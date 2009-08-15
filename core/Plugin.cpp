#include "Plugin.h"
#include "PluginManager.h"
#include "Globals.h"
#include "ModuleLink.h"

typedef PluginInfo*(__stdcall *InitPlugin)(void* Reserved);

DWORD Plugin::ExceptionHandler(LPEXCEPTION_POINTERS Information, const char* Location) const
{
	bool Handled = false;

	// Check for a Delphi Exception
	__try
	{
		struct DelphiException
		{
			char** Virtual;
			char* Message;
		};

		if (Information->ExceptionRecord->NumberParameters == 7)
		{
			DelphiException* Object = ((DelphiException**)Information->ExceptionRecord->ExceptionInformation)[1];

			char* Class = Object->Virtual[-11] + 1;

			if (*((int*)Object->Message - 1) == strlen(Object->Message))
			{
				char* ClassName = new char[Class[-1] + 1];
				__try
				{
					ClassName[Class[-1]] = 0;
					memcpy(ClassName, Class, Class[-1]);

					Log.Write("(Error in %s) %s gave %s with message %s at 0x%p\n\n", GetTitle(), Location, ClassName, Object->Message, Information->ExceptionRecord->ExceptionCode, Information->ExceptionRecord->ExceptionAddress);
					Handled = true;
				}
				__finally
				{
					delete ClassName;
				}
			}
		}
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
	}

	if(!Handled)
	{
		Log.Write("(Error in %s) %s gave an exception (0x%p) at 0x%p\n\n", GetTitle(), Location, Information->ExceptionRecord->ExceptionCode, Information->ExceptionRecord->ExceptionAddress);
	}

	return EXCEPTION_EXECUTE_HANDLER;
}

Plugin::Plugin(const char* filename) :
	_info(0)
{
	_filename = filename;

	CreateHandle();
}

void Plugin::CreateHandle()
{
	InitPlugin Init;

	_library = LoadLibrary(_filename.c_str());

	if (_library != 0)
	{
		__try
		{
			Init = (InitPlugin)GetProcAddress(_library, "_InitPlugin@4");

			_info = Init(Plugins->GetPluginInfo());
		}
		__except(ExceptionHandler(GetExceptionInformation(), "InitPlugin"))
		{
			FreeHandle();

			_library = 0;
		}
	}
}

void Plugin::FreeHandle() const
{
	if (GetHandle() != 0)
	{ 
		__try
		{
			FreeLibrary(GetHandle());
		}
		__except(ExceptionHandler(GetExceptionInformation(), "FreeLibrary"))
		{
		}	
	}
}

void Plugin::Free()
{
	__try
	{
		_info->Free(_info);
	}
	__except(ExceptionHandler(GetExceptionInformation(), "PluginInfo->Free"))
	{
	}
}

Plugin::~Plugin()
{
	if (GetHandle() != 0)
	{ 
		Free();
		FreeHandle();
	}
}

void __stdcall Plugin::Unload()
{
}

const char* __stdcall Plugin::GetFileName()
{
  return _filename.c_str();
}

PluginInfo* __stdcall Plugin::GetInfo()
{
  return _info;
}

IModule* Plugin::ModuleCreator(IProxy* proxy, const IModuleKind Kind) const
{
	if (GetHandle() == 0) return 0;

	IModule* Result = 0;

	__try
	{
		Result = _info->Create(proxy, Kind);
	}
	__except(ExceptionHandler(GetExceptionInformation(), "PluginInfo->Create"))
	{
	}

	return Result;
}

IModule* Plugin::CreateModule(IProxy* proxy, const IModuleKind Kind) const
{
	IModule* Result = ModuleCreator(proxy, Kind);

	if (Result != 0)
	{
		Result = new ModuleLink(Kind, Result, proxy, (Plugin *)this);
	}

	return Result;
}

const char* Plugin::GetTitle() const
{
	if (GetHandle() != 0)
	{
		__try
		{
			return _info->Name;
		}
		__except(EXCEPTION_EXECUTE_HANDLER)
		{
			const char* filename = strrchr(_filename.c_str(), '\\');

			if (filename == 0)
			{
				filename = strrchr(_filename.c_str(), '/');

				if (filename == 0)
					return _filename.c_str();
			}

			return ++filename;
		}
	}

	return 0;	
}

int Plugin::GetSdkVersion() const
{
	if (GetHandle() != 0)
	{
		__try
		{
			return _info->SDKVersion;
		}
		__except(EXCEPTION_EXECUTE_HANDLER)
		{
		}
	}

	return 0;
}

HMODULE Plugin::GetHandle() const
{
	return _library;
}

bool Plugin::IsValid() const
{
	return GetHandle() != 0;
}