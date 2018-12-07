
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ КАДРОВОГО УЧЕТА

// Функция осуществляет проверку дублей в справочнике ФизическиеЛица
// Проверка происходит по паспортным данным, ИНН, ПФР и ФИО
//
// Возвращаемое значение
//		Список значений с сообщениями
//
Функция ПроверитьДублиФизлиц(Ссылка, ЗаписьПаспортныхДанных = Неопределено, ИНН, ПФР, ФИО) Экспорт
	
	ТаблицаСообщений = Новый ТаблицаЗначений;
	ТаблицаСообщений.Колонки.Добавить("ТекстСообщения");
	ТаблицаСообщений.Колонки.Добавить("Физлицо");
	
	ЕстьДублиПаспортныхДанных	= Ложь;
	ЕстьДублиИНН				= Ложь;
	ЕстьДублиПФР				= Ложь;
	
	Если ЗаписьПаспортныхДанных <> Неопределено И (
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументВид) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументСерия) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументНомер) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументДатаВыдачи) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументКодПодразделения)) Тогда
		
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",						Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ДокументВид",				ЗаписьПаспортныхДанных.ДокументВид);
		ЗапросПоДублям.УстановитьПараметр("ДокументСерия",				ЗаписьПаспортныхДанных.ДокументСерия);
		ЗапросПоДублям.УстановитьПараметр("ДокументНомер",				ЗаписьПаспортныхДанных.ДокументНомер);
		ЗапросПоДублям.УстановитьПараметр("ДокументДатаВыдачи",			ЗаписьПаспортныхДанных.ДокументДатаВыдачи);
		ЗапросПоДублям.УстановитьПараметр("ДокументКодПодразделения",	ЗаписьПаспортныхДанных.ДокументКодПодразделения);
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПаспортныеДанныеФизЛиц.ФизЛицо
		|ИЗ
		|	РегистрСведений.ПаспортныеДанныеФизЛиц КАК ПаспортныеДанныеФизЛиц
		|ГДЕ
		|	ПаспортныеДанныеФизЛиц.ФизЛицо <> &Ссылка
		|	И ПаспортныеДанныеФизЛиц.ДокументВид = &ДокументВид
		|	И ПаспортныеДанныеФизЛиц.ДокументСерия = &ДокументСерия
		|	И ПаспортныеДанныеФизЛиц.ДокументНомер = &ДокументНомер
		|	И ПаспортныеДанныеФизЛиц.ДокументДатаВыдачи = &ДокументДатаВыдачи
		|	И ПаспортныеДанныеФизЛиц.ДокументКодПодразделения = &ДокументКодПодразделения";
		
		ВыборкаЗапроса = ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			ТекстСообщения = "Физлицо: %% имеет такие же паспортные данные как и у "+Строка(Ссылка);
			НоваяСтрока = ТаблицаСообщений.Добавить();
			НоваяСтрока.ТекстСообщения = ТекстСообщения;
			НоваяСтрока.Физлицо = ВыборкаЗапроса.Физлицо;
			ЕстьДублиПаспортныхДанных = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИНН) Тогда
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",	Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ИНН",	ИНН);
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФизическиеЛица.Ссылка КАК Физлицо
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Ссылка <> &Ссылка
		|	И ФизическиеЛица.ИНН = &ИНН";
		
		ВыборкаЗапроса = ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			ТекстСообщения = "Физлицо: %% имеет такой же ИНН как и у "+Строка(Ссылка);
			НоваяСтрока = ТаблицаСообщений.Добавить();
			НоваяСтрока.ТекстСообщения = ТекстСообщения;
			НоваяСтрока.Физлицо = ВыборкаЗапроса.Физлицо;
			ЕстьДублиИНН = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Число("0"+СтрЗаменить(СтрЗаменить(ПФР, "-", ""), " ", ""))) Тогда
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",	Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ПФР",	ПФР);
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФизическиеЛица.Ссылка КАК Физлицо
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Ссылка <> &Ссылка
		|	И ФизическиеЛица.СтраховойНомерПФР = &ПФР";
		
		ВыборкаЗапроса = ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			ТекстСообщения = "Физлицо: %% имеет такой же страховой номер ПФР как и у "+Строка(Ссылка);
			НоваяСтрока = ТаблицаСообщений.Добавить();
			НоваяСтрока.ТекстСообщения = ТекстСообщения;
			НоваяСтрока.Физлицо = ВыборкаЗапроса.Физлицо;
			ЕстьДублиПФР = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФИО) И
		 НЕ ЕстьДублиИНН И
		 НЕ ЕстьДублиПаспортныхДанных И
		 НЕ ЕстьДублиПФР Тогда
		 
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",	Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ФИО",	СтрЗаменить(ФИО, " ", ""));
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФИОФизЛиц.ФизЛицо
		|ИЗ
		|	РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
		|ГДЕ
		|	ФИОФизЛиц.ФизЛицо <> &Ссылка
		|	И ФИОФизЛиц.Фамилия + ФИОФизЛиц.Имя + ФИОФизЛиц.Отчество = &ФИО";
		
		ВыборкаЗапроса 				= ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			ТекстСообщения = "Физлицо с таким ФИО (%%) уже есть в справочнике";
			НоваяСтрока = ТаблицаСообщений.Добавить();
			НоваяСтрока.ТекстСообщения = ТекстСообщения;
			НоваяСтрока.Физлицо = ВыборкаЗапроса.Физлицо;
			ЕстьДублиПаспортныхДанных = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТаблицаСообщений;
	
