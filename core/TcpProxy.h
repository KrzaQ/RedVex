#pragma once
#include <list>

#include "IModule.h"
#include "IProxy.h"
#include "TcpSocket.h"
#include "PacketMarshal.h"

class IProxyPool;

class TcpProxy :
	public IModule,
	public IProxy
{
public:
	enum ProxyState
	{
		ProxyState_Invalid,
		ProxyState_Disconnected,
		ProxyState_FindServer,
		ProxyState_ConnectingStart,
		ProxyState_ConnectingWait,
		ProxyState_Connected,
		ProxyState_ConnectError
	};

	TcpProxy();
	virtual ~TcpProxy();

	void ConnectClient(TcpSocket* client);

	void Connect(const char* serverName, int serverPort, TcpSocket* client);
	void Disconnect();
	void AddModule(IModule* module);
	void ClearModules();
	ProxyState GetState() const;

	// IProxy
	void __stdcall RelayDataToServer(const IPacket* packet, const IModule* owner);
	void __stdcall RelayDataToClient(const IPacket* packet, const IModule* owner);
	IPacket* __stdcall CreatePacket(const void* data, int size) const;
	int __stdcall GetClientSocket();
	int __stdcall GetServerSocket();
	IProxy* __stdcall GetPeer();

	// IModule
	virtual void __stdcall Delete();
	virtual void __stdcall OnRelayDataToServer(IPacket* packet, const IModule* owner);
	virtual void __stdcall OnRelayDataToClient(IPacket* packet, const IModule* owner);
	virtual void __stdcall Update();

protected:
	virtual PacketMarshal* CreateClientPacketMarshal() = 0;
	virtual PacketMarshal* CreateServerPacketMarshal() = 0;
	virtual void OnStateChange(ProxyState previous, ProxyState current);

	void ConnectServer(TcpProxy* owner, const char* serverName, int serverPort);

	const char* GetServerName() const;
	int GetServerPort() const;

	TcpProxy* GetOwner();

private:
	void Setup();
	void UpdateStateFindServer();
	void UpdateStateConnectingStart();
	void UpdateStateConnectingWait();
	void UpdateStateConnected();
	void ResizeBuffer(int size);
	void SetState(ProxyState state);

	static const int InitialBufferSize = 0x6000;

	PacketMarshal* _clientPacketMarshal;
	PacketMarshal* _serverPacketMarshal;

	unsigned char* _buffer;
	int _size;

	TcpSocket* _client;
	TcpSocket _server;

	char _serverName[256];
	int _serverPort;

	TcpProxy* _owner;

	std::list<IModule*> _modules;
	ProxyState _state;
};
