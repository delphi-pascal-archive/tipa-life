unit uSoldier;
interface
  uses Classes,SysUtils, Graphics;

type
 tMyAction=procedure(MLL,N,O,S,W,NO,SO,SW,NW,NL,OL,SL,WL,NOL,SOL,SWL,NWL:integer; var MVR,ACT,DX,DY,HLP:integer);
 // идея проста. Чем писать интерпретатор, надо взять dcc32.exe и компилить заранее подготовленные шаблоны

 tSoldier=class
  private
    X,Y:integer;
    FF:char;
    Fried:integer;
    Frend:integer;

    LevelLife:integer;
    MyProgram:String;

    procedure SetPosX(const Value: integer);
    procedure SetPosY(const Value: integer);
    procedure SetLevelLife(const Value: double);
    function GetLife: double;
    procedure SetMyProgram(const Value: String);
    function GetColor: tColor;

  public
    max:integer;
    hDll:tHandle;
    MyAction:tMyAction;
    N,O,S,W,NO,SO,SW,NW, NL,OL,SL,WL,NOL,SOL,SWL,NWL:integer;
    MVR:integer;
    Constructor Create(AX,AY:integer; AFF:char; Amax:integer; AMyAction:tMyAction); virtual;
    Destructor Destroy; override;
    procedure Move(dx,dy:integer);
    Function RunProgram:string;

    property PosX:integer read X write SetPosX;
    property PosY:integer read Y write SetPosY;
    Property Who:char read FF;
    property CntFried:integer read Fried;
    property CntFrend:integer read Frend;
    property Life:double read GetLife write SetLevelLife;
    property Programma:String read MyProgram write SetMyProgram;
    property Color:tColor read GetColor;
 end;

implementation

{ tSoldier }

constructor tSoldier.Create(AX, AY: integer; AFF: char; Amax:integer; AMyAction:tMyAction);
begin
  X:=AX;
  Y:=AY;
  FF:=AFF;
  max:=Amax;
  LevelLife:=1;
  MVR:=0;
  MyProgram:='';
  MyAction:=AMyAction;
end;

destructor tSoldier.Destroy;
begin
  inherited;
end;

function tSoldier.GetColor: tColor;
var
  CL:LongWord;
  b:byte;
begin
  b:=ord(FF)-96;
  CL:=55+LevelLife*2;
  case b of
    1: result:= CL*65536;
    2: result:= CL*256;
    3: result:= CL;
    4: result:= CL*65536+CL*256;
    5: result:= CL*256+CL;
    6: result:= CL*65536+CL;
    else result:= 0;
  end;
end;

function tSoldier.GetLife: double;
begin
  result:=LevelLife;
end;

procedure tSoldier.Move(dx, dy: integer);
begin
 PosX:=X+dx;
 PosY:=Y+dy;
end;

function tSoldier.RunProgram: string;
begin
  exit;
end;

procedure tSoldier.SetLevelLife(const Value: double);
begin
  LevelLife:=round(Value);
  if LevelLife>100 then LevelLife:=100;
end;

procedure tSoldier.SetMyProgram(const Value: String);
begin
  MyProgram:=Value;
end;

procedure tSoldier.SetPosX(const Value: integer);
begin
  if Value<0 then exit;
  if Value>max-1 then exit;
  X:=Value;
end;

procedure tSoldier.SetPosY(const Value: integer);
begin
  if Value<0 then exit;
  if Value>max-1 then exit;
  Y:=Value;
end;
{
procedure tSoldier.SetState(AFried, AFrend: integer);
var
  i:integer;
begin
  Frend:=0;
  Fried:=0;
  for i:=0 to 8 do
    if Around[i]<>nil
      then if Around[i].Who<>Who
             then Fried:=Fried+1
             else Frend:=Frend+1;
end;
 }
end.