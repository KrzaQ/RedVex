#include "GameClientPacketMarshal.h"
#include "Packet.h"
#include "Globals.h"

const int GameClientPacketMarshal::PacketSizes[] =
{
	-1,	5,	9,	5,	9,	5,	9,	9,	5,	9,	9,	1,	5,	9,	9,	5,	
	9,	9,	1,	9,	-1,	-1,	13,	5,	17,	5,	9,	9,	3,	9,	9,	17, 
	13,	9,	5,	9,	5,	9,	13,	9,	9,	9,	9,	-1,	-1,	1,	3,	9, 
	9,	9,	17,	17,	5,	17,	9,	5,	13,	5,	3,	3,	9,	5,	5,	3, 
	1,	1,	1,	1,	17,	9,	13,	13,	1,	9,	-1,	9,	5,	3,	-1,	7,
	9,	9,	5,	1,	1,	-1,	-1,	-1,	3,	17,	-1,	-1,	-1,	7,	6,	5,
	1,	3,	5,	5,	9,	17,	-1,	-1,	37,	1,	1,	1,	1,	13,	-1, 1
};

IPacket* GameClientPacketMarshal::Deserialize()
{
	IPacket* packet = 0;

	if (GetSize() > 0)
	{
		bool packetReady;
		int packetSize;

		if (!GetCurrentPacketSize(&packetSize, &packetReady))
		{
			// packet could not be deserialized because of a problem with the packet parser;
			// send what we have any way in an attempt to keep the application from disconnecting
			Log.Write("Error: Unexpected client packetId encountered: 0x%.2x\n", *reinterpret_cast<const unsigned char*>(GetData()));
			Log.Dump(GetData(), GetSize());
			Log.Write("\n");

			packet = PacketMarshal::Deserialize();
			if (packet != 0)
			{
				packet->SetFlag(IPacket::PacketFlag_Hidden);
			}
		}

		else if (packetReady && packetSize <= GetSize())
		{
			packet = new Packet(GetData(), packetSize);
			RemoveData(packet->GetSize());
		}
	}

	return packet;
}

bool GameClientPacketMarshal::GetCurrentPacketSize(int* size, bool* ready) const
{
	if (GetSize() <= 0)
	{
		// no packet data has been read in at all; this obviously means that 
		// it is impossible to determine the length of this packet
		*size = -1;
		*ready = false;
		return false;
	}

	// first byte of the packet contains the packetId
	int packetId = *static_cast<const unsigned char*>(GetData());
	if (packetId > sizeof(PacketSizes) / sizeof(int))
	{
		// packetId is greater than the size of the packetId table;
		// this means that this packet is probably invalid
		*size = -1;
		*ready = false;
		return false;
	}

	// get the size of the packet out of the packet size table via packetId
	int packetSize = PacketSizes[packetId];
	if (packetSize >= 0)
	{
		// packetSize is valid; this means that the size of this
		// packet is fixed and doesn't need interpretation
		*size = packetSize;
		*ready = true;
		return true;
	}

	// packetSize is invalid; this means that the packet has a variable
	// size so the contents must be interpreted
	switch (packetId)
	{
	case 0x14:
		return GetBubblePacketSize(size, ready);

	case 0x15:
		return GetChatPacketSize(size, ready);

	case 0x66:
		return GetWardenPacketSize(size, ready);
	}

	// don't know how to interpret this packet, perhaps it was never seen before
	*size = -1;
	*ready = false;
	return false;
}

bool GameClientPacketMarshal::GetBubblePacketSize(int* size, bool* ready) const
{
	int chatOffset = 3;

	if (GetSize() < chatOffset)
	{
		// not enough data has been received to be able to get the beginning
		// of the player's chat string; impossible to determine packet size
		*size = -1;
		*ready = false;
		return true;
	}

	const unsigned char* bytes = static_cast<const unsigned char*>(GetData());
	
	bool chatTerminated = false;
	int chatLength = 0;

	// iterate through the packet data in order to try to find the 
	// zero terminator for the player's chat string
	for (int i = chatOffset; i < GetSize() && !chatTerminated; i++)
	{
		if (bytes[i] == 0x00)
		{
			chatTerminated = true;
		}

		else
		{
			chatLength++;
		}
	}

	if (!chatTerminated)
	{
		// the character's chat string has not been zero terminated; 
		// there is not enough data to determine packet size
		*size = -1;
		*ready = false;
		return true;
	}

	// calculate the size of the packet
	*size = chatOffset + chatLength + 1 + 2;
	*ready = true;
	return true;
}

bool GameClientPacketMarshal::GetChatPacketSize(int* size, bool* ready) const
{
	int chatOffset = 3;

	if (GetSize() < chatOffset)
	{
		// not enough data has been received to be able to get the beginning
		// of the player's chat string; impossible to determine packet size
		*size = -1;
		*ready = false;
		return true;
	}

	const unsigned char* bytes = static_cast<const unsigned char*>(GetData());
	
	bool chatTerminated = false;
	int chatLength = 0;

	// iterate through the packet data in order to try to find the 
	// zero terminator for the player's chat string
	for (int i = chatOffset; i < GetSize() && !chatTerminated; i++)
	{
		if (bytes[i] == 0x00)
		{
			chatTerminated = true;
		}

		else
		{
			chatLength++;
		}
	}

	if (!chatTerminated)
	{
		// the character's chat string has not been zero terminated; 
		// there is not enough data to determine packet size
		*size = -1;
		*ready = false;
		return true;
	}

	int playerOffset = chatOffset + chatLength + 1;
	bool playerTerminated = false;
	int playerLength = 0;

	// iterate through the packet data in order to try to find the
	// zero terminator for the player's player string
	for (int i = playerOffset; i < GetSize() && !playerTerminated; i++)
	{
		if (bytes[i] == 0x00)
		{
			playerTerminated = true;
		}

		else
		{
			playerLength++;
		}
	}

	if (!playerTerminated)
	{
		// the character's player string has not been zero terminated;
		// there is not enough data to determine packet size
		*size = -1;
		*ready = false;
		return true;
	}

	// calculate the size of the packet
	*size = playerOffset + playerLength + 1 + 1;
	*ready = true;
	return true;
}

bool GameClientPacketMarshal::GetWardenPacketSize(int* size, bool* ready) const
{
	int wardenSizeOffset = 1;

	if (GetSize() < wardenSizeOffset + static_cast<int>(sizeof(short)))
	{
		// not enough data has been received to be able to get the size
		// of the warden data; impossible to determine packet size
		*size = -1;
		*ready = false;
	}

	else
	{
		const unsigned char* bytes = static_cast<const unsigned char*>(GetData());
		int wardenSize = *reinterpret_cast<const short*>(bytes + wardenSizeOffset);

		// calculate the size of the packet from the header
		*size = wardenSizeOffset + sizeof(short) + wardenSize;
		*ready = true;
	}

	return true;
}