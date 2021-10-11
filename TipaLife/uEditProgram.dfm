object frmEditProgram: TfrmEditProgram
  Left = 334
  Top = 173
  Width = 468
  Height = 301
  Caption = 'frmEditProgram'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 122
    Top = 0
    Width = 338
    Height = 273
    Align = alClient
    Lines.Strings = (
      '// '#1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ''
      '  ACT:=0;'
      '  DX:=RND;'
      '  DY:=RND;'
      '  HLP:=0;'
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 122
    Height = 273
    Align = alLeft
    TabOrder = 1
    object Button1: TButton
      Left = 15
      Top = 10
      Width = 92
      Height = 31
      Caption = 'SetProgram'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 17
      Top = 103
      Width = 93
      Height = 31
      Caption = 'Close'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 17
      Top = 54
      Width = 93
      Height = 31
      Caption = 'open'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.vpg'
    Filter = '*.vpg|*.vpg'
    Left = 64
    Top = 44
  end
end
