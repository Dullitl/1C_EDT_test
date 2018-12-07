Перем СохраненнаяНастройка Экспорт;
Перем ИДКонфигурации Экспорт;

#Если Клиент Тогда

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить();

	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметраОрганизация = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	
	Если ЗначениеПараметраНачалоПериода <> Неопределено Тогда
		ЗначениеПараметраНачалоПериода.Значение = НачалоПериода;
		ЗначениеПараметраНачалоПериода.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраКонецПериода <> Неопределено Тогда
		ЗначениеПараметраКонецПериода.Значение = ?(КонецПериода = '00010101', КонецПериода, КонецДня(КонецПериода));
		ЗначениеПараметраКонецПериода.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраОрганизация <> Неопределено Тогда
		ЗначениеПараметраОрганизация.Значение = Организация;
		ЗначениеПараметраОрганизация.Использование = Истина;
	КонецЕсли;

	ЗначениеПараметраСчетДтР1 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетДтР1"));
	ЗначениеПараметраСчетКтР1 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетКтР1"));
	ЗначениеПараметраСчетДтР2 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетДтР2"));
	ЗначениеПараметраСчетКтР2 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетКтР2"));
	ЗначениеПараметраСчетДтР3 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетДтР3"));
	ЗначениеПараметраСчетКтР3 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СчетКтР3"));
	
	// Формирование списков счетов для реализации алгоритма отбора расходов в различных конфигурациях
	//
	СписокСчетовВсе  = Новый СписокЗначений;
	СписокСчетовДтР1 = Новый СписокЗначений;
	СписокСчетовКтР1 = Новый СписокЗначений;
	СписокСчетовДтР2 = Новый СписокЗначений;
	СписокСчетовКтР2 = Новый СписокЗначений;
	СписокСчетовДтР3 = Новый СписокЗначений;
	СписокСчетовКтР3 = Новый СписокЗначений;
	
	Если ИДКонфигурации = "БГУ" Тогда
		
		ПланСчетовУчета =  ПланыСчетов["ЕПСБУ"];
		
		СписокСчетовВсе.Добавить(ПланСчетовУчета.ПустаяСсылка());
		
		// Раздел 1
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "Медикаменты_ОЦДИ", "105.21");                             //105.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ПродуктыПитания_ОЦДИ", "105.22");                         //105.22
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ГСМ_ОЦДИ", "105.23");                                     //105.23
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "СтроительныеМатериалы_ОЦДИ", "105.24");                   //105.24
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "МягкийИнвентарь_ОЦДИ", "105.25");                         //105.25
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ПрочиеМЗ_ОЦДИ", "105.26");                                //105.26
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "Медикаменты_ИДИ", "105.31");                              //105.31
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ПродуктыПитания_ИДИ", "105.32");                          //105.32
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ГСМ_ИДИ", "105.33");                                      //105.33
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "СтроительныеМатериалы_ИДИ", "105.34");                    //105.34
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "МягкийИнвентарь_ИДИ", "105.35");                          //105.35
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ПрочиеМЗ_ИДИ", "105.36");                                 //105.36
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "СтроительныеМатериалы_ПЛ", "105.44");                     //105.44
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ПрочиеМЗ_ПЛ", "105.46");                                  //105.46
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ВложенияВ_МЗ_ОЦДИ_Покупка", "106.2П");                    //106.2П
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ВложенияВ_МЗ_ИДИ_Покупка", "106.3П");                     //106.3П
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ВложенияВ_МЗ_ПЛ_Покупка", "106.4П");                      //106.4П
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицами_Услуги", "208.20");            //208.20
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "Расчеты_Услуги", "302.20");                               //302.20
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицами_МЗ", "208.34");                //208.34
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "Расчеты_МЗ", "302.34");                                   //302.34
		
		// Раздел 2
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "СебестоимостьГП", "109.60");                              //109.60
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "НакладныеРасходы", "109.70");                             //109.70
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицами_Услуги", "208.20");            //208.20
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "Расчеты_Услуги", "302.20");                               //302.20
		
		// Раздел 3
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР3, ПланСчетовУчета, "ОбщехозяйственныеРасходы", "109.80");                     //109.80
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР3, ПланСчетовУчета, "ИздержкиОбращения", "109.90");                            //109.90
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицами_Услуги", "208.20");            //208.20
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "Расчеты_Услуги", "302.20");                               //302.20
		
	Иначе
		
		ПланСчетовУчета =  ПланыСчетов["Хозрасчетный"];
		
		СписокСчетовВсе.Добавить(ПланСчетовУчета.ПустаяСсылка());
		
		// Раздел 1
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "Материалы", "10");                                        //10.*
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ЖивотныеНаВыращиванииИОткорме", "11");                    //11.*
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР1, ПланСчетовУчета, "ЗаготовлениеИПриобретениеМЦ", "15");                      //15.*
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПоставщиками", "60.01");                          //60.01
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПоставщикамиВал", "60.21");                       //60.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПоставщикамиУЕ", "60.31");                        //60.31
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоКраткосрочнымКредитам", "66.02");               //66.02
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоКраткосрочнымЗаймам", "66.04");                 //66.04
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоКраткосрочнымКредитамВал", "66.22");            //66.22
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоКраткосрочнымЗаймамВал", "66.24");              //66.24
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоДолгосрочнымКредитам", "67.02");                //67.02
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоДолгосрочнымЗаймам", "67.04");                  //67.04
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоДолгосрочнымКредитамВал", "67.22");             //67.22
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПроцентыПоДолгосрочнымЗаймамВал", "67.24");               //67.24
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицами", "71.01");                    //71.01
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПодотчетнымиЛицамиВал", "71.21");                 //71.21
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованию", "76.01.1");  //76.01.1
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчиками", "76.05");      //76.05
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторами", "76.09");   //76.09
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованиюВал", "76.21"); //76.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиВал", "76.25");   //76.25
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал", "76.29");//76.29
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ", "76.35");    //76.35
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР1, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ", "76.39"); //76.39
		
		// Раздел 2
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "ОсновноеПроизводство", "20.01");                          //20.01
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "ПроизводствоИзДавальческогоСырья", "20.02");              //20.02
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "ВспомогательныеПроизводства", "23");                      //23 
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР2, ПланСчетовУчета, "ИздержкиОбращения", "44.01");                             //44.01
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПоставщиками", "60.01");                          //60.01
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПоставщикамиВал", "60.21");                       //60.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПоставщикамиУЕ", "60.31");                        //60.31
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованию", "76.01.1");  //76.01.1
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчиками", "76.05");      //76.05
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторами", "76.09");   //76.09
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованиюВал", "76.21"); //76.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиВал", "76.25");   //76.25
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал", "76.29");//76.29
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ", "76.35");    //76.35
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР2, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ", "76.39"); //76.39
		
		// Раздел 3
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР3, ПланСчетовУчета, "ОбщепроизводственныеРасходы", "25");                      //25
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР3, ПланСчетовУчета, "ОбщехозяйственныеРасходы", "26");                         //26
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовДтР3, ПланСчетовУчета, "КоммерческиеРасходы", "44.02");                           //44.02
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПоставщиками", "60.01");                          //60.01
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПоставщикамиВал", "60.21");                       //60.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПоставщикамиУЕ", "60.31");                        //60.31
		
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованию", "76.01.1");  //76.01.1
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчиками", "76.05");      //76.05
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторами", "76.09");   //76.09
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыПоИмущественномуИЛичномуСтрахованиюВал", "76.21"); //76.21
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиВал", "76.25");   //76.25
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал", "76.29");//76.29
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ", "76.35");    //76.35
		ДобавитьПредопределенныйСчетВСписок(СписокСчетовКтР3, ПланСчетовУчета, "ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ", "76.39"); //76.39
		
	КонецЕсли;
	
	Если ЗначениеПараметраСчетДтР1 <> Неопределено Тогда
		ЗначениеПараметраСчетДтР1.Значение = ?(СписокСчетовДтР1.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовДтР1);
		ЗначениеПараметраСчетДтР1.Использование = Истина;
	КонецЕсли;
	Если ЗначениеПараметраСчетКтР1 <> Неопределено Тогда
		ЗначениеПараметраСчетКтР1.Значение = ?(СписокСчетовКтР1.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовКтР1);
		ЗначениеПараметраСчетКтР1.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраСчетДтР2 <> Неопределено Тогда
		ЗначениеПараметраСчетДтР2.Значение = ?(СписокСчетовДтР2.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовДтР2);
		ЗначениеПараметраСчетДтР2.Использование = Истина;
	КонецЕсли;
	Если ЗначениеПараметраСчетКтР2 <> Неопределено Тогда
		ЗначениеПараметраСчетКтР2.Значение = ?(СписокСчетовКтР2.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовКтР2);
		ЗначениеПараметраСчетКтР2.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраСчетДтР3 <> Неопределено Тогда
		ЗначениеПараметраСчетДтР3.Значение = ?(СписокСчетовДтР3.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовДтР3);
		ЗначениеПараметраСчетДтР3.Использование = Истина;
	КонецЕсли;
	Если ЗначениеПараметраСчетКтР3 <> Неопределено Тогда
		ЗначениеПараметраСчетКтР3.Значение = ?(СписокСчетовКтР3.Количество() = 0, СписокСчетовВсе.Скопировать(), СписокСчетовКтР3);
		ЗначениеПараметраСчетКтР3.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПредопределенныйСчетВСписок(СписокСчетов, ПланСчетовУч, ИмяПредопределенного, КодСчета)
	
	Попытка
		
		ПредопределенныйСчет = ПланСчетовУч[ИмяПредопределенного];
		СписокСчетов.Добавить(ПредопределенныйСчет);
		
	Исключение
		
		НайденныйСчет = ПланСчетовУч.НайтиПоКоду(КодСчета);
		
		Если НайденныйСчет <> Неопределено Тогда
			Если НЕ НайденныйСчет.Пустая() Тогда
				
				СписокСчетов.Добавить(НайденныйСчет);
				
				Возврат;
				
			КонецЕсли;
		КонецЕсли;
		
		Сообщить("Не найден счет " + КодСчета + ?(ПустаяСтрока(ИмяПредопределенного), "", " (""" + ИмяПредопределенного + """)"), СтатусСообщения.Внимание);
		
	КонецПопытки;
	
	
КонецПроцедуры 

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВТаблицуЗначений = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Если ИДКонфигурации = "БГУ" Тогда
			Сообщить("Не выбрано учреждение. Отчет не формируется.", СтатусСообщения.Внимание);
		Иначе
			Сообщить("Не выбрана организация. Отчет не формируется.", СтатусСообщения.Внимание);
		КонецЕсли;
		
		Возврат;
	
	КонецЕсли;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ДоработатьКомпоновщикПередВыводом();
	КомпоновщикНастроек.Восстановить();
	
	НастройкаКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	Если НастройкаКомпоновкиДанных = Неопределено Тогда 
		НастройкаКомпоновкиДанных = КомпоновщикНастроек.Настройки;
	КонецЕсли;
	
	ПараметрЗаголовок = НастройкаКомпоновкиДанных.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрЗаголовок <> Неопределено Тогда
		ПараметрЗаголовок.Значение = ПолучитьТекстЗаголовка();
		ПараметрЗаголовок.Использование = Истина;
	КонецЕсли; 
	
	//Сгенерируем макет компоновки данных при помощи компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
	
		Если ВыводВТаблицуЗначений Тогда
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкаКомпоновкиДанных, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		Иначе
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкаКомпоновкиДанных, ДанныеРасшифровки);
		КонецЕсли;
		
		//Вызываем событие отчета
		ПередВыводомОтчета(МакетКомпоновки, ВыводВТаблицуЗначений);
		
		//Создадим и инициализируем процессор компоновки
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		
		Если ВыводВТаблицуЗначений Тогда
			
			Если ВнешниеНаборыДанных = Неопределено Тогда
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			Иначе
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, , Истина);
			КонецЕсли;
			
			ДанныеОтчета.Очистить();
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.ОтображатьПроцентВывода = Истина;
			ДанныеОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
		Иначе
			
			Если ВнешниеНаборыДанных = Неопределено Тогда
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
			Иначе
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
			КонецЕсли;
			
			Если Результат.ФиксацияСлева > 0 Тогда
				 Результат.ФиксацияСлева = 0;
			КонецЕсли; 
			Если Результат.ФиксацияСверху > 0 Тогда
				 Результат.ФиксацияСверху = 0;
			КонецЕсли; 
			
			Результат.Очистить();
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
			ПроцессорВывода.ОтображатьПроцентВывода = Истина;
			ПроцессорВывода.УстановитьДокумент(Результат);
			
			//Обозначим начало вывода
			ПроцессорВывода.НачатьВывод();
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			Если Результат.ФиксацияСверху = 0 Тогда
				 Результат.ФиксацияСверху = 12;
			КонецЕсли; 
			
		КонецЕсли;
		
	Исключение
		
		Вопрос("Отчет не сформирован!" + Символы.ПС + ИнформацияОбОшибке().Описание, РежимДиалогаВопрос.ОК);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки, ВыводВТаблицуЗначений) Экспорт
	
	Если ВыводВТаблицуЗначений Тогда
		Возврат;
	КонецЕсли;
	
	ШрифтЗаголовка = МакетКомпоновки.Макеты[0].Макет[0].Ячейки[0].Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Шрифт"));
	ИзмененныйШрифт = Новый Шрифт(ШрифтЗаголовка.Значение, , 13);
	ШрифтЗаголовка.Значение = ИзмененныйШрифт;
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	//
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	СхемаКомпоновкиДанных.Параметры.ВыводитьЗабалансовыеСчета.Значение = Ложь;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Для Каждого Параметр Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		
		Параметр.Использование = Истина;
		
	КонецЦикла;
	
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметраОрганизация = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	ЗначениеПараметраВыводитьЗабалансовыеСчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗабалансовыеСчета"));
	
	Если ЗначениеПараметраНачалоПериода <> Неопределено Тогда
		ЗначениеПараметраНачалоПериода.Значение = НачалоПериода;
		ЗначениеПараметраНачалоПериода.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраКонецПериода <> Неопределено Тогда
		ЗначениеПараметраКонецПериода.Значение = ?(КонецПериода = '00010101', КонецПериода, КонецДня(КонецПериода));
		ЗначениеПараметраКонецПериода.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраОрганизация <> Неопределено Тогда
		ЗначениеПараметраОрганизация.Значение = Организация;
		ЗначениеПараметраОрганизация.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраВыводитьЗабалансовыеСчета <> Неопределено Тогда
		ЗначениеПараметраВыводитьЗабалансовыеСчета.Значение = ВыводитьЗабалансовыеСчета;
		ЗначениеПараметраВыводитьЗабалансовыеСчета.Использование = Истина;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	Если НачалоПериода > КонецПериода Тогда
		 КонецПериода =  НачалоПериода;
	КонецЕсли;

	НачПериода    = ?(ЗначениеЗаполнено(НачалоПериода), НачалоДня(НачалоПериода), '00010101');
	КонПериода = ?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), '00010101');
	
	ЗаголовокОтчета = "Сведения о расходах на производство и продажу продукции за " + ПредставлениеПериода(НачПериода, КонПериода, "ФП = Истина");

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + ?(ПустаяСтрока(Строка(Организация)), "", "(" + Строка(Организация) + ")"));
	
КонецФункции

// Для настройки отчета
Процедура Настроить() Экспорт
	
	ЗаполнитьНачальныеНастройки();
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураПараметров = Новый Структура;
	Для каждого Реквизит Из ЭтотОбъект.Метаданные().Реквизиты Цикл
		Если Найти(Реквизит.Имя, "СхемаКомпоновкиДанных") > 0
			ИЛИ Реквизит.Имя = "ДатаВерсииИсточникаДанных"
			ИЛИ Реквизит.Имя = "ИсточникДанныхОтчета"
			ИЛИ Реквизит.Имя = "Описание" Тогда
			Продолжить;
		КонецЕсли;
		СтруктураПараметров.Вставить(Реквизит.Имя, ЭтотОбъект[Реквизит.Имя]);
	КонецЦикла;
	
	СтруктураПараметров.Вставить("НастройкиКомпоновщика", КомпоновщикНастроек.ПолучитьНастройки());
	СтруктураПараметров.Вставить("Версия", "1.0");
	
	СсылкаНаОбъект = "ОтчетОбъект." + Метаданные().Имя;
	
	Если СохраненнаяНастройка = Неопределено Тогда
		
		Пользователи = Новый Массив;
		Пользователи.Добавить(ПараметрыСеанса.ТекущийПользователь);
		Пользователи.Добавить(Справочники.ГруппыПользователей.ВсеПользователи);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
		|	СохраненныеНастройки.Ссылка КАК СохраненнаяНастройка
		|ИЗ
		|	Справочник.СохраненныеНастройки.Пользователи КАК СохраненныеНастройкиПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СохраненныеНастройки КАК СохраненныеНастройки
		|		ПО СохраненныеНастройкиПользователи.Ссылка = СохраненныеНастройки.Ссылка
		|ГДЕ
		|	СохраненныеНастройки.ИспользоватьПриОткрытии = ИСТИНА
		|	И СохраненныеНастройки.НастраиваемыйОбъект = &НастраиваемыйОбъект
		|	И СохраненныеНастройкиПользователи.Пользователь В(&Пользователи)
		|	И (НЕ СохраненныеНастройки.ПометкаУдаления)";
		
		Запрос.УстановитьПараметр("Пользователи", Пользователи);
		Запрос.УстановитьПараметр("НастраиваемыйОбъект", СсылкаНаОбъект);
		ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
		
		Если ТаблицаРезультата.Количество() > 0 Тогда
			СохраненнаяНастройка = ТаблицаРезультата[0].СохраненнаяНастройка;
		Иначе
			Настройка = Справочники.СохраненныеНастройки.СоздатьЭлемент();
			Настройка.НастраиваемыйОбъект = СсылкаНаОбъект;
			Настройка.ТипНастройки = Перечисления.ТипыНастроек.НастройкиПользователяНастройкиОтчета;
			Настройка.Наименование = "НастройкиПользователяНастройкиОтчета";
			Настройка.ИспользоватьПриОткрытии = Истина;
			НовыйПользователь = Настройка.Пользователи.Добавить();
			НовыйПользователь.Пользователь = глЗначениеПеременной("глТекущийПользователь");
			Настройка.Записать();
			
			СохраненнаяНастройка = Настройка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	ОбъектСохраненнаяНастройка = СохраненнаяНастройка.ПолучитьОбъект();
	
	Если СохраненнаяНастройка.Предопределенный тогда
		СтруктураПараметров.Вставить("Изменялась", истина);
	КонецЕсли;
	
	ОбъектСохраненнаяНастройка.ХранилищеНастроек = Новый ХранилищеЗначения(СтруктураПараметров);
	
	Попытка
		ОбъектСохраненнаяНастройка.Записать();
	Исключение
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Настройка формы не записана:" + Символы.ПС + "- " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если НЕ ЗначениеЗаполнено(СохраненнаяНастройка) Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	
	Если СтруктураПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураПараметров);
	
	ИнициализацияОтчета();
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураПараметров.НастройкиКомпоновщика);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	Если НЕ ЗначениеЗаполнено(СохраненнаяНастройка) Тогда
		
		Если Месяц(ТекущаяДата()) < 4 Тогда
			НачалоПериода = НачалоГода(НачалоГода(ТекущаяДата())-1);
			КонецПериода  = КонецГода(НачалоГода(ТекущаяДата())-1);
		Иначе
			НачалоПериода = НачалоГода(ТекущаяДата());
			КонецПериода  = КонецМесяца(ТекущаяДата());
		КонецЕсли;
		
		Если ИДКонфигурации = "БГУ" Тогда
			Организация  = глЗначениеПеременной("глТекущийРазделительУчета");
		ИначеЕсли ИДКонфигурации = "УПП" ИЛИ ИДКонфигурации = "КА" Тогда
			Организация  = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Иначе
			Организация  = глЗначениеПеременной("ОсновнаяОрганизация");
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуОрганизаций(ФормаОтчета) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НаборОрганизаций.Организация КАК Организация,
	|	НаборОрганизаций.ОрганизацияПредставление КАК ОрганизацияПредставление
	|ИЗ
	|	(ВЫБРАТЬ
	|		Организации.Ссылка КАК Организация,
	|		Организации.Наименование КАК ОрганизацияПредставление
	|	ИЗ
	|		Справочник.Организации КАК Организации
	|	) КАК НаборОрганизаций
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПредставление";
	
	ФормаОтчета.ТаблицаОрганизаций = Запрос.Выполнить().Выгрузить();
	СписокВыбора = Новый СписокЗначений;
	МаксКоличествоСимволов = 40;
	Для Каждого СтрокаТаблицы Из ФормаОтчета.ТаблицаОрганизаций Цикл
		СписокВыбора.Добавить(ФормаОтчета.ТаблицаОрганизаций.Индекс(СтрокаТаблицы), СтрокаТаблицы.ОрганизацияПредставление);
		МаксКоличествоСимволов = Макс(МаксКоличествоСимволов, СтрДлина(СтрокаТаблицы.ОрганизацияПредставление));
	КонецЦикла;
	ФормаОтчета.ЭлементыФормы.Организация.СписокВыбора = СписокВыбора;
	ФормаОтчета.ЭлементыФормы.Организация.ШиринаСпискаВыбора = Окр(?(МаксКоличествоСимволов > 200, 200, МаксКоличествоСимволов) * 1.3);
	ФормаОтчета.ЭлементыФормы.Организация.ВысотаСпискаВыбора = ?(ФормаОтчета.ТаблицаОрганизаций.Количество() > 15, 15, ФормаОтчета.ТаблицаОрганизаций.Количество());
	
	СтрокаПоиска = ФормаОтчета.ТаблицаОрганизаций.НайтиСтроки(Новый Структура("Организация", ФормаОтчета.Организация));
	
	Если СтрокаПоиска.Количество() = 1 Тогда
		ФормаОтчета.ПолеОрганизация = ФормаОтчета.ТаблицаОрганизаций.Индекс(СтрокаПоиска[0]);
	КонецЕсли; 

КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Неопределено;
	
КонецФункции


НастройкаПериода = Новый НастройкаПериода;

Если Метаданные.РегистрыСведений.Найти("ИдентификацияРасходовНаПроизводствоИПродажуПоОКПД") <> Неопределено Тогда
	
	ИДКонфигурации = РегламентированнаяОтчетность.ИДКонфигурации();
	Если ИДКонфигурации = "БГУ" Тогда
		СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанныхЕПСБУ");
	Иначе
		СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанныхХозрасчетный");
	КонецЕсли; 
	
КонецЕсли;

#КонецЕсли