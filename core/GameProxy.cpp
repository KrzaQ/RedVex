#include "GameProxy.h"
#include "GameServerPacketMarshal.h"
#include "GameClientPacketMarshal.h"
#include "PluginManager.h"
#include "Plugin.h"
#include "Packet.h"
#include "ProxyThread.h"
#include "ChatProxy.h"
#include "Globals.h"

ChatProxy* FindGameHash(const void* hash, int size)
{
	for (std::list<TcpProxy*>::iterator i =  Thread->Proxies.begin(); i != Thread->Proxies.end(); i++)
	{
		TcpProxy* proxy = *i;
		ChatProxy* chatProxy = dynamic_cast<ChatProxy*>(proxy);

		if(chatProxy != 0)
		{
			if(chatProxy->GameHash.Equal(hash, size))
				return chatProxy;
		}
	}

	return 0;
}

GameProxy::GameProxy() :
	TcpProxy(),
	_processedPackets(false)
{
	for (int i = 0; i < Plugins->GetPluginCount(); i++)
	{
		const Plugin* plugin = Plugins->GetPlugin(i);
		IModule* module = plugin->CreateModule(this, GameModule);	
		if (module != 0)
		{
			AddModule(module);
		}
	}
}


void GameProxy::OnStateChange(ProxyState previous, ProxyState current)
{
	switch (current)
	{
		case ProxyState_Disconnected:
			if (previous == ProxyState_FindServer)
				Log.Write("No game server found at %X\n\n", this);
			break;

		case ProxyState_FindServer:
			unsigned char data = 0xAF;

			Packet* packet = new Packet(&data, 1);
			OnRelayDataToClient(packet, this);
			delete packet;

			Log.Write("Searching for game server at %X\n\n", this);
			break;
	}

	TcpProxy::OnStateChange(previous, current);
}

void GameProxy::OnRelayDataToClient(IPacket* packet, const IModule* owner)
{
	Log.Write("Game packet to client!\n");
	Log.Dump(packet->GetData(), packet->GetSize());
	Log.Write("\n");

	const unsigned char* bytes = static_cast<const unsigned char*>(packet->GetData());
	int packetId = *bytes;

	if (packetId == 0xAF && !_processedPackets && GetState() != ProxyState_FindServer)
	{
		for (std::list<IPacket*>::iterator i = _packets.begin(); i != _packets.end(); i++)
		{
			IPacket* packet = *i;
			RelayDataToServer(packet, this);
			delete packet;
		}

		_packets.clear();

		return;
	}

	TcpProxy::OnRelayDataToClient(packet, owner);
}

void GameProxy::OnRelayDataToServer(IPacket* packet, const IModule* owner)
{
	Log.Write("Game packet to server!\n");
	Log.Dump(packet->GetData(), packet->GetSize());
	Log.Write("\n");

	if(GetState() != ProxyState_Connected)
	{
		_packets.push_back(packet->Clone());

		const unsigned char* bytes = static_cast<const unsigned char*>(packet->GetData());
		int packetId = *bytes;
		
		if (packetId == 0x68)
		{
			const unsigned long* gameHash = reinterpret_cast<const unsigned long*>(bytes + 1);

			Log.Write("Looking for gamehash %d\n\n", *gameHash);

			// store off the server hash
			ChatProxy* proxy = FindGameHash(gameHash, 4);

			if(proxy != 0)
				ConnectServer(proxy, &proxy->GameName[0], Thread->GameServerPort);
			else
				Disconnect();

			return;
		}

	}

	TcpProxy::OnRelayDataToServer(packet, owner);
}


PacketMarshal* GameProxy::CreateServerPacketMarshal()
{
	return new GameServerPacketMarshal();
}

PacketMarshal* GameProxy::CreateClientPacketMarshal()
{
	return new GameClientPacketMarshal();
}