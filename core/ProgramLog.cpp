#include "ProgramLog.h"
#include "Globals.h"
#include <stdio.h>
#include <stdarg.h>
#include <memory.h>
#include <ctype.h>
#include <string.h>
#include "ITextLog.h"


ProgramLog::ProgramLog()
{

}

void ProgramLog::WriteTo(const char* text)
{
    Owner.LogWrite(text);
}

void ProgramLog::Write(const char* format, ...)
{
		char text[4096];
		va_list arguments;

		va_start(arguments, format);
		vsprintf_s(text, sizeof(text), format, arguments);
		WriteTo(text);
		va_end(arguments);
}

void ProgramLog::Dump(const void* data, int size, int columns)
{
		int textSize = CalculateTextDumpSize(size, columns);
		char* text = new char[textSize];

		DumpDataAsText(data, size, text, textSize, columns);
		WriteTo(text);

		delete[] text;
}

int ProgramLog::CalculateTextDumpSize(int size, int columns)
{
	int rows = size / columns;

	if (size % columns > 0)
		rows++;

	return columns * rows * 4 + rows * 3 + 1;
}

int ProgramLog::DumpDataAsText(const void* dataIn, int sizeIn, char* dataOut, int sizeOut, int columns)
{
	if (sizeOut < CalculateTextDumpSize(sizeIn, columns))
		return -1;

	// zero out the destination data to be safe
	memset(dataOut, 0, sizeOut);

	const unsigned char* bytesIn = static_cast<const unsigned char*>(dataIn);
	int offset = 0;

	for (int i = 0; i < sizeIn; i += columns)
	{
		// print out hexadecimal representation for the current row
		for (int j = 0; j < columns; j++)
		{
			if (i + j < sizeIn)
			{
				sprintf_s(dataOut + offset, sizeOut - offset, "%.2x ", bytesIn[i + j]);
			}

			else
			{
				strcat_s(dataOut + offset, sizeOut - offset, "   ");
			}

			offset += 3;
		}

		// seperate hexadecimal representation from ascii representation with a tab
		dataOut[offset++] = '\t';

		// print out ascii representation for the current row
		for (int j = 0; j < columns; j++)
		{
			unsigned char temp = ' ';
			
			if (i + j < sizeIn)
			{
				if (isprint(bytesIn[i + j]))
				{
					temp = bytesIn[i + j];
				}

				else
				{
					temp = '.';
				}
			}
			
			dataOut[offset++] = temp;
		}	

		// insert line break at the end of the row
		dataOut[offset++] = 0x0d;
		dataOut[offset++] = 0x0a;
	}

	// terminate the output string
	dataOut[offset++] = 0;

	return offset;
}
