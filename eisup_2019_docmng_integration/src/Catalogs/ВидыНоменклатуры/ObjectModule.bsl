// Обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не  ЗначениеЗаполнено(ТипНоменклатуры) Тогда
		ТекстСообщения = "Необходимо указать тип номенклатуры!";
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;

	СуществуютСсылки = Неопределено;
	Если НЕ ЭтоНовый() 
	   И ТипНоменклатуры <> Ссылка.ТипНоменклатуры 
	   И ПолныеПрава.ВидыНоменклатуры_СуществуютСсылкиВНоменклатуре(Ссылка, СуществуютСсылки) Тогда
		ТекстСообщения = "Вид номенклатуры """ + СокрЛП(Ссылка) + """ выбран в элементах справочника ""Номенклатура"".
		|Тип не может быть изменен!";
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

