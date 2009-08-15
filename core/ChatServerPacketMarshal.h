#pragma once
#include "ChatPacketMarshal.h"

class ChatServerPacketMarshal :
	public ChatPacketMarshal
{
public:
	ChatServerPacketMarshal(const MarshalType* type);

	IPacket* Deserialize();
	MarshalType GetMarshalType() const;

private:
	const MarshalType* _type;
};
