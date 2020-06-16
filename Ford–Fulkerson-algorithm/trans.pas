program fordfalkenson;

const // объявление констант
  maxn = 100; // макс. кол-во вершин
  oo = maxint; // бесконечность
  
var // объявление переменных
  f: array [1..maxn, 1..maxn] of integer; // текущий поток в сети f[i, j] = -f[j, i]
  c: array [1..maxn, 1..maxn] of integer; // матрица пропускных способностей
  n: integer; // количество вешрин

const
  queue_size = maxn + 2; // размер очереди
  
type
  queue = record // очередь
  a: array [0..queue_size-1] of integer;
  head, tail: integer;
end;

procedure init_queue(var q: queue); // инициализация очереди
begin
  with q do
  begin
    tail := 0;
    head := 0;
  end;
end;

function is_queue_empty(const q: queue): boolean; // функция проверки // очереди на пустоту
begin
  is_queue_empty := q.tail = q.head;
end;

procedure push_to_queue(var q: queue; x: integer); // процедура добавления
// элемента х в очередь
begin
  with q do
  begin
    a[tail] := x;
    tail := (tail + 1) mod queue_size;
  end;
end;

function pop_from_queue(var q: queue): integer; // функция извлечения
// элемента из очереди
begin
  with q do
  begin
    pop_from_queue := a[head];
    head := (head + 1) mod queue_size;
   end;
end;

var // объвление переменных
  p: array [1..maxn] of integer; // номер предыдущей вершины
  v: array [1..maxn] of boolean; // посещенность вершин
  q: queue; // очередь
function bfs(s, t: integer): boolean; // функция поиска в ширину для метода Форда-Фалкерсона
// возвращает true, если существует путь от s до t
var
  i, j: integer;
begin
  for i:=1 to maxn do
    v[i]:=false; // обнуляем массив посещений
  init_queue(q); // инициализируем очередь
  push_to_queue(q, s); // заталкиваем в очередь исток
  v[s] := true; // посетили исток
  p[s] := -1; // у истока нет предка
  while not is_queue_empty(q) do // пока очередь не пуста
  begin
    i := pop_from_queue(q); // достаем вершину из очереди
    for j := 1 to n do // перебираем все вершины
      if not v[j] and (c[i, j]-f[i, j] > 0) then // вершина не посещена
      //т.е. ребро i->j ненасыщенное
      begin
        v[j] := true; // посетили вершину j
        push_to_queue(q, j); // положили веришину j в очередь
        p[j] := i; // i предок j
      end;
  end;
  bfs := v[t]; // дошли ли до стока
end;

{ Основные процедуры }
function min(a, b: integer): integer; // функция нахождения минимума
// из двух чисел
begin
  if a > b then 
    min := b 
  else 
    min := a;
end;

function maxflow(s, t: integer): integer; // нахождение максимального
// потока поток хранится в
// матрице f, s-исток, t-сток
var
  i,j: integer;
  k: integer;
  d, flow: integer;
begin
  for i:=1 to maxn do
    for j:=1 to maxn do
      f[i,j]:=0; // обнуляем f
  flow := 0; // поток пустой
  while bfs(s, t) do // пока существует путь от истока в
  begin // в сток в остаточной сети, ищем
    d := oo; // ребро в этом пути с минимальной
    k := t; // неиспользованной пропускной
    while k <> s do // способностью
    begin
      d := min(d, c[p[k], k]-f[p[k], k]);
      k := p[k]; // берем вершину-предок
    end;
    k := t; // идем по найденому пути
    while k <> s do // от стока к истоку
    begin
      f[p[k], k] := f[p[k], k] + d; // увеличиваем по прямым ребрам
      f[k, p[k]] := f[k, p[k]] - d; // уменьшаем по обратным ребрам
      k := p[k]; // берем вершину-предок
    end;
    flow := flow + d; // увеличиваем поток
  end;
  maxflow := flow; // возвращаем максимальный поток
end;

procedure init; // процедура инициализации
// и ввода исходных данных
var
  input: text;
  m, i, j, x, y, z: integer;
begin
  for i:=1 to maxn do
    for j:=1 to maxn do
      c[i,j]:=0;
  assign(input, 'flow.txt');
  reset(input);
  read(input, n, m);
  for i := 1 to m do
  begin
    read(input, x, y, z);
    c[x, y] := z;
  end;
  close(input);
end;

{solve: решение }
procedure solve; // решение
begin
  writeln(maxflow(1, n));
  readln;
end;

{ Главная программа }
begin
  init;
  solve;
  readln;
end.