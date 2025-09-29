unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Windows;

type
    Point = array[0..3] of Double;
    TMatrix4 = array[0..3,0..3] of Double;
  { TForm2 }

  TForm2 = class(TForm)
    ButtonDrawHouse: TButton;
    ButtonExecute: TButton;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    EditEixo: TEdit;
    EditX: TEdit;
    EditGraus: TEdit;
    EditX1: TEdit;
    Edit1: TEdit;
    EditY1: TEdit;
    EditZ: TEdit;
    EditY: TEdit;
    EditZ1: TEdit;
    EditS: TEdit;
    Image1: TImage;
    LabelEixo: TLabel;
    LabelGraus: TLabel;
    LabelEscala: TLabel;
    LabelX: TLabel;
    LabelTranslacao: TLabel;
    LabelRotacao: TLabel;
    LabelShearing: TLabel;
    LabelX1: TLabel;
    LabelY: TLabel;
    LabelY1: TLabel;
    LabelZ: TLabel;
    LabelZ1: TLabel;
    LabelZ2: TLabel;
    RadioButtonRotacaoOrigem: TRadioButton;
    RadioButtonRotacaoCentro: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure ButtonDrawHouseClick(Sender: TObject);
    procedure ButtonExecuteClick(Sender: TObject);

    function To2d(p : Point) : TPoint;
    function Multiply(M : TMatrix4; P : Point) : Point;
    function MultiplyMatrix(m1, m2 : TMatrix4) : TMatrix4;
    function To3d(p : Point) : TPoint;

  private

  public

  end;

var
  Form2: TForm2;

  const house_points : array[0..9] of Point = (
        (0, 0, 0, 1),              // 0
        (100, 0, 0, 1),            // 1
        (0, 100, 0, 1),            // 2
        (100, 100, 0, 1),          // 3
        (50, 150, 0, 1),           // 4
        (0, 0, 100, 1),            // 5
        (100, 0, 100, 1),          // 6
        (0, 100, 100, 1),          // 7
        (100, 100, 100, 1),        // 8
        (50, 150, 100, 1)         // 9
  );
  const house_lines : array[0..14, 0..1] of Integer = (
        (0, 1), (0, 5), (1, 6), (5, 6), // bottom
        (0, 2), (1, 3), (2, 4), (3, 4), // front
        (5, 7), (6, 8), (7, 9), (8, 9), // back
        (2, 7), (4, 9), (3, 8)          // top
  );

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.ButtonDrawHouseClick(Sender: TObject);
var
  i : Integer;
  p1, p2 : TPoint;
begin
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Image1.ClientRect);

  Image1.Canvas.Pen.Color := clBlack;

  for i := 0 to High(house_lines) do
  begin
    p1 := To3D(house_points[house_lines[i,0]]);
    p2 := To3D(house_points[house_lines[i,1]]);
    Image1.Canvas.MoveTo(p1.X, p1.Y);
    Image1.Canvas.LineTo(p2.X, p2.Y);
  end;
end;

procedure TForm2.ButtonExecuteClick(Sender: TObject);
var
  i, j : Integer;
  tx, ty, tz : Double;
  sx, sy, sz : Double;
  angle, rad : Double;
  axis : String;
  M, R, T, S : TMatrix4;
  P : Point;
  new_points : array[0..9] of Point;
begin
     // Initializing Matrixes
     for i := 0 to 3 do
         for j := 0 to 3 do
             if (i = j) then
             begin
                M[i,j] := 1;
                R[i,j] := 1;
                T[i,j] := 1;
                S[i,j] := 1;
             end
             else
             begin
               M[i,j] := 0;
               R[i,j] := 0;
               T[i,j] := 0;
               S[i,j] := 0;
             end;

     // Getting inputs

     tx := StrToFloat(EditX.Text);
     ty := StrToFloat(EditY.Text);
     tz := StrToFloat(EditZ.Text);

     sx := StrToFloat(EditS.Text);
     sy := sx;
     sz := sx;

     axis := UpperCase(Trim(EditEixo.Text));
     angle := StrToFloat(EditGraus.Text);
     rad := angle * PI / 180;

     // Translacao
     T[0,3] := tx;
     T[1,3] := ty;
     T[2,3] := tz;

     // Escala
     S[0,0] := sx;
     s[1,1] := sy;
     s[2,2] := sz;

     // Rotacao
     if (axis = 'X') then
     begin
          R[1,1] := Cos(rad);
          R[1,2] := Sin(rad);
          R[2,1] := -Sin(rad);
          R[2,2] := Cos(rad);
     end
     else if (axis = 'Y') then
     begin
          R[0,0] := Cos(rad);
          R[0,2] := -Sin(rad);
          R[2,0] := Sin(rad);
          R[2,2] := Cos(rad);
     end
     else if (axis = 'Z') then
     begin
          R[0,0] := Cos(rad);
          R[0,1] := Sin(rad);
          R[1,0] := -Sin(rad);
          R[1,1] := Cos(rad);
     end;

     for i := 0 to 9 do
     begin
       P := house_points[i];
       P := Multiply(S,P);
       P := Multiply(R,P);
       P := Multiply(T,P);
       new_points[i] := P;
     end;

     Image1.Canvas.Brush.Color := clWhite;
     Image1.Canvas.FillRect(Image1.ClientRect);
     Image1.Canvas.Brush.Color := clBlack;

     for i := 0 to High(house_lines) do
     begin
          Image1.Canvas.MoveTo(
                               To3D(new_points[house_lines[i,0]]).X,
                               To3D(new_points[house_lines[i,0]]).Y
                               );
          Image1.Canvas.LineTo(
                               To3D(new_points[house_lines[i,1]]).X,
                               To3D(new_points[house_lines[i,1]]).Y
                               );
     end;

end;


function TForm2.To2d(p : Point) : TPoint;
begin
  Result.X := Round(Image1.Width div 2 + p[0]);
  Result.Y := Round(Image1.Height div 2 - p[1]);
end;

function TForm2.To3d(p : Point) : TPoint;
begin
     Result.X := Round(Image1.Width div 2 + (p[0] - p[2]));
     Result.Y := Round(Image1.Width div 2 - (p[1] + p[2]));
end;

function TForm2.Multiply(M : TMatrix4; P : Point) : Point;
var
  i, j : Integer;
  res : Point;
begin
  for i := 0 to 3 do
  begin
       res[i] := 0;
       for j := 0 to 3 do
           res[i] := res[i] + M[i,j] * P[j];

  end;
      Result := res;
end;

function TForm2.MultiplyMatrix(m1, m2 : TMatrix4) : TMatrix4;
var
  i, j, k : Integer;
  mResult : TMatrix4;
begin
  for i := 0 to 3 do
      for j := 0 to 3 do
      begin
             mResult[i,j] := 0;
             for k := 0 to 3 do
                 mResult[i,j] := mResult[i,j] + m1[i,k] * m2[k,j]
      end;
  Result := mResult;
end;

end.

