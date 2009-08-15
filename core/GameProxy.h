#pragma once
#include "TcpProxy.h"

class PluginManager;

class GameProxy :
	public TcpProxy
{
public:
	
	GameProxy();

	void __stdcall OnRelayDataToClient(IPacket* packet, const IModule* owner);
	void __stdcall OnRelayDataToServer(IPacket* packet, const IModule* owner);

protected:
	void OnStateChange(ProxyState previous, ProxyState current);

	PacketMarshal* CreateServerPacketMarshal();
	PacketMarshal* CreateClientPacketMarshal();

private:
	bool _processedPackets;
	std::list<IPacket*> _packets;
};
