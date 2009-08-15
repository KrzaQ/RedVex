#pragma once
#include <list>

class PacketMarshal;
class TcpSocket;
class IPacket;

class ProxyCreator
{
public:
	enum CreatorState
	{
		CreatorState_Creating,
		CreatorState_Error,
		CreatorState_Disconnected
	};

	ProxyCreator(TcpSocket* client, int clientPort);
	virtual ~ProxyCreator();

	void Disconnect();
	CreatorState GetState() const;

	void Update();

	virtual void RelayDataToClient(IPacket* packet);
	virtual void RelayDataToServer(const IPacket* packet);

protected:
	virtual PacketMarshal* CreateClientPacketMarshal();
	virtual PacketMarshal* CreateServerPacketMarshal();
	virtual void OnStateChange(CreatorState previous, CreatorState current);

	int GetClientPort() const;

private:
	void UpdateStateCreating();
	void ResizeBuffer(int size);
	void SetState(CreatorState state);

	static const int InitialBufferSize = 0x6000;

	PacketMarshal* _clientPacketMarshal;
	PacketMarshal* _serverPacketMarshal;

	unsigned char* _buffer;
	int _size;

	TcpSocket* _client;
	int _clientPort;

	CreatorState _state;
};
