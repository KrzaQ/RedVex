#pragma once
#include "TcpProxy.h"
#include "ChatPacketMarshal.h"
#include "HashData.h"

class PluginManager;

class ChatProxy : 
	public TcpProxy
{
public:
	ChatProxy();
	~ChatProxy();

	void __stdcall OnRelayDataToClient(IPacket* packet, const IModule* owner);
	void __stdcall Update();

	HashData RealmHash;
	HashData GameHash;

	char RealmName[256];
	int RealmPort;

	char GameName[256];

protected:
	PacketMarshal* CreateClientPacketMarshal();
	PacketMarshal* CreateServerPacketMarshal();
	
private:
	ChatPacketMarshal::MarshalType _type;

	bool _pluginsProcessed;
};
