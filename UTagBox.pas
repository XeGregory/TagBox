unit UTagBox;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Math,
  System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Graphics,
  Winapi.Windows;

type
  TTag = record
    Text: string;
    Rect: TRect;
    CloseRect: TRect;
    Color: TColor;
  end;

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    FTags: TList<TTag>;
    procedure AddTag(const AText: string);
    procedure RecalculateTagRects;
    function TagExists(const AText: string): Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTags := TList<TTag>.Create;
  PaintBox1.Align := alClient;

  AddTag('Delphi');
  AddTag('TPaintBox');
  AddTag('UI');
  AddTag('Exemple');
  AddTag('Test');

  PaintBox1.Invalidate;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTags.Free;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    AddTag(Trim(Edit1.Text));
    Edit1.Text := '';
  end;
end;

function TForm1.TagExists(const AText: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if AText = '' then
    Exit;
  for i := 0 to FTags.Count - 1 do
    if SameText(FTags[i].Text, AText) then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TForm1.AddTag(const AText: string);
var
  NewTag: TTag;
begin
  if AText = '' then
    Exit;
  if TagExists(AText) then
    Exit;

  NewTag.Text := AText;
  NewTag.Rect := Rect(0, 0, 0, 0);
  NewTag.CloseRect := Rect(0, 0, 0, 0);
  NewTag.Color := clSkyBlue;
  FTags.Add(NewTag);
  RecalculateTagRects;
  PaintBox1.Invalidate;
end;

procedure TForm1.RecalculateTagRects;
var
  i, X, Y, paddingX, paddingY, marginX, marginY: Integer;
  txtW, txtH: Integer;
  r: TRect;
  tmpTag: TTag;
  closeSize, closePadding: Integer;
begin
  paddingX := 8;
  paddingY := 4; // Espace vertical interne du tag
  marginX := 6; // Espace entre tags horizontal
  marginY := 6; // Espace entre lignes vertical
  X := 4;
  Y := 4;

  PaintBox1.Canvas.Font := Self.Font;
  txtH := PaintBox1.Canvas.TextHeight('Hg');

  closeSize := Max(12, txtH - 2);
  closePadding := 6;

  for i := 0 to FTags.Count - 1 do
  begin
    txtW := PaintBox1.Canvas.TextWidth(FTags[i].Text);
    r.Left := X;
    r.Top := Y;
    r.Right := X + txtW + 2 * paddingX + closeSize + closePadding;
    r.Bottom := Y + txtH + 2 * paddingY;

    if r.Right > PaintBox1.Width - 4 then
    begin
      X := 4;
      Y := Y + txtH + 2 * paddingY + marginY;
      r.Left := X;
      r.Top := Y;
      r.Right := X + txtW + 2 * paddingX + closeSize + closePadding;
      r.Bottom := Y + txtH + 2 * paddingY;
    end;

    tmpTag := FTags[i];
    tmpTag.Rect := r;

    tmpTag.CloseRect.Left := r.Right - closePadding - closeSize;
    tmpTag.CloseRect.Top := r.Top + ((r.Bottom - r.Top) - closeSize) div 2;
    tmpTag.CloseRect.Right := tmpTag.CloseRect.Left + closeSize;
    tmpTag.CloseRect.Bottom := tmpTag.CloseRect.Top + closeSize;

    FTags[i] := tmpTag;

    Inc(X, (r.Right - r.Left) + marginX);
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  i: Integer;
  r, cr: TRect;
  radius: Integer;
  txtX, txtY: Integer;
  offset: Integer;
begin
  with PaintBox1.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(PaintBox1.ClientRect);
    Pen.Style := psClear;
    Font := Self.Font;
  end;

  for i := 0 to FTags.Count - 1 do
  begin
    r := FTags[i].Rect;
    PaintBox1.Canvas.Brush.Color := FTags[i].Color;
    PaintBox1.Canvas.Pen.Color := clGray;
    radius := 6;
    PaintBox1.Canvas.RoundRect(r.Left, r.Top, r.Right, r.Bottom,
      radius, radius);

    PaintBox1.Canvas.Font.Color := clBlack;
    txtX := r.Left + 8;
    txtY := r.Top + (r.Height - PaintBox1.Canvas.TextHeight
      (FTags[i].Text)) div 2;
    PaintBox1.Canvas.TextOut(txtX, txtY, FTags[i].Text);

    cr := FTags[i].CloseRect;

    PaintBox1.Canvas.Pen.Style := psSolid;
    PaintBox1.Canvas.Pen.Width := 2;
    PaintBox1.Canvas.Pen.Color := clRed;

    offset := Max(2, (cr.Right - cr.Left) div 6);

    PaintBox1.Canvas.MoveTo(cr.Left + offset, cr.Top + offset);
    PaintBox1.Canvas.LineTo(cr.Right - offset, cr.Bottom - offset);

    PaintBox1.Canvas.MoveTo(cr.Left + offset, cr.Bottom - offset);
    PaintBox1.Canvas.LineTo(cr.Right - offset, cr.Top + offset);
    PaintBox1.Canvas.Pen.Width := 1;
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  pt: TPoint;
begin
  if Button <> mbLeft then
    Exit;
  pt := Point(X, Y);

  for i := 0 to FTags.Count - 1 do
  begin
    if PtInRect(FTags[i].CloseRect, pt) then
    begin
      FTags.Delete(i);
      RecalculateTagRects;
      PaintBox1.Invalidate;
      Exit;
    end;
  end;

  for i := 0 to FTags.Count - 1 do
  begin
    if PtInRect(FTags[i].Rect, pt) then
    begin
      FTags.Delete(i);
      RecalculateTagRects;
      PaintBox1.Invalidate;
      Exit;
    end;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  RecalculateTagRects;
  PaintBox1.Invalidate;
end;

end.
