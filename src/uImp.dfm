object dlgImp: TdlgImp
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #23548#20837#22806#37096#25968#25454
  ClientHeight = 249
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 225
    Shape = bsFrame
  end
  object lblPath: TLabel
    Left = 26
    Top = 56
    Width = 36
    Height = 13
    Caption = #36335#24452#65306
  end
  object lblState: TLabel
    Left = 26
    Top = 85
    Width = 36
    Height = 13
    Caption = #29366#24577#65306
  end
  object Label3: TLabel
    Left = 26
    Top = 27
    Width = 48
    Height = 13
    Caption = #36873#25321#31867#22411
  end
  object btImp: TButton
    Left = 301
    Top = 51
    Width = 75
    Height = 25
    Caption = #23548#20837
    Enabled = False
    TabOrder = 1
    OnClick = btImpClick
  end
  object btClose: TButton
    Left = 301
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = #20851#38381
    ModalResult = 1
    TabOrder = 3
    OnClick = btCloseClick
  end
  object btOpen: TButton
    Left = 301
    Top = 8
    Width = 75
    Height = 25
    Caption = #25171#24320
    TabOrder = 0
    OnClick = btOpenClick
  end
  object Memo1: TMemo
    Left = 26
    Top = 120
    Width = 239
    Height = 97
    ReadOnly = True
    TabOrder = 2
  end
  object cbbType: TComboBox
    Left = 89
    Top = 24
    Width = 176
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      #23548#20837#24555#25429#25163#21382#21490#25968#25454
      #23548#20837#32593#31449#25552#20132#31449#28857)
  end
  object odOpen: TOpenDialog
    Filter = #25968#25454#25991#20214'(*.mdb)|*.mdb'
    Left = 168
    Top = 72
  end
  object adoc: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\Downloads\SEO'#24555#25429#25163 +
      '\data.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 200
    Top = 72
  end
  object adoq: TADOQuery
    Connection = adoc
    Parameters = <>
    Left = 232
    Top = 72
  end
end
