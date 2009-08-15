#include "Command.h"
#include <string.h>

Command::Command(const char* commandLine) :
	_tokens(0)
{
	Parse(commandLine);
}

Command::Command()
{

}

Command::~Command()
{
	Clear();
}

int Command::Parse(const char* commandLine, const char* delimiters)
{
	// clear any parameters that may already be in the command
	Clear();

	// allocate and store off a local version of the command line string
	int commandLineLength = static_cast<int>(strlen(commandLine));
	_tokens = new char[commandLineLength + 1];
	strcpy_s(_tokens, commandLineLength + 1, commandLine);

	// parse out the individual parameters in the command line string
	char* locale = 0;
	char* token = strtok_s(_tokens, delimiters, &locale);
	while (token != 0)
	{
		_parameters.push_back(token);
		token = strtok_s(0, delimiters, &locale);
	}
	
	return GetParameterCount();
}

void Command::Clear()
{
	_parameters.clear();

	if (_tokens != 0)
	{
		delete[] _tokens;
		_tokens = 0;
	}
}

char* Command::GetParameter(int index, char* parameter, int size) const
{
	if (index < GetParameterCount())
	{
		strcpy_s(parameter, size, _parameters[index]);
	}
	else
	{
		parameter[0] = '\0';
	}

	return parameter;
}

const char* Command::GetParameter(int index) const
{
	if (index < GetParameterCount())
	{
		return _parameters[index];
	}

	return 0;
}

int Command::GetParameterCount() const
{
	return static_cast<int>(_parameters.size());
}

int Command::FindParameter(const char* parameter, bool caseSensitive) const
{
	for (int i = 0; i < GetParameterCount(); i++)
	{
		if (caseSensitive)
		{
			if (strcmp(parameter, GetParameter(i)) == 0)
			{
				return i;
			}
		}

		else
		{
			if (_stricmp(parameter, GetParameter(i)) == 0)
			{
				return i;
			}
		}
	}

	return -1;
}

bool Command::HasParameter(const char* parameter, bool caseSensitive) const
{
	return FindParameter(parameter, caseSensitive) > -1;
}