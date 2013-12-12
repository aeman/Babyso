object dlgReg: TdlgReg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #24341#25806#37197#32622
  ClientHeight = 507
  ClientWidth = 603
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 498
    Top = 474
    Width = 75
    Height = 25
    Cancel = True
    Caption = #20851#38381
    ModalResult = 2
    TabOrder = 1
  end
  object pgSet: TPageControl
    Left = 8
    Top = 8
    Width = 585
    Height = 457
    ActivePage = TabSheet1
    TabOrder = 0
    OnChange = pgSetChange
    object TabSheet1: TTabSheet
      Caption = #31449#28857#37197#32622
      object Bevel1: TBevel
        Left = 11
        Top = 15
        Width = 550
        Height = 395
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 249
        Top = 31
        Width = 48
        Height = 13
        Caption = #27979#35797#31449#28857
      end
      object Label2: TLabel
        Left = 37
        Top = 58
        Width = 43
        Height = 13
        Caption = #25628#32034'URL'
      end
      object Label3: TLabel
        Left = 37
        Top = 31
        Width = 48
        Height = 13
        Caption = #24403#21069#24341#25806
      end
      object Label4: TLabel
        Left = 36
        Top = 347
        Width = 36
        Height = 13
        Caption = #34920#36798#24335
      end
      object Label5: TLabel
        Left = 249
        Top = 347
        Width = 48
        Height = 13
        Caption = #21305#37197#32467#26524
      end
      object Label6: TLabel
        Left = 36
        Top = 376
        Width = 43
        Height = 13
        Caption = #20445#23384'URL'
      end
      object Label7: TLabel
        Left = 249
        Top = 376
        Width = 46
        Height = 13
        Caption = #20445#23384'Expr'
      end
      object meContent: TMemo
        Left = 37
        Top = 81
        Width = 495
        Height = 250
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 4
      end
      object edUrl: TEdit
        Left = 91
        Top = 54
        Width = 440
        Height = 21
        TabOrder = 3
      end
      object btGo: TButton
        Left = 456
        Top = 25
        Width = 75
        Height = 25
        Caption = #25628#32034
        TabOrder = 0
        OnClick = btGoClick
      end
      object edRegExpr: TEdit
        Left = 86
        Top = 343
        Width = 144
        Height = 21
        TabOrder = 6
      end
      object btMatch: TButton
        Left = 456
        Top = 341
        Width = 75
        Height = 25
        Caption = #21305#37197
        TabOrder = 5
        OnClick = btMatchClick
      end
      object edResult: TEdit
        Left = 303
        Top = 343
        Width = 147
        Height = 21
        ReadOnly = True
        TabOrder = 7
      end
      object edUrlg: TEdit
        Left = 85
        Top = 372
        Width = 144
        Height = 21
        ReadOnly = True
        TabOrder = 10
      end
      object btGen: TButton
        Left = 456
        Top = 370
        Width = 75
        Height = 25
        Caption = #26684#24335
        Enabled = False
        TabOrder = 9
        OnClick = btGenClick
      end
      object edExprg: TEdit
        Left = 303
        Top = 370
        Width = 147
        Height = 21
        ReadOnly = True
        TabOrder = 8
      end
      object edSite: TEdit
        Left = 303
        Top = 27
        Width = 147
        Height = 21
        TabOrder = 2
        Text = 'www.sina.com.cn'
      end
      object cbSeo: TComboBox
        Left = 91
        Top = 27
        Width = 144
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbSeoChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20851#38190#23383#37197#32622
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bevel2: TBevel
        Left = 11
        Top = 15
        Width = 550
        Height = 395
        Shape = bsFrame
      end
      object Label8: TLabel
        Left = 225
        Top = 30
        Width = 60
        Height = 13
        Caption = #27979#35797#20851#38190#23383
      end
      object Label9: TLabel
        Left = 37
        Top = 58
        Width = 43
        Height = 13
        Caption = #25628#32034'URL'
      end
      object Label10: TLabel
        Left = 37
        Top = 31
        Width = 48
        Height = 13
        Caption = #24403#21069#24341#25806
      end
      object Label11: TLabel
        Left = 36
        Top = 347
        Width = 36
        Height = 13
        Caption = #34920#36798#24335
      end
      object Label12: TLabel
        Left = 346
        Top = 347
        Width = 48
        Height = 13
        Caption = #21305#37197#32467#26524
      end
      object Label13: TLabel
        Left = 36
        Top = 376
        Width = 43
        Height = 13
        Caption = #20445#23384'URL'
      end
      object Label14: TLabel
        Left = 249
        Top = 376
        Width = 46
        Height = 13
        Caption = #20445#23384'Expr'
      end
      object Label15: TLabel
        Left = 377
        Top = 30
        Width = 24
        Height = 13
        Caption = #39029#25968
      end
      object edUrl2: TEdit
        Left = 91
        Top = 54
        Width = 440
        Height = 21
        TabOrder = 4
      end
      object btGo2: TButton
        Left = 456
        Top = 25
        Width = 75
        Height = 25
        Caption = #25628#32034
        TabOrder = 0
        OnClick = btGo2Click
      end
      object edRegExpr2: TEdit
        Left = 86
        Top = 343
        Width = 243
        Height = 21
        TabOrder = 8
      end
      object btMatch2: TButton
        Left = 456
        Top = 341
        Width = 75
        Height = 25
        Caption = #21305#37197
        TabOrder = 7
        OnClick = btMatch2Click
      end
      object edExprg2: TEdit
        Left = 303
        Top = 372
        Width = 147
        Height = 21
        ReadOnly = True
        TabOrder = 12
      end
      object edUrlg2: TEdit
        Left = 85
        Top = 372
        Width = 144
        Height = 21
        ReadOnly = True
        TabOrder = 11
      end
      object btGen2: TButton
        Left = 456
        Top = 370
        Width = 75
        Height = 25
        Caption = #26684#24335
        Enabled = False
        TabOrder = 10
        OnClick = btGen2Click
      end
      object edResult2: TEdit
        Left = 404
        Top = 343
        Width = 46
        Height = 21
        ReadOnly = True
        TabOrder = 9
      end
      object edKey: TEdit
        Left = 291
        Top = 27
        Width = 78
        Height = 21
        TabOrder = 2
        Text = #36275#29699
      end
      object cbSeo2: TComboBox
        Left = 91
        Top = 27
        Width = 118
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
        OnChange = cbSeo2Change
      end
      object cbPage: TComboBox
        Left = 408
        Top = 27
        Width = 42
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 3
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10')
      end
      object lbContent: TListBox
        Left = 37
        Top = 223
        Width = 494
        Height = 112
        ItemHeight = 13
        TabOrder = 6
      end
      object meContent2: TMemo
        Left = 37
        Top = 81
        Width = 495
        Height = 136
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 5
      end
    end
  end
end
