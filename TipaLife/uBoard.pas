unit uBoard;

interface

uses Grids, SysUtils, Dialogs,Types, uSoldier;

type
 tBoard=class
  private
    procedure ArhiveSoldiers;
  public
    Soldiers:array of tSoldier;
    Pole:tStringGrid;
    Constructor Create(SG:tStringGrid); virtual;
    Destructor Destroy; override;
    procedure AddSoldier(var ASoldier:tSoldier);
    procedure DelSoldier(ASoldier:tSoldier); overload;
    procedure DelSoldier(AX,AY:integer); overload;
    function GetSolByXY(AX,AY:integer):tSoldier;
    Function NewSoldier(ASoldier:tSoldier):tSoldier;
    function IsBadCoord(X,Y:integer):boolean;
    procedure SetAroundForSoldier(var ASoldier:tSoldier);
    Procedure Step;
    Procedure Show;
    Procedure OnDraw(Sender: TObject; ACol, ARow: Integer;  Rect: TRect; State: TGridDrawState);
 end;

implementation

{ tBoard }

procedure tBoard.AddSoldier(var ASoldier: tSoldier);
var
  LenSols:integer;
begin
  if ASoldier=nil then exit;
  if GetSolByXY(ASoldier.PosX,ASoldier.PosY)<>nil then
  begin
    freeandnil(ASoldier);
    exit;
  end;
  LenSols:=length(Soldiers);
  SetLength(Soldiers,LenSols+1);
  Soldiers[LenSols]:=ASoldier;
//  pole.Cells[ASoldier.PosX,ASoldier.PosY]:=ASoldier.Who;
end;

procedure tBoard.ArhiveSoldiers;  //выкинуть из массива пустых, сжать массив
var
  Soldiers2:array of tSoldier;
  i,ls:integer;
begin
  ls:=0;
  for i:=0 to length(Soldiers)-1 do
    if Soldiers[i]<>nil then
    begin
      inc(ls);
      setlength(soldiers2,ls);
      soldiers2[ls-1]:=soldiers[i];
    end;
  setlength(Soldiers,ls);
  for i:=0 to ls-1 do soldiers[i]:=soldiers2[i];
  setlength(soldiers2,0);
end;

constructor tBoard.Create(SG: tStringGrid);
begin
  Pole:=SG;
  Pole.OnDrawCell:=OnDraw;
end;

destructor tBoard.Destroy;
var
  i:integer;
begin
  for i:=0 to length(Soldiers)-1 do
    if Soldiers[i]<>nil then FreeAndNil(Soldiers[i]);
  SetLength(Soldiers,0);
  inherited;
end;

procedure tBoard.DelSoldier(ASoldier: tSoldier);
var
  i:integer;
begin
  if ASoldier<>nil then
    for i:=0 to Length(Soldiers)-1 do
    begin
      if ASoldier=Soldiers[i] then FreeAndNil(Soldiers[i]);
    end;
end;

procedure tBoard.DelSoldier(AX, AY: integer);
begin
  DelSoldier(GetSolByXY(AX,AY));
end;

function tBoard.GetSolByXY(AX, AY: integer): tSoldier;
var
  i:integer;
begin
  result:=nil;
  for i:=0 to Length(Soldiers)-1 do
  begin
    if Soldiers[i]=nil then continue;
    if (Soldiers[i].PosX=AX) and (Soldiers[i].PosY=AY) then
    begin
      result:=Soldiers[i];
      exit;
    end;
  end;
end;

procedure tBoard.Step;
label exit;
var
  i,j:integer;
  act,dx,dy,hlp:integer;
  ASol:tSoldier;
  RNDS:integer;
//  Log:tLog;
 procedure RndDxDy(var x,y:integer);
 var
   sign1,sign2:double;
 begin
       sign1:=random; // случайно на клетку идет в любую сторону
       dx:=random(2);
       if sign1>0.5 then dx:=dx*(-1);
       sign2:=random;
       dy:=random(2);
       if sign2>0.5 then dy:=dy*(-1);// END случайно на клетку идет в любую сторону
 end;
