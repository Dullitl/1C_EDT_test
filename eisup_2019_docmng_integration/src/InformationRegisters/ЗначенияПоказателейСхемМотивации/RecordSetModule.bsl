
Процедура Автозаполнение(ТаблицаЗапроса = Неопределено, Сотрудники = Неопределено, Показатели = Неопределено, ОдинВидРасчета = Ложь, ИзДокумента = Ложь) Экспорт
	
	Результат = ЗначенияПоказателейСхемМотивацииПереопределяемый.Автозаполнение(Отбор.Организация.Значение, Отбор.ПериодДействия.Значение, ТаблицаЗапроса, Сотрудники, Показатели, ОдинВидРасчета, ИзДокумента);
	
	Если Результат <> Неопределено Тогда
		ЭтотОбъект.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры // Автозаполнение

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияПоказателейСхемМотивацииПереопределяемый.ПриЗаписи(Отбор, Отказ, Замещение);
	
КонецПроцедуры

