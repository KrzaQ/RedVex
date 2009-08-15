#pragma once
#include "ProxyCreator.h"

class RealmCreator:
	public ProxyCreator
{
public:
	RealmCreator(TcpSocket* client, int clientPort);
	virtual ~RealmCreator();

	void RelayDataToClient(IPacket* packet);
	void RelayDataToServer(const IPacket* packet);

protected:
	PacketMarshal* CreateClientPacketMarshal();
	PacketMarshal* CreateServerPacketMarshal();
};
