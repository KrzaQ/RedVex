#pragma comment(lib, "WS2_32.lib")
#include "TcpSocket.h"

int TcpSocket::_wsaReferenceCount = 0;
WSAData TcpSocket::_wsaData;

TcpSocket::TcpSocket(SOCKET socket) :
	_socket(socket),
	_event(0)
{
	if (_wsaReferenceCount++ == 0)
	{
		// the first instance of a socket has been created, sockets need to be initialized
		Startup(WinSockMajorVersion, WinSockMinorVersion);
	}

	if (_socket != INVALID_SOCKET)
	{
		// a valid socket socket was passed in, create an event and bind desired conditions to it
		_event = WSACreateEvent();
		
		if (_event == 0 || WSAEventSelect(_socket, _event, MonitoredEvents) != 0)
		{
			// there is some sort of error with the socket or the event associated with it, close everything
			Close();
		}
	}
}

TcpSocket::TcpSocket(const TcpSocket& other) :
	_socket(other._socket),
	_event(other._event)
{
	_wsaReferenceCount++;
}

TcpSocket::~TcpSocket()
{
	if (--_wsaReferenceCount == 0)
	{
		// the last instance of a socket has been deleted, winsock needs to be shut down
		Cleanup();
	}
}

bool TcpSocket::Connect(const char* name, short port)
{
	long address;

	if (Resolve(name, &address) && Create())
	{
		sockaddr_in host;
		host.sin_port = htons(port);
		host.sin_family = Family;
		host.sin_addr.s_addr = address;

		return connect(_socket, reinterpret_cast<const sockaddr*>(&host), sizeof(host)) == 0;
	}

	return false;
}

bool TcpSocket::Connect(long address, short port, bool translated)
{
	if (Create())
	{	
		sockaddr_in host;
		host.sin_port = htons(port);
		host.sin_family = Family;
		host.sin_addr.s_addr = translated ? address : htonl(address);

		return connect(_socket, reinterpret_cast<const sockaddr*>(&host), sizeof(host)) == 0;
	}

	return false;
}

bool TcpSocket::Bind(short port)
{
	if (Create())
	{
		sockaddr_in address;
		address.sin_family = Family;
		address.sin_port = htons(port);
		address.sin_addr.s_addr = htonl(INADDR_ANY);

		return bind(_socket, reinterpret_cast<const sockaddr*>(&address), sizeof(address)) == 0;
	}

	return false;
}

bool TcpSocket::Listen(int backlog)
{
	if (IsValid())
	{	
		return listen(_socket, backlog) == 0;
	}

	return false;
}

bool TcpSocket::Accept(TcpSocket* other)
{
	if (IsValid())
	{
		*other = TcpSocket(accept(_socket, 0, 0));
		return true;
	}

	return false;
}

int TcpSocket::GetPendingReadLength() const
{
	int size;

	if (!IsValid() || ioctlsocket(_socket, FIONREAD, reinterpret_cast<u_long*>(&size)) == SOCKET_ERROR)
	{
		return -1;
	}

	return size;
}

int TcpSocket::Receive(void* buffer, int size)
{
	if (IsValid())
	{
		return recv(_socket, static_cast<char*>(buffer), size, 0);
	}

	return -1;
}

int TcpSocket::Send(const void* buffer, int size)
{
	if (IsValid())
	{
		return send(_socket, static_cast<const char*>(buffer), size, 0);
	}

	return -1;
}

bool TcpSocket::EnableDelay()
{
	if (IsValid())
	{
		int data = 0;
		return setsockopt(GetDescriptor(), IPPROTO_TCP, TCP_NODELAY, reinterpret_cast<const char*>(&data), sizeof(data)) == 0;
	}

	return false;
}

bool TcpSocket::DisableDelay()
{
	if (IsValid())
	{
		int data = 1;
		return setsockopt(GetDescriptor(), IPPROTO_TCP, TCP_NODELAY, reinterpret_cast<const char*>(&data), sizeof(data)) == 0;
	}

	return false;
}

