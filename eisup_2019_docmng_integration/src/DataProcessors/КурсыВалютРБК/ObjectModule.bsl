// хранит курсы и кратности валют до загрузки с РБК
// для возможности заполнения вычисляемых полей табличного поля
// при подборе валют
Перем ТаблицаКонСреза Экспорт;

Перем ИмяФайла;

// Выделяет из переданной строки первое значение
 //  до символа "TAB"
 //
 // Параметры: 
 //  ИсходнаяСтрока - Строка - строка для разбора
 //
 // Возвращаемое значение:
 //  подстроку до символа "TAB"
 //
Функция ВыделитьПодСтроку(ИсходнаяСтрока)

	Перем ПодСтрока;
	
    Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз+1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
 
 КонецФункции // ВыделитьПодСтроку()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Производит загрузку курсов и кратностей валют с сайта РБК
//
// Параметры:
//  ИндикаторФормы     - ЭлементыФормы типа Индикатор - для отработки индикатора формы
//  НадписьВалютыФормы - ЭлементыФормы типа Надпись  - Для отработки надписи 
//													   загружаемой валюты
//
Процедура ЗагрузитьКурсыСРБК(ИндикаторФормы = "",НадписьВалютыФормы = "") Экспорт
	
	Перем HTTP;
	#Если Клиент Тогда
	ОтрабатыватьИндикатор = Ложь;
	ОтрабатыватьНадпись   = Ложь;
	Если ТипЗнч(ИндикаторФормы) = Тип("Индикатор") Тогда
		ОтрабатыватьИндикатор = Истина;
	КонецЕсли;	
	Если ТипЗнч(НадписьВалютыФормы) = Тип("Надпись") Тогда
		ОтрабатыватьНадпись = Истина;
	КонецЕсли;	
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();

	Текст = Новый ТекстовыйДокумент();

	СерверИсточник = "cbrates.rbc.ru";
	ОбработкаПолученияФайлов = Обработки.ПолучениеФайловИзИнтернета.Создать();

	Адрес1 = "tsv/cb/";  // в интервале
	Адрес2 = "tsv/";     // по 1 дате
	Если НачДата = КонДата Тогда  // по 1 дате
		Адрес = Адрес2;
		ТМП   = "/"+Формат(Год(КонДата),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");
	Иначе    // в интервале
		Адрес = Адрес1;
		ТМП   = "";
	КонецЕсли;

	ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог,"*.*");
	
	//АБС ВСТАВКА 28126
	СписокПодчиненныхВалют=ПолучитьСписокПодчиненныхВалют(СписокВалют.ВыгрузитьКолонку("Валюта"));
	//\\АБС ВСТАВКА 28126 КОНЕЦ
	
	Для каждого СтрокаСпВалют из СписокВалют Цикл

		ТекВалюта = СтрокаСпВалют.Валюта;
		Стр = "";
		ИмяВходящегоФайла = "" + ВремКаталог + "\" + ИмяФайла;
		
		//Бреев
		Если ТекВалюта.Наименование = "CU" тогда
			ВалютаЗамены = Справочники.Валюты.НайтиПоНаименованию("USD");
			КодЗамены = ?(ЗначениеЗаполнено(ВалютаЗамены), ВалютаЗамены.Код, ТекВалюта.Код);
			СтрокаПараметраПолучения = Адрес + Прав(КодЗамены,3) + ТМП + ".tsv";
		Иначеесли ТекВалюта.Наименование = "UEE" тогда
			ВалютаЗамены = Справочники.Валюты.НайтиПоНаименованию("EUR");
			КодЗамены = ?(ЗначениеЗаполнено(ВалютаЗамены), ВалютаЗамены.Код, ТекВалюта.Код);
			СтрокаПараметраПолучения = Адрес + Прав(КодЗамены,3) + ТМП + ".tsv";
		Иначе
			СтрокаПараметраПолучения = Адрес + Прав(ТекВалюта.Код,3) + ТМП + ".tsv";
		КонецЕсли;
		//Бреев
		
		
		Если ОбработкаПолученияФайлов.ЗапроситьФайлыССервера(СерверИсточник, СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP) <> Истина Тогда
			Сообщить("Не удалось получить ресурс для валюты " + СокрЛП(ТекВалюта.Наименование) + " (код " + ТекВалюта.Код + "). Курс для валюты не загружен."); 
			Продолжить;
		КонецЕсли; 

		ВходящийФайл = Новый Файл(ИмяВходящегоФайла);
		Если НЕ ВходящийФайл.Существует() Тогда
			Сообщить("Не удалось получить ресурс для валюты " + СокрЛП(ТекВалюта.Наименование) + " (код " + ТекВалюта.Код + "). Курс для валюты не загружен."); 
			Продолжить;
		КонецЕсли;	

		Текст.Прочитать(ИмяВходящегоФайла,КодировкаТекста.ANSI);
		
		КолСтрок = Текст.КоличествоСтрок();
		Для Инд = 1 По КолСтрок Цикл
			Если ОтрабатыватьНадпись Тогда
				НадписьВалютыФормы.Заголовок = "" + СокрЛП(ТекВалюта.Наименование);
			КонецЕсли;	

			Если ОтрабатыватьИндикатор Тогда
				ИндикаторФормы.Значение = Инд/КолСтрок * 100;
			КонецЕсли;	
				
			Стр = Текст.ПолучитьСтроку(Инд);
			Если (Стр = "") ИЛИ (Найти(Стр,Символы.Таб) = 0) Тогда
			   Продолжить;
			КонецЕсли;
			Если НачДата = КонДата Тогда  
			   ДатаКурса = КонДата;
			Иначе 
			   ДатаКурсаСтр = ВыделитьПодСтроку(Стр);
			   ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4),Сред(ДатаКурсаСтр,5,2),Сред(ДатаКурсаСтр,7,2));
			КонецЕсли;
			Кратность = Число(ВыделитьПодСтроку(Стр));
			Курс      = Число(ВыделитьПодСтроку(Стр));

			Если ДатаКурса > КонДата Тогда
			   Прервать;
			КонецЕсли;

			Если ДатаКурса < НачДата Тогда 
			   Продолжить;
			КонецЕсли;

            ЗаписьКурсовВалют.Валюта = ТекВалюта;
			ЗаписьКурсовВалют.Период = ДатаКурса;
			ЗаписьКурсовВалют.Прочитать();
			ЗаписьКурсовВалют.Валюта    = ТекВалюта;
			ЗаписьКурсовВалют.Период    = ДатаКурса;
			ЗаписьКурсовВалют.Курс      = Курс;
			ЗаписьКурсовВалют.Кратность = Кратность;
			ЗаписьКурсовВалют.Записать();
			
			//АБС ВСТАВКА 28126  Загрузить подчиненные курсы валют
			Если СписокПодчиненныхВалют.НАйти(ТекВалюта,"БазоваяВалюта")<>Неопределено Тогда
				СтрВалюты=СписокПодчиненныхВалют.НАйти(ТекВалюта,"БазоваяВалюта");
				Если ЗначениеЗаполнено(СтрВалюты.ВалютаРасчета) Тогда
					ЗагрузитьПодчиненнуюВалюту(СтрВалюты.ВалютаРасчета,СтрВалюты.Коэффициент,ДатаКурса,Курс,Кратность);
				КонецЕсли;
			КонецЕсли;
			//\\АБС ВСТАВКА 28126 КОНЕЦ
			
						//АБС Заявка 2868
			Если СокрЛП(ТекВалюта.Код) = "840" Тогда
				УсловныйДоллар = Справочники.Валюты.НайтиПоКоду("36");
				Если ЗначениеЗаполнено(УсловныйДоллар) Тогда
					НоваяЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
					НоваяЗаписьКурсовВалют.Валюта = УсловныйДоллар;
					НоваяЗаписьКурсовВалют.Период = ДатаКурса;
					НоваяЗаписьКурсовВалют.Прочитать();
					НоваяЗаписьКурсовВалют.Валюта    = УсловныйДоллар;
					НоваяЗаписьКурсовВалют.Период    = ДатаКурса;
					НоваяЗаписьКурсовВалют.Курс      = Курс;
					НоваяЗаписьКурсовВалют.Кратность = Кратность;
					НоваяЗаписьКурсовВалют.Записать();

				КонецЕсли;
			ИначеЕсли СокрЛП(ТекВалюта.Код) = "978" Тогда 	
				УсловныйЕвро = Справочники.Валюты.НайтиПоКоду("124");
				Если ЗначениеЗаполнено(УсловныйЕвро) Тогда
					НоваяЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
					НоваяЗаписьКурсовВалют.Валюта = УсловныйЕвро;
					НоваяЗаписьКурсовВалют.Период = ДатаКурса;
					НоваяЗаписьКурсовВалют.Прочитать();
					НоваяЗаписьКурсовВалют.Валюта    = УсловныйЕвро;
					НоваяЗаписьКурсовВалют.Период    = ДатаКурса;
					НоваяЗаписьКурсовВалют.Курс      = Курс;
					НоваяЗаписьКурсовВалют.Кратность = Кратность;
					НоваяЗаписьКурсовВалют.Записать();

				КонецЕсли;

			КонецЕсли;
			
			//АБС Заявка 2868

		КонецЦикла;	   
	КонецЦикла;	
	
	//АБС ВСТАВКА 28126  Загрузить "Руб"  если есть настройка
	Рубль=Справочники.Валюты.НайтиПоКоду("643");
	Если ЗначениеЗаполнено(Рубль) Тогда
		Если СписокПодчиненныхВалют.НАйти(Рубль,"БазоваяВалюта")<>Неопределено Тогда
			СтрВалюты=СписокПодчиненныхВалют.НАйти(Рубль,"БазоваяВалюта");
			Если ЗначениеЗаполнено(СтрВалюты.ВалютаРасчета) Тогда
				Состояние("Расчет подчиненных валют по базовой валюте РУБЛЬ...");
				ЗагрузитьПодчиненнуюВалюту(СтрВалюты.ВалютаРасчета,СтрВалюты.Коэффициент,СтрВалюты.Период,1,1);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//\\АБС ВСТАВКА 28126 КОНЕЦ
	
	УдалитьФайлы(ВремКаталог,"*.*");
