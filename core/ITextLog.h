#pragma once

class ITextLog
{
public:
	virtual void Write(const char* text) = 0;
};