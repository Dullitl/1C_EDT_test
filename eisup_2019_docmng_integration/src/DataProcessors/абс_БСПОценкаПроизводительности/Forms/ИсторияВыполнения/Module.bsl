////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = Параметры.НастройкиИстории.КлючеваяОперация;
	ДатаНачала = Параметры.НастройкиИстории.ДатаНачала;
	ДатаОкончания = Параметры.НастройкиИстории.ДатаОкончания;
	Приоритет = КлючеваяОперация.Приоритет;
	ЦелевоеВремя = КлючеваяОперация.ЦелевоеВремя;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КлючеваяОперация", КлючеваяОперация);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗамерыВремени.Пользователь КАК Пользователь,
	|	ЗамерыВремени.ВремяВыполнения КАК Длительность,
	|	ЗамерыВремени.ДатаНачалаЗамера КАК ВремяОкончания
	|ИЗ
	|	РегистрСведений.абс_БСПЗамерыВремени КАК ЗамерыВремени
	|ГДЕ
	|	ЗамерыВремени.КлючеваяОперация = &КлючеваяОперация
	|	И ЗамерыВремени.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяОкончания";
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоЗамеровЧисло = Выборка.Количество();
	КоличествоЗамеров = Строка(КоличествоЗамеровЧисло) + ?(КоличествоЗамеровЧисло < 100, " (недостаточно)", "");
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаИстории = История.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаИстории, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ История

// Запрещает редактирование ключевой операции из формы обработки
// т.к. могут пострадать внутренние механизмы
//
&НаКлиенте
Процедура КлючеваяОперацияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры




