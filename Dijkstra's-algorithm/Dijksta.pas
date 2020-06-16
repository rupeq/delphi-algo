program lab91;
{ Дейкстра }

type
 tmas2=array[1..50,1..50] of integer;
 tmas1=array[1..50] of Boolean;
 tmas1i=array[1..50] of Integer;
var
 w:tmas2; //матрица весов
 d:tmas1i; //массив минимальных путей
 v:tmas1; //массив посещенных вершин
 ist,n:Integer; //от какой вершины идем и размерность
procedure vvodmatr(var n,ist: integer;var w:tmas2);
{ввод матрицы}
var
 i,j:integer;
 fin:text;
begin
 assign(fin,'input.txt');
 reset(fin);
 readln(fin,n,ist);
 for i:=1 to n do
 begin
  for j:=1 to n do
   read(fin,w[i,j]);
  readln(fin);
 end;
 close(fin);
end;
procedure vivodmatr(const n,ist:integer;const w:tmas2);
{вывод матрицы}
var
 i,j:integer;
 fout:text;
begin
 assign(fout,'output.txt');
 rewrite(fout);
 writeln(fout,ist,'  w'); //ищем от ist
 for i:=1 to n do
 begin
  for j:=1 to n do
   write(fout,w[i,j]:8);
  writeln(fout);
 end;
 close(fout);
end;
procedure Dejkstra(n:Integer;w:tmas2;ist:Integer;var d:tmas1i);
{ist = inf}
var
 i,j,nom,u:Integer;
 dmin:integer;
begin
 for i:=1 to n do
 begin
  d[i]:=w[ist,i]; //смежные с источником помечаем равными весам до них от источника
  v[i]:=False;
 end;
 d[ist]:=0; //присваиваем начальной вешине 0
 u:=1; 
 for i:=1 to n do //выбор следубщей вершины, ближайшей к d[ist]
 begin
  dmin:=maxint; //все остальные расстояния заполняются большим пол. числом
  for j:=1 to n do
  begin
    if (not v[j]) and (d[j]<dmin) then //выбираем наименьшую метку
    begin //вершину помечаем как пройденную, а метку помещаем в массив крат. раст. 
      dmin:=d[j]; 
      nom:=j;
    end;
  end;
  //в противном случае
  u:=nom; //из еще не пройденных вершин берем u, с мин. меткой
  v[u]:=True;
  for j:=1 to n do // для каждого соседа вершины, рассмотрим длину пути,равную сумме значений метки и лины ребра
    if (not v[j]) and (w[u,j]<>maxint) and (d[u]<>maxint) and ((d[u]+w[u,j])<d[j]) then // соединяющую u с соседом
      d[j]:=d[u]+w[u,j]; //если меньше, заменим значение метки полученным значением длины
 end;
end;
procedure vivodrasst(n,ist:Integer;d:tmas1i);
var
 i:Integer;
 fout:Text;
begin
 assign(fout,'output.txt');
 append(fout);
 Writeln(fout,ist,'  d=');
 for i:=1 to n do
  if d[i]<>maxint then
   write(fout,d[i]:8);
 Writeln(fout);
 Close(fout);
end;
begin
 vvodmatr(n,ist,w);
 vivodmatr(n,ist,w);
 Dejkstra(n,w,ist,d);
 vivodrasst(n,ist,d);
end.
