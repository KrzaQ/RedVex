#include "RealmProxy.h"
#include "RealmPacketMarshal.h"
#include "PluginManager.h"
#include "Plugin.h"
#include "Packet.h"
#include "GameProxy.h"
#include "Globals.h"
#include "IProxyPool.h"
#include "IPacket.h"
#include "ProxyThread.h"
#include "ChatProxy.h"

ChatProxy* FindRealmHash(const void* hash, int size)
{
	for (std::list<TcpProxy*>::iterator i =  Thread->Proxies.begin(); i != Thread->Proxies.end(); i++)
	{
		TcpProxy* proxy = *i;
		ChatProxy* chatProxy = dynamic_cast<ChatProxy*>(proxy);

		if(chatProxy != 0)
		{
			if(chatProxy->RealmHash.Equal(hash, size))
				return chatProxy;
		}
	}

	return 0;
}

RealmProxy::RealmProxy() :
	TcpProxy()
{
	for (int i = 0; i < Plugins->GetPluginCount(); i++)
	{
		const Plugin* plugin = Plugins->GetPlugin(i);
		IModule* module = plugin->CreateModule(this, RealmModule);
		if (module != 0)
		{
			AddModule(module);
		}
	}
}

	
RealmProxy::~RealmProxy()
{
}

void RealmProxy::OnStateChange(ProxyState previous, ProxyState current)
{
	switch (current)
	{
		case ProxyState_Disconnected:
			if (previous == ProxyState_FindServer)
				Log.Write("No realm server found at %X\n\n", this);
			break;

		case ProxyState_Connected:
			for (std::list<IPacket*>::iterator i = _packets.begin(); i != _packets.end(); i++)
			{
				IPacket* packet = *i;
				RelayDataToServer(packet, this);
				packet->Delete();
			}
			_packets.clear();
			break;

		case ProxyState_FindServer:
			Log.Write("Searching for realm server at %X\n\n", this);
			break;
	}

	TcpProxy::OnStateChange(previous, current);
}

void RealmProxy::OnRelayDataToClient(IPacket* packet, const IModule* owner)
{
	Log.Write("Realm packet to client!\n");
	Log.Dump(packet->GetData(), packet->GetSize());
	Log.Write("\n");

	const unsigned char* bytes = static_cast<const unsigned char*>(packet->GetData());
	int packetId = bytes[2];

	if (packetId == 0x04)
	{
		// create a temporary work buffer for the packet data
		unsigned char* buffer = new unsigned char[packet->GetSize()];
		memcpy(buffer, packet->GetData(), packet->GetSize());

		// extract game server and game result
		unsigned long* serverIp = reinterpret_cast<unsigned long*>(buffer + 9);
		unsigned long* gameHash = reinterpret_cast<unsigned long*>(buffer + 13);
		unsigned int* result = reinterpret_cast<unsigned int*>(buffer + 17);

		// only bother to patch the packet if game creation request was successful
		if (*result == 0)
		{
			// store off the original and patched addresses
			long oldServerIp = *serverIp;
			long newServerIp = 0;

			// resolve local name
			TcpSocket::Resolve(Thread->LocalName.c_str(), &newServerIp);

			ChatProxy* proxy = dynamic_cast<ChatProxy*>(GetOwner());

			if(newServerIp != 0 && proxy != 0)
			{
				proxy->GameHash.Set(gameHash, 4);

				// convert server addresses from numerical to string form
				char newServerAddress[16];
				strcpy_s(newServerAddress, inet_ntoa(*reinterpret_cast<in_addr*>(&newServerIp)));

				strcpy_s(proxy->GameName, inet_ntoa(*reinterpret_cast<in_addr*>(&oldServerIp)));

				*serverIp = newServerIp;

				packet->SetData(buffer, packet->GetSize());

				// notify the user that the realm logon packet has been patched
				Log.Write("Patched game server logon (%s to %s) Hash %d\n\n", proxy->GameName, newServerAddress, *gameHash);
			}
			else
				Log.Write("Error: Unable to patch game server logon");
		}

		else
		{
			Log.Write("Game server logon denied (%d)\n\n", *result);
		}

		// work buffer no loner needed, deallocate it
		delete[] buffer;
	}

	TcpProxy::OnRelayDataToClient(packet, owner);
}

void RealmProxy::OnRelayDataToServer(IPacket* packet, const IModule* owner)
{
	Log.Write("Realm packet to server!\n");
	Log.Dump(packet->GetData(), packet->GetSize());
	Log.Write("\n");

	if(GetState() != ProxyState_Connected)
	{
		_packets.push_back(packet->Clone());

		const unsigned char* bytes = static_cast<const unsigned char*>(packet->GetData());
		int packetId = bytes[2];
		
		if (packetId == 0x01)
		{
			// store off the server hash
			ChatProxy* proxy = FindRealmHash(bytes + 3, 64);

			if(proxy != 0)
				ConnectServer(proxy, &proxy->RealmName[0], proxy->RealmPort);
			else
				Disconnect();

			return;
		}

	}

	TcpProxy::OnRelayDataToServer(packet, owner);
}

PacketMarshal* RealmProxy::CreateServerPacketMarshal()
{
	return new RealmPacketMarshal(false);
}

PacketMarshal* RealmProxy::CreateClientPacketMarshal()
{
	return new RealmPacketMarshal(true);
}