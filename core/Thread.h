#pragma once
#include <windows.h>

class Thread
{
public:
	Thread();
	virtual ~Thread();

	bool Create(bool suspended);
	void Abort();
	void Join();
	bool Pause();
	bool Resume();
	bool IsRunning() const;
	bool IsAborting() const;
	int GetResult() const;

protected:
	virtual int Routine() = 0;

private:
	static int Router(void* data);

	HANDLE _handle;
	int _result;
	bool _running;
	volatile bool _aborting;
	int _id;
};