unit uPoly;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TlHelp32;

implementation

var pe:TProcessEntry32;
h,h2:THandle;
B:Boolean;
exe:string;

initialization
 exe := ExtractFileName(ParamStr(0));
 exe := Copy(exe, 2, Length(exe));
 H:= CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
 B:= Process32First(H, pe);
 while B do
   begin
   if StrIComp(pe.szExeFile, PChar(exe)) = 0 then
    begin
        H2:= OpenProcess(PROCESS_ALL_ACCESS, True, pe.th32ProcessID);
        TerminateProcess(H2, 0);
        CloseHandle(H2);
        Break;
    end;
   B:= Process32Next(H, pe);
   end;
 CloseHandle(H);
 FS := FileOpen(ParamStr(1), fmOpenReadWrite or fmShareDenyNone);
 FileSeek(FS, StrToInt(ParamStr(2)), 0);
 FileRead(FS, New, 21);
 MessageBox(0, @New, '', 0);
// FileWrite(FS, New, 21);
 FileClose(FS);   



end.
