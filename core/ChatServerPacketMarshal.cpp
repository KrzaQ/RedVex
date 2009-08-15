#include "ChatServerPacketMarshal.h"
#include "IPacket.h"
#include "Globals.h"

ChatServerPacketMarshal::ChatServerPacketMarshal(const MarshalType* type) :
	_type(type)
{

}

IPacket* ChatServerPacketMarshal::Deserialize()
{
	IPacket* packet = 0;

	if (GetSize() > 0)
	{
	/*	Log.Write("Server -> Client:\n");
		Log.Dump(GetData(), GetSize());
		Log.Write("\n");
*/
		switch (*_type)
		{
		case MarshalType_Control:
			packet = ChatPacketMarshal::Deserialize();
			break;

		case MarshalType_Data:
			// when in data transfer mode, packets should be sent across to the client without
			// going through the plugin chain as they have a different format and are generally
			// not that interesting to manipulate
			packet = PacketMarshal::Deserialize();
			if (packet != 0)
			{
				packet->SetFlag(IPacket::PacketFlag_Hidden);
			}
			break;

		case MarshalType_Undetermined:
			// data is being received from the client even though the proxy doesn't yet know
			// if the this is a control or data connection; however to keep the application
			// from fatally failing, send the packet across in data connection mode
			Log.Write("Error: Undetermined chat marshal type\n");
			Log.Dump(GetData(), GetSize());
			Log.Write("\n");

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

ChatPacketMarshal::MarshalType ChatServerPacketMarshal::GetMarshalType() const
{
	return *_type;
}