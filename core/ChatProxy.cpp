#include "ChatProxy.h"
#include "ChatClientPacketMarshal.h"
#include "ChatServerPacketMarshal.h"
#include "PluginManager.h"
#include "Plugin.h"
#include "Globals.h"
#include "RealmProxy.h"
#include "IProxyPool.h"
#include "IPacket.h"
#include "IModule.h"
#include "ProxyThread.h"

ChatProxy::ChatProxy() :
	TcpProxy(),
	_type(ChatPacketMarshal::MarshalType_Undetermined),
	_pluginsProcessed(false)
{
}

ChatProxy::~ChatProxy()
{
}

void ChatProxy::OnRelayDataToClient(IPacket* packet, const IModule* owner)
{
	const unsigned char* bytes = static_cast<const unsigned char*>(packet->GetData());
	int packetId = bytes[1];

	if (packetId == 0x3e)
	{
		// create a temporary work buffer for the packet data
		unsigned char* buffer = new unsigned char[packet->GetSize()];
		memcpy(buffer, packet->GetData(), packet->GetSize());
		
		// store off the server hash
		unsigned char hash[64];
		memcpy(hash, buffer + 4, 16);
		memcpy(hash + 16, buffer + 28, 48); 

		RealmHash.Set(hash, sizeof(hash));

		// extract realm server ip and port
		unsigned long* serverIp = reinterpret_cast<unsigned long*>(buffer + 20);
		unsigned short* serverPort = reinterpret_cast<unsigned short*>(buffer + 24);

		// store off the old values for server ip and port
		long oldServerIp = *serverIp;
		RealmPort = ntohs(*serverPort);

		// redirect realm server port to local interface
		long newServerIp = 0;

		// resolve local name
		TcpSocket::Resolve(Thread->LocalName.c_str(), &newServerIp);

		if(newServerIp != 0)
		{
			// convert server addresses from numerical to string form
			char newServerAddress[16];
			strcpy_s(newServerAddress, inet_ntoa(*reinterpret_cast<in_addr*>(&newServerIp)));
			strcpy_s(RealmName, inet_ntoa(*reinterpret_cast<in_addr*>(&oldServerIp)));

			// patch the packet with the modified data
			*serverPort = htons(Thread->RealmClientPort);
			*serverIp = newServerIp;
			packet->SetData(buffer, packet->GetSize());


			// notify the user that the realm logon packet has been patched
			Log.Write("Patched realm server logon (%s:%d to %s:%d)\n\n", RealmName, RealmPort, newServerAddress, Thread->RealmClientPort);
		}
		else
			Log.Write("Error: Unable to patch realm server logon");

		// work buffer no longer needed, deallocate it
		delete[] buffer;
	}

	TcpProxy::OnRelayDataToClient(packet, owner);
}

void ChatProxy::Update()
{
	if (_type == ChatPacketMarshal::MarshalType_Control && !_pluginsProcessed)
	{
		// only load chat modules for control connections, not data connections
		for (int i = 0; i < Plugins->GetPluginCount(); i++)
		{
			const Plugin* plugin = Plugins->GetPlugin(i);
			IModule* module = plugin->CreateModule(this, ChatModule);
			if (module != 0)
			{
				AddModule(module);
			}
		}

		// set the processed flag so that plugins don't get loaded again
		_pluginsProcessed = true;
	}

	TcpProxy::Update();
}

PacketMarshal* ChatProxy::CreateClientPacketMarshal()
{
	return new ChatClientPacketMarshal(&_type);
}

PacketMarshal* ChatProxy::CreateServerPacketMarshal()
{
	return new ChatServerPacketMarshal(&_type);
}