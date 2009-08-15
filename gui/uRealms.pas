unit uRealms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RandomHandle, StdCtrls;

type
  PRealm = ^TRealm;
  TRealm = record
     Name, IP, Timezone: String;
  end;
  TRealms = class(TRandomForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    RealmTimezone: TEdit;
    Label4: TLabel;
    btnAdd: TButton;
    btnRemove: TButton;
    btnApply: TButton;
    RealmList: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    RealmName: TEdit;
    RealmAddress: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure RealmListClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
RealmsKey = 'Software\Battle.net\Configuration';
RealmsValue = 'Diablo II Battle.net gateways';

var
  Realms: TRealms;

function ReadRealmData: string;
procedure WriteRealmData(Data: string);

implementation

uses uMain;

{$R *.dfm}

function ReadRealmData: string;
var Key: HKEY;
    Size, ValueType: Cardinal;
    Buffer, Line: PChar;
begin

	if (RegOpenKey(HKEY_CURRENT_USER, RealmsKey, Key) = ERROR_SUCCESS) then
   begin

    RegQueryValueEx(Key, RealmsValue, nil, @ValueType, nil, @Size);

    GetMem(Buffer, Size);

		if not (((RegQueryValueEx(key, RealmsValue, nil, @ValueType,
              PByte(Buffer),@Size)) = ERROR_SUCCESS)
              and (ValueType = REG_MULTI_SZ)) then
       ShowMessage('Error reading Realm Data!');

    Line := Buffer;

    Result := '';

    repeat
      Result := Result + Line + #13#10;
      Inc(Line, StrLen(Line) + 1)
    until Cardinal(Line) - Cardinal(Buffer) >= Size;

    FreeMem(Buffer);

    Result := Trim(Result);

		RegCloseKey(Key);
   end;
end;

procedure WriteRealmData(Data: string);
var Key: HKEY;
    List: TStringList;
    Memory: TMemoryStream;
    i:Integer;
    Buffer: String;
begin
 	if (RegOpenKey(HKEY_CURRENT_USER, RealmsKey, Key) = ERROR_SUCCESS) then
   begin
    List := TStringList.Create;
    List.Text := Trim(Data);
    List.Add('');

    Memory := TMemoryStream.Create;
    for i := 0 to List.Count - 1 do
      begin
       Buffer := List[i];
       Memory.Write(PChar(Buffer)^, Length(Buffer)+1);
      end;

    List.Free;
    RegSetValueEx(Key, RealmsValue, 0, REG_MULTI_SZ, Memory.Memory, Memory.Size);
    Memory.Free;
    RegCloseKey(Key);
   end;
end;

procedure TRealms.btnAddClick(Sender: TObject);
var  Realm: PRealm;
begin
 if RealmName.Text = '' then
   ShowMessage('Please enter realm name!')
 else
  begin
    New(Realm);
    Realm.Name := RealmName.Text;
    Realm.IP := RealmAddress.Text;
    Realm.Timezone := RealmTimezone.Text;
    RealmList.Items.AddObject(Realm.Name, TObject(Realm));
  end;
end;

procedure TRealms.btnRemoveClick(Sender: TObject);
var  Realm: PRealm;
begin
 if RealmList.ItemIndex = -1 then
   ShowMessage('You must select an realm to delete!')
 else
  begin
    Realm := PRealm(RealmList.Items.Objects[RealmList.ItemIndex]);
    Dispose(Realm);
    RealmList.Items.Delete(RealmList.ItemIndex);
  end;
end;

procedure TRealms.btnApplyClick(Sender: TObject);
var  Realm: PRealm;
begin
 if RealmList.ItemIndex = -1 then
   ShowMessage('You must select an realm to alter!')
 else
  begin
    Realm := PRealm(RealmList.Items.Objects[RealmList.ItemIndex]);
    Realm.Name := RealmName.Text;
    Realm.IP := RealmAddress.Text;
    Realm.Timezone := RealmTimezone.Text;
    RealmList.Items[RealmList.ItemIndex] := Realm.Name;
  end;
end;

procedure TRealms.btnCancelClick(Sender: TObject);
begin
Close;
end;

procedure TRealms.btnOKClick(Sender: TObject);
var List:TStringList;
    i:Integer;
     Realm: PRealm;
begin
 List := TStringList.Create;
 List.Add('1002');
 List.Add(IntToStr(RealmList.Items.Count-1));

 if Length(List[1]) = 1 then  //Add padding
    List[1] := '0'+List[1];

  for i := 0 to RealmList.Items.Count - 1 do
   begin
    Realm := PRealm(RealmList.Items.Objects[i]);
    List.Add(Realm.IP);
    List.Add(Realm.Timezone);
    List.Add(Realm.Name);
   end;
  List.Add('');

  WriteRealmData(List.Text);

  List.Free;

  Close;
end;

procedure TRealms.FormClose(Sender: TObject; var Action: TCloseAction);
begin
while RealmList.Items.Count > 0 do
 begin
    Dispose(PRealm(RealmList.Items.Objects[0]));
    RealmList.Items.Delete(0);
 end;
Close;
end;

procedure TRealms.FormCreate(Sender: TObject);
begin
  SystemFont(Font);
end;

procedure TRealms.FormShow(Sender: TObject);
var Lines: TStringList;
    Len: Integer;
    Realm: PRealm;
begin
    Lines := TStringList.Create;

    Lines.Text := ReadRealmData;

    Len := 2;
     while Len < Lines.Count do
      begin
       New(Realm);
       Realm.IP := Lines[Len];
       Inc(Len);
       Realm.Timezone := Lines[Len];
       Inc(Len);
       Realm.Name := Lines[Len];
       Inc(Len);
       RealmList.Items.AddObject(Realm.Name, TObject(Realm));
      end;


    Lines.Free;

 RealmList.ItemIndex := 0;
 RealmList.OnClick(nil);  
end;

procedure TRealms.RealmListClick(Sender: TObject);
var  Realm: PRealm;
begin
  if RealmList.ItemIndex = -1 then Exit;

  Realm := PRealm(RealmList.Items.Objects[RealmList.ItemIndex]);
  RealmName.Text :=  Realm.Name;
  RealmAddress.Text :=  Realm.IP;
  RealmTimezone.Text :=  Realm.Timezone;
 
end;

end.
