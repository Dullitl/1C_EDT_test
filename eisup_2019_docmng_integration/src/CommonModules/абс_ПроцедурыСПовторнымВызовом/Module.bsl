Функция ПолучитьЭтапыМэппингаПоИннКппДляТекущейБазы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос  = Новый запрос;
	
	ЗАпрос.Текст = "ВЫБРАТЬ
	               |	Организации.ИНН,
	               |	Организации.КПП,
	               |	Организации.Ссылка
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |ГДЕ
	               |	Организации.ПометкаУдаления = ЛОЖЬ";
	ТЗИННиКПП = Запрос.Выполнить().Выгрузить();
	
	МаксимальныйЭтап = 0;
	
	
	абс_ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
    МакетМэппинга = абс_ОбработчикWebService.ПОлучитьМакет("абс_МэппингКонтрагентов");
	
	ВысотаМакета = Мин(МакетМэппинга.ВысотаТаблицы,500);
	
	Для Итер = 2 по ВысотаМакета  Цикл
		
		ТекИНН = СокрЛП(МакетМэппинга.ПолучитьОбласть(Итер,1,Итер,1).ТекущаяОбласть.Текст);
		ТекКПП = СокрЛП(МакетМэппинга.ПолучитьОбласть(Итер,2,Итер,2).ТекущаяОбласть.Текст);
		
		ТекЭтап = СокрЛП(МакетМэппинга.ПолучитьОбласть(Итер,3,Итер,3).ТекущаяОбласть.Текст);
				
		
		Если ТекИНН = "" или ТекКПП = "" ТОгда
			ПРодолжить;	
		КонецЕсли;   
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Инн",ТекИнн);
		СтруктураОтбора.Вставить("Кпп",ТекКПП);
		НашлиСТроки = ТЗИННиКПП.НайтиСтроки(СтруктураОтбора);	
		
		Если НашлиСТроки.Количество()<>0 ТОгда
			МаксимальныйЭтап = Макс(МаксимальныйЭтап,Число(ТекЭтап));	
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат МаксимальныйЭтап;
КонецФункции
Функция  ПолучитьТекущегоПользователя() Экспорт
	Возврат глЗначениеПеременной("глТекущийПользователь");
КонецФункции
Функция ПолучитьОбработкуWebСервисСПовторнымВызовом()  Экспорт
	Возврат абс_WebService.ПолучитьОбработчикWebService();	
КонецФункции


Функция ПолучитьНастройкиПодключенияКSQLКОнтрагентам()  Экспорт
	//ТекАбс_WebService = абс_WebService.ПолучитьОбработчикWebService();
	//Запрос  = Новый запрос;
	//
	//ЗАпрос.Текст = "ВЫБРАТЬ
	//			   |	Организации.ИНН,
	//			   |	Организации.КПП,
	//			   |	Организации.Ссылка
	//			   |ИЗ
	//			   |	Справочник.Организации КАК Организации
	//			   |ГДЕ
	//			   |	Организации.ПометкаУдаления = ЛОЖЬ";
	//ТЗИННиКПП = Запрос.Выполнить().Выгрузить();
	//
	//
	//НастройкиПодключения = ТекАбс_WebService.ПолучитьМакет("НастройкиПодключения");		
	//
	//ВысотаМакета = Мин(НастройкиПодключения.ВысотаТаблицы,500);
	//
	//Для Итер = 2 по ВысотаМакета  Цикл
	//	
	//	ТекИНН 					= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,1,Итер,1).ТекущаяОбласть.Текст);
	//	ТекКПП 					= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,2,Итер,2).ТекущаяОбласть.Текст);
	//	
	//	ИмяСервераSQL 			= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,3,Итер,3).ТекущаяОбласть.Текст);
	//	ИмяБазыДанныхSQL 		= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,4,Итер,4).ТекущаяОбласть.Текст);
	//	ИмяПользователя 		= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,5,Итер,5).ТекущаяОбласть.Текст);
	//	Пароль 					= СокрЛП(НастройкиПодключения.ПолучитьОбласть(Итер,6,Итер,6).ТекущаяОбласть.Текст);
	//			
	//	
	//	Если ТекИНН = "" или ТекКПП = "" ТОгда
	//		ПРодолжить;	
	//	КонецЕсли;   
	//	
	//	СтруктураОтбора = Новый Структура;
	//	СтруктураОтбора.Вставить("Инн",ТекИнн);
	//	СтруктураОтбора.Вставить("Кпп",ТекКПП);
	//	НашлиСТроки = ТЗИННиКПП.НайтиСтроки(СтруктураОтбора);	
	//	
	//	Если НашлиСТроки.Количество()<>0 ТОгда
	//		СтруктураПодключения =  Новый Структура("Provider,DataSource,UserID,Password");
	//		СтруктураПодключения.Вставить("Provider",		СокрЛП(ИмяСервераSQL));	
	//		СтруктураПодключения.Вставить("DataSource",		СокрЛП(ИмяБазыДанныхSQL));	
	//		СтруктураПодключения.Вставить("UserID",			СокрЛП(ИмяПользователя));	
	//		СтруктураПодключения.Вставить("Password",		СокрЛП(Пароль));
	//		Возврат СтруктураПодключения;
	//		Прервать;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	СтруктураПодключения = Новый Структура;
	Нашли = Справочники.абс_НастройкиОбменаСSQL.НайтиПоРеквизиту("ТипОбъекта","СправочникСсылка.Контрагенты");
	Если Не Нашли.Пустая() ТОгда
		СтруктураПодключения =  Новый Структура("Provider,DataSource,UserID,Password");
		СтруктураПодключения.Вставить("Provider",		СокрЛП(Нашли.ИмяСервераSQL));	
		СтруктураПодключения.Вставить("DataSource",		СокрЛП(Нашли.ИмяБазыДанныхSQL));	
		СтруктураПодключения.Вставить("UserID",			СокрЛП(Нашли.ИмяПользователя));	
		СтруктураПодключения.Вставить("Password",		СокрЛП(Нашли.Пароль));
	КонецЕсли;
	
	
	Возврат   СтруктураПодключения;
