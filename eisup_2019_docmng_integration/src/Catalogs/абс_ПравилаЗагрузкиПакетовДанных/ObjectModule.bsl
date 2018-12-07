Процедура УдалитьЛишниеПоляФайла(ТекСтрокаПравилаЗагрузкиОбъектов)  Экспорт
	// Вставить содержимое обработчика.
	ОбъектОтбора = ТекСтрокаПравилаЗагрузкиОбъектов.Объект;
	ЗагрузкаВТабличнуюЧасть = ТекСтрокаПравилаЗагрузкиОбъектов.ЗагрузкаВТабличнуюЧасть;
	ТабличнаяЧасть = ТекСтрокаПравилаЗагрузкиОбъектов.ТабличнаяЧасть;
	РеквизитНазначения = ТекСтрокаПравилаЗагрузкиОбъектов.РеквизитНазначения;
	СтруктураОтбора = Новый Структура("Объект,ЗагрузкаВТабличнуюЧасть,ТабличнаяЧасть,РеквизитНазначения");
	
	СтруктураОтбора.Объект = ОбъектОтбора;
	СтруктураОтбора.ЗагрузкаВТабличнуюЧасть = ЗагрузкаВТабличнуюЧасть; 
	СтруктураОтбора.ТабличнаяЧасть = ТабличнаяЧасть;   
	СтруктураОтбора.РеквизитНазначения = РеквизитНазначения;
	
	МассивСтрок = ПоляФайла.НайтиСтроки(СтруктураОтбора);
	
	Запрос = новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.ИмяРеквизита,
	|	абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.ПредставлениеРеквизита
	|ИЗ
	|	Справочник.абс_ПравилаЗагрузкиДанных.ТЧТаблицаЗагружаемыхРеквизитов КАК абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов
	|ГДЕ
	|	абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.Пометка
	|	И (абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.РежимЗагрузки = ""Искать""
	|			ИЛИ абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.РежимЗагрузки = ""Вычислять"")
	|	И абс_ПравилаЗагрузкиДанныхТЧТаблицаЗагружаемыхРеквизитов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ТекСтрокаПравилаЗагрузкиОбъектов.Правило);
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаПоляФайла из МассивСтрок Цикл
		Удалять = Истина;
		Для каждого СтрокаТЗ из ТЗ Цикл
			Если СтрокаПоляФайла.ИмяРеквизита = СтрокаТЗ.ИмяРеквизита Тогда
				Удалять = Ложь;
				прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Удалять Тогда
			ПоляФайла.Удалить(СтрокаПоляФайла);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПРоцедуры
