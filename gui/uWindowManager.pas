unit uWindowManager;


interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, TB2Item, TB2Toolbar, TBX;

type
  TWindowButtonsItem = class;

  TWindowTab = class(TObject)
  private
  fTitle:WideString;
  fItem:TTBXItem;
  procedure SetTitle(S:WideString);
  procedure ItemClick(Sender:TObject);
  public
  Panel:TControl;
  OnHide, OnShow, OnClose:TNotifyEvent;
  ImageIndex:Integer;
  Visible:Boolean;
  property Title: WideString read fTitle write SetTitle;
  procedure Show;
  procedure Hide;
    destructor Destroy; override;
  end;

  TWindowManager = class(TComponent)
  private
    FToolbar: TTBCustomToolbar;
  public
    FButtonsItem: TWindowButtonsItem;
    FTabs:TList;
    FVisibleTab:TWindowTab;
    procedure AddTab(Tab:TWindowTab; Show: Boolean);
    procedure RemoveTab(Tab:TWindowTab);
    procedure HideAll;
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  TWindowButtonItem = class(TTBCustomItem)
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TWindowButtonItemViewer = class(TTBItemViewer)
  protected
    procedure CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer); override;
    procedure Paint(const Canvas: TCanvas; const ClientAreaRect: TRect;
      IsSelected, IsPushed, UseDisabledShadow: Boolean); override;
  end;

  TWindowSepItem = class(TTBSeparatorItem)
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  end;

  TWindowSepItemViewer = class(TTBSeparatorItemViewer)
  protected
    procedure CalcSize (const Canvas: TCanvas; var AWidth, AHeight: Integer); override;
  end;

  TWindowButtonsItem = class(TTBCustomItem)
  public
    FCloseItem: TWindowButtonItem;
  //  FSep1, FSep2: TWindowSepItem;

    
   procedure UpdateState;
    procedure ItemClick(Sender: TObject);

    constructor Create(AOwner: TComponent); override;
  end;

  var WindowManager:TWindowManager;

implementation

uses
  TBXThemes, TB2Common, TB2Consts, CommCtrl;

type
  TTBViewAccess = class(TTBView);
  TTBCustomToolbarAccess = class(TTBCustomToolbar);


//----------------------------------------------------------------------------//

{ TWindowManager }

procedure TWindowManager.HideAll;
begin
if Assigned(WindowManager.FVisibleTab) then
WindowManager.FVisibleTab.Hide;
FButtonsItem.FCloseItem.Visible := False;
FButtonsItem.UpdateState;
end;

constructor TWindowManager.Create (AOwner: TComponent);
begin
  inherited;
  FTabs := TList.Create;
  FButtonsItem := TWindowButtonsItem.Create(Self);
    FToolbar := TTBCustomToolbar(AOwner);
    if Assigned(TTBCustomToolbar(AOwner)) then with TTBCustomToolbarAccess(TTBCustomToolbar(AOwner)) do
    begin
      FreeNotification(Self);
      FMDIButtonsItem := FButtonsItem;
      View.RecreateAllViewers;
    end;

end;

destructor TWindowManager.Destroy;
begin
  FToolbar := nil;
  FTabs.Free;
end;

procedure TWindowManager.AddTab(Tab:TWindowTab; Show: Boolean);
begin
if FTabs.IndexOf(Tab) <> -1 then
 begin
 Tab.Show;
 Exit;
 end;
FTabs.Add(Tab);
Tab.fItem := TTBXItem.Create(FToolbar);
Tab.fItem.OnClick := Tab.ItemClick;
Tab.fItem.Caption := Tab.Title;
Tab.fItem.ImageIndex := Tab.ImageIndex;
Tab.fItem.DisplayMode := nbdmImageAndText;
FToolbar.Items.Add(Tab.fItem);
Tab.fItem.Visible := True;
FToolbar.Visible := True;
if not Assigned(FVisibleTab) then Tab.Show;
if Show then Tab.Show;
FButtonsItem.UpdateState;
end;


procedure TWindowManager.RemoveTab(Tab:TWindowTab);
var i:Integer;
begin
if not Assigned(Tab.fItem) then Exit;

if Tab.Visible then
begin
Tab.Hide;

if FTabs.Count > 0 then
 begin
i := FTabs.IndexOf(Tab);
FTabs.Remove(Tab);
if i >= FTabs.Count then i := FTabs.Count-1;
if i > -1 then
TWindowTab(FTabs[i]).Show;

 end;
end
else
FTabs.Remove(Tab);
     
if FTabs.Count = 0 then
FToolbar.Visible := False;
Tab.fItem.Free;
FButtonsItem.UpdateState;
end;

procedure TWindowTab.Show;
begin
if Visible then Exit;

if not WindowManager.FButtonsItem.FCloseItem.Visible then
 begin
WindowManager.FButtonsItem.FCloseItem.Visible := True;
WindowManager.FButtonsItem.UpdateState;
 end;

Visible := True;
if Assigned(OnShow) then
    OnShow(Self);
fItem.Checked := True;
if Assigned(Panel) then
 begin
Panel.Visible := True;
 end;
if Assigned(WindowManager.FVisibleTab) then
WindowManager.FVisibleTab.Hide;
WindowManager.FVisibleTab := Self;
end;


