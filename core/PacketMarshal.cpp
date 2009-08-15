#include "PacketMarshal.h"
#include <memory.h>
#include "Packet.h"

PacketMarshal::PacketMarshal() :
	_buffer(new unsigned char[InitialBufferSize]),
	_bufferSize(InitialBufferSize),
	_bufferOffset(0),
	_dataSize(0)
{

}

PacketMarshal::~PacketMarshal()
{
	delete[] _buffer;
}

void PacketMarshal::AppendData(const void* data, int size)
{
	int nextBufferOffset = _bufferOffset + size;
	if (nextBufferOffset > _bufferSize)
	{
		// not enough space left in the buffer to append the provided data;
		// allocate a new buffer large enough to hold the appended data
		unsigned char* buffer = new unsigned char[nextBufferOffset];

		// copy contents of the old buffer into the new buffer
		memcpy(buffer, _buffer, _bufferSize);

		// deallocate the old buffer (it is no longer needed)
		delete[] _buffer;

		// make the buffer pointer point to the newly allocated buffer
		_buffer = buffer;

		// update the buffer size (it is now larger)
		_bufferSize = nextBufferOffset;
	}

	// copy in the appended data at the proper offset within the buffer
	memcpy(_buffer + _bufferOffset, data, size);

	// adjust the buffer offset and data size
	_bufferOffset = nextBufferOffset;
	_dataSize += size;
}

void PacketMarshal::RemoveData(int size)
{
	if (size > _dataSize)
	{
		// don't try to remove more data than what 
		// is available in the packet buffer
		size = _dataSize;
	}

	int nextSize = _dataSize - size;
	int nextBufferOffset = _bufferOffset - size;
	
	if (nextSize > 0)
	{
		// shift down remaining data in the buffer
		memcpy(_buffer, _buffer + size, nextSize);
	}
	
	_dataSize = nextSize;
	_bufferOffset = nextBufferOffset;
}

IPacket* PacketMarshal::Deserialize()
{
	if (GetSize() > 0)
	{
		Packet* packet = new Packet(GetData(), GetSize());
		RemoveData(packet->GetSize());
		return packet;
	}

	return 0;
}

int PacketMarshal::Serialize(const IPacket* packet, void* buffer, int size)
{
	if (packet->GetSize() <= size)
	{
		memcpy(buffer, packet->GetData(), packet->GetSize());
		return packet->GetSize();
	}

	return -1;
}

const void* PacketMarshal::GetData() const
{
	return _buffer;
}

int PacketMarshal::GetSize() const
{
	return _dataSize;
}
