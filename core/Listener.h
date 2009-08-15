#pragma once
#include <queue>
#include "TcpSocket.h"

class Listener
{
public:
	enum ListenerState
	{
		ListenerState_Disconnected,
		ListenerState_Accepting,
		ListenerState_AcceptError,
		ListenerState_BindError,
		ListenerState_ListenError,
	};

	Listener();
	virtual ~Listener();

	virtual void Connect(int Port);
	void Disconnect();

	ListenerState GetState() const;

	void Update();

protected:
	int GetPort() const;

	virtual void OnConnection(TcpSocket* client) = 0;

	virtual void OnStateChange(ListenerState previous, ListenerState current);

private:
	void UpdateStateAccepting();
	void SetState(ListenerState state);

	TcpSocket _host;

	int _port;

	ListenerState _state;
};