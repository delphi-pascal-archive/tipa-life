object Form1: TForm1
  Left = 240
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TipaLife'
  ClientHeight = 322
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object StringGrid1: TStringGrid
    Left = 208
    Top = 0
    Width = 282
    Height = 322
    Align = alClient
    ColCount = 10
    DefaultColWidth = 10
    DefaultRowHeight = 10
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    GridLineWidth = 0
    Options = []
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 208
    Height = 322
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 96
      Top = 44
      Width = 99
      Height = 16
      Caption = 'Number of Class'
    end
    object Label2: TLabel
      Left = 96
      Top = 76
      Width = 89
      Height = 16
      Caption = 'Object in Class'
    end
    object Label3: TLabel
      Left = 97
      Top = 13
      Width = 54
      Height = 16
      Caption = 'Size Grid'
    end
    object Button1: TButton
      Left = 8
      Top = 112
      Width = 193
      Height = 27
      Caption = 'Init'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 176
      Width = 97
      Height = 25
      Caption = 'Step'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 112
      Top = 176
      Width = 89
      Height = 25
      Caption = 'Timer ON'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Edit2: TEdit
      Left = 8
      Top = 39
      Width = 65
      Height = 24
      TabOrder = 3
      Text = '3'
    end
    object UpDown1: TUpDown
      Left = 73
      Top = 39
      Width = 17
      Height = 24
      Associate = Edit2
      Min = 2
      Max = 6
      Position = 3
      TabOrder = 4
    end
    object Edit3: TEdit
      Left = 8
      Top = 69
      Width = 65
      Height = 24
      TabOrder = 5
      Text = '7'
    end
    object UpDown2: TUpDown
      Left = 73
      Top = 69
      Width = 17
      Height = 24
      Associate = Edit3
      Min = 2
      Max = 10
      Position = 7
      TabOrder = 6
    end
    object Edit1: TEdit
      Left = 8
      Top = 8
      Width = 65
      Height = 24
      TabOrder = 7
      Text = '30'
    end
    object UpDown3: TUpDown
      Left = 73
      Top = 8
      Width = 17
      Height = 24
      Associate = Edit1
      Min = 20
      Position = 30
      TabOrder = 8
    end
    object Edit4: TEdit
      Left = 112
      Top = 216
      Width = 73
      Height = 24
      TabOrder = 9
      Text = '500'
    end
    object UpDown4: TUpDown
      Left = 185
      Top = 216
      Width = 16
      Height = 24
      Associate = Edit4
      Min = 100
      Max = 1000
      Increment = 100
      Position = 500
      TabOrder = 10
      Thousands = False
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 152
      Width = 119
      Height = 17
      Caption = 'Randomize'
      Checked = True
      State = cbChecked
      TabOrder = 11
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 8
    Top = 288
  end
end
