#include "Listener.h"

class RealmListener:
	public Listener
{
public:
	RealmListener();

	void OnConnection(TcpSocket* client);
};