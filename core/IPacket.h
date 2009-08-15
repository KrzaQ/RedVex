#pragma once

class IPacket
{
public:
	enum PacketFlag
	{
		PacketFlag_Dead,
		PacketFlag_Finalized,
		PacketFlag_Hidden,
		PacketFlag_Virtual
	};

	virtual void __stdcall Delete() = 0;
	virtual void __stdcall SetData(const void* data, int size) = 0;
	virtual void __stdcall ClearData() = 0;
	virtual int __stdcall GetSize() const = 0;
	virtual const void* __stdcall GetData() const = 0;
	virtual IPacket* __stdcall Clone() const = 0;
	virtual bool __stdcall IsFlagSet(PacketFlag flag) const = 0;
	virtual void __stdcall SetFlag(PacketFlag flag) = 0;
	virtual void __stdcall ClearFlag(PacketFlag flag) = 0;
	virtual ~IPacket() {}

};