
Функция НайтиСтатьюЗатратВГО(СтруктураЭлемента)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ttk_СтатьиЗатратВГО.Ссылка
		|ИЗ
		|	Справочник.ttk_СтатьиЗатратВГО КАК ttk_СтатьиЗатратВГО
		|ГДЕ
		|	ttk_СтатьиЗатратВГО.ПометкаУдаления = ЛОЖЬ
		|	И ttk_СтатьиЗатратВГО.Код = &Код";
	Запрос.УстановитьПараметр("Код", СтруктураЭлемента.Код);
	
	Выборка = Запрос.Выполнить();
	Если Выборка.Пустой() Тогда
		Возврат Справочники.ttk_СтатьиЗатратВГО.ПустаяСсылка();
	КонецЕсли;
	
	Результат = Выборка.Выгрузить();
	
	Возврат Результат[0].Ссылка;
	
КонецФункции

Процедура СоздатьЭлементСправочникаНаСервере(ЭлементСправочника) Экспорт
	
	НайденныйЭлементСправочника = НайтиСтатьюЗатратВГО(ЭлементСправочника);
	Если НайденныйЭлементСправочника = Справочники.ttk_СтатьиЗатратВГО.ПустаяСсылка() Тогда
		ТекущийЭлементСправочника = Справочники.ttk_СтатьиЗатратВГО.СоздатьЭлемент();
	Иначе 
		ТекущийЭлементСправочника = НайденныйЭлементСправочника.ПолучитьОбъект();
	КонецЕсли;
	
	ТекущийЭлементСправочника.Код = ЭлементСправочника.Код;
	ТекущийЭлементСправочника.Наименование = ЭлементСправочника.Наименование;
	ТекущийЭлементСправочника.Статус = Перечисления.абс_СтатусыНоменклатуры.Использование;
	ТекущийЭлементСправочника.ПричинаИзмененияСтатуса = "Автоматическая загрузка из файла [" + ЭлементСправочника.ФайлИмпорта + "]";
	ТекущийЭлементСправочника.Ответственный = глЗначениеПеременной("глТекущийПользователь");
	
	ТекущийЭлементСправочника.Записать();
	
КонецПроцедуры

Процедура ПрочитатьДанныеФайла(АдресХранилища, ИмяФайла, РасширениеФайла) Экспорт

	//ИмпортируемыйФайл = Новый Файл(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	//Если ИмпортируемыйФайл.Существует() Тогда
	//	УдалитьФайлы(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	//КонецЕсли;
	//
	//ФайлИзХранилища = ПолучитьИзВременногоХранилища(Строка(АдресХранилища));
	//ФайлИзХранилища.Записать(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	//
	//ЧитаемыйФайл = Новый ТекстовыйДокумент;
	//ЧитаемыйФайл.Прочитать(СокрЛП(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла), КодировкаТекста.UTF8);	
	//
	//Для н = 1 По ЧитаемыйФайл.КоличествоСтрок() Цикл
	//	Стр = ЧитаемыйФайл.ПолучитьСтроку(н);
	//	Стр = СтрЗаменить(Стр, """", "");
	//	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр, ";");		
	//	Если ЗначениеЗаполнено(СокрЛП(МассивПодстрок[0])) И СокрЛП(МассивПодстрок[0]) <> "0" Тогда
	//		ЭлементКонтрагента = Новый Структура;
	//		ЭлементКонтрагента.Вставить("КодАСВГО", СокрЛП(МассивПодстрок[0]));
	//		ЭлементКонтрагента.Вставить("НаименованиеКонтрагента", СокрЛП(МассивПодстрок[1]));
	//		ЭлементКонтрагента.Вставить("ИННКонтрагента", СокрЛП(Формат(Число(МассивПодстрок[8]), "ЧДЦ=; ЧГ=0")));
	//		ЭлементКонтрагента.Вставить("КППКонтрагента", СокрЛП(Формат(Число(МассивПодстрок[9]), "ЧДЦ=; ЧГ=0")));
	//		ЭлементКонтрагента.Вставить("КодГоловногоКонтрагента", СокрЛП(МассивПодстрок[17]));
	//		ЭлементКонтрагента.Вставить("ФайлИмпорта", СокрЛП(ИмяФайла + РасширениеФайла));
	//		Справочники.ttk_КонтрагентыВГО.СоздатьЭлементСправочникаНаСервере(ЭлементКонтрагента);
	//	Иначе
	//		Сообщить("Контрагент '" + СокрЛП(СокрЛП(МассивПодстрок[1])) + "' пропущен. Не полная информация в файле импорта [" + СокрЛП(ИмяФайла + РасширениеФайла) + "].");
	//	КонецЕсли;		
	//КонецЦикла;	
	//
	////Обновим головных контрагентов
	//Для н = 1 По ЧитаемыйФайл.КоличествоСтрок() Цикл
	//	Стр = ЧитаемыйФайл.ПолучитьСтроку(н);
	//	Стр = СтрЗаменить(Стр, """", "");
	//	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр, ";");		
	//	Если ЗначениеЗаполнено(СокрЛП(МассивПодстрок[17])) И СокрЛП(МассивПодстрок[17]) <> "0" Тогда
	//		ЭлементКонтрагента = Новый Структура;
	//		ЭлементКонтрагента.Вставить("КодАСВГО", СокрЛП(МассивПодстрок[0]));
	//		ЭлементКонтрагента.Вставить("НаименованиеКонтрагента", СокрЛП(МассивПодстрок[1]));
	//		ЭлементКонтрагента.Вставить("ИННКонтрагента", СокрЛП(Формат(Число(МассивПодстрок[8]), "ЧДЦ=; ЧГ=0")));
	//		ЭлементКонтрагента.Вставить("КППКонтрагента", СокрЛП(Формат(Число(МассивПодстрок[9]), "ЧДЦ=; ЧГ=0")));
	//		ЭлементКонтрагента.Вставить("КодГоловногоКонтрагента", СокрЛП(МассивПодстрок[17]));
	//		ЭлементКонтрагента.Вставить("ФайлИмпорта", СокрЛП(ИмяФайла + РасширениеФайла));
	//		Справочники.ttk_КонтрагентыВГО.ОбновитьГоловныхКонтрагентовНаСервере(ЭлементКонтрагента);
	//	Иначе
	//		Сообщить("Контрагент '" + СокрЛП(СокрЛП(МассивПодстрок[1])) + "' пропущен. Не полная информация в файле импорта [" + СокрЛП(ИмяФайла + РасширениеФайла) + "].");
	//	КонецЕсли;		
	//КонецЦикла;	
	
