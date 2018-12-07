// Процедура рассчитывает плановую стоимость продукции
// Параметры:
//	МассивПродукции - массив с продукцией для стоимость которой надо получить
//  Дата - дата на которую производится расчет.
//
// Возврат:
//	Таблица значений с колонками Продукция и Стоимость
//
Функция ПолучитьПланСебестоимостьПродукции(ТабПродукции, Дата) Экспорт
	
	ТаблицаПродукции = ТабПродукции.Скопировать();
	ТаблицаПродукции.Свернуть("Продукция,ХарактеристикаПродукции");
	
	МассивПродукции = ТаблицаПродукции.ВыгрузитьКолонку("Продукция");
	МассивХарактеристик = ТаблицаПродукции.ВыгрузитьКолонку("ХарактеристикаПродукции");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("МассивПродукции", МассивПродукции);
	Запрос.УстановитьПараметр("МассивХарактеристик", МассивХарактеристик);
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПлановаяСебестоимостьНоменклатурыСрезПоследних.Номенклатура КАК Продукция,
		|	ПлановаяСебестоимостьНоменклатурыСрезПоследних.ХарактеристикаНоменклатуры КАК ХарактеристикаПродукции,
		|	ПлановаяСебестоимостьНоменклатурыСрезПоследних.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ПлановаяСебестоимостьНоменклатурыСрезПоследних.Сумма КАК Стоимость
		|ИЗ
		|	РегистрСведений.ПлановаяСебестоимостьНоменклатуры.СрезПоследних(&Дата, Номенклатура В (&МассивПродукции) И ХарактеристикаНоменклатуры В (&МассивХарактеристик)) КАК ПлановаяСебестоимостьНоменклатурыСрезПоследних";
		
	ТабРезультат = Новый ТаблицаЗначений;
	ТабРезультат.Колонки.Добавить("Продукция", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТабРезультат.Колонки.Добавить("ХарактеристикаПродукции", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТабРезультат.Колонки.Добавить("СтатьяЗатрат", Новый ОписаниеТипов("СправочникСсылка.СтатьиЗатрат"));
	ТабРезультат.Колонки.Добавить("Стоимость", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
		
	РезЗапроса = Запрос.Выполнить().Выгрузить();
	
	// Чтобы исключить ненужные пары Продукция - Характеристика 
	// т.к. отбор в запросе ставится на значения измерений, но не на их сочетание
	СтруктПоиска = Новый Структура;
	Для Каждого К Из ТаблицаПродукции Цикл
		
		СтруктПоиска.Вставить("Продукция", К.Продукция);
		СтруктПоиска.Вставить("ХарактеристикаПродукции", К.ХарактеристикаПродукции);
		Строки = РезЗапроса.НайтиСтроки( СтруктПоиска);
		Для Каждого М Из Строки Цикл
			НоваяСтрока = ТабРезультат.Добавить();
			НоваяСтрока.Продукция    = М.Продукция;
			НоваяСтрока.ХарактеристикаПродукции = М.ХарактеристикаПродукции;
			НоваяСтрока.СтатьяЗатрат = М.СтатьяЗатрат;
			НоваяСтрока.Стоимость    = М.Стоимость;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабРезультат;
	
КонецФункции // ПолучитьПланСебестоимостьПродукции()