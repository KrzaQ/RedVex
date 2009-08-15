#pragma once
#include "PacketMarshal.h"

class GameClientPacketMarshal :
	public PacketMarshal
{
public:
	IPacket* Deserialize();

private:
	static const int PacketSizes[];

	bool GetCurrentPacketSize(int* size, bool* ready) const;
	bool GetBubblePacketSize(int* size, bool* ready) const;
	bool GetChatPacketSize(int* size, bool* ready) const;
	bool GetWardenPacketSize(int* size, bool* ready) const;
};
