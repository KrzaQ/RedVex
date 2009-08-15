#include "ModuleLink.h"
#include "Globals.h"
#include "IProxy.h"
#include "Plugin.h"
#include "IProxy.h"

ModuleLink::ModuleLink(IModuleKind type, IModule* module, IProxy* proxy, Plugin* plugin) :
	_type(type),
	_module(module),
    _proxy(proxy),
	_plugin(plugin)
{
    switch(_type)
    {
		case ChatModule: _typestr = "Chat"; break;
		case RealmModule: _typestr = "Realm"; break;
		case GameModule: _typestr = "Game"; break;
    }

	Log.Write("Loading \"%s\" into %s\n\n", _plugin->GetTitle(), _typestr);
}

void ModuleLink::Delete()
{
	Log.Write("Removing \"%s\" from %s\n\n", _plugin->GetTitle(), _typestr);

	__try
	{
		_module->Delete();
	}
	__except(_plugin->ExceptionHandler(GetExceptionInformation(), "IModule->Delete"))
	{
	}

	delete this;
}

void ModuleLink::OnRelayDataToServer(IPacket* packet, const IModule* owner)
{
	__try
	{
		_module->OnRelayDataToServer(packet, owner);
	}
	__except(_plugin->ExceptionHandler(GetExceptionInformation(), "IModule->OnRelayDataToServer"))
	{
	}
}

void ModuleLink::OnRelayDataToClient(IPacket* packet, const IModule* owner)
{
	__try
	{
		_module->OnRelayDataToClient(packet, owner);
	}
	__except(_plugin->ExceptionHandler(GetExceptionInformation(), "IModule->OnRelayDataToClient"))
	{
	}	
}

void ModuleLink::Update()
{
	__try
	{
		_module->Update();
	}
	__except(_plugin->ExceptionHandler(GetExceptionInformation(), "IModule->Update"))
	{
	}	
}
