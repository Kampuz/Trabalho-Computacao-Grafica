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

    function ProjectCenter(p : Point) : TPoint;
    function Multiply(M : TMatrix4; P : TPoint;


implementation

{ TForm2 }

procedure TForm2.ButtonDrawHouseClick(Sender: TObject);
begin

end;

procedure TForm2.ButtonExecuteClick(Sender: TObject);
begin

end;

function TForm2.ProjectCenter(p: Point): TPoint;
begin

end;

function TForm2.Multiply(M: TMatrix4; P: Point);
begin

end;

;

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
    p1 := ProjectCenter(house_points[house_lines[i,0]]);
    p2 := ProjectCenter(house_points[house_lines[i,1]]);
    Image1.Canvas.MoveTo(p1.X, p1.Y);
    Image1.Canvas.LineTo(p2.X, p2.Y);
  end;
end;


function TForm2.ProjectCenter(p : Point) : TPoint;
begin
  Result.X := Round(Image1.Width div 2 + (p[0] - p[2]*0.5));
  Result.Y := Round(Image1.Height div 2 - (p[1] - p[2]*0.5));
end;

function TForm2.Multiply(M : TMatrix4; P : Point);
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
      Resul := res;
end.

