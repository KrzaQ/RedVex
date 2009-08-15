#pragma once
#include "IPacket.h"

class Packet :
	public IPacket
{
public:
	Packet(const void* data, int size);
	Packet(const Packet& other);
	~Packet();

	// IPacket
	void __stdcall Delete();
	void __stdcall SetData(const void* data, int size);
	void __stdcall ClearData();
	int __stdcall GetSize() const;
	const void* __stdcall GetData() const;
	virtual IPacket* __stdcall Clone() const;
	bool __stdcall IsFlagSet(PacketFlag flag) const;
	void __stdcall SetFlag(PacketFlag flag);
	void __stdcall ClearFlag(PacketFlag flag);

private:
	static const int InitialBufferSize = 0x1000;

	unsigned int _flags;
	unsigned char* _buffer;
	int _bufferSize;
	int _dataSize;
};
