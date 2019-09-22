unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  // создадим тип для матрицы
  // нужен для передачи матрицы в функции обработки
  // кстати т.к. он в области interface и этот модуль мы подключаем в unit1
  // то этот тип можо будет использовать в unit1
  Matr = array[1..15, 1..15] of integer;

// прототипы функций которые ДОЛЖНЫ быть ВЫДНЫ в ДРУГИХ модулях(unit1)
procedure RandomMatrix(var M: Matr; n: integer);
procedure MoveRight(var M: Matr; n: integer);
procedure MoveLeft(var M: Matr; n: integer);

// для защиты расскомментируйте две нижние строчке
procedure MoveUP(var M:Matr; n: integer);
procedure MoveDown(var M:Matr; n: integer);

implementation

{Процедура заполнения матрицы рандомными числами}
//'var M' - т.к. меняем элементы матрицы
//  'n' - разменрность матрицы - число строк и столбцов
procedure RandomMatrix(var M: Matr; n : integer);
var i, j: integer;
begin
  randomize; // для генератора случайных чисел
  for i:=1 to n do
    for j:=1 to n do
      M[i,j] := 1 + random(100); // рандомное число на отрезке [1;100]
end;


{Процедура перемещает элементы с ПОБОЧНОЙ диагонали ВПАРАВО}
procedure MoveRight(var M:Matr; n: integer);
var
  // вспомогательная переменная для перестановки элементов в матрице
  temp: integer;
  i, j: integer;
begin
  // Сначала обходим СТРОКИ матрицы - так как будем перемещать элементы
  // ИМЕННО в строках, а не в столбцах
  for i:=1 to n do
  begin
    // Для начала стоит вспомнить как задаются элементы,
    // лежашщие на  ПОБОЧНОЙ диагнали
    // Побочная диагональ
    // - это когда номер СТРОКИ = номеру СТОЛБЦА(если считать столбец с конца)
    // то есть элемент с индексом M[i,n-i+1];

    // Переместим этот элемент в ВПРАВО,
    // то есть в КОНЕЦ i-ой строки матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[i, n-i+1];

    // Потом смещаем все элементы ПРАВЕЕ его ВЛЕВО на одну позицию(затирая его)
    //   -От j=n-i+1 - элемента лежащего на ПОБОЧНОЙ диагонали
    //   -До n-1, т.к. если n то получится M[i, j] = M[i, n+1]
    //    НЕТ такого элемента
    for j := n-i+1 to n-1 do
        M[i, j]:= M[i, j+1];

    {
        То есть
        было :   1 2 3 diag_el 4 5
        стало:   1 2 3 4 5 5
    }

    // нетрудно заметить, что теперь два последних элемента СТРОКИ дублируются
    // теперь мы как раз можем записать на ПОСЛЕДНЕЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[i,n] := temp;
    // стало :  1 2 3 4 5 diag_el

    // задача для одной строки выполнена, переходим к другой строке
  end;
end;


{Процедура перемещает элементы с ПОБОЧНОЙ диагонали ВЛЕВО}
procedure MoveLeft(var M:Matr; n: integer);
var
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим СТРОКИ матрицы
  for i:=1 to n do
  begin

    // Для начала стоит вспомнить как задаются элементы,
    // лежашщие на ПОБОЧНОЙ диагнали
    // Побочная диагональ
    // - это когда номер СТРОКИ = номеру СТОЛБЦА(если считать столбец с конца)
    // то есть элемент с индексом M[i,n-i+1];

    // Переместим этот элемент в ВЛЕВО,
    // то есть в НАЧАЛО i-ой строки матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[i, n-i+1];

    // Потом смещаем все элементы ЛЕВЕЕ его ВПРАВО на одну позицию(затирая его)
    //   -От j=n-i+1 - элемента лежащего на ПОБОЧНОЙ диагонали
    //   -До 2, т.к. если j=1 то получится M[i, j] = M[i, 1-1] = M[i, 0]
    //    НЕТ такого элемента
    for j := n-i+1 downto 2 do
        M[i, j]:= M[i, j-1];

    {
        То есть
        было :   1 2 3 diag_el 4 5
        стало:   1 1 2 3 4 5
    }

    // нетрудно заметить, что теперь два первых элемента СТРОКИ дублируются
    // теперь мы как раз можем записать на ПЕРВОЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[i,1] := temp;
    // стало :  diag_el 1 2 3 4 5

    // задача для одной строки выполнена, переходим к другой строке
  end;
