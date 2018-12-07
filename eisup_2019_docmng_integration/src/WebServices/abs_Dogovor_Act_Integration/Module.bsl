
Функция ChangeStatusDogovor(Number, ID, Status)
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	ОтветXDTO = Ложь;
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.ChangeStatusDogovor(Number, ID, Status);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика ChangeStatusDogovor()");
	КонецПопытки;
	
	Возврат ОтветXDTO; 
	
КонецФункции

Функция ChangeStatusAct(Number, ID, Status)
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	ОтветXDTO = Ложь;
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.ChangeStatusAct(Number, ID, Status);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика ChangeStatusAct()");
	КонецПопытки;
	
	Возврат ОтветXDTO; 

КонецФункции

Функция CreateDogovor(Number, Date, Data)
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	ОтветXDTO = Ложь;
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.CreateDogovor(Number, Date, Data);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика CreateDogovor()");
	КонецПопытки;
	
	Возврат ОтветXDTO; 

КонецФункции

Функция CreateAct(Number, Date, Data)
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	ОтветXDTO = Ложь;
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.CreateAct(Number, Date, Data);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика CreateAct()");
	КонецПопытки;
	
	Возврат ОтветXDTO; 

КонецФункции
