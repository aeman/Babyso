object dlgSubmit: TdlgSubmit
  Left = 0
  Top = 0
  Caption = #32593#31449#25552#20132
  ClientHeight = 545
  ClientWidth = 757
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    757
    545)
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 728
    Height = 489
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 186
      Top = 1
      Height = 487
      ExplicitLeft = 288
      ExplicitTop = 160
      ExplicitHeight = 100
    end
    object wbSite: TWebBrowser
      Left = 189
      Top = 1
      Width = 538
      Height = 487
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 432
      ExplicitTop = 65
      ExplicitWidth = 530
      ExplicitHeight = 479
      ControlData = {
        4C0000009B370000553200000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E12620A000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 487
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 41
        Align = alTop
        TabOrder = 0
        object cbbType: TComboBox
          Left = 19
          Top = 11
          Width = 145
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          OnChange = cbbTypeChange
          Items.Strings = (
            #25628#32034#24341#25806
            #20013#25991#30446#24405
            #33521#25991#30446#24405)
        end
      end
      object lvURL: TListView
        Left = 0
        Top = 41
        Width = 185
        Height = 446
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Columns = <
          item
            Caption = #21517#31216
            Width = 150
          end
          item
            Caption = 'URL'
            Width = 500
          end>
        GridLines = True
        RowSelect = True
        SmallImages = fmMain.ImageList
        TabOrder = 1
        ViewStyle = vsReport
        OnClick = lvURLClick
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 668
    Top = 514
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20851#38381
    TabOrder = 1
    Kind = bkClose
  end
end
