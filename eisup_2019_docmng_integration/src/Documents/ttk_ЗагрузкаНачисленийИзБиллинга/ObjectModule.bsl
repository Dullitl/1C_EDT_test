Перем КоличествоДокументовНаОперации Экспорт;

Процедура ЗаписатьИнформациюЗавершенияТаблицаTPI(СтатусTPI)
	
	ИмяСервера = "kttk-1c-db";
	ИмяБазыДанных = "TransPlatformIntegration";
	Пользователь = "abs_dbo";
	Пароль = "yHGHivs";
	
	Попытка
		ConnectionString = "Provider=sqloledb; SERVER=" + СокрЛП(ИмяСервера) + ";UID=" + СокрЛП(Пользователь) + ";PWD=" + СокрЛП(Пароль) + ";DATABASE=" + СокрЛП(ИмяБазыДанных)+"; ";
		Соединение=Новый COMОбъект("ADODB.Connection");
		Соединение.Open(СокрЛП(ConnectionString));
	Исключение
		Сообщить("Нет подключения! " +  ОписаниеОшибки());
		ВызватьИсключение;
	КонецПопытки; 
	
	//сч = 1;
	
	//Для Каждого СтрокаРезультата Из РезультатТаблица Цикл
		
	//алгоритм обработки строки результата - начало ------>
		
	JOURNALID = "'" + СокрЛП(ЖурналID) + "'";
	SESSIONID = "'" + СокрЛП(СессияID) + "'";
	//SESSIONISOK = "'" + 1 + "'";
	TABLENAME = "'" + "TTLEDGERJOURNALTABLEBILLINGOS_" + СокрЛП(МестонахождениеБиллинга.ПрефиксТаблицыНачисленияВTPI) + "'";
		
	ТекстЗапросаADO = "Select * From dbo.TTLEDGERJOURNALTABLEBILLINGOS_INFO Where JOURNALID = " + JOURNALID + " AND SESSIONID = " + SESSIONID;
	
	Cmd = Новый COMОбъект("ADODB.Command");
	Cmd.ActiveConnection = Соединение; 
	Cmd.CommandText = ТекстЗапросаADO;
		
	Rs = Новый COMОбъект("ADODB.RecordSet");
	
	Попытка                                             
		Rs = Cmd.Execute();       
		Если Rs.BOF = 0 Тогда
			//Сообщить(""обновим"");
			ТекстЗапросаADO = "UPDATE dbo.TTLEDGERJOURNALTABLEBILLINGOS_INFO SET JOURNALID = " + JOURNALID
				+ ", SESSIONID = " + SESSIONID
				+ ", SESSIONISOK = " + СтатусTPI				
				+ ", TABLENAME = " + TABLENAME				
				+ " Where JOURNALID = " + JOURNALID + " AND SESSIONID = " + SESSIONID; 
			Соединение.Execute(ТекстЗапросаADO);
		Иначе
			//Сообщить(""добавим"");
			ТекстЗапросаADO = "Insert into dbo.TTLEDGERJOURNALTABLEBILLINGOS_INFO(JOURNALID, SESSIONID, SESSIONISOK, TABLENAME) Values ("
				+ JOURNALID +","
				+ SESSIONID + ","
				+ СтатусTPI + ","
				+ TABLENAME + ")";
			Соединение.Execute(ТекстЗапросаADO);
		КонецЕсли;         
		Rs.Close();
	Исключение
		Сообщить(ОписаниеОшибки());
		ВызватьИсключение;
	КонецПопытки;
		
	//сч = сч + 1;
		
	//ЭлементыФормы.Индикатор.Значение = сч;
		
	//	ОбработкаПрерыванияПользователя();
		
	//КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьНовыйСтатус(НовыйСтатус, Комментарий = Неопределено) Экспорт
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	НаборЗаписей = РегистрыСведений.абс_ИзменениеСтатусовПервичныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПервичныйДокумент.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Прочитать();
	Запись = НаборЗаписей.Добавить();
	Запись.Период = абс_СерверныеФункции.ПолучитьДатуСервера();
	Запись.ПервичныйДокумент		= ЭтотОбъект.Ссылка;
	Запись.Пользователь 			= ТекПользователь;	
	Запись.СтатусДокумента			= НовыйСтатус;
	Запись.Комментарий 				= Комментарий;
	ОтветственныйСотрудник = абс_БизнесПроцессы.ПолучитьСотрудникаПользователя(ТекПользователь);
	Если НЕ ОтветственныйСотрудник = Неопределено Тогда
		Запись.ДолжностьОтветственного	= ОтветственныйСотрудник.Должность;
	КонецЕсли;
	
	//+++ Григорьев Д.В. - 03.10.2018
	Если НовыйСтатус = Перечисления.абс_СтатусыПервичныхДокументов.Завершен Тогда
		ЗаписатьИнформациюЗавершенияТаблицаTPI("'1'");
	иначе
		ЗаписатьИнформациюЗавершенияТаблицаTPI("'0'");
	КонецЕсли;	
	//--- Григорьев Д.В. - 03.10.2018
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция СтатусПоРегистру()
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	             |	абс_ИзменениеСтатусовПервичныхДокументов.СтатусДокумента,
	             |	абс_ИзменениеСтатусовПервичныхДокументов.Период
	             |ИЗ
	             |	РегистрСведений.абс_ИзменениеСтатусовПервичныхДокументов КАК абс_ИзменениеСтатусовПервичныхДокументов
	             |ГДЕ
	             |	абс_ИзменениеСтатусовПервичныхДокументов.ПервичныйДокумент = &Дока
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	абс_ИзменениеСтатусовПервичныхДокументов.Период УБЫВ";
	Запрос.УстановитьПараметр("ДатаТек",абс_СерверныеФункции.ПолучитьДатуСервера());
	Запрос.УстановитьПараметр("Дока",ЭтотОбъект.Ссылка);
	Статусы=Запрос.Выполнить().Выбрать();
	РСтат = Перечисления.абс_СтатусыПервичныхДокументов.ПустаяСсылка();
	Если Статусы.Следующий() Тогда
		РСтат = Статусы.СтатусДокумента;
	КонецЕсли;
	Возврат РСтат;
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	Если НЕ Отказ Тогда
		Если СтатусПоРегистру()<>ЭтотОбъект.абс_Статус Тогда
			ЗаписатьНовыйСтатус(ЭтотОбъект.абс_Статус);
		КонецЕсли;
	КонецЕсли;
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	//Если СтатусПоРегистру()<>ЭтотОбъект.абс_Статус Тогда
	Если ЭтотОбъект.Ссылка.абс_Статус=Перечисления.абс_СтатусыПервичныхДокументов.Завершен Тогда
		// Сохрание исторического отпечатка соответствия признаков нормативно-справочной информации НСИ ЕИСУП
		//Попытка
		//	Состояние("Идёт сохранение исторического отпечатка соответствия реквизитов НСИ...");
		//Исключение
		//КонецПопытки;
		йГод=Цел(ЭтотОбъект.MONT_F/100);
		йМесяц=ЭтотОбъект.MONT_F-йГод*100;
		ДатаПериода = НачалоМесяца(Дата(йГод,йМесяц,1,0,0,0));
		РКД=ЭтотОбъект.Движения.ttk_СоответствиеВБиллингеИЕисупеНормативноСправочнойИнформации;
		РКД.Прочитать();
		РКД.Очистить();
		Запрос=Новый Запрос;
		Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Доки",ЭтотОбъект.Документы.Выгрузить(,"ИндексДоговора,Статус"));
		Запрос.УстановитьПараметр("ДокаМГМН",ЭтотОбъект.ЗадолженностьМГМН.Выгрузить(,"ИндексДоговора"));
		Запрос.УстановитьПараметр("Доги",ЭтотОбъект.КонтрагентыДоговоры.Выгрузить(,"НомерСтроки,КодКонтрагента,ЛицевойСчет,НомерДоговора,Контрагент,ТипКонтрагента,Договор,Валюта,Статус"));
		Запрос.УстановитьПараметр("ЕстьМГМН",(ЭтотОбъект.МестонахождениеБиллинга.БиллингМГМН И (ЭтотОбъект.СтатусДокументаЗадолженностиМГМН=Перечисления.ttk_СтатусыЭлементовЗагрузки.Проведен)));
 		Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
 		             |	ВТ_.ИндексДоговора КАК ИндексДоговора
 		             |ПОМЕСТИТЬ ВТ_Доки
 		             |ИЗ
 		             |	&Доки КАК ВТ_
 		             |ГДЕ
 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Проведен)
 		             |;
 		             |
 		             |////////////////////////////////////////////////////////////////////////////////
 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
 		             |	ВТ_.ИндексДоговора КАК ИндексДоговора
 		             |ПОМЕСТИТЬ ВТ_ДокаМГМН
 		             |ИЗ
 		             |	&ДокаМГМН КАК ВТ_
 		             |ГДЕ
 		             |	&ЕстьМГМН
 		             |;
 		             |
 		             |////////////////////////////////////////////////////////////////////////////////
 		             |ВЫБРАТЬ
 		             |	ВТ_.НомерСтроки КАК ИндексДоговора,
 		             |	ВТ_.КодКонтрагента КАК КодКонтрагента,
 		             |	ВТ_.ЛицевойСчет КАК ЛицевойСчет,
 		             |	ВТ_.НомерДоговора КАК НомерДоговора,
 		             |	ВТ_.Контрагент КАК Контрагент,
 		             |	ВТ_.ТипКонтрагента КАК ТипКонтрагента,
 		             |	ВТ_.Договор КАК Договор,
 		             |	ВТ_.Валюта КАК Валюта
 		             |ПОМЕСТИТЬ ВТ_Доги
 		             |ИЗ
 		             |	&Доги КАК ВТ_
 		             |ГДЕ
 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Готов)
 		             |;
 		             |
 		             |////////////////////////////////////////////////////////////////////////////////
 		             |ВЫБРАТЬ
 		             |	ВТ_Доги.КодКонтрагента КАК КодКонтрагента,
 		             |	ВТ_Доги.ЛицевойСчет КАК ЛицевойСчет,
 		             |	ВТ_Доги.НомерДоговора КАК НомерДоговора,
 		             |	ВТ_Доги.Контрагент КАК Контрагент,
 		             |	ВТ_Доги.ТипКонтрагента КАК ТипКонтрагента,
 		             |	ВТ_Доги.Договор КАК Договор,
 		             |	ВТ_Доги.Валюта КАК Валюта
 		             |ИЗ
 		             |	ВТ_Доги КАК ВТ_Доги
 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Доки КАК ВТ_Доки
 		             |		ПО ВТ_Доги.ИндексДоговора = ВТ_Доки.ИндексДоговора
 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДокаМГМН КАК ВТ_ДокаМГМН
 		             |		ПО ВТ_Доги.ИндексДоговора = ВТ_ДокаМГМН.ИндексДоговора
 		             |ГДЕ
 		             |	(НЕ ВТ_Доки.ИндексДоговора ЕСТЬ NULL 
 		             |			ИЛИ НЕ ВТ_ДокаМГМН.ИндексДоговора ЕСТЬ NULL )
 		             |
 		             |СГРУППИРОВАТЬ ПО
 		             |	ВТ_Доги.КодКонтрагента,
 		             |	ВТ_Доги.ЛицевойСчет,
 		             |	ВТ_Доги.НомерДоговора,
 		             |	ВТ_Доги.Контрагент,
 		             |	ВТ_Доги.ТипКонтрагента,
 		             |	ВТ_Доги.Договор,
 		             |	ВТ_Доги.Валюта";
		Доги = Запрос.Выполнить().Выгрузить();
		Запрос.МенеджерВременныхТаблиц.Закрыть();
		Для каждого йСтр Из Доги Цикл
			йРКД=РКД.Добавить();
			йРКД.МестонахождениеБиллинга=ЭтотОбъект.МестонахождениеБиллинга;
			йРКД.ДокументЗагрузки=ЭтотОбъект.Ссылка;
			йРКД.КодКонтрагента=йСтр.КодКонтрагента;
			йРКД.ЛицевойСчет=йСтр.ЛицевойСчет;
			йРКД.НомерДоговора=йСтр.НомерДоговора;
			йРКД.Контрагент=йСтр.Контрагент;
			йРКД.ТипКонтрагента=йСтр.ТипКонтрагента;
			йРКД.Договор=йСтр.Договор;
			йРКД.Валюта=йСтр.Валюта;
			йРКД.Период=ДатаПериода;
		КонецЦикла;
		РКД.Записать(Истина);
		Если ЭтотОбъект.МестонахождениеБиллинга.ИспользоватьРегистрИсторииЗагрузокДляУчетаЦФОиЦФУ Тогда
			// Сохрание исторического отпечатка соответствия признаков нормативно-справочной информации Биллинга и ЦФО, ЦФУ
			РКД=ЭтотОбъект.Движения.ttk_СоответствиеНормативныхРеквизитовБиллингаИЦФОиЦФУ;
			РКД.Прочитать();
			РКД.Очистить();
			Запрос=Новый Запрос;
			Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
			Запрос.УстановитьПараметр("Доки",ЭтотОбъект.Документы.Выгрузить(,"ИндексДоговора,Статус"));
			Запрос.УстановитьПараметр("Аналитики",ЭтотОбъект.Деталировка.Выгрузить(,"ИндексДоговора,НомерСтроки,Заказ,ЦФО,ЦФУ,Статус"));
			Запрос.УстановитьПараметр("ДокаМГМН",ЭтотОбъект.ЗадолженностьМГМН.Выгрузить(,"ИндексДоговора"));
			Запрос.УстановитьПараметр("Доги",ЭтотОбъект.КонтрагентыДоговоры.Выгрузить(,"НомерСтроки,КодКонтрагента,ЛицевойСчет,НомерДоговора,Контрагент,ТипКонтрагента,Договор,ИндексВалюты,Статус"));
			Запрос.УстановитьПараметр("Валюты",ЭтотОбъект.Валюты.Выгрузить(,"НомерСтроки,КодВалюты,Статус"));
			Запрос.УстановитьПараметр("ЕстьМГМН",(ЭтотОбъект.МестонахождениеБиллинга.БиллингМГМН И (ЭтотОбъект.СтатусДокументаЗадолженностиМГМН=Перечисления.ttk_СтатусыЭлементовЗагрузки.Проведен)));
	 		Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.ИндексДоговора КАК ИндексДоговора
	 		             |ПОМЕСТИТЬ ВТ_Доки
	 		             |ИЗ
	 		             |	&Доки КАК ВТ_
	 		             |ГДЕ
	 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Проведен)
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.ИндексДоговора КАК ИндексДоговора
	 		             |ПОМЕСТИТЬ ВТ_ДокаМГМН
	 		             |ИЗ
	 		             |	&ДокаМГМН КАК ВТ_
	 		             |ГДЕ
	 		             |	&ЕстьМГМН
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.НомерСтроки КАК ИндексВалюты,
	 		             |	ВТ_.КодВалюты КАК КодВалюты
	 		             |ПОМЕСТИТЬ ВТ_Валюты
	 		             |ИЗ
	 		             |	&Валюты КАК ВТ_
	 		             |ГДЕ
	 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Готов)
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ
	 		             |	ВТ_.НомерСтроки КАК ИндексДоговора,
	 		             |	ВТ_.КодКонтрагента КАК КодКонтрагента,
	 		             |	ВТ_.ЛицевойСчет КАК ЛицевойСчет,
	 		             |	ВТ_.НомерДоговора КАК НомерДоговора,
	 		             |	ВТ_.ИндексВалюты КАК ИндексВалюты
	 		             |ПОМЕСТИТЬ ВТ_Доги
	 		             |ИЗ
	 		             |	&Доги КАК ВТ_
	 		             |ГДЕ
	 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Готов)
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.ИндексДоговора КАК ИндексДоговора,
	 		             |	ВТ_.НомерСтроки КАК НомерСтроки,
	 		             |	ВТ_.Заказ КАК Заказ,
	 		             |	ВТ_.ЦФО КАК ЦФО,
	 		             |	ВТ_.ЦФУ КАК ЦФУ
	 		             |ПОМЕСТИТЬ ВТ_Детали_Сырец
	 		             |ИЗ
	 		             |	&Аналитики КАК ВТ_
	 		             |ГДЕ
	 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Готов)
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ
	 		             |	ВТ_Детали_Сырец.ИндексДоговора,
	 		             |	ВТ_Детали_Сырец.Заказ,
	 		             |	МИНИМУМ(ВТ_Детали_Сырец.НомерСтроки) КАК НомерСтроки
	 		             |ПОМЕСТИТЬ ВТ_Детали_Отсчет
	 		             |ИЗ
	 		             |	ВТ_Детали_Сырец КАК ВТ_Детали_Сырец
	 		             |
	 		             |СГРУППИРОВАТЬ ПО
	 		             |	ВТ_Детали_Сырец.ИндексДоговора,
	 		             |	ВТ_Детали_Сырец.Заказ
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ
	 		             |	ВТ_Детали_Отсчет.ИндексДоговора,
	 		             |	ВТ_Детали_Отсчет.Заказ,
	 		             |	ВТ_Детали_Сырец.ЦФО,
	 		             |	ВТ_Детали_Сырец.ЦФУ
	 		             |ПОМЕСТИТЬ ВТ_Детали
	 		             |ИЗ
	 		             |	ВТ_Детали_Отсчет КАК ВТ_Детали_Отсчет
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Детали_Сырец КАК ВТ_Детали_Сырец
	 		             |		ПО ВТ_Детали_Отсчет.НомерСтроки = ВТ_Детали_Сырец.НомерСтроки
	 		             |			И ВТ_Детали_Отсчет.Заказ = ВТ_Детали_Сырец.Заказ
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ
	 		             |	ВТ_Доги.КодКонтрагента КАК КодКонтрагента,
	 		             |	ВТ_Доги.ЛицевойСчет КАК ЛицевойСчет,
	 		             |	ВТ_Доги.НомерДоговора КАК НомерДоговора,
	 		             |	ВТ_Валюты.КодВалюты КАК КодВалюты,
	 		             |	ВТ_Детали.Заказ,
	 		             |	ВТ_Детали.ЦФО,
	 		             |	ВТ_Детали.ЦФУ
	 		             |ИЗ
	 		             |	ВТ_Доги КАК ВТ_Доги
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Доки КАК ВТ_Доки
	 		             |		ПО ВТ_Доги.ИндексДоговора = ВТ_Доки.ИндексДоговора
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДокаМГМН КАК ВТ_ДокаМГМН
	 		             |		ПО ВТ_Доги.ИндексДоговора = ВТ_ДокаМГМН.ИндексДоговора
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Детали КАК ВТ_Детали
	 		             |		ПО ВТ_Доги.ИндексДоговора = ВТ_Детали.ИндексДоговора
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Валюты КАК ВТ_Валюты
	 		             |		ПО ВТ_Доги.ИндексВалюты = ВТ_Валюты.ИндексВалюты
	 		             |ГДЕ
	 		             |	(НЕ ВТ_Доки.ИндексДоговора ЕСТЬ NULL 
	 		             |			ИЛИ НЕ ВТ_ДокаМГМН.ИндексДоговора ЕСТЬ NULL )
	 		             |	И НЕ ВТ_Валюты.ИндексВалюты ЕСТЬ NULL 
	 		             |
	 		             |СГРУППИРОВАТЬ ПО
	 		             |	ВТ_Доги.КодКонтрагента,
	 		             |	ВТ_Доги.ЛицевойСчет,
	 		             |	ВТ_Доги.НомерДоговора,
	 		             |	ВТ_Валюты.КодВалюты,
	 		             |	ВТ_Детали.Заказ,
	 		             |	ВТ_Детали.ЦФО,
	 		             |	ВТ_Детали.ЦФУ";
			йЗаказы = Запрос.Выполнить().Выгрузить();
			Запрос.МенеджерВременныхТаблиц.Закрыть();
			Для каждого йСтр Из йЗаказы Цикл
				йРКД=РКД.Добавить();
				йРКД.МестонахождениеБиллинга=ЭтотОбъект.МестонахождениеБиллинга;
				йРКД.ДокументЗагрузки=ЭтотОбъект.Ссылка;
				йРКД.КодКонтрагента=йСтр.КодКонтрагента;
				йРКД.ЛицевойСчет=йСтр.ЛицевойСчет;
				йРКД.НомерДоговора=йСтр.НомерДоговора;
				йРКД.КодВалюты=йСтр.КодВалюты;
				йРКД.Заказ=йСтр.Заказ;
				йРКД.ЦФО=йСтр.ЦФО;
				йРКД.ЦФУ=йСтр.ЦФУ;
				йРКД.Период=ДатаПериода;
			КонецЦикла;
			РКД.Записать(Истина);
		КонецЕсли;
		Если ЭтотОбъект.МестонахождениеБиллинга.АгрегированнаяЗагрузка Тогда
			РРА=ЭтотОбъект.Движения.ttk_РасшифровкаАгрегированнойВыручкиПоДокументамНачислений;
			РРА.Прочитать();
			РРА.Очистить();
			Запрос=Новый Запрос;
			Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
			Запрос.УстановитьПараметр("Доки",ЭтотОбъект.Документы.Выгрузить(,"НомерСтроки,Статус,НомерКорректировкиРеализации,Реализация"));
			Запрос.УстановитьПараметр("Расшифровка",ЭтотОбъект.Деталировка.Выгрузить(,"ИндексДокумента,НомерИсходногоДокумента,НаименованиеПокупателя,ИННПокупателя,КПППокупателя"));
	 		Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.НомерСтроки КАК ИндексДокумента,
	 		             |	ВТ_.Реализация КАК Реализация
	 		             |ПОМЕСТИТЬ ВТ_Доки
	 		             |ИЗ
	 		             |	&Доки КАК ВТ_
	 		             |ГДЕ
	 		             |	ВТ_.Статус = ЗНАЧЕНИЕ(Перечисление.ttk_СтатусыЭлементовЗагрузки.Проведен)
	 		             |	И ВТ_.НомерКорректировкиРеализации = """"
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.ИндексДокумента КАК ИндексДокумента,
	 		             |	ВТ_.НомерИсходногоДокумента КАК НомерДокумента,
	 		             |	ВТ_.НаименованиеПокупателя КАК НаименованиеПокупателя,
	 		             |	ВТ_.ИННПокупателя КАК ИННПокупателя,
	 		             |	ВТ_.КПППокупателя КАК КПППокупателя
	 		             |ПОМЕСТИТЬ ВТ_Расшифровка
	 		             |ИЗ
	 		             |	&Расшифровка КАК ВТ_
	 		             |;
	 		             |
	 		             |////////////////////////////////////////////////////////////////////////////////
	 		             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 		             |	ВТ_.ИндексДокумента,
	 		             |	ВТ_.НомерДокумента,
	 		             |	ВТ_.НаименованиеПокупателя,
	 		             |	ВТ_.ИННПокупателя,
	 		             |	ВТ_.КПППокупателя,
	 		             |	ВТ_Доки.Реализация
	 		             |ИЗ
	 		             |	ВТ_Расшифровка КАК ВТ_
	 		             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Доки КАК ВТ_Доки
	 		             |		ПО ВТ_.ИндексДокумента = ВТ_Доки.ИндексДокумента
	 		             |ГДЕ
	 		             |	НЕ ВТ_Доки.ИндексДокумента ЕСТЬ NULL ";
			йДоки = Запрос.Выполнить().Выгрузить();
			Запрос.МенеджерВременныхТаблиц.Закрыть();
			Для каждого йСтр Из йДоки Цикл
				йРРА=РРА.Добавить();
				йРРА.Организация=ЭтотОбъект.Организация;
				йРРА.НомерДокумента=СокрЛП(йСтр.НомерДокумента);
				йРРА.ДатаДокумента=КонецМесяца(ДатаПериода);
				йРРА.НаименованиеПокупателя=йСтр.НаименованиеПокупателя;
				йРРА.ИННПокупателя=йСтр.ИННПокупателя;
				йРРА.КПППокупателя=йСтр.КПППокупателя;
				йРРА.ДокументАгрегации=йСтр.Реализация;
			КонецЦикла;
			РРА.Записать(Истина);
		КонецЕсли;
		//Попытка
		//	Состояние("Идёт дозаполнение обязательных реквизитов договоров связанных с данной загрузкой...");
		//Исключение
		//КонецПопытки;
		ВидДеятельностиСвязь = Справочники.абс_ВидыДеятельностиКТТК.НайтиПоКоду("000000005");
		Для каждого йСтр Из Доги Цикл
			Если йСтр.Договор.абс_СтатусДоговора<>Перечисления.абсСтатусыДоговоров.Исполнение Тогда
				Продолжить;
			КонецЕсли;
			йДога=йСтр.Договор.ПолучитьОбъект();
			ФлагЗаписи=Ложь;
			Если СокрЛП(йСтр.НомерДоговора)<>СокрЛП(йДога.Номер) Тогда
				йДога.Номер=СокрЛП(йСтр.НомерДоговора);
				йДога.Наименование=йДога.Номер+" от "+Формат(йДога.Дата,"ДЛФ=D");
				ФлагЗаписи=Истина;
			КонецЕсли;
			Если НЕ ЭтотОбъект.МестонахождениеБиллинга.УчитыватьСписокЛицевыхСчетовНаОдномДоговоре Тогда
				Если СокрЛП(йСтр.ЛицевойСчет)<>СокрЛП(йДога.абс_ЛицевойСчетБиллинга) Тогда
					йДога.абс_ЛицевойСчетБиллинга=СокрЛП(йСтр.ЛицевойСчет);
					ФлагЗаписи=Истина;
				КонецЕсли;
			КонецЕсли;
			Если ЭтотОбъект.МестонахождениеБиллинга<>йДога.ввв_МестонахождениеБиллинга Тогда
				йДога.ввв_МестонахождениеБиллинга=ЭтотОбъект.МестонахождениеБиллинга;
				ФлагЗаписи=Истина;
			КонецЕсли;
			Если НЕ йДога.абс_КлиентБиллинга Тогда
				йДога.абс_КлиентБиллинга=Истина;
				ФлагЗаписи=Истина;
			КонецЕсли;
			Если йДога.абс_ВидДеятельности<>ВидДеятельностиСвязь Тогда
				йДога.абс_ВидДеятельности=ВидДеятельностиСвязь;
				ФлагЗаписи=Истина;
			КонецЕсли;
			Если ФлагЗаписи Тогда
				Попытка
					йДога.ОбменДанными.Загрузка=Истина;
					йДога.Записать();
					Сообщить("Нормализовался договор "+йДога.Ссылка);
				Исключение
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
