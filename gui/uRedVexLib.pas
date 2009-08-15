unit uRedVexLib;

interface

uses Windows, SysUtils, Forms, Dialogs, RedVexTypes, uToolbars;

type
TLibPlugin = class abstract
  function GetFileName: PChar; virtual; stdcall; abstract;
  function GetInfo: PPluginInfo; virtual; stdcall; abstract;
  procedure Unload; virtual; stdcall; abstract;
end;

TLibPluginManager = class abstract
  function Count: Integer; virtual; stdcall; abstract;
	function Plugins(Index: Integer):TLibPlugin; virtual; stdcall; abstract;
  function LoadPlugin(const Path: PChar):Boolean;  virtual; stdcall; abstract;
end;

POwnerInfo = ^TOwnerInfo;
TOwnerInfo = packed record
	LogWrite: Pointer;
  WindowHandle: THandle;
  PluginPath: PChar;
end;

PLibInfo = ^TLibInfo;
TLibInfo = packed record
  StartProxy: procedure (LocalName, ServerName:PChar; ChatClientPort, RealmClientPort, GameClientPort, ChatServerPort, RealmServerPort, GameServerPort:Integer); stdcall;
  StopProxy: procedure; stdcall;
  Manager: TLibPluginManager;
end;

var OwnerInfo:TOwnerInfo;
    ClientInfo: TRedVexInfo;
    LibInfo: PLibInfo;
    LibHandle: THandle;

procedure InitRedVexLibrary;
procedure FreeRedVexLibrary;

implementation

function IsClass(Obj: TObject; Cls: TClass): Boolean;
var
  Parent: TClass;
begin
  Parent := Obj.ClassType;
  while (Parent <> nil) and (Parent.ClassName <> Cls.ClassName) do
    Parent := Parent.ClassParent;
  Result := Parent <> nil;  
end;

procedure InitRedVexLibrary;

var InitProc: function(Info: POwnerInfo; PluginInfo: PRedVexInfo):PLibInfo; stdcall;
    Buffer: array[0..1023] of Char;
begin
  InitProc := GetProcAddress(LibHandle, '_InitCore@8');

  try
     if Assigned(InitProc) then
       LibInfo := InitProc(@OwnerInfo, @ClientInfo)
     else
       raise Exception.Create('InitCore doesn''t exists.');

   except
     if IsClass(ExceptObject, Exception) then
        ShowMessage('Can''t load RedVex Library!'#13#10#13#10+Exception(ExceptObject).Message)
     else
        begin
           ExceptionErrorMessage(ExceptObject, ExceptAddr, Buffer, SizeOf(Buffer));
           ShowMessage('Can''t load RedVex Library!'#13#10#13#10+PChar(@Buffer[0]))
        end;
   end;
end;

procedure FreeRedVexLibrary;

var FreeProc: procedure; stdcall;

begin
  FreeProc := GetProcAddress(LibHandle, '_FreeCore@0');

  if Assigned(FreeProc) then
     FreeProc;
end;

initialization
  LibHandle := LoadLibrary(PChar(ChangeFileExt(Application.ExeName, '.dll')));

finalization
  FreeLibrary(LibHandle);

end.
