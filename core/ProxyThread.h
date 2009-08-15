#pragma once
#include <list>
#include <string>
#include "Thread.h"
#include "IProxyPool.h"
#include "ProxyCreator.h"

class PluginManager;

class ProxyThread :
	public Thread,
	public IProxyPool
{
public:
	ProxyThread(const char* localName, const char* serverName);

	// IProxyPool
	void AddProxy(TcpProxy* proxy);
	void RemoveProxy(TcpProxy* proxy);
	void ClearProxies();
	//TcpProxy* FindPeerProxy(const TcpProxy* peer);

	int RealmClientPort;
	int GameClientPort;
	int ChatClientPort;

	int RealmServerPort;
	int GameServerPort;
	int ChatServerPort;

	std::string ServerName;
	std::string LocalName;

	std::list<TcpProxy*> Proxies;

protected:
	int Routine();

private:

	const PluginManager* _plugins;
};

extern ProxyThread* Thread;
