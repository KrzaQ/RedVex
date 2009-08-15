#include "ChatListener.h"
#include "ChatProxy.h"
#include "Globals.h"
#include "ProxyThread.h"
#include "PluginManager.h"
#include "ProxyThread.h"

ChatListener::ChatListener() : Listener()
{
}

void ChatListener::OnConnection(TcpSocket* client)
{
	ChatProxy* proxy = new ChatProxy();

	proxy->Connect(Thread->ServerName.c_str(), Thread->ChatServerPort, client);

	Thread->AddProxy(proxy);
}
