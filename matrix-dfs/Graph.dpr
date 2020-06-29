program lab32_11;
{Разработал Деревяго А. С.
}


{$APPTYPE CONSOLE}


type
 TMatrix=array of array of integer;  //динамическая матрица

function Rus(mes: string):string;
var
  i: integer; // номер обрабатываемого символа
begin
  for i:=1 to length(mes) do
   case mes[i] of
     'А'..'о':mes[i] := Chr(Ord(mes[i]) - 64);
     'п'..'я': mes[i]:= Chr (Ord(mes [i] ) -16);
   end;
  rus := mes;
end;

{загрузка матрицы из файла}
function LoadMatrix(const FileName:string):TMatrix;
var
 F:TextFile;
 S:string;
 j:integer;
begin
 Result:=nil;
 AssignFile(F,FileName);
 try
    Reset(F);
 except
    exit;
 end;
 while not EOF(F) do
 begin
    Readln(F,S);
    SetLength(Result,Length(Result)+1);                  //ув. высоты
    SetLength(Result[High(Result)],Length(S)+1);         //ув. ширины
    for j:=1 to Length(S) do                             //значения
      Result[High(Result),j-1]:=ord(S[j])-ord('0');
    Result[High(Result),High(Result[High(Result)])]:=0;  //последний элемент каждой строки - флаг входа в DFS
 end;
 CloseFile(F);
end;

{вывод матрицы}
procedure PrintMatrix(const M:TMatrix);
var
 i,j:integer;
 c:char;
begin
 if M=nil then
 begin
    Writeln(rus('Matrix is empty!'));
    exit;
 end;
 c:='A';                      //маркировка вершин по алфавиту (A-Z)
 for i:=0 to High(M) do
 begin
    Write(c,' ');
    Inc(c);
    for j:=0 to High(M[i])-1 do //последний элемент каждой строки не выводится
      Write(M[i,j]);
    Writeln;
 end;
end;

{dfs поиск пути}
function GetPath(const G:TMatrix; Src,Dst:integer):string;
var
 i,j:integer;
begin
 if (Src>High(G)) or (Dst>High(G)) then    //проверка границ
 begin
    Result:='';
    exit;
 end;
{вход в вершину}
 Result:=chr(Src+ord('A')); //маркировка
 G[Src,High(G[Src])]:=1;    //установка флага
 if Src=Dst then
    exit;
{Поиск рёбер, ведущих из текущей вершины}
 for j:=0 to High(G[Src])-1 do
    if G[Src,j]=1 then            //найдено ребро
      for i:=0 to High(G) do       //поиск целевой вершины
        if (G[i,j]=1) and (G[i,High(G[i])]=0) then  //если целевая вершина ещё не промаркирована,
          Result:=Result+GetPath(G,i,Dst);           //то выполнить вход в неё
 G[Src,High(G[Src])]:=0;
 if Result[Length(Result)]<>chr(Dst+ord('A')) then
    delete(Result,Length(Result),1);
end;


// Основная программа
var
 M:TMatrix;
 c:char;
 NodeA,NodeB:integer;
 Path:string;
begin
 M:=LoadMatrix('Matrix.txt');
 PrintMatrix(M);
 if M<>nil then
 begin
    Writeln;
    Write(rus('Начальная вершина (латиницей): '));
    Readln(c);
    NodeA:=ord(c)-ord('A');
    Write(rus('Конечная вершина (латиницей): '));
    Readln(c);
    NodeB:=ord(c)-ord('A');
    Path:=GetPath(M,NodeA,NodeB);   //поиск пути
    Write(rus('Путь: '));
    if Path<>'' then
      Writeln(Path)
    else
      Writeln(rus('Путь не найден!'));
 end;
 Readln;
end.
