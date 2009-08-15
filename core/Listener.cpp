#include "Listener.h"
#include "TcpProxy.h"
#include <assert.h>
#include "Globals.h"

Listener::Listener() :
	_state(ListenerState_Disconnected),
	_port(0)
{
}

Listener::~Listener()
{
	// break any remaining network connections
	Disconnect();
}

void Listener::Update()
{
	switch (GetState())
	{
		case ListenerState_Accepting:
			UpdateStateAccepting();
			break;
	}
}

void Listener::UpdateStateAccepting()
{
	assert(_host.IsValid());

	TcpSocket* client = new TcpSocket();

	// accept incoming connection from the client
	_host.Accept(client);

	if (client->IsValid())
	{
		// turn off delay on the client side
		client->DisableDelay();

		Log.Write("New connection on port %d", _port); 
		
		OnConnection(client);
	}
	else
	{
		delete client;

		if (TcpSocket::GetLastError() != WSAEWOULDBLOCK)
		{
			// invalid connection accepted, set error state
			SetState(ListenerState_AcceptError);

			// create a new connection 
			Connect(_port);
		}
	}
}

void Listener::Connect(int Port)
{
	// break any existing connections
	Disconnect();

	_port = Port;

	// bind and begin listening on the proxy port
	if (!_host.Bind(Port))
	{
		SetState(ListenerState_BindError);
	}
	else if (!_host.Listen(0))
	{
		SetState(ListenerState_ListenError);
	}
	else
	{
		SetState(ListenerState_Accepting);
	}
}

void Listener::Disconnect()
{
	// break any existing connections
	_host.Close();

	// proxy is now disconnected
	SetState(ListenerState_Disconnected);
}

Listener::ListenerState Listener::GetState() const
{
	return _state;
}

int Listener::GetPort() const
{
	return _port;
}

void Listener::OnStateChange(ListenerState previous, ListenerState current)
{
	switch (current)
	{
		case ListenerState_Accepting:
			Log.Write("Accepting connections on port %d...\n\n", GetPort());
			break;

		case ListenerState_AcceptError:
			Log.Write("Error: Unable to accept on port %d\n\n", GetPort());
			break;

		case ListenerState_BindError:
			Log.Write("Error: Unable to bind on port %d\n\n", GetPort());
			break;

		case ListenerState_ListenError:
			Log.Write("Error: Unable to listen on port %d\n\n", GetPort());
			break;
	}
}

void Listener::SetState(ListenerState state)
{
	OnStateChange(_state, state);
	_state = state;
}
