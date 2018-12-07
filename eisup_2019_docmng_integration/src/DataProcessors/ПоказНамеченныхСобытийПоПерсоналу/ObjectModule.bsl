////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ

// Получаем актуальные намеченные кадровые изменения
//
// Параметры
//  ДатаНачала		– дата, начало периода, в котором 
//                 надо регистрировать изменения
//  ДатаОкончания	– дата, окончание этого периода
//
// Возвращаемое значение:
//  Таблица значений – список подходящих изменений, по 
// структуре соответствует табличной части обработки
//
Процедура Автозаполнение(МаксимальноеКоличествоСобытий = 0) Экспорт
	
	Результаты.Очистить();
	
	Выборка = ПоказНамеченныхСобытийПоПерсоналуПереопределяемый.СформироватьЗапрос(?(Организация.Пустая(), Неопределено, Организация), ДатаНачала, ДатаОкончания, МаксимальноеКоличествоСобытий).Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Результаты.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры // ВыбратьНамеченныеИзменения()

// Разбирает отмеченные строки т.ч. обработки по видам намеченных кадровых изменений
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//	Таблица значений с описанием документов, которые следует создать
//
Функция РазобратьТаблицуИзменений() Экспорт
	Перем Док, ТЧ;
	
	СписокДокументов = Новый ТаблицаЗначений;
	СписокДокументов.Колонки.Добавить("ИмяДокумента");
	СписокДокументов.Колонки.Добавить("Организация");
	СписокДокументов.Колонки.Добавить("ИмяТЧ");
	СписокДокументов.Колонки.Добавить("ТЧ");
	
	СписокДокументов.Индексы.Добавить("ИмяДокумента");
	СписокДокументов.Индексы.Добавить("Организация");
	
	ПараметрыОтбора = Новый Структура;
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ОснованияУвольненияИзОрганизации) Тогда
		СтатьяТК = Справочники.ОснованияУвольненияИзОрганизации.НайтиПоНаименованию("п. 2 ст. 77 ТК");
	КонецЕсли;
	
	Для Каждого Строка Из Результаты Цикл
		Если Не Строка.ФормироватьДокумент Тогда
			Продолжить;
		КонецЕсли;
		
		ВыполненыДействияПоДополнительномуУсловию = ПоказНамеченныхСобытийПоПерсоналуПереопределяемый.ВыполняетсяДополнительноеУсловие(Строка, ПараметрыОтбора, СписокДокументов);
		
		Если НЕ ВыполненыДействияПоДополнительномуУсловию Тогда
			
			Если Строка.ПланируемоеСобытие = Перечисления.НамеченныеСобытияПоПерсоналу.Увольнение 
			 ИЛИ Строка.ПланируемоеСобытие = Перечисления.НамеченныеСобытияПоПерсоналу.УвольнениеПослеИспытательногоСрока Тогда
				ПараметрыОтбора.Вставить("ИмяДокумента",	"УвольнениеИзОрганизаций");
				ПараметрыОтбора.Вставить("Организация",		Строка.Организация);
				НайденныеСтроки = СписокДокументов.НайтиСтроки(ПараметрыОтбора);
				Если НайденныеСтроки.Количество() = 0 Тогда
					Док = СписокДокументов.Добавить();
					Док.ИмяДокумента	= "УвольнениеИзОрганизаций";
					Док.Организация		= Строка.Организация;
					Док.ИмяТЧ			= "РаботникиОрганизации";
				Иначе
					Док = НайденныеСтроки[0];
				КонецЕсли;
					
				Если Док.ТЧ = Неопределено Тогда
					ТЧ = Новый ТаблицаЗначений;
					Для Каждого Реквизит Из Метаданные.Документы.УвольнениеИзОрганизаций.ТабличныеЧасти.РаботникиОрганизации.Реквизиты Цикл
						ТЧ.Колонки.Добавить(Реквизит.Имя);
					КонецЦикла;
					Док.ТЧ = ТЧ;
				Иначе
					ТЧ = Док.ТЧ;
				КонецЕсли;
				
				СтрокаТаб = ТЧ.Добавить();
				СтрокаТаб.Сотрудник			= Строка.Сотрудник;
				СтрокаТаб.Физлицо			= Строка.Физлицо;
				СтрокаТаб.ДатаУвольнения	= Строка.ДатаИзменения;
				СтрокаТаб.СтатьяТКРФ		= СтатьяТК;
				
			ИначеЕсли Строка.ПланируемоеСобытие = Перечисления.НамеченныеСобытияПоПерсоналу.Перемещение Тогда
				ПараметрыОтбора.Вставить("ИмяДокумента",	"КадровоеПеремещениеОрганизаций");
				ПараметрыОтбора.Вставить("Организация",		Строка.Организация);
				НайденныеСтроки = СписокДокументов.НайтиСтроки(ПараметрыОтбора);
				Если НайденныеСтроки.Количество() = 0 Тогда
					Док = СписокДокументов.Добавить();
					Док.ИмяДокумента	= "КадровоеПеремещениеОрганизаций";
					Док.Организация		= Строка.Организация;
					Док.ИмяТЧ			= "РаботникиОрганизации";
				Иначе
					Док = НайденныеСтроки[0];
				КонецЕсли;
					
				Если Док.ТЧ = Неопределено Тогда
					ТЧ = Новый ТаблицаЗначений;
					Для Каждого Реквизит Из Метаданные.Документы.КадровоеПеремещениеОрганизаций.ТабличныеЧасти.РаботникиОрганизации.Реквизиты Цикл
						ТЧ.Колонки.Добавить(Реквизит.Имя);
					КонецЦикла;
					Док.ТЧ = ТЧ;
				Иначе
					ТЧ = Док.ТЧ;
				КонецЕсли;
				
				СтрокаТаб = ТЧ.Добавить();
				СтрокаТаб.Сотрудник					= Строка.Сотрудник;
				СтрокаТаб.Физлицо					= Строка.Физлицо;
				СтрокаТаб.ДатаНачала				= Строка.ДатаИзменения;
				СтрокаТаб.ПодразделениеОрганизации	= Строка.Подразделение;
				СтрокаТаб.Должность					= Строка.Должность;
				СтрокаТаб.ГрафикРаботы				= Строка.ГрафикРаботы;
				СтрокаТаб.ЗанимаемыхСтавок			= Строка.ЗанимаемыхСтавок;
				
			ИначеЕсли Строка.ПланируемоеСобытие = Перечисления.НамеченныеСобытияПоПерсоналу.РезультатИспытательногоСрока Тогда
				ПараметрыОтбора.Вставить("ИмяДокумента",	"РезультатИспытательногоСрока");
				ПараметрыОтбора.Вставить("Организация",		Строка.Организация);
				НайденныеСтроки = СписокДокументов.НайтиСтроки(ПараметрыОтбора);
				Если НайденныеСтроки.Количество() = 0 Тогда
					Док = СписокДокументов.Добавить();
					Док.ИмяДокумента	= "РезультатИспытательногоСрока";
				Иначе
					Док = НайденныеСтроки[0];
				КонецЕсли;
					
				Если Док.ТЧ = Неопределено Тогда
					ТЧ = Новый ТаблицаЗначений;
					Для Каждого Реквизит Из Метаданные.Документы.РезультатИспытательногоСрока.Реквизиты Цикл
						ТЧ.Колонки.Добавить(Реквизит.Имя);
					КонецЦикла;
					Док.ТЧ = ТЧ;
				Иначе
					ТЧ = Док.ТЧ;
				КонецЕсли;
				
				СтрокаТаб = ТЧ.Добавить();
				СтрокаТаб.Сотрудник				= Строка.Сотрудник;
				СтрокаТаб.Физлицо				= Строка.Физлицо;
				СтрокаТаб.ДатаИзменения			= Строка.ДатаИзменения;
				СтрокаТаб.Результат				= Перечисления.РезультатыИспытательногоСрока.Положительный;
				
			Иначе
				ПараметрыОтбора.Вставить("ИмяДокумента",	"ВозвратНаРаботуОрганизаций");
				ПараметрыОтбора.Вставить("Организация",		Строка.Организация);
				НайденныеСтроки = СписокДокументов.НайтиСтроки(ПараметрыОтбора);
				Если НайденныеСтроки.Количество() = 0 Тогда
					Док = СписокДокументов.Добавить();
					Док.ИмяДокумента	= "ВозвратНаРаботуОрганизаций";
					Док.Организация		= Строка.Организация;
					Док.ИмяТЧ			= "РаботникиОрганизации";
				Иначе
					Док = НайденныеСтроки[0];
				КонецЕсли;
					
				Если Док.ТЧ = Неопределено Тогда
					ТЧ = Новый ТаблицаЗначений;
					Для Каждого Реквизит Из Метаданные.Документы.ВозвратНаРаботуОрганизаций.ТабличныеЧасти.РаботникиОрганизации.Реквизиты Цикл
						ТЧ.Колонки.Добавить(Реквизит.Имя);
					КонецЦикла;
					Док.ТЧ = ТЧ;
				Иначе
					ТЧ = Док.ТЧ;
				КонецЕсли;
				
				СтрокаТаб = ТЧ.Добавить();
				СтрокаТаб.Сотрудник			= Строка.Сотрудник;
				СтрокаТаб.Физлицо			= Строка.Физлицо;
				СтрокаТаб.ДатаВозврата		= Строка.ДатаИзменения;
				СтрокаТаб.ЗаниматьСтавку	= Строка.ЗаниматьСтавку;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокДокументов;
	
КонецФункции

// Формирует текст запроса и исполняет его
//
// Параметры
//  ДатаНачала		– параметр запроса 
//  ДатаОкончания	– параметр запроса 
//
// Возвращаемое значение:
//  Результат выполнения запроса
//
Функция СформироватьЗапрос(Организации = Неопределено, ДатаНачала, ДатаОкончания, МаксимальноеКоличествоСобытий = 0) Экспорт
	
	Возврат ПоказНамеченныхСобытийПоПерсоналуПереопределяемый.СформироватьЗапрос(Организации, ДатаНачала, ДатаОкончания, МаксимальноеКоличествоСобытий);
	
КонецФункции // СформироватьЗапрос()
