unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, Forms, StdCtrls, ImgList, Registry, IniFiles, TBXGraphics, TB2Item, TBX,
  ActnList, Menus, ExtCtrls, ComCtrls, TB2Dock, TB2Toolbar,
  uWindowManager, RandomHandle, StrUtils, uToolbarsClasses,
  uToolbars, SynEdit, SynMemo, RedVexTypes;

{$R *.dfm}

 type
  TMainForm = class(TRandomForm)
    TrayIcon: TTrayIcon;
    tbxDock: TTBXDock;
    tblTabs: TTBXToolbar;
    tbxMainMenu: TTBXToolbar;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    TBXSubmenuItem3: TTBXSubmenuItem;
    TBXItem2: TTBXItem;
    TBXItem3: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXItem4: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    TBXItem7: TTBXItem;
    TBXItem8: TTBXItem;
    tbxProxy: TTBXToolbar;
    ActionList: TActionList;
    ProxyStart: TAction;
    ProxyStop: TAction;
    TrayIconPopupMenu: TTBXPopupMenu;
    TBXItem9: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXItem10: TTBXItem;
    TBXItem11: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXItem12: TTBXItem;
    ProxyQuit: TAction;
    TBXItem13: TTBXItem;
    TBXItem14: TTBXItem;
    tblPlugin: TTBXToolbar;
    TBXItem15: TTBXItem;
    TBXItem16: TTBXItem;
    TBXItem17: TTBXItem;
    Plugins: TListView;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXItem18: TTBXItem;
    SettingsOptions: TAction;
    SettingsRealms: TAction;
    HelpAbout: TAction;
    TrayIconOpen: TAction;
    LogCopy: TAction;
    LogPopupMenu: TTBXPopupMenu;
    TBXItem19: TTBXItem;
    ProxyCloseToTray: TAction;
    PluginsRefresh: TAction;
    PluginsReload: TAction;
    PluginsEnable: TAction;
    PluginsDisable: TAction;
    SettingsPlugins: TAction;
    TBXItem1: TTBXItem;
    LogTimer: TTimer;
    ImagesToolbar: TTBXImageList;
    ImagesPlugins: TTBXImageList;
    Log: TSynEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadSettings;
    procedure ConfigurePlugins1Click(Sender: TObject);
    procedure ProxyQuitExecute(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClosePlugins(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure LogCopyExecute(Sender: TObject);
    procedure ShowPlugins(Sender: TObject);
    procedure PluginsDisableExecute(Sender: TObject);
    procedure PluginsDisableUpdate(Sender: TObject);
    procedure PluginsEnableExecute(Sender: TObject);
    procedure PluginsEnableUpdate(Sender: TObject);
    procedure PluginsRefreshExecute(Sender: TObject);
    procedure PluginsReloadExecute(Sender: TObject);
    procedure PluginsReloadUpdate(Sender: TObject);
    procedure ProxyCloseToTrayExecute(Sender: TObject);
    procedure ProxyStartExecute(Sender: TObject);
    procedure ProxyStartUpdate(Sender: TObject);
    procedure ProxyStopExecute(Sender: TObject);
    procedure ProxyStopUpdate(Sender: TObject);
    procedure SettingsOptionsExecute(Sender: TObject);
    procedure SettingsPluginsExecute(Sender: TObject);
    procedure SettingsRealmsExecute(Sender: TObject);
    procedure TrayIconOpenExecute(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
  protected
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
  private
    { Private declarations }
  public
    PluginsTab: TWindowTab;
    ProxyRunning:Boolean;

    PluginFolder: String;

    ProxyServer: string;

    LocalName: string;

    ProxyChatClientPort, ProxyRealmClientPort, ProxyGameClientPort: Integer;

    ProxyChatServerPort, ProxyRealmServerPort, ProxyGameServerPort: Integer;

    Controller: TWrapperController;

    LogQuene: TThreadList;
    LogAdd:TStringList;
  end;

var
  MainForm: TMainForm;
  Settings: TIniFile;
  StartProxy:Boolean;
  AppPath: string;


procedure AddLog(const S:PChar); stdcall;
procedure SystemFont(F:TFont);
function GetWindowHandle: THandle; stdcall;

implementation

uses uRealms, uSettings, uAbout, uRedVexLib, uSetup, uHashChecks;


function GetWindowHandle: THandle; stdcall;
begin
  Result := MainForm.Handle;
end;

procedure SystemFont(F:TFont);
var
  NonClientMetrics: TNonClientMetrics;
begin
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    F.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure AddLog(const S:PChar); stdcall;
var
    Length:Integer;
    Mem:PChar;
begin
with MainForm.LogQuene.LockList do
 begin
   Length := StrLen(S);
   Mem := AllocMem(Length+1);
   System.Move(S^, Mem^, Length+1);
   Add(Mem);
 end;
MainForm.LogQuene.UnlockList;
end;

procedure TMainForm.WMQueryEndSession(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TMainForm.ConfigurePlugins1Click(Sender: TObject);
begin
Plugins.Visible := not Plugins.Visible;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Hide;
Action := caNone;
end;

procedure TMainForm.LoadSettings;
var Title: string;
begin
Title := ExtractFileName(Application.ExeName);
Title := Copy(Title, 1, Length(Title) - Length(ExtractFileExt(Title)));
Caption := Settings.ReadString('GUI', 'Title', Title);
Application.Title := Caption;

ProxyServer := Settings.ReadString('Proxy', 'Server', 'uswest.battle.net');

if Settings.ValueExists('Proxy', 'Client') then
  LocalName := Settings.ReadString('Proxy', 'Client', 'localhost')
else
  LocalName := DefaultHost;

ProxyChatServerPort := Settings.ReadInteger('Proxy', 'ChatServerPort', 6112);
ProxyRealmServerPort := Settings.ReadInteger('Proxy', 'RealmServerPort', 6112);
ProxyGameServerPort := Settings.ReadInteger('Proxy', 'GameServerPort', 4000);

ProxyChatClientPort := Settings.ReadInteger('Proxy', 'ChatClientPort', 6112);
ProxyRealmClientPort := Settings.ReadInteger('Proxy', 'RealmClientPort', 6113);
ProxyGameClientPort := Settings.ReadInteger('Proxy', 'GameClientPort', 4000);


Log.Color := StringToColor(Settings.ReadString('GUI', 'Background', '$003C3128'));
Log.SelectedColor.Background := StringToColor(Settings.ReadString('GUI', 'SelBackground', '$0046392F'));
Log.Font.Color := StringToColor(Settings.ReadString('GUI', 'Foreground', '$00DADADA'));
Log.Font.Name := Settings.ReadString('GUI', 'Font', 'Lucida Console');
Log.Font.Size := Settings.ReadInteger('GUI', 'FontSize', 9);

Log.Font.Style := [];

if Settings.ReadBool('GUI', 'FontBold', False) then
  Log.Font.Style := Log.Font.Style + [fsBold];

if Settings.ReadBool('GUI', 'FontItalic', False) then
  Log.Font.Style := Log.Font.Style + [fsItalic];

Log.Invalidate; 
end;

procedure TMainForm.ProxyStartExecute(Sender: TObject);
begin
ProxyRunning := True;

LibInfo.StartProxy(PChar(LocalName), PChar(ProxyServer),
ProxyChatClientPort, ProxyRealmClientPort, ProxyGameClientPort,
ProxyChatServerPort, ProxyRealmServerPort, ProxyGameServerPort);
end;

procedure TMainForm.ProxyStopExecute(Sender: TObject);
begin
LibInfo.StopProxy;
ProxyRunning := False;
end;

procedure TMainForm.ShowPlugins(Sender: TObject);
begin
 PluginsRefresh.Execute;
 MainForm.tblPlugin.Visible := True;
end;

procedure TMainForm.ClosePlugins(Sender: TObject);
begin
MainForm.tblPlugin.Hide;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
TBXSetTheme('OfficeXP');

PluginFolder := AppPath + 'Plugins';

Controller := TWrapperController.Create(Self);

Controller.AddDock('MainDock', tbxDock);

Controller.AddToolbar('MainMenu', tbxMainMenu);

LogQuene := TThreadList.Create;
LogAdd := TStringList.Create;

WindowManager := TWindowManager.Create(tblTabs);
WindowManager.HideAll;

PluginsTab := TWindowTab.Create;
PluginsTab.Title := 'Manage Plugins';
PluginsTab.ImageIndex := 4;
PluginsTab.Panel := Plugins;
PluginsTab.OnClose := ClosePlugins;
PluginsTab.OnShow := ShowPlugins;


LoadSettings;

SystemFont(Font);

AddLog(#13#10);

OwnerInfo.LogWrite := @AddLog;
OwnerInfo.PluginPath := PChar(PluginFolder);
OwnerInfo.WindowHandle := Handle;

ClientInfo.WriteLog := AddLog;
ClientInfo.GetWindowHandle := GetWindowHandle;
ClientInfo.Controller := Controller;

InitRedVexLibrary;

if StartProxy then
   ProxyStart.Execute;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
LogTimer.Enabled := False;

if ProxyRunning then
   ProxyStop.Execute;

FreeRedVexLibrary;

LogQuene.Free;
LogAdd.Free;
Controller.Free;
end;

procedure TMainForm.HelpAboutExecute(Sender: TObject);
var About: TAbout;
begin
  About := TAbout.Create(Self);
  About.ShowModal;
  About.Free;
end;

procedure TMainForm.LogCopyExecute(Sender: TObject);
begin
Log.CopyToClipboard
end;

procedure TMainForm.LogTimerTimer(Sender: TObject);
var i: Integer;

begin
if not MainForm.Enabled then Exit;

with LogQuene.LockList do
 begin
 for i := 0 to Count - 1 do
 begin
   LogAdd.Text := PChar(Items[i]);
   Log.Lines.AddStrings(LogAdd);
   Log.GotoLineAndCenter(Log.Lines.Count);
   FreeMem(Items[i]);
 end;
 LogAdd.Clear;
 Clear;
 end;
LogQuene.UnlockList;
end;

procedure TMainForm.PluginsDisableExecute(Sender: TObject);
begin
 LibInfo.Manager.Plugins(Integer(Plugins.Selected.Data)).Unload;
 PluginsRefresh.Execute;
end;

procedure TMainForm.PluginsDisableUpdate(Sender: TObject);
begin
if Plugins.Selected = nil then
  TAction(Sender).Enabled := False
else
TAction(Sender).Enabled := Plugins.Selected.ImageIndex = 1;
end;

procedure TMainForm.PluginsEnableExecute(Sender: TObject);
begin
if not FileExists(PluginFolder + '\' + Plugins.Selected.Caption) then
 begin
 ShowMessage('The file "' + PluginFolder + '\' + Plugins.Selected.Caption + '" doesn''t exist!');
 Exit;
 end;

if not LibInfo.Manager.LoadPlugin(PChar(PluginFolder + '\' + Plugins.Selected.Caption)) then
 begin
 ShowMessage(Plugins.Selected.Caption + ' has invalid SDK version!');
 Exit;
 end;

PluginsRefresh.Execute;
end;

procedure TMainForm.PluginsEnableUpdate(Sender: TObject);
begin
if Plugins.Selected = nil then
  TAction(Sender).Enabled := False
else
TAction(Sender).Enabled := Plugins.Selected.ImageIndex = 0;
end;

procedure TMainForm.PluginsRefreshExecute(Sender: TObject);
var
Node:TListItem;
i:Integer;
Found: TSearchRec;
Finished: Integer;
PluginInfo: PPluginInfo;

function Loaded:Boolean;
var x:Integer;
begin

for x := 0 to LibInfo.Manager.Count - 1 do
 if LowerCase(ExtractFileName(LibInfo.Manager.Plugins(x).GetFileName)) = LowerCase(Found.Name) then
  begin
  Result := True;
  Exit;
 end;

Result := False;
end;

begin
Plugins.Items.BeginUpdate;
Plugins.Items.Clear;

for i := 0 to LibInfo.Manager.Count - 1 do
 begin
  Node := Plugins.Items.Add;
  PluginInfo := LibInfo.Manager.Plugins(i).GetInfo;
  Node.Caption := ExtractFileName(LibInfo.Manager.Plugins(i).GetFileName);
  Node.Data := Pointer(i);
  Node.SubItems.Add('Loaded');
  Node.SubItems.Add(PluginInfo.Name);
  Node.SubItems.Add(PluginInfo.Author);
  Node.SubItems.Add(IntToStr(PluginInfo.SDKVersion));
  Node.ImageIndex := 1;
  Node.StateIndex := 1;
 end;

                            
	Finished  := FindFirst(PluginFolder+'\*.dll', faAnyFile, Found);
	while Finished = 0 do
	 begin

     if not Loaded then
      begin
      Node := Plugins.Items.Add;
      Node.Caption := Found.Name;
      Node.ImageIndex := 0;
      Node.StateIndex := 0;
      end;

     Finished := FindNext(Found);
   end;
 FindClose(Found);

Plugins.Items.EndUpdate;
end;

procedure TMainForm.PluginsReloadExecute(Sender: TObject);
var Plugin: TLibPlugin;
    FileName:String;
begin
Plugin := LibInfo.Manager.Plugins(Integer(Plugins.Selected.Data));
FileName := Plugin.GetFileName;
Plugin.Unload;
LibInfo.Manager.LoadPlugin(PChar(FileName));

PluginsRefresh.Execute;
end;

procedure TMainForm.PluginsReloadUpdate(Sender: TObject);
begin
if Plugins.Selected = nil then
  TAction(Sender).Enabled := False
else
TAction(Sender).Enabled := Plugins.Selected.ImageIndex = 1;
end;

procedure TMainForm.ProxyCloseToTrayExecute(Sender: TObject);
begin
Hide;
end;

procedure TMainForm.ProxyQuitExecute(Sender: TObject);
begin
MainForm.Free;
Application.Terminate;
end;

procedure TMainForm.ProxyStartUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not ProxyRunning;
end;

procedure TMainForm.ProxyStopUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ProxyRunning;
end;

procedure TMainForm.SettingsOptionsExecute(Sender: TObject);
var Options: TOptions;
begin
  Options := TOptions.Create(Self);
  Options.ShowModal;
  Options.Free;
end;

procedure TMainForm.SettingsPluginsExecute(Sender: TObject);
begin
WindowManager.AddTab(PluginsTab, True);
end;

procedure TMainForm.SettingsRealmsExecute(Sender: TObject);
var Realms: TRealms;
begin
  Realms := TRealms.Create(Self);
  Realms.ShowModal;
  Realms.Free;
end;


procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
TrayIconOpen.Execute;
end;

procedure TMainForm.TrayIconOpenExecute(Sender: TObject);
begin
Show;
SetFocus;
end;

end.
