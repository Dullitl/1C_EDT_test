Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Забалансовый = 0 Тогда
		Забалансовый = 1;
	КонецЕсли;

	Порядок = ПолучитьПорядокКода();
	
КонецПроцедуры