КонецПроцедуры

Процедура ПрочитатьДанныеФайлаExcel(АдресХранилища, ИмяФайла, РасширениеФайла) Экспорт

	ИмпортируемыйФайл = Новый Файл(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	Если ИмпортируемыйФайл.Существует() Тогда
		УдалитьФайлы(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	КонецЕсли;
	
	ФайлИзХранилища = ПолучитьИзВременногоХранилища(Строка(АдресХранилища));
	ФайлИзХранилища.Записать(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла);
	
	СтрокаСоединения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(КаталогВременныхФайлов() + ИмяФайла + РасширениеФайла) + ";Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";";
	Соединение = Новый COMОбъект("ADODB.Connection");
	Соединение.ConnectionString = СтрокаСоединения;
	Соединение.CursorLocation = 3;
	Попытка        
	    Соединение.Open();
	Исключение        
		Сообщить(ОписаниеОшибки());
	    Возврат;
	КонецПопытки;
	
	ТекстЗапроса = "SELECT * FROM [Лист1$]";
	
	ТаблицаДанных = Новый COMОбъект("ADODB.Recordset");
	ТаблицаДанных.Open(ТекстЗапроса, Соединение);
	ТаблицаДанных.MoveFirst();
	ТаблицаДанных.Move(4);	
	Пока ТаблицаДанных.EOF = Ложь Цикл
		Если ЗначениеЗаполнено(СокрЛП(ТаблицаДанных.Fields(0).Value)) И СокрЛП(ТаблицаДанных.Fields(0).Value) <> "0" Тогда
			ЭлементСтатьиЗатрат = Новый Структура;
			ЭлементСтатьиЗатрат.Вставить("Код", СокрЛП(ТаблицаДанных.Fields(0).Value));
			ЭлементСтатьиЗатрат.Вставить("Наименование", СокрЛП(ТаблицаДанных.Fields(1).Value));
			ЭлементСтатьиЗатрат.Вставить("ФайлИмпорта", СокрЛП(ИмяФайла + РасширениеФайла));
			Справочники.ttk_СтатьиЗатратВГО.СоздатьЭлементСправочникаНаСервере(ЭлементСтатьиЗатрат);
		Иначе
			Сообщить("Статья затрат '" + СокрЛП(ТаблицаДанных.Fields(1).Value) + "' пропущена. Не полная информация в файле импорта [" + СокрЛП(ИмяФайла + РасширениеФайла) + "].");
		КонецЕсли;
		ТаблицаДанных.MoveNext();
	КонецЦикла;
	
КонецПроцедуры
