unit uToolbars;

interface

uses Windows;

type
TMenuItemType = (mitItem, mitSubMenu, mitSeperator);

TToolBarMenuItem = class;

TToolBarMenuItems = class;

TToolBarDock = class;

TTab = class;

TOnClick = procedure(Owner: Pointer; Sender: TToolBarMenuItem); stdcall;

TToolBarMenuItem = class
    //Mainpulation
    function GetText: PWideChar; virtual; stdcall; abstract;
    procedure SetText(Text: PWideChar); virtual; stdcall; abstract;

    function GetChecked: Boolean; virtual; stdcall; abstract;
    procedure SetChecked(Checked: Boolean); virtual; stdcall; abstract;

    function GetOnClick: Pointer; virtual; stdcall; abstract;
    procedure SetOnClick(OnClick: Pointer); virtual; stdcall; abstract;

    function GetOwner: TObject; virtual; stdcall; abstract;
    procedure SetOwner(Value: TObject); virtual; stdcall; abstract;

    //Items
    function Items: TToolBarMenuItems; virtual; stdcall; abstract;
end;

TToolBarMenuItems = class
    //SubItems
    function AddItem(MenuItemType: TMenuItemType; Owner: TObject): TToolBarMenuItem; virtual; stdcall; abstract;
    function GetItem(Index:Integer): TToolBarMenuItem; virtual; stdcall; abstract;
    function FindItem(Text: PWideChar): TToolBarMenuItem; virtual; stdcall; abstract;
    function GetItemCount: Integer; virtual; stdcall; abstract;
    procedure DeleteItem(Index:Integer); virtual; stdcall; abstract;
    procedure RemoveItem(Item:TToolBarMenuItem); virtual; stdcall; abstract;
end;

TToolBar = class
    function GetTitle: PWideChar; virtual; stdcall; abstract;
    procedure SetTitle(Title: PWideChar); virtual; stdcall; abstract;

    function GetVisible: Boolean; virtual; stdcall; abstract;
    procedure SetVisible(Value: Boolean); virtual; stdcall; abstract;

    function GetDock: TToolBarDock; virtual; stdcall; abstract;
    procedure SetDock(Dock: TToolBarDock); virtual; stdcall; abstract;

    function Items: TToolBarMenuItems; virtual; stdcall; abstract;
end;


TToolBars = class
    function GetToolbarCount: Integer; virtual; stdcall; abstract;
    function GetToolbar(Index: Integer): TToolBar; virtual; stdcall; abstract;
    function FindToolbar(Title: PWideChar): TToolBar; virtual; stdcall; abstract;
end;

TToolBarDock = class
    function GetVisible: Boolean; virtual; stdcall; abstract;
    procedure SetVisible(Value: Boolean); virtual; stdcall; abstract;

    //Position
    function GetLeft: Integer; virtual; stdcall; abstract;
    procedure SetLeft(Value: Integer); virtual; stdcall; abstract;

    function GetTop: Integer; virtual; stdcall; abstract;
    procedure SetTop(Value: Integer); virtual; stdcall; abstract;

    function GetWidth: Integer; virtual; stdcall; abstract;
    procedure SetWidth(Value: Integer); virtual; stdcall; abstract;
    
    function GetHeight: Integer; virtual; stdcall; abstract;
    procedure SetHeight(Value: Integer); virtual; stdcall; abstract;
end;

TToolBarDocks = class
    function GetDockCount: Integer; virtual; stdcall; abstract;
    function GetDock(Index: Integer): TToolBarDock; virtual; stdcall; abstract;
    function FindDock(Title: PWideChar): TToolBarDock; virtual; stdcall; abstract;
end;


TOnResize = procedure(Owner: Pointer; Sender: TTab; Size: PRect); stdcall;

TOnClose = procedure(Owner: Pointer; Sender: TTab); stdcall;


TTab = class
   function GetTitle: PWideChar; virtual; stdcall; abstract;
   procedure SetTitle(Title: PWideChar); virtual; stdcall; abstract;

   function Handle: Cardinal; virtual; stdcall; abstract;

   function GetOnResize: Pointer; virtual; stdcall; abstract;
   procedure SetOnResize(OnResize: Pointer); virtual; stdcall; abstract;

   function GetOnClose: Pointer; virtual; stdcall; abstract;
   procedure SetOnClose(OnClose: Pointer); virtual; stdcall; abstract;

   function GetOwner: TObject; virtual; stdcall; abstract;
   procedure SetOwner(Value: TObject); virtual; stdcall; abstract;


   procedure Show; virtual; stdcall; abstract;
   procedure Hide; virtual; stdcall; abstract;
end;

TController = class
    function ControllerVersion: Integer; virtual; stdcall; abstract;
    
    function CreateToolbar(Name: PWideChar; Dock: TToolBarDock): TToolBar; virtual; stdcall; abstract;
    procedure DeleteToolbar(Toolbar: TToolBar); virtual; stdcall; abstract;

    function CreateDock(Name: PWideChar; Owner: Cardinal): TToolBarDock; virtual; stdcall; abstract;
    procedure DeleteDock(Dock: TToolBarDock); virtual; stdcall; abstract;

    function CreateTab: TTab; virtual; stdcall; abstract;
    procedure DeleteTab(Tab: TTab); virtual; stdcall; abstract;

    function Toolbars: TToolBars; virtual; stdcall; abstract;
    function Docks: TToolBarDocks; virtual; stdcall; abstract;
end;

implementation

end.
