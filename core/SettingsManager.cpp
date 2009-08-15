#include "SettingsManager.h"
#include <windows.h>
#include <shlwapi.h>

const char* SettingsManager::DefaultWindowTitle = "RedVex";
const char* SettingsManager::DefaultServerName = "uswest.battle.net";

SettingsManager::SettingsManager() :
	_serverPort(DefaultServerPort),
	_chatProxyPort(DefaultChatProxyPort),
	_realmProxyPort(DefaultRealmProxyPort),
	_gameProxyPort(DefaultGameProxyPort),
	_windowBackgroundColor(DefaultWindowBackgroundColor),
	_windowForegroundColor(DefaultWindowForegroundColor)
{
	SetServerName(DefaultServerName);
	SetWindowTitle(DefaultWindowTitle);
}

void SettingsManager::Load(const char* filename)
{
	const char* path = BuildPath(filename);
	char bufferIn[16];
	char bufferOut[16];

	// load logon server data
	GetPrivateProfileString("Logon server", "Name", DefaultServerName, _serverName, sizeof(_serverName), path);

	_itoa_s(DefaultServerPort, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Logon server", "Port", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetServerPort(atoi(bufferIn));

	// load proxy port data
	_itoa_s(DefaultChatProxyPort, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Proxy ports", "Chat", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetChatProxyPort(atoi(bufferIn));
	
	_itoa_s(DefaultRealmProxyPort, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Proxy ports", "Realm", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetRealmProxyPort(atoi(bufferIn));

	_itoa_s(DefaultGameProxyPort, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Proxy ports", "Game", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetGameProxyPort(atoi(bufferIn));

	// read window data
	GetPrivateProfileString("Window", "Title", DefaultWindowTitle, _windowTitle, sizeof(_windowTitle), path);

	_itoa_s(DefaultWindowForegroundColor, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Window", "Foreground color", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetWindowForegroundColor(atoi(bufferIn));

	_itoa_s(DefaultWindowBackgroundColor, bufferOut, sizeof(bufferOut), 10);
	GetPrivateProfileString("Window", "Background color", bufferOut, bufferIn, sizeof(bufferIn), path);
	SetWindowBackgroundColor(atoi(bufferIn));
}

void SettingsManager::Save(const char* filename)
{
	const char* path = BuildPath(filename);
	char buffer[16];

	// save logon server data
	WritePrivateProfileString("Logon server", "Name", _serverName, path);

	_itoa_s(GetServerPort(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Logon server", "Port", buffer, path);

	// save proxy port data
	_itoa_s(GetChatProxyPort(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Proxy ports", "Chat", buffer, path);

	_itoa_s(GetRealmProxyPort(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Proxy ports", "Realm", buffer, path);

	_itoa_s(GetGameProxyPort(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Proxy ports", "Game", buffer, path);

	// save window data
	WritePrivateProfileString("Window", "Title", GetWindowTitle(), path);

	_itoa_s(GetWindowForegroundColor(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Window", "Foreground color", buffer, path);

	_itoa_s(GetWindowBackgroundColor(), buffer, sizeof(buffer), 10);
	WritePrivateProfileString("Window", "Background color", buffer, path);
}

const char* SettingsManager::BuildPath(const char* filename)
{
	static char path[MAX_PATH]; 

	GetCurrentDirectory(sizeof(path), path);
	PathAppend(path, filename);

	return path;
}

const char* SettingsManager::GetServerName() const
{
	return _serverName;
}

int SettingsManager::GetServerPort() const
{
	return _serverPort;
}

int SettingsManager::GetChatProxyPort() const
{
	return _chatProxyPort;
}

int SettingsManager::GetRealmProxyPort() const
{
	return _realmProxyPort;
}

int SettingsManager::GetGameProxyPort() const
{
	return _gameProxyPort;
}

const char* SettingsManager::GetWindowTitle() const
{
	return _windowTitle;
}

COLORREF SettingsManager::GetWindowForegroundColor() const
{
	return _windowForegroundColor;
}

COLORREF SettingsManager::GetWindowBackgroundColor() const
{
	return _windowBackgroundColor;
}

void SettingsManager::SetServerName(const char* serverName)
{
	strcpy_s(_serverName, sizeof(_serverName), serverName);
}

void SettingsManager::SetServerPort(int serverPort)
{
	_serverPort = serverPort;
}

void SettingsManager::SetChatProxyPort(int chatProxyPort)
{
	_chatProxyPort = chatProxyPort;
}

void SettingsManager::SetRealmProxyPort(int realmProxyPort)
{
	_realmProxyPort = realmProxyPort;
}

void SettingsManager::SetGameProxyPort(int gameProxyPort)
{
	_gameProxyPort = gameProxyPort;
}

void SettingsManager::SetWindowTitle(const char* windowTitle)
{
	strcpy_s(_windowTitle, sizeof(_windowTitle), windowTitle);
}

void SettingsManager::SetWindowForegroundColor(COLORREF color)
{
	_windowForegroundColor = color;
}

void SettingsManager::SetWindowBackgroundColor(COLORREF color)
{
	_windowBackgroundColor = color;
}