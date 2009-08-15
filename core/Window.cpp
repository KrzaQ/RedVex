#pragma warning(disable: 4311 4312)
#include "Window.h"

Window::Window() :
	_className(0),
	_handle(0)
{

}

Window::~Window()
{

}

int Window::Register(HINSTANCE instance, int style, HICON icon32, HICON icon16, 
					 HCURSOR cursor, HBRUSH background, int menuId, const char* className)
{
	Unregister();

	int size = static_cast<int>(strlen(className) + 1);
	_className = new char[size];
	strcpy_s(_className, size, className);

	_windowClass.cbSize = sizeof(WNDCLASSEX);
	_windowClass.style = style;
	_windowClass.lpfnWndProc = reinterpret_cast<WNDPROC>(Router);
	_windowClass.cbClsExtra = 0;
	_windowClass.cbWndExtra = 0;
	_windowClass.hInstance = instance;
	_windowClass.hIcon = icon32;
	_windowClass.hIconSm = icon16;
	_windowClass.hCursor = cursor;
	_windowClass.hbrBackground = background;
	_windowClass.lpszMenuName = MAKEINTRESOURCE(menuId);
	_windowClass.lpszClassName = _className;

	return RegisterClassEx(&_windowClass);
}

void Window::Unregister()
{
	if (_className != 0)
	{
		UnregisterClass(_className, _windowClass.hInstance);
		delete[] _className;
		_className = 0;
	}
}

HWND Window::Create(const char* windowName, int style, int styleExtra, 
					int x, int y, int width, int height, HWND parent, HMENU menu)
{
	_handle = CreateWindowEx(styleExtra, _className, windowName, style, x, y, 
		width, height, parent, menu, _windowClass.hInstance, this);

	return _handle;
}

int __stdcall Window::Router(HWND handle, int message, WPARAM wParam, LPARAM lParam)
{
	Window* window = 0;

	if (message == WM_CREATE)
	{
		CREATESTRUCT* createData = reinterpret_cast<CREATESTRUCT*>(lParam);
		window = static_cast<Window*>(createData->lpCreateParams);
		SetWindowLong(handle, GWL_USERDATA, reinterpret_cast<long>(window));
	}

	else 
	{
		window = reinterpret_cast<Window*>(GetWindowLong(handle, GWL_USERDATA));
	}

	if (window == 0)
	{
		return static_cast<int>(DefWindowProc(handle, message, wParam,lParam));
	}

	window->_handle = handle;
	return window->Callback(message, wParam, lParam);
}

int Window::CallDefaultCallback(int message, WPARAM wParam, LPARAM lParam)
{
	return static_cast<int>(DefWindowProc(GetHandle(), message, wParam, lParam));
}

HWND Window::GetHandle() const
{
	return _handle;
}