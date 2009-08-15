#include "TcpProxy.h"
#include <assert.h>
#include "PacketMarshal.h"
#include "Packet.h"
#include "Globals.h"
#include "IProxyPool.h"

TcpProxy::TcpProxy() :
	_state(ProxyState_Invalid),
	_buffer(new unsigned char[InitialBufferSize]),
	_size(InitialBufferSize),
	_client(0),
	_serverPort(0),
	_owner(0)
{
}

TcpProxy::~TcpProxy()
{
	// break any remaining network connections
	Disconnect();

	// deallocate and clear any loaded modules
	ClearModules();

	// deallocate the read/write buffer
	delete[] _buffer;
}

void TcpProxy::Delete()
{
	delete this;
}

void TcpProxy::ConnectClient(TcpSocket* client)
{
	Setup();

	_client = client;

	SetState(ProxyState_FindServer);
}

void TcpProxy::Setup()
{
	_clientPacketMarshal = CreateClientPacketMarshal();
	_serverPacketMarshal = CreateServerPacketMarshal();

	strcpy_s(_serverName, "");
	AddModule(this);
}

void TcpProxy::Update()
{
	// update the loaded modules regardless of the proxy's current state; 
	// however take care not to update the proxy module because that 
	// would cause the proxy to update itself (and overflow the stack)
	for (std::list<IModule*>::iterator i = _modules.begin(); i != _modules.end(); i++)
	{
		IModule* module = *i;
		if (module != this)
		{
			module->Update();
		}
	}

	switch (GetState())
	{
	case ProxyState_FindServer:
		UpdateStateFindServer();
		break;

	case ProxyState_ConnectingStart:
		UpdateStateConnectingStart();
		break;

	case ProxyState_ConnectingWait:
		UpdateStateConnectingWait();
		break;

	case ProxyState_Connected:
		UpdateStateConnected();
		break;
	}
}

void TcpProxy::UpdateStateConnectingStart()
{
	if (_server.Connect(_serverName, _serverPort) || TcpSocket::GetLastError() == WSAEWOULDBLOCK)
	{
		// connection was either sucessfully established or the connect call is not yet completed
		SetState(ProxyState_ConnectingWait);
	}

	else
	{
		// unable to establish connection, set error state
		SetState(ProxyState_ConnectError);
	}
}

void TcpProxy::UpdateStateConnectingWait()
{
	assert(_server.IsValid());

	// determine if the connection operation was completed and/or successful
	TcpSocket::EventState serverState;
	_server.QueryEventState(FD_CONNECT, &serverState);	

	if (serverState.set)
	{
		if (serverState.error == 0)
		{
			// turn off delay on the server side
			_server.DisableDelay();

			// proxy is now connected to the server
			SetState(ProxyState_Connected);
		}

		else
		{
			// proxy was unable to connect to the server
			SetState(ProxyState_ConnectError);
		}
	}
}

void TcpProxy::UpdateStateFindServer()
{
	assert(_client->IsValid());
	assert(_clientPacketMarshal != 0);

	IPacket* packet;
	int size;

	if ((size = _client->GetPendingReadLength()) > 0)
	{
		// resize the read buffer to make that the entire read buffer 
		// can be retrieved in one receive operation
		ResizeBuffer(size);

		// receive incoming data from the server and append it 
		// to the appropriate packet marshal for processing
		_client->Receive(_buffer, size);
		_clientPacketMarshal->AppendData(_buffer, size);
	}

	// check to see if any packets can be deserialized yet
	while ((packet = _clientPacketMarshal->Deserialize()) != 0)
	{
		// enough data was received for an entire packet
		OnRelayDataToServer(packet, this);
		delete packet;

		if(_client == 0)
			return;
	}

	// determine if the client connection has been closed
	TcpSocket::EventState clientState;
	_client->QueryEventState(FD_CLOSE, &clientState);

	// if either the client or the server connection was closed then close 
	// any remaining connections and switch to a disconnected state
	if (clientState.set)
	{
		Disconnect();
	}
}

