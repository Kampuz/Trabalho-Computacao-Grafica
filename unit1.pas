unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ExtDlgs,
  Menus, StdCtrls, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorButtonNovaCor: TColorButton;
    ColorButtonCorAtual: TColorButton;
    EditX: TEdit;
    EditY: TEdit;
    Image1: TImage;
    LabelX: TLabel;
    LabelY: TLabel;
    MainMenu1: TMainMenu;
    MenuItemSalvar: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemArquivo: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioButtonCircunferenciaBresenham: TRadioButton;
    RadioButtonRetaGeral: TRadioButton;
    RadioButtonRetaParametrica: TRadioButton;
    RadioButtonRetaBresenham: TRadioButton;
    RadioButtonCircunferenciaGeral: TRadioButton;
    RadioButtonCircunferenciaParametrica: TRadioButton;
    RadioButtonCircunferenciaRotacao: TRadioButton;
    RadioButtonPincel: TRadioButton;
    RadioButtonReta: TRadioButton;
    RadioButtonCircunferencia: TRadioButton;
    RadioGroupCircunferencia: TRadioGroup;
    RadioGroupReta: TRadioGroup;
    RadioGroupTipo: TRadioGroup;
    SavePictureDialog1: TSavePictureDialog;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);
    procedure RadioButtonCircunferenciaChange(Sender: TObject);
    procedure RadioButtonRetaChange(Sender: TObject);


    procedure RetaGeral(image: TImage; x1, y1, x2, y2: Integer;
              cor: TColor);
    procedure RetaParametrica(image: TImage; x1, y1, x2, y2 : Integer;
              cor: TColor);
    procedure RetaBresenham(image : TImage; x1, y1, x2, y2 : Integer; cor : TColor);
    procedure CircunferenciaGeral(image : TImage; x1, y1, x2, y2 : Integer;
              cor : TColor);
    procedure CircunferenciaParametrica(image : TImage;
              x1, y1, x2, y2 : Integer; cor : TColor);
    procedure CircunferenciaRotacao(image : TImage; x1, y1, x2, y2 : Integer;
              cor : TColor);
    procedure CircunferenciaBresenham(image : TImage; x1, y1, x2, y2 : Integer;
              cor : TColor);

    function RetaMaisHorizontal(dx, dy : Integer): Boolean;
    procedure Plot8Point(x0, y0, x, y : Integer; cor : TColor);
    procedure PlotOnePoint(x, y : Integer; cor : TColor);
  private

  public

  end;

var
  Form1: TForm1;
  isDragging : Boolean;
  lastX, lastY : Integer;

implementation

{$R *.lfm}



{ TForm1 }

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
       isDragging := True;
       lastX := X;
       lastY := Y;
  end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (isDragging) then
       if (RadioButtonPincel.Checked) then
            Image1.Canvas.Pixels[X, Y] := ColorButtonNovaCor.ButtonColor;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   newColor : TColor;
begin
  if (Button = mbLeft) then
     isDragging := False;
     newColor := ColorButtonNovaCor.ButtonColor;

     if (RadioButtonReta.Checked) then
     begin
          if (RadioButtonRetaGeral.Checked) then
                  RetaGeral(Image1, lastX, lastY, X, Y, newColor)
          else if (RadioButtonRetaParametrica.Checked) then
                  RetaParametrica(Image1, lastX, lastY, X, Y, newColor)
          else if (RadioButtonRetaBresenham.Checked) then
                  RetaBresenham(Image1, lastX, lastY, X, Y, newColor);
     end
     else if (RadioButtonCircunferencia.Checked) then
     begin
          if (RadioButtonCircunferenciaGeral.Checked) then
             CircunferenciaGeral(Image1, lastX, lastY, X, Y, newColor)
          else if (RadioButtonCircunferenciaParametrica.Checked) then
               CircunferenciaParametrica(Image1, lastX, lastY, X, Y, newColor)
          else if (RadioButtonCircunferenciaRotacao.Checked) then
               CircunferenciaRotacao(Image1, lastX, lastY, X, Y, newColor)
          else if (RadioButtonCircunferenciaBresenham.Checked) then
               CircunferenciaBresenham(image1, lastX, lastY, X, Y, newColor);
     end;
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

procedure TForm1.RadioButtonCircunferenciaChange(Sender: TObject);
begin
     RadioGroupCircunferencia.Visible := RadioButtonCircunferencia.Checked;
end;

procedure TForm1.RadioButtonRetaChange(Sender: TObject);
begin
     RadioGroupReta.Visible := RadioButtonReta.Checked;
end;

procedure TForm1.RetaGeral(image: TImage; x1, y1, x2, y2: Integer; cor: TColor);
var
  deltaX, deltaY, x, y: Integer;
  m : Double;
begin
  if (x1 = x2) then
  begin
       for y := Min(y1, y2) to Max(y1,y2) do
           PlotOnePoint(x1, y, cor);
  end
  else if (y1 = y2) then
  begin
       for x := Min(x1, x2) to Max(x1, x2) do
           PlotOnePoint(x, y1, cor);
  end
  else
  begin
       deltaX := x2-x1;
       deltaY := y2-y1;
       m := deltaY/deltaX;
       if (Abs(deltaX) < Abs(deltaY)) then
       begin
            for x := Min(x1,x2) to Max(x1,x2) do
            begin
                 y := Round(m*(x-x1) + y1);
                 PlotOnePoint(x, y, cor);
            end;
       end
       else
       begin
            for y := Min(y1,y2) to Max(y1,y2) do
            begin
                 x := Round((y-y1)/m + x1);
                 PlotOnePoint(x, y, cor);
            end;
       end;
  end;
