///////////////////////////////////////////////////////////////////////////////
//// БЛОК НАСТРОЙКИ ПАРАМЕТРОВ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ЭТ'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпCOMПортДО = Элементы.COMПортДО.СписокВыбора;
	Для Индекс = 1 По 32 Цикл
		СпCOMПортДО.Добавить(Индекс, "COM" + Строка(Индекс));
	КонецЦикла;

	СпСкоростьОбменаДО = Элементы.СкоростьОбменаСДО.СписокВыбора;
	СпСкоростьОбменаДО.Добавить(9600,     "9600");
	СпСкоростьОбменаДО.Добавить(19200,   "19200");
	СпСкоростьОбменаДО.Добавить(38400,   "38400");
	СпСкоростьОбменаДО.Добавить(57600,   "57600");
	СпСкоростьОбменаДО.Добавить(115200, "115200");

	СпРазмерДанныхДО = Элементы.РазмерДанныхДО.СписокВыбора;
	СпРазмерДанныхДО.Добавить(4, "4");
	СпРазмерДанныхДО.Добавить(5, "5");
	СпРазмерДанныхДО.Добавить(6, "6");
	СпРазмерДанныхДО.Добавить(7, "7");
	СпРазмерДанныхДО.Добавить(8, "8");

	СпЧетностьДО = Элементы.ЧетностьДО.СписокВыбора;
	СпЧетностьДО.Добавить(0, "None");
	СпЧетностьДО.Добавить(1, "Odd");
	СпЧетностьДО.Добавить(2, "Even");
	СпЧетностьДО.Добавить(3, "Mark");
	СпЧетностьДО.Добавить(4, "Space");

	СпСтопБитыДО = Элементы.СтопБитыДО.СписокВыбора;
	СпСтопБитыДО.Добавить(0, "1 стоп-бит");
	СпСтопБитыДО.Добавить(1, "1,5 стоп-бита");
	СпСтопБитыДО.Добавить(2, "2 стоп-бита");

	СпУправлениеПотокомДО = Элементы.УправлениеПотокомДО.СписокВыбора;
	СпУправлениеПотокомДО.Добавить(0, "Xon/Xoff");
	СпУправлениеПотокомДО.Добавить(1, "Hardware");
	СпУправлениеПотокомДО.Добавить(2, "None");

	СпШиринаСлипЧека = Элементы.ШиринаСлипЧека.СписокВыбора;
	СпШиринаСлипЧека.Добавить(24,  "24 сим");
	СпШиринаСлипЧека.Добавить(32,  "32 сим");
	СпШиринаСлипЧека.Добавить(36,  "36 сим");
	СпШиринаСлипЧека.Добавить(40,  "40 сим");
	СпШиринаСлипЧека.Добавить(48,  "48 сим");

	///////////////////// Считывание значений из параметров /////////////////////////
	//// Авторизационный канал ////
	времАдресСА         = Неопределено;
	времПортСА          = Неопределено;
	времСкриптX25       = Неопределено;
	времТаймаутACK      = Неопределено;
	времТаймаутСА       = Неопределено;
	времЧислоNAK        = Неопределено;
	времРазмерПакета    = Неопределено;
	времТаймаутОперации = Неопределено;

	Параметры.Свойство("АдресСА",         времАдресСА);
	Параметры.Свойство("ПортСА",          времПортСА);
	Параметры.Свойство("СкриптX25",       времСкриптX25);
	Параметры.Свойство("ТаймаутACK",      времТаймаутACK);
	Параметры.Свойство("ТаймаутСА",       времТаймаутСА);
	Параметры.Свойство("ЧислоNAK",        времЧислоNAK);
	Параметры.Свойство("РазмерПакета",    времРазмерПакета);
	Параметры.Свойство("ТаймаутОперации", времТаймаутОперации);

	АдресСА         = ?(времАдресСА          = Неопределено, "127.0.0.1", времАдресСА);
	ПортСА          = ?(времПортСА           = Неопределено,           0, времПортСА);
	СкриптX25       = ?(времСкриптX25        = Неопределено,          "", времСкриптX25);
	ТаймаутACK      = ?(времТаймаутACK       = Неопределено,        5000, времТаймаутACK);
	ТаймаутСА       = ?(времТаймаутСА        = Неопределено,       45000, времТаймаутСА);
	ЧислоNAK        = ?(времЧислоNAK         = Неопределено,           3, времЧислоNAK);
	РазмерПакета    = ?(времРазмерПакета     = Неопределено,        1024, времРазмерПакета);
	ТаймаутОперации = ?(времТаймаутОперации  = Неопределено,          90, времТаймаутОперации);

	//// Канал управления ////
	времАдресКУ                = Неопределено;
	времПортКУ                 = Неопределено;
	времТаймаутКУ              = Неопределено;
	времИдентификаторТерминала = Неопределено;
	времCOMПортДО              = Неопределено;
	времСкоростьОбменаСДО      = Неопределено;
	времРазмерДанныхДО         = Неопределено;
	времЧетностьДО             = Неопределено;
	времСтопБитыДО             = Неопределено;
	времУправлениеПотокомДО    = Неопределено;

	Параметры.Свойство("АдресКУ",                времАдресКУ);
	Параметры.Свойство("ПортКУ",                 времПортКУ);
	Параметры.Свойство("ТаймаутКУ",              времТаймаутКУ);
	Параметры.Свойство("ИдентификаторТерминала", времИдентификаторТерминала);
	Параметры.Свойство("COMПортДО",              времCOMПортДО);
	Параметры.Свойство("СкоростьОбменаСДО",      времСкоростьОбменаСДО);
	Параметры.Свойство("РазмерДанныхДО",         времРазмерДанныхДО);
	Параметры.Свойство("ЧетностьДО",             времЧетностьДО);
	Параметры.Свойство("СтопБитыДО",             времСтопБитыДО);
	Параметры.Свойство("УправлениеПотокомДО",    времУправлениеПотокомДО);

	АдресКУ                = ?(времАдресКУ                = Неопределено, "127.0.0.1", времАдресКУ);
	ПортКУ                 = ?(времПортКУ                 = Неопределено,           0, времПортКУ);
	ТаймаутКУ              = ?(времТаймаутКУ              = Неопределено,       60000, времТаймаутКУ);
	ИдентификаторТерминала = ?(времИдентификаторТерминала = Неопределено,          "", времИдентификаторТерминала);
	COMПортДО              = ?(времCOMПортДО              = Неопределено,           1, времCOMПортДО);
	СкоростьОбменаСДО      = ?(времСкоростьОбменаСДО      = Неопределено,       19200, времСкоростьОбменаСДО);
	РазмерДанныхДО         = ?(времРазмерДанныхДО         = Неопределено,           8, времРазмерДанныхДО);
	ЧетностьДО             = ?(времЧетностьДО             = Неопределено,           0, времЧетностьДО);
	СтопБитыДО             = ?(времСтопБитыДО             = Неопределено,           0, времСтопБитыДО);
	УправлениеПотокомДО    = ?(времУправлениеПотокомДО    = Неопределено,           2, времУправлениеПотокомДО);

	//// Слип-чек ////
	времКодВалюты                  = Неопределено;
	времШиринаСлипЧека             = Неопределено;
	времКоличествоКопийСлипчека    = Неопределено;
	времКодСимволаЧастичногоОтреза = Неопределено;
	времДанныеМакетаСлипЧека       = Неопределено;

	Параметры.Свойство("КодВалюты"                 , времКодВалюты);
	Параметры.Свойство("ШиринаСлипЧека"            , времШиринаСлипЧека);
	Параметры.Свойство("КоличествоКопийСлипчека"   , времКоличествоКопийСлипчека);
	Параметры.Свойство("КодСимволаЧастичногоОтреза", времКодСимволаЧастичногоОтреза);
	Параметры.Свойство("ДанныеМакетаСлипЧека"      , времДанныеМакетаСлипЧека);

	КодВалюты                  = ?(времКодВалюты                  = Неопределено, "643", времКодВалюты);
	ШиринаСлипЧека             = ?(времШиринаСлипЧека             = Неопределено,    36, времШиринаСлипЧека);
	КоличествоКопийСлипчека    = ?(времКоличествоКопийСлипчека    = Неопределено,     2, времКоличествоКопийСлипчека);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза = Неопределено,    22, времКодСимволаЧастичногоОтреза);
	ДанныеМакетаСлипЧека       = времДанныеМакетаСлипЧека;

	ПрочитатьДанныеМакета();

	времМодель         = Неопределено;
	Параметры.Свойство("Модель"        , времМодель);
	Модель         = ?(времМодель         = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

// Процедура - обработчик события "Перед открытием" формы.
//
// Параметры:
//  Отказ                - <Булево>
//                       - Признак отказа от открытия формы. Если в теле
//                         процедуры-обработчика установить данному параметру
//                         значение Истина, открытие формы выполнено не будет.
//                         Значение по умолчанию: Ложь 
//
//  СтандартнаяОбработка - <Булево>
//                       - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события. Если в
//                         теле процедуры-обработчика установить данному
//                         параметру значение Ложь, стандартная обработка
//                         события производиться не будет. Отказ от стандартной
//                         обработки не отменяет открытие формы.
//                         Значение по умолчанию: Истина 
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры // ПередОткрытием()

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	ЗаписатьДанныеМакета();

	Параметры.ПараметрыНастройки.Добавить(АдресСА                   , "АдресСА");
	Параметры.ПараметрыНастройки.Добавить(ПортСА                    , "ПортСА");
	Параметры.ПараметрыНастройки.Добавить(СкриптX25                 , "СкриптX25");
	Параметры.ПараметрыНастройки.Добавить(ТаймаутACK                , "ТаймаутACK");
	Параметры.ПараметрыНастройки.Добавить(ТаймаутСА                 , "ТаймаутСА");
	Параметры.ПараметрыНастройки.Добавить(ЧислоNAK                  , "ЧислоNAK");
	Параметры.ПараметрыНастройки.Добавить(РазмерПакета              , "РазмерПакета");
	Параметры.ПараметрыНастройки.Добавить(ТаймаутОперации           , "ТаймаутОперации");

	Параметры.ПараметрыНастройки.Добавить(АдресКУ                   , "АдресКУ");
	Параметры.ПараметрыНастройки.Добавить(ПортКУ                    , "ПортКУ");
	Параметры.ПараметрыНастройки.Добавить(ТаймаутКУ                 , "ТаймаутКУ");
	Параметры.ПараметрыНастройки.Добавить(ИдентификаторТерминала    , "ИдентификаторТерминала");
	Параметры.ПараметрыНастройки.Добавить(COMПортДО                 , "COMПортДО");
	Параметры.ПараметрыНастройки.Добавить(СкоростьОбменаСДО         , "СкоростьОбменаСДО");
	Параметры.ПараметрыНастройки.Добавить(РазмерДанныхДО            , "РазмерДанныхДО");
	Параметры.ПараметрыНастройки.Добавить(ЧетностьДО                , "ЧетностьДО");
	Параметры.ПараметрыНастройки.Добавить(СтопБитыДО                , "СтопБитыДО");
	Параметры.ПараметрыНастройки.Добавить(УправлениеПотокомДО       , "УправлениеПотокомДО");

	Параметры.ПараметрыНастройки.Добавить(КодВалюты                 , "КодВалюты");
	Параметры.ПараметрыНастройки.Добавить(ШиринаСлипЧека            , "ШиринаСлипЧека");
	Параметры.ПараметрыНастройки.Добавить(КоличествоКопийСлипчека   , "КоличествоКопийСлипчека");
	Параметры.ПараметрыНастройки.Добавить(КодСимволаЧастичногоОтреза, "КодСимволаЧастичногоОтреза");
	Параметры.ПараметрыНастройки.Добавить(ДанныеМакетаСлипЧека      , "ДанныеМакетаСлипЧека");
	Параметры.ПараметрыНастройки.Добавить(Модель                    , "Модель");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("АдресСА"                   , АдресСА);
	времПараметрыУстройства.Вставить("ПортСА"                    , ПортСА);
	времПараметрыУстройства.Вставить("СкриптX25"                 , СкриптX25);
	времПараметрыУстройства.Вставить("ТаймаутACK"                , ТаймаутACK);
	времПараметрыУстройства.Вставить("ТаймаутСА"                 , ТаймаутСА);
	времПараметрыУстройства.Вставить("ЧислоNAK"                  , ЧислоNAK);
	времПараметрыУстройства.Вставить("РазмерПакета"              , РазмерПакета);
	времПараметрыУстройства.Вставить("ТаймаутОперации"           , ТаймаутОперации);

	времПараметрыУстройства.Вставить("АдресКУ"                   , АдресКУ);
	времПараметрыУстройства.Вставить("ПортКУ"                    , ПортКУ);
	времПараметрыУстройства.Вставить("ТаймаутКУ"                 , ТаймаутКУ);
	времПараметрыУстройства.Вставить("ИдентификаторТерминала"    , ИдентификаторТерминала);
	времПараметрыУстройства.Вставить("COMПортДО"                 , COMПортДО);
	времПараметрыУстройства.Вставить("СкоростьОбменаСДО"         , СкоростьОбменаСДО);
	времПараметрыУстройства.Вставить("РазмерДанныхДО"            , РазмерДанныхДО);
	времПараметрыУстройства.Вставить("ЧетностьДО"                , ЧетностьДО);
	времПараметрыУстройства.Вставить("СтопБитыДО"                , СтопБитыДО);
	времПараметрыУстройства.Вставить("УправлениеПотокомДО"       , УправлениеПотокомДО);

	времПараметрыУстройства.Вставить("КодВалюты"                 , КодВалюты);
	времПараметрыУстройства.Вставить("ШиринаСлипЧека"            , ШиринаСлипЧека);
	времПараметрыУстройства.Вставить("КоличествоКопийСлипчека"   , КоличествоКопийСлипчека);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("ДанныеМакетаСлипЧека"      , ДанныеМакетаСлипЧека);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);

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

