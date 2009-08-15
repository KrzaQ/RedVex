object SetupHelp: TSetupHelp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RedVex'
  ClientHeight = 200
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 135
    Height = 200
    Align = alLeft
    ExplicitLeft = -6
  end
  object MainPanel: TPanel
    Left = 135
    Top = 0
    Width = 306
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object pnlWelcome: TPanel
      Left = 0
      Top = 0
      Width = 306
      Height = 160
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      Visible = False
      object LabelWelcome: TLabel
        Left = 8
        Top = 8
        Width = 282
        Height = 145
        AutoSize = False
        Caption = 
          'It looks like you are running RedVex for the first time. This gu' +
          'ide will help you set RedVex correctly up.'#13#10#13#10'To start the guide' +
          ' click '#39'Next'#39
        Color = clWindow
        ParentColor = False
        WordWrap = True
      end
    end
    object pnlRealms: TPanel
      Left = 0
      Top = 0
      Width = 306
      Height = 160
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 2
      Visible = False
      object LabelRealm: TLabel
        Left = 8
        Top = 8
        Width = 282
        Height = 19
        AutoSize = False
        Caption = 'Which realm do you play on?'
        Color = clWindow
        ParentColor = False
        WordWrap = True
      end
      object rbWest: TRadioButton
        Left = 32
        Top = 31
        Width = 113
        Height = 17
        Caption = 'US West'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbEast: TRadioButton
        Left = 32
        Top = 54
        Width = 113
        Height = 17
        Caption = 'US East'
        TabOrder = 1
      end
      object rbAsia: TRadioButton
        Left = 32
        Top = 77
        Width = 113
        Height = 17
        Caption = 'Asia'
        TabOrder = 2
      end
      object rbEurope: TRadioButton
        Left = 32
        Top = 100
        Width = 113
        Height = 17
        Caption = 'Europe'
        TabOrder = 3
      end
    end
    object pnlDiabloRealm: TPanel
      Left = 0
      Top = 0
      Width = 306
      Height = 160
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 3
      Visible = False
      object DiabloRealmLabel: TLabel
        Left = 8
        Top = 8
        Width = 289
        Height = 40
        AutoSize = False
        Caption = 
          'You have no RedVex realm in Diablo II, do you want to create one' +
          ' now?'
        Color = clWindow
        ParentColor = False
        WordWrap = True
      end
      object mRealmLabel: TLabel
        Left = 56
        Top = 77
        Width = 63
        Height = 13
        Caption = 'Realm Name:'
      end
      object mDiabloRealm: TRadioButton
        Left = 24
        Top = 50
        Width = 249
        Height = 17
        Caption = 'Yes, make a Diablo II realm for me'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object mDiabloRealmName: TEdit
        Left = 125
        Top = 73
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object mNoDiabloRealm: TRadioButton
        Left = 24
        Top = 123
        Width = 233
        Height = 17
        Caption = 'No thanks, I will make my own realm'
        TabOrder = 2
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 160
      Width = 306
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 306
        Height = 2
        Align = alTop
      end
      object btnRight: TButton
        Left = 224
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Next'
        Default = True
        TabOrder = 0
        OnClick = btnRightClick
      end
      object btnLeft: TButton
        Left = 143
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Back'
        TabOrder = 1
        OnClick = btnLeftClick
      end
    end
    object pnlFinal: TPanel
      Left = 0
      Top = 0
      Width = 306
      Height = 160
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 4
      Visible = False
      object lblFinish: TLabel
        Left = 8
        Top = 8
        Width = 282
        Height = 145
        AutoSize = False
        Caption = 
          'RedVex is now properly setup and you may run it by using the '#39'St' +
          'art'#39' button or the Ctrl+S shortcut.'#13#10#13#10'Click '#39'Finish'#39' to start R' +
          'edVex.'
        Color = clWindow
        ParentColor = False
        WordWrap = True
      end
    end
  end
end
