unit uAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RandomHandle, ExtCtrls, StdCtrls;

type
  TAbout = class(TRandomForm)
    Image: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

uses uMain;

{$R *.dfm}

procedure TAbout.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TAbout.FormCreate(Sender: TObject);
begin
SystemFont(Font);
end;

end.
