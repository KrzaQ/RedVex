unit RandomHandle;

interface

uses Windows, Messages, Forms, Controls;


type TRandomForm = class(TForm)
 protected
    procedure CreateParams(var Params: TCreateParams); override;
end;


implementation


procedure TRandomForm.CreateParams(var Params: TCreateParams);
var i,m:Integer;
begin
  inherited CreateParams(Params);
  m := 10+Random(20);
  Params.WinClassName[m+1] := #0;
  for i := 0 to m do
 begin
 case Random(3) of
  0: Params.WinClassName[i] := Char(65+Random(18));
  1: Params.WinClassName[i] := Char(97+Random(18));
  2: Params.WinClassName[i] := Char(48+Random(8));
 end;
 end;
end;



end.
