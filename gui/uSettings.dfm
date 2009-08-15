object Options: TOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 264
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    379
    264)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 296
    Top = 231
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
    ExplicitTop = 215
  end
  object btnCancel: TButton
    Left = 220
    Top = 231
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
    ExplicitTop = 215
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 363
    Height = 217
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    ExplicitHeight = 230
    object TabSheet1: TTabSheet
      Caption = 'Proxy'
      ExplicitHeight = 173
      object GroupBox1: TGroupBox
        Left = 6
        Top = 3
        Width = 342
        Height = 86
        Caption = 'Server Settings'
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 25
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object Label6: TLabel
          Left = 253
          Top = 56
          Width = 27
          Height = 13
          Caption = 'Game'
        end
        object Label5: TLabel
          Left = 131
          Top = 56
          Width = 29
          Height = 13
          Caption = 'Realm'
        end
        object Label4: TLabel
          Left = 16
          Top = 56
          Width = 23
          Height = 13
          Caption = 'Chat'
        end
        object PServer: TComboBox
          Left = 49
          Top = 22
          Width = 280
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'uswest.battle.net'
          Items.Strings = (
            'uswest.battle.net'
            'useast.battle.net'
            'asia.battle.net'
            'europe.battle.net')
        end
        object sGame: TEdit
          Left = 286
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 1
          Text = '4000'
        end
        object sRealm: TEdit
          Left = 166
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 2
          Text = '6112'
        end
        object sChat: TEdit
          Left = 49
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 3
          Text = '6112'
        end
      end
      object GroupBox2: TGroupBox
        Left = 6
        Top = 95
        Width = 342
        Height = 86
        Caption = 'Local Settings'
        TabOrder = 1
        object Label8: TLabel
          Left = 253
          Top = 56
          Width = 27
          Height = 13
          Caption = 'Game'
        end
        object Label11: TLabel
          Left = 131
          Top = 56
          Width = 29
          Height = 13
          Caption = 'Realm'
        end
        object Label12: TLabel
          Left = 16
          Top = 56
          Width = 23
          Height = 13
          Caption = 'Chat'
        end
        object Label3: TLabel
          Left = 16
          Top = 25
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object cGame: TEdit
          Left = 286
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 0
          Text = '4000'
        end
        object cRealm: TEdit
          Left = 166
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 1
          Text = '6113'
        end
        object cChat: TEdit
          Left = 49
          Top = 53
          Width = 43
          Height = 21
          TabOrder = 2
          Text = '6112'
        end
        object PClient: TComboBox
          Left = 49
          Top = 22
          Width = 280
          Height = 21
          ItemHeight = 13
          TabOrder = 3
          Text = 'localhost'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Interface'
      ImageIndex = 1
      ExplicitHeight = 186
      DesignSize = (
        355
        189)
      object GroupBox4: TGroupBox
        Left = 6
        Top = 66
        Width = 343
        Height = 115
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Log'
        TabOrder = 0
        object LogFont: TShape
          Left = 288
          Top = 24
          Width = 41
          Height = 16
          Pen.Color = cl3DDkShadow
          OnMouseDown = ColorShapeMouseDown
        end
        object Label9: TLabel
          Left = 179
          Top = 26
          Width = 50
          Height = 13
          Caption = 'Font Color'
        end
        object Label10: TLabel
          Left = 179
          Top = 56
          Width = 84
          Height = 13
          Caption = 'Background Color'
        end
        object LogBack: TShape
          Left = 288
          Top = 55
          Width = 41
          Height = 17
          Pen.Color = cl3DDkShadow
          OnMouseDown = ColorShapeMouseDown
        end
        object LogSelBack: TShape
          Left = 288
          Top = 85
          Width = 41
          Height = 17
          Pen.Color = cl3DDkShadow
          OnMouseDown = ColorShapeMouseDown
        end
        object Label1: TLabel
          Left = 179
          Top = 85
          Width = 71
          Height = 13
          Caption = 'Selection Color'
        end
        object FontChange: TButton
          Left = 10
          Top = 21
          Width = 89
          Height = 25
          Caption = 'Change Font'
          TabOrder = 0
          OnClick = FontChangeClick
        end
        object GridPanel: TGridPanel
          Left = 10
          Top = 56
          Width = 147
          Height = 45
          BevelKind = bkFlat
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = FontSample
              Row = 0
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 100.000000000000000000
            end>
          TabOrder = 1
          DesignSize = (
            143
            41)
          object FontSample: TLabel
            Left = 34
            Top = 14
            Width = 74
            Height = 13
            Anchors = []
            Caption = 'This is a sample'
            ExplicitLeft = 40
            ExplicitTop = 6
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 6
        Top = 3
        Width = 343
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Window'
        TabOrder = 1
        DesignSize = (
          343
          57)
        object Label7: TLabel
          Left = 16
          Top = 25
          Width = 20
          Height = 13
          Caption = 'Title'
        end
        object WindowTitle: TEdit
          Left = 49
          Top = 22
          Width = 280
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
    end
  end
  object ColorDialog: TColorDialog
    Left = 224
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [fdNoStyleSel]
    Left = 256
  end
end
