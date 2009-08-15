#include "ChatClientPacketMarshal.h"
#include "Packet.h"
#include "Globals.h"

ChatClientPacketMarshal::ChatClientPacketMarshal(MarshalType* type) :
	_type(type)
{

}

IPacket* ChatClientPacketMarshal::Deserialize()
{
	IPacket* packet = 0;

	if (GetSize() > 0)
	{
/*		Log.Write("Client -> Server:\n");
		Log.Dump(GetData(), GetSize());
		Log.Write("\n");
*/
		const unsigned char* bytes = static_cast<const unsigned char*>(GetData());

		switch (*_type)
		{
		case MarshalType_Undetermined:
			switch (bytes[0])
			{
			case 0x01:
				Log.Write("Chat marshal switched to control mode\n\n");
				*_type = MarshalType_Control;
				packet = new Packet(GetData(), 1);
				break;

			case 0x02:
				Log.Write("Chat marshal switched to data mode\n\n");
				*_type = MarshalType_Data;
				packet = new Packet(GetData(), 1);
				break;

			default:
				// an unknown type of chat server connection was announced; can't really do anything
				// at this point except fall back to a data connection type to prevent a fatal
				// failure in the application
				*_type = MarshalType_Data;
				Log.Write("Error: Unrecognized chat server connection type: 0x%.2x\n", bytes[0]);
				Log.Dump(GetData(), GetSize());
				Log.Write("\n");
				break;
			}
			
			if (packet != 0)
			{
				// in this state the client isn't sending out "real" packets, these are just
				// identifiers for the type of connection the client wants to establish (data vs control);
				// these packets should be hidden from the plugins because they aren't formed
				// in a standard way and would make packet handling more difficult
				packet->SetFlag(IPacket::PacketFlag_Hidden);
				RemoveData(packet->GetSize());
			}
			break;

		case MarshalType_Control:
			packet = ChatPacketMarshal::Deserialize();
			break;

		case MarshalType_Data:
			// when in data transfer mode, packets should be sent across to the server without
			// going through the plugin chain as they have a different format and are generally
			// not that interesting to manipulate
			packet = PacketMarshal::Deserialize();
			if (packet != 0)
			{
				packet->SetFlag(IPacket::PacketFlag_Hidden);
			}
			break;
		}
	}

	return packet;
}

ChatPacketMarshal::MarshalType ChatClientPacketMarshal::GetMarshalType() const
{
	return *_type;
}