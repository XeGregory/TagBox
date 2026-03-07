object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'TagBox'
  ClientHeight = 142
  ClientWidth = 432
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  TextHeight = 15
  object PaintBox1: TPaintBox
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 426
    Height = 107
    Align = alClient
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
    ExplicitLeft = 24
    ExplicitTop = 40
    ExplicitWidth = 545
    ExplicitHeight = 105
  end
  object Edit1: TEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 426
    Height = 23
    Align = alTop
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 121
  end
end
