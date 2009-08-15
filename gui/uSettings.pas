unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, RandomHandle, WinSock;

type
  TOptions = class(TRandomForm)
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    PServer: TComboBox;
    Label2: TLabel;
    ColorDialog: TColorDialog;
    GroupBox4: TGroupBox;
    LogFont: TShape;
    Label9: TLabel;
    Label10: TLabel;
    LogBack: TShape;
    FontDialog: TFontDialog;
    FontChange: TButton;
    GridPanel: TGridPanel;
    FontSample: TLabel;
    LogSelBack: TShape;
    Label1: TLabel;
    sGame: TEdit;
    Label6: TLabel;
    sRealm: TEdit;
    Label5: TLabel;
    Label4: TLabel;
    sChat: TEdit;
    GroupBox2: TGroupBox;
    cGame: TEdit;
    Label8: TLabel;
    cRealm: TEdit;
    Label11: TLabel;
    cChat: TEdit;
    Label12: TLabel;
    PClient: TComboBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    WindowTitle: TEdit;
    Label7: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure ColorShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FontChangeClick(Sender: TObject);
  private
    procedure SetupHostNames;
  public
  end;

var
  Options: TOptions;

function DefaultHost: string;

implementation

uses uMain;

{$R *.dfm}

procedure TOptions.btnOKClick(Sender: TObject);
begin

Settings.WriteString('GUI', 'Title', WindowTitle.Text);

Settings.WriteString('GUI', 'Background', ColorToString(LogBack.Brush.Color));
Settings.WriteString('GUI', 'SelBackground', ColorToString(LogSelBack.Brush.Color));
Settings.WriteString('GUI', 'Foreground', ColorToString(LogFont.Brush.Color));
Settings.WriteString('GUI', 'Font', FontSample.Font.Name);
Settings.WriteInteger('GUI', 'FontSize', FontSample.Font.Size);
Settings.WriteBool('GUI', 'FontBold', fsBold in FontSample.Font.Style);
Settings.WriteBool('GUI', 'FontItalic', fsItalic in FontSample.Font.Style);

Settings.WriteString('Proxy', 'Server', PServer.Text);
Settings.WriteInteger('Proxy', 'ChatServerPort', StrToIntDef(sChat.Text, 6112));
Settings.WriteInteger('Proxy', 'RealmServerPort', StrToIntDef(sRealm.Text, 6112));
Settings.WriteInteger('Proxy', 'GameServerPort', StrToIntDef(sGame.Text, 4000));

Settings.WriteString('Proxy', 'Client', PClient.Text);
Settings.WriteInteger('Proxy', 'ChatClientPort', StrToIntDef(cChat.Text, 6112));
Settings.WriteInteger('Proxy', 'RealmClientPort', StrToIntDef(cRealm.Text, 6113));
Settings.WriteInteger('Proxy', 'GameClientPort', StrToIntDef(cGame.Text, 4000));


MainForm.LoadSettings;

Close;
end;

procedure TOptions.btnCancelClick(Sender: TObject);
begin
Close;
end;

procedure TOptions.FontChangeClick(Sender: TObject);
begin
FontDialog.Font.Assign(FontSample.Font);
if FontDialog.Execute then
 begin
    FontSample.Font.Assign(FontDialog.Font);
    FontSample.Font.Color := LogFont.Brush.Color;
 end;
end;

type
  PPInteger = ^PInteger;

function GetHost: PHostEnt;
var
  HostName: array [0..255] of Char;
begin
  if gethostname(@HostName[0], Length(HostName)) = SOCKET_ERROR then
    raise Exception.Create('Socket Error');

  Result := gethostbyname(HostName);
end;

function DefaultHost: string;
var
  Host: PHostEnt;
  IP: PPInteger;
begin
  Result := 'localhost';
  
  try
    Host := GetHost;

    IP := PPInteger(Host.h_addr_list);

    if IP^ = nil then
      raise Exception.Create('No hosts');

    Result := inet_ntoa(in_addr(IP^^));
  except
    on E: Exception do;
  end;
end;

procedure TOptions.SetupHostNames;
var
  Host: PHostEnt;
  IP: PPInteger;
begin
  PClient.Items.Clear;

  try
    Host := GetHost;

    IP := PPInteger(Host.h_addr_list);

    while IP^ <> nil do
      begin
        PClient.Items.Add(inet_ntoa(in_addr(IP^^)));

        Inc(IP);
      end;
  except
    on E: Exception do;
  end;
end;

procedure TOptions.FormCreate(Sender: TObject);
begin
  SystemFont(Font);

  WindowTitle.Text := MainForm.Caption;

  PServer.Text := MainForm.ProxyServer;
  PClient.Text := MainForm.LocalName;

  SetupHostNames;

  sChat.Text := IntToStr(MainForm.ProxyChatServerPort);
  sRealm.Text := IntToStr(MainForm.ProxyRealmServerPort);
  sGame.Text := IntToStr(MainForm.ProxyGameServerPort);

  cChat.Text := IntToStr(MainForm.ProxyChatClientPort);
  cRealm.Text := IntToStr(MainForm.ProxyRealmClientPort);
  cGame.Text := IntToStr(MainForm.ProxyGameClientPort);

  LogBack.Brush.Color := MainForm.Log.Color;
  LogSelBack.Brush.Color := MainForm.Log.SelectedColor.Background;
  LogFont.Brush.Color := MainForm.Log.Font.Color;
  FontSample.Font.Assign(MainForm.Log.Font);

  GridPanel.Color := LogBack.Brush.Color;
  FontSample.Font.Color := LogFont.Brush.Color;
end;

procedure TOptions.ColorShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
ColorDialog.Color := (Sender as TShape).Brush.Color;
if ColorDialog.Execute then
 (Sender as TShape).Brush.Color := ColorDialog.Color;

GridPanel.Color := LogBack.Brush.Color;
FontSample.Font.Color := LogFont.Brush.Color;
end;

var WSAData: TWSAData;

initialization
   if WSAStartup(MakeWord(2, 2), WSAData) <> NOERROR then
      raise Exception.Create('Unable to start WinSock!');

finalization
   WSACleanup;

end.
