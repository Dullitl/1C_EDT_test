
Функция DogovoryAdd(PackXDTO)
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.sample-package.org/", "Answer"));
	ОтветXDTO.Guid 	= "";
	//ОтветXDTO.Error = "";
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.СоздатьДоговор(PackXDTO);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика  создания договора по вебсервису");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
КонецФункции

Функция ТестСоединения()
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.sample-package.org/", "Answer"));
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	ОтветXDTO.Guid 	= Строка(ТипЗнч(ОбработчикWebService)) + " Соединение успешно выполнено!";
	//ОтветXDTO.Error = "";
	
	Возврат ОтветXDTO;
КонецФункции