void TcpProxy::UpdateStateConnected()
{
	assert(_client->IsValid() && _server.IsValid());
	assert(_clientPacketMarshal != 0 && _serverPacketMarshal != 0);

	IPacket* packet;
	int size;

	if ((size = _client->GetPendingReadLength()) > 0)
	{
		// resize the read buffer to make that the entire read buffer 
		// can be retrieved in one receive operation
		ResizeBuffer(size);

		// receive incoming data from the server and append it 
		// to the appropriate packet marshal for processing
		_client->Receive(_buffer, size);
		_clientPacketMarshal->AppendData(_buffer, size);
	}

	// check to see if any packets can be deserialized yet
	while ((packet = _clientPacketMarshal->Deserialize()) != 0)
	{
		// enough data was received for an entire packet
		RelayDataToServer(packet, this);
		delete packet;

		if(_client == 0)
			return;
	}

	if ((size = _server.GetPendingReadLength()) > 0)
	{
		// resize the read buffer to make that the entire read buffer 
		// can be retrieved in one receive operation
		ResizeBuffer(size);
		
		// receive incoming data from the server and append it 
		// to the appropriate packet marshal for processing
		_server.Receive(_buffer, size);
		_serverPacketMarshal->AppendData(_buffer, size);
	}

	// check to see if any packets can be deserialized yet
	while ((packet = _serverPacketMarshal->Deserialize()) != 0)
	{
		// enough data was received for an entire packet
		RelayDataToClient(packet, this);
		delete packet;

		if(_client == 0)
			return;
	}

	// determine if the client connection has been closed
	TcpSocket::EventState clientState;
	_client->QueryEventState(FD_CLOSE, &clientState);

	// determine if the server connection has been closed
	TcpSocket::EventState serverState;
	_server.QueryEventState(FD_CLOSE, &serverState);

	// if either the client or the server connection was closed then close 
	// any remaining connections and switch to a disconnected state
	if (clientState.set || serverState.set)
	{
		Disconnect();
	}
}

void TcpProxy::ConnectServer(TcpProxy* owner, const char* serverName, int serverPort)
{
	_owner = owner;

	// store off local copies of the connection parameters
	strcpy_s(_serverName, sizeof(_serverName), serverName);
	_serverPort = serverPort;

	// the proxy is now connecting to the server
	SetState(ProxyState_ConnectingStart);
}

void TcpProxy::Connect(const char* serverName, int serverPort, TcpSocket* client)
{
	Setup();

	_client = client;

	// store off local copies of the connection parameters
	strcpy_s(_serverName, sizeof(_serverName), serverName);
	_serverPort = serverPort;

	// turn off delay on the client side
	_client->DisableDelay();

	// the proxy is now connecting to the server
	SetState(ProxyState_ConnectingStart);
}

void TcpProxy::Disconnect()
{
	// break any existing connections
	if(_client != 0)
	{
		_client->Close();
		delete _client;
	}

	_client = 0;

	_server.Close();

	// packet marshals are no longer needed
	if (_clientPacketMarshal != 0)
	{
		delete _clientPacketMarshal;
		_clientPacketMarshal = 0;
	}

	if (_serverPacketMarshal != 0)
	{
		delete _serverPacketMarshal;
		_serverPacketMarshal = 0;
	}

	// proxy is now disconnected
	SetState(ProxyState_Disconnected);
}

TcpProxy::ProxyState TcpProxy::GetState() const
{
	return _state;
}

int TcpProxy::GetClientSocket()
{
	return static_cast<int>(_client->GetDescriptor());
}

int TcpProxy::GetServerSocket()
{
	return static_cast<int>(_server.GetDescriptor());
}

IProxy* TcpProxy::GetPeer()
{
	return _owner;
}

void TcpProxy::OnRelayDataToServer(IPacket* packet, const IModule* owner)
{
	if(GetState() == ProxyState_FindServer) 
		return;

	assert(GetState() == ProxyState_Connected);
	assert(_clientPacketMarshal != 0);
	assert(packet != 0);

	int size;

	// serialize the incoming packet; if for some unexpected reason there is not
	// enough room for this operation (this should never happen) keep doubling
	// the work buffer until the operation can be completed
	while ((size = _clientPacketMarshal->Serialize(packet, _buffer, _size)) < 0)
	{
		_size *= 2;
		ResizeBuffer(_size);
	}

	// send the raw packet data to the server
	_server.Send(_buffer, size);
}

void TcpProxy::OnRelayDataToClient(IPacket* packet, const IModule* owner)
{
	assert(_serverPacketMarshal != 0);
	assert(packet != 0);

	int size;

	// serialize the incoming packet; if for some unexpected reason there is not
	// enough room for this operation (this should never happen) keep doubling
	// the work buffer until the operation can be completed
	while ((size = _serverPacketMarshal->Serialize(packet, _buffer, _size)) < 0)
	{
		_size *= 2;
		ResizeBuffer(_size);
	}

	// send the raw packet data to the client
	_client->Send(_buffer, size);
}

