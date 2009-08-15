#pragma once
#include "IModule.h"
#include "IProxy.h"
#include "Plugin.h"


class ModuleLink :
	public IModule
{
public:

	ModuleLink(IModuleKind type, IModule* module, IProxy* proxy, Plugin* plugin);
	void __stdcall Delete();
	void __stdcall OnRelayDataToServer(IPacket* packet, const IModule* owner);
	void __stdcall OnRelayDataToClient(IPacket* packet, const IModule* owner);
	void __stdcall Update();
private:
	Plugin* _plugin;
    char* _typestr;
    IModuleKind _type;
	IModule* _module; 
    IProxy* _proxy;
};
