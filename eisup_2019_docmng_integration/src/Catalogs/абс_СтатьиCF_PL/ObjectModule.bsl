
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка или ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Если Модифицированность() Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;	
	КонецЕсли;	
	
КонецПроцедуры
