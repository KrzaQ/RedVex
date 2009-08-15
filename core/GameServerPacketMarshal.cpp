#include "GameServerPacketMarshal.h"
#include "Compression.h"
#include "Packet.h"
#include "Globals.h"

const int GameServerPacketMarshal::PacketSizes[] = 
{
	1,	8,	1,	12,	1,	1,	1,	6,	6,	11,	6,	6,	9,	13,	12,	16, 
	16,	8,	26,	14,	18,	11,	-1,	-1,	15,	2,	2,	3,	5,	3,	4,	6,
	10,	12,	12,	13,	90,	90,	-1,	40,	103,97,	15,	-1,	8,	-1,	-1,	-1,
	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	34,	8,
	13,	-1,	6,	-1,	-1,	13,	-1,	11,	11,	-1,	-1,	-1,	16,	17,	7,	1,
	15,	14,	42,	10,	3,	-1,	-1,	14,	7,	26,	40,	-1,	5,	6,	38,	5,
	7,	2,	7,	21,	-1,	7,	7,	16,	21,	12,	12,	16,	16,	10,	1,	1,
	1,	1,	1,	32,	10,	13,	6,	2,	21,	6,	13,	8,	6,	18,	5,	10,
	4,	20,	29,	-1,	-1,	-1,	-1,	-1,	-1,	2,	6,	6,	11,	7,	10,	33,
	13,	26,	6,	8,	-1,	13,	9,	1,	7,	16,	17,	7,	-1,	-1,	7,	8,
	10,	7,	8,	24,	3,	8,	-1,	7,	-1,	7,	-1,	7,	-1,	-1,	-1,	-1, 
	1
};

GameServerPacketMarshal::GameServerPacketMarshal() :
	_magic(false)
{

}

GameServerPacketMarshal::~GameServerPacketMarshal()
{
	// free any leftover packets in the packet queue
	while (!_packets.empty())
	{
		delete _packets.front();
		_packets.pop();
	}
}

IPacket* GameServerPacketMarshal::Deserialize()
{
	if (GetSize() > 0)
	{
		unsigned char buffer[WorkBufferSize];

		if (_magic)
		{
			// determine the size of the packet in the compressed form
			int compressedSize = Compression::GetPacketSize(GetData(), GetSize());
			if (compressedSize <= GetSize())
			{
				// at least the entire length of the compressed packet was received, decompress the packet data
				int decompressedSize = Compression::DecompressPacket(GetData(), compressedSize, buffer, sizeof(buffer));
				if (decompressedSize == 0)
				{
					// zero-length packets are not to be sent through the plugin chain
					IPacket* packet = new Packet(buffer, decompressedSize);
					packet->SetFlag(IPacket::PacketFlag_Hidden);

					// enqueue the empty packet into the send queue
					_packets.push(packet);
				}

				else
				{
					// parse out and enqueue the individual packets within the decompressed lump
					EnqueuePackets(buffer, decompressedSize);
				}

				// remove the corresponding chunk of data from the receive buffer
				RemoveData(compressedSize);
			}
		}

		else
		{
			_magic = true;

			// the first packet received from the game server is magical because it is not compressed
			Packet* packet = new Packet(GetData(), 1);
			packet->SetFlag(IPacket::PacketFlag_Finalized);
			packet->SetFlag(IPacket::PacketFlag_Hidden);

			// enqueue the given packet and remove the corresponding chunk of data from the receive buffer
			_packets.push(packet);
			RemoveData(packet->GetSize());
		}
	}

	IPacket* packet = 0;

	if (!_packets.empty())
	{
		// there is at least one received packet available to the caller, 
		// extract it from the local packet queue to be returned
		packet = _packets.front();
		_packets.pop();
	}

	return packet;
}

