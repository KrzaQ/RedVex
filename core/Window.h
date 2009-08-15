#pragma once
#include <windows.h>

class Window
{
public:
	Window();
	virtual ~Window();

	int Register(HINSTANCE instance, int style, HICON icon32, HICON icon16, 
		HCURSOR cursor, HBRUSH background, int menuId, const char* className);
	void Unregister();

	HWND Create(const char* windowName, int style, int styleExtra, 
		int x, int y, int width, int height, HWND parent, HMENU menu);
	HWND GetHandle() const;
		
protected:
	virtual int Callback(int message, WPARAM wParam, LPARAM lParam) = 0;
	int CallDefaultCallback(int message, WPARAM wParam, LPARAM lParam);

private:
	static int __stdcall Router(HWND handle, int message, WPARAM wParam, LPARAM lParam);

	WNDCLASSEX _windowClass;
	char* _className;
	HWND _handle;
};