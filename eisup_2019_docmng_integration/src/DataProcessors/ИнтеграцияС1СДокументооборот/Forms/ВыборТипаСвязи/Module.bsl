#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИсходныйДокумент = Параметры.ИсходныйДокумент;
	ИсходныйДокумент.Свойство("ID", ИсходныйДокументID);
	ИсходныйДокумент.Свойство("Тип", ИсходныйДокументТип);
	ИсходныйДокумент.Свойство("Представление", ИсходныйДокументПредставление);
	
	СвязанныйДокумент = Параметры.СвязанныйДокумент;
	СвязанныйДокумент.Свойство("ID", СвязанныйДокументID);
	СвязанныйДокумент.Свойство("Тип", СвязанныйДокументТип);
	СвязанныйДокумент.Свойство("Представление", СвязанныйДокументПредставление);
	
	ЗаполнитьТипыСвязей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// В отсутствие доступных связей покажем пояснение.
	Если ТипыСвязей.Количество() = 0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница 
			= Элементы.СтраницаНетДоступныхТипов;
		Элементы.ФормаСоздать.Видимость = Ложь;
		Элементы.КонтекстСоздать.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТипыСвязей

&НаКлиенте
Процедура ТипыСвязейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗакрытьСПараметром(Элементы.ТипыСвязей.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьСвязь(Команда)
	
	ТекущиеДанные = Элементы.ТипыСвязей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЗакрытьСПараметром(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет таблицу связей запросом к веб-сервису согласно связываемым документам.
//
&НаСервере
Процедура ЗаполнитьТипыСвязей()
	
	ТипыСвязей.Очистить();
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Условия = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	
	УсловиеИз = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	УсловиеИз.property = "DocumentFrom";
	УсловиеИз.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(
		Прокси, ИсходныйДокументID, ИсходныйДокументТип);
	Условия.conditions.Добавить(УсловиеИз);
	
	УсловиеВ = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	УсловиеВ.property = "DocumentTo";
	УсловиеВ.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(
		Прокси, СвязанныйДокументID, СвязанныйДокументТип);
	Условия.conditions.Добавить(УсловиеВ);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMRelationType";
	Запрос.query = Условия;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Для Каждого Элемент Из Результат.items Цикл
		НоваяСтрока = ТипыСвязей.Добавить();
		НоваяСтрока.ID = Элемент.object.objectId.id;
		НоваяСтрока.Наименование = Элемент.object.name;
	КонецЦикла;
	
КонецПроцедуры

// Закрывает форму с передачей выбранного типа связи.
//
&НаКлиенте
Процедура ЗакрытьСПараметром(ВыбраннаяСтрока)
	
	ТипСвязи = Новый Структура;
	ТипСвязи.Вставить("ID", ВыбраннаяСтрока.ID);
	ТипСвязи.Вставить("Тип", "DMRelationType");
	ТипСвязи.Вставить("Представление", ВыбраннаяСтрока.Наименование);
	
	Закрыть(ТипСвязи);
	
КонецПроцедуры

// Закрывает форму с передачей результата, возвращающего процесс к выбору документа.
//
&НаКлиенте
Процедура ПовторитьВыборДокумента(Команда)
	
	Закрыть("ПовторитьВыборДокумента");
	
КонецПроцедуры

#КонецОбласти