КонецФункции

//абс_Попов
Функция ПолучитьТаблицуПроверкиНоменклатурыИзМакета() Экспорт
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(70);

		ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);

		Макет = ПолучитьОбщийМакет("абс_МетаданныеНоменклатура");
		Область = Макет.ПолучитьОбласть("ОблатьДокументовСНоменклатурой");
		ТаблицаПроверкиНоменклатуры =  Новый ТаблицаЗначений;
		ТаблицаПроверкиНоменклатуры.Колонки.Добавить("ИмяДокумента",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатуры.Колонки.Добавить("ИмяТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатуры.Колонки.Добавить("ИмяРеквизитаТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатуры.Колонки.Добавить("ИмяРеквизитаШапки",ОписаниеТиповС);
		НайденаПустаяСтрока = Ложь;
		ТекСтрока = 5;
		Пока Не НайденаПустаяСтрока Цикл
			
			ИмяДокументаМакет		= Область.ПолучитьОбласть(ТекСтрока,1,ТекСтрока,1).ТекущаяОбласть.Текст;
			ИмяТабЧасти 			= Область.ПолучитьОбласть(ТекСтрока,2,ТекСтрока,2).ТекущаяОбласть.Текст;
			ИмяРеквизитаТабЧасти 	=  Область.ПолучитьОбласть(ТекСтрока,3,ТекСтрока,3).ТекущаяОбласть.Текст;
			ИмяРеквизитаШапки 		=  Область.ПолучитьОбласть(ТекСтрока,4,ТекСтрока,4).ТекущаяОбласть.Текст;	
			Если СокрЛП(ИмяДокументаМакет) = "" Тогда
				НайденаПустаяСтрока = Истина;
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы = ТаблицаПроверкиНоменклатуры.Добавить();
			СтрокаТаблицы.ИмяДокумента = ИмяДокументаМакет;
			СтрокаТаблицы.ИмяТабЧасти  = ИмяТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаТабЧасти = ИмяРеквизитаТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаШапки = ИмяРеквизитаШапки;
			ТекСтрока = ТекСтрока+1;
		КонецЦикла;
		Возврат ТаблицаПроверкиНоменклатуры;
КонецФункции
	
Функция ПолучитьТаблицуПроверкиНоменклатурнойГруппыИзМакета() Экспорт
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(70);

		ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);

		Макет = ПолучитьОбщийМакет("абс_МетаданныеНоменклатурныеГруппы");
		Область = Макет.ПолучитьОбласть("ОблатьДокументовСНоменклатурнымиГруппами");
		ТаблицаПроверкиНоменклатурныойГруппы =  Новый ТаблицаЗначений;
		ТаблицаПроверкиНоменклатурныойГруппы.Колонки.Добавить("ИмяДокумента",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатурныойГруппы.Колонки.Добавить("ИмяТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатурныойГруппы.Колонки.Добавить("ИмяРеквизитаТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиНоменклатурныойГруппы.Колонки.Добавить("ИмяРеквизитаШапки",ОписаниеТиповС);
		НайденаПустаяСтрока = Ложь;
		ТекСтрока = 5;
		Пока Не НайденаПустаяСтрока Цикл
			
			ИмяДокументаМакет		= Область.ПолучитьОбласть(ТекСтрока,1,ТекСтрока,1).ТекущаяОбласть.Текст;
			ИмяТабЧасти 			= Область.ПолучитьОбласть(ТекСтрока,2,ТекСтрока,2).ТекущаяОбласть.Текст;
			ИмяРеквизитаТабЧасти 	=  Область.ПолучитьОбласть(ТекСтрока,3,ТекСтрока,3).ТекущаяОбласть.Текст;
			ИмяРеквизитаШапки 		=  Область.ПолучитьОбласть(ТекСтрока,4,ТекСтрока,4).ТекущаяОбласть.Текст;	
			Если СокрЛП(ИмяДокументаМакет) = "" Тогда
				НайденаПустаяСтрока = Истина;
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы = ТаблицаПроверкиНоменклатурныойГруппы.Добавить();
			СтрокаТаблицы.ИмяДокумента = ИмяДокументаМакет;
			СтрокаТаблицы.ИмяТабЧасти  = ИмяТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаТабЧасти = ИмяРеквизитаТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаШапки = ИмяРеквизитаШапки;
			ТекСтрока = ТекСтрока+1;
		КонецЦикла;
		Возврат ТаблицаПроверкиНоменклатурныойГруппы;
		
КонецФункции
	
Функция ПолучитьТаблицуПроверкиСтатьиЗатратИзМакета() Экспорт
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(70);

		ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);

		Макет = ПолучитьОбщийМакет("абс_МетаданныеСтатьиЗатрат");
		Область = Макет.ПолучитьОбласть("ОблатьДокументов");
		ТаблицаПроверкиСтатьиЗатрат =  Новый ТаблицаЗначений;
		ТаблицаПроверкиСтатьиЗатрат.Колонки.Добавить("ИмяДокумента",ОписаниеТиповС);
		ТаблицаПроверкиСтатьиЗатрат.Колонки.Добавить("ИмяТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиСтатьиЗатрат.Колонки.Добавить("ИмяРеквизитаТабЧасти",ОписаниеТиповС);
		ТаблицаПроверкиСтатьиЗатрат.Колонки.Добавить("ИмяРеквизитаШапки",ОписаниеТиповС);
		НайденаПустаяСтрока = Ложь;
		ТекСтрока = 5;
		Пока Не НайденаПустаяСтрока Цикл
			
			ИмяДокументаМакет		= Область.ПолучитьОбласть(ТекСтрока,1,ТекСтрока,1).ТекущаяОбласть.Текст;
			ИмяТабЧасти 			= Область.ПолучитьОбласть(ТекСтрока,2,ТекСтрока,2).ТекущаяОбласть.Текст;
			ИмяРеквизитаТабЧасти 	=  Область.ПолучитьОбласть(ТекСтрока,3,ТекСтрока,3).ТекущаяОбласть.Текст;
			ИмяРеквизитаШапки 		=  Область.ПолучитьОбласть(ТекСтрока,4,ТекСтрока,4).ТекущаяОбласть.Текст;	
			Если СокрЛП(ИмяДокументаМакет) = "" Тогда
				НайденаПустаяСтрока = Истина;
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы = ТаблицаПроверкиСтатьиЗатрат.Добавить();
			СтрокаТаблицы.ИмяДокумента = ИмяДокументаМакет;
			СтрокаТаблицы.ИмяТабЧасти  = ИмяТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаТабЧасти = ИмяРеквизитаТабЧасти;
			СтрокаТаблицы.ИмяРеквизитаШапки = ИмяРеквизитаШапки;
			ТекСтрока = ТекСтрока+1;
		КонецЦикла;
		Возврат ТаблицаПроверкиСтатьиЗатрат;
		
КонецФункции
	
// АБС Фролов
Функция ПолучитьМассивТиповППД() Экспорт
	
	МассивТиповППД = Новый Массив();
	
	МассивТиповППД.Добавить(Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ТребованиеНакладная")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ПередачаТоваров")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ВозвратПереданныхТоваров")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ПеремещениеТоваров")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.КомплектацияНоменклатуры")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.АвансовыйОтчет")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.СписаниеТоваров")); 
	МассивТиповППД.Добавить(Тип("ДокументСсылка.ПолучениеУслугПоПереработке"));
	
	Возврат МассивТиповППД;
	
КонецФункции

Функция ПолучитьСтруктуруСчетовВзаиморасчетов() Экспорт
	
	Стр = Новый Структура;
	
	Стр.Вставить("РасчетыПоПриобретениюРуб"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.01"));
	Стр.Вставить("АвансыПоПриобретениюРуб"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.02"));
	
	Стр.Вставить("РасчетыПоПриобретениюВал"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.21"));
	Стр.Вставить("АвансыПоПриобретениюВал"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.22"));
	
	Стр.Вставить("РасчетыПоПриобретениюУЕ"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.31"));
	Стр.Вставить("АвансыПоПриобретениюУЕ"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.32"));
	
	
	Стр.Вставить("РасчетыПоРеализацииРуб"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.01"));
	Стр.Вставить("АвансыПоРеализацииРуб"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.02"));
	
	Стр.Вставить("РасчетыПоРеализацииВал"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.21"));
	Стр.Вставить("АвансыПоРеализацииВал"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.22"));
	
	Стр.Вставить("РасчетыПоРеализацииУЕ"		, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.31"));
	Стр.Вставить("АвансыПоРеализацииУЕ"			, ПланыСчетов.Хозрасчетный.НайтиПоКоду("62.32"));
	
	Возврат Стр;
	
КонецФункции

// АБС ВСТАВКА Фролов
// Универсальный обмен данными через веб сервис
Функция ПолучитьОбработкуВыгрузкиДанныхИСУЗК() Экспорт
	
	ОбработкаВыгрузки = Обработки.абс_УниверсальныйОбменДаннымиXML_ИСУЗК.Создать();

	ОбработкаВыгрузки.ЗагрузитьПравилаОбмена(ОбработкаВыгрузки.ПолучитьМакет("ПравилаОбменаДанными").ПолучитьТекст(), "Строка");

	ОбработкаВыгрузки.ИмяФайлаПравилОбмена = "ПравилаОбменаДанными";
	
	Возврат ОбработкаВыгрузки;

КонецФункции


//АБС ВСТАВКА Попов
Функция ПолучитьWSОпределениеПоURL(URLСсылка, Пользователь, Пароль) Экспорт
	
	Возврат Новый WSОпределения(URLСсылка, Пользователь, Пароль);	
	
КонецФункции

//abs_PersonData
Функция ПолучитьWSПрокси_abs_PersonData() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_PersonData") = Неопределено Тогда
		Попытка
			ТекстСообщения = "Начало получения WSПрокси через WSСсылку";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_PersonData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_PersonData , ,ТекстСообщения);
		
			Прокси = WSСсылки.abs_PersonData.СоздатьWSПрокси("http://www.abs-soft.ru", "abs_PersonData", "abs_PersonDataSoap",Таймаут); 	
			
			ТекстСообщения = "Получен WSПрокси через WSСсылку";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_PersonData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_PersonData , ,ТекстСообщения);
		

		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_EmpData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_PersonData , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/persondata/ws/PersonData.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft.ru", "abs_PersonData", "abs_PersonDataSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.PersonData", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_EmpData
Функция ПолучитьWSПрокси_abs_ISUZK_EmpData() Экспорт
	
		//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_EmpData") = Неопределено Тогда
		Попытка
			ТекстСообщения = "Начало получения WSПрокси через WSСсылку";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_EmpData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_PersonData , ,ТекстСообщения);
		

			Прокси = WSСсылки.abs_ISUZK_EmpData.СоздатьWSПрокси("http://www.abs-soft_Emp.ru", "abs_EmpData", "abs_EmpDataSoap",Таймаут); 	
			
			ТекстСообщения = "Получен WSПрокси через WSСсылку";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_EmpData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_PersonData , ,ТекстСообщения);
		

		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_EmpData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_EmpData , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_EmpData/ws/EmpData.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft_Emp.ru", "abs_EmpData", "abs_EmpDataSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_EmpData", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_AgentScheme
Функция ПолучитьWSПрокси_abs_ISUZK_AgentScheme() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_AgentScheme") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_AgentScheme.СоздатьWSПрокси("http://www.abs-soft.ru/AgentScheme", "abs_AgentScheme", "abs_AgentSchemeSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_AgentScheme.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_AgentScheme , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_AgentScheme/ws/AgentScheme.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft.ru/AgentScheme", "abs_AgentScheme", "abs_AgentSchemeSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_AgentScheme", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_Contractors
Функция ПолучитьWSПрокси_abs_ISUZK_Contractors() Экспорт
	
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_Contractors") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_Contractors.СоздатьWSПрокси("http://www.abs-soft_Contractors.ru", "abs_Contractors", "abs_ContractorsSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Contractors.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_Contractors , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_Contractors/ws/Contractors.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft_Contractors.ru", "abs_Contractors", "abs_ContractorsSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_Contractors", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_DepData
Функция ПолучитьWSПрокси_abs_ISUZK_DepData() Экспорт
	
		//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_DepData") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_DepData.СоздатьWSПрокси("http://www.abs-soft_Dep.ru", "abs_DepData", "abs_DepDataSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_DepData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_DepData , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_DepData/ws/DepData.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft_Dep.ru", "abs_DepData", "abs_DepDataSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_DepData", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_Dogovor_Act_Integration
Функция ПолучитьWSПрокси_abs_ISUZK_Dogovor_Act_Integration() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ


	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_Dogovor_Act_Integration") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_Dogovor_Act_Integration.СоздатьWSПрокси("Dogovor_Act", "abs_Dogovor_Act_Integration", "abs_Dogovor_Act_IntegrationSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Dogovor_Act_Integration.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_Dogovor_Act_Integration , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_Dogovor_Act_Integration/ws/Dogovor_Act_Integration.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "Dogovor_Act", "abs_Dogovor_Act_Integration", "abs_Dogovor_Act_IntegrationSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_Dogovor_Act_Integration", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_Dogovor_PersonData
Функция ПолучитьWSПрокси_abs_ISUZK_Dogovor_PersonData() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ


	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_Dogovor_PersonData") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_EmpData.СоздатьWSПрокси("http://www.abs-soft_Dogovor_PersonData.ru", "abs_Dogovor_PersonData", "abs_Dogovor_PersonDataSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Dogovor_PersonData.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_Dogovor_PersonData , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_Dogovor_PersonData/ws/Dogovor_PersonData.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "http://www.abs-soft_Dogovor_PersonData.ru", "abs_Dogovor_PersonData", "abs_Dogovor_PersonDataSoap", Таймаут); 	
		Исключение
			
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_Dogovor_PersonData", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_PaySlip
Функция ПолучитьWSПрокси_abs_ISUZK_PaySlip() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ


	
	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_PaySlip") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_PaySlip.СоздатьWSПрокси("abs_Payslip", "abs_PaySlip", "abs_PaySlipSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_PaySlip.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_PaySlip , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_PaySlip/ws/PaySlip.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "abs_Payslip", "abs_PaySlip", "abs_PaySlipSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_PaySlip", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_Viplata_Zarplati
Функция ПолучитьWSПрокси_abs_ISUZK_Viplata_Zarplati() Экспорт
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_Viplata_Zarplati") = Неопределено Тогда
		Попытка
			
			//АБС ВСТАВКА 37022  27.12.2013 15:47:50  Шамов
			ТекстСообщения = "Попытка получения прокси через WSСсылку abs_ViplataZarplati";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Viplata_Zarplati.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_ISUZK_Viplata_Zarplati , ,ТекстСообщения);
			//АБС ВСТАВКА 37022 КОНЕЦ
			Прокси = WSСсылки.abs_ISUZK_Viplata_Zarplati.СоздатьWSПрокси("Viplata_Zarplati", "abs_ViplataZarplati", "abs_ViplataZarplatiSoap",Таймаут); 	
			//АБС ВСТАВКА 37022  27.12.2013 15:47:50  Шамов
			ТекстСообщения = "Успешно получено прокси через WSСсылку abs_ViplataZarplati";
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Viplata_Zarplati.СоздатьWSПрокси", УровеньЖурналаРегистрации.Информация,Метаданные.WSСсылки.abs_ISUZK_Viplata_Zarplati , ,ТекстСообщения);
			//АБС ВСТАВКА 37022 КОНЕЦ
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_Viplata_Zarplati.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_Viplata_Zarplati , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_Viplata_Zarplati/ws/Viplata_Zarplati.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			//АБС ВСТАВКА 37022  27.12.2013 15:47:50  Шамов
			ТекстСообщения = "Попытка получения прокси через WSОпределение abs_ViplataZarplati";
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.abs_ISUZK_Viplata_Zarplati", УровеньЖурналаРегистрации.Информация, , ,ТекстСообщения);
			//АБС ВСТАВКА 37022 КОНЕЦ
		    Прокси = Новый WSПрокси(WSОпределение, "Viplata_Zarplati", "abs_ViplataZarplati", "abs_ViplataZarplatiSoap", Таймаут); 	
			//АБС ВСТАВКА 37022  27.12.2013 15:47:50  Шамов
			ТекстСообщения = "Успешно получено прокси через WSОпределение abs_ViplataZarplati";
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.abs_ISUZK_Viplata_Zarplati", УровеньЖурналаРегистрации.Информация, , ,ТекстСообщения);
			//АБС ВСТАВКА 37022 КОНЕЦ
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.ISUZK_Viplata_Zarplati", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

//abs_ISUZK_XMLExchange
Функция ПолучитьWSПрокси_abs_ISUZK_XMLExchange() Экспорт
	
	//АБС ИЗМЕНЕНИЕ 54695  22.12.2014 12:54:31  Попов
	//АБС ИЗМЕНЕНИЕ 37344  10.01.2014 17:31:17  Шамов
	Таймаут = глЗначениеПеременной("абс_ТаймаутПриОбращенииКВебСервисам");
	Если Таймаут = Неопределено Тогда
		Таймаут = 0;
	КонецЕсли;
	//Таймаут = 0;
	//АБС ИЗМЕНЕНИЕ 37344 КОНЕЦ
	//АБС ИЗМЕНЕНИЕ 54695 КОНЕЦ

	Прокси = Неопределено; 
	
	// Создание описания по WSDL файлу	
	Если НЕ Метаданные.WSСсылки.Найти("abs_ISUZK_XMLExchange") = Неопределено Тогда
		Попытка
			
			Прокси = WSСсылки.abs_ISUZK_XMLExchange.СоздатьWSПрокси("abs_XMLExchange", "abs_XMLExchange", "abs_XMLExchangeSoap",Таймаут); 	
		
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSСсылку:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("WSСсылки.abs_ISUZK_XMLExchange.СоздатьWSПрокси", УровеньЖурналаРегистрации.Ошибка,Метаданные.WSСсылки.abs_ISUZK_XMLExchange , ,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	

	
	Если Прокси = Неопределено Тогда

		Попытка
			
			Если НЕ Константы.абс_ЭтоТестоваяБаза.Получить() Тогда
				WSОпределение = ПолучитьWSОпределениеПоURL("https://isup-ttk.transtk.ru/ISUZK_XMLExchange/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			Иначе
				WSОпределение = ПолучитьWSОпределениеПоURL("http://bd/ISUZK/ws/XMLExchange.1cws?wsdl", "EISUP_PersonalData", "EISUP_PersonalData");
			КонецЕсли;
			
		    Прокси = Новый WSПрокси(WSОпределение, "abs_XMLExchange", "abs_XMLExchange", "abs_XMLExchangeSoap", Таймаут); 	
		Исключение
			ТекстСообщения = "Ошибка при получении WSПрокси через WSОпределение:  "+ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации("ПолучитьWSОпределениеПоURL.abs_XMLExchange", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		
			Возврат Неопределено;
	    КонецПопытки;
	КонецЕсли;
	
	Если Прокси = Неопределено Тогда
		ТекстСообщения = "Ошибка при получении WSПрокси:  "+ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации("WSПрокси", УровеньЖурналаРегистрации.Ошибка, , ,ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

