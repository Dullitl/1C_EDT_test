#Если Клиент Тогда
	
Перем мНастройкаПериодаЗакупок Экспорт;
Перем мНастройкаПериодаПродаж Экспорт;
Перем СоставЗаказа Экспорт;
Перем ВнутренниеЗаказы Экспорт;
Перем мСоответствиеНазначений Экспорт;
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

Перем мТекущаяНастройка Экспорт;

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Склад КАК Склад,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Склад) КАК СкладПредставление,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Номенклатура) КАК НоменклатураПредставление,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.ХарактеристикаНоменклатуры) КАК ХарактеристикаНоменклатурыПредставление,
	|	ВложенныйЗапрос.Период КАК Период,
	|	Штрихкоды.Штрихкод КАК Штрихкод,
	|	СУММА(ВложенныйЗапрос.Продано) КАК Продано,
	|	СУММА(ВЫБОР
	|			КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.НТТ)
	|				ТОГДА ВложенныйЗапрос.КоличествоНачальныйОстатокНТТ
	|			КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.Розничный)
	|				ТОГДА ВложенныйЗапрос.КоличествоНачальныйОстатокРозничный
	|			ИНАЧЕ ВложенныйЗапрос.КоличествоНачальныйОстатокОптовый
	|		КОНЕЦ) КАК КоличествоНачальныйОстаток,
	|	СУММА(ВЫБОР
	|			КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.НТТ)
	|				ТОГДА ВложенныйЗапрос.КоличествоКонечныйОстатокНТТ
	|			КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.Розничный)
	|				ТОГДА ВложенныйЗапрос.КоличествоКонечныйОстатокРозничный
	|			ИНАЧЕ ВложенныйЗапрос.КоличествоКонечныйОстатокОптовый
	|		КОНЕЦ) КАК КоличествоКонечныйОстаток,
	|	СУММА(ВЫБОР
	|			КОГДА &ОстатокКНачалуПериодаЗакупок = 1
	|				ТОГДА ВЫБОР
	|						КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.НТТ)
	|							ТОГДА ЕСТЬNULL(ТоварыВНТТОстатки.КоличествоОстаток, 0)
	|						КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.Розничный)
	|							ТОГДА ЕСТЬNULL(ТоварыВРозницеОстатки.КоличествоОстаток, 0)
	|						ИНАЧЕ ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0)
	|					КОНЕЦ
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ОстатокКНачалуПериодаЗакупок = 2
	|						ТОГДА ВЫБОР
	|								КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.НТТ)
	|									ТОГДА ЕСТЬNULL(ТоварыВНТТОстатки.КоличествоОстаток, 0)
	|								КОГДА ВложенныйЗапрос.Склад.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.Розничный)
	|									ТОГДА ЕСТЬNULL(ТоварыВРозницеОстатки.КоличествоОстаток, 0)
	|								ИНАЧЕ ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0)
	|							КОНЕЦ + ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) - ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0)
	|				КОНЕЦ
	|		КОНЕЦ) КАК ОстатокНаДатуНачалаЗакупок
	|	//СВОЙСТВА
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры,
	|	Штрихкод
	|	//СВОЙСТВА
	|}
	|ИЗ
	|	(ВЫБРАТЬ
	|		Продажи.Склад КАК Склад,
	|		Продажи.Номенклатура КАК Номенклатура,
	|		Продажи.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		Продажи.Период КАК Период,
	|		СУММА(Продажи.Продано) КАК Продано,
	|		СУММА(Продажи.КоличествоНачальныйОстатокОптовый) КАК КоличествоНачальныйОстатокОптовый,
	|		СУММА(Продажи.КоличествоКонечныйОстатокОптовый) КАК КоличествоКонечныйОстатокОптовый,
	|		СУММА(Продажи.КоличествоНачальныйОстатокНТТ) КАК КоличествоНачальныйОстатокНТТ,
	|		СУММА(Продажи.КоличествоКонечныйОстатокНТТ) КАК КоличествоКонечныйОстатокНТТ,
	|		СУММА(Продажи.КоличествоНачальныйОстатокРозничный) КАК КоличествоНачальныйОстатокРозничный,
	|		СУММА(Продажи.КоличествоКонечныйОстатокРозничный) КАК КоличествоКонечныйОстатокРозничный
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ПродажиОбороты.ДокументПродажи.Склад КАК Склад,
	|			ПродажиОбороты.Номенклатура КАК Номенклатура,
	|			ПродажиОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			ПродажиОбороты.Период КАК Период,
	|			ПродажиОбороты.КоличествоОборот КАК Продано,
	|			0 КАК КоличествоНачальныйОстатокОптовый,
	|			0 КАК КоличествоКонечныйОстатокОптовый,
	|			0 КАК КоличествоНачальныйОстатокНТТ,
	|			0 КАК КоличествоКонечныйОстатокНТТ,
	|			0 КАК КоличествоНачальныйОстатокРозничный,
	|			0 КАК КоличествоКонечныйОстатокРозничный
	|		ИЗ
	|			РегистрНакопления.Продажи.Обороты(&ДатаНачПродаж, &ДатаКонПродаж, День, {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (ДокументПродажи.Склад).* КАК Склад}) КАК ПродажиОбороты
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ТоварыНаСкладахОстаткиИОбороты.Склад,
	|			ТоварыНаСкладахОстаткиИОбороты.Номенклатура,
	|			ТоварыНаСкладахОстаткиИОбороты.ХарактеристикаНоменклатуры,
	|			ТоварыНаСкладахОстаткиИОбороты.Период,
	|			0,
	|			ТоварыНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток,
	|			ТоварыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток,
	|			0,
	|			0,
	|			0,
	|			0
	|		ИЗ
	|			РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, День, , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыНаСкладахОстаткиИОбороты
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ТоварыВНТТОстаткиИОбороты.Склад,
	|			ТоварыВНТТОстаткиИОбороты.Номенклатура,
	|			ТоварыВНТТОстаткиИОбороты.ХарактеристикаНоменклатуры,
	|			ТоварыВНТТОстаткиИОбороты.Период,
	|			0,
	|			0,
	|			0,
	|			ТоварыВНТТОстаткиИОбороты.КоличествоНачальныйОстаток,
	|			ТоварыВНТТОстаткиИОбороты.КоличествоКонечныйОстаток,
	|			0,
	|			0
	|		ИЗ
	|			РегистрНакопления.ТоварыВНТТ.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, День, , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыВНТТОстаткиИОбороты
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ТоварыВРозницеОстаткиИОбороты.Склад,
	|			ТоварыВРозницеОстаткиИОбороты.Номенклатура,
	|			ТоварыВРозницеОстаткиИОбороты.ХарактеристикаНоменклатуры,
	|			ТоварыВРозницеОстаткиИОбороты.Период,
	|			0,
	|			0,
	|			0,
	|			0,
	|			0,
	|			ТоварыВРозницеОстаткиИОбороты.КоличествоНачальныйОстаток,
	|			ТоварыВРозницеОстаткиИОбороты.КоличествоКонечныйОстаток
	|		ИЗ
	|			РегистрНакопления.ТоварыВРознице.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, День, , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыВРозницеОстаткиИОбороты
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			Склады.Склад,
	|			Номенклатура.Ссылка,
	|			ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|			НЕОПРЕДЕЛЕНО,
	|			0,
	|			0,
	|			0,
	|			0,
	|			0,
	|			0,
	|			0
	|		ИЗ
	|			Справочник.Номенклатура КАК Номенклатура
	|				ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					ПродажиОбороты.ДокументПродажи.Склад КАК Склад
	|				ИЗ
	|					РегистрНакопления.Продажи.Обороты(&ДатаНачПродаж, &ДатаКонПродаж, , ДокументПродажи.Склад ЕСТЬ НЕ NULL  {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (ДокументПродажи.Склад).* КАК Склад}) КАК ПродажиОбороты
	|				
	|				ОБЪЕДИНИТЬ
	|				
	|				ВЫБРАТЬ
	|					ТоварыНаСкладахОстаткиИОбороты.Склад
	|				ИЗ
	|					РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, , , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыНаСкладахОстаткиИОбороты
	|				
	|				ОБЪЕДИНИТЬ
	|				
	|				ВЫБРАТЬ
	|					ТоварыВНТТОстаткиИОбороты.Склад
	|				ИЗ
	|					РегистрНакопления.ТоварыВНТТ.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, , , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыВНТТОстаткиИОбороты
	|				
	|				ОБЪЕДИНИТЬ
	|				
	|				ВЫБРАТЬ
	|					ТоварыВРозницеОстаткиИОбороты.Склад
	|				ИЗ
	|					РегистрНакопления.ТоварыВРознице.ОстаткиИОбороты(&ДатаНачПродаж, &ДатаКонПродаж, , , {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (Склад).* КАК Склад}) КАК ТоварыВРозницеОстаткиИОбороты) КАК Склады
	|				ПО (&ПоВсейНоменклатуре = ИСТИНА)
	|		ГДЕ
	|			Номенклатура.ЭтоГруппа = ЛОЖЬ
	|			И &ПоВсейНоменклатуре = ИСТИНА
	|		{ГДЕ
	|			Номенклатура.Ссылка.* КАК Номенклатура}) КАК Продажи
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Продажи.Склад,
	|		Продажи.Номенклатура,
	|		Продажи.ХарактеристикаНоменклатуры,
	|		Продажи.Период) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаНачЗакупок, {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ТоварыНаСкладахОстатки
	|		ПО ВложенныйЗапрос.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры
	|			И ВложенныйЗапрос.Склад = ТоварыНаСкладахОстатки.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВНТТ.Остатки(&ДатаНачЗакупок, {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ТоварыВНТТОстатки
	|		ПО ВложенныйЗапрос.Номенклатура = ТоварыВНТТОстатки.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = ТоварыВНТТОстатки.ХарактеристикаНоменклатуры
	|			И ВложенныйЗапрос.Склад = ТоварыВНТТОстатки.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРознице.Остатки(&ДатаНачЗакупок, {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ТоварыВРозницеОстатки
	|		ПО ВложенныйЗапрос.Номенклатура = ТоварыВРозницеОстатки.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = ТоварыВРозницеОстатки.ХарактеристикаНоменклатуры
	|			И ВложенныйЗапрос.Склад = ТоварыВРозницеОстатки.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказыПоставщикамОстатки.ЗаказПоставщику.Склад КАК Склад,
	|			ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	|			ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			СУММА(ЗаказыПоставщикамОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|		ИЗ
	|			РегистрНакопления.ЗаказыПоставщикам.Остатки(&ДатаКонЗакупок, ЗаказПоставщику.ДатаПоступления <= &ДатаНачалаЗакупок {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (ЗаказПоставщику.Склад).* КАК Склад}) КАК ЗаказыПоставщикамОстатки
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЗаказыПоставщикамОстатки.ЗаказПоставщику.Склад,
	|			ЗаказыПоставщикамОстатки.Номенклатура,
	|			ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры) КАК ЗаказыПоставщикамОстатки
	|		ПО ВложенныйЗапрос.Номенклатура = ЗаказыПоставщикамОстатки.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры
	|			И ВложенныйЗапрос.Склад = ЗаказыПоставщикамОстатки.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказыПокупателейОстатки.ЗаказПокупателя.СкладГруппа КАК Склад,
	|			ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
	|			ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			СУММА(ЗаказыПокупателейОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|		ИЗ
	|			РегистрНакопления.ЗаказыПокупателей.Остатки(
	|					&ДатаКонЗакупок,
	|					ЗаказПокупателя.ДатаОтгрузки <= &ДатаНачалаЗакупок
	|						И ЗаказПокупателя.СкладГруппа ССЫЛКА Справочник.Склады {(Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (ЗаказПокупателя.СкладГруппа).* КАК Склад}) КАК ЗаказыПокупателейОстатки
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЗаказыПокупателейОстатки.ЗаказПокупателя.СкладГруппа,
	|			ЗаказыПокупателейОстатки.Номенклатура,
	|			ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры) КАК ЗаказыПокупателейОстатки
	|		ПО ВложенныйЗапрос.Номенклатура = ЗаказыПокупателейОстатки.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры
	|			И ВложенныйЗапрос.Склад = ЗаказыПокупателейОстатки.Склад
	|		{ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Штрихкоды.Владелец КАК Номенклатура,
	|			Штрихкоды.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			МАКСИМУМ(Штрихкоды.Штрихкод) КАК Штрихкод
	|		ИЗ
	|			РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ГДЕ
	|			Штрихкоды.Владелец ССЫЛКА Справочник.Номенклатура
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Штрихкоды.Владелец,
	|			Штрихкоды.ХарактеристикаНоменклатуры) КАК Штрихкоды
	|		ПО ВложенныйЗапрос.Номенклатура = Штрихкоды.Номенклатура
	|			И ВложенныйЗапрос.ХарактеристикаНоменклатуры = Штрихкоды.ХарактеристикаНоменклатуры}
	|	//СОЕДИНЕНИЯ
	|{ГДЕ
	|	ВложенныйЗапрос.Склад.* КАК Склад,
	|	ВложенныйЗапрос.Номенклатура.* КАК Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Склад,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.Период,
	|	Штрихкоды.Штрихкод
	|	//СГРУППИРОВАТЬПО
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склад,
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры,
	|	Период
	|ИТОГИ
	|	МАКСИМУМ(Штрихкод),
	|	СУММА(Продано),
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(КоличествоКонечныйОстаток),
	|	МАКСИМУМ(ОстатокНаДатуНачалаЗакупок)
	|	//ИТОГИ_СВОЙСТВА
	|ПО
	|	Склад,
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры
	|{ИТОГИ ПО
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры}
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	СтруктураПредставлениеПолей = Новый Структура(
	"Номенклатура,
	|ХарактеристикаНоменклатуры,
	|Штрихкод",
	"Номенклатура",
	"Характеристика номенклатуры",
	"Штрих-код");
	
	//Отборы по свойствам и категориям
	мСоответствиеНазначений = Новый Соответствие;
	
	ТаблицаПолей = Новый ТаблицаЗначений;
	ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и
												   // категории. Используется в условии соединения с регистром сведений,
												   // хранящим значения свойств или категорий
	ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
	ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
	ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта
	
	СтрокаТаблицы = ТаблицаПолей.Добавить();
		
	СтрокаТаблицы.ПутьКДанным = "ВложенныйЗапрос.Склад";
	СтрокаТаблицы.Представление = "Склад";
	СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады;
		
	СтрокаТаблицы = ТаблицаПолей.Добавить();
		
	СтрокаТаблицы.ПутьКДанным = "ВложенныйЗапрос.Номенклатура";
	СтрокаТаблицы.Представление = "Номенклатура";
	СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;
	
	СтрокаТаблицы = ТаблицаПолей.Добавить();
		
	СтрокаТаблицы.ПутьКДанным = "ВложенныйЗапрос.ХарактеристикаНоменклатуры";
	СтрокаТаблицы.Представление = "Характеристика номенклатуры";
	СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры;
	
	ТекстПоляКатегорий = "";
	ТекстПоляСвойств = "";
	
	_ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, 
			мСоответствиеНазначений, ПостроительОтчета.Параметры
			,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,мСтруктураДляОтбораПоКатегориям);
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Склад");

	ПостроительОтчета.Текст = ТекстЗапроса;
	
	УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, СтруктураПредставлениеПолей);
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	ПостроительОтчета.ВыбранныеПоля.Очистить();
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// В текст для построителя отчета вставляет свойства и категории
Процедура _ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, мСоответствиеНазначений, 
	                                          СтруктураПараметры, ТекстИсточникиСведений="", ТекстПоляКатегорий="", 
	                                          ТекстПоляСвойств="", ТекстПоляСгруппироватьПо = "", 
	                                          ЗаменятьСвойства = "//СВОЙСТВА", ЗаменятьКатегории = "//КАТЕГОРИИ", 
	                                          ЗаменятьСоединения = "//СОЕДИНЕНИЯ", ЗаменятьСгруппироватьПо = "//СГРУППИРОВАТЬПО",
	                                          ИдентификаторыПараметровДляОтборовПоКатегориям = "") Экспорт

	// Добавляемые фрагменты запроса
	ТекстПоляКатегорийДляГруппировки = "";
	ТекстПоляСвойствДляГруппировки = "";
	ТекстИсточникиСведений = "";
	ТекстПоляКатегорий = "";
	ТекстПоляСвойств = "";
	ТекстИтогиСвойств = "";
	
	Если НЕ ТипЗнч(ИдентификаторыПараметровДляОтборовПоКатегориям) = Тип("Структура") Тогда
		
		ИдентификаторыПараметровДляОтборовПоКатегориям = Новый Структура;
		
	КонецЕсли;

	Индекс = 0;

	СвойстваОбъектов = ПланыВидовХарактеристик.СвойстваОбъектов.Выбрать();
	
	Пока СвойстваОбъектов.Следующий() Цикл

		Если СвойстваОбъектов.ЭтоГруппа ИЛИ СвойстваОбъектов.ПометкаУдаления Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если СвойстваОбъектов.ТипЗначения.Типы().Количество() > 1 Тогда
			
			ПараметрПустоеЗначениеСвойства = "Неопределено";
			
		Иначе
			
			ТипСвойства = СвойстваОбъектов.ТипЗначения.Типы()[0];
			ВозможныеТипыСвойств = Метаданные.ПланыВидовХарактеристик.СвойстваОбъектов.Тип.Типы();
			
			ИндексТекущегоВозможногоТипа = 0;
			
			Для каждого ВозможныйТипСвойства из ВозможныеТипыСвойств Цикл
				
				Если ВозможныйТипСвойства = ТипСвойства Тогда
					
					ПараметрПустоеЗначениеСвойства = "&ПараметрПустоеЗначениеСвойства" + ИндексТекущегоВозможногоТипа;
					
				КонецЕсли;
				
				ИндексТекущегоВозможногоТипа = ИндексТекущегоВозможногоТипа + 1;
				
			КонецЦикла;
			
		КонецЕсли;

		Поля = ТаблицаПолей.НайтиСтроки(Новый Структура("Назначение", СвойстваОбъектов.НазначениеСвойства));
		
		Для каждого Поле из Поля Цикл
			
			// Для списка всех полей
			ТекстПоляСвойств = ТекстПоляСвойств + ",
			|	ЕСТЬNULL (Свойство" + Индекс + ".Значение, " + ПараметрПустоеЗначениеСвойства + ") КАК Свойство" + Индекс + "Значение";
			
			ТекстПоляСвойствДляГруппировки = ТекстПоляСвойствДляГруппировки + ",
			|	Свойство" + Индекс + ".Значение";

			// Для итогов
			ТекстИтогиСвойств = ТекстИтогиСвойств + ",
			|	МАКСИМУМ(Свойство" + Индекс + "Значение)";
			
			// Источник для свойств
			ТекстИсточникиСведений = ТекстИсточникиСведений + Символы.ПС + 
			"	{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК Свойство" + Индекс + "
			|	ПО Свойство" + Индекс + ".Объект = " + Поле.ПутьКДанным + "
			|	И  Свойство" + Индекс + ".Свойство = &ПараметрСвойство" + Индекс + "}";

			СтруктураПараметры.Вставить("ПараметрСвойство" + Индекс, СвойстваОбъектов.Ссылка);

			СтруктураПредставлениеПолей.Вставить("Свойство" + Индекс + "Значение", СвойстваОбъектов.Наименование + " (св-во " + Поле.Представление + ")");

			мСоответствиеНазначений.Вставить(СвойстваОбъектов.Наименование + " (св-во " + Поле.Представление + ")", СвойстваОбъектов.Ссылка);

			Индекс = Индекс + 1;

		КонецЦикла;	

	КонецЦикла;

	Для каждого Строка Из ТаблицаПолей Цикл

		Если НЕ (Строка.НетКатегорий = Истина) Тогда

			ТекстИсточникиСведений = ТекстИсточникиСведений + Символы.ПС + 
			"	{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК Категории" + Индекс + "
			|	ПО Категории" + Индекс + ".Объект = " + Строка.ПутьКДанным + "
			|	И  Категории" + Индекс + ".Категория В (&ПараметрКатегории" + Индекс + ")}";

			ТекстПоляКатегорий = ТекстПоляКатегорий + ",
			|	ЕСТЬNULL(Категории" + Индекс + ".Категория, " + Строка.ПутьКДанным + ") КАК Категории" + Индекс + "Категория";

			ТекстПоляКатегорийДляГруппировки = ТекстПоляКатегорийДляГруппировки + ",
			|	Категории" + Индекс + ".Категория";

			СтруктураПредставлениеПолей.Вставить("Категории" + Индекс + "Категория", "Категории " + Строка.Представление);

			ИдентификаторыПараметровДляОтборовПоКатегориям.Вставить("Категории" + Индекс + "Категория", "ПараметрКатегории" + Индекс);

			мСоответствиеНазначений.Вставить("Категории " + Строка.Представление, Строка.Назначение);

			Индекс = Индекс + 1;

		КонецЕсли; 
	
	КонецЦикла; 

	//ВЫБРАТЬ РАЗЛИЧНЫЕ съедает достаточно много ресурсов - поэтому если 
	//не надо, то обойдемся без него.
	Если ТекстПоляКатегорийДляГруппировки <> "" Тогда

		Текст = СтрЗаменить(Текст, "//РАЗЛИЧНЫЕ", "РАЗЛИЧНЫЕ");

	КонецЕсли;
	
	Текст = СтрЗаменить(Текст, ЗаменятьСвойства, ТекстПоляСвойств);
	Текст = СтрЗаменить(Текст, ЗаменятьКатегории, ТекстПоляКатегорий);
	Текст = СтрЗаменить(Текст, ЗаменятьСоединения, ТекстИсточникиСведений);
	Текст = СтрЗаменить(Текст, ЗаменятьСгруппироватьПо, ТекстПоляСвойствДляГруппировки + ТекстПоляКатегорийДляГруппировки);
	Текст = СтрЗаменить(Текст, "//ИТОГИ_СВОЙСТВА", ТекстИтогиСвойств);

КонецПроцедуры // УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории()

Процедура УстановитьШиринуКолонки(ТабДок, ИмяКолонки, Ширина) Экспорт
	
	ТекущаяОбласть = Неопределено;
	
	Пока Истина Цикл
		
	    ТекущаяОбласть = ТабДок.НайтиТекст(ИмяКолонки, ТекущаяОбласть, ТабДок.Область(), Истина, Истина, Истина, Ложь);
		
	    Если ТекущаяОбласть <> Неопределено Тогда
			
            ТекущаяОбласть.ШиринаКолонки = Ширина;
			
		Иначе
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВосстановитьНастройки() Экспорт
	
	Перем СохраненнаяНастройка;
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	СтруктураНастройки.Вставить("ИмяОбъекта", Строка(ЭтотОбъект));
	СтруктураНастройки.Вставить("НаименованиеНастройки", ?(мТекущаяНастройка = Неопределено, Неопределено, мТекущаяНастройка.НаименованиеНастройки));
	
	Результат = УниверсальныеМеханизмы.ВосстановлениеНастроек(СтруктураНастройки);
	
	Если Результат <> Неопределено Тогда
			
		мТекущаяНастройка = Результат;
		ВосстановитьНастройкиИзСтруктуры(Результат.СохраненнаяНастройка);
			
	Иначе
		
		мТекущаяНастройка = СтруктураНастройки;
		
	КонецЕсли;

КонецФункции // ВосстановитьНастройки()

Процедура СохранитьНастройки() Экспорт
	
	Перем СохраненнаяНастройка;
	
	СформироватьСтруктуруДляСохраненияНастроек(СохраненнаяНастройка);
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	СтруктураНастройки.Вставить("ИмяОбъекта", Строка(ЭтотОбъект));
	СтруктураНастройки.Вставить("НаименованиеНастройки", ?(мТекущаяНастройка = Неопределено, Неопределено, мТекущаяНастройка.НаименованиеНастройки));
	СтруктураНастройки.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);
	СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", Ложь);
	СтруктураНастройки.Вставить("СохранятьАвтоматически", Ложь);
	
	Результат = УниверсальныеМеханизмы.СохранениеНастроек(СтруктураНастройки);
	
	Если Результат <> Неопределено Тогда
			
		мТекущаяНастройка = Результат;
			
	Иначе
		
		мТекущаяНастройка = СтруктураНастройки;
		
	КонецЕсли;
	
КонецПроцедуры // СохранитьНастройки()

Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	Если ТипЗнч(СтруктураСНастройками) <> Тип("Структура") Тогда
		
		СтруктураСНастройками = Новый Структура;
		
	КонецЕсли;
	
	мНастройкаПериодаПродаж.ДатаНачала = ДатаНачПродаж;
	мНастройкаПериодаПродаж.ДатаОкончания = ДатаКонПродаж;
	
	мНастройкаПериодаЗакупок.ДатаНачала = ДатаНачЗакупок;
	мНастройкаПериодаЗакупок.ДатаОкончания = ДатаКонЗакупок;
	
	СтруктураСНастройками.Вставить("НастройкиПостроителя", ПостроительОтчета.ПолучитьНастройки());
	СтруктураСНастройками.Вставить("НастройкаПериодаПродаж", мНастройкаПериодаПродаж);
	СтруктураСНастройками.Вставить("НастройкаПериодаЗакупок", мНастройкаПериодаЗакупок);
	СтруктураСНастройками.Вставить("РабочаяНеделя", РабочаяНеделя);
	СтруктураСНастройками.Вставить("ОстатокКНачалуПериодаЗакупок", ОстатокКНачалуПериодаЗакупок);
	СтруктураСНастройками.Вставить("ОкруглятьВБольшуюСторону", ОкруглятьВБольшуюСторону);
	СтруктураСНастройками.Вставить("ПорядокОкругления", ПорядокОкругления);
	СтруктураСНастройками.Вставить("ПоказатьТолькоНеобходимыеЗакупки", ПоказатьТолькоНеобходимыеЗакупки);
	СтруктураСНастройками.Вставить("ПоВсейНоменклатуре", ПоВсейНоменклатуре);
	СтруктураСНастройками.Вставить("ТипЦенНоменклатуры", ТипЦенНоменклатуры);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, Отчет = Неопределено) Экспорт
	
	Перем ТаблицаЗначенийСклады, ТаблицаЗначенийтипыЦен, СохраненнаяНастройкаПериодаПродаж, СохраненнаяНастройкаПериодаЗакупок;
	
	Если ТипЗнч(СтруктураСНастройками) <> Тип("Структура") Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтруктураСНастройками.Свойство("НастройкаПериодаПродаж", СохраненнаяНастройкаПериодаПродаж);
	
	Если ТипЗнч(СохраненнаяНастройкаПериодаПродаж) = Тип("НастройкаПериода") Тогда
		
		мНастройкаПериодаПродаж = СохраненнаяНастройкаПериодаПродаж;
		ДатаНачПродаж = мНастройкаПериодаПродаж.ДатаНачала;
		ДатаКонПродаж = мНастройкаПериодаПродаж.ДатаОкончания;
		
	Иначе
		
		СтруктураСНастройками.Свойство("ДатаНачПродаж", ДатаНачПродаж);
		СтруктураСНастройками.Свойство("ДатаКонПродаж", ДатаКонПродаж);
		
	КонецЕсли;
	
	СтруктураСНастройками.Свойство("НастройкаПериодаЗакупок", СохраненнаяНастройкаПериодаЗакупок);
	
	Если ТипЗнч(СохраненнаяНастройкаПериодаЗакупок) = Тип("НастройкаПериода") Тогда
		
		мНастройкаПериодаЗакупок = СохраненнаяНастройкаПериодаЗакупок;
		ДатаНачЗакупок = мНастройкаПериодаЗакупок.ДатаНачала;
		ДатаКонЗакупок = мНастройкаПериодаЗакупок.ДатаОкончания;
		
	Иначе
		
		СтруктураСНастройками.Свойство("ДатаНачЗакупок", ДатаНачЗакупок);
		СтруктураСНастройками.Свойство("ДатаКонЗакупок", ДатаКонЗакупок);
		
	КонецЕсли;
	
	СтруктураСНастройками.Свойство("РабочаяНеделя", РабочаяНеделя);
	СтруктураСНастройками.Свойство("ОстатокКНачалуПериодаЗакупок", ОстатокКНачалуПериодаЗакупок);
	СтруктураСНастройками.Свойство("ОкруглятьВБольшуюСторону", ОкруглятьВБольшуюСторону);
	СтруктураСНастройками.Свойство("ПорядокОкругления", ПорядокОкругления);
	СтруктураСНастройками.Свойство("ПоказатьТолькоНеобходимыеЗакупки", ПоказатьТолькоНеобходимыеЗакупки);
	СтруктураСНастройками.Свойство("ПоВсейНоменклатуре", ПоВсейНоменклатуре);	
	СтруктураСНастройками.Свойство("ТипЦенНоменклатуры", ТипЦенНоменклатуры);	
	
	ЗаполнитьНачальныеНастройки();
	
	ПостроительОтчета.УстановитьНастройки(СтруктураСНастройками.НастройкиПостроителя);
	
	Возврат Истина;
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мНастройкаПериодаЗакупок = Новый НастройкаПериода;
мНастройкаПериодаЗакупок.ВариантНастройки = ВариантНастройкиПериода.Период;

мНастройкаПериодаПродаж = Новый НастройкаПериода;
мНастройкаПериодаПродаж.ВариантНастройки = ВариантНастройкиПериода.Период;

СоставЗаказа = Новый ТаблицаЗначений;
СоставЗаказа.Колонки.Добавить("Номенклатура");
СоставЗаказа.Колонки.Добавить("ХарактеристикаНоменклатуры");
СоставЗаказа.Колонки.Добавить("Количество");

ВнутренниеЗаказы = Новый ТаблицаЗначений;
ВнутренниеЗаказы.Колонки.Добавить("Склад");
ВнутренниеЗаказы.Колонки.Добавить("Номенклатура");
ВнутренниеЗаказы.Колонки.Добавить("ХарактеристикаНоменклатуры");
ВнутренниеЗаказы.Колонки.Добавить("Количество");

#КонецЕсли