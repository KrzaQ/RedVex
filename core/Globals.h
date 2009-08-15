#pragma once
#include "ProgramLog.h"

struct OwnerInfo{
	WriteLog LogWrite;
    unsigned int WindowHandle;
    const char* PluginPath;
};

extern OwnerInfo Owner;
extern const char VersionString[];
extern const int SdkVersion;
extern ProgramLog Log;
extern const char PatchRegion[];