end;

procedure TForm1.RetaParametrica(x1, y1, x2, y2 : Integer; cor : TColor);
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
       PlotOnePoint(x, y, cor);
       t := t + 0.01;
  end;
end;

procedure TForm1.RetaBresenham(x1, y1, x2, y2 : Integer; cor : TColor);
var
  dx, dy, sx, sy, error, e2 : Integer;
begin
  dx := Abs(x2 - x1);
  dy := -Abs(y2 - y1);

  if (x1 < x2) then
     sx := 1
  else
      sx := -1;

  if (y1 < y2) then
     sy := 1
  else
      sy := -1;
  error := dx + dy;

  while (true) do
  begin
       PlotOnePoint(x1,y1,cor);
       e2 := 2 * error;
       if (e2 >= dy) then
       begin
            if (x1 = x2) then Break;
            error := error + dy;
            x1 := x1 + sx;
       end;
       if (e2 <= dx) then
       begin
            if (y1 = y2) then Break;
            error := error + dx;
            y1 := y1 + sy;
       end;
  end;
end;

procedure TForm1.CircunferenciaGeral(image : TImage; x1, y1, x2, y2 : Integer;
  cor : TColor);
var
   x, y, dx, dy, radious, r2 : Integer;
begin
  dx := Abs(x2 - x1);
  dy := Abs(y2 - y1);
  radious := Round(Sqrt(dx*dx + dy*dy));
  r2 := radious*radious;
  for x := -radious to radious do
  begin
       y := Round(Sqrt(r2 - x*x));
       PlotOnePoint(x1+x, y1+y, cor);
       PlotOnePoint(x1+x, y1-y, cor);
  end;
end;

procedure TForm1.CircunferenciaParametrica(x1, y1, x2, y2 : Integer;
  cor : TColor);
var
   x, y, dx, dy, radious : Integer;
   a : Double;
begin
  dx := Abs(x2 - x1);
  dy := Abs(y2 - y1);
  radious := Round(Sqrt(dx*dx + dy*dy));
  a := 0;

  while a <= 6.28 do
  begin
       x := Round(radious * Cos(a));
       y := Round(radious * Sin(a));
       PlotOnePoint(x1+x, y1+y, cor);
       a := a + 0.01;
  end;
end;

procedure TForm1.CircunferenciaRotacao(x1, y1, x2, y2 : Integer; cor : TColor);
var
   i, dx, dy, radious : Integer;
   angle, cos1, sin1, x, y, xn : Double;
begin
  dx := Abs(x2 - x1);
  dy := Abs(y2 - y1);
  radious := Round(Sqrt(dx*dx + dy*dy));

  x := radious;
  y := 0;
  angle := PI/180;
  cos1 := Cos(angle);
  sin1 := sin(angle);

  for i := 1 to 360 do
  begin
       xn := x * cos1 - y * sin1;
       y := x * sin1 + y * cos1;
       x := xn;
       PlotOnePoint(x1+Round(x), y1+Round(y), cor);
  end;
end;

procedure TForm1.CircunferenciaBresenham(x1, y1, x2, y2 : Integer;
  cor : TColor);
var
   x,  y, dx, dy, radious, dE, dSE : Integer;
   h : Double;
begin
  dx := Abs(x2 - x1);
  dy := Abs(y2 - y1);
  radious := Round(Sqrt(dx*dx + dy*dy));

  x := 0;
  y := radious;
  h := 1 - radious;
  dE := 3;
  dSE := 5 - 2*radious;

  Plot8Point(x1,y1,x,y, cor);

  while (x < y) do
  begin
       if (h < 0) then
       begin
            h := h + dE;
            dE := dE + 2;
            dSE := dSE + 2;
       end
       else
       begin
            h := h + dSE;
            dE := dE + 2;
            dSE := dSE + 4;
            y := y - 1;
       end;

       x := x + 1;
       Plot8Point(x1,y1,x,y, cor);
  end;
end;

function TForm1.RetaMaisHorizontal(dx, dy : Integer): Boolean;
begin
  Result := Abs(dx) > Abs(dy);
end;

procedure TForm1.PlotOnePoint(x, y : Integer; cor : TColor);
begin
  Image1.Canvas.Pixels[x, y] := cor;
end;

procedure TForm1.Plot8Point(x0, y0, x, y : Integer; cor : TColor);
begin
  Image1.Canvas.Pixels[x0+x, y0+y] := cor;
  Image1.Canvas.Pixels[x0-x, y0+y] := cor;
  Image1.Canvas.Pixels[x0+x, y0-y] := cor;
  Image1.Canvas.Pixels[x0-x, y0-y] := cor;
  Image1.Canvas.Pixels[x0+y, y0+x] := cor;
  Image1.Canvas.Pixels[x0-y, y0+x] := cor;
  Image1.Canvas.Pixels[x0+y, y0-x] := cor;
  Image1.Canvas.Pixels[x0-y, y0-x] := cor;
end;

end.

