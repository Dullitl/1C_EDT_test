  
  &НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
 
	//СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");            
	
	СхемаКомпоновкиДанных = Документы.КонтролируемаяСделка.ПолучитьМакет("Макет");	
	
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если  КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		ЭлементОтбораДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Контрагент");
		ЭлементОтбораДанных.ПравоеЗначение = Справочники.Контрагенты.ПустаяСсылка();
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование  = Ложь;
		
		ЭлементОтбораДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДоговорКонтрагента");
		ЭлементОтбораДанных.ПравоеЗначение = Справочники.Контрагенты.ПустаяСсылка();
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование  = Ложь;
		
		ЭлементОтбораДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Стоимость");
		ЭлементОтбораДанных.ПравоеЗначение = Справочники.Контрагенты.ПустаяСсылка();
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование  = Ложь;
		
		ЭлементОтбораДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Количество");
		ЭлементОтбораДанных.ПравоеЗначение = Справочники.Контрагенты.ПустаяСсылка();
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование  = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗагрузитьНастройкиОтбораПоУмолчанию();
	ДокументСделка = Параметры.ДокументСделка;
	
	Для Каждого Стр  Из Параметры.ПараметрыОтбора Цикл
		ЭлементОтбораДанных = КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(СтрЗаменить(Стр.ЛевоеЗначение,"Объект.Сделки.",""));
		ЭлементОтбораДанных.ПравоеЗначение = Стр.ПравоеЗначение;
		ЭлементОтбораДанных.ВидСравнения   = ПолучитьВидСравнения(Стр.ВидСравнения);
		ЭлементОтбораДанных.Использование  = Стр.Использование;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекущиеСтрокиПослеОтбора()

	СхемаКомпоновкиДанных =  ДокументСделка.ПолучитьОбъект().ПолучитьМакет("Макет");
	
	//СхемаКомпоновкиДанных = Документы.КонтролируемаяСделка.ПолучитьМакет("Макет");	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных =  КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки();
	НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы[0].Значение = ДокументСделка;	
			
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос);
	
	Запрос.Параметры.Вставить("Ссылка", ДокументСделка);
	
	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ПолучитьВидСравнения(ВидСравнения)
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеРавно 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеВИерархии 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеВСписке 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.Больше 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.БольшеИлиРавно 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.ВИерархии 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.ВСписке 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.Содержит 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеСодержит 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.Меньше 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.НеЗаполнено 	
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
		ВидСравнения    = ВидСравненияКомпоновкиДанных.Заполнено 	
	КонецЕсли;
	
	возврат  ВидСравнения;
КонецФункции

&НаКлиенте
Процедура УстановитьОтбор(Команда)
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ВидСравнения");
	ТЗ.Колонки.Добавить("ЛевоеЗначение");
	ТЗ.Колонки.Добавить("ПравоеЗначение");
	ТЗ.Колонки.Добавить("Использование");

	
	Для каждого Стр Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы Цикл
		//Если Стр.Использование Тогда
			НоваяСтрока = ТЗ.Добавить();

			НоваяСтрока.ВидСравнения    =  ПолучитьВидСравнения(Стр.ВидСравнения); 	
			НоваяСтрока.ЛевоеЗначение   =  Стр.ЛевоеЗначение;
			НоваяСтрока.ПравоеЗначение  =  Стр.ПравоеЗначение;
			НоваяСтрока.Использование   =  Стр.Использование;
		//КонецЕсли;	
	КонецЦикла;	
	

	ТекущиеСтрокиПослеОтбора = ПолучитьТекущиеСтрокиПослеОтбора();
	ПараметрыОтбора = Новый Структура("ТЗ,ТекущиеСтрокиПослеОтбора",ТЗ,ТекущиеСтрокиПослеОтбора);
	
	Закрыть();
	Оповестить("УстановкаОтбора",ПараметрыОтбора,ЭтаФорма);
КонецПроцедуры