int GameServerPacketMarshal::Serialize(const IPacket* packet, void* buffer, int size)
{
	if (packet->IsFlagSet(IPacket::PacketFlag_Finalized))
	{
		// finalized packets are serialized specifically without any additional 
		// operations performed on them; let the base packet marshal deal with it
		return PacketMarshal::Serialize(packet, buffer, size);
	}

	// decompress data out of the packet directly into the output buffer
	return Compression::CompressPacket(packet->GetData(), packet->GetSize(), buffer, size);
}

void GameServerPacketMarshal::EnqueuePackets(const void* data, int size)
{
	const unsigned char* bytes = reinterpret_cast<const unsigned char*>(data);
	std::queue<IPacket*> packets;
	int offset = 0;

	while (offset < size)
	{
		int packetSize = GetDecompressedPacketSize(bytes + offset, size - offset);

		if (packetSize < 0)
		{
			Log.Write("Error: Unexpected server packetId encountered: 0x%.2x\n", bytes[offset]);
			Log.Dump(data, size);
			Log.Write("\n");
			break;
		}

		if (packetSize < 0 || size - offset < 0)
		{
			Log.Write("Error: Unexpected end of server data encountered\n");
			Log.Dump(data, size);
			Log.Write("\n");
			break;
		}

		// a packet size was successfully obtained; create a packet and store the
		// current segment of the lump inside of it
		packets.push(new Packet(bytes + offset, packetSize));
		offset += packetSize;
	}

	if (offset == size)
	{
		// all of the packets were successfully parsed, transfer the contents
		// of the temporary packet queue into the persistant packet queue
		while (!packets.empty())
		{
			IPacket* packet = packets.front();
			_packets.push(packet);
			packets.pop();
		}
	}

	else
	{
		// packet parsing was not successful, not all of the packets within the
		// decompressed lump could be sepearated; free the packets in the local 
		// packet queue because they are invalid
		while (!packets.empty())
		{
			delete packets.front();
			packets.pop();
		}

		// send the entire lump as a packet; even though the proxy could not
		// parse it, it should at least reach the game client to prevent a 
		// disconnect; also hide this packet so that the plugins don't have to
		// deal with raw packet data
		Packet* packet = new Packet(data, size);
		packet->SetFlag(IPacket::PacketFlag_Hidden);
		_packets.push(packet);
	}
}

int GameServerPacketMarshal::GetDecompressedPacketSize(const void* data, int size)
{
	const unsigned char* bytes = reinterpret_cast<const unsigned char*>(data);
	int packetId = *static_cast<const unsigned char*>(data);

	switch (packetId)
	{
	case 0x26:
		return GetChatPacketSize(data, size);

	case 0x5b:
		return *reinterpret_cast<const short*>(bytes + 1);

	case 0x94:
		if (size >= 2)
		{
			return bytes[1] * 3 + 6;
		}
		break;

	case 0xa8:
		if (size >= 7)
		{
			return bytes[6];
		}
		break;

	case 0xaa:
		if (size >= 7)
		{
			return bytes[6];
		}
		break;

	case 0xac:
		if (size >= 13)
		{
			return bytes[12];
		}
		break;

	case 0xae:
		if (size >= 3)
		{
			return 3 + *reinterpret_cast<const short*>(bytes + 1);
		}
		break;

	case 0x9c:
		if (size >= 3)
		{
			return bytes[2];
		}
		break;

	case 0x9d:
		if (size >= 3)
		{
			return bytes[2];
		}
		break;

	default:
		if (packetId < sizeof(PacketSizes) / sizeof(int))
		{
			return PacketSizes[packetId];
		}
		break;
	}

	return -1;
}

int GameServerPacketMarshal::GetChatPacketSize(const void* data, int size)
{
	if (size >= 12)
	{
		const unsigned char* bytes = reinterpret_cast<const unsigned char*>(data);
		
		const char* name = reinterpret_cast<const char*>(bytes + 10);
		int nameLength = static_cast<int>(strlen(name));

		const char* message = reinterpret_cast<const char*>(bytes + 10 + nameLength + 1);
		int messageLength = static_cast<int>(strlen(message));
		
		return 10 + nameLength + 1 + messageLength + 1;
	}

	return -1;
}