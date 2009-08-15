#pragma once
#include "PacketMarshal.h"

class ChatPacketMarshal :
	public PacketMarshal
{
public:
	enum MarshalType
	{
		MarshalType_Control,
		MarshalType_Data,
		MarshalType_Undetermined
	};

	virtual ~ChatPacketMarshal();

	virtual MarshalType GetMarshalType() const = 0;
	virtual IPacket* Deserialize();
};