КонецФункции

// Вычисляет количество временно освобожденных ставок для переданных строк штатного
// 	расписания на указанные в строках даты
//
// Параметры
//  ТаблицаСтрок - Таблица значений с колонками НомерСтроки, ДатаНачала, ПодразделениеОрганизации, Должность
//  ГоловнаяОрганизация - СправочникСсылка.Организации - головная организация документа
//
// Возвращаемое значение:
//   Таблица значений с колонками НомерСтроки, ОсвобожденныеСтавки 
//
Функция ВременноСвободныеСтавкиСтрокШтатногоРасписания(ТаблицаСтрок, ГоловнаяОрганизация) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ДанныеДокумента", ТаблицаСтрок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаботникиДокумента.НомерСтроки КАК НомерСтроки,
	|	РаботникиДокумента.ДатаНачала,
	|	РаботникиДокумента.ПодразделениеОрганизации,
	|	РаботникиДокумента.Должность
	|ПОМЕСТИТЬ ВТСтрокиДокумента
	|ИЗ
	|	&ДанныеДокумента КАК РаботникиДокумента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерСтроки";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.ДатаНачала,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаНачала
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	ДатыПоследнихДвиженийРаботников.Сотрудник
	|ПОМЕСТИТЬ ВТСотрудникиНаШтатныхЕдиницах
	|ИЗ
	|	ВТСтрокиДокумента КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(Работники.Период) КАК Период,
	|			Работники.Сотрудник КАК Сотрудник
	|		ИЗ
	|			ВТСтрокиДокумента КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|				ПО ТЧРаботникиОрганизации.ДатаНачала >= Работники.Период
	|		ГДЕ
	|			Работники.Организация = &ГоловнаяОрганизация
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки,
	|			Работники.Сотрудник) КАК ДатыПоследнихДвиженийРаботников
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|			ПО ДатыПоследнихДвиженийРаботников.Период = ДанныеПоРаботникуДоНазначения.Период
	|				И ДатыПоследнихДвиженийРаботников.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыПоследнихДвиженийРаботников.НомерСтроки
	|ГДЕ
	|	ТЧРаботникиОрганизации.ПодразделениеОрганизации = ВЫБОР
	|			КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаНачала
	|					И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизацииЗавершения
	|			ИНАЧЕ ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации
	|		КОНЕЦ
	|	И ТЧРаботникиОрганизации.Должность = ВЫБОР
	|			КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаНачала
	|					И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ДанныеПоРаботникуДоНазначения.ДолжностьЗавершения
	|			ИНАЧЕ ДанныеПоРаботникуДоНазначения.Должность
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|					И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаНачала
	|				ТОГДА ДанныеПоРаботникуДоНазначения.ПричинаИзмененияСостоянияЗавершения
	|			ИНАЧЕ ДанныеПоРаботникуДоНазначения.ПричинаИзмененияСостояния
	|		КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыПоследнихИзмененийСотрудников.НомерСтроки,
	|	ДатыПоследнихИзмененийСотрудников.Сотрудник,
	|	ДатыПоследнихИзмененийСотрудников.ДатаНачала
	|ПОМЕСТИТЬ ВТСотрудникиОсвободившиеСтавку
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(СотрудникиОсвободившиеСтавкиВОрганизациях.Период) КАК ПериодПоследнегоДвижения,
	|		СотрудникиОсвободившиеСтавкиВОрганизациях.Сотрудник КАК Сотрудник,
	|		СтрокиДокумента.НомерСтроки КАК НомерСтроки,
	|		СтрокиДокумента.ДатаНачала КАК ДатаНачала
	|	ИЗ
	|		ВТСотрудникиНаШтатныхЕдиницах КАК СтрокиДокумента
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СотрудникиОсвободившиеСтавкиВОрганизациях КАК СотрудникиОсвободившиеСтавкиВОрганизациях
	|			ПО СтрокиДокумента.ДатаНачала >= СотрудникиОсвободившиеСтавкиВОрганизациях.Период
	|				И СтрокиДокумента.Сотрудник.Организация = СотрудникиОсвободившиеСтавкиВОрганизациях.Организация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СтрокиДокумента.НомерСтроки,
	|		СотрудникиОсвободившиеСтавкиВОрганизациях.Сотрудник,
	|		СтрокиДокумента.ДатаНачала) КАК ДатыПоследнихИзмененийСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СотрудникиОсвободившиеСтавкиВОрганизациях КАК СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних
	|		ПО ДатыПоследнихИзмененийСотрудников.ПериодПоследнегоДвижения = СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.Период
	|			И ДатыПоследнихИзмененийСотрудников.Сотрудник = СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.Сотрудник
	|ГДЕ
	|	ВЫБОР
	|			КОГДА СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|					И СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.ПериодЗавершения <= ДатыПоследнихИзмененийСотрудников.ДатаНачала
	|				ТОГДА СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.ОсвобождатьСтавкуЗавершения
	|			ИНАЧЕ СотрудникиОсвободившиеСтавкиВОрганизацияхСрезПоследних.ОсвобождатьСтавку
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеДаты.НомерСтроки,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				И РаботникиОрганизаций.ПериодЗавершения <= ПоследниеДаты.ДатаНачала
	|			ТОГДА РаботникиОрганизаций.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ РаботникиОрганизаций.ПодразделениеОрганизации
	|	КОНЕЦ КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				И РаботникиОрганизаций.ПериодЗавершения <= ПоследниеДаты.ДатаНачала
	|			ТОГДА РаботникиОрганизаций.ДолжностьЗавершения
	|		ИНАЧЕ РаботникиОрганизаций.Должность
	|	КОНЕЦ КАК Должность,
	|	СУММА(ВЫБОР
	|			КОГДА РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|					И РаботникиОрганизаций.ПериодЗавершения <= ПоследниеДаты.ДатаНачала
	|				ТОГДА РаботникиОрганизаций.ЗанимаемыхСтавокЗавершения
	|			ИНАЧЕ РаботникиОрганизаций.ЗанимаемыхСтавок
	|		КОНЕЦ) КАК Ставка
	|ПОМЕСТИТЬ ОсвободившиесяСтавки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТСотрудникиОсвободившиеСтавку.НомерСтроки КАК НомерСтроки,
	|		ВТСотрудникиОсвободившиеСтавку.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период,
	|		ВТСотрудникиОсвободившиеСтавку.ДатаНачала КАК ДатаНачала
	|	ИЗ
	|		ВТСотрудникиОсвободившиеСтавку КАК ВТСотрудникиОсвободившиеСтавку
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|			ПО ВТСотрудникиОсвободившиеСтавку.ДатаНачала >= РаботникиОрганизаций.Период
	|				И ВТСотрудникиОсвободившиеСтавку.Сотрудник = РаботникиОрганизаций.Сотрудник
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВТСотрудникиОсвободившиеСтавку.НомерСтроки,
	|		ВТСотрудникиОсвободившиеСтавку.Сотрудник,
	|		ВТСотрудникиОсвободившиеСтавку.ДатаНачала) КАК ПоследниеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО ПоследниеДаты.Сотрудник = РаботникиОрганизаций.Сотрудник
	|			И ПоследниеДаты.Период = РаботникиОрганизаций.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоследниеДаты.НомерСтроки,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				И РаботникиОрганизаций.ПериодЗавершения <= ПоследниеДаты.ДатаНачала
	|			ТОГДА РаботникиОрганизаций.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ РаботникиОрганизаций.ПодразделениеОрганизации
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				И РаботникиОрганизаций.ПериодЗавершения <= ПоследниеДаты.ДатаНачала
	|			ТОГДА РаботникиОрганизаций.ДолжностьЗавершения
	|		ИНАЧЕ РаботникиОрганизаций.Должность
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСтрокиДокумента.НомерСтроки,
	|	СУММА(ОсвободившиесяСтавки.Ставка) КАК ОсвобожденныеСтавки
	|ИЗ
	|	ВТСтрокиДокумента КАК ВТСтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсвободившиесяСтавки КАК ОсвободившиесяСтавки
	|		ПО ВТСтрокиДокумента.НомерСтроки = ОсвободившиесяСтавки.НомерСтроки
	|			И ВТСтрокиДокумента.ПодразделениеОрганизации = ОсвободившиесяСтавки.ПодразделениеОрганизации
	|			И ВТСтрокиДокумента.Должность = ОсвободившиесяСтавки.Должность
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСтрокиДокумента.НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ВременноСвободныеСтавкиСтрокШтатногоРасписания()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ДЛЯ ЗАПИСИ ТЕКУЩИХ КАДРОВЫХ ДАННЫХ СОТРУДНИКА ОРГАНИЗАЦИИ

