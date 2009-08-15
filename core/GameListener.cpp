#include "GameListener.h"
#include "GameProxy.h"
#include "Globals.h"
#include "PluginManager.h"
#include "ProxyThread.h"

GameListener::GameListener() : Listener()
{
}

void GameListener::OnConnection(TcpSocket* client)
{
	GameProxy* proxy = new GameProxy();

	proxy->ConnectClient(client);

	Thread->AddProxy(proxy);
}
