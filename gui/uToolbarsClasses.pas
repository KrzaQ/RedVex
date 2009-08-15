unit uToolbarsClasses;

interface

uses uToolbars, TBX, TB2Item, Classes, SysUtils, TB2Dock, Controls, ExtCtrls,
     uWindowManager;

type
TWrapperItems = class(TToolBarMenuItems)
    protected
      FItem: TTBCustomItem;
      FCount: Integer;
      FList, FItemList: TList;
    public

    constructor Create(Item: TTBCustomItem);
    destructor Destroy; override;

    //SubItems
    function AddItem(MenuItemType: TMenuItemType; Owner: TObject): TToolBarMenuItem; override; stdcall;
    function GetItem(Index:Integer): TToolBarMenuItem; override; stdcall;
    function FindItem(Text: PWideChar): TToolBarMenuItem; override; stdcall;
    function GetItemCount: Integer; override; stdcall;
    procedure DeleteItem(Index:Integer); override; stdcall;
    procedure RemoveItem(Item:TToolBarMenuItem); override; stdcall;

    function CachedGetItem(Item: TTBCustomItem): TToolBarMenuItem;
end;

TWrapperItem = class(TToolBarMenuItem)
    protected
      FItem: TTBCustomItem;
      FItems: TWrapperItems;
      FOnClick: Pointer;
      FOwner: TObject;
    public

    procedure OnItemClick(Sender: TObject);

    constructor Create(Item: TTBCustomItem);
    destructor Destroy; override;

    //Mainpulation
    function GetText: PWideChar; override; stdcall;
    procedure SetText(Text: PWideChar); override; stdcall;

    function GetOwner: TObject; override; stdcall;
    procedure SetOwner(Value: TObject); override; stdcall;

    function GetChecked: Boolean; override; stdcall;
    procedure SetChecked(Checked: Boolean); override; stdcall; 

    function GetOnClick: Pointer; override; stdcall;
    procedure SetOnClick(OnClick: Pointer); override; stdcall;

    function Items: TToolBarMenuItems; override; stdcall;
end;

TWrapperToolBar = class(TToolBar)
    protected
    FToolbar: TTBXToolbar;
    FItems: TWrapperItems;
    FDock: TToolBarDock;
    public
    constructor Create(Toolbar: TTBXToolbar);
    destructor Destroy; override;

    function GetTitle: PWideChar; override; stdcall;
    procedure SetTitle(Title: PWideChar); override; stdcall;

    function GetVisible: Boolean; override; stdcall;
    procedure SetVisible(Value: Boolean); override; stdcall;

    function GetDock: TToolBarDock; override; stdcall;
    procedure SetDock(Dock: TToolBarDock); override; stdcall;

    function Items: TToolBarMenuItems; override; stdcall;
end;

TWrapperToolBars = class(TToolBars)
    protected
      FToolBars: TStringList;
    public

    constructor Create;
    destructor Destroy; override;

    function GetToolbarCount: Integer; override; stdcall;
    function GetToolbar(Index: Integer): TToolBar; override; stdcall;
    function FindToolbar(Title: PWideChar): TToolBar; override; stdcall;
end;

TWrapperToolBarDock = class(TToolBarDock)
    protected
    FDock: TTBXDock;
    FCustom: Boolean;
    public
    constructor Create(Dock: TTBXDock);
    destructor Destroy; override;

    function GetVisible: Boolean; override; stdcall;
    procedure SetVisible(Value: Boolean); override; stdcall;

    function GetLeft: Integer; override; stdcall;
    procedure SetLeft(Value: Integer); override; stdcall;

    function GetTop: Integer;override; stdcall;
    procedure SetTop(Value: Integer); override; stdcall;

    function GetWidth: Integer; override; stdcall;
    procedure SetWidth(Value: Integer); override; stdcall;
    
    function GetHeight: Integer; override; stdcall;
    procedure SetHeight(Value: Integer); override; stdcall;
end;


TWrapperToolBarDocks = class(TToolBarDocks)
    protected
      FDocks: TStringList;
    public

    constructor Create;
    destructor Destroy; override;

    function GetDockCount: Integer; override; stdcall;
    function GetDock(Index: Integer): TToolBarDock; override; stdcall;
    function FindDock(Title: PWideChar): TToolBarDock; override; stdcall;


