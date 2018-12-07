Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю
Перем СоответствиеНаборовДанныхИЗапросов;

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	//ЗначениеПанелипользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(ЭтотОбъект);
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	УправлениеОтчетами.УстановитьЗапросыСКДПоСоответсвию(СхемаКомпоновкиДанных.НаборыДанных, СоответствиеНаборовДанныхИЗапросов);
	Возврат Результат;
		
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

//Процедура ПередВыводомЭлементРезультата(МакетКомпоновки, ПроцессорКомпоновки, ЭлементРезультата) Экспорт
//КонецПроцедуры

//Процедура ПередВыводомОтчета(МакетКомпоновки, ПроцессорКомпоновки) Экспорт
//КонецПроцедуры

//Процедура ПриВыводеЗаголовкаОтчета(ОбластьЗаголовок) Экспорт
//КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("Организация", "ОсновнаяОрганизация");
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	СписокНастроек = Новый СписокЗначений;
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ВыработкаУпрУчет);
	КонецЕсли;	

	СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ВыработкаРеглУчет);
	
	Возврат Новый Структура("ИспользоватьСобытияПриФормированииОтчета,
	|ПриВыводеЗаголовкаОтчета,
	|ПослеВыводаПанелиПользователя,
	|ПослеВыводаПериода,
	|ПослеВыводаПараметра,
	|ПослеВыводаГруппировки,
	|ПослеВыводаОтбора,
	|ДействияПанелиИзменениеФлажкаДопНастроек,
	|ПриПолучениеНастроекПользователя, 
	|ЗаполнитьОтборыПоУмолчанию, 
	|СписокПолейПодстановкиОтборовПоУмолчанию,
	|СписокДоступныхПредопределенныхНастроек,
	|МинимальныйПериодОтчета", 
	ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию, СписокНастроек, "Месяц");
	
КонецФункции

#Если Клиент Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры


Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ТЗ = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	     |	ОсновныеНачисленияОрганизацийПоказатели.Ссылка КАК ВидРасчета,
	     |	ОсновныеНачисленияОрганизацийПоказатели.НомерСтроки
	     |ИЗ
	     |	ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК ОсновныеНачисленияОрганизацийПоказатели
	     |ГДЕ
	     |	ОсновныеНачисленияОрганизацийПоказатели.Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиСхемМотивации.СдельнаяВыработка)
	     |	И (НЕ ОсновныеНачисленияОрганизацийПоказатели.Ссылка.ПометкаУдаления)
	     |
	     |ОБЪЕДИНИТЬ
	     |
	     |ВЫБРАТЬ РАЗЛИЧНЫЕ
	     |	ОсновныеНачисленияОрганизаций.Ссылка,
	     |	NULL
	     |ИЗ
	     |	ПланВидовРасчета.ОсновныеНачисленияОрганизаций КАК ОсновныеНачисленияОрганизаций
	     |ГДЕ
	     |	ОсновныеНачисленияОрганизаций.Ссылка.СпособРасчета = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОплатыТруда.СдельныйЗаработок)
	     |	И (НЕ ОсновныеНачисленияОрганизаций.ПометкаУдаления)
	     |
	     |ОБЪЕДИНИТЬ ВСЕ
	     |
	     |ВЫБРАТЬ РАЗЛИЧНЫЕ
	     |	УправленческиеНачисления.Ссылка,
	     |	NULL
	     |ИЗ
	     |	ПланВидовРасчета.УправленческиеНачисления КАК УправленческиеНачисления
	     |ГДЕ
	     |	УправленческиеНачисления.Ссылка.СпособРасчета = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОплатыТруда.СдельныйЗаработок)
	     |	И (НЕ УправленческиеНачисления.ПометкаУдаления)
	     |
	     |ОБЪЕДИНИТЬ ВСЕ
	     |
	     |ВЫБРАТЬ РАЗЛИЧНЫЕ
	     |	УправленческиеНачисленияПоказатели.Ссылка,
	     |	УправленческиеНачисленияПоказатели.НомерСтроки
	     |ИЗ
	     |	ПланВидовРасчета.УправленческиеНачисления.Показатели КАК УправленческиеНачисленияПоказатели
	     |ГДЕ
	     |	УправленческиеНачисленияПоказатели.Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиСхемМотивации.СдельнаяВыработка)
	     |	И (НЕ УправленческиеНачисленияПоказатели.Ссылка.ПометкаУдаления)";
		 
	Запрос = Новый Запрос(ТЗ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокВидовРасчета = Новый СписокЗначений;
	
	Пока Выборка.Следующий() Цикл
		Если "ИсходныеДанные.Показатель"+Выборка.НомерСтроки = СокрЛП(Выборка.ВидРасчета.ФормулаРасчета) тогда
			СписокВидовРасчета.Добавить(Выборка.ВидРасчета);
		ИначеЕсли Выборка.ВидРасчета.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.СдельныйЗаработок тогда
			СписокВидовРасчета.Добавить(Выборка.ВидРасчета);
		КонецЕсли;
	КонецЦикла;
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидыРасчета", СписокВидовРасчета);
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат;
	Иначе
		НачалоПериода = ?(ПараметрНачалоПериода.Значение <> Неопределено, Дата(ПараметрНачалоПериода.Значение), '00010101');
		КонецПериода  = ?(ПараметрКонецПериода.Значение <> Неопределено, Дата(ПараметрКонецПериода.Значение), '00010101');
		Если НачалоПериода = '00010101'  тогда
			НачалоПериода = НачалоМесяца(ТекущаяДата());
		КонецЕсли;
		Если КонецПериода = '00010101' тогда
			КонецПериода = КонецМесяца(ТекущаяДата());
		КонецЕсли;
		ПараметрКонецПериода.Использование = Истина;
		ПараметрНачалоПериода.Использование = Истина;
		
		ПараметрКонецПериода.Значение  = КонецПериода;
		ПараметрНачалоПериода.Значение = НачалоПериода;
	КонецЕсли;
	
	Если НачалоПериода <> Неопределено и КонецПериода <> Неопределено тогда
		УправлениеОтчетами.ЗаменитьВСКДТекстЗапросКалендаря(СхемаКомпоновкиДанных, НачалоПериода, КонецПериода, СоответствиеНаборовДанныхИЗапросов);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецЕсли

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ФактическаяВыработкаРаботниковОрганизаций,) тогда
	СхемаКомпоновкиДанных.НаборыДанных.ОбъеденениеУчетов.Элементы.РегламентированныйУчет.Запрос = "Выбрать 1 ГДЕ ЛОЖЬ";
КонецЕсли;

Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ФактическаяВыработкаРаботников, ) тогда
	СхемаКомпоновкиДанных.НаборыДанных.ОбъеденениеУчетов.Элементы.УправленчискийУчет.Запрос = "Выбрать 1 ГДЕ ЛОЖЬ";
КонецЕсли;
	
