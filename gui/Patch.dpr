program polyrun;

uses
  SysUtils,
  Windows,
  Classes,
  uPatchFile in 'uPatchFile.pas';

  
{$APPTYPE CONSOLE}

{$R RedVex.res}

const PatchString = 'q9fvn4q2hb3456223434hs0sj3q5gfamkzc32vhsdpopdj028qhe';


var Path:String;
    ParamName:String;
   Sr : TSearchRec;
   Error:Integer;
begin

 if ParamCount = 0 then
  begin
    Writeln('Drag''n drop the main executable on this file.');
    ReadLn;
  end
 else
  begin
 WriteLn('Patching files for safety...'); 
  
 Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(1)));

 ParamName := ExtractFileName(ParamStr(1));

 PatchFile(Path + ParamName);

 ParamName := Copy(ParamName, 1, Length(ParamName)- 4 );

 PatchFile(Path + ParamName+'.dll');

 Error := FindFirst(Path+'Plugins\*.dll',0,Sr);

  while Error = 0 do
   begin

    PatchFile(Path + 'Plugins\'+Sr.Name);
    
    Error := FindNext(Sr);

   end;

   Writeln('Patching complete.');
   Readln;
   
  end;

  StrLen(PatchString) 
end.