end;


TWrapperTab = class(TTab)
   private
     FPanel: TPanel;
     FTab: TWindowTab;
     FOnClose: Pointer;
     FOnResize: Pointer;
     FOwner: Pointer;
   public
   constructor Create(Owner: TWinControl);
   destructor Destroy; override;
    
   function GetTitle: PWideChar; override; stdcall;
   procedure SetTitle(Title: PWideChar); override; stdcall;

   function Handle: Cardinal; override; stdcall;

   function GetOnResize: Pointer; override; stdcall;
   procedure SetOnResize(OnResize: Pointer); override; stdcall;

   procedure OnResize(Sender: TObject);

   function GetOnClose: Pointer; override; stdcall;
   procedure SetOnClose(OnClose: Pointer);  override; stdcall;

   procedure OnClose(Sender: TObject);

   function GetOwner: TObject; override; stdcall;
   procedure SetOwner(Value: TObject); override; stdcall;


   procedure Show; override; stdcall;
   procedure Hide; override; stdcall;
end;

TWrapperController = class(TController)
   private
    FToolbars: TWrapperToolBars;
    FDocks: TWrapperToolBarDocks;
    FOwner: TWinControl;
   public
    constructor Create(Owner: TWinControl);
    destructor Destroy; override;

    function ControllerVersion: Integer; override; stdcall;

    function CreateToolbar(Name: PWideChar; Dock: TToolBarDock): TToolBar; override; stdcall;
    procedure DeleteToolbar(Toolbar: TToolBar); override; stdcall;

    function CreateDock(Name: PWideChar; Owner: Cardinal): TToolBarDock;  override; stdcall;
    procedure DeleteDock(Dock: TToolBarDock); override; stdcall;

    function CreateTab: TTab; override; stdcall;
    procedure DeleteTab(Tab: TTab); override; stdcall;

    function Toolbars: TToolBars; override; stdcall;
    function Docks: TToolBarDocks; override; stdcall;

    //Internal
    procedure AddDock(Name: WideString; Dock: TTBXDock);
    procedure AddToolbar(Name: WideString; Toolbar: TTBXToolbar);
end;

const TControllerVersion = 1;


implementation


uses StrUtils, Windows;


constructor TWrapperTab.Create(Owner: TWinControl);
begin
  inherited Create;
  FPanel := TPanel.Create(Owner);
  FPanel.Align := alClient;
  FPanel.Caption := '';
  FPanel.BevelOuter := bvNone;
  FPanel.OnResize := OnResize;
  FPanel.Visible := False;
  FPanel.Parent := Owner;
  FTab := TWindowTab.Create;
  FTab.Panel := FPanel;
  FTab.OnClose := OnClose;
end;


destructor TWrapperTab.Destroy;
begin
  FPanel.Free;
  inherited;
end;

procedure TWrapperTab.OnResize(Sender: TObject);
var Rect: TRect;
begin
  if Assigned(FOnResize) then
    begin
      Rect := FPanel.BoundsRect;
      TOnResize(FOnResize)(FOwner, Self, @Rect);
    end;
end;

procedure TWrapperTab.OnClose(Sender: TObject);
begin
  if Assigned(FOnClose) then
      TOnClose(FOnClose)(FOwner, Self);
end;

function TWrapperTab.GetOnClose: Pointer;
begin
 Result := FOnClose;
end;

procedure TWrapperTab.SetOnClose(OnClose: Pointer);
begin
 FOnClose := OnClose;
end;

function TWrapperTab.GetTitle: PWideChar;
begin
 Result := PWideChar(FTab.Title);
end;

procedure TWrapperTab.SetTitle(Title: PWideChar);
begin
 FTab.Title := Title;
end;

function TWrapperTab.Handle: Cardinal;
begin
 Result := FPanel.Handle;
end;

function TWrapperTab.GetOwner: TObject;
begin
  Result := FOwner;
end;

procedure TWrapperTab.SetOwner(Value: TObject);
begin
 FOwner := Value;
end;

function TWrapperTab.GetOnResize: Pointer;
begin
 Result := FOnResize;
