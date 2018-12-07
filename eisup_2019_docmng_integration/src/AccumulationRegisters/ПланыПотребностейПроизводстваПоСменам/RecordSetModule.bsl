Перем мТаблицаДвижений Экспорт; // Таблица движений

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");
	
	Для каждого СтрокаТаблицы Из мТаблицаДвижений Цикл
		СтрокаДвижения = ЭтотОбъект.Добавить(); // Для оборотных регистров
		
		// Откопируем остальные колонки (структура таблиц совпадает).
		Для каждого Колонка Из мТаблицаДвижений.Колонки Цикл

			ИмяКолонки = Колонка.Имя;
			Если ИмяКолонки <> "Активность"
			   И ИмяКолонки <> "НомерСтроки"
			   И ИмяКолонки <> ""
			   И ИмяКолонки <> "ВидДвижения" 
			   И ИмяКолонки <> "МоментВремени" Тогда
				СтрокаДвижения[ИмяКолонки] = СтрокаТаблицы[ИмяКолонки]
			КонецЕсли;

		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // ДобавитьДвижение()
