#include "ChatPacketMarshal.h"
#include "Globals.h"
#include "Packet.h"

ChatPacketMarshal::~ChatPacketMarshal()
{

}

IPacket* ChatPacketMarshal::Deserialize()
{
	IPacket* packet = 0;

	if (GetSize() > 0)
	{
		const unsigned char* bytes = static_cast<const unsigned char*>(GetData());

		if (bytes[0] == 0xff)
		{
			int packetSize = *reinterpret_cast<const short*>(bytes + 2); 
			if (packetSize <= GetSize())
			{
				// at least the entire length of the packet was received; deserialize the 
				// packet and remove the data associated with the packet from the packet buffer

				packet = new Packet(GetData(), packetSize);
				RemoveData(packet->GetSize());
			}
		}
	
		else
		{
			Log.Write("Error: Unrecognized chat packet format\n");
			Log.Dump(GetData(), GetSize());
			Log.Write("\n");

			packet = PacketMarshal::Deserialize();
			if (packet != 0)
			{
				packet->SetFlag(IPacket::PacketFlag_Hidden);
			}
		}
	}

	return packet;
}