bool TcpSocket::Create() 
{
	// close the existing event and socket if they have already been created
	// so as to not leak any networking resources when the new socket is created
	if (IsValid())
	{
		Close();
	}

	if ((_socket = socket(Family, Type, Protocol)) == INVALID_SOCKET ||
		(_event = WSACreateEvent()) == 0 ||	(WSAEventSelect(_socket, _event, MonitoredEvents)) != 0)
	{
		// socket and/or event creation has failed; close free whatever
		// resources were allocated and bail out because this socket
		// is unusable in the current state
		Close();
		return false;
	}

	return true;
}

void TcpSocket::Close()
{
	if (_socket != INVALID_SOCKET)
	{
		// current socket is valid, close and invalidate it
		closesocket(_socket);
		_socket = INVALID_SOCKET;
	}

	if (_event != 0)
	{
		// current event is valid, close and invalidate it
		WSACloseEvent(_event);
		_event = 0;
	}
}

bool TcpSocket::QueryEventState(int eventId, EventState* state) const
{
	// set default event state values
	state->error = 0;
	state->set = false;

	// bail out if the socket is not valid (can't check events)
	if (!IsValid())
	{
		return false;
	}

	WSANETWORKEVENTS events;
	
	// determine which events are set for this socket; bail if operation fails
	if (WSAEnumNetworkEvents(_socket, _event, &events) != 0)
	{
		return false;
	}

	// store off whether or not the given even is set; return out immediately
	// if the event is not set (because there aren't any error codes for it)
	if (state->set = ((events.lNetworkEvents & eventId) != 0))
	{
		return true;
	}

	// find and store off the applicable error code for this eventId if one exists
	for (int i = 0, flag = 1; i < FD_MAX_EVENTS; i++, flag <<= 1)
	{
		if ((flag & eventId) == eventId)
		{
			state->error = events.iErrorCode[i];
			break;
		}
	}

	return true;
}

SOCKET TcpSocket::GetDescriptor()
{
	return _socket;
}

bool TcpSocket::IsReadable(int timeout) const
{
	if (!IsValid())
	{
		return false;
	}

	fd_set rs;
	FD_ZERO(&rs);
	FD_SET(_socket, &rs);
	
	timeval delay;
	delay.tv_sec = 0;
	delay.tv_usec = timeout * 1000;

	return select(0, &rs, 0, 0, &delay) > 0;
}

bool TcpSocket::IsWriteable(int timeout) const
{
	if (!IsValid())
	{
		return false;
	}

	fd_set ws;
	FD_ZERO(&ws);
	FD_SET(_socket, &ws);

	timeval delay;
	delay.tv_sec = 0;
	delay.tv_usec = timeout * 1000;

	return select(0, 0, &ws, 0, &delay) > 0;
}

bool TcpSocket::IsValid() const
{
	return _socket != INVALID_SOCKET && _event != 0;
}

int TcpSocket::GetLastError()
{
	return WSAGetLastError();
}

bool TcpSocket::Resolve(const char* name, long* address)
{
	// attempt to parse the host name as an ip string
	*address = inet_addr(name);

	if (*address == INADDR_NONE)
	{
		// host name is not an ip string, attempt to resolve it
		hostent* host = gethostbyname(name);

		if (host == 0)
		{
			// host name cannot be resolved
			*address = 0;
			return false;
		}

		// store off the first address associated with this name
		*address = *reinterpret_cast<long*>(host->h_addr_list[0]);
	}

	return true;
}

bool TcpSocket::Startup(int majorVersion, int minorVersion)
{
	return WSAStartup(MAKEWORD(majorVersion, minorVersion), &_wsaData) == 0;
}

bool TcpSocket::Cleanup()
{
	return WSACleanup() != SOCKET_ERROR;
}
