unit uSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  THelpMode = (hmMessage, hmGuide);
  TGuideClick = function: Boolean of object;

  TGuideEvent = record
    Panel: TPanel;
    Action: TGuideClick;
  end;

  
  TSetupHelp = class(TForm)
    Image: TImage;
    pnlWelcome: TPanel;
    LabelWelcome: TLabel;
    pnlButtons: TPanel;
    MainPanel: TPanel;
    btnRight: TButton;
    btnLeft: TButton;
    pnlRealms: TPanel;
    LabelRealm: TLabel;
    rbWest: TRadioButton;
    rbEast: TRadioButton;
    rbAsia: TRadioButton;
    rbEurope: TRadioButton;
    Bevel1: TBevel;
    pnlDiabloRealm: TPanel;
    DiabloRealmLabel: TLabel;
    mDiabloRealm: TRadioButton;
    mRealmLabel: TLabel;
    mDiabloRealmName: TEdit;
    mNoDiabloRealm: TRadioButton;
    pnlFinal: TPanel;
    lblFinish: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    function RealmClick: Boolean;
    function DiabloClick: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
  public
    Mode: THelpMode;
    Guide: array [0..3] of TGuideEvent;
    GuideIndex: Integer;
    Message: string;
    GuideCompleted: Boolean;
  end;

var
  SetupHelp: TSetupHelp;

implementation

uses uMain, uAbout, uRealms;

{$R *.dfm}

procedure TSetupHelp.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TSetupHelp.btnLeftClick(Sender: TObject);
begin
  if GuideIndex = High(Guide) then
     btnRight.Caption := '&Next';
  Guide[GuideIndex - 1].Panel.Show;
  Guide[GuideIndex].Panel.Hide;
  Dec(GuideIndex);
  if GuideIndex = 0 then
     btnLeft.Enabled := False;
end;

procedure TSetupHelp.btnRightClick(Sender: TObject);
begin
 case Mode of

  hmMessage: Close;

  hmGuide:
      begin

         if Assigned(Guide[GuideIndex].Action) then
           if not Guide[GuideIndex].Action then Exit;

        btnLeft.Enabled := True;

        if btnRight.Caption = '&Finish' then
         begin
           GuideCompleted := True;
           Close;
           Exit;
         end;

        Guide[GuideIndex + 1].Panel.Show;
        Guide[GuideIndex].Panel.Hide;

        Inc(GuideIndex);

        if GuideIndex = High(Guide) then
           btnRight.Caption := '&Finish';
      end;
 end;

 end;         

function TSetupHelp.DiabloClick: Boolean;
var Lines:  TStringList;
begin
  Result := True;
  if mDiabloRealm.Checked then
    begin
    if mDiabloRealmName.Text = '' then
       begin
         ShowMessage('Your realm must have a name!');
         Result := False;
         Exit;
       end;

    Lines := TStringList.Create;

    Lines.Text := ReadRealmData;

    Lines.Add('localhost');

    Lines.Add('0');

    Lines.Add(mDiabloRealmName.Text);

    WriteRealmData(Lines.Text);

    Lines.Free;
    end;
end;


function TSetupHelp.RealmClick: Boolean;
var Lines:  TStringList;
    Found: Boolean;
    Len: Integer;
begin
  Result := True;
if rbWest.Checked then
   Settings.WriteString('Proxy', 'Server', 'uswest.battle.net');

if rbEast.Checked then
   Settings.WriteString('Proxy', 'Server', 'useast.battle.net');

if rbAsia.Checked then
   Settings.WriteString('Proxy', 'Server', 'asia.battle.net');
   
if rbEurope.Checked then
   Settings.WriteString('Proxy', 'Server', 'europe.battle.net');

    Found := False;

    Lines := TStringList.Create;

    Lines.Text := ReadRealmData;

     Len := 2;
     while Len < Lines.Count do
      begin
       if Lines[Len] = 'localhost' then
        begin
          Found := True;
          Break;
        end;
       Inc(Len, 3);
      end;

     if Found then
      begin
        DiabloRealmLabel.Caption := 'You already have a RedVex realm in Diablo II. There is no need to create another.';
        mNoDiabloRealm.Checked := True;
        mNoDiabloRealm.Hide;
        mDiabloRealm.Checked := False;
        mDiabloRealm.Hide;
        mDiabloRealmName.Hide;
        mRealmLabel.Hide;
      end
     else
      begin
        mNoDiabloRealm.Checked := False;
        mNoDiabloRealm.Show;
        mDiabloRealm.Checked := True;
        mDiabloRealm.Show;
        mDiabloRealmName.Show;
        mRealmLabel.Show;
      end;
    Lines.Free;
end;


procedure TSetupHelp.FormCreate(Sender: TObject);
var About: TAbout;
begin
About := TAbout.Create(nil);
Image.Picture.Assign(About.Image.Picture);
About.Free;
SystemFont(Font);

Guide[0].Panel := pnlWelcome;
Guide[0].Action := nil;

Guide[1].Panel := pnlRealms;
Guide[1].Action := RealmClick;

Guide[2].Panel := pnlDiabloRealm;
Guide[2].Action := DiabloClick;

Guide[3].Panel := pnlFinal;
Guide[3].Action := nil;
end;

procedure TSetupHelp.FormShow(Sender: TObject);
begin
 case Mode of

  hmMessage:
   begin
     LabelWelcome.Caption := Message;
     btnLeft.Hide;
     btnRight.Caption := '&Close';
     pnlWelcome.Show;
   end;

  hmGuide:
    begin
      btnLeft.Enabled := False;
      
      if GuideIndex = High(Guide) then
          btnRight.Enabled := False;

      Guide[GuideIndex].Panel.Show;

    end;
 end;

end;

end.