end;

procedure TWrapperTab.SetOnResize(OnResize: Pointer);
begin
 FOnResize := OnResize;
end;

procedure TWrapperTab.Show;
begin
 OnResize(nil);
 WindowManager.AddTab(FTab, True);
end;

procedure TWrapperTab.Hide;
begin
 FTab.Hide;
end;


constructor TWrapperController.Create(Owner: TWinControl);
begin
  inherited Create;
  FToolbars := TWrapperToolBars.Create;
  FOwner := Owner;
  FDocks := TWrapperToolBarDocks.Create;
end;

destructor TWrapperController.Destroy;
begin
  FToolbars.Free;
  FDocks.Free;
  inherited;
end;

function TWrapperController.ControllerVersion: Integer;
begin
  Result := TControllerVersion;
end;

function TWrapperController.CreateTab: TTab;
begin
  Result := TWrapperTab.Create(FOwner);
end;

procedure TWrapperController.DeleteTab(Tab: TTab);
begin
  Tab.Free;
end;

procedure TWrapperController.AddDock(Name: WideString; Dock: TTBXDock);
begin
  FDocks.FDocks.AddObject(Name, TWrapperToolBarDock.Create(Dock));
end;

procedure TWrapperController.AddToolbar(Name: WideString; Toolbar: TTBXToolbar);
begin
  FToolbars.FToolBars.AddObject(Name, TWrapperToolBar.Create(Toolbar));
end;

function TWrapperController.CreateToolbar(Name: PWideChar; Dock: TToolBarDock): TToolBar;
var Toolbar: TTBXToolbar;
begin
  Toolbar := TTBXToolbar.Create(TWrapperToolBarDock(Dock).FDock);
  
  Result := TWrapperToolBar.Create(Toolbar);

  Toolbar.DockMode := dmCannotFloat;

  FToolbars.FToolBars.AddObject(Name, Result);
end;

procedure TWrapperController.DeleteToolbar(Toolbar: TToolBar);
var i:Integer;
begin
  for i := 0 to FToolbars.FToolBars.Count - 1 do
   if FToolbars.FToolBars.Objects[i] = Toolbar then
    begin
     FToolbars.FToolBars.Delete(i);
    end;

  Toolbar.Free;
end;

function TWrapperController.CreateDock(Name: PWideChar; Owner: Cardinal): TToolBarDock;
var Dock: TWrapperToolBarDock;
begin
  Dock := TWrapperToolBarDock.Create(TTBXDock.CreateParented(Owner));
  Dock.FCustom := True;
  Result := Dock;
  FDocks.FDocks.AddObject(Name, Result);
end;

procedure TWrapperController.DeleteDock(Dock: TToolBarDock);
var i:Integer;
begin
  for i := 0 to FDocks.FDocks.Count - 1 do
   if FDocks.FDocks.Objects[i] = Dock then
    begin
     FDocks.FDocks.Delete(i);
    end;

  Dock.Free;
end;

function TWrapperController.Toolbars: TToolBars;
begin
  Result := FToolbars;
end;

function TWrapperController.Docks: TToolBarDocks;
begin
 Result := FDocks;
end;


constructor TWrapperToolBarDock.Create(Dock: TTBXDock);
begin
 inherited Create;
 FDock := Dock;
end;

destructor TWrapperToolBarDock.Destroy;
begin
 inherited;
end;

function TWrapperToolBarDock.GetVisible: Boolean;
begin
 Result := FDock.Visible;
end;

procedure TWrapperToolBarDock.SetVisible(Value: Boolean);
begin
 FDock.Visible := Value;
end;

function TWrapperToolBarDock.GetLeft: Integer;
begin
 Result := FDock.Left;
end;

procedure TWrapperToolBarDock.SetLeft(Value: Integer);
begin
 FDock.Left := Value;
end;

function TWrapperToolBarDock.GetTop: Integer;
begin
 Result := FDock.Top;
end;

procedure TWrapperToolBarDock.SetTop(Value: Integer);
begin
 FDock.Top := Value;
end;

function TWrapperToolBarDock.GetWidth: Integer;
begin
 Result := FDock.Width;