///////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("АдресСА"                   , АдресСА);
	времПараметрыУстройства.Вставить("ПортСА"                    , ПортСА);
	времПараметрыУстройства.Вставить("СкриптX25"                 , СкриптX25);
	времПараметрыУстройства.Вставить("ТаймаутACK"                , ТаймаутACK);
	времПараметрыУстройства.Вставить("ТаймаутСА"                 , ТаймаутСА);
	времПараметрыУстройства.Вставить("ЧислоNAK"                  , ЧислоNAK);
	времПараметрыУстройства.Вставить("РазмерПакета"              , РазмерПакета);
	времПараметрыУстройства.Вставить("ТаймаутОперации"           , ТаймаутОперации);

	времПараметрыУстройства.Вставить("АдресКУ"                   , АдресКУ);
	времПараметрыУстройства.Вставить("ПортКУ"                    , ПортКУ);
	времПараметрыУстройства.Вставить("ТаймаутКУ"                 , ТаймаутКУ);
	времПараметрыУстройства.Вставить("ИдентификаторТерминала"    , ИдентификаторТерминала);
	времПараметрыУстройства.Вставить("COMПортДО"                 , COMПортДО);
	времПараметрыУстройства.Вставить("СкоростьОбменаСДО"         , СкоростьОбменаСДО);
	времПараметрыУстройства.Вставить("РазмерДанныхДО"            , РазмерДанныхДО);
	времПараметрыУстройства.Вставить("ЧетностьДО"                , ЧетностьДО);
	времПараметрыУстройства.Вставить("СтопБитыДО"                , СтопБитыДО);
	времПараметрыУстройства.Вставить("УправлениеПотокомДО"       , УправлениеПотокомДО);

	времПараметрыУстройства.Вставить("КодВалюты"                 , КодВалюты);
	времПараметрыУстройства.Вставить("ШиринаСлипЧека"            , ШиринаСлипЧека);
	времПараметрыУстройства.Вставить("КоличествоКопийСлипчека"   , КоличествоКопийСлипчека);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("ДанныеМакетаСлипЧека"      , ДанныеМакетаСлипЧека);
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

