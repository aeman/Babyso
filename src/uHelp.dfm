object twHelp: TtwHelp
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #27491#21017#34920#36798#24335#24110#21161
  ClientHeight = 400
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object mmoHelp: TMemo
    Left = 0
    Top = 0
    Width = 280
    Height = 400
    Align = alClient
    Color = clCream
    Lines.Strings = (
      #27491#21017#34920#36798#24335' - '#39044#23450#20041#26631#35782
      ''
      '  \w     '#19968#20010'ASCII'#23383#31526'('#21253#25324' "_")'
      '  \W     '#19968#20010#38750'ASCII'#23383#31526
      '  \d     '#19968#20010#25968#23383#22411#23383#31526
      '  \D     '#19968#20010#38750#25968#23383#22411#23383#31526
      '  \s     '#19968#20010#31354#26684' ([\t\n\r\f]'#26631#35782#65292#20197#27492#31867#25512')'
      '  \S     '#19968#20010#38750#31354#26684
      ''
      #20351#29992'\w, \d and \s '#33258#23450#20041#21305#37197#23383#31526#20018
      ''
      #20363#23376':'
      'foob\dr '#21305#37197#21040' '#39'foob1r'#39', '#39#39'foob6r'#39' '#19981#20250#21305#37197' '
      #39'foobar'#39', '#39'foobbr'#39' '#31561
      ''
      'foob[\w\s]r '#21305#37197#21040' '#39'foobar'#39', '#39'foob r'#39', '
      #39'foobbr'#39' '#19981#20250#21305#37197' '#39'foob1r'#39', '#39'foob=r'#39' '#31561)
    ReadOnly = True
    TabOrder = 0
    ExplicitWidth = 250
  end
end
