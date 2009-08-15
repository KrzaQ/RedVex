#include "ProxyCreator.h"
#include <assert.h>
#include "Globals.h"
#include "TcpSocket.h"
#include "PacketMarshal.h"
#include "IPacket.h"

ProxyCreator::ProxyCreator(TcpSocket* client, int clientPort) :
	_state(CreatorState_Creating),
	_buffer(new unsigned char[InitialBufferSize]),
	_size(InitialBufferSize),
	_client(client),
	_clientPort(clientPort)
{
	_clientPacketMarshal = CreateClientPacketMarshal();
	_serverPacketMarshal = CreateServerPacketMarshal();
}

ProxyCreator::~ProxyCreator()
{
	// break any remaining network connections
	Disconnect();

	// deallocate the read/write buffer
	delete[] _buffer;
}

void ProxyCreator::Update()
{
	switch (GetState())
	{
		case CreatorState_Creating:
			UpdateStateCreating();
			break;
	}
}

int ProxyCreator::GetClientPort() const
{
	return _clientPort;
}

void ProxyCreator::UpdateStateCreating()
{
	assert(_client->IsValid());
	assert(_clientPacketMarshal != 0);

	IPacket* packet;
	int size;

	if ((size = _client->GetPendingReadLength()) > 0)
	{
		// resize the read buffer to make that the entire read buffer 
		// can be retrieved in one receive operation
		ResizeBuffer(size);

		// receive incoming data from the server and append it 
		// to the appropriate packet marshal for processing
		_client->Receive(_buffer, size);
		_clientPacketMarshal->AppendData(_buffer, size);
	}

	// check to see if any packets can be deserialized yet
	while ((packet = _clientPacketMarshal->Deserialize()) != 0)
	{
		// enough data was received for an entire packet
		RelayDataToServer(packet);
		delete packet;
	}

	// determine if the client connection has been closed
	TcpSocket::EventState clientState;
	_client->QueryEventState(FD_CLOSE, &clientState);

	// if the client connection was closed then close 
	// any remaining connections and switch to a disconnected state
	if (clientState.set)
	{
		Disconnect();
	}
}

void ProxyCreator::Disconnect()
{
	// break any existing connections
	if(_client != 0)
	{
		_client->Close();
		delete _client;
	}

	_client = 0;

	// packet marshals are no longer needed
	if (_clientPacketMarshal != 0)
	{
		delete _clientPacketMarshal;
		_clientPacketMarshal = 0;
	}

	// proxy is now disconnected
	SetState(CreatorState_Disconnected);
}

ProxyCreator::CreatorState ProxyCreator::GetState() const
{
	return _state;
}

void ProxyCreator::RelayDataToServer(const IPacket* packet)
{
}

void ProxyCreator::RelayDataToClient(IPacket* packet)
{
	assert(GetState() == CreatorState_Creating);
	assert(_serverPacketMarshal != 0);
	assert(packet != 0);

	int size;

	// serialize the incoming packet; if for some unexpected reason there is not
	// enough room for this operation (this should never happen) keep doubling
	// the work buffer until the operation can be completed
	while ((size = _serverPacketMarshal->Serialize(packet, _buffer, _size)) < 0)
	{
		_size *= 2;
		ResizeBuffer(_size);
	}

	// send the raw packet data to the client
	_client->Send(_buffer, size);
}

PacketMarshal* ProxyCreator::CreateClientPacketMarshal()
{
	return new PacketMarshal();
}

PacketMarshal* ProxyCreator::CreateServerPacketMarshal()
{
	return new PacketMarshal();
}

void ProxyCreator::OnStateChange(CreatorState previous, CreatorState current)
{
	switch (current)
	{
		case CreatorState_Disconnected:
			Log.Write("Client disconnected from %d at %X\n\n", GetClientPort(), this);
			break;

		case CreatorState_Creating:
			Log.Write("Searching for owner at %d at %X\n\n", GetClientPort(), this);
			break;

		case CreatorState_Error:
			Log.Write("Error: Unable to find owner at %d at %X\n\n", GetClientPort(), this);
			break;
	}
}

void ProxyCreator::ResizeBuffer(int size)
{
	if (size > _size)
	{
		delete[] _buffer;
		_buffer = new unsigned char[size];
		_size = size;
	}
}

void ProxyCreator::SetState(CreatorState state)
{
	OnStateChange(_state, state);
	_state = state;
}