Процедура ПрочитатьДанныеМакета()

	Если ДанныеМакетаСлипЧека.Количество() = 0 Тогда
		ДанныеМакетаСлипЧека.Добавить("БАНК"   , "Банк");
		ДанныеМакетаСлипЧека.Добавить(""       , "Организация");
		ДанныеМакетаСлипЧека.Добавить(""       , "Город");
		ДанныеМакетаСлипЧека.Добавить(""       , "Адрес");
		ДанныеМакетаСлипЧека.Добавить("ОТДЕЛ1" , "Отдел");
		ДанныеМакетаСлипЧека.Добавить("КАССИР" , "Кассир");
		ДанныеМакетаСлипЧека.Добавить("СПАСИБО", "ТекстПодвала");
	КонецЕсли;

	Банк         = ДанныеМакетаСлипЧека[0].Значение;
	Организация  = ДанныеМакетаСлипЧека[1].Значение;
	Город        = ДанныеМакетаСлипЧека[2].Значение;
	Адрес        = ДанныеМакетаСлипЧека[3].Значение;
	Отдел        = ДанныеМакетаСлипЧека[4].Значение;
	Кассир       = ДанныеМакетаСлипЧека[5].Значение;
	ТекстПодвала = ДанныеМакетаСлипЧека[6].Значение;

КонецПроцедуры

Процедура ЗаписатьДанныеМакета()

	ДанныеМакетаСлипЧека[0].Значение = Банк;
	ДанныеМакетаСлипЧека[1].Значение = Организация;
	ДанныеМакетаСлипЧека[2].Значение = Город;
	ДанныеМакетаСлипЧека[3].Значение = Адрес;
	ДанныеМакетаСлипЧека[4].Значение = Отдел;
	ДанныеМакетаСлипЧека[5].Значение = Кассир;
	ДанныеМакетаСлипЧека[6].Значение = ТекстПодвала;

КонецПроцедуры

