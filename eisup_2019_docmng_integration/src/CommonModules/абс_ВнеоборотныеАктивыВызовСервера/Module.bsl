

Процедура ВыполнитьНачислениеАмортизацииОС(Ссылка, Отказ) Экспорт
	
	абс_ВнеоборотныеАктивы.ВыполнитьНачислениеАмортизацииОС(Ссылка, Отказ);
	
КонецПроцедуры

Функция ПолучитьПодразделениеОрганизации(Подразделение, ТекущееПодразделениеОрганизации, СпособОтражения, Организация) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		Возврат ТекущееПодразделениеОрганизации;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда 
		Возврат ТекущееПодразделениеОрганизации;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СпособОтражения) Тогда 	
		Если СпособОтражения.Организация = Организация Тогда 
			Возврат ТекущееПодразделениеОрганизации;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	СоответствиеПодразделенийИПодразделенийОрганизаций.ПодразделениеОрганизации
	                      |ИЗ
	                      |	РегистрСведений.СоответствиеПодразделенийИПодразделенийОрганизаций КАК СоответствиеПодразделенийИПодразделенийОрганизаций
	                      |ГДЕ
	                      |	СоответствиеПодразделенийИПодразделенийОрганизаций.Подразделение = &Подразделение
	                      |	И СоответствиеПодразделенийИПодразделенийОрганизаций.ПодразделениеОрганизации <> &ПустоеПодразделениеОрганизации
	                      |	И СоответствиеПодразделенийИПодразделенийОрганизаций.Организация = &Организация");
				   
	Запрос.УстановитьПараметр("Подразделение",	Подразделение);
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ПустоеПодразделениеОрганизации",Справочники.ПодразделенияОрганизаций.ПустаяСсылка());

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ПодразделениеОрганизации;
	КонецЕсли;
	
	Возврат ТекущееПодразделениеОрганизации; 
	
КонецФункции

