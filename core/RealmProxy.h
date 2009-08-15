#pragma once
#include "TcpProxy.h"

class PluginManager;

class RealmProxy :
	public TcpProxy
{
public:
	RealmProxy();
	~RealmProxy();
	void __stdcall OnRelayDataToClient(IPacket* packet, const IModule* owner);
	void __stdcall OnRelayDataToServer(IPacket* packet, const IModule* owner);

protected:
	void OnStateChange(ProxyState previous, ProxyState current);
	PacketMarshal* CreateServerPacketMarshal();
	PacketMarshal* CreateClientPacketMarshal();

private:
	std::list<IPacket*> _packets;
};
