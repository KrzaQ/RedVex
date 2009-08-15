object Realms: TRealms
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Realms'
  ClientHeight = 208
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Caption = 'Diablo II Realms'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 16
      Top = 59
      Width = 43
      Height = 13
      Caption = 'Address:'
    end
    object Label4: TLabel
      Left = 16
      Top = 97
      Width = 49
      Height = 13
      Caption = 'Timezone:'
    end
    object RealmName: TEdit
      Left = 72
      Top = 21
      Width = 98
      Height = 21
      TabOrder = 0
    end
    object RealmAddress: TEdit
      Left = 72
      Top = 56
      Width = 98
      Height = 21
      TabOrder = 1
    end
    object RealmTimezone: TEdit
      Left = 71
      Top = 94
      Width = 99
      Height = 21
      TabOrder = 2
    end
    object btnAdd: TButton
      Left = 96
      Top = 123
      Width = 58
      Height = 25
      Caption = 'Add'
      TabOrder = 3
      OnClick = btnAddClick
    end
    object btnRemove: TButton
      Left = 160
      Top = 123
      Width = 58
      Height = 25
      Caption = 'Remove'
      TabOrder = 4
      OnClick = btnRemoveClick
    end
    object btnApply: TButton
      Left = 224
      Top = 123
      Width = 57
      Height = 25
      Caption = 'Apply'
      TabOrder = 5
      OnClick = btnApplyClick
    end
    object RealmList: TListBox
      Left = 176
      Top = 21
      Width = 105
      Height = 96
      ItemHeight = 13
      TabOrder = 6
      OnClick = RealmListClick
    end
  end
  object btnOK: TButton
    Left = 232
    Top = 175
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 151
    Top = 175
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
