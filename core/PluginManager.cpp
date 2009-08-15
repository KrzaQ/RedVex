#pragma comment(lib, "shlwapi.lib")
#include <shlwapi.h>
#include "PluginManager.h"
#include "Plugin.h"
#include "Globals.h"

PluginManager* Plugins = 0; 

PluginManager::PluginManager(const char* path)
{
	AddPluginPath(path);
}

PluginManager::PluginManager()
{

}

void PluginManager::DisplayPluginData()
{
	Log.Write(VersionString);

	Log.Write("\nLoaded plugins (%d total, must have SDK version %d or lower):\n\n", 
		GetPluginCount(), SdkVersion);

	for (int i = 0; i < GetPluginCount(); i++)
	{
		const Plugin* plugin = GetPlugin(i);

		char modules[4] = {0};
		int offset = 0;


		Log.Write("\t%d.\tTitle: %s\n\t\tSDK Version: %d\n\n",
			i + 1, plugin->GetTitle(), plugin->GetSdkVersion());
	}
}

void* PluginManager::GetPluginInfo()
{
  return _plugininfo;
}

void PluginManager::SetPluginInfo(void* Info)
{
   _plugininfo = Info;
}

PluginManager::~PluginManager()
{
	ClearPlugins();
}

int PluginManager::AddPluginPath(const char* path)
{
	int count = 0;

	char searchPath[MAX_PATH];
	strcpy_s(searchPath, sizeof(searchPath), path);
	PathAppend(searchPath, "\\*.dll");

	WIN32_FIND_DATA data;
	HANDLE search = FindFirstFile(searchPath, &data);

	if (search != INVALID_HANDLE_VALUE)
	{
		do
		{
			char filePath[MAX_PATH];
			strcpy_s(filePath, sizeof(filePath), path);
			PathAppend(filePath, data.cFileName);

			Plugin* plugin = new Plugin(filePath);

			if (!plugin->IsValid())
			{
				delete plugin;
			}

			else
			{
				_plugins.push_back(plugin);
				count++;
			}
		}
		while (FindNextFile(search, &data));

		FindClose(search);
	}

	return count;
}

void PluginManager::ClearPlugins()
{
	for (int i = 0; i < static_cast<int>(_plugins.size()); i++)
	{
		delete _plugins[i];
	}

	_plugins.clear();
}

bool __stdcall PluginManager::LoadPlugin(const char* FilePath)
{
	return 0;
}

int __stdcall PluginManager::GetPluginCount() const
{
	return static_cast<int>(_plugins.size());
}

const Plugin* __stdcall PluginManager::GetPlugin(int index) const
{
	if (index < GetPluginCount())
	{
		return _plugins[index];
	}

	return 0;
}