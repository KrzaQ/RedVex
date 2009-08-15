#include "RealmListener.h"
#include "RealmProxy.h"
#include "Globals.h"
#include "ProxyThread.h"
#include "PluginManager.h"

RealmListener::RealmListener() : Listener()
{
}

void RealmListener::OnConnection(TcpSocket* client)
{
	RealmProxy* proxy = new RealmProxy();

	proxy->ConnectClient(client);

	Thread->AddProxy(proxy);
}
