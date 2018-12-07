
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	// задачи
	Если НЕ ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	Если Параметры.Свойство("Предмет")
		И ЗначениеЗаполнено(Параметры.Предмет) Тогда
		Предмет = Параметры.Предмет.name;
		ПредметID = Параметры.Предмет.id;
		ПредметТип = Параметры.Предмет.type;
	КонецЕсли;
	
	Если Параметры.Свойство("ГлавнаяЗадача")
		И ЗначениеЗаполнено(Параметры.ГлавнаяЗадача) Тогда
		ГлавнаяЗадача = Параметры.ГлавнаяЗадача.name;
		ГлавнаяЗадачаID = Параметры.ГлавнаяЗадача.id;
		ГлавнаяЗадачаТип = Параметры.ГлавнаяЗадача.type;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ПолучатьВидДокумента = Ложь;
		Если НЕ ЗначениеЗаполнено(ВидДокументаID) Тогда 
			// пакетные запросы
			Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
				ПолучатьВидДокумента = Истина;
			Иначе
				Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
				ОбъектИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПредметID, ПредметТип);
				Запрос.objectIds.Добавить(ОбъектИд);
				Запрос.columnSet.Добавить("documentType");
				Результат = Прокси.execute(Запрос);
				ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
				Объект = Результат.objects[0];
				Если Найти(Объект.objectID.type,"Document") <> 0 Тогда
					ВидДокумента = Объект.documentType.name;
				Иначе
					Элементы.ВидДокумента.Видимость = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьДеревоШаблонов(ПолучатьВидДокумента);
	Иначе
		ЗаполнитьДеревоШаблонов();
	КонецЕсли;
	
	УстановитьЗаголовокПредметаПоТипуОбъекта();
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		Элементы.ГруппаЭлементы.Доступность = Истина;
		Элементы.СоздатьПроцесс.Доступность = Истина;
		Элементы.ГруппаПредмет.Видимость = Истина;
	Иначе
		Элементы.СтартоватьСразу.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливается развернутость ветвей по умолчанию.
	ЭлементыДерева = ДеревоШаблонов.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Развернуть Тогда
			Элементы.ДеревоШаблонов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
		КонецЕсли;
	КонецЦикла;
	
	Если СозданНовыйДокумент Тогда // оповестим открытые формы
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("name", Предмет);
		ПараметрыОповещения.Вставить("id", ПредметID);
		ПараметрыОповещения.Вставить("type", ПредметТип);
		ПараметрыОповещения.Вставить("documentType", ВидДокумента);
		
		Оповестить("Запись_ДокументооборотДокумент", ПараметрыОповещения, ВладелецФормы);
		
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотДокумент" И Источник = Элементы.Предмет Тогда 
		
		ПредметID = Параметр.id;
		ПредметТип = Параметр.type;
		Предмет = Параметр.name;
		Если Параметр.Свойство("documentType") Тогда
			ВидДокумента = Параметр.documentType;
		КонецЕсли;
		
		Элементы.ГруппаЭлементы.Доступность = Истина;
		Элементы.СоздатьПроцесс.Доступность = Истина;
		Элементы.ГруппаПредмет.Доступность = Истина;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПредмет;
		
		ЗаполнитьДеревоШаблонов();
		
		ЭлементыДерева = ДеревоШаблонов.ПолучитьЭлементы();
		Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
			Если ЭлементДерева.Развернуть Тогда
				Элементы.ДеревоШаблонов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.Свойство("Стартован") Тогда
			Если Параметр.Стартован Тогда
				ПодключитьОбработчикОжидания("ЗакрытьФорму",0.1,Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элементы.Предмет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоШаблонов

&НаКлиенте
Процедура ДеревоШаблоновПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СоздатьПроцессВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоШаблонов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СоздатьПроцесс.Доступность = НЕ Элементы.ДеревоШаблонов.ТекущиеДанные.ЭтоЗаголовок;
	
	Сводка = Элементы.ДеревоШаблонов.ТекущиеДанные.Подсказка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	СоздатьПроцессВыполнить();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокПредметаПоТипуОбъекта()
	
	Если ПредметТип = "DMInternalDocument" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Внутренний документ'");
		
	ИначеЕсли ПредметТип = "DMIncomingDocument" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Входящий документ'");
		
	ИначеЕсли ПредметТип = "DMOutgoingDocument" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Исходящий документ'");
		
	ИначеЕсли ПредметТип = "DMFile" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Файл'");
		
	ИначеЕсли ПредметТип = "DMActivity" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Мероприятие'");
		
	ИначеЕсли ПредметТип = "DMIncomingEMail" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Входящее письмо'");
		
	ИначеЕсли ПредметТип = "DMOutgoingEMail" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Исходящее письмо'");
		
	ИначеЕсли ПредметТип = "DMProject" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Проект'");
		
	ИначеЕсли ПредметТип = "DMProjectTask" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Проектная задача'");
		
	ИначеЕсли ПредметТип = "DMDiscussionMessage" Тогда
		Элементы.Предмет.Заголовок = НСтр("ru='Сообщение'");
		
	Иначе
		Элементы.Предмет.Заголовок = "Предмет";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоШаблонов(ПолучатьВидДокумента = Ложь)
	
	Дерево = РеквизитФормыВЗначение("ДеревоШаблонов");
	Дерево.Строки.Очистить();
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Если ПолучатьВидДокумента Тогда
		
		Пакет =  ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMBatchRequest");
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
		ОбъектИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПредметID, ПредметТип);
		Запрос.objectIds.Добавить(ОбъектИд);
		Запрос.columnSet.Добавить("documentType");
		
		Пакет.requests.Добавить(Запрос);
		
	КонецЕсли;
		
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetBusinessProcessTemplatesTreeRequest");
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ПредметБизнесПроцессаИд = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
		ПредметБизнесПроцессаИд.id = ПредметID;
		ПредметБизнесПроцессаИд.type = ПредметТип;
    	Запрос.businessProcessTargetID = ПредметБизнесПроцессаИд;
	КонецЕсли;

	Если ПолучатьВидДокумента Тогда
		Пакет.requests.Добавить(Запрос);
		Результаты = Прокси.execute(Пакет);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результаты);
		
		РезультатВидДокумента = Результаты.responses[0];
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатВидДокумента);
		Объект = РезультатВидДокумента.objects[0];
		Если Найти(Объект.objectID.type,"Document") <> 0 Тогда
			ВидДокумента = Объект.documentType.name;
		Иначе
			Элементы.ВидДокумента.Видимость = Ложь;
		КонецЕсли;
		
		РезультатДеревоШаблонов = Результаты.responses[1];
		
	Иначе
		РезультатДеревоШаблонов = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатДеревоШаблонов);
	КонецЕсли;
	
	ПорядокБизнесПроцессов = новый Массив();
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessOrder");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessApproval");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessPerformance");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessConsideration");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessAcquaintance");
	ПорядокБизнесПроцессов.Добавить("DMComplexBusinessProcess");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessRegistration");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessConfirmation");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessInvitation");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessOutgoingDocumentProcessing");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessInternalDocumentProcessing");
	ПорядокБизнесПроцессов.Добавить("DMBusinessProcessIncomingDocumentProcessing");
	
	СкрытьПоручения = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("2.0.0.0");
	
	Для каждого Раздел из РезультатДеревоШаблонов.BusinessProcessTemplatesTree Цикл
		
		РазделДерева = Дерево.Строки.Добавить();
		РазделДерева.Наименование = Раздел.name;
		РазделДерева.Подсказка = Раздел.hint;
		РазделДерева.ЭтоЗаголовок = Истина;
		
		Если РазделДерева.Наименование = "Другие шаблоны" Тогда
			РазделДерева.Развернуть = Ложь;
		Иначе
			РазделДерева.Развернуть = Истина;
		КонецЕсли;
		
		Для каждого Шаблон из Раздел.elements Цикл
			
			Если СкрытьПоручения
				И Шаблон.businessProcessType = "DMBusinessProcessOrder" Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаРаздела = РазделДерева.Строки.Добавить();
			СтрокаРаздела.Наименование = Шаблон.name;
			СтрокаРаздела.Подсказка = Шаблон.hint;
			СтрокаРаздела.ЭтоЗаголовок = Ложь;
			СтрокаРаздела.ТипПроцесса = Шаблон.businessProcessType;
			Если ЗначениеЗаполнено(Шаблон.template.objectID.id) Тогда
				СтрокаРаздела.ШаблонID = Шаблон.template.objectID.id;
				СтрокаРаздела.ШаблонТип = Шаблон.template.objectID.type;
			Иначе
				СтрокаРаздела.Индекс = ПорядокБизнесПроцессов.Найти(СтрокаРаздела.ТипПроцесса);
			КонецЕсли;
			
		КонецЦикла;
		
		РазделДерева.Строки.Сортировать("Индекс");
		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(Дерево, ДеревоШаблонов);
	УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент()
	
	ЭлементыДерева = ДеревоШаблонов.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ПерваяГруппа = ЭлементыДерева[0];
	Если ПерваяГруппа.ПолучитьЭлементы().Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ПервыйЭлементПервойГруппы = ПерваяГруппа.ПолучитьЭлементы()[0];
	Индекс = ПервыйЭлементПервойГруппы.ПолучитьИдентификатор();
	Элементы.ДеревоШаблонов.ТекущаяСтрока = Индекс;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцессВыполнить()
	
	Если Элементы.ДеревоШаблонов.ТекущиеДанные = Неопределено 
		ИЛИ Элементы.ДеревоШаблонов.ТекущиеДанные.ЭтоЗаголовок Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Элементы.ДеревоШаблонов.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ПредметБизнесПроцесса = Новый Структура;
		ПредметБизнесПроцесса.Вставить("id", ПредметID);
		ПредметБизнесПроцесса.Вставить("type", ПредметТип);
		ПараметрыФормы.Вставить("Предмет", ПредметБизнесПроцесса);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадачаID) Тогда
		ГлавнаяЗадачаБизнесПроцесса = Новый Структура;
		ГлавнаяЗадачаБизнесПроцесса.Вставить("id",ГлавнаяЗадачаID);
		ГлавнаяЗадачаБизнесПроцесса.Вставить("type",ГлавнаяЗадачаТип);
		ГлавнаяЗадачаБизнесПроцесса.Вставить("name",ГлавнаяЗадача);
		ПараметрыФормы.Вставить("ГлавнаяЗадача", ГлавнаяЗадачаБизнесПроцесса);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.ШаблонID) Тогда
		ШаблонБизнесПроцесса = Новый Структура;
		ШаблонБизнесПроцесса.Вставить("id", Данные.ШаблонID);
		ШаблонБизнесПроцесса.Вставить("type", Данные.ШаблонТип);
		ПараметрыФормы.Вставить("Шаблон", ШаблонБизнесПроцесса);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредметID) И СтартоватьСразу Тогда
		Если ЗначениеЗаполнено(Данные.ШаблонID) Тогда 
			
			Элементы.СоздатьПроцесс.Доступность = Ложь;
			
			Если ЗаполнитьСтартоватьПроцесс(Данные.ТипПроцесса, ПараметрыФормы) Тогда
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Стартован бизнес-процесс по шаблону ""%1"".'"), Данные.Наименование);
				ТекстЗаголовка = НСтр("ru='Стартован процесс'");
				ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
				
				ПараметрыОповещения = Новый Структура;
				ПараметрыОповещения.Вставить("id", ПроцессID);
				ПараметрыОповещения.Вставить("Стартован", Истина);
				
				// Соберем предметы.
				Предметы = Новый Массив;
				ОписаниеПредмета = Новый Структура;
				ОписаниеПредмета.Вставить("ID", ПредметID);
				ОписаниеПредмета.Вставить("Тип", ПредметТип);
				Предметы.Добавить(ОписаниеПредмета);
				
				ПараметрыОповещения.Вставить("Предметы", Предметы);
				
				Оповестить("Запись_ДокументооборотБизнесПроцесс",ПараметрыОповещения, ВладелецФормы);

			Иначе
				ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(Данные.ТипПроцесса, Неопределено, , ПараметрыФормы);
			КонецЕсли;
			
		Иначе 
			Элементы.СоздатьПроцесс.Доступность = Истина;
			ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(Данные.ТипПроцесса, Неопределено, , ПараметрыФормы);
		КонецЕсли;
	Иначе
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(Данные.ТипПроцесса, Неопределено, , ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьСтартоватьПроцесс(ТипПроцесса, ПараметрыЗапуска)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
	Если ПараметрыЗапуска.Свойство("Предмет") Тогда
		ШаблонПроцесса = ИнтеграцияС1СДокументооборот.НовыйБизнесПроцессПоШаблону(Прокси, ТипПроцесса, ПараметрыЗапуска.Шаблон, ПараметрыЗапуска.Предмет);
	Иначе
		ШаблонПроцесса = ИнтеграцияС1СДокументооборот.НовыйБизнесПроцессПоШаблону(Прокси, ТипПроцесса, ПараметрыЗапуска.Шаблон);
	КонецЕсли;
	
	НовыйПроцесс = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, ШаблонПроцесса.ObjectId.type);
	ИнтеграцияС1СДокументооборот.ЗаполнитьЗначенияСвойствXDTO(Прокси, НовыйПроцесс, ШаблонПроцесса);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, НовыйПроцесс);
		
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, РезультатЗапуска, "DMError") Тогда
		Возврат Ложь;
	Иначе
		ПроцессID = РезультатЗапуска.businessProcess.ObjectID.id;
		Возврат Истина;
	КонецЕсли;

КонецФункции

#КонецОбласти
