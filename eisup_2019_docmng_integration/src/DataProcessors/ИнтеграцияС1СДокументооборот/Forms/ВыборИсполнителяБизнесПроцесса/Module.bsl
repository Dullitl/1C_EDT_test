
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Дерево.ПолучитьЭлементы(), "DMSubdivision", "");
	ЭлементВсеПользователи = Дерево.ПолучитьЭлементы().Вставить(0);
	ЭлементВсеПользователи.Наименование = НСтр("ru = 'Все пользователи'");
	ЭлементВсеПользователи.ID = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователиРолиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Роли.Количество() = 0 Тогда
		ЗаполнитьСписокДоступныхРолей();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВыполнить();

КонецПроцедуры

&НаКлиенте
Процедура РолиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПодразделений(ВеткаДерева, ТипОбъектаВыбора, ИдентификаторПапки = Неопределено, СтрокаПоиска = Неопределено)
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	Если ИдентификаторПапки <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Parent";
		Условие.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ИдентификаторПапки, ТипОбъектаВыбора);
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
	КонецЕсли;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Name";
		Условие.value = СтрокаПоиска;
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
	КонецЕсли;
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.Type = ТипОбъектаВыбора;
	Запрос.query = УсловияОтбораОбъектов;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Для Каждого Элемент Из Результат.Items Цикл
		
		НоваяСтрока = ВеткаДерева.Добавить();
		НоваяСтрока.Наименование = Элемент.object.name;
		НоваяСтрока.ID = Элемент.object.objectId.id;
		НоваяСтрока.Тип = Элемент.object.objectId.type;
		
		Если ТипОбъектаВыбора = "DMFileFolder" Тогда
			НоваяСтрока.Картинка = 0;
		Иначе
			Если Элемент.isFolder Тогда
				НоваяСтрока.Картинка = 0;
			Иначе	
				НоваяСтрока.Картинка = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Элемент.canHaveChildren И (СтрокаПоиска = Неопределено) Тогда
			НоваяСтрока.ПодпапкиСчитаны = Ложь;
			НоваяСтрока.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
		Иначе
			НоваяСтрока.ПодпапкиСчитаны = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПользователей(ПодразделениеИД)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		//получение руководителя текущего подразделения
		Подразделения = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, "DMSubdivision", ПодразделениеИД); 
		Если Подразделения.objects[0].Установлено("head") Тогда
			IDРуководителя = Подразделения.objects[0].head.objectId.id;
		КонецЕсли;
	КонецЕсли;
	
	//заполнение списка пользователей	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.Type = "DMUser";
	
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
		ПодразделениеXDTO = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПодразделениеИД, "DMSubdivision");
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси,"DMObjectListCondition");
		Условие.property = "Subdivision";
		Условие.value = ПодразделениеXDTO;
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
				
		Запрос.query = УсловияОтбораОбъектов;
	КонецЕсли;
	
	Результат = Прокси.execute(Запрос);

	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	ТаблицаПользователей.Очистить();
	Для Каждого ПользовательВСписке Из Результат.Items Цикл
		НоваяСтрока = ТаблицаПользователей.Добавить();
		НоваяСтрока.Пользователь = ПользовательВСписке.object.name;
		НоваяСтрока.ПользовательID = ПользовательВСписке.object.objectId.id;
		НоваяСтрока.ПользовательТип = ПользовательВСписке.object.objectId.type;
		НоваяСтрока.Руководитель = (IDРуководителя = ПользовательВСписке.object.objectId.id);
	КонецЦикла;
	
	ТаблицаПользователей.Сортировать("Пользователь Возр");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = Дерево.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Лист.ПолучитьЭлементы(), "DMSubdivision", Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ЗаполнитьТаблицуПользователей(Элементы.Дерево.ТекущиеДанные.ID);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхРолей()

	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery"); 
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMBusinessProcessExecutorRole";
	Запрос.query = УсловияОтбораОбъектов;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Роли.Очистить();
	Для Каждого Элемент Из Результат.Items Цикл
		НоваяСтрока = Роли.Добавить();
		НоваяСтрока.Роль = Элемент.object.name;
		НоваяСтрока.РольID = Элемент.object.objectId.id;
		НоваяСтрока.РольТип = Элемент.object.objectId.type;
		НоваяСтрока.Картинка =  ИнтеграцияС1СДокументооборотПереопределяемый.ИндексКартинкиЭлемента();
	КонецЦикла;

	Роли.Сортировать("Роль Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.ГруппаПользователиРоли.ТекущаяСтраница = Элементы.ГруппаПользователи Тогда
		
		Если Элементы.ТаблицаПользователей.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеВозврата = Новый Структура;
		ДанныеВозврата.Вставить("Исполнитель",
			Элементы.ТаблицаПользователей.ТекущиеДанные.Пользователь);
		ДанныеВозврата.Вставить("ИсполнительID",
			Элементы.ТаблицаПользователей.ТекущиеДанные.ПользовательID);
		ДанныеВозврата.Вставить("ИсполнительТип",
			Элементы.ТаблицаПользователей.ТекущиеДанные.ПользовательТип);
		
		Закрыть(ДанныеВозврата);
		
	ИначеЕсли Элементы.ГруппаПользователиРоли.ТекущаяСтраница = Элементы.ГруппаРоли Тогда
		
		Если Элементы.Роли.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьВыполнитьЗавершение", ЭтаФорма);
		 
		ИнтеграцияС1СДокументооборотКлиент.ПоказатьПолучениеОбъектовАдресацииРоли(
			Оповещение,
			Элементы.Роли.ТекущиеДанные.Роль, 
			Элементы.Роли.ТекущиеДанные.РольТип, 
			Элементы.Роли.ТекущиеДанные.РольID, 
			ЭтаФорма);  
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнитьЗавершение(ДанныеВозврата, ПараметрыОповещения) Экспорт
	
	Если ДанныеВозврата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры

#КонецОбласти
