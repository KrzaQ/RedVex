#pragma once
#include <Winsock2.h>

class TcpSocket
{
public:
	struct EventState
	{
		int error;
		bool set;
	};

	TcpSocket(SOCKET socket = INVALID_SOCKET);
	TcpSocket(const TcpSocket& other);
	virtual ~TcpSocket();

	bool Connect(const char* name, short port);
	bool Connect(long address, short port, bool translated);
	bool Bind(short port);
	bool Listen(int backlog = SOMAXCONN);
	bool Accept(TcpSocket* other);
	int GetPendingReadLength() const;
	int Receive(void* buffer, int size);
	int Send(const void* buffer, int size);
	bool EnableDelay();
	bool DisableDelay();
	void Close();

	bool QueryEventState(int eventId, EventState* state) const;
	SOCKET GetDescriptor();
	bool IsReadable(int timeout) const;
	bool IsWriteable(int timeout) const;
	bool IsValid() const;

	static bool Resolve(const char* name, long* address); 

	static int GetLastError();

private:
	static const int MonitoredEvents = FD_READ | FD_WRITE | FD_CLOSE | FD_CONNECT | FD_ACCEPT;
	static const int WinSockMajorVersion = 2;
	static const int WinSockMinorVersion = 2;
	static const int Family = AF_INET;
	static const int Type = SOCK_STREAM;
	static const int Protocol = 0;

	bool Create();
	static bool Startup(int majorVersion, int minorVersion);
	static bool Cleanup();

	static int _wsaReferenceCount;
	static WSAData _wsaData;

	WSAEVENT _event;
	SOCKET _socket;
};
