program lab27_11;
{Разработал Деревяго А. С.
Найдите путь между двумя заданными узлами бинарного дерева}

{$APPTYPE CONSOLE}

uses
 Windows;

type
uk=^btree;    // указатель на узел
btree=record     // бинарное дерево
  Tag:char;       // тег узла
  L,R:uk;      // указатели на потомков
end;

function Rus(mes: string):string;
var
  i: integer;
begin
  for i:=1 to length(mes) do
   case mes[i] of
     'А'..'п':mes[i] := Chr(Ord(mes[i]) - 64);
     'р'..'я':mes[i]:= Chr (Ord(mes [i] ) -16);
   end;
  rus := mes;
end;

{перемещение курсора}
procedure GotoXY(x,y:integer);
var
 XY:COORD;
begin
 XY.X:=x;
 XY.Y:=y;
 SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE),XY);
end;

{вывод узла с потомками}
procedure PrintNode(V:uk; X, Y, dx:integer); //х,y текущие координаты
var
 idx,i: integer;
begin
 idx:=Trunc(dx+0.5);   // смещение курсора, dx - размах ветки
 GotoXY(X,Y);
 Write(V.Tag);
 if V.L<>nil then      // вывод левой ветви
 begin
    GotoXY(X-idx,Y);
    if(idx<>0) then
      Write(#218);
    for i:=1 to idx-1 do
      Write(#196);
    PrintNode(V.L,X-idx,Y+1,dx div 2);  // влево-вниз + потомок
 end;
 if V.R<>nil then      // вывод правой ветви
 begin
    GotoXY(X+1,Y);
    for i:=1 to idx-1 do
      Write(#196);
    if idx<>0 then
      Write(#191);
    PrintNode(V.R,X+idx,Y+1,dx div 2); //право-низ + потомок
 end;
end;

{создание узла с потомками}
function MakeNode(Depth:integer; var Tag:char):uk; //depth - тек. клубина
begin
 Result:=nil;
 if (Depth<Random(6)+1) and (Tag<='Z') then //чем глубже, тем меньше шанс создания
 begin
    new(Result);
    Result.Tag:=Tag;
    Inc(Tag);
    Result.L:=MakeNode(Depth+1,Tag);   // левый потомок
    Result.R:=MakeNode(Depth+1,Tag);   // и правый
 end;
end;

{поиск в глубину пути из корня до узла tag}
function Search(V:uk; Tag:char):string;
begin
 Result:=V.Tag;
 if V.Tag=Tag then
    exit;     //если уже найдено
 if V.L<>nil then
    Result:=Result+Search(V.L,Tag);   //для левого потомка
 if V.R<>nil then
    Result:=Result+Search(V.R,Tag);  //для правого потомка
 if Result[Length(Result)]<>Tag then
    delete(Result,Length(Result),1);  //выход из узла
end;

{формирование пути}
function GetPath(V:uk; a,b:char):string;
var
 WayA,WayB:string;
 Buf:char;
 i:integer;
begin
 WayA:=Search(V,a);
 WayB:=Search(V,b);
 if (WayA='') or (WayB='') then   // нет узла = ошибка
 begin
    Result:=Rus('Путь не найден. Пороверьте правильность ввода');
    exit;
 end;
 repeat
    Buf:=WayA[1];         // последний общий символ в буфер
    delete(WayA,1,1);     // удаляем общие
    delete(WayB,1,1);
 until (Length(WayA)=0) or (Length(WayB)=0) or (WayA[1]<>WayB[1]);
 Result:='';
 for i:=Length(WayA) downto 1 do
    Result:=Result+WayA[i];
 Result:=Result+Buf+WayB;   //дописываем последний общий символ
end;


{основная часть}
var
 Tree:uk;
 Tag:char='A';
 a,b:char;
begin
 Randomize;
 Tree:=MakeNode(0,Tag);
 PrintNode(Tree,40,0,20);
 GotoXY(0,10);             //курсор под дерево
 Write (Rus('Путь из: '));     //ввод начала и конец
 Readln(a);
 Write (Rus('Путь в: '));
 Readln(b);
 Writeln (rus('Искомый путь: '));
 write(GetPath(Tree,a,b));
 Readln;
end.
