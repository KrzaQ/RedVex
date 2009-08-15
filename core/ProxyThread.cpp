#include <queue>
#include "ChatProxy.h"
#include "ProxyThread.h"
#include "PluginManager.h"
#include "ChatListener.h"
#include "GameListener.h"
#include "RealmListener.h"
#include "Plugin.h"
#include "Globals.h"

ProxyThread* Thread = 0;

ProxyThread::ProxyThread(const char* localName, const char* serverName)
{
	ServerName = serverName;
	LocalName = localName;
}

int ProxyThread::Routine()
{
	Log.Write("Proxy thread started\n\n");

	GameListener gameListener;
	gameListener.Connect(GameClientPort);

	RealmListener realmListener;
	realmListener.Connect(RealmClientPort);

	ChatListener chatListener;
	chatListener.Connect(ChatClientPort);

	while (!IsAborting())
	{
		chatListener.Update();
		realmListener.Update();
		gameListener.Update();

		// Update proxies

		std::queue<TcpProxy*> deadProxies;

		for (std::list<TcpProxy*>::iterator i = Proxies.begin(); i != Proxies.end(); i++)
		{
			TcpProxy* proxy = *i;

			switch (proxy->GetState())
			{
				case TcpProxy::ProxyState_Disconnected:
				case TcpProxy::ProxyState_ConnectError:
					deadProxies.push(proxy);
					break;
			}

			proxy->Update();
		}

		while (!deadProxies.empty())
		{
			RemoveProxy(deadProxies.front());
			deadProxies.pop();
		}

		Sleep(1);
	}

	ClearProxies();

	Log.Write("Proxy thread stopped\n\n");

	return 0;
}

void ProxyThread::AddProxy(TcpProxy* proxy)
{
	Proxies.push_back(proxy);
}

void ProxyThread::RemoveProxy(TcpProxy* proxy)
{
	if (proxy != 0)
	{
		Proxies.remove(proxy);
		delete proxy;
	}
}

void ProxyThread::ClearProxies()
{
	for (std::list<TcpProxy*>::iterator i = Proxies.begin(); i != Proxies.end(); i++)
	{
		TcpProxy* proxy = *i;
		delete proxy;
	}
	Proxies.clear();
}