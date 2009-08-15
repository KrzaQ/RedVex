#pragma warning(disable: 4311 4312)
#include "Dialog.h"

std::list<Dialog*> Dialog::_dialogs;

Dialog::Dialog(int resourceId) :
	_resourceId(resourceId),
	_handle(0),
	_type(DialogType_None)
{
	_dialogs.push_back(this);
}

Dialog::~Dialog()
{
	_dialogs.remove(this);	
}

int Dialog::CreateModal(HINSTANCE instance, HWND parent)
{
	_type = DialogType_Modal;

	return static_cast<int>(DialogBoxParam(instance, MAKEINTRESOURCE(_resourceId), parent, 
		reinterpret_cast<DLGPROC>(Router), reinterpret_cast<LPARAM>(this)));
}

HWND Dialog::CreateModeless(HINSTANCE instance, HWND parent)
{
	_type = DialogType_Modeless;

	_handle = CreateDialogParam(instance, MAKEINTRESOURCE(_resourceId), parent, 
		reinterpret_cast<DLGPROC>(Router), reinterpret_cast<LPARAM>(this));

	return _handle;
}

HWND Dialog::GetHandle() const
{
	return _handle;
}

int __stdcall Dialog::Router(HWND window, int message, WPARAM wParam, LPARAM lParam)
{
	Dialog* dialog = 0;

	if (message == WM_INITDIALOG)
	{
		dialog = reinterpret_cast<Dialog*>(lParam);
		SetWindowLong(window, DWL_USER, reinterpret_cast<long>(dialog));
	}

	else 
	{
		dialog = reinterpret_cast<Dialog*>(GetWindowLong(window, DWL_USER));
	}

	if (dialog == 0)
	{
		return false;
	}

	dialog->_handle = window;
	return dialog->Callback(message, wParam, lParam);
}

bool Dialog::ProcessMessage(MSG* message)
{
	for (std::list<Dialog*>::iterator i = _dialogs.begin(); i != _dialogs.end(); i++)
	{
		Dialog* dialog = *i;

		if (dialog->_type == DialogType_Modeless && IsDialogMessage(dialog->_handle, message))
		{
			return true;
		}
	}

	return false;
}
