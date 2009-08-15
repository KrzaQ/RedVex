#include "RealmCreator.h"
#include "RealmPacketMarshal.h"
#include "Globals.h"
#include "IPacket.h"

RealmCreator::RealmCreator(TcpSocket* client, int clientPort) :
	ProxyCreator(client, clientPort)
{
}

RealmCreator::~RealmCreator()
{
}

void RealmCreator::RelayDataToClient(IPacket* packet)
{
}

void RealmCreator::RelayDataToServer(const IPacket* packet)
{
	Log.Write("Realm: Packet recived!\n");
	Log.Dump(packet->GetData(), packet->GetSize());
	Log.Write("\n");
}

PacketMarshal* RealmCreator::CreateServerPacketMarshal()
{
	return new RealmPacketMarshal(false);
}

PacketMarshal* RealmCreator::CreateClientPacketMarshal()
{
	return new RealmPacketMarshal(true);
}