procedure TWindowTab.SetTitle(S:WideString);
  begin
  fTitle := S;
  if Assigned(fItem) then
    fItem.Caption := S;
  end;
procedure TWindowTab.Hide;
begin
if not Visible then Exit;
if Assigned(Panel) then
 begin
Panel.Visible := False;
 end;
 fItem.Checked := False;
WindowManager.FVisibleTab := nil;

if Assigned(OnHide) then
    OnHide(Self);
Visible := False;
end;

    destructor TWindowTab.Destroy;
    begin
      if Assigned(fItem) then
       WindowManager.RemoveTab(Self);
      inherited;
    end;

procedure TWindowTab.ItemClick(Sender:TObject);
begin
Show;
end;

//----------------------------------------------------------------------------//

{ TWindowButtonItem }

constructor TWindowButtonItem.Create (AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle - [tbisSelectable] + [tbisRightAlign];
end;

function TWindowButtonItem.GetItemViewerClass (AView: TTBView): TTBItemViewerClass;
begin
  Result := TWindowButtonItemViewer;
end;


//----------------------------------------------------------------------------//

{ TWindowButtonItemViewer }

procedure TWindowButtonItemViewer.CalcSize (const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  if NewStyleControls then
  begin
    AWidth := GetSystemMetrics(SM_CXMENUSIZE) - CurrentTheme.MenuMDIDW;
    if AWidth < 0 then AWidth := 0;
    AHeight := GetSystemMetrics(SM_CYMENUSIZE) - CurrentTheme.MenuMDIDH;
    if AHeight < 0 then AHeight := 0;
  end
  else
  begin
    AWidth := 16;
    AHeight := 14;
  end;
end;

procedure TWindowButtonItemViewer.Paint(const Canvas: TCanvas;
  const ClientAreaRect: TRect; IsSelected, IsPushed, UseDisabledShadow: Boolean);
const
  CDesigning: array [Boolean] of Integer = (0, IO_DESIGNING);
var
  ItemInfo: TTBXItemInfo;
begin
  FillChar(ItemInfo, SizeOf(ItemInfo), 0);
  ItemInfo.ViewType := VT_NORMALTOOLBAR; //GetViewType(View);
  ItemInfo.ItemOptions := IO_TOOLBARSTYLE or CDesigning[csDesigning in Item.ComponentState];
  ItemInfo.Enabled := Item.Enabled{ or View.Customizing};
  ItemInfo.Pushed := IsPushed;
  ItemInfo.Selected := False;
  ItemInfo.ImageShown := False;
  ItemInfo.ImageWidth := 0;
  ItemInfo.ImageHeight := 0;
  if IsSelected then
  begin
    if not ItemInfo.Enabled and not TTBViewAccess(View).MouseOverSelected then ItemInfo.HoverKind := hkKeyboardHover
    else if ItemInfo.Enabled then ItemInfo.HoverKind := hkMouseHover;
  end
  else ItemInfo.HoverKind := hkNone;
  ItemInfo.IsVertical := View.Orientation = tbvoVertical;

  CurrentTheme.PaintMDIButton(Canvas.Handle, ClientAreaRect, ItemInfo,
    DFCS_CAPTIONCLOSE);
end;


//----------------------------------------------------------------------------//

{ TWindowSepItem }

function TWindowSepItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TWindowSepItemViewer;
end;


//----------------------------------------------------------------------------//

{ TWindowSepItemViewer }

procedure TWindowSepItemViewer.CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer);
begin
  if View.Orientation <> tbvoVertical then
  begin
    AWidth := 2;
    AHeight := 6;
  end
  else
  begin
    AWidth := 6;
    AHeight := 2;
  end;
end;


//----------------------------------------------------------------------------//

{ TWindowButtonsItem }


constructor TWindowButtonsItem.Create(AOwner: TComponent);

begin
  inherited;
  ItemStyle := ItemStyle + [tbisEmbeddedGroup];
  FCloseItem := TWindowButtonItem.Create(Self);
  FCloseItem.OnClick := ItemClick;

 { FSep1 := TWindowSepItem.Create(Self);
  FSep1.Blank := True;
  FSep1.ItemStyle := FSep1.ItemStyle + [tbisRightAlign, tbisNoLineBreak];
  FSep2 := TWindowSepItem.Create(Self);
  FSep2.Blank := True;
  FSep2.ItemStyle := FSep2.ItemStyle + [tbisRightAlign, tbisNoLineBreak];
  Add(FSep1);
  Add(FSep2); }
  Add(FCloseItem);
  UpdateState;
end;

procedure TWindowButtonsItem.UpdateState;
begin
 if Assigned(TWindowManager(Owner).FToolbar) then
  begin
  TWindowManager(Owner).FToolbar.View.InvalidatePositions;
  TWindowManager(Owner).FToolbar.View.TryValidatePositions;
  end;
end;

procedure TWindowButtonsItem.ItemClick (Sender: TObject);
var Tab:TWindowTab;
begin
if Assigned(WindowManager.FVisibleTab) then
  begin
 Tab := WindowManager.FVisibleTab;

 if Assigned(WindowManager.FVisibleTab.OnClose) then
 WindowManager.FVisibleTab.OnClose(WindowManager.FVisibleTab);

 if Tab.Visible then
 WindowManager.RemoveTab(Tab);



 end;
end;



end.
