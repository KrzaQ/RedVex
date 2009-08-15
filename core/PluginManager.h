#pragma once
#include <vector>

class Plugin;

class PluginManager
{
public:
	virtual int __stdcall GetPluginCount() const;
	virtual const Plugin* __stdcall GetPlugin(int index) const;
	virtual bool __stdcall LoadPlugin(const char* FilePath);

	PluginManager(const char* path);
	PluginManager();
	~PluginManager();

	int AddPluginPath(const char* path);

	void ClearPlugins();

    void* GetPluginInfo();
    void SetPluginInfo(void* Info);

	void DisplayPluginData();

private:
	std::vector<Plugin*> _plugins;
	void* _plugininfo;
};

extern PluginManager* Plugins; 