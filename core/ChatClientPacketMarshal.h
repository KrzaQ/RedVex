#pragma once
#include "ChatPacketMarshal.h"

class ChatClientPacketMarshal :
	public ChatPacketMarshal
{
public:
	ChatClientPacketMarshal(MarshalType* type);

	MarshalType GetMarshalType() const;
	IPacket* Deserialize();

private:
	MarshalType* _type;
};
