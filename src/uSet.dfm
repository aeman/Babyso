object dlgSet: TdlgSet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35774#32622
  ClientHeight = 309
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 24
    Top = 18
    Width = 337
    Height = 236
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 52
    Top = 170
    Width = 24
    Height = 12
    Caption = #22320#22336
  end
  object Label2: TLabel
    Left = 222
    Top = 170
    Width = 24
    Height = 12
    Caption = #31471#21475
  end
  object Label3: TLabel
    Left = 52
    Top = 211
    Width = 24
    Height = 12
    Caption = #29992#25143
  end
  object Label4: TLabel
    Left = 222
    Top = 211
    Width = 24
    Height = 12
    Caption = #23494#30721
  end
  object edtServer: TEdit
    Left = 82
    Top = 167
    Width = 121
    Height = 20
    Enabled = False
    TabOrder = 3
  end
  object edtPort: TEdit
    Left = 252
    Top = 167
    Width = 89
    Height = 20
    Enabled = False
    TabOrder = 4
  end
  object btnOk: TBitBtn
    Left = 205
    Top = 268
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 7
    OnClick = btnOkClick
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 286
    Top = 268
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 8
    NumGlyphs = 2
  end
  object rbNoProxy: TRadioButton
    Left = 52
    Top = 48
    Width = 113
    Height = 17
    Caption = #19981#20351#29992#20195#29702
    TabOrder = 0
    OnClick = rbNoProxyClick
  end
  object rbBrowProxy: TRadioButton
    Tag = 1
    Left = 52
    Top = 88
    Width = 113
    Height = 17
    Caption = #20351#29992#27983#35272#22120#20195#29702
    TabOrder = 1
    OnClick = rbNoProxyClick
  end
  object rbUserProxy: TRadioButton
    Tag = 2
    Left = 52
    Top = 128
    Width = 113
    Height = 17
    Caption = #33258#23450#20041#20195#29702
    TabOrder = 2
    OnClick = rbNoProxyClick
  end
  object edtUser: TEdit
    Left = 82
    Top = 208
    Width = 121
    Height = 20
    TabOrder = 5
  end
  object edtPassword: TEdit
    Left = 252
    Top = 208
    Width = 89
    Height = 20
    TabOrder = 6
  end
end
