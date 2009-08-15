#include "HashData.h"
#include <string.h>

HashData::HashData() :
	_hashData(0),
	_hashSize(0)
{

}

HashData::~HashData()
{
	Clear();
}

const void* HashData::Get() const
{
	return _hashData;
}

int HashData::GetSize() const
{
	return _hashSize;
}

bool HashData::Equal(const void* hash, int size)
{
	if(size != _hashSize)
		return false;

	return memcmp(hash, _hashData, size) == 0;
}

void HashData::Set(const void* hash, int size)
{
	Clear();

	_hashData = new unsigned char[size];
	memcpy(_hashData, hash, size); 
	_hashSize = size;
}

void HashData::Clear()
{
	if (_hashData != 0)
	{
		delete[] _hashData;
		_hashData = 0;
		_hashSize = 0;
	}
}
