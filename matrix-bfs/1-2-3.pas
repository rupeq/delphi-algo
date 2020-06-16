program lab8_1;

uses crt, System;


var
  i, j, n, a, b, v: integer;
  mas: array of array of integer;
  smezh, incid: array of array of integer;
  list: array of array of string;
  visit: array [1..6] of boolean;
  str: string; f: textfile;


{процедура поиска в глубину DFS}
procedure DFS(v: integer);
var t: integer;
begin
  write(v, ' ');
  visit[v]:=true;
  for t := 1 to n do
    if (smezh[v-1, t-1]<>0) and (visit[t] = false) then
     dfs(t);

end;

{ввод из файла}
begin
 AssignFile(f, 'input.txt');
 reset(f);
 read(f, v);
 read(f, n);
 SetLength(mas, 7, 4);
 SetLength(smezh, v, v);
 SetLength(incid, v, n);
 SetLength(list, v);
 for i := 0 to n-1 do
 begin
     read(f, mas[i,1-1]);
     read(f, mas[i,2-1]);
     read(f, mas[i,3-1]);
 end;
 for i := 0 to n-1 do
 begin
     write(mas[i, 1-1], ' ');
     write(mas[i, 2-1], ' ');
     write(mas[i, 3-1], ' ');
     writeln;
 end;
 writeln;
{матрица смежности}
 for i := 0 to n-1 do
 begin
     smezh[mas[i,0]-1, mas[i,1]-1 ]:=mas[i,2];
     smezh[mas[i,1]-1, mas[i,0]-1 ]:=mas[i,2];
 end;
 writeln('Матрица смежности: ');
 for i := 0 to v-1 do
 begin
   for j := 0 to v-1 do
   begin
       write (smezh[i,j], ' ' )
   end;
   writeln;
 end;
 writeln; 
{матрица инцидентности}
 for i := 0 to n-1 do
 begin
   incid[mas[i,0]-1, i]:= mas[i, 2];
   incid[mas[i,1]-1, i]:= mas[i, 2];
 end;
  writeln('Матрица инцидентности: ');
 for i := 0 to v-1 do
 begin
   for j := 0 to n-1 do
   begin
     write(incid[i,j], ' ');
   end;
   writeln;
 end;
 writeln;
{список смежности}
  writeln('Список смежности: ');
   for i := 0 to n-1 do
   begin
        list[mas[i, 0]-1]:=list[mas[i, 0]-1] +(IntToStr(mas[i, 1]) + '(' + IntToSTr(mas[i,2]) + ')  ');
        list[mas[i, 1]-1]:=list[mas[i, 1]-1]+(IntToStr(mas[i, 0]) + '(' + IntToSTr(mas[i,2]) + ')  ');
   end;
   for i := 0 to v-1 do
   begin
       write(i+1, ': ');
       writeln(list[i]);
   end;
  readln;
  writeln('Узнать смежность вершин');
  writeln('Ввести вершины');
   read(a, b);
   writeln (smezh[a-1,b-1]<>0);
  writeln('Узнать ребра');
  writeln('Введите вершины');
  readln(a, b);
  writeln(smezh[a-1,b-1]);
  writeln('Узнать инцидентные ребра ');
  writeln('Введите вершины');
  readln(a);
  write(a, ': ');
  for i := 0 to n-1 do
    if incid[a-1, i]<>0 then
    write(i+1, ' ');
  readln;
  writeln('DFS');
  writeln('Введите первую вершину');
  readln(a);
  writeln('Путь обхода (DFS):');
  dfs(a);
  readln;
  close(f);
end.