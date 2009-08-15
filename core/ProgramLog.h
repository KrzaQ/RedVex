#pragma once

typedef void(__stdcall *WriteLog)(const char* text);

class ProgramLog
{
public:
	ProgramLog();

    void WriteTo(const char* text);
	void Write(const char* format, ...);
	void Dump(const void* data, int size, int columns = 16);
private:
	static int CalculateTextDumpSize(int size, int columns);
	static int DumpDataAsText(const void* dataIn, int sizeIn, char* dataOut, int sizeOut, int columns);
};
