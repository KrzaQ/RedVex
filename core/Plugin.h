#pragma once
#include <string>
#include <windows.h>
#include "IModule.h"

class IModule;
class IProxy;

typedef void(__stdcall *FreePlugin)(void* Info);
typedef IModule*(__stdcall *ModuleCreator)(IProxy* proxy, IModuleKind Kind);

struct PluginInfo {
	  const char* Name;
	  const char* Author;
	  int SDKVersion;
	  FreePlugin Free;
	  ModuleCreator Create;
	};


class Plugin
{
public:
	// External
    virtual const char* __stdcall GetFileName();
    virtual PluginInfo* __stdcall GetInfo();
    virtual void __stdcall Unload();

	Plugin(const char* filename);
	~Plugin();

	void CreateHandle();
	void FreeHandle() const;

	DWORD ExceptionHandler(LPEXCEPTION_POINTERS Information, const char* Location) const;

	IModule* CreateModule(IProxy* proxy, const IModuleKind Kind) const;
	void Free();

	IModule* ModuleCreator(IProxy* proxy, const IModuleKind Kind) const;

	const char* GetTitle() const;
	int GetSdkVersion() const;

	HMODULE GetHandle() const;
	bool IsValid() const;

private:
	PluginInfo *_info;
	std::string _filename;
	HMODULE _library;
};
