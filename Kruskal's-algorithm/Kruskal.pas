program Kruskal_alg;

const
  maxn = 100;
  maxm = 10000;
  inf = maxint div 2;

type
  edge = record
  x, y: integer; // вершины ребра
  w: integer; // вес ребра
end;

var
  a: array [1..maxm] of edge; // список ребер
  s: array [1..maxn] of integer; // размер компонент связности
  r: array [1..maxn] of integer; // связи вершин в компонентах связности
  n, m: longint; // кол-во вершин и ребер
  mst_weight: longint; // вес MST
  
{ инициализация и чтение данных }
procedure init;
var
  i, j, x, y, nn, z: longint;
  input:text;
begin
  mst_weight := 0;
  assign(input, 'mst.txt');
  reset(input);
  readln(input,n);
  readln(input,m);
  for i := 1 to m do
  begin
    readln(input,x, y, z);
    a[i].x := x;
    a[i].y := y;
    a[i].w := z;
  end;
  Close(input);
end;

{ обмен двух ребер (для сортировки) }
procedure swap(var e1, e2: edge);
var
  e: edge;
begin
  e := e1; 
  e1 := e2; 
  e2 := e;
end;

{ рандомизированная быстрая сортировка }
procedure qsort(l, r: integer);
var
  i, j, x: integer;
begin
  i := l; // i – левая граница
  j := r; // j – правая граница
  x := a[l+random(r-l+1)].w; // x – случайный элемент из интервала
  repeat
  while x > a[i].w do inc(i); // ищем элемент больший барьера
    while x < a[j].w do dec(j); // ищем элемент меньший барьера
      if i <= j then // указатели не пересекклись
      begin
        swap(a[i], a[j]); // меняем элементы
        inc(i); // продвигаем левый указатель
        dec(j); // продвигаем правый указатель
      end;
  until i > j; // до пересечения указателей
  if l < j then 
    qsort(l, j); // сортируем левый подмассив
  if i < r then 
    qsort(i, r); // сортируем правый подмассив
end;

{ построение mst (алгоритм Крускала) }
procedure kruskal;
var
  k, i, p, q: integer;
begin
  qsort(1, m); // сортируем список ребер по неубыванию
  for i := 1 to n do // цикл по вершинам
  begin
    r[i] := i; // у вершина своя компонента связности
    s[i] := 1; // размер компоненты связности
  end;
   k := 0; // номер первого ребра + 1
  for i := 1 to n - 1 do // цикл по ребрам mst
  begin
    repeat // ищем ребра из разных
      inc(k); // компонент связности
      p := a[k].x;
      q := a[k].y;
      while r[p] <> p do // ищем корень для p
        p := r[p];
      while r[q] <> q do // ищем корень для q
        q := r[q];
    until p <> q;
    writeln(a[k].x, ' ', a[k].y); // вывод ребра
    inc(mst_weight, a[k].w);
    if s[p] < s[q] then // взвешенное объединение
    begin // компоненты связности
      r[p] := q;
      s[q] := s[q] + s[p];
    end
    else
    begin
      r[q] := p;
      s[p] := s[p] + s[q];
    end;
  end;
end;

{main}
begin
  init; //инициилицируем
  writeln('Алгоритм Крускала: ');
  kruskal; //запуск алгоритма
  writeln('Коммуникационная сеть с минимальными затратами: ', mst_weight); //вывод последовательности
end.