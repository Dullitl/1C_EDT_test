
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если УправлениеСвойствамиСлужебный.ДополнительноеСвойствоИспользуется(Параметры.Ссылка) Тогда
		
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектИспользуется;
		
		Элементы.РазрешитьРедактирование.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоРеквизита;
		Иначе
			Элементы.Предупреждения.ТекущаяСтраница = Элементы.ПредупреждениеДополнительногоСведения;
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "СвойствоИспользуется");
		Элементы.КнопкиПояснения.Видимость = Ложь;
	Иначе
		Элементы.ДиалогиПользователя.ТекущаяСтраница = Элементы.ОбъектНеИспользуется;
		Элементы.ОбъектИспользуется.Видимость = Ложь; // Для компактного отображения формы.
		
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЭтоДополнительныйРеквизит = Истина Тогда
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоРеквизита;
		Иначе
			Элементы.Пояснения.ТекущаяСтраница = Элементы.ПояснениеДополнительногоСведения;
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "СвойствоНеИспользуется");
		Элементы.КнопкиПредупреждения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	РазблокируемыеРеквизиты.Добавить("ТипЗначения");
	РазблокируемыеРеквизиты.Добавить("Имя");
	
	Закрыть(РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
