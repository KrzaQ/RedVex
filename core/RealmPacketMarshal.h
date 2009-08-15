#pragma once
#include "PacketMarshal.h"

class RealmPacketMarshal :
	public PacketMarshal
{
public:
	RealmPacketMarshal(bool useMagicByte);

	IPacket* Deserialize();

private:
	bool _magic;
};
