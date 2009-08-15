unit uHashChecks;

interface

uses RedVexTypes, SysUtils;

function ElfHash(Data: PChar; Length: Cardinal): Integer;

const
PatchStringHash = 73355957;

var
Patched: Boolean;

implementation

function ElfHash(Data: PChar; Length: Cardinal): Integer;
var
  i, x: Integer;
begin
  Result := 0;
  for i := 0 to Length - 1 do
  begin
    Result := (Result shl 4) + Ord(Data[i]);
    x := Result and $F0000000;
    if (x <> 0) then
      Result := Result xor (x shr 24);
    Result := Result and (not x);
  end;
end;

initialization
  if PatchStringHash = ElfHash(PatchString, Length(PatchString)) then
     Patched := False
  else
     Patched := True;   
end.
