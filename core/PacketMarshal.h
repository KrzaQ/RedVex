#pragma once

class IPacket;

class PacketMarshal
{
public:
	PacketMarshal();
	virtual ~PacketMarshal();

	virtual int Serialize(const IPacket* packet, void* buffer, int size);
	virtual IPacket* Deserialize();

	void AppendData(const void* data, int size);
	void RemoveData(int size);

protected:
	const void* GetData() const;
	int GetSize() const;

private:
	static const int InitialBufferSize = 0x6000;

	unsigned char* _buffer;
	int _bufferSize;
	int _bufferOffset;
	int _dataSize;
};
