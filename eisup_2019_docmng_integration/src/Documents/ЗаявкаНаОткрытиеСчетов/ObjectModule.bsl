
Перем мОрганизация, мБанк;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Проведен Тогда
		ОбъектВБазе = Ссылка.ПолучитьОбъект();
		мОрганизация = ОбъектВБазе.Организация;
		мБанк = ОбъектВБазе.Банк;
		ОбработкаУдаленияПроведения(Ложь);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Банк", Банк);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
		
		МассивСотрудников = Новый Массив;
		Если ВводНачальныхСведений Тогда
			МассивСотрудников = РаботникиОрганизации.ВыгрузитьКолонку("ФизЛицо");
		Иначе
			
			Попытка
				ИсходноеДерево = ЗначениеИзСтрокиВнутр(ТекстПодтверждения);
			Исключение
				Возврат;
			КонецПопытки;
			
			Если ТипЗнч(ИсходноеДерево) <> Тип("ДеревоЗначений") Тогда
				Возврат;
			КонецЕсли;
			
			МассивОпераций = ПроцедурыУправленияПерсоналом.ПолучитьОперацииПоЛицевымСчетамРаботников(ИсходноеДерево, "РезультатОткрытияСчетов");
			 			
			Для каждого ОперацияПодтверждения из МассивОпераций Цикл
				
				МассивСотрудников.Добавить(ОперацияПодтверждения.Сотрудник);
				
			КонецЦикла;
			
		КонецЕсли;
	    Запрос.УстановитьПараметр("Сотрудники", МассивСотрудников);
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Представление(ЛицевыеСчетаРаботниковОрганизации.ФизЛицо) Как ФизЛицоНаименование
		               |ИЗ
		               |	РегистрСведений.ЛицевыеСчетаРаботниковОрганизации КАК ЛицевыеСчетаРаботниковОрганизации
		               |ГДЕ
		               |	ЛицевыеСчетаРаботниковОрганизации.Организация = &Организация
		               |	И ЛицевыеСчетаРаботниковОрганизации.Банк = &Банк
		               |	И ЛицевыеСчетаРаботниковОрганизации.Документ <> &ДокументСсылка
		               |	И ЛицевыеСчетаРаботниковОрганизации.ФизЛицо В (&Сотрудники)";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 0 Тогда
			СтрокаСообщения = " На указанных сотрудников уже введены данные:";
			Пока Выборка.Следующий() Цикл
				СтрокаСообщения = СтрокаСообщения + Символы.ПС + "    " + Выборка.ФизЛицоНаименование;
				
			КонецЦикла;
			Сообщить(СтрокаСообщения);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	НаборЛицевыхСчетов = РегистрыСведений.ЛицевыеСчетаРаботниковОрганизации.СоздатьНаборЗаписей();
	НаборЛицевыхСчетов.Отбор.Организация.Установить(Организация);
	НаборЛицевыхСчетов.Отбор.Банк.Установить(Банк);
	
	
	
	Если ВводНачальныхСведений Тогда
		Для каждого СтрокаСРаботником Из РаботникиОрганизации Цикл
			НаборЛицевыхСчетов.Отбор.ФизЛицо.Установить(СтрокаСРаботником.ФизЛицо);
			НаборЛицевыхСчетов.Прочитать();
			ЗаписьЛицевогоСчета = НаборЛицевыхСчетов.Добавить();
			ЗаписьЛицевогоСчета.Организация = Организация;
			ЗаписьЛицевогоСчета.Банк = Банк;
			ЗаписьЛицевогоСчета.ФизЛицо = СтрокаСРаботником.ФизЛицо;
			ЗаписьЛицевогоСчета.НомерЛицевогоСчета = СтрокаСРаботником.НомерЛицевогоСчета;
			ЗаписьЛицевогоСчета.Документ = Ссылка;
			НаборЛицевыхСчетов.Записать();
		КонецЦикла;
		
	Иначе
		
		Попытка
			ИсходноеДерево = ЗначениеИзСтрокиВнутр(ТекстПодтверждения);
		Исключение
			Возврат;
		КонецПопытки;
		
		Если ТипЗнч(ИсходноеДерево) <> Тип("ДеревоЗначений") Тогда
			Возврат;
		КонецЕсли;
		
				
		МассивОпераций = ПроцедурыУправленияПерсоналом.ПолучитьОперацииПоЛицевымСчетамРаботников(ИсходноеДерево, "РезультатОткрытияСчетов");
		
		ЗаполненныеФизЛица = Новый Соответствие;
		
		Для каждого ОперацияПодтверждения из МассивОпераций Цикл
			
			ЗаписьЛицевогоСчета = ЗаполненныеФизЛица[ОперацияПодтверждения.Сотрудник];
			НаборЛицевыхСчетов.Отбор.ФизЛицо.Установить(ОперацияПодтверждения.Сотрудник);
			НаборЛицевыхСчетов.Прочитать();
			Если ЗаписьЛицевогоСчета = Неопределено Тогда
				
				
				ЗаписьЛицевогоСчета = НаборЛицевыхСчетов.Добавить();
				ЗаписьЛицевогоСчета.Организация = Организация;
				ЗаписьЛицевогоСчета.Банк = Банк;
				ЗаписьЛицевогоСчета.ФизЛицо = ОперацияПодтверждения.Сотрудник;
				ЗаписьЛицевогоСчета.Документ = Ссылка;
				ЗаполненныеФизЛица.Вставить(ОперацияПодтверждения.Сотрудник, ЗаписьЛицевогоСчета);
			КонецЕсли;
			
			Если ВРЕГ(СтрЗаменить(ОперацияПодтверждения.Результат, " ", "")) = "СЧЕТОТКРЫТ" Тогда
				ЗаписьЛицевогоСчета.НомерЛицевогоСчета = ОперацияПодтверждения.ЛицевойСчет;
				
			Иначе
				ЗаполненныеФизЛица.Вставить(ОперацияПодтверждения.Сотрудник, Неопределено);
				НаборЛицевыхСчетов.Удалить(ЗаписьЛицевогоСчета);
				
			КонецЕсли;
			НаборЛицевыхСчетов.Записать();
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	НаборЛицевыхСчетов = РегистрыСведений.ЛицевыеСчетаРаботниковОрганизации.СоздатьНаборЗаписей();
	
	НаборЛицевыхСчетов.Отбор.Организация.Установить(мОрганизация);
	НаборЛицевыхСчетов.Отбор.Банк.Установить(мБанк);
	НаборЛицевыхСчетов.Прочитать();
	НомерЗаписиНабора = НаборЛицевыхСчетов.Количество() - 1;
	Пока НомерЗаписиНабора >= 0 Цикл
		Если НаборЛицевыхСчетов[НомерЗаписиНабора].Документ = Ссылка Тогда
			НаборЛицевыхСчетов.Удалить(НомерЗаписиНабора);
		КонецЕсли;
		НомерЗаписиНабора = НомерЗаписиНабора - 1
	КонецЦикла;

	НаборЛицевыхСчетов.Записать();
	
	ТекстПодтверждения = "";
КонецПроцедуры




