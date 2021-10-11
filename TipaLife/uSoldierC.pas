unit uSoldierC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, ComCtrls, uSoldier, uBoard,
  uEditProgram;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Timer1: TTimer;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Edit3: TEdit;
    UpDown2: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    UpDown3: TUpDown;
    Label3: TLabel;
    Edit4: TEdit;
    UpDown4: TUpDown;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);

  private
    bor:tBoard;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses comobj;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 i,j:integer;
 Sol:tSoldier;
 XX,YY,CNT:integer;
begin
 if checkbox1.Checked then randomize;

 StringGrid1.RowCount:=StrToInt(Edit1.Text);
 StringGrid1.ColCount:=StringGrid1.RowCount;
 form1.ClientWidth:=panel1.Width+(StringGrid1.ColCount+1)*StringGrid1.ColWidths[0];
 form1.ClientHeight :=(StringGrid1.ColCount+1)*StringGrid1.ColWidths[0];


 for i:=0 to StringGrid1.RowCount-1 do
  for j:=0 to StringGrid1.ColCount-1 do StringGrid1.Cells[i,j]:='';

 XX:=StringGrid1.RowCount;
 YY:=XX;

 CNT:=StrToInt(Edit3.Text);

 if bor<>nil then FreeAndNil(bor);
 bor:= tBoard.Create(StringGrid1);
 for i:=0 to CNT-1 do
 begin
   for j:=0 to StrToInt(Edit2.Text)-1 do
   begin
     sol:=nil;
     repeat 
      sol:=tSoldier.Create(random(XX),Random(YY),Chr(ord('a')+j),XX, nil);
      if sol=bor.GetSolByXY(Sol.PosX,Sol.PosY) then freeandnil(sol);
     until sol<>nil;
     bor.AddSoldier(sol);
   end;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  bor.Step;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  bor.Step;
  timer1.Enabled:=true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Timer1.Interval:=StrToInt(edit4.Text);
  if bor=nil then Button1.Click;
  if Button4.Caption='Timer ON' then
  begin
     Button4.Caption:='Timer OFF';
     timer1.Enabled:=true;
  end
  else begin
     Button4.Caption:='Timer ON';
     timer1.Enabled:=false;
  end;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Sol:tSoldier;
  Action:tMyAction;
  i:integer;
begin
  if bor=nil then exit;
  Sol:=bor.GetSolByXY(ACol,ARow);
  if Sol=nil then exit;
  addr(Action):=nil;
  InitProgram(Sol.Who, Action);  //тут форма

  if addr(Action)<>nil then
  begin
    for i:=0 to length(bor.Soldiers)-1 do
    begin
      if bor.Soldiers[i]<>nil then
       if bor.Soldiers[i].Who= Sol.Who then
         begin
           bor.Soldiers[i].MyAction:=addr(Action);
         end;
    end;
  end;
end;    

end.