end;


// -----------------------------------------------------------------------------
// защита
// здесь могут дать сделать то же самое только для столбцов
// То есть вместо того чтобы, передвигать ВЛЕВО - передвигаем ВВЕРХ
//                                вместо ВПРАВО - передвигаем ВНИЗ

{Процедура перемещает элементы с ПОБОЧНОЙ диагонали НАВЕРХ}
procedure MoveUP(var M:Matr; n: integer);
var
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим СТОЛБЦЫ матрицы - так как будем перемещать элементы
  // ИМЕННО в столбцах, а не в строках
  for j:=1 to n do
  begin

    // Элемент на ПОБОЧНОЙ диагонали задаётся так(если обходятся строки): M[i, n-i+1]
    // а если как мы обходим СТОЛБЦЫ - то M[n-j+1, j]

    // Переместим  его в ВВЕРХ,
    // то есть в НАЧЛАО j-го столбца матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[n-j+1, j];

    // Потом смещаем все элементы ВЫШЕ его ВНИЗ на одну позицию(затирая его)
    //   -От i=n-j+1 - элемента лежащего на ПОБОЧНОЙ диагонали
    //   -До 2, т.к. если i=1 то получится M[i-1, j] = M[1-1, j] = M[0, j]
    //    НЕТ такого элемента
    for i := n-j+1 downto 2 do
        M[i, j]:= M[i-1, j];

    {
        То есть
        было :   1           стало:   1
                 2                    1
                 3                    2
                 diag_el              3
                 4                    4
                 5                    5
    }

    // нетрудно заметить, что теперь два первых элемента СТОЛБЦА дублируются
    // теперь мы как раз можем записать на ПЕРВОЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[1, j] := temp;
    {
       стало:    diag_el
                 1
                 2
                 3
                 4
                 5
    }

    // задача для одного столбца выполнена, переходим к другому
  end;
end;

{Процедура перемещает элементы с ПОБОЧНОЙ диагонали ВНИЗ}
procedure MoveDown(var M:Matr; n: integer);
var
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим СТОЛБЦЫ матрицы - так как будем перемещать элементы
  // ИМЕННО в столбцах, а не в строках
  for j:=1 to n do
  begin

    // Элемент на ПОБОЧНОЙ диагонали задаётся так(если обходятся строки): M[i, n-i+1]
    // а если как мы обходим СТОЛБЦЫ - то M[n-j+1, j]

    // Переместим  его в ВНИЗ,
    // то есть в КОНЕЦ j-го столбца матрицы

    // Но перед этим сохраним его значение в вспомогательную переменную
    temp := M[n-j+1, j];

    // Потом смещаем все элементы НИЖЕ его ВВЕРХ на одну позицию(затирая его)
    //   -От i=n-j+1 - элемента лежащего на ПОБОЧНОЙ диагонали
    //   -До n-1, т.к. если i=n то получится M[n+1, j] = M[n+1, j]
    //    НЕТ такого элемента
    for i := n-j+1 to n-1 do
        M[i, j]:= M[i+1, j];

    {
        То есть
        было :   1           стало:   1
                 2                    2
                 3                    3
                 diag_el              4
                 4                    5
                 5                    5
    }

    // нетрудно заметить, что теперь два последних элемента СТОЛБЦА дублируются
    // теперь мы как раз можем записать на ПОСЛЕДНЕЕ место
    // наш диагональный элемент, значение которого было сохранено в temp
    M[n, j] := temp;
    {
       стало:    1
                 2
                 3
                 4
                 5
                 diag_el
    }

    // задача для одного столбца выполнена, переходим к другому
  end;
end;

end.