end;

procedure TWrapperToolBarDock.SetWidth(Value: Integer);
begin
 FDock.Width := Value;
end;

function TWrapperToolBarDock.GetHeight: Integer;
begin
 Result := FDock.Height;
end;

procedure TWrapperToolBarDock.SetHeight(Value: Integer);
begin
 FDock.Height := Value;
end;



constructor TWrapperToolBar.Create(Toolbar: TTBXToolbar);
begin
  inherited Create;
  FToolbar := Toolbar;
  FItems := TWrapperItems.Create(Toolbar.Items);
end;

destructor TWrapperToolBar.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TWrapperToolBar.GetTitle: PWideChar;
begin
  Result := PWideChar(FToolbar.Caption);
end;

procedure TWrapperToolBar.SetTitle(Title: PWideChar);
begin
  FToolbar.Caption := Title;
end;

function TWrapperToolBar.GetVisible: Boolean;
begin
 Result := FToolbar.Visible;
end;

procedure TWrapperToolBar.SetVisible(Value: Boolean);
begin
 FToolbar.Visible := Value;
end;

function TWrapperToolBar.GetDock: TToolBarDock;
begin
 Result := FDock;
end;

procedure TWrapperToolBar.SetDock(Dock: TToolBarDock);
begin
 FDock := Dock;
 FToolbar.Parent := TWrapperToolBarDock(Dock).FDock;
end;

function TWrapperToolBar.Items: TToolBarMenuItems;
begin
 Result := FItems;
end;


constructor TWrapperToolBarDocks.Create;
begin
  inherited Create;
  FDocks := TStringList.Create;
end;

destructor TWrapperToolBarDocks.Destroy;
var i:Integer;
begin
  for i := 0 to FDocks.Count - 1 do
    FDocks.Objects[i].Free;

  FDocks.Free;
  inherited;
end;

function TWrapperToolBarDocks.GetDockCount: Integer;
begin
  Result := FDocks.Count;
end;

function TWrapperToolBarDocks.GetDock(Index: Integer): TToolBarDock;
begin
 Result := TToolBarDock(FDocks.Objects[Index]);
end;

function TWrapperToolBarDocks.FindDock(Title: PWideChar): TToolBarDock;
var i:Integer;
begin
  i := FDocks.IndexOf(Title);
  if i = -1 then
     raise Exception.Create('FindDock: Can''t find toolbar: ' + Title);

  Result := TToolBarDock(FDocks.Objects[i]);
end;


constructor TWrapperToolBars.Create;
begin
  inherited;
  FToolBars := TStringList.Create;
end;

destructor TWrapperToolBars.Destroy;
var i:Integer;
begin
  for i := 0 to FToolBars.Count - 1 do
    FToolBars.Objects[i].Free;

  FToolBars.Free;
  inherited;
end;

function TWrapperToolBars.GetToolbarCount: Integer;
begin
  Result := FToolBars.Count;
end;

function TWrapperToolBars.GetToolbar(Index: Integer): TToolBar;
begin
 Result := TToolBar(FToolBars.Objects[Index]);
end;

function TWrapperToolBars.FindToolbar(Title: PWideChar): TToolBar;
var i:Integer;
begin
  i := FToolBars.IndexOf(Title);
  if i = -1 then
     raise Exception.Create('FindToolbar: Can''t find toolbar: ' + Title);

  Result := TToolBar(FToolBars.Objects[i]);
end;

constructor TWrapperItems.Create(Item: TTBCustomItem);
begin
  inherited Create;
  FItem := Item;
  FList := TList.Create;
  FItemList := TList.Create;
end;

destructor TWrapperItems.Destroy;
var i:Integer;
begin
  for i := 0 to FList.Count - 1 do
    TWrapperItem(FList[i]).Free;

  FList.Free;
  FItemList.Free;
  inherited;
end;

function TWrapperItems.CachedGetItem(Item: TTBCustomItem): TToolBarMenuItem;
var LocalIndex: Integer;
begin
  LocalIndex :=  FItemList.IndexOf(Item);

  if LocalIndex = -1 then
   begin
       Result := TWrapperItem.Create(Item);
       FList.Add(Result);
       FItemList.Add(Item);
   end
  else Result := FList[LocalIndex];
