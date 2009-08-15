#include "RealmPacketMarshal.h"
#include "Packet.h"

RealmPacketMarshal::RealmPacketMarshal(bool useMagicByte) :
	_magic(!useMagicByte)
{


}

IPacket* RealmPacketMarshal::Deserialize()
{
	IPacket* packet = 0;

	if (GetSize() > 0)
	{
		if (_magic)
		{
			int packetSize = *reinterpret_cast<const short*>(GetData()); 
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
			_magic = true;

			// magic data, send it off without waiting for the rest of the packet;
			// set the hidden flag so that the magical packet is not processed
			// by the plugins - it has an incompatible structure and would cause
			// parsing problems for the plugins
			packet = new Packet(GetData(), 1);
			packet->SetFlag(IPacket::PacketFlag_Hidden);
			RemoveData(packet->GetSize());
		}
	}

	return packet;
}