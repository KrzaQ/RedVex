#pragma once
#include <queue>
#include "PacketMarshal.h"

class GameServerPacketMarshal :
	public PacketMarshal
{
public:
	GameServerPacketMarshal();
	~GameServerPacketMarshal();

	int Serialize(const IPacket* packet, void* buffer, int size);
	IPacket* Deserialize();

private:
	static const int PacketSizes[];
	static const int WorkBufferSize = 0x6000;
		
	void EnqueuePackets(const void* data, int size);
	static int GetDecompressedPacketSize(const void* data, int size);
	static int GetChatPacketSize(const void* data, int size);

	std::queue<IPacket*> _packets;
	bool _magic;
};
