unit uEditProgram;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uSoldier;

type
  TfrmEditProgram = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private    { Private declarations }
    Who:char;
    Action:tMyAction;
  public
    { Public declarations }
  end;

  procedure InitProgram(ForWho:char;  var AAction:tMyAction);

var
  frmEditProgram: TfrmEditProgram;

implementation

{$R *.dfm}

  procedure InitProgram(ForWho:char;  var AAction:tMyAction);
  begin
   // addr(frmEditProgram.Action):=nil;
    if frmEditProgram<>nil then frmEditProgram:=TfrmEditProgram.Create(application);
    frmEditProgram.Who:=ForWho;
    frmEditProgram.ShowModal;
    if addr(frmEditProgram.Action)<>nil
     then showMessage('OK! Программа установлена!')
     else showMessage('.. Программа НЕ установлена');
    AAction:=frmEditProgram.Action;
  end;

procedure TfrmEditProgram.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmEditProgram.Button1Click(Sender: TObject);
var
  f:textfile;
  s:string;
  DLL:string;
  PAS:string;
  Cmd:pAnsiChar;
  FacDir:string;
  hDll:tHandle;

  function TimeToName:string;
  begin
     result:=datetimetostr(now);
     result:=stringreplace(result,':','',[rfReplaceAll]);
     result:=stringreplace(result,'.','',[rfReplaceAll]);
     result:=stringreplace(result,' ','',[rfReplaceAll]);
  end;

begin
  FacDir:=ExtractFileDir(paramstr(0))+'\factory\';
  s:='library '+Who+'GetAction'+TimeToName+Who+'; uses '+Who+'GetAction1 in ' +Quotedstr(Who+'GetAction1.pas')+'; exports GetActionA name '+Quotedstr('GetAction')+'; end. ';
  DLL:=Who+'GetAction'+TimeToName+Who;
  assignfile(f,FacDir+DLL+'.dpr');
  rewrite(f);
  writeln(f,s);
  closefile(f);
  s:='unit '+Who+'GetAction1; ';
  s:=s+'interface  Procedure GetActionA(MLL,N,O,S,W,NO,SO,SW,NW,NL,OL,SL,WL,NOL,SOL,SWL,NWL:integer; var MVR,ACT,DX,DY,HLP:integer);';
  s:=s+'implementation Procedure GetActionA(MLL,N,O,S,W,NO,SO,SW,NW,NL,OL,SL,WL,NOL,SOL,SWL,NWL:integer; var MVR,ACT,DX,DY,HLP:integer);';
  s:=s+'function RND:integer; var sign:double; begin sign:=random; result:=random(2); if sign>0.5 then result:=result*(-1); end; ';
  s:=s+'begin'    +#13#10;
  s:=s+memo1.Text +#13#10;
  s:=s+' end;'     +#13#10+'end.';
  PAS:=FacDir+Who+'GetAction1.pas';
  assignfile(f,PAS);
  rewrite(f);
  writeln(f,s);
  closefile(f);

  ChDir(ExtractFileDir(paramstr(0))+'\factory');
  Cmd:=pChar('dcc32.exe '+DLL+'.dpr');
  winexec(Cmd,SW_NORMAL);

  sleep(500);

  ChDir(ExtractFileDir(paramstr(0)));
  DLL:=FacDir+DLL+'.dll';
  if fileexists(DLL)
  then
    try
      hDll:= LoadLibrary(pchar(DLL));
      addr(Action) := GetProcAddress(hDll, 'GetAction');
    except
      showmessage(SysErrorMessage(getlasterror));
    end
  else
    showmessage(DLL + ' не найден! А это могет означать, что скорее всего не поправилам написана программа.');
  close;
end;

procedure TfrmEditProgram.Button3Click(Sender: TObject);
begin
  if opendialog1.Execute then
    memo1.Lines.LoadFromFile(opendialog1.FileName);
end;

procedure TfrmEditProgram.FormCreate(Sender: TObject);
begin
  opendialog1.InitialDir:=ExtractFileDir(paramstr(0));
end;

end.