#КонецЕсли
КонецПроцедуры // ЗагрузитьКурсыСРБК()


Процедура ЗаполнитьВалюты(ЗаполнятьТолькоВалютамиБезАктуальныхКурсов = Ложь) Экспорт
	
	СписокВалют.Очистить();
	СправочникВалюты = Справочники.Валюты;
	ВыборкаВалют = СправочникВалюты.Выбрать();
	МакетОКВ = Справочники.Валюты.ПолучитьМакет("КлассификаторВалют");
	ОбластьКоды = МакетОКВ.Область("КодЧисловой");
	мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
	
	Пока ВыборкаВалют.Следующий() Цикл
		ТекущаяВалюта = ВыборкаВалют.Ссылка;
		КодТекущейВалюты = СокрЛП(ТекущаяВалюта.Код);
		НайденнаяОбласть = МакетОКВ.НайтиТекст(КодТекущейВалюты,,ОбластьКоды);
		
		Если НайденнаяОбласть = Неопределено ИЛИ НайденнаяОбласть.Верх=2 Тогда
			//Бреев
			Если ТекущаяВалюта<>Справочники.Валюты.НайтиПоНаименованию("CU",истина)
				И  ТекущаяВалюта<>Справочники.Валюты.НайтиПоНаименованию("UEE",истина) тогда  
				Продолжить;
			КонецЕсли;
			//Бреев
		КонецЕсли;	
		
		Если ТекущаяВалюта = мВалютаРегламентированногоУчета Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗаполнятьТолькоВалютамиБезАктуальныхКурсов Тогда
			ЗаписьКурсовВалют.Валюта = ТекущаяВалюта;
			ЗаписьКурсовВалют.Период = ?(НЕ ЗначениеЗаполнено(КонДата), ТекущаяДата(), КонДата);
			ЗаписьКурсовВалют.Прочитать();
			Если ЗаписьКурсовВалют.Выбран() Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаСпискаВалют = СписокВалют.Добавить();
		СтрокаСпискаВалют.Валюта = ТекущаяВалюта;
	КонецЦикла;	
	
