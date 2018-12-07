////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// В процедуре всем сотрудникам, которые есть в документе регистраторе,
// устанавливаются текущие данные без учета регистратора
// Это необходимо для корректной отработки отмены проведения документа
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПолныеПраваЗК.ЗаписатьТекущиеКадровыеДанныеСотрудникаОрганизации(Отказ, Замещение, Истина, Отбор.Регистратор.Значение);
	
КонецПроцедуры

// В процедуре всем сотрудникам, которые есть в документе регистраторе,
// устанавливаются текущие данные по данным регистратора
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПолныеПраваЗК.ЗаписатьТекущиеКадровыеДанныеСотрудникаОрганизации(Отказ, Замещение, Ложь, Отбор.Регистратор.Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
