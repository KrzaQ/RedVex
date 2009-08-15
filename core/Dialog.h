#pragma once
#include <windows.h>
#include <list>

class Dialog
{
public:
	Dialog(int resourceId);
	virtual ~Dialog();

	int CreateModal(HINSTANCE instance, HWND parent);
    HWND CreateModeless(HINSTANCE instance, HWND parent);
	HWND GetHandle() const;

	static bool ProcessMessage(MSG* message);

protected:
	virtual int Callback(int message, WPARAM wParam, LPARAM lParam) = 0;

private:
	enum DialogType
	{
		DialogType_Modal,
		DialogType_Modeless,
		DialogType_None
	};

	static int __stdcall Router(HWND window, int message, WPARAM wParam, LPARAM lParam);

	static std::list<Dialog*> _dialogs;
	int _resourceId;
	DialogType _type;
	HWND _handle;
};
