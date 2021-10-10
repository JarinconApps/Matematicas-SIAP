object FVistaJSON: TFVistaJSON
  Left = 0
  Top = 0
  ClientHeight = 506
  ClientWidth = 895
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 895
    Height = 45
    Align = alTop
    Caption = 'Vista de Archivo JSON'
    Color = 12615680
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 1114
  end
  object seConsola: TSynEdit
    Left = 0
    Top = 45
    Width = 895
    Height = 461
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = False
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = 16711808
    Gutter.Font.Height = -16
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = [fsBold]
    Gutter.ShowLineNumbers = True
    Lines.Strings = (
      'seConsola')
    WordWrap = True
    FontSmoothing = fsmNone
    ExplicitWidth = 1114
    ExplicitHeight = 766
  end
end
