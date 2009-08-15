object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'RedVex'
  ClientHeight = 597
  ClientWidth = 636
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Log: TSynEdit
    Left = 0
    Top = 75
    Width = 636
    Height = 522
    Margins.Left = 30
    Margins.Top = 10
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    PopupMenu = LogPopupMenu
    TabOrder = 2
    BorderStyle = bsNone
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Visible = False
    Gutter.Width = 0
    Options = [eoNoCaret, eoScrollPastEol, eoTabsToSpaces]
    ReadOnly = True
    RightEdge = 0
    ScrollBars = ssVertical
    SelectionMode = smLine
  end
  object Plugins: TListView
    Left = 0
    Top = 75
    Width = 636
    Height = 522
    Align = alClient
    Columns = <
      item
        Caption = 'Filename'
        Width = 120
      end
      item
        Caption = 'State'
        Width = 70
      end
      item
        Caption = 'Title'
        Width = 200
      end
      item
        Caption = 'Author'
        Width = 75
      end
      item
        Caption = 'SDK Version'
        Width = 75
      end>
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    Visible = False
  end
  object tbxDock: TTBXDock
    Left = 0
    Top = 0
    Width = 636
    Height = 75
    object tblTabs: TTBXToolbar
      Left = 0
      Top = 49
      BorderStyle = bsNone
      DockPos = 0
      DockRow = 2
      FullSize = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      Visible = False
      Caption = 'Tabs'
    end
    object tbxMainMenu: TTBXToolbar
      Left = 0
      Top = 0
      BorderStyle = bsNone
      CloseButton = False
      DockMode = dmCannotFloat
      DockPos = 0
      FullSize = True
      Images = ImagesToolbar
      MenuBar = True
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      TabOrder = 1
      Caption = 'Menubar'
      object TBXSubmenuItem1: TTBXSubmenuItem
        Caption = '&Proxy'
        Hint = ''
        object TBXItem2: TTBXItem
          Action = ProxyStart
        end
        object TBXItem3: TTBXItem
          Action = ProxyStop
        end
        object TBXSeparatorItem1: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object TBXItem4: TTBXItem
          Action = ProxyCloseToTray
        end
        object TBXSeparatorItem2: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object TBXItem5: TTBXItem
          Action = ProxyQuit
        end
      end
      object TBXSubmenuItem2: TTBXSubmenuItem
        Caption = '&Settings'
        Hint = ''
        object TBXItem7: TTBXItem
          Action = SettingsRealms
        end
        object TBXItem6: TTBXItem
          Action = SettingsOptions
        end
        object TBXItem1: TTBXItem
          Action = SettingsPlugins
        end
      end
      object TBXSubmenuItem3: TTBXSubmenuItem
        Caption = '&About'
        Hint = ''
        object TBXItem8: TTBXItem
          Action = HelpAbout
        end
      end
    end
    object tbxProxy: TTBXToolbar
      Left = 0
      Top = 23
      BorderStyle = bsNone
      DockPos = -6
      DockRow = 1
      Images = ImagesToolbar
      TabOrder = 2
      Caption = 'Proxy'
      object TBXItem14: TTBXItem
        Action = ProxyStart
        DisplayMode = nbdmImageAndText
        Caption = 'Start'
      end
      object TBXItem13: TTBXItem
        Action = ProxyStop
        DisplayMode = nbdmImageAndText
      end
    end
    object tblPlugin: TTBXToolbar
      Left = 110
      Top = 23
      BorderStyle = bsNone
      DockPos = 92
      DockRow = 1
      Images = ImagesPlugins
      TabOrder = 3
      Visible = False
      Caption = 'Plugins'
      object TBXItem15: TTBXItem
        Action = PluginsReload
        DisplayMode = nbdmImageAndText
      end
      object TBXItem16: TTBXItem
        Action = PluginsEnable
        DisplayMode = nbdmImageAndText
      end
      object TBXItem17: TTBXItem
        Action = PluginsDisable
        DisplayMode = nbdmImageAndText
      end
      object TBXSeparatorItem5: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object TBXItem18: TTBXItem
        Action = PluginsRefresh
        DisplayMode = nbdmImageAndText
      end
    end
  end
  object TrayIcon: TTrayIcon
    Icon.Data = {
      0000010001001020000001000800680500001600000028000000100000002000
      000001000800000000000000000000000000000000000001000000000000FFFF
      FF00CCFFFF0099FFFF0066FFFF0033FFFF0000FFFF00FFCCFF00CCCCFF0099CC
      FF0066CCFF0033CCFF0000CCFF00FF99FF00CC99FF009999FF006699FF003399
      FF000099FF00FF66FF00CC66FF009966FF006666FF003366FF000066FF00FF33
      FF00CC33FF009933FF006633FF003333FF000033FF00FF00FF00CC00FF009900
      FF006600FF003300FF000000FF00FFFFCC00CCFFCC0099FFCC0066FFCC0033FF
      CC0000FFCC00FFCCCC00CCCCCC0099CCCC0066CCCC0033CCCC0000CCCC00FF99
      CC00CC99CC009999CC006699CC003399CC000099CC00FF66CC00CC66CC009966
      CC006666CC003366CC000066CC00FF33CC00CC33CC009933CC006633CC003333
      CC000033CC00FF00CC00CC00CC009900CC006600CC003300CC000000CC00FFFF
      9900CCFF990099FF990066FF990033FF990000FF9900FFCC9900CCCC990099CC
      990066CC990033CC990000CC9900FF999900CC99990099999900669999003399
      990000999900FF669900CC66990099669900666699003366990000669900FF33
      9900CC33990099339900663399003333990000339900FF009900CC0099009900
      9900660099003300990000009900FFFF6600CCFF660099FF660066FF660033FF
      660000FF6600FFCC6600CCCC660099CC660066CC660033CC660000CC6600FF99
      6600CC99660099996600669966003399660000996600FF666600CC6666009966
      6600666666003366660000666600FF336600CC33660099336600663366003333
      660000336600FF006600CC00660099006600660066003300660000006600FFFF
      3300CCFF330099FF330066FF330033FF330000FF3300FFCC3300CCCC330099CC
      330066CC330033CC330000CC3300FF993300CC99330099993300669933003399
      330000993300FF663300CC66330099663300666633003366330000663300FF33
      3300CC33330099333300663333003333330000333300FF003300CC0033009900
      3300660033003300330000003300FFFF0000CCFF000099FF000066FF000033FF
      000000FF0000FFCC0000CCCC000099CC000066CC000033CC000000CC0000FF99
      0000CC99000099990000669900003399000000990000FF660000CC6600009966
      0000666600003366000000660000FF330000CC33000099330000663300003333
      000000330000FF000000CC0000009900000066000000330000000000EE000000
      DD000000BB000000AA0000008800000077000000550000004400000022000000
      110000EE000000DD000000BB000000AA00000088000000770000005500000044
      00000022000000110000EE000000DD000000BB000000AA000000880000007700
      000055000000440000002200000011000000EEEEEE00DDDDDD00BBBBBB00AAAA
      AA0088888800777777005555550044444400222222001111110000000000FFFF
      FFFFFFFF1515151515FFFFFFFFFFFFFFFFFFFF15000000000015FFFFFFFFFFFF
      FFFF150017D9D917070015FFFFFFFFFFFFFF15001D1DD723170015FFFFFFFFFF
      FF15001D1D1DDCD71D070015FFFFFFFFFF15001D1DDCDCD81D170015FFFFFFFF
      FF15001D1DDCDEDCD7D80015FFFFFFFFFF1500D965DCDEDCD7D70015FFFFFFFF
      FF1500171765DEDCD71D0015FFFFFFFFFF15001717DCDDDC1D170015FFFFFFFF
      FF1500171DDCDCD7D71D0015FFFFFFFFFF15003F1D1DD8D9D71D0015FFFFFFFF
      FFFF15001DD8D9D91D0015FFFFFFFFFFFFFF15003FD8D9D8070015FFFFFFFFFF
      FFFFFF15000000000015FFFFFFFFFFFFFFFFFFFF1515151515FFFFFFFFFFFC1F
      EA0EF80FFC1FF007F80FF007F007E003F007E003E003E003E003E003E003E003
      E003E003E003E003E003E003E003F007E003F007F007F80FF007FC1FF80F}
    PopupMenu = TrayIconPopupMenu
    Visible = True
    OnDblClick = TrayIconDblClick
    Left = 444
    Top = 244
  end
  object ActionList: TActionList
    Left = 288
    Top = 432
    object ProxyStart: TAction
      Category = 'Proxy'
      Caption = '&Start'
      ImageIndex = 0
      ShortCut = 16467
      OnExecute = ProxyStartExecute
      OnUpdate = ProxyStartUpdate
    end
    object ProxyStop: TAction
      Category = 'Proxy'
      Caption = 'Stop'
      Enabled = False
      ImageIndex = 1
      ShortCut = 16468
      OnExecute = ProxyStopExecute
      OnUpdate = ProxyStopUpdate
    end
    object ProxyQuit: TAction
      Category = 'Proxy'
      Caption = '&Quit'
      OnExecute = ProxyQuitExecute
    end
    object SettingsOptions: TAction
      Category = 'Settings'
      Caption = '&Options'
      ImageIndex = 3
      OnExecute = SettingsOptionsExecute
    end
    object SettingsRealms: TAction
      Category = 'Settings'
      Caption = '&Realms'
      OnExecute = SettingsRealmsExecute
    end
    object HelpAbout: TAction
      Category = 'Help'
      Caption = '&About RedVex'
      ImageIndex = 2
      OnExecute = HelpAboutExecute
    end
    object TrayIconOpen: TAction
      Category = 'TrayIcon'
      Caption = '&Open RedVex'
      OnExecute = TrayIconOpenExecute
    end
    object LogCopy: TAction
      Category = 'Log'
      Caption = '&Copy'
      ShortCut = 16451
      OnExecute = LogCopyExecute
    end
    object ProxyCloseToTray: TAction
      Category = 'Proxy'
      Caption = '&Minimize to tray'
      OnExecute = ProxyCloseToTrayExecute
    end
    object PluginsRefresh: TAction
      Category = 'Plugins'
      Caption = 'Refresh'
      ImageIndex = 1
      OnExecute = PluginsRefreshExecute
    end
    object PluginsReload: TAction
      Category = 'Plugins'
      Caption = 'Reload'
      ImageIndex = 0
      OnExecute = PluginsReloadExecute
      OnUpdate = PluginsReloadUpdate
    end
    object PluginsEnable: TAction
      Category = 'Plugins'
      Caption = 'Enable'
      ImageIndex = 3
      OnExecute = PluginsEnableExecute
      OnUpdate = PluginsEnableUpdate
    end
    object PluginsDisable: TAction
      Category = 'Plugins'
      Caption = 'Disable'
      ImageIndex = 2
      OnExecute = PluginsDisableExecute
      OnUpdate = PluginsDisableUpdate
    end
    object SettingsPlugins: TAction
      Category = 'Settings'
      Caption = '&Manage plugins'
      ImageIndex = 4
      OnExecute = SettingsPluginsExecute
    end
  end
  object TrayIconPopupMenu: TTBXPopupMenu
    Left = 408
    Top = 352
    object TBXItem9: TTBXItem
      Action = TrayIconOpen
    end
    object TBXSeparatorItem3: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object TBXItem10: TTBXItem
      Action = ProxyStart
    end
    object TBXItem11: TTBXItem
      Action = ProxyStop
    end
    object TBXSeparatorItem4: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object TBXItem12: TTBXItem
      Action = ProxyQuit
    end
  end
  object LogPopupMenu: TTBXPopupMenu
    Left = 376
    Top = 352
    object TBXItem19: TTBXItem
      Action = LogCopy
    end
  end
  object LogTimer: TTimer
    Interval = 200
    OnTimer = LogTimerTimer
    Left = 320
    Top = 432
  end
  object ImagesToolbar: TTBXImageList
    Left = 408
    Top = 248
    PngDIB = {
      0500000089504E470D0A1A0A0000000D49484452000000100000005008030000
      002775053F0000009F504C5445FFFFFF74983BA7C07CEEF7D4C2E16797B753B8
      B7AD9B0000C44444FFA5A5FF5858C42424678FB19DB8CFEBF2F9C4D9EEAFCCE8
      FFFFFFDCE9F572A6D697BDE197B4CD333333818181808080EDEDEDE9E9E97D7D
      7DE5E5E57B7B7B787878E3E3E3E0E0E0DDDDDDDBDBDAD8D8D87676767C7C7CE1
      E1E1DEDEDEDBDBDB777777E2E2E2DFDFDFDCDCDCDADADAD4D4D4D0D0D0737373
      727272C29E21D5B654EDD4925A5C27C40000000174524E530040E6D866000001
      AE4944415478019D94E972C2300C846D020E10012101F7A0F74DEF06BFFFB375
      25D92199FE29681CA1FDBC929D990CC61C17D6F6FBEC60D04736CBB21E62D043
      0A18C55176A8314AB3158CAC751D07CBA48D1DF5A4310EE67657BA5C5F0A3B38
      E5D2A199CB7CCCB566D513907CCC39EA09EAF1843303873D08AC71AE174A2469
      DC3D9F72C47D74E505EB69C167419AA8A789882E626683435DE4313330A8314F
      B300103EDF81AAC6B9523095E25F8938F64EA2D97C3E9F1145C472512E1829A1
      F9A2440B905A60284B5A5259A28B2D6C1047B25055D7B45C525DD795F450B562
      02B08A602D16806A2D0EC7160CAD61D0D7A17585AE55150D78576204496A0071
      B81751F733711C7CA9831E8FE836F893539F0E11EECF587BA925F973088F4794
      317E7371E9FD550BFCE6FAE6F6EEFE4101C63F3E3DBF6CF12B63E17E7D7BFFD8
      7ADC5606786E865B7699786CF94F3E94151E2EFD978E83C4CBE3D0EF9F0E804E
      F3C58084F1ED44C8635693223637BBA0B16B943421ECE001DE830607837700BC
      3DA02D76EF90A1368BFF1FF0866083CD861D805DE84E8B1D42870E087668430B
      70ABA6B19C713A162E9516D49FF50B94572AD7DD4640A00000000049454E4400
      000000}
  end
  object ImagesPlugins: TTBXImageList
    Left = 376
    Top = 248
    PngDIB = {
      0400000089504E470D0A1A0A0000000D49484452000000100000004008030000
      0024A307A400000036504C5445FFFFFFC29E21D5B654EDD492B8B7AD9B0000FA
      6002714A00AF811AE9D49333333374983BEEF7D4C2E167EAD27DEFDC9FF4E9CB
      D6D5CABBE8B4750000000174524E530040E6D866000000DA494441547801AD92
      ED1284200845356B6D97327BFF97DD2B1F6AB37F762C8668380222EADC3FE24D
      34D84F4164F2427C081362801BF0F33C837700B11760290B169CC392140DCB8B
      49057165BF46C435728681F88E6D9752E313830174A52A2968CA54C088D58A5E
      37718FCE83B4AA1D9F36921E1950A06DEF0056E17729B4C3AFC72FD3A09D4205
      DC3A152B456D18F80B18B1C94493D391458E2424E57C2006B881749E27780710
      7B013F295234B794FB005DA96277289A328537A865BCFC69FEA3EFA35E65B95B
      FEBADB67FF4E04B7CD467AC7BB301570B55F5C850D2C74B1E540000000004945
      4E4400000000}
  end
end
