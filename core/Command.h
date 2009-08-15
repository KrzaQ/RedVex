#pragma once
#include <vector>

class Command
{
public:
	Command(const char* commandLine);
	Command();
	~Command();

	int Parse(const char* commandLine, const char* delimiters = " \t\n");
	void Clear();
	char* GetParameter(int index, char* parameter, int size) const;
	const char* GetParameter(int index) const;
	int GetParameterCount() const;
	int FindParameter(const char* parameter, bool caseSensitive = false) const;
	bool HasParameter(const char* parameter, bool caseSensitive = false) const;

private:
	std::vector<const char*> _parameters;
	char* _tokens;
};