begin
//  log:=tLog.Create;

  ArhiveSoldiers;
  for i:=0 to length(Soldiers)-1 do //просто так, смысла особого нет, можно до любого числа
  begin
   RNDS:=random(length(Soldiers));
   act:=0; hlp:=0;
   if Soldiers[RNDS]<>nil then
   begin
     SetAroundForSoldier(Soldiers[RNDS]);
     if addr(Soldiers[RNDS].MyAction)<>Nil
      then
      Soldiers[RNDS].MyAction(
        round(Soldiers[RNDS].Life),
        Soldiers[RNDS].N, Soldiers[RNDS].O, Soldiers[RNDS].S, Soldiers[RNDS].W,
        Soldiers[RNDS].NO, Soldiers[RNDS].SO, Soldiers[RNDS].SW, Soldiers[RNDS].NW,
        Soldiers[RNDS].NL, Soldiers[RNDS].OL, Soldiers[RNDS].SL, Soldiers[RNDS].WL,
        Soldiers[RNDS].NOL, Soldiers[RNDS].SOL, Soldiers[RNDS].SWL, Soldiers[RNDS].NWL,
        Soldiers[RNDS].MVR,act,dx,dy,hlp)
     else
       RndDxDy(dx,dy);

     if IsBadCoord(Soldiers[RNDS].PosX+dx, Soldiers[RNDS].PosY+dy) then continue;
     ASol:=GetSolByXY(Soldiers[RNDS].PosX+dx,Soldiers[RNDS].PosY+dy);
     if ASol=Soldiers[RNDS] then continue; //сам

     case act of
       0: if ASol=nil
           then Soldiers[RNDS].Move(dx,dy)  //никого, идем туда
           else //кто-то
               if ASol.Who<>Soldiers[RNDS].Who then //враг
               begin
                 ASol.Life:=ASol.Life-Soldiers[RNDS].Life/2;
                 Soldiers[RNDS].Life:=Soldiers[RNDS].Life-ASol.Life/2;
                 if Soldiers[RNDS].Life<=0 then freeandnil(Soldiers[RNDS]);
                 if ASol.Life<=0 then
                   for j:=0 to length(soldiers)-1 do
                      if ASol=Soldiers[j] then
                       begin
                         freeandnil(Soldiers[j]);
                         ASol:=nil;
                       end;
               end
               else begin //свой
                   ASol:=NewSoldier(Soldiers[RNDS]);
                   if ASol<>nil then ASol.MyAction:=Soldiers[RNDS].MyAction;
                   AddSoldier(ASol);
               end;
       1: begin
             Soldiers[RNDS].Life:=Soldiers[RNDS].Life-hlp;
             if (ASol<>nil) then ASol.Life:=ASol.Life+hlp;
          end;
     end //case

   end; //if Soldiers[RNDS]<>nil
  end; //for i:=0 to length(Soldiers)-1 do

  for i:=0 to length(Soldiers)-1 do //всем добавим жизни (можно потом не всегда это делать, чтоб ценнее была)
   if Soldiers[i]<>nil then
   begin
     Soldiers[i].Life:=Soldiers[i].Life+1;
   end;

  Show;
end;

procedure tBoard.Show;
var
  i,j:integer;
begin
  for i:=0 to pole.RowCount-1 do
   for j:=0 to pole.ColCount-1 do pole.Cells[i,j]:='';//inttostr(i)+'-'+inttostr(j);
exit;
  for i:=0 to length(Soldiers)-1 do
   if Soldiers[i]<>nil then
   pole.Cells[Soldiers[i].PosX,Soldiers[i].PosY]:=Soldiers[i].Who+floattostr(Soldiers[i].Life);
end;

function tBoard.NewSoldier(ASoldier: tSoldier): tSoldier;
var
  a:array[0..7] of byte;
  b:integer;
  i:integer;
  fl2:boolean;
  function New(AX,AY:integer):tSoldier;
  begin
    if IsBadCoord(AX,AY) then
    begin
      result:=nil;
      exit;
    end;
    result:=tSoldier.Create(AX,AY,ASoldier.Who,ASoldier.max, ASoldier.MyAction);
    if result<>nil then result.Life:=ASoldier.Life/2;
  end;
