#include "Listener.h"

class GameListener:
	public Listener
{
public:
	GameListener();

	void OnConnection(TcpSocket* client);
private:
};