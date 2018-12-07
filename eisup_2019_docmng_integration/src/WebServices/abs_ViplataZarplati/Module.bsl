
Функция CreateVedomost(Number, Date, Data)
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService(); 
	 Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.CreateVedomost(Number, Date, Data);				
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика CreateVedomost()");
	КонецПопытки;
	
	Возврат ОтветXDTO;
КонецФункции