void TcpProxy::OnStateChange(ProxyState previous, ProxyState current)
{
	switch (current)
	{
	case ProxyState_Disconnected:
		if (previous == ProxyState_Connected)
		{
			Log.Write("Disconnected from %s:%d at %X\n\n", GetServerName(), GetServerPort(), this);
		}
		break;

	case ProxyState_ConnectingStart:
		Log.Write("Connecting to %s:%d at %X...\n\n", GetServerName(), GetServerPort(), this);
		break;

	case ProxyState_Connected:
		Log.Write("Connected to %s:%d at %X\n\n", GetServerName(), GetServerPort(), this);
		break;

	case ProxyState_ConnectError:
		Log.Write("Error: Unable to connect to %s:%d at %X\n\n", GetServerName(), GetServerPort(), this);
		break;
	}
}

const char* TcpProxy::GetServerName() const
{
	return _serverName;
}

int TcpProxy::GetServerPort() const
{
	return _serverPort;
}

TcpProxy* TcpProxy::GetOwner()
{
	return _owner;
}

void TcpProxy::RelayDataToServer(const IPacket* packet, const IModule* owner)
{
	if (packet != 0 && GetState() == ProxyState_Connected)
	{
		// use a packet clone throughout the plugin chain so that the owner 
		// of this method doesn't get their copy of the packet messed up
		IPacket* clone = packet->Clone();

		// let each loaded plugin process the packet; if anyone sets the
		// packet dead flag then bail without doing further processing,
		// thereby blocking the packet from transmission
		for (std::list<IModule*>::iterator i = _modules.begin(); 
			i != _modules.end() && !clone->IsFlagSet(IPacket::PacketFlag_Dead); i++)
		{
			IModule* module = *i;

			if ((!clone->IsFlagSet(IPacket::PacketFlag_Hidden) || module == this) &&
				(!clone->IsFlagSet(IPacket::PacketFlag_Virtual) || module != this))
			{
				// hidden packets avoid traversing the plugin chain, and virtual
				// packets traverse the plugin chain without ever being sent 
				// over the network (useful for inter-plugin communication)
				module->OnRelayDataToServer(clone, owner);
			}
		}

		// get rid of the packet clone, it has already passed through the
		// plugin chain and is no longer necessary
		delete clone;
	}
}

void TcpProxy::RelayDataToClient(const IPacket* packet, const IModule* owner)
{
	if (packet != 0 && GetState() == ProxyState_Connected)
	{
		// use a packet clone throughout the plugin chain so that the owner 
		// of this method doesn't get their copy of the packet messed up
		IPacket* clone = packet->Clone();

		// let each loaded plugin process the packet; if anyone sets the
		// packet dead flag then bail without doing further processing,
		// thereby blocking the packet from transmission
		for (std::list<IModule*>::iterator i = _modules.begin(); i != _modules.end() && !clone->IsFlagSet(IPacket::PacketFlag_Dead); i++)
		{
			IModule* module = *i;

			if ((!clone->IsFlagSet(IPacket::PacketFlag_Hidden) || module == this) &&
				(!clone->IsFlagSet(IPacket::PacketFlag_Virtual) || module != this))
			{
				// hidden packets avoid traversing the plugin chain, and virtual
				// packets traverse the plugin chain without ever being sent 
				// over the network (useful for inter-plugin communication)
				module->OnRelayDataToClient(clone, owner);
			}
		}

		// get rid of the packet clone, it has already passed through the
		// plugin chain and is no longer necessary
		delete clone;
	}
}

IPacket* TcpProxy::CreatePacket(const void* data, int size) const
{
	return new Packet(data, size);
}

void TcpProxy::AddModule(IModule* module)
{
	_modules.push_front(module);
}

void TcpProxy::ClearModules()
{
	for (std::list<IModule*>::iterator i = _modules.begin(); i != _modules.end(); i++)
	{
		IModule* module = *i;
		if (module != this)
			module->Delete();
	}
	_modules.clear();
}

void TcpProxy::ResizeBuffer(int size)
{
	if (size > _size)
	{
		delete[] _buffer;
		_buffer = new unsigned char[size];
		_size = size;
	}
}

void TcpProxy::SetState(ProxyState state)
{
	ProxyState old = _state;
	_state = state;
	OnStateChange(old, state);
}