Процедура ЗаполнитьОбособленноеПодразделениеОС(СтруктураШапкиДокумента) Экспорт
	
	Если СтруктураШапкиДокумента.Свойство("абс_Обособленное") Тогда 
		ОбособленноеПодразделение = СтруктураШапкиДокумента.абс_Обособленное;
	ИначеЕсли СтруктураШапкиДокумента.Свойство("абс_ОбособленноеПодразделение") Тогда
		ОбособленноеПодразделение = СтруктураШапкиДокумента.абс_ОбособленноеПодразделение;
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаОС.ОсновноеСредство
	                      |ИЗ
	                      |	Документ.ПеремещениеОС.ОС КАК ТаблицаОС
	                      |ГДЕ
	                      |	ТаблицаОС.Ссылка = &Ссылка
	                      |	И ТаблицаОС.ОсновноеСредство.абс_ОбособленноеПодразделение <> &ОбособленноеПодразделение");
						  
	Запрос.УстановитьПараметр("Ссылка", 					СтруктураШапкиДокумента.Ссылка);						  
	Запрос.УстановитьПараметр("ОбособленноеПодразделение", 	ОбособленноеПодразделение);						  
	
	Если СтруктураШапкиДокумента.ВидДокумента = "ПринятиеКУчетуОС" Тогда  
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПеремещениеОС.ОС", "ПринятиеКУчетуОС.ОсновныеСредства");
	// Гущина T#7763513  2017.02.07 +++
	ИначеЕсли СтруктураШапкиДокумента.ВидДокумента = "абс_РазукрупнениеОС" Тогда  
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПеремещениеОС.ОС", "абс_РазукрупнениеОС.ОС");
	ИначеЕсли СтруктураШапкиДокумента.ВидДокумента = "ВводНачальныхОстатковОС" Тогда  
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПеремещениеОС.ОС", "ВводНачальныхОстатковОС.ОС");
	//Гущина  2017.02.07 ---
	КонецЕсли;
	
	ВыборкаОС = Запрос.Выполнить().Выбрать();
	Пока ВыборкаОС.Следующий() Цикл 
		
		ОбъектОС = ВыборкаОС.ОсновноеСредство.ПолучитьОбъект();
		//ОбъектОС.абс_ОбособленноеПодразделение = СтруктураШапкиДокумента.абс_Обособленное;
		ОбъектОС.абс_ОбособленноеПодразделение = ОбособленноеПодразделение;
		ОбъектОС.ОбменДанными.Загрузка = Истина;
		
		Попытка 
			ОбъектОС.Записать();
			
			// Гущина T#7763513  2017.01.11 +++   переношу из модуля объекта из ПриЗаписи  справочника Осн.средств. добавила &ДатаДокумента и период
			
			Запрос = Новый Запрос("ВЫБРАТЬ РАзрешенные
			|	абс_ИсторияИзмененияОбособленныхПодразделенийОС.ОбособленноеПодразделение,
			|	абс_ИсторияИзмененияОбособленныхПодразделенийОС.Период
			|ИЗ
			|	РегистрСведений.абс_ИсторияИзмененияОбособленныхПодразделенийОС.СрезПоследних(&ДатаДокумента
			|			,
			|			ОсновноеСредство = &ОС) КАК абс_ИсторияИзмененияОбособленныхПодразделенийОС");
			Запрос.УстановитьПараметр("ОС", ОбъектОС.ссылка);
			Запрос.УстановитьПараметр("ДатаДокумента", СтруктураШапкиДокумента.Ссылка.Дата);
			
			Выборка = Запрос.Выполнить().Выбрать();
			//Если Выборка.Следующий() и Выборка.ОбособленноеПодразделение <> СтруктураШапкиДокумента.абс_Обособленное и  Выборка.Период <> СтруктураШапкиДокумента.Ссылка.Дата 
			Если Выборка.Следующий() и Выборка.ОбособленноеПодразделение <> ОбособленноеПодразделение и  Выборка.Период <> СтруктураШапкиДокумента.Ссылка.Дата 
				ИЛИ Выборка.Количество() = 0 тогда
				НаборЗаписей = РегистрыСведений.абс_ИсторияИзмененияОбособленныхПодразделенийОС.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОсновноеСредство.Установить(ОбъектОС.ссылка);
				
				НаборЗаписей.Прочитать();
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = СтруктураШапкиДокумента.Ссылка.Дата; //было ТекущаяДата();
				НоваяЗапись.ОбособленноеПодразделение = ОбособленноеПодразделение;//СтруктураШапкиДокумента.абс_Обособленное;
				НоваяЗапись.ОсновноеСредство = ОбъектОС.ссылка;
				НаборЗаписей.Записать();
				
			//ИначеЕсли Выборка.ОбособленноеПодразделение <> СтруктураШапкиДокумента.абс_Обособленное и  Выборка.Период = СтруктураШапкиДокумента.Ссылка.Дата тогда	
			ИначеЕсли Выборка.ОбособленноеПодразделение <> ОбособленноеПодразделение и  Выборка.Период = СтруктураШапкиДокумента.Ссылка.Дата тогда	
				НаборЗаписей = РегистрыСведений.абс_ИсторияИзмененияОбособленныхПодразделенийОС.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОсновноеСредство.Установить(ОбъектОС.ссылка);
				НаборЗаписей.Отбор.Период.Установить(СтруктураШапкиДокумента.Ссылка.Дата);
				НаборЗаписей.Прочитать();
				Для Каждого СтрЗаписи из НаборЗаписей цикл
					СтрЗаписи.ОбособленноеПодразделение = ОбособленноеПодразделение;//СтруктураШапкиДокумента.абс_Обособленное;
				КонецЦикла;	
				НаборЗаписей.Записать();
			КонецЕсли;
			// Гущина T#7763513  2017.01.11 ---
		Исключение
			Сообщить("Обособленное подразделение в карточке ОС не изменено: " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
		
КонецПроцедуры