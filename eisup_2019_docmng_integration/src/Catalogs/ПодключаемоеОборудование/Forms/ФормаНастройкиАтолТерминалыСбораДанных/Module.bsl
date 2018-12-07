
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ТСД'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпМодель = Элементы.Модель.СписокВыбора;
	СпМодель.Добавить("0", "Zebex PDL-20");
	СпМодель.Добавить("00", "Zebex PDC-10");
	СпМодель.Добавить("000", "Zebex PDL-10");
	СпМодель.Добавить("0000", "Zebex PDW-10");
	СпМодель.Добавить("00000", "Zebex PDM-10");
	СпМодель.Добавить("000000", "Zebex PDT-10");
	СпМодель.Добавить("1", "Zebex Z-1050 (""АТОЛ технологии"")");
	СпМодель.Добавить("3", "Cipher CPT-711 (соединение с ПК через кабель)");
	СпМодель.Добавить("03", "Cipher CPT-720 (соединение с ПК через кабель)");
	СпМодель.Добавить("003", "Cipher CPT-8300 (соединение с ПК через кабель)");
	СпМодель.Добавить("4", "Cipher CPT-800х (соединение с ПК через IR подставку)");
	СпМодель.Добавить("04", "Cipher CPT-8300 (соединение с ПК через IR подставку)");
	СпМодель.Добавить("5", "Cipher CPT-3510 для серии CPT-8x1x");
	СпМодель.Добавить("6", "Zebex Z-2030");
	СпМодель.Добавить("7", "Терминалы с ОС WinCE/PocketPC/Windows Mobile и установленным ПО АТОЛ: Mobile Logistics");
	СпМодель.Добавить("07", "Терминалы Symbol SPT-1800 с установленным ПО АТОЛ:Mobile Logistics");
	СпМодель.Добавить("007", "Терминалы Symbol SPT-1550 с установленным ПО АТОЛ:Mobile Logistics");
	СпМодель.Добавить("8", "Cipher CPT-8x00 (соединение с ПК через подставку)");
	СпМодель.Добавить("9", "Casio DT-900/DT-930");
	СпМодель.Добавить("09", "Cipher CPT-800x/8300 (соединение с ПК через провод)");
	СпМодель.Добавить("10", "MobileLogistics 4.x");

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(1,     "300 бод");
	СпСкорость.Добавить(2,     "600 бод");
	СпСкорость.Добавить(3,    "1200 бод");
	СпСкорость.Добавить(4,    "2400 бод");
	СпСкорость.Добавить(5,    "4800 бод");
	СпСкорость.Добавить(7,    "9600 бод");
	СпСкорость.Добавить(10,  "19200 бод");
	СпСкорость.Добавить(12,  "38400 бод");
	СпСкорость.Добавить(14,  "57600 бод");
	СпСкорость.Добавить(18, "115200 бод");

	СпЧетность = Элементы.Четность.СписокВыбора;
	СпЧетность.Добавить(0, "Нет");
	СпЧетность.Добавить(1, "Нечетность");
	СпЧетность.Добавить(2, "Четность");
	СпЧетность.Добавить(3, "Установлен");
	СпЧетность.Добавить(4, "Сброшен");

	СпБитыДанных = Элементы.БитыДанных.СписокВыбора;
	СпБитыДанных.Добавить(3, "7 бит");
	СпБитыДанных.Добавить(4, "8 бит");

	СпСтопБиты = Элементы.СтопБиты.СписокВыбора;
	СпСтопБиты.Добавить(0, "1 бит");
	СпСтопБиты.Добавить(2, "2 бита");

	времПорт            = Неопределено;
	времСкорость        = Неопределено;
	времIPПорт          = Неопределено;
	времЧетность        = Неопределено;
	времБитыДанных      = Неопределено;
	времСтопБиты        = Неопределено;
	времТаблицаВыгрузки = Неопределено;
	времТаблицаЗагрузки = Неопределено;
	времРазделитель     = Неопределено;
	времФорматВыгрузки  = Неопределено;
	времФорматЗагрузки  = Неопределено;
	времМодель          = Неопределено;
	времНаименование    = Неопределено;

	Параметры.Свойство("Порт"           , времПорт);
	Параметры.Свойство("Скорость"       , времСкорость);
	Параметры.Свойство("IPПорт"         , времIPПорт);
	Параметры.Свойство("Четность"       , времЧетность);
	Параметры.Свойство("БитыДанных"     , времБитыДанных);
	Параметры.Свойство("СтопБиты"       , времСтопБиты);
	Параметры.Свойство("ТаблицаВыгрузки", времТаблицаВыгрузки);
	Параметры.Свойство("ТаблицаЗагрузки", времТаблицаЗагрузки);
	Параметры.Свойство("Разделитель"    , времРазделитель);
	Параметры.Свойство("ФорматВыгрузки" , времФорматВыгрузки);
	Параметры.Свойство("ФорматЗагрузки" , времФорматЗагрузки);
	Параметры.Свойство("Модель"         , времМодель);
	Параметры.Свойство("Наименование"   , времНаименование);

	Порт            = ?(времПорт            = Неопределено, 1, времПорт);
	Скорость        = ?(времСкорость        = Неопределено, 7, времСкорость);
	IPПорт          = ?(времIPПорт          = Неопределено, 0, времIPПорт);
	Четность        = ?(времЧетность        = Неопределено, 0, времЧетность);
	БитыДанных      = ?(времБитыДанных      = Неопределено, 4, времБитыДанных);
	СтопБиты        = ?(времСтопБиты        = Неопределено, 0, времСтопБиты);
	ТаблицаВыгрузки = ?(времТаблицаВыгрузки = Неопределено, 0, времТаблицаВыгрузки);
	ТаблицаЗагрузки = ?(времТаблицаЗагрузки = Неопределено, 0, времТаблицаЗагрузки);
	Разделитель     = ?(времРазделитель     = Неопределено, 0, времРазделитель);

	Если времФорматВыгрузки <> Неопределено Тогда
		Для Каждого СтрокаБазы Из времФорматВыгрузки Цикл
			СтрокаТаблицы = ФорматВыгрузки.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаБазы.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаБазы.Наименование;
		КонецЦикла;
	КонецЕсли;

	Если времФорматЗагрузки <> Неопределено Тогда
		Для Каждого СтрокаДокумента Из времФорматЗагрузки Цикл
			СтрокаТаблицы = ФорматЗагрузки.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаДокумента.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаДокумента.Наименование;
		КонецЦикла;
	КонецЕсли;

	Модель       = ?(времМодель       = Неопределено, Элементы.Модель.СписокВыбора[0].Значение     , времМодель);
	Наименование = ?(времНаименование = Неопределено, Элементы.Модель.СписокВыбора[0].Представление, времНаименование);

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	ОбновитьДоступныеПорты();

КонецПроцедуры

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	Параметры.ПараметрыНастройки.Добавить(Порт           , "Порт");
	Параметры.ПараметрыНастройки.Добавить(Скорость       , "Скорость");
	Параметры.ПараметрыНастройки.Добавить(IPПорт         , "IPПорт");
	Параметры.ПараметрыНастройки.Добавить(Четность       , "Четность");
	Параметры.ПараметрыНастройки.Добавить(БитыДанных     , "БитыДанных");
	Параметры.ПараметрыНастройки.Добавить(СтопБиты       , "СтопБиты");
	Параметры.ПараметрыНастройки.Добавить(ТаблицаВыгрузки, "ТаблицаВыгрузки");
	Параметры.ПараметрыНастройки.Добавить(ТаблицаЗагрузки, "ТаблицаЗагрузки");
	Параметры.ПараметрыНастройки.Добавить(Разделитель    , "Разделитель");
	Параметры.ПараметрыНастройки.Добавить(Модель         , "Модель");
	Параметры.ПараметрыНастройки.Добавить(Наименование   , "Наименование");

	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	Параметры.ПараметрыНастройки.Добавить(времФорматВыгрузки, "ФорматВыгрузки");

	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	Параметры.ПараметрыНастройки.Добавить(времФорматЗагрузки, "ФорматЗагрузки");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("IPПорт"         , IPПорт);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("ТаблицаВыгрузки", ТаблицаВыгрузки);
	времПараметрыУстройства.Вставить("ТаблицаЗагрузки", ТаблицаЗагрузки);
	времПараметрыУстройства.Вставить("Разделитель"    , Разделитель);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);

	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматВыгрузки", времФорматВыгрузки);

	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматЗагрузки", времФорматЗагрузки);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		                           "");


		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

&НаКлиенте
Процедура МодельПриИзменении(Элемент)

	ОбновитьДоступныеПорты();

КонецПроцедуры


&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("IPПорт"         , IPПорт);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("ТаблицаВыгрузки", ТаблицаВыгрузки);
	времПараметрыУстройства.Вставить("ТаблицаЗагрузки", ТаблицаЗагрузки);
	времПараметрыУстройства.Вставить("Разделитель"    , Разделитель);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);

	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматВыгрузки", времФорматВыгрузки);

	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматЗагрузки", времФорматЗагрузки);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

&НаКлиенте
Процедура РазделительПриИзменении(Элемент)

	СимволРазделителя = Символ(Разделитель);

КонецПроцедуры

&НаКлиенте
Процедура СимволРазделителяПриИзменении(Элемент)

	Разделитель = КодСимвола(СимволРазделителя);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступныеПорты()

	Элементы.Порт.СписокВыбора.Очистить();
	СпПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 32 Цикл
		СпПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;

	Если Число(Модель) = 7 Тогда
		СпПорт.Добавить(65,  "USB");
		СпПорт.Добавить(101, "TCP/IP");
		СпПорт.Добавить(102, "IRComm (клиент)");
	ИначеЕсли Число(Модель) = 9 Тогда
		СпПорт.Добавить(103, "IRComm (сервер)");
	ИначеЕсли Число(Модель) = 10 Тогда
		СпПорт.Добавить(65,  "USB");
		СпПорт.Добавить(101, "TCP/IP");
		СпПорт.Добавить(102, "IRComm (клиент)");
		СпПорт.Добавить(103, "IRComm (сервер)");
	КонецЕсли;

	Если СпПорт.НайтиПоЗначению(Порт) = Неопределено Тогда
		Порт = 1;
	КонецЕсли;

КонецПроцедуры;
