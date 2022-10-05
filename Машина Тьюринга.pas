uses graphabc;
{Константы для визуализации}
const
  y1 = 200;
  y2 = 300;
  x1 = 50;
  x2 = 590;
{Визуализация перехода указателя вправо}
procedure cool_1(x, i: integer; s: string; c: color := clPaleGreen);
begin
  sleep(500);
  SetBrushColor(c);
  FillRectangle(x1 + (i - 1) * x, y1, x1 + i * x, y2);
  DrawRectangle(x1 + (i - 1) * x, y1, x1 + i * x, y2);
  textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s[i]);
  SetBrushColor(clWhite);
  FillRectangle(x1 + (i - 2) * x, y1, x1 + (i - 1) * x, y2);
  DrawRectangle(x1 + (i - 2) * x, y1, x1 + (i - 1) * x, y2);
  textout(x1 + (i - 2) * x + (x div 4), y1 + 50, s[i - 1]);
  
end;
{Визуализация перехода указателя влево}
procedure cool_2(x, i: integer; s: string; c: color := clPaleGreen);
begin
  sleep(500);
  SetBrushColor(c);
  FillRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
  DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
  textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s[i]);
  SetBrushColor(clWhite);
  FillRectangle(x1 + i * x, y1, x1 + (i + 1) * x, y2);
  DrawRectangle(x1 + i * x, y1, x1 + (i + 1) * x, y2);
  textout(x1 + i * x + (x div 4), y1 + 50, s[i + 1]);
  
end;
{Визуализация перезаписи текущей ячейки}
procedure cool_3(x, i: integer; s: string; c: color := clPaleGreen);
begin
  sleep(500);
  SetBrushColor(c);
  FillRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
  DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
  textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s[i]);
end;

{Четность/нечётность количества единиц в строке}
procedure chek(s: string);
  {Состояние 2: Количество единиц нечетно}
  procedure parity_2(var s: string; var i: integer; x: integer); 
  begin
    if s[i] <> '1' then 
    begin
      if s[i] = 'B' then //Если мы достигли конца строки, то выводим ответ
        begin 
        SetBrushColor(clWhite); 
        textout(0, 20, 'Ответ: Количество единиц нечетно'); 
        exit;
        end;
      i += 1; //Если встречена не единица, то переходим к следующей ячейке
      cool_1(x, i, s, clSalmon);
      parity_2(s, i, x);
    end
    else 
    begin
      cool_3(x, i, s); //Встречена единица, визуально показываем переход в состояние 1
      exit;
    end;
  end;
  
  {Состояние 1: количество единиц четно}
  procedure parity_1(var s: string; var i: integer; x: integer); 
  begin
    if s[i] <> '1' then
    begin
      if s[i] = 'B' then //Если мы достигли конца строки, то выводим ответ
        begin SetBrushColor(clWhite); 
        textout(0, 20, 'Ответ: Количество единиц четно');
        exit;
        end;
      i += 1; //Если встречена не единица, то переходим к следующей ячейке
      cool_1(x, i, s);
      parity_1(s, i, x);
    end
    else begin //Встечена единица
      cool_3(x, i, s, clSalmon); //Визуально показываем переход в другое состояние
      i += 1;
      cool_1(x, i, s, clSalmon); //Переходим к следующей ячейке
      parity_2(s, i, x); //Запускаем процедуру для второго состояния
      if s[i] = 'B' then exit; //Если ответ был получен в процедуре состояния 2, то завершаем работу процедуры
      i += 1; //Конец стоки не достигнут, переходим к следующей ячейке
      cool_1(x, i, s); 
      parity_1(s, i, x);
    end;
  end;


var
  x, i, n: integer;

begin
  s := s + 'B'; //Символ конца строки
  n := length(s); //Длина строки для визуализации
  if s = 'B' then //Проверка на пустую строку
    textout(0, 20, 'Некорректный ввод')
  else begin
    x := ((x2) - (x1)) div n; //Расчетное количество ячеек
    for i := 1 to n  do
    begin
      DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2); //Рисуем ячейку
      textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s[i]); //Рисуем значение ячейки
    end;
    i := 1; //Начинаем с первой ячейки
    cool_3(x, i, s);//Визуально обозначаем первую ячейку
    SetBrushColor(clWhite);
    parity_1(s, i, x); //Запускаем процедуру
  end;
  while true do //Выход в главное меню
  begin
    textout(0, 40, 'Введите 1 чтобы выйти');
    readln(i);
    if i = 1 then break;
  end;
  exit
end;

{Правильная скобочная последовательность}
procedure psp(s: string);
  
  {Поиск первой открывающей скобки}
  procedure psp_2(var s: string; var i: integer; x: integer);
  begin
    if s[i] = '(' then //Скобка найдена
    begin
      s[i] := 'X'; //Зачеркиваем
      exit; //Возвращаемся в процедуру 1
    end;
    if s[i] = 'A' then //Скобка ненайдена
    begin
      cool_3(x, i, s, clRed); //Ошибка
      SetBrushColor(clWhite); //Выводим ответ
      textout(0, 20, 'Ответ: Последовательность неправильная'); exit;
    end;
    i := i - 1; //Встречен зачеркнутый символ, идём налево
    cool_2(x, i, s);
    psp_2(s, i, x);
  end;
  
  {Проверка на зачеркнутые символы}
  procedure psp_3(s: string; var i: integer; x: integer);
  begin
    i := i - 1; //Идём налево
    if s[i] = 'X' then
    begin
      cool_2(x, i, s);
      psp_3(s, i, x);
    end
    else begin cool_2(x, i, s); exit; end;
  end;
  
  {Поиск закрывающих скобок}
  procedure psp_1(var s: string; var i: integer; x: integer);
  begin
    if ((s[i] = '(') or (s[i] = 'X')) then begin
      cool_1(x, i, s); //Идём направо
      i += 1;
      psp_1(s, i, x);
    end
    else
    if s[i] = ')' then begin //Встречена закрывающая скобка
      cool_1(x, i, s); //Обозначаем переход
      s[i] := 'X'; //Зачеркиваем
      cool_3(x, i, s); //Обозначаем зачеркивание
      psp_2(s, i, x); //Запускаем процедуру 2
      if s[i] = 'A' then //Было сообщение об ошибке
        exit;
      psp_1(s, i, x); //Продолжаем идти вправо
    end
    else
    if s[i] = 'A' then begin //Встречен конец строки
      cool_1(x, i, s); //Визуальный переход
      psp_3(s, i, x); //Проверка на незачеркнутые символы
      if s[i] = 'A' then //Проверка пройдена
      begin
        SetBrushColor(clWhite);
        textout(0, 20, 'Ответ: Последовательность правильная'); exit;
      end
      else begin //Проверка не пройдена
        cool_3(x, i, s, clRed);
        SetBrushColor(clWhite);
        textout(0, 20, 'Ответ: Последовательность неправильная'); exit;
      end;
    end;
  end;

var
  x, i, n: integer;

begin
  if s = '' then //Проверка на пустую строку
    textout(0, 20, 'Некорректный ввод')
  else begin
    s := 'A' + s + 'A'; //Начало и конец строки
    n := length(s); //Визуализация
    x := ((x2) - (x1)) div n;
    for i := 1 to n  do
    begin
      DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
      textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s[i]);
    end;
    i := 2; //Начинаем со второго символа
    cool_3(x,i,s);
    psp_1(s, i, x); //Запускаем процедуру
  end;
  while true do //Выход в главное меню
  begin
    textout(0, 40, 'Введите 1 чтобы выйти');
    readln(i);
    if i = 1 then break;
  end;
  exit
end;

{Умножение в унарной системе}
procedure multiply(s1, s2: string);
  
  {Приводим унарные числа в корректный вид}
  procedure multiply_5(var s: string; var i: integer; x: integer);
  begin
    i := i + 1; //Идём направо
    cool_1(x, i, s);
    if (s[i] = 'X') or (s[i] = '0') then begin
      s[i] := '1'; //Все 0 и X заменяем на 1
      cool_3(x, i, s);
    end;
    if s[i] = ' ' then exit; //Встречен конец строки, выход
    multiply_5(s, i, x); //Идём дальше
  end;
  
  {Запись зачеркнутого символа в конец строки}
  procedure multiply_4(var s: string; var i: integer; x: integer);
  begin
    i := i + 1; //Идём направо
    if s[i] = ' ' then begin //Встречен пустой символ
      cool_1(x, i, s);
      s[i] := 'X'; //Ставим на его место зачеркнутый
      cool_3(x, i, s);
      s := s + ' '; //Довавляем пустой символ к строке
      exit; //Выходим
    end;
    cool_1(x, i, s); //Идём дальше
    multiply_4(s, i, x);
  end;
  
  {Поиск единиц второго множителя}
  procedure multiply_3(var s: string; var i: integer; x: integer);
  begin
    i := i - 1; //Идём налево
    cool_2(x, i, s);
    if s[i] = '1' then begin //Единица найдена
      s[i] := 'X'; //Зачеркиваем единицу
      cool_3(x, i, s); //Отображаем зачеркивание
      multiply_4(s, i, x); //Записываем зачеркнутый символ в конец строки
    end
    else if s[i] = 'B' then exit; //Встречен конец первой строки, выход
    multiply_3(s, i, x); //Идём дальше
  end;
  
  {Поиск конца второй строки}
  procedure multiply_2(var s: string; var i: integer; x: integer);
  begin
    i += 1; //Идём направо
    cool_1(x, i, s);
    if s[i] <> 'A' then
    begin
      if (s[i] <> 'B') and (s[i] <> '0') then begin
        s[i] := '1'; //Вместо всех зачеркнутых символов ставим 1
        cool_3(x, i, s); //Отображаем 1
      end;
      multiply_2(s, i, x);
    end
    else 
      begin //Конец строки найден
    multiply_3(s, i, x); //Ищем единицы второго множителя
    exit; //Встречен конец первой строки, выход, начинаем все сначала
      end; 
  end;
  
  {Поиск единиц первого множителя}
  procedure multiply_1(var s: string; var i: integer; x: integer);
  begin
    i := i - 1; //Идём налево
    cool_2(x, i, s);
    if s[i] = '1' then begin //Найдена единица
      s[i] := '0'; //Записываем 0
      cool_3(x, i, s); //Визуально отображаем 0
      multiply_2(s, i, x); //Ищем конец второй строки
    end
    else
    if s[i] = 'A' then begin //Встречено начало первой строки
      multiply_5(s, i, x); //Приводим унарные числа в корректный вид
      exit; //Завершение работы
    end;
    multiply_1(s, i, x); //Идём дальше
  end;

var
  x, i, n: integer;

begin
  if (s1 = '') or (s2 = '') then //Проверка на пустую строку
    textout(0, 40, 'Некорректный ввод')
  else begin
    n := length(s1) + length(s2) + length(s1) * length(s2) + 4; //Определяем необходимое количество ячеек
    s1 := 'A' + s1 + 'B' + s2 + 'A' + ' '; //Формируем строку
    x := ((x2) - (x1)) div n; 
    for i := 1 to n  do
    begin
      if i <= length(s1) then begin //Визуализируем строку
        DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
        textout(x1 + (i - 1) * x + (x div 4), y1 + 50, s1[i]);
      end
      else begin //Визуализируем остальные ячейки
        DrawRectangle(x1 + (i) * x, y1, x1 + (i - 1) * x, y2);
        textout(x1 + (i - 1) * x + (x div 4), y1 + 50, ' ');
      end;
    end;
    i := 2; //Начинаем со второго символа
    cool_3(x,i,s1);
    while s1[i] <> 'B' do //Ищем символ между первым и вторым множителем
    begin
      cool_1(x, i, s1);
      sleep(500);
      i += 1;
    end;
    cool_1(x, i, s1);
    multiply_1(s1, i, x);//Запускаем процедуру
    SetBrushColor(clWhite);
    textout(0, 40, 'Ответ: '); //Выводим ответ
    i := LastPos('A', s1) + 1;
    textout(45, 40, s1[i:]);
  end;
  while true do //Выход в главное меню
  begin
    textout(0, 60, 'Введите 1 чтобы выйти');
    readln(i);
    if i = 1 then break;
  end;
  exit;
end;

var
  vvod: integer;
  s, str: string;

begin
  while true do //Формируем главное меню
  begin
    ClearWindow;
    textout(0, 0, 'МЕНЮ:');
    textout(20, 20, '1: Проверка четности количества единиц');
    textout(20, 40, '2: Правильная скобочная последовательность');  
    textout(20, 60, '3: Унарное умножение');
    textout(20, 80, '4: Выход');
    readln(vvod);
    case vvod of //Возможные варианты
      1: //Четность/нечётность количества единиц в строке
        begin
          ClearWindow; 
          textout(0, 0, 'Введите двоичную последовательность: ');
          readln(s); textout(260, 0, s); chek(s); 
        end;
      2: //Правильная скобочная последовательность
        begin
          ClearWindow; 
          textout(0, 0, 'Введите скобочную последовательность: '); 
          readln(s); textout(265, 0, s); psp(s); 
        end;
      3: //Умножение в унарной системе
        begin
          ClearWindow;
          textout(0, 0, 'Введите первое число в унарной системе: '); readln(s); textout(270, 0, s);
          textout(0, 20, 'Введите второе число в унарной системе: '); readln(str); textout(270, 20, str);
          multiply(s, str);
        end;
      4: CloseWindow; //Выход
    else begin textout(0, 100, 'Некорректный ввод'); sleep(5000); end; //Неверный ввод
    end;
  end;
end.