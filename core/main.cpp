#include "Globals.h"
#include "PluginManager.h"
#include "Plugin.h"
#include "ProxyThread.h"

struct ReturnOwnerInfo{
	void* StartProxy;
    void* StopProxy;
	PluginManager* Manager;
};

ReturnOwnerInfo ResultInfo;

BOOL WINAPI DllMain(HINSTANCE hDll,DWORD dwReason,LPVOID lpReserved)
{
	return true;
}

void __stdcall StartProxy(const char* LocalName, const char* ServerName, 
int chatClientPort, int realmClientPort, int gameClientPort,
int chatServerPort, int realmServerPort, int gameServerPort)
{
		// allocate and create the proxy thread
	Thread = new ProxyThread(LocalName, ServerName);

	Thread->ChatClientPort = chatClientPort;
	Thread->RealmClientPort = realmClientPort;
	Thread->GameClientPort = gameClientPort;

	Thread->ChatServerPort = chatServerPort;
	Thread->RealmServerPort = realmServerPort;
	Thread->GameServerPort = gameServerPort;

	Thread->Create(false);
}

void __stdcall StopProxy()
{
		// tell the thread to abort and wait for it to finish running
		Thread->Abort();
        Thread->Join();

		// deallocate the thread since it's no longer needed
		delete Thread;
        Thread = 0;
}

extern "C"
{

	__declspec(dllexport) ReturnOwnerInfo* __stdcall InitCore(OwnerInfo* Info, void* PluginInfo)
	{
		Owner = *Info;

		// load the application plugin manager

		Plugins = new PluginManager;

		Plugins->SetPluginInfo(PluginInfo);

		Plugins->AddPluginPath(Owner.PluginPath);

		Plugins->DisplayPluginData();

		ResultInfo.Manager = Plugins;
		ResultInfo.StartProxy = &StartProxy;
		ResultInfo.StopProxy = &StopProxy;


		return &ResultInfo;
	}


	__declspec(dllexport) void __stdcall FreeCore()
	{
		delete Plugins;
	}

}