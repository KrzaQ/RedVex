#include "Packet.h"
#include <memory.h>

Packet::Packet(const void* data, int size) :
	_buffer(new unsigned char[InitialBufferSize]),
	_bufferSize(InitialBufferSize),
	_dataSize(0),
	_flags(0)
{
	SetData(data, size);
}

Packet::Packet(const Packet& other) :
	_buffer(new unsigned char[InitialBufferSize]),
	_bufferSize(InitialBufferSize),
	_dataSize(0),
	_flags(other._flags)
{
	SetData(other.GetData(), other.GetSize());
}

Packet::~Packet()
{
	delete[] _buffer;
}

void Packet::Delete()
{
	delete this;
}

void Packet::SetData(const void* data, int size)
{
	if (size > _bufferSize)
	{
		delete[] _buffer;
		_buffer = new unsigned char[size];
		_bufferSize = size;
	}

	memcpy(_buffer, data, size);
	_dataSize = size;
}

void Packet::ClearData()
{
	_dataSize = 0;
}

int Packet::GetSize() const
{
	return _dataSize;
}

const void* Packet::GetData() const
{
	return _buffer;
}

IPacket* Packet::Clone() const
{
	return new Packet(*this);
}

bool Packet::IsFlagSet(PacketFlag flag) const
{
	return (_flags & (1 << flag)) != 0;
}

void Packet::SetFlag(PacketFlag flag)
{
	_flags |= (1 << flag);
}

void Packet::ClearFlag(PacketFlag flag)
{
	_flags &= ~(1 << flag);
}