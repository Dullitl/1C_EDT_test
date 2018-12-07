
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ И ЗАПИСИ ДОКУМЕНТА

Процедура ДополнительныеДействияОбработкиПроведения(ДокументОбъект, ВыборкаПоШапкеДокумента, Заголовок, Отказ) Экспорт

	Для каждого СтрокаТЧ Из ДокументОбъект.ПособияПоСоциальномуСтрахованию Цикл
		// проверим очередную строку табличной части
		РасчетСтраховыхВзносовДополнительный.ПроверитьЗаполнениеСтрокиПособияСоциальномуСтрахованию(СтрокаТЧ, Отказ, Заголовок);
	КонецЦикла; 
	
	Если НЕ Отказ Тогда
		Выборка = РасчетСтраховыхВзносовДополнительный.СформироватьЗапросПоПособияСоциальномуСтрахованию(ДокументОбъект.Ссылка).Выбрать();
		Пока Выборка.Следующий() Цикл 
			ЗаполнитьЗначенияСвойств(ДокументОбъект.Движения.ПособияСоциальномуСтрахованию.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет Цикл
		// проверим очередную строку табличной части
		РасчетСтраховыхВзносовДополнительный.ПроверитьЗаполнениеСтрокиПособияПоУходуЗаРебенкомДоПолутораЛет(СтрокаТЧ, Отказ, Заголовок);
	КонецЦикла; 
	
	Если НЕ Отказ Тогда
		Выборка = РасчетСтраховыхВзносовДополнительный.СформироватьЗапросПоПособияПоУходуЗаРебенкомДоПолутораЛет(ДокументОбъект.Ссылка).Выбрать();
		Пока Выборка.Следующий() Цикл 
			ЗаполнитьЗначенияСвойств(ДокументОбъект.Движения.ПособияПоУходуЗаРебенкомДоПолутораЛет.Добавить(),Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СформироватьДвиженияПоДоходам(ДокументОбъект, ВыборкаПоШапкеДокумента, Заголовок, Отказ);

КонецПроцедуры

Процедура СформироватьДвиженияПоДоходам(ДокументОбъект, ВыборкаПоШапкеДокумента, Заголовок, Отказ, НаборЗаписей = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",	ВыборкаПоШапкеДокумента.Организация);
	Запрос.УстановитьПараметр("Организация",			ВыборкаПоШапкеДокумента.ОбособленноеПодразделение);
	Запрос.УстановитьПараметр("ОсновныеНачисления",		ДокументОбъект.ОсновныеНачисления);
	Запрос.УстановитьПараметр("ПособияСоциальномуСтрахованию", ДокументОбъект.ПособияПоСоциальномуСтрахованию);
	Запрос.УстановитьПараметр("ПособияПоУходуЗаРебенкомДоПолутораЛет", ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет);
	Запрос.УстановитьПараметр("ДополнительныеНачисления",ДокументОбъект.ДополнительныеНачисления);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Основные.НомерСтроки,
	|	Основные.ВидРасчета,
	|	Основные.Сотрудник КАК Сотрудник,
	|	Основные.ВидДохода КАК КодДоходаЕСН,
	|	Основные.ОблагаетсяЕНВД,
	|	Основные.ОблагаетсяПоДополнительномуТарифу,
	|	Основные.Результат,
	|	Основные.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА Основные.ПериодДействияКонец <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА КОНЕЦПЕРИОДА(Основные.ПериодДействияКонец, ДЕНЬ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ КАК ПериодДействияКонец,
	|	Основные.Сторно КАК Сторно,
	|	Основные.ДокументОснование
	|ПОМЕСТИТЬ ВТОсновныеНачисления
	|ИЗ
	|	&ОсновныеНачисления КАК Основные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ПериодДействияНачало";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Дополнительные.НомерСтроки,
	|	Дополнительные.ВидРасчета,
	|	Дополнительные.Сотрудник,
	|	Дополнительные.ВидДохода КАК КодДоходаЕСН,
	|	Дополнительные.ОблагаетсяЕНВД,
	|	Дополнительные.ОблагаетсяПоДополнительномуТарифу,
	|	Дополнительные.Результат,
	|	Дополнительные.Сторно,
	|	Дополнительные.ДокументОснование
	|ПОМЕСТИТЬ ВТДополнительныеНачисления
	|ИЗ
	|	&ДополнительныеНачисления КАК Дополнительные";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пособия.НомерСтроки,
	|	Пособия.ВидРасчета,
	|	Пособия.Сотрудник КАК Сотрудник,
	|	Пособия.ВидПособияСоциальногоСтрахования,
	|	Пособия.СпособФинансированияПособий,
	|	Пособия.ОблагаетсяЕНВД,
	|	Пособия.СуммаВсего,
	|	Пособия.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА Пособия.ПериодДействияКонец <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА КОНЕЦПЕРИОДА(Пособия.ПериодДействияКонец, ДЕНЬ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ КАК ПериодДействияКонец,
	|	Пособия.Сторно,
	|	Пособия.ДокументОснование
	|ПОМЕСТИТЬ ВТПособияСоциальномуСтрахованию
	|ИЗ
	|	&ПособияСоциальномуСтрахованию КАК Пособия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ПериодДействияНачало";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПособияПоУходу.НомерСтроки,
	|	ПособияПоУходу.ВидРасчета,
	|	ПособияПоУходу.Сотрудник КАК Сотрудник,
	|	ПособияПоУходу.ОблагаетсяЕНВД,
	|	ПособияПоУходу.ПособиеПоУходуЗаПервымРебенком,
	|	ПособияПоУходу.ПособиеПоУходуЗаВторымРебенком,
	|	ПособияПоУходу.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА ПособияПоУходу.ПериодДействияКонец <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА КОНЕЦПЕРИОДА(ПособияПоУходу.ПериодДействияКонец, ДЕНЬ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ КАК ПериодДействияКонец,
	|	ПособияПоУходу.Сторно,
	|	ПособияПоУходу.ДокументОснование
	|ПОМЕСТИТЬ ВТПособияПоУходуЗаРебенкомДоПолутораЛет
	|ИЗ
	|	&ПособияПоУходуЗаРебенкомДоПолутораЛет КАК ПособияПоУходу
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ПериодДействияНачало";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ПериодДействияНачало КАК ПериодДействияНачало,
	|	Основные.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	ВТОсновныеНачисления КАК Основные
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Пособия.ПериодДействияНачало,
	|	Пособия.Сотрудник
	|ИЗ
	|	ВТПособияСоциальномуСтрахованию КАК Пособия
	|ГДЕ
	|	Пособия.ВидРасчета ССЫЛКА ПланВидовРасчета.ОсновныеНачисленияОрганизаций
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПособияПоУходу.ПериодДействияНачало,
	|	ПособияПоУходу.Сотрудник
	|ИЗ
	|	ВТПособияПоУходуЗаРебенкомДоПолутораЛет КАК ПособияПоУходу
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ПериодДействияНачало
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаботникиОрганизацииСрез.Сотрудник КАК Сотрудник,
	|	РаботникиОрганизацииСрез.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.ПериодЗавершения <= РаботникиОрганизацииСрез.ПериодДействияНачало
	|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА РаботникиОрганизации.ГрафикРаботыЗавершения.СуммированныйУчетРабочегоВремени
	|		ИНАЧЕ РаботникиОрганизации.ГрафикРаботы.СуммированныйУчетРабочегоВремени
	|	КОНЕЦ КАК СуммированныйУчетРабочегоВремени,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.ПериодЗавершения <= РаботникиОрганизацииСрез.ПериодДействияНачало
	|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА РаботникиОрганизации.ГрафикРаботыЗавершения
	|		ИНАЧЕ РаботникиОрганизации.ГрафикРаботы
	|	КОНЕЦ КАК ГрафикРаботы
	|ПОМЕСТИТЬ ВТДанныеСотрудников
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(РаботникиОрганизации.Период) КАК ПериодСреза,
	|		Основные.Сотрудник КАК Сотрудник,
	|		Основные.ПериодДействияНачало КАК ПериодДействияНачало
	|	ИЗ
	|		ВТСотрудники КАК Основные
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|			ПО Основные.ПериодДействияНачало >= РаботникиОрганизации.Период
	|				И Основные.Сотрудник = РаботникиОрганизации.Сотрудник
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Основные.Сотрудник,
	|		Основные.ПериодДействияНачало) КАК РаботникиОрганизацииСрез
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|		ПО РаботникиОрганизацииСрез.ПериодСреза = РаботникиОрганизации.Период
	|			И РаботникиОрганизацииСрез.Сотрудник = РаботникиОрганизации.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ПериодДействияНачало
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Основные начисления"" КАК ТипСтроки,
	|	Основные.НомерСтроки,
	|	Основные.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	Основные.ВидРасчета.ВидВремени КАК ВидВремени,
	|	Основные.ВидРасчета КАК ВидРасчета,
	|	Основные.Сотрудник КАК Сотрудник,
	|	Основные.Сотрудник.Физлицо КАК Физлицо,
	|	Основные.КодДоходаЕСН,
	|	Основные.ОблагаетсяЕНВД,
	|	Основные.ОблагаетсяПоДополнительномуТарифу,
	|	Основные.Результат,
	|	Основные.ПериодДействияНачало КАК ПериодДействияНачало,
	|	Основные.ПериодДействияКонец,
	|	ЕСТЬNULL(РаботникиОрганизацииСрез.СуммированныйУчетРабочегоВремени, ЛОЖЬ) КАК СуммированныйУчетРабочегоВремени,
	|	РаботникиОрганизацииСрез.ГрафикРаботы КАК ГрафикРаботы,
	|	ВЫБОР
	|		КОГДА Основные.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	Основные.Сторно КАК Сторно,
	|	Основные.ДокументОснование,
	|	Основные.КодДоходаЕСН КАК ВидДохода
	|ИЗ
	|	ВТОсновныеНачисления КАК Основные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСотрудников КАК РаботникиОрганизацииСрез
	|		ПО Основные.Сотрудник = РаботникиОрганизацииСрез.Сотрудник
	|			И Основные.ПериодДействияНачало = РаботникиОрганизацииСрез.ПериодДействияНачало
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Дополнительные начисления"",
	|	Дополнительные.НомерСтроки,
	|	Дополнительные.ВидРасчета.СпособРасчета,
	|	NULL,
	|	Дополнительные.ВидРасчета,
	|	Дополнительные.Сотрудник,
	|	Дополнительные.Сотрудник.Физлицо,
	|	Дополнительные.КодДоходаЕСН,
	|	Дополнительные.ОблагаетсяЕНВД,
	|	Дополнительные.ОблагаетсяПоДополнительномуТарифу,
	|	Дополнительные.Результат,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА Дополнительные.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	Дополнительные.Сторно,
	|	Дополнительные.ДокументОснование,
	|	Дополнительные.КодДоходаЕСН
	|ИЗ
	|	ВТДополнительныеНачисления КАК Дополнительные
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Пособия по социальному страхованию (основные)"",
	|	Пособия.НомерСтроки,
	|	Пособия.ВидРасчета.СпособРасчета,
	|	Пособия.ВидРасчета.ВидВремени,
	|	Пособия.ВидРасчета,
	|	Пособия.Сотрудник,
	|	Пособия.Сотрудник.Физлицо,
	|	ВЫБОР
	|		КОГДА Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|		КОГДА Пособия.СпособФинансированияПособий = ЗНАЧЕНИЕ(Перечисление.СпособыФинансированияПособийСоцстрахования.ЗаСчетФСС)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|	КОНЕЦ,
	|	Пособия.ОблагаетсяЕНВД,
	|	ЛОЖЬ,
	|	Пособия.СуммаВсего,
	|	Пособия.ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА Пособия.ПериодДействияКонец <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА КОНЕЦПЕРИОДА(Пособия.ПериодДействияКонец, ДЕНЬ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ,
	|	ЕСТЬNULL(РаботникиОрганизацииСрез.СуммированныйУчетРабочегоВремени, ЛОЖЬ),
	|	РаботникиОрганизацииСрез.ГрафикРаботы,
	|	ВЫБОР
	|		КОГДА Пособия.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	Пособия.Сторно,
	|	Пособия.ДокументОснование,
	|	ВЫБОР
	|		КОГДА Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|		КОГДА Пособия.СпособФинансированияПособий = ЗНАЧЕНИЕ(Перечисление.СпособыФинансированияПособийСоцстрахования.ЗаСчетФСС)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|	КОНЕЦ
	|ИЗ
	|	ВТПособияСоциальномуСтрахованию КАК Пособия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСотрудников КАК РаботникиОрганизацииСрез
	|		ПО Пособия.Сотрудник = РаботникиОрганизацииСрез.Сотрудник
	|			И Пособия.ПериодДействияНачало = РаботникиОрганизацииСрез.ПериодДействияНачало
	|ГДЕ
	|	Пособия.ВидРасчета ССЫЛКА ПланВидовРасчета.ОсновныеНачисленияОрганизаций
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Пособия по социальному страхованию (единовременные)"",
	|	Пособия.НомерСтроки,
	|	Пособия.ВидРасчета.СпособРасчета,
	|	NULL,
	|	Пособия.ВидРасчета,
	|	Пособия.Сотрудник,
	|	Пособия.Сотрудник.Физлицо,
	|	ВЫБОР
	|		КОГДА Пособия.СпособФинансированияПособий = ЗНАЧЕНИЕ(Перечисление.СпособыФинансированияПособийСоцстрахования.ЗаСчетФСС)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|	КОНЕЦ,
	|	Пособия.ОблагаетсяЕНВД,
	|	ЛОЖЬ,
	|	Пособия.СуммаВсего,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВЫБОР
	|		КОГДА Пособия.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	Пособия.Сторно,
	|	Пособия.ДокументОснование,
	|	ВЫБОР
	|		КОГДА Пособия.СпособФинансированияПособий = ЗНАЧЕНИЕ(Перечисление.СпособыФинансированияПособийСоцстрахования.ЗаСчетФСС)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.НеОблагаетсяЦеликом)
	|	КОНЕЦ
	|ИЗ
	|	ВТПособияСоциальномуСтрахованию КАК Пособия
	|ГДЕ
	|	Пособия.ВидРасчета ССЫЛКА ПланВидовРасчета.ДополнительныеНачисленияОрганизаций
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Пособия по уходу за ребенком"",
	|	ПособияПоУходу.НомерСтроки,
	|	ПособияПоУходу.ВидРасчета.СпособРасчета,
	|	ПособияПоУходу.ВидРасчета.ВидВремени,
	|	ПособияПоУходу.ВидРасчета,
	|	ПособияПоУходу.Сотрудник,
	|	ПособияПоУходу.Сотрудник.Физлицо,
	|	ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС),
	|	ПособияПоУходу.ОблагаетсяЕНВД,
	|	ЛОЖЬ,
	|	ПособияПоУходу.ПособиеПоУходуЗаПервымРебенком + ПособияПоУходу.ПособиеПоУходуЗаВторымРебенком,
	|	ПособияПоУходу.ПериодДействияНачало,
	|	ВЫБОР
	|		КОГДА ПособияПоУходу.ПериодДействияКонец <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА КОНЕЦПЕРИОДА(ПособияПоУходу.ПериодДействияКонец, ДЕНЬ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ,
	|	ЕСТЬNULL(РаботникиОрганизацииСрез.СуммированныйУчетРабочегоВремени, ЛОЖЬ),
	|	РаботникиОрганизацииСрез.ГрафикРаботы,
	|	ВЫБОР
	|		КОГДА ПособияПоУходу.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ПособияПоУходу.Сторно,
	|	ПособияПоУходу.ДокументОснование,
	|	ЗНАЧЕНИЕ(Справочник.ДоходыПоСтраховымВзносам.ПособияЗаСчетФСС)
	|ИЗ
	|	ВТПособияПоУходуЗаРебенкомДоПолутораЛет КАК ПособияПоУходу
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСотрудников КАК РаботникиОрганизацииСрез
	|		ПО ПособияПоУходу.Сотрудник = РаботникиОрганизацииСрез.Сотрудник
	|			И ПособияПоУходу.ПериодДействияНачало = РаботникиОрганизацииСрез.ПериодДействияНачало
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	ВидРасчета,
	|	ПериодДействияНачало";
		
	ВыборкаПоДоходам =  Запрос.Выполнить().Выбрать();
	Пока ВыборкаПоДоходам.Следующий() Цикл
		РасчетСтраховыхВзносовДополнительный.ПроверитьЗаполнениеСтрокиДохода(ВыборкаПоДоходам, Отказ, Заголовок);
		Если Не Отказ Тогда
			Если НаборЗаписей = Неопределено Тогда
				РасчетСтраховыхВзносовДополнительный.ДобавитьСтрокуВДвиженияПоДоходам(ДокументОбъект, ВыборкаПоДоходам, ВыборкаПоШапкеДокумента);
			Иначе
				СтрокаНабора = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоДоходам);
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоШапкеДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАСЧЕТА Страховых взносов

Процедура Автозаполнение(ДокументОбъект, ВыборкаПоШапкеДокумента, ОграничениеНаСотрудников, Отказ) Экспорт
	
	// Создадим ссылки на наборы записей о доходах
	Если ДокументОбъект.Проведен Тогда
		НаборДвиженийОсновной = РегистрыРасчета.ЕСНОсновныеНачисления.СоздатьНаборЗаписей();
		НаборДвиженийОсновной.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
		НаборДвиженийОсновной.Прочитать();
		НаборДвиженийДополнительный = РегистрыРасчета.ЕСНДополнительныеНачисления.СоздатьНаборЗаписей();
		НаборДвиженийДополнительный.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
		НаборДвиженийДополнительный.Прочитать();
	КонецЕсли;
	
	ПособияСоциальномуСтрахованию 		  = ДокументОбъект.ПособияПоСоциальномуСтрахованию;
	ПособияПоУходуЗаРебенкомДоПолутораЛет = ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет;
	
	ОсновныеНачисления 		 = ДокументОбъект.ОсновныеНачисления;
	ДополнительныеНачисления = ДокументОбъект.ДополнительныеНачисления;
	
	//подготовим таблицу для регистрации ошибок
	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("Сотрудник");
	ТаблицаОшибок.Колонки.Добавить("ВидРасчета");
	ТаблицаОшибок.Колонки.Добавить("ПериодДействияНачало");
	ТаблицаОшибок.Колонки.Добавить("ПериодДействияКонец");
	ТаблицаОшибок.Колонки.Добавить("Сторно");
	ТаблицаОшибок.Колонки.Добавить("КодОшибки");
	ТаблицаОшибок.Колонки.Добавить("Регистратор");
	ТаблицаОшибок.Колонки.Добавить("НомерСтроки");
	ТаблицаОшибок.Колонки.Добавить("ВидПособияСоциальногоСтрахования");
	
	НаборЗаписейОсновной = РегистрыРасчета.ЕСНОсновныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписейОсновной.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
	НаборЗаписейОсновной.Записать();
	НаборЗаписейДополнительный = РегистрыРасчета.ЕСНДополнительныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписейДополнительный.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
	НаборЗаписейДополнительный.Записать();
	
	// Автозаполним наборы записей о доходах
	Отказ = РасчетСтраховыхВзносовДополнительный.АвтозаполнениеНаборовЗаписейОДоходах(ДокументОбъект, ВыборкаПоШапкеДокумента, НаборЗаписейОсновной, НаборЗаписейДополнительный, ОграничениеНаСотрудников, ТаблицаОшибок);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамРегистратор", ДокументОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСНОсновныеНачисления.ВидРасчета,
	|	ЕСНОсновныеНачисления.ПериодДействияНачало,
	|	ЕСНОсновныеНачисления.ПериодДействияКонец,
	|	ЕСНОсновныеНачисления.Сторно,
	|	ЕСНОсновныеНачисления.Сотрудник,
	|	ЕСНОсновныеНачисления.Сотрудник.Физлицо КАК Физлицо,
	|	СУММА(ЕСНОсновныеНачисления.Результат) КАК Результат,
	|	ЕСНОсновныеНачисления.КодДоходаЕСН КАК ВидДохода,
	|	ЕСНОсновныеНачисления.ОблагаетсяЕНВД,
	|	ЕСНОсновныеНачисления.ДокументОснование
	|ИЗ
	|	РегистрРасчета.ЕСНОсновныеНачисления КАК ЕСНОсновныеНачисления
	|ГДЕ
	|	ЕСНОсновныеНачисления.Регистратор = &парамРегистратор
	|	И ЕСНОсновныеНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСНОсновныеНачисления.ВидРасчета,
	|	ЕСНОсновныеНачисления.ПериодДействияНачало,
	|	ЕСНОсновныеНачисления.ПериодДействияКонец,
	|	ЕСНОсновныеНачисления.Сторно,
	|	ЕСНОсновныеНачисления.Сотрудник,
	|	ЕСНОсновныеНачисления.Сотрудник.Физлицо,
	|	ЕСНОсновныеНачисления.КодДоходаЕСН,
	|	ЕСНОсновныеНачисления.ОблагаетсяЕНВД,
	|	ЕСНОсновныеНачисления.ДокументОснование";
	
	ДокументОбъект.ОсновныеНачисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСНДополнительныеНачисления.ВидРасчета,
	|	ЕСНДополнительныеНачисления.Сторно,
	|	ЕСНДополнительныеНачисления.Сотрудник,
	|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо КАК Физлицо,
	|	СУММА(ЕСНДополнительныеНачисления.Результат) КАК Результат,
	|	ЕСНДополнительныеНачисления.КодДоходаЕСН КАК ВидДохода,
	|	ЕСНДополнительныеНачисления.ОблагаетсяЕНВД,
	|	ЕСНДополнительныеНачисления.ДокументОснование
	|ИЗ
	|	РегистрРасчета.ЕСНДополнительныеНачисления КАК ЕСНДополнительныеНачисления
	|ГДЕ
	|	ЕСНДополнительныеНачисления.Регистратор = &парамРегистратор
	|	И ЕСНДополнительныеНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСНДополнительныеНачисления.ВидРасчета,
	|	ЕСНДополнительныеНачисления.Сторно,
	|	ЕСНДополнительныеНачисления.Сотрудник,
	|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо,
	|	ЕСНДополнительныеНачисления.КодДоходаЕСН,
	|	ЕСНДополнительныеНачисления.ОблагаетсяЕНВД,
	|	ЕСНДополнительныеНачисления.ДокументОснование";
	
	ДокументОбъект.ДополнительныеНачисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтраховыеВзносыСкидкиКДоходам.ВидДохода КАК ВидДохода
	|ПОМЕСТИТЬ ВТКодыСоСкидками
	|ИЗ
	|	РегистрСведений.СтраховыеВзносыСкидкиКДоходам КАК СтраховыеВзносыСкидкиКДоходам
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидДохода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо КАК Физлицо,
	|	ЕСНДополнительныеНачисления.КодДоходаЕСН КАК ВидДохода,
	|	СУММА(ЕСНДополнительныеНачисления.Скидка) КАК Скидка
	|ИЗ
	|	РегистрРасчета.ЕСНДополнительныеНачисления КАК ЕСНДополнительныеНачисления
	|ГДЕ
	|	ЕСНДополнительныеНачисления.Регистратор = &парамРегистратор
	|	И ЕСНДополнительныеНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
	|	И ЕСНДополнительныеНачисления.КодДоходаЕСН В
	|			(ВЫБРАТЬ
	|				КодыСоСкидками.ВидДохода
	|			ИЗ
	|				ВТКодыСоСкидками КАК КодыСоСкидками)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо,
	|	ЕСНДополнительныеНачисления.КодДоходаЕСН";
	
	ДокументОбъект.НеоблагаемыеСуммыДоходов.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ДокументОбъект.РасчетСкидок(ВыборкаПоШапкеДокумента);
	
	Если Константы.ИспользуетсяТрудЧленовЛетныхЭкипажей.Получить() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.НомерСтроки,
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.ДатаАктуальности КАК ДатаАктуальности
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&ТаблицаСотрудников КАК Сотрудники
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник,
		|	ДатаАктуальности
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период,
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.ДатаАктуальности,
		|	Сотрудники.НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиРегистра
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ПО Сотрудники.Сотрудник = РаботникиОрганизаций.Сотрудник
		|			И Сотрудники.ДатаАктуальности >= РаботникиОрганизаций.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	Сотрудники.Сотрудник,
		|	Сотрудники.ДатаАктуальности,
		|	Сотрудники.НомерСтроки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник,
		|	Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтрокиРегистра.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ВЫБОР
		|			КОГДА Работники.ПериодЗавершения <= СтрокиРегистра.ДатаАктуальности
		|					И Работники.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|				ТОГДА Работники.ДолжностьЗавершения.ЯвляетсяДолжностьюЛетногоЭкипажа
		|			ИНАЧЕ Работники.Должность.ЯвляетсяДолжностьюЛетногоЭкипажа
		|		КОНЕЦ, ЛОЖЬ) КАК ОблагаетсяПоДополнительномуТарифу
		|ИЗ
		|	ВТСтрокиРегистра КАК СтрокиРегистра
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
		|		ПО СтрокиРегистра.Сотрудник = Работники.Сотрудник
		|			И СтрокиРегистра.Период = Работники.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		ТаблицаСотрудников = ДокументОбъект.ОсновныеНачисления.Выгрузить(,"НомерСтроки, Сотрудник,ПериодДействияНачало");
		ТаблицаСотрудников.Колонки.ПериодДействияНачало.Имя = "ДатаАктуальности";
		Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
		ДокументОбъект.ОсновныеНачисления.ЗагрузитьКолонку(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ОблагаетсяПоДополнительномуТарифу"),"ОблагаетсяПоДополнительномуТарифу");
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.НомерСтроки,
		|	Сотрудники.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&ТаблицаСотрудников КАК Сотрудники
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Работники.ПериодЗавершения <= &ДатаАктуальности
		|				И Работники.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА Работники.ДолжностьЗавершения.ЯвляетсяДолжностьюЛетногоЭкипажа
		|		ИНАЧЕ Работники.Должность.ЯвляетсяДолжностьюЛетногоЭкипажа
		|	КОНЕЦ КАК ЯвляетсяДолжностьюЛетногоЭкипажа,
		|	Работники.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСтрокиРегистра
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
		|			&ДатаАктуальности,
		|			Сотрудник В
		|				(ВЫБРАТЬ
		|					Сотрудники.Сотрудник
		|				ИЗ
		|					ВТСотрудники КАК Сотрудники)) КАК Работники
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(Работники.ЯвляетсяДолжностьюЛетногоЭкипажа, ЛОЖЬ) КАК ОблагаетсяПоДополнительномуТарифу
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтрокиРегистра КАК Работники
		|		ПО Сотрудники.Сотрудник = Работники.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		ТаблицаСотрудников = ДокументОбъект.ДополнительныеНачисления.Выгрузить(,"НомерСтроки, Сотрудник");
		Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
		Запрос.УстановитьПараметр("ДатаАктуальности", КонецМесяца(ДокументОбъект.ПериодРегистрации));
		ДокументОбъект.ДополнительныеНачисления.ЗагрузитьКолонку(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ОблагаетсяПоДополнительномуТарифу"),"ОблагаетсяПоДополнительномуТарифу");
	КонецЕсли;
	
	Если Отказ Тогда
		
		// есть ошибки в сборе данных по отражению начислений
		                                            
		ТекстСообщения = "Расчет страховых взносов не произведен! Для автоматического учета начислений при расчете страховых взносов не хватает данных.";
		ОбщегоНазначения.КомментарийРасчета(ТекстСообщения, , , , Перечисления.ВидыСообщений.Ошибка);
		
		Если ТаблицаОшибок.Количество() > 0 Тогда
			// сообщим пользователю об ошибках
			
			//отсортируем таблицу ошибок по кодам
			ТаблицаОшибок.Сортировать("КодОшибки, ВидРасчета");
			
			НовыйУчетПособий = НачалоМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации) >= НачалоМесяца(ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоСоциальнымПособиям2006());
			
			СтруктураПоискаНачисления = Новый Структура("Сотрудник,ВидРасчета,ПериодДействияНачало,ПериодДействияКонец,ДокументОснование,Сторно");
			СтруктураПоискаДополнительныеНачисления = Новый Структура("Сотрудник,ВидРасчета,ДокументОснование,Сторно");
			
			// коды ошибок
			// 1 - сторно, нет данных отражения в учете начисления в прошлых периодах
			// 2 - нет доли ЕНВД для пособий, доля ЕНВД по базовым начислениям
			// 3 - нет данных по базе, нужен код страховых взносов и доля ЕНВД
			// 4 - нет данных по базе, нужен код страховых взносов 
			// 5 - нет данных по базе, нужна доля ЕНВД
			// 6 - не заполнен код дохода страховых взносов у вида расчета
			// 7 - не заполнен код дохода страховых взносов у вида расчета, нужна доля ЕНВД
			
			ТекущийКодОшибки = 0;
			ТекущийВидРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка();
			
			Для каждого СтрокаТаблицыОшибок Из ТаблицаОшибок Цикл
				
				Если ТекущийКодОшибки <> СтрокаТаблицыОшибок.КодОшибки или ТекущийВидРасчета <> СтрокаТаблицыОшибок.ВидРасчета Тогда
					//выведем описание ошибки
					ТекстСообщенияРекомендации = "";
					ТекстСообщения = "Начисление: """ + СтрокаТаблицыОшибок.ВидРасчета.Наименование + """. ";
					
					Если СтрокаТаблицыОшибок.КодОшибки = 1 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для учета сторно записи. Отсутствуют данные отражения в учете для исчисления страховых взносов этого начисления в прошлых периодах";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 2 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения доли ЕНВД пособия. Стратегия определения доли ЕНВД - ""по базовым начислениям "" задана в начислении. ";
						Если СтрокаТаблицыОшибок.ВидРасчета.ВидПособияСоциальногоСтрахования <> Перечисления.ВидыПособийСоциальногоСтрахования.ПоУходуЗаРебенкомДоПолутораЛет Тогда
							ТекстСообщенияРекомендации = "Рекомендуется зарегистрировать отражение пособия в учете документом ""Начисление по больничному листу"".
							|На закладке ""Отражение пособия в учете"" установите ""Отражать в учете по данным текущего документа""
							|и заполните таблицу ""Проводки и данные для страховых взносов""";
						КонецЕсли;
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 3 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения вида дохода в учете для исчисления страховых взносов и доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 4 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения вида дохода в учете для исчисления страховых взносов. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 5 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 6 Тогда
						ТекстСообщения = ТекстСообщения + "Не задан вид дохода по страховым взносам у начисления";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную. Рекомендуется указать порядок учета
													|начисления для целей исчисления страховых взносов в форме начисления на закладке ""Взносы""";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 7 Тогда
						ТекстСообщения = ТекстСообщения + "Не задан вид дохода по страховым взносам у начисления. Нет данных для определения доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную. Рекомендуется указать порядок учета
													|начисления для целей исчисления страховых взносов в форме начисления на закладке ""Взносы""";
					Иначе //для этого кода нет текста сообщения
						Продолжить;
					КонецЕсли;	
					
					РодительскаяСтрока = ОбщегоНазначения.КомментарийРасчета(ТекстСообщения, , , , Перечисления.ВидыСообщений.ВажнаяИнформация);
					Если ЗначениеЗаполнено(ТекстСообщенияРекомендации) Тогда
						ОбщегоНазначения.КомментарийРасчета(ТекстСообщенияРекомендации, РодительскаяСтрока);	
					КонецЕсли;
					
					ТекущийКодОшибки  = СтрокаТаблицыОшибок.КодОшибки;
					ТекущийВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
					
				КонецЕсли;	
				
				// выведем информацию о том, в каких строках табличных частей проблемы
				Если НовыйУчетПособий Тогда
					//поиск пособий делаем в "новых" табличных частях
					
					Если СтрокаТаблицыОшибок.ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.ПоУходуЗаРебенкомДоПолутораЛет Тогда
						ТекстТабличнаяЧасть = """Пособия по уходу за ребенком"", ";
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ПособияПоУходуЗаРебенкомДоПолутораЛет.НайтиСтроки(СтруктураПоискаНачисления);
					ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицыОшибок.ВидПособияСоциальногоСтрахования)Тогда
						ТекстТабличнаяЧасть = """Пособия по социальному страхованию"", ";
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ПособияСоциальномуСтрахованию.НайтиСтроки(СтруктураПоискаНачисления);
					ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицыОшибок.ПериодДействияНачало) Тогда
						ТекстТабличнаяЧасть = """Основные начисления"", ";
                        СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ОсновныеНачисления.НайтиСтроки(СтруктураПоискаНачисления);
					Иначе
						ТекстТабличнаяЧасть = """Дополнительные начисления"", ";
						СтруктураПоискаДополнительныеНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаДополнительныеНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаДополнительныеНачисления.ДокументОснование = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаДополнительныеНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ДополнительныеНачисления.НайтиСтроки(СтруктураПоискаДополнительныеНачисления);
					КонецЕсли;	
					
				Иначе
					
					Если ЗначениеЗаполнено(СтрокаТаблицыОшибок.ПериодДействияНачало) Тогда
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ОсновныеНачисления.НайтиСтроки(СтруктураПоискаНачисления);
						ТекстТабличнаяЧасть = """Основные начисления"", ";
					Иначе
						СтруктураПоискаДополнительныеНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаДополнительныеНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаДополнительныеНачисления.ДокументОснование = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаДополнительныеНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ДополнительныеНачисления.НайтиСтроки(СтруктураПоискаДополнительныеНачисления);
						ТекстТабличнаяЧасть = """Дополнительные начисления"", ";
					КонецЕсли;
					
				КонецЕсли;
				
				Для каждого СтрокаТЧ Из НайденныеСтроки Цикл
					ТекстСообщенияПоСтрокеТЧ = ТекстТабличнаяЧасть + "строка: " + СтрокаТЧ.НомерСтроки;
					ОбщегоНазначения.КомментарийРасчета(ТекстСообщенияПоСтрокеТЧ, РодительскаяСтрока);
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;	
		
	КонецЕсли;
	
	// восстановление движений документа
	Если ДокументОбъект.Проведен Тогда
		
		Для Каждого Набор Из ДокументОбъект.Движения Цикл
			Если ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНОсновныеНачисления")  Тогда
				
				НаборДвиженийОсновной.Записать();
				
			ИначеЕсли  ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНДополнительныеНачисления") Тогда
				
				НаборДвиженийДополнительный.Записать();
				
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого Набор Из ДокументОбъект.Движения Цикл
			Если ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНОсновныеНачисления") 
				или ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНДополнительныеНачисления") Тогда
				
				// Удаляем движения
				Набор.Очистить();
				Набор.Записать();
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // Автозаполнение()

Функция ПолучитьДополнительноеУсловиеЗапросаБазаФСС_НС() Экспорт

	Возврат "";

КонецФункции // ПолучитьДополнительноеУсловиеЗапросаБазаФСС_НС