
// Создает контрагента, возвращает код созданного элемента
Функция Добавить(PackXDTO)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));
	ОтветXDTO.ID 	= "";
	//ОтветXDTO.Error = "";
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.СоздатьКонтрагента(PackXDTO);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика согласования создания контрагента по вебсервису");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

Функция ТестСоединения()
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	ОтветXDTO.ID 	= Строка(ТипЗнч(ОбработчикWebService)) + " Соединение успешно выполнено!";
	//ОтветXDTO.Error = "";
	
	Возврат ОтветXDTO;
	
КонецФункции

Функция SpeedTest(Pack)
	
	Возврат Pack.Размер(); 
	
КонецФункции

// Возвращает список файлов контрагента
Функция GetCountragentsFileList(ID)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "FileList"));	
	//ОтветXDTO.Error = "";
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.GetCountragentsFileList(ID);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика GetCountragentsFileList(ID)");
		ОтветXDTO.Error = ОписаниеОшибки;
		//ОтветXDTO.FileDescription = NULL;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

// Запускает согласование ДЭБ 
Функция CountragentsDEB_Check(PackXDTO)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));	
	ОтветXDTO.ID 	= "";
	//ОтветXDTO.Error = "";
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.СогласованиеДЭБ(PackXDTO);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика получения файлов контрагента по вебсервису");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

Функция ВыполнитьFunction(Name, ID, XML)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));	
	//ОтветXDTO.Error = "";
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.ВыполнитьFunction(Name, ID, XML);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов функции " + Name + "(" + ID + ")");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

// Помещает файл контрагента
Функция PutCountragentsFile(ID, FileXDTO)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));	
	ОтветXDTO.ID 	= "";
	//ОтветXDTO.Error = "";
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.PutCountragentsFile(ID, FileXDTO);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика PutCountragentsFile(ID, FileXDTO)");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

// Возвращает файл контрагента по его Name
Функция GetCountragentsFile(ID, Name)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "File"));	
	//ОтветXDTO.File  = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "File"));;
	//ОтветXDTO.Error = "";
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.GetCountragentsFile(ID, Name);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика GetCountragentsFile(ID, File_ID)");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

// Создает заявку на изменение контрагента
Функция CountragentsChangeRequest(PackXDTO,NumberDoc)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "Answer"));	
	ОтветXDTO.ID 	= "";
	//ОтветXDTO.Error = "";
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.CountragentsChangeRequest(PackXDTO,NumberDoc);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика получения файлов контрагента по вебсервису");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции

// Start КТТК Ермолов Е.Л.  18.03.2016 Получить баланс взаиморасчетов по документу
Функция GetBalance(OrderNumber)
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "AnswerBalance"));
	ОтветXDTO.Sum 	= 0;
	Если Не ЗначениеЗаполнено(OrderNumber) Тогда 
		ОтветXDTO.Error = "В сервис не передан номер документа";
		Возврат ОтветXDTO;
	КонецЕсли;	
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		// Вызов обработчика
		ОтветXDTO = ОбработчикWebService.ПолучитьБаланс(OrderNumber);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		абс_WebService.СообщитьОбОшибке(ОписаниеОшибки, "Вызов обработчика вебсервиса получения баланса");
		ОтветXDTO.Error = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат ОтветXDTO;
КонецФункции

Функция GetBalanceByDogID(DogID, Dt)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.abs-soft.ru/", "AnswerBalance"));
	ОтветXDTO.Sum = 0;
	ОтветXDTO.Error = "";
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка		
		ОтветXDTO = ОбработчикWebService.ПолучитьБалансПоДоговору(DogID, Dt);
	Исключение
		ОтветXDTO.Sum = 0;
		ОтветXDTO.Error = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат ОтветXDTO;

КонецФункции

Функция SetContactInfo(ID, ContactInfo)
	
	ОтветXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://transtk.ru", "Response"));
	ОтветXDTO.RC = 0;
	ОтветXDTO.Msg = "";
	
	ОбработчикWebService = абс_WebService.ПолучитьОбработчикWebService();
	
	Попытка 
		ОтветXDTO = ОбработчикWebService.ОбновитьКонтактнуюИнформациюКонтрагента(ID, ContactInfo);
	Исключение
		ОтветXDTO.RC = -99;
		ОтветXDTO.Msg = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат ОтветXDTO;
	
КонецФункции