КонецПроцедуры // () 

Процедура УстановитьПериодЗагрузки() Экспорт

	ТаблицаКонСреза = Новый ТаблицаЗначений;
	РегВалют = РегистрыСведений.КурсыВалют;
	ТаблицаКонСреза = РегВалют.СрезПоследних();
	
	НачДата = НачалоМесяца(ТекущаяДата());
	КонДата = КонецМесяца(ТекущаяДата());
	
	МаксДата = Дата('00010101');
	Для Каждого стрСреза Из ТаблицаКонСреза Цикл
		МаксДата = Макс(МаксДата, стрСреза.Период);
	КонецЦикла;
	
	НачалоПрошлогоМесяца = ДобавитьМесяц(НачДата, -1);
	Если (МаксДата>=НачалоПрошлогоМесяца) И (МаксДата<НачДата) Тогда
		НачДата = МаксДата;
	КонецЕсли;

КонецПроцедуры // УстановитьПериодЗагрузки()

//АБС ВСТАВКА 28126
Функция ПолучитьСписокПодчиненныхВалют(ВалютыДляАнализа) Экспорт
	 	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	абс_ВалютыСКоэффициентамиПерерасчетаСрезПоследних.БазоваяВалюта КАК БазоваяВалюта,
		|	абс_ВалютыСКоэффициентамиПерерасчетаСрезПоследних.ВалютаРасчета КАК ВалютаРасчета,
		|	ЕСТЬNULL(абс_ВалютыСКоэффициентамиПерерасчетаСрезПоследних.Коэффициент, 0) КАК Коэффициент,
		|	абс_ВалютыСКоэффициентамиПерерасчетаСрезПоследних.Период
		|ИЗ
		|	РегистрСведений.абс_ВалютыСКоэффициентамиПерерасчета.СрезПоследних(&Период, ) КАК абс_ВалютыСКоэффициентамиПерерасчетаСрезПоследних";

	Запрос.УстановитьПараметр("Период", КонецДня(КонДата));
	//Запрос.УстановитьПараметр("СписокВалют", ВалютыДляАнализа);

	Результат = Запрос.Выполнить();

	Возврат Результат.Выгрузить();

	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

КонецФункции

Процедура ЗагрузитьПодчиненнуюВалюту(ВалютаРасчета,Коэффициент,ДатаКурса,Курс,Кратность) Экспорт
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	
	НоваяЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
	НоваяЗаписьКурсовВалют.Валюта = ВалютаРасчета;
	НоваяЗаписьКурсовВалют.Период = ДатаКурса;
	НоваяЗаписьКурсовВалют.Прочитать();
	НоваяЗаписьКурсовВалют.Валюта    = ВалютаРасчета;
	НоваяЗаписьКурсовВалют.Период    = ДатаКурса;
	НоваяЗаписьКурсовВалют.Курс      = Курс * (1  + Коэффициент*0.01);
	НоваяЗаписьКурсовВалют.Кратность = Кратность;
	НоваяЗаписьКурсовВалют.Записать();
	
КонецПроцедуры

//\\АБС ВСТАВКА 28126 КОНЕЦ

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ИмяФайла = "Curses.txt";  

