program RedVex;

uses
  Windows,
  SysUtils,
  IniFiles,
  Forms,
  Dialogs,
  Controls,
  uMain in 'uMain.pas' {MainForm},
  RandomHandle in 'RandomHandle.pas',
  uWindowManager in 'uWindowManager.pas',
  uAbout in 'uAbout.pas' {About},
  uRealms in 'uRealms.pas' {Realms},
  uSettings in 'uSettings.pas' {Options},
  uRedVexLib in 'uRedVexLib.pas',
  uToolbarsClasses in 'uToolbarsClasses.pas',
  uSetup in 'uSetup.pas' {SetupHelp},
  uHashChecks in 'uHashChecks.pas',
  RedVexTypes in 'Shared\RedVexTypes.pas',
  uToolbars in 'Shared\uToolbars.pas',
  TBXOfficeXPTheme in '..\VCL\TBX\TBXOfficeXPTheme.pas';

{$R *.res}

procedure MessageBox(Message: String);
begin
     SetupHelp := TSetupHelp.Create(Application);
     SetupHelp.Message := Message;
     SetupHelp.Mode := hmMessage;
     SetupHelp.ShowModal;
     SetupHelp.Free;
     Halt;
end;

var i:Integer;
    Hide:Boolean;
begin
  if not Patched then
     MessageBox('You must drop RedVex.exe on Patch.exe before running RedVex!'#13#10#13#10'Note: You must close this dialog before you try to patch it');


  if FileExists(ExtractFilePath(Application.ExeName) + 'Patch.exe') then
     MessageBox('Please rename or move Patch.exe!');


  if LowerCase(ExtractFileName(Application.ExeName)) = 'redvex.exe' then
     MessageBox('You must rename RedVex.exe and RedVex.dll to something else!'#13#10#13#10'Note: Both files must have the same name');


  if not FileExists(ChangeFileExt(Application.ExeName, '.dll')) then
     MessageBox('Please rename RedVex.dll to '+ExtractFileName(ChangeFileExt(Application.ExeName, '.dll'))+'!');

  Settings := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  if Settings.ReadBool('GUI', 'FirstRun', True) then
   begin
     SetupHelp := TSetupHelp.Create(Application);
     SetupHelp.Mode := hmGuide;
     SetupHelp.ShowModal;
     if not SetupHelp.GuideCompleted then
      begin
        SetupHelp.Free;
        Halt;
      end;
     SetupHelp.Free;
     Settings.WriteBool('GUI', 'FirstRun', False);
   end;



  Hide := False;
  StartProxy := False;

  for i := 1 to ParamCount do
   begin
    if CompareText(ParamStr(i), '-hide') = 0 then
      Hide := True;
    if CompareText(ParamStr(i), '-run') = 0 then
      StartProxy := True;
   end;

  AppPath := ExtractFilePath(Application.ExeName);

  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOptions, Options);
  Application.ShowMainForm := not Hide;
  Application.Run;

  Settings.Free;
end.