begin
  result:=nil;
  if ASoldier=nil then exit;
  for i:=0 to 7 do a[i]:=0;
  repeat
    b:=random(8);
    a[b]:=1;
    case b of
      0: if GetSolByXY(ASoldier.PosX+1,ASoldier.PosY+1)=nil then result:=New(ASoldier.PosX+1,ASoldier.PosY+1);
      1: if GetSolByXY(ASoldier.PosX+1,ASoldier.PosY)=nil then result:=New(ASoldier.PosX+1,ASoldier.PosY);
      2: if GetSolByXY(ASoldier.PosX+1,ASoldier.PosY-1)=nil then result:=New(ASoldier.PosX+1,ASoldier.PosY-1);
      3: if GetSolByXY(ASoldier.PosX,ASoldier.PosY+1)=nil then result:=New(ASoldier.PosX,ASoldier.PosY+1);
      4: if GetSolByXY(ASoldier.PosX,ASoldier.PosY-1)=nil then result:=New(ASoldier.PosX,ASoldier.PosY-1);
      5: if GetSolByXY(ASoldier.PosX-1,ASoldier.PosY+1)=nil then result:=New(ASoldier.PosX-1,ASoldier.PosY+1);
      6: if GetSolByXY(ASoldier.PosX-1,ASoldier.PosY)=nil then result:=New(ASoldier.PosX-1,ASoldier.PosY);
      7: if GetSolByXY(ASoldier.PosX-1,ASoldier.PosY-1)=nil then result:=New(ASoldier.PosX-1,ASoldier.PosY-1);

    end;
    fl2:=true;
    for i:=0 to 7 do fl2:=fl2 and (a[i]=1);
  until (result<>nil) or fl2;
end;

function tBoard.IsBadCoord(X, Y: integer): boolean;
begin
  result:=(x<0) or (x>pole.RowCount-1) or (y<0) or (y>pole.RowCount-1);
end;

procedure tBoard.SetAroundForSoldier(var ASoldier: tSoldier);

 procedure SetVector(X,Y:integer; var V,VL:integer);
 var
   ASol:tSoldier;
 begin
  VL:=0;
  if IsBadCoord(X, Y)
   then V:=-1
   else begin
     ASol:=GetSolByXY(X,Y);
     if ASol=nil
       then V:=1
       else begin
         V:=0;
         if ASoldier.Who=ASol.Who then VL:=round(ASol.Life);
       end;
   end;
 end;

begin
  if ASoldier = nil then exit;
  SetVector(ASoldier.PosX+1, ASoldier.PosY+1, ASoldier.SO, ASoldier.SOL);
  SetVector(ASoldier.PosX+1,ASoldier.PosY, ASoldier.O, ASoldier.OL);
  SetVector(ASoldier.PosX+1,ASoldier.PosY-1,ASoldier.NO, ASoldier.NOL);
  SetVector(ASoldier.PosX,ASoldier.PosY+1,ASoldier.S, ASoldier.SL);
  SetVector(ASoldier.PosX,ASoldier.PosY-1,ASoldier.N, ASoldier.NL);
  SetVector(ASoldier.PosX-1,ASoldier.PosY+1,ASoldier.SW, ASoldier.SWL);
  SetVector(ASoldier.PosX-1,ASoldier.PosY,ASoldier.W, ASoldier.WL);
  SetVector(ASoldier.PosX-1,ASoldier.PosY-1,ASoldier.NW, ASoldier.NWL);
end;

procedure tBoard.OnDraw(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
      If GetSolByXY(ACol,ARow)<>nil then
      begin
        Pole.Canvas.Brush.Color:=GetSolByXY(ACol,ARow).Color;
        pole.Canvas.FillRect(Rect);
      end;
exit;
      If GetSolByXY(ACol,ARow)=nil then
      begin
        Pole.Canvas.Brush.Color:=$FFFFFF;
        pole.Canvas.FrameRect(Rect);
        exit;
      end;
      Pole.Canvas.Brush.Color:=GetSolByXY(ACol,ARow).Color;
      pole.Canvas.FrameRect(Rect);
end;

end.