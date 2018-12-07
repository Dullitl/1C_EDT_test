// Производит заполнение регистра сведений СсылкиНаСайтеИТС
//
// Параметры:
//		ТекстXML - 	ТекстовыйДокумент, содержащий XML описание списка ссылок
//					если опущен, то производится заполнение из макета со списком ссылок
//					включенным в поставку конфигурации
//
Процедура ПроизвестиЗаполнениеРегистраСведенийСсылкиНаСайтеИТС(ТекстXML = Неопределено) Экспорт
	
	Если ТекстXML = Неопределено Тогда
	
		ТекстXML = ПолучитьМакет("СписокСсылокНаСайтеИТС");
	
	КонецЕсли; 
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(ТекстXML.ПолучитьТекст());
	
	// Прочитаем первый узел и проверим его
	Если Не Чтение.Прочитать() Тогда
		Возврат;
	ИначеЕсли Чтение.Имя <> "Items" Тогда
		Возврат;
	КонецЕсли;
	
	// Получим описание таблицы и создадим ее
	ИменаКолонок = СтрЗаменить(Чтение.ПолучитьАтрибут("Columns"), ",", Символы.ПС);
	
	Набор = РегистрыСведений.СсылкиНаСайтеИТС.СоздатьНаборЗаписей();
	
	Пока Чтение.Прочитать() Цикл
		
		Если Чтение.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
			Продолжить;
		ИначеЕсли Чтение.Имя <> "Item" Тогда
			Возврат;
		КонецЕсли;
		
		Запись = Набор.Добавить();
		
		СтруктураЗаписи = Новый Структура;
		
		Для Сч = 1 По СтрЧислоСтрок(ИменаКолонок) Цикл
			
			ИмяКолонки = СтрПолучитьСтроку(ИменаКолонок, Сч);
			СтруктураЗаписи.Вставить(ИмяКолонки, Чтение.ПолучитьАтрибут(ИмяКолонки));
			
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(Запись, СтруктураЗаписи);
		
	КонецЦикла;
	
	Если НЕ ОбщегоНазначения.ЗаписатьНабор(Набор) Тогда
		
		Возврат;
		
	КонецЕсли; 
		
КонецПроцедуры // ПроизвестиЗаполнениеРегистраСведенийСсылкиНаСайтеИТС()
