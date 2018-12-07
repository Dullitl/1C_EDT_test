
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ФР'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпПорт = Элементы.Порт.СписокВыбора;
	Индекс = Неопределено;
	Для Индекс = 1 По 32 Цикл
		СпПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(9600,   "9600 бод");

	времПорт                       = Неопределено;
	времСкорость                   = Неопределено;
	времТаймаут                    = Неопределено;
	времПарольККМ                  = Неопределено;
	времНомерСекции                = Неопределено;
	времКодСимволаЧастичногоОтреза = Неопределено;
	времМодель                     = Неопределено;

	Параметры.Свойство("Порт"                      , времПорт);
	Параметры.Свойство("Скорость"                  , времСкорость);
	Параметры.Свойство("Таймаут"                   , времТаймаут);
	Параметры.Свойство("ПарольККМ"                 , времПарольККМ);
	Параметры.Свойство("НомерСекции"               , времНомерСекции);
	Параметры.Свойство("КодСимволаЧастичногоОтреза", времКодСимволаЧастичногоОтреза);
	Параметры.Свойство("Модель"                    , времМодель);

	Порт                       = ?(времПорт                       = Неопределено,        1, времПорт);
	Скорость                   = ?(времСкорость                   = Неопределено,     9600, времСкорость);
	Таймаут                    = ?(времТаймаут                    = Неопределено,      100, времТаймаут);
	ПарольККМ                  = ?(времПарольККМ                  = Неопределено, "000000", времПарольККМ);
	НомерСекции                = ?(времНомерСекции                = Неопределено,        0, времНомерСекции);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза = Неопределено,       22, времКодСимволаЧастичногоОтреза);
	Модель                     = ?(времМодель                     = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

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

	Параметры.ПараметрыНастройки.Добавить(Порт                      , "Порт");
	Параметры.ПараметрыНастройки.Добавить(Скорость                  , "Скорость");
	Параметры.ПараметрыНастройки.Добавить(Таймаут                   , "Таймаут");
	Параметры.ПараметрыНастройки.Добавить(ПарольККМ                 , "ПарольККМ");
	Параметры.ПараметрыНастройки.Добавить(НомерСекции               , "НомерСекции");
	Параметры.ПараметрыНастройки.Добавить(КодСимволаЧастичногоОтреза, "КодСимволаЧастичногоОтреза");
	Параметры.ПараметрыНастройки.Добавить(Модель                    , "Модель");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста    = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Таймаут"                   , Таймаут);
	времПараметрыУстройства.Вставить("ПарольККМ"                 , ПарольККМ);
	времПараметрыУстройства.Вставить("НомерСекции"               , НомерСекции);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
	                           И ВыходныеПараметры.Количество() >= 2,
	                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
	                           "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
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

///////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Таймаут"                   , Таймаут);
	времПараметрыУстройства.Вставить("ПарольККМ"                 , ПарольККМ);
	времПараметрыУстройства.Вставить("НомерСекции"               , НомерСекции);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);

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

КонецПроцедуры
