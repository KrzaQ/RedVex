
class HashData
{
	private:
		unsigned char* _hashData;
		int _hashSize;
	public:
		HashData();
		~HashData();

		const void* Get() const;
		int GetSize() const;
		void Set(const void* hash, int size);
		bool Equal(const void* hash, int size);
		void Clear();
};