end;

function TWrapperItems.AddItem(MenuItemType: TMenuItemType; Owner: TObject): TToolBarMenuItem; stdcall;
var AItem: TTBCustomItem;
begin
  case MenuItemType of
     mitSubMenu:  AItem := TTBXSubmenuItem.Create(FItem);
     mitSeperator:  AItem := TTBXSeparatorItem.Create(FItem);
     else AItem := TTBXItem.Create(FItem);
  end;

  FItem.Add(AItem);

  Result := TWrapperItem.Create(AItem);

  Result.SetOwner(Owner);

  FList.Add(Result);
  FItemList.Add(AItem);
end;

function TWrapperItems.FindItem(Text: PWideChar): TToolBarMenuItem;
var i:Integer;
    LText: string;
begin
   LText := LowerCase(Text);
   for i := 0 to FItem.Count - 1 do
      if LowerCase(ReplaceText(FItem.Items[i].Caption, '&', '')) = LText then
       begin
          Result := CachedGetItem(FItem.Items[i]);
          Exit;
       end;

  raise Exception.Create('FindItem: Can''t find item in list: ' + Text);
end;

function TWrapperItems.GetItem(Index:Integer): TToolBarMenuItem;
begin
  Result := CachedGetItem(FItem.Items[Index]);
end;

function TWrapperItems.GetItemCount: Integer;
begin
 Result := FItem.Count;
end;

procedure TWrapperItems.RemoveItem(Item:TToolBarMenuItem);
var LocalIndex:Integer;
begin
  LocalIndex := FList.IndexOf(Item);

  if LocalIndex = -1 then
    raise Exception.Create('RemoveItem: Can''t find item in list: ' + Item.GetText);

  FItem.Remove(FItemList[LocalIndex]);

  TWrapperItem(FList[LocalIndex]).Free;
  FList.Delete(LocalIndex);
  FItem.Remove(FItemList[LocalIndex]);
  TTBCustomItem(FItemList[LocalIndex]).Free;
  FItemList.Delete(LocalIndex);
end;

procedure TWrapperItems.DeleteItem(Index:Integer);
var LocalIndex:Integer;
begin
   LocalIndex := FItemList.IndexOf(FItem.Items[Index]);

  if LocalIndex = -1 then
    raise Exception.Create('DeleteItem: Can''t find item in list, invalid index: '+ IntToStr(Index));

  TWrapperItem(FList[LocalIndex]).Free;
  FList.Delete(LocalIndex);
  FItem.Delete(Index);
  TTBCustomItem(FItemList[LocalIndex]).Free;
  FItemList.Delete(LocalIndex);
end;



constructor TWrapperItem.Create(Item: TTBCustomItem);
begin
  inherited Create;
  FItem := Item;
  FItems := TWrapperItems.Create(FItem);
  FItem.OnClick := OnItemClick;
end;

destructor TWrapperItem.Destroy;
begin
  FItem.OnClick := nil;
  FItems.Free;
end;

function TWrapperItem.Items: TToolBarMenuItems;
begin
  Result := FItems;
end;

procedure TWrapperItem.OnItemClick(Sender: TObject);
begin
  if Assigned(FOnClick) then
     TOnClick(FOnClick)(FOwner, Self);
end;

function TWrapperItem.GetOwner: TObject;
begin
  Result := FOwner;
end;

procedure TWrapperItem.SetOwner(Value: TObject);
begin
 FOwner := Value;
end;

function TWrapperItem.GetText: PWideChar;
begin
  Result := PWideChar(FItem.Caption)
end;

procedure TWrapperItem.SetText(Text: PWideChar);
begin
  FItem.Caption := Text;
end;

function TWrapperItem.GetChecked: Boolean;
begin
  Result := FItem.Checked;
end;

procedure TWrapperItem.SetChecked(Checked: Boolean);
begin
  FItem.Checked := Checked;
end;

function TWrapperItem.GetOnClick: Pointer;
begin
  Result := FOnClick;
end;

procedure TWrapperItem.SetOnClick(OnClick: Pointer);
begin
  FOnClick := OnClick;
end;


end.
