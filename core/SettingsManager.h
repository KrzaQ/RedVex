#pragma once
#include <windows.h>

class SettingsManager
{
public:
	SettingsManager();

	void Load(const char* filename);
	void Save(const char* filename);

	const char* GetServerName() const;
	int GetServerPort() const;
	int GetChatProxyPort() const;
	int GetRealmProxyPort() const;
	int GetGameProxyPort() const;
	const char* GetWindowTitle() const;
	COLORREF GetWindowForegroundColor() const;
	COLORREF GetWindowBackgroundColor() const;

	void SetServerName(const char* serverName);
	void SetServerPort(int serverPort);
	void SetChatProxyPort(int chatProxyPort);
	void SetRealmProxyPort(int realmProxyPort);
	void SetGameProxyPort(int gameProxyPort);
	void SetWindowTitle(const char* windowTitle);
	void SetWindowForegroundColor(COLORREF color);
	void SetWindowBackgroundColor(COLORREF color);

	static const char* DefaultWindowTitle;
	static const char* DefaultServerName;
	static const int DefaultServerPort = 6112;
	static const int DefaultChatProxyPort = 6112;
	static const int DefaultRealmProxyPort = 5000;
	static const int DefaultGameProxyPort = 4000;
	static const COLORREF DefaultWindowForegroundColor = RGB(192, 192, 192);
	static const COLORREF DefaultWindowBackgroundColor = RGB(0, 0, 0);

private:
	static const char* BuildPath(const char* filename);

	COLORREF _windowBackgroundColor;
	COLORREF _windowForegroundColor;
	char _windowTitle[256];
	char _serverName[256];
	int _serverPort;
	int _chatProxyPort;
	int _realmProxyPort;
	int _gameProxyPort;
};
