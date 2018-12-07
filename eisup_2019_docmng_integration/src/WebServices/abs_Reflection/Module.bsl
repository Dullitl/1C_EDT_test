
Функция CreateUpdateReflectionZP(Data)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("Reflection", "Answer"));
	ОтветXDTO.Error = "";
	ОтветXDTO.Result = Ложь;
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.CreateUpdateReflectionZP(Data);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика CreateUpdateReflectionZP(Data)");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;

КонецФункции
