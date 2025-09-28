unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ExtDlgs,
  Menus, StdCtrls, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonDesenhar: TButton;
    CheckBoxPincel: TCheckBox;
    CheckBoxLinha: TCheckBox;
    ColorButtonNovaCor: TColorButton;
    ColorButtonCorAtual: TColorButton;
    EditX: TEdit;
    EditX1: TEdit;
    EditX2: TEdit;
    EditY: TEdit;
    EditY1: TEdit;
    EditY2: TEdit;
    Image1: TImage;
    LabelX: TLabel;
    LabelX1: TLabel;
    LabelX2: TLabel;
    LabelY: TLabel;
    LabelY1: TLabel;
    LabelY2: TLabel;
    MainMenu1: TMainMenu;
    MenuItemSalvar: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemArquivo: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioGroup1: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonDesenharClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);


    procedure CalcularRetaUsandoPixels(image: TImage; x1, y1, x2, y2: Integer;
      cor: TColor);
    procedure FormaParametrica(image: TImage; x1, y1, x2, y2 : Integer; cor:
      TColor);
    procedure Bresenham(image : TImage; x1, y1, x2, y2 : Integer; cor : TColor);

    function RetaMaisHorizontal(dx, dy : Integer): Boolean;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}



{ TForm1 }

procedure TForm1.ButtonDesenharClick(Sender: TObject);
var
  x1, y1, x2, y2 : Integer;
  cor : TColor;
begin
  if ((TryStrToInt(EditX1.Text, x1)) and (TryStrToInt(EditY1.Text, y1)) and
  (TryStrToInt(EditX2.Text, x2)) and (TryStrToInt(EditY2.Text, y2))) then
  begin
       cor := ColorButtonNovaCor.ButtonColor;
       if (RadioButton1.Checked) then
          CalcularRetaUsandoPixels(Image1, x1, y1, x2, y2, cor)
       else if (RadioButton2.Checked) then
            FormaParametrica(Image1, x1, y1, x2, y2, cor)
       else if (RadioButton3.Checked) then
            Bresenham(Image1, x1, y1, x2, y2, cor);

       EditX1.Text := '';
       EditY1.Text := '';
       EditX2.Text := '';
       EditY2.Text := '';
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (not CheckBoxLinha.Checked) then Exit;

  if ((EditX1.Text = '') and (EditY1.Text = '')) then
     begin
       EditX1.Text := IntToStr(X);
       EditY1.Text := IntToStr(Y);
     end
     else
     begin
       EditX2.Text := IntToStr(X);
       EditY2.Text := IntToStr(Y);
     end;
end;


procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  EditX.Text := IntToStr(X);
  EditY.Text := IntToStr(Y);
  ColorButtonCorAtual.ButtonColor := Image1.Canvas.Pixels[X,Y];

  if ((CheckBoxPincel.Checked) and (ssLeft in Shift)) then
     Image1.Canvas.Pixels[X,Y] := ColorButtonNovaCor.ButtonColor;
end;

procedure TForm1.MenuItemAbrirClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
     Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TForm1.MenuItemSalvarClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
     Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
end;

procedure TForm1.calcularRetaUsandoPixels(image: TImage; x1, y1, x2, y2: Integer; cor: TColor);
var
  deltaX, deltaY, x, y: Integer;
  m : Double;
begin
  if (x1 = x2) then
  begin
       for y := Min(y1, y2) to Max(y1,y2) do
           image.Canvas.Pixels[x1,y] := cor;
  end
  else if (y1 = y2) then
  begin
       for x := Min(x1, x2) to Max(x1, x2) do
           image.Canvas.Pixels[x, y1] := cor
  end
  else
  begin
       deltaX := (x2-x1);
       deltaY := (y2-y1);
       m := deltaY/deltaX;
       if (RetaMaisHorizontal(deltaX, deltaY)) then
       begin
            for x := Min(x1,x2) to Max(x1,x2) do
            begin
                 y := Round(m*(x-x1) + y1);
                 image.Canvas.Pixels[x,y] := cor;
            end;
       end
       else
       begin
            for y := Min(y1,y2) to Max(y1,y2) do
            begin
                 x := Round((y-y1)/m + x1);
                 image.Canvas.Pixels[x,y] := cor;
            end;
       end;
  end;
end;

procedure TForm1.FormaParametrica(image : TImage; x1, y1, x2, y2 : Integer; cor
  : TColor);
var
  x, y, vx, vy : Integer;
  t : Double;

begin
  vx := x2 - x1;
  vy := y2 - y1;
  t := 0;
  while (t <= 1) do
  begin
       x := Round(x1 + vx*t);
       y := Round(y1 + vy*t);
       image.Canvas.Pixels[x, y] := cor;
       t := t + 0.01;
  end;
end;

procedure TForm1.Bresenham(image : TImage; x1, y1, x2, y2 : Integer; cor :
  TColor);
var
  dx, dy, sx, sy, err, e2 : Integer;
  x, y : Integer;
begin
  x := x1;
  y := y1;

  dx := Abs(x2 - x1);
  dy := Abs(y2 - y1);

  if (x1 < x2) then sx := 1 else sx := -1;
  if (y1 < y2) then sy := 1 else sy := -1;

  err := dx - dy;

  while True do
  begin
       if (x >= 0) and (x < image.Width) and (y >= 0) and (y < image.Height) then
          image.Canvas.Pixels[x, y] := cor;
       if (x = x2) and (y = y2) then Break;

       e2 := 2 * err;

       if e2 > -dy then
       begin
         err := err - dy;
         x := x + sx;
       end;

       if e2 < dx then
       begin
         err := err + dx;
         y := y + sy;
       end;
  end;
end;

function TForm1.RetaMaisHorizontal(dx, dy : Integer): Boolean;
begin
  Result := Abs(dx) > Abs(dy);
end;

end.

