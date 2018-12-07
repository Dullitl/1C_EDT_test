Перем КонтролироватьПорядок Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() 
	   И НазначениеСвойства <> Ссылка.НазначениеСвойства 
	   И ПолныеПрава.СвойстваОбъектов_СуществуютСсылки(Ссылка) Тогда

		Сообщить("Существуют объекты, которым назначено свойство """ + Наименование + """.
		         |Назначение свойства не может быть изменено, элемент не записан.", 
		         СтатусСообщения.Важное);

		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПередУдалением объекта.
//
Процедура ПередУдалением(Отказ)

	Если Предопределенный Тогда
		Сообщить("Не допускается удаление предопределенных элементов!",СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

КонтролироватьПорядок = Истина;