Процедура УстановитьРеквизитыИЗаписатьСотрудникаОрганизации(Выборка, Отказ)
	
	Пока Выборка.Следующий() Цикл
		
		СотрудникОбъект = Выборка.Сотрудник.ПолучитьОбъект();
		
		Если СотрудникОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СотрудникОбъект.ТекущееОбособленноеПодразделение	= Выборка.ОбособленноеПодразделение;
		СотрудникОбъект.ТекущееПодразделениеОрганизации		= Выборка.ПодразделениеОрганизации;
		СотрудникОбъект.ТекущаяДолжностьОрганизации			= Выборка.Должность;
		СотрудникОбъект.ДатаПриемаНаРаботу					= Выборка.ДатаПриемаНаРаботу;
		СотрудникОбъект.ДатаУвольнения						= Выборка.ДатаУвольнения;
		
		Попытка
			СотрудникОбъект.Заблокировать();
		Исключение
			ОбщегоНазначения.ПоказатьДиалогСИнформациейОбОшибке(ИнформацияОбОшибке());
			Отказ = Истина;
			Возврат;
		КонецПопытки;
		СотрудникОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// В процедуре всем сотрудникам, которые есть в документе регистраторе,
// устанавливаются текущие кадровые данные
// Перед записью данных необходимо отобрать данные без учета регистратора
// При записи данных необходимо отбирать данные с учетом регистратора
//
Процедура ЗаписатьТекущиеКадровыеДанныеСотрудникаОрганизации(Отказ, Замещение, БезРегистратора, Регистратор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РаботникиОрганизаций.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|ГДЕ
	|	РаботникиОрганизаций.Регистратор = &Регистратор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА РаботникиОрганизацийСрезПоследних.ОбособленноеПодразделение
	|		ИНАЧЕ РаботникиОрганизацийСрезПоследних.ОбособленноеПодразделениеЗавершения
	|	КОНЕЦ КАК ОбособленноеПодразделение,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации
	|		ИНАЧЕ РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизацииЗавершения
	|	КОНЕЦ КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА РаботникиОрганизацийСрезПоследних.Должность
	|		ИНАЧЕ РаботникиОрганизацийСрезПоследних.ДолжностьЗавершения
	|	КОНЕЦ КАК Должность,
	|	ЕСТЬNULL(РаботникиОрганизацийПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РаботникиОрганизацийУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(РаботникиОрганизацийУвольнение.Период, ДЕНЬ, -1)
	|	КОНЕЦ КАК ДатаУвольнения
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				,
	|				Сотрудник В
	|						(ВЫБРАТЬ
	|							Сотрудники.Сотрудник
	|						ИЗ
	|							ВТСотрудники КАК Сотрудники)
	|					" + ?(БезРегистратора, "И Регистратор <> &Регистратор", "") + ") КАК РаботникиОрганизацийСрезПоследних
	|		ПО Сотрудники.Сотрудник = РаботникиОрганизацийСрезПоследних.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизацийПрием
	|		ПО Сотрудники.Сотрудник = РаботникиОрганизацийПрием.Сотрудник
	|			И (ВЫБОР
	|				КОГДА РаботникиОрганизацийПрием.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА РаботникиОрганизацийПрием.ПричинаИзмененияСостояния
	|				ИНАЧЕ РаботникиОрганизацийПрием.ПричинаИзмененияСостоянияЗавершения
	|			КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
	|			" + ?(БезРегистратора, "И (РаботникиОрганизацийПрием.Регистратор <> &Регистратор)", "") + "
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизацийУвольнение
	|		ПО Сотрудники.Сотрудник = РаботникиОрганизацийУвольнение.Сотрудник
	|			И (ВЫБОР
	|				КОГДА РаботникиОрганизацийУвольнение.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА РаботникиОрганизацийУвольнение.ПричинаИзмененияСостояния
	|				ИНАЧЕ РаботникиОрганизацийУвольнение.ПричинаИзмененияСостоянияЗавершения
	|			КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение))
	|			" + ?(БезРегистратора, "И (РаботникиОрганизацийУвольнение.Регистратор <> &Регистратор)", "") + "
	|ГДЕ
	|	(Сотрудники.Сотрудник.ТекущееОбособленноеПодразделение <> ЕСТЬNULL(ВЫБОР
	|					КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА РаботникиОрганизацийСрезПоследних.ОбособленноеПодразделение
	|					ИНАЧЕ РаботникиОрганизацийСрезПоследних.ОбособленноеПодразделениеЗавершения
	|				КОНЕЦ, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ТекущееПодразделениеОрганизации <> ЕСТЬNULL(ВЫБОР
	|					КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации
	|					ИНАЧЕ РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизацииЗавершения
	|				КОНЕЦ, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ТекущаяДолжностьОрганизации <> ЕСТЬNULL(ВЫБОР
	|					КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА РаботникиОрганизацийСрезПоследних.Должность
	|					ИНАЧЕ РаботникиОрганизацийСрезПоследних.ДолжностьЗавершения
	|				КОНЕЦ, ЗНАЧЕНИЕ(Справочник.ДолжностиОрганизаций.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ДатаПриемаНаРаботу <> ЕСТЬNULL(РаботникиОрганизацийПрием.Период, ДАТАВРЕМЯ(1, 1, 1))
	|			ИЛИ Сотрудники.Сотрудник.ДатаУвольнения <> ЕСТЬNULL(РаботникиОрганизацийУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьРеквизитыИЗаписатьСотрудникаОрганизации(Выборка, Отказ);
	
КонецПроцедуры
