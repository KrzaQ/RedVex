unit uPatchFile;

interface

uses Classes, SysUtils;

const
SearchForLen = 52;
SearchFor = 'q9fvn4q2hb3456223434hs0sj3q5gfamkzc32vhsdpopdj028qhe';
FirstCh = 'q';

procedure PatchFile(Filename:String);

implementation

procedure PatchFile(Filename:String);
var
  FFilePos:Integer;
  Range : longint;
  WriteStream, ReadStream: TFileStream;
  Skip : boolean;
  FBuf: array[0..1023] of byte;
  New: array[0..SearchForLen] of byte;
  ChArray: PChar;

  procedure ScanBuffer;
  var i : longint;

    procedure CheckName;
    var AChArray: array[0..SearchForLen-1] of byte;
    begin
      if i + SearchForLen > Range - 1 then
      begin
        ReadStream.Seek(WriteStream.Position-Range+i, soFromBeginning);
        if ReadStream.Read(AChArray, SearchForLen) <>
                   SearchForLen then exit;
        ChArray := @AChArray
      end else
        ChArray := Pointer(Longint(@FBuf)+i);
      if StrLComp(SearchFor, ChArray,SearchForLen) = 0 then
      begin
        FFilePos := WriteStream.Position-Range+i;
        Skip := true;
      end;
    end;

  begin
      for i := 0 to Range - 1 do
      begin
        if Char(Pointer(Longint(@FBuf)+i)^) = FirstCh then CheckName;
        if Skip then exit;
      end;
  end;


begin

 if not FileExists(Filename) then
    begin
      Writeln(Filename+' don''t exist.');
      Exit;
    end;

  try

  FFilePos := -1;
  WriteStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);

  ReadStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  
  Skip := False;
    with WriteStream do
     while (Position < Size - 1)
           and (not Skip) do
     begin
       Range := Read(FBuf, 1024);
       ScanBuffer;
     end;


    ReadStream.Free;
    if FFilePos <> -1 then
      begin
      
      WriteStream.Position := FFilePos;

      WriteStream.Read(New, SearchForLen);
      if StrLComp(SearchFor, @New,SearchForLen) <> 0 then
         begin
            Writeln('Found '+PChar(@New)+'. Error in search!');
            Readln;
            Halt;
         end;
      WriteStream.Position := FFilePos;

    Randomize;
    for FFilePos := 0 to SearchForLen-1 do
       begin
         case Random(3) of
             0: New[FFilePos] := 65+Random(18);
             1: New[FFilePos] := 97+Random(18);
             2: New[FFilePos] := 48+Random(8);
         end;
       end;

    New[SearchForLen] := 0;

    WriteStream.Write(New, SearchForLen);

    Writeln('Patched '+Filename+' with the key '+PChar(@New)+'.');

      end
      else
       begin
           Writeln(Filename+' is already patched.');
       end;




    WriteStream.Free;

    except
      on E:Exception do Writeln('Couldn''t open file: '+FileName);
    end;
    
 end;

end.
