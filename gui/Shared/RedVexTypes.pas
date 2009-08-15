unit RedVexTypes;

interface

uses Windows, SysUtils, Classes, uToolbars;

type

 TPacketFlag = (PacketFlag_Dead,
               PacketFlag_Finalized,
               PacketFlag_Hidden,
               PacketFlag_Virtual);

 IPacket = class abstract
  procedure Delete; virtual; stdcall; abstract;
	procedure SetData(const Buffer; Size:Integer); virtual; stdcall; abstract;
	procedure ClearData; virtual; stdcall; abstract;
	function GetSize:Integer; virtual; stdcall; abstract;
	function GetData:Pointer; virtual; stdcall; abstract;
	function Clone:IPacket; virtual; stdcall; abstract;
	function IsFlagSet(flag: TPacketFlag ):Boolean; virtual; stdcall; abstract;
	procedure SetFlag(flag: TPacketFlag); virtual; stdcall; abstract;
	procedure ClearFlag(flag: TPacketFlag); virtual; stdcall; abstract;
  end;


 IModule = class
    procedure FreeModule; virtual;  stdcall;
    procedure OnRelayDataToServer(packet: IPacket; const Owner: IModule); virtual;  stdcall;
    procedure OnRelayDataToClient(packet: IPacket; const Owner: IModule); virtual;  stdcall;
    procedure Update; virtual;  stdcall;
  end;




 IProxy = class abstract
    procedure RelayDataToServer(packet: IPacket; const Owner: IModule);  virtual; stdcall; abstract;
    procedure RelayDataToClient(packet: IPacket; const Owner: IModule);  virtual; stdcall; abstract;
    function GetClientSocket: Integer; virtual; stdcall; abstract;
    function GetServerSocket: Integer; virtual; stdcall; abstract;
    function CreatePacket(Buffer: Pointer; Size:Integer): IPacket;  virtual; stdcall; abstract;
    function GetPeer: IProxy; virtual; stdcall; abstract;
  end;


PRedVexInfo = ^TRedVexInfo;
TRedVexInfo = packed record
   WriteLog: procedure (const Text:PChar); stdcall;
   GetWindowHandle: function: THandle; stdcall;
   Controller: TController;
 end;


TModuleKind = (mkRealm, mkChat, mkGame);

PPluginInfo = ^TPluginInfo;
TPluginInfo = packed record
   Name, Author: PChar;
   SDKVersion: Integer;
   Destroy: procedure(PluginInfo:PPluginInfo); stdcall;
   Create: function(Proxy: IProxy; Kind:TModuleKind):IModule; stdcall;
 end;



//You should keep this string for security reasons
const ConstPatchString = 'q9fvn4q2hb3456223434hs0sj3q5gfamkzc32vhsdpopdj028qhe';

//Use a var so it the string doesn't appear twice
var PatchString:PChar;


procedure FreeList(List: TList);

function GetDword(Data: PChar; index: Cardinal): Cardinal; inline;
function GetWord(Data: PChar; index: Cardinal): Word; inline;

implementation

function GetDword(Data: PChar; index: Cardinal): Cardinal;
begin
  Result := Cardinal((@Data[index])^)
end;

function GetWord(Data: PChar; index: Cardinal): Word;
begin
  Result := Word((@Data[index])^)
end;

procedure FreeList(List: TList);
var P:Pointer;
    i:Cardinal;
begin
  for i := 0 to List.Count - 1 do
   begin
     P := List[i];
     List[i] := nil;
     Dispose(P);
   end;
  List.Free;
end;

procedure IModule.FreeModule;
begin
 Free;
end;

procedure IModule.OnRelayDataToServer(packet: IPacket; const Owner: IModule);
begin
end;

procedure IModule.OnRelayDataToClient(packet: IPacket; const Owner: IModule);
begin
end;

procedure IModule.Update;
begin
end;

initialization
   PatchString := ConstPatchString;

end.
