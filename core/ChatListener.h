#include "Listener.h"

class ChatListener:
	public Listener
{
public:
	ChatListener();

	void OnConnection(TcpSocket* client);
};