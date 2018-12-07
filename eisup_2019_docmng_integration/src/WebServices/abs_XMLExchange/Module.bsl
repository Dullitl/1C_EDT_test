Функция PutData(XMLData)
			
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("abs_XMLData", "Answer"));
		
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		ОтветXDTO = ОбработчикWebService.abs_XMLExchange_PutData(XMLData);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "abs_XMLExchange_PutData(XMLData)");
		ОтветXDTO.Error = "Ошибка вызова обработчика веб-сервиса abs_XMLExchange_PutData(XMLData): " + ОписаниеОшибки;
		ОтветXDTO.AnswerXMLString = "";
		ОтветXDTO.Result = Ложь;
	КонецПопытки;
	
	Возврат ОтветXDTO;
		
КонецФункции

Функция GetData()
	// Вставить содержимое обработчика.
КонецФункции
