Перем мУдалятьДвижения;
Перем мВалютаРегламентированногоУчета Экспорт;

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПланаПродаж()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ВедениеУчетаПоПроектам", УправлениеПроектами.ВедениеУчетаПоПроектам());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланПродаж.Номер КАК Номер,
	|	ПланПродаж.Дата КАК Дата,
	|	NULL КАК Организация,
	|	ПланПродаж.Подразделение КАК Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(ПланПродаж.Подразделение) КАК ПодразделениеПредставление,
	|	ПланПродаж.Сценарий КАК Сценарий,
	|	ПРЕДСТАВЛЕНИЕ(ПланПродаж.Сценарий) КАК СценарийПредставление,
	|	ВЫБОР
	|		КОГДА &ВедениеУчетаПоПроектам = ИСТИНА
	|			ТОГДА ПланПродаж.Проект
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК Проект,
	|	ВЫБОР
	|		КОГДА &ВедениеУчетаПоПроектам = ИСТИНА
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ПланПродаж.Проект)
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК ПроектПредставление,
	|	ПланПродаж.Сценарий.Периодичность КАК Периодичность,
	|	ПРЕДСТАВЛЕНИЕ(ПланПродаж.Сценарий.Периодичность) КАК ПериодичностьПредставление,
	|	ПланПродаж.ДатаПланирования КАК ДатаПланирования,
	|	ПланПродаж.УчитыватьНДС КАК УчитыватьНДС,
	|	ПланПродаж.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ПланПродаж.Ответственный КАК Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ПланПродаж.Ответственный) КАК ОтветственныйПредставление,
	|	ПланПродаж.СоставПлана.(
	|		НомерСтроки КАК НомерСтроки,
	|		Контрагент КАК Контрагент,
	|		Договор КАК Договор,
	|		Номенклатура КАК Номенклатура,
	|		ВЫБОР
	|			КОГДА ПланПродаж.СоставПлана.Номенклатура.НаименованиеПолное ЕСТЬ NULL 
	|				ТОГДА ПланПродаж.СоставПлана.Номенклатура.Наименование
	|			ИНАЧЕ ВЫБОР
	|					КОГДА (ВЫРАЗИТЬ(ПланПродаж.СоставПлана.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|						ТОГДА ПланПродаж.СоставПлана.Номенклатура.Наименование
	|					ИНАЧЕ ПланПродаж.СоставПлана.Номенклатура.НаименованиеПолное
	|				КОНЕЦ
	|		КОНЕЦ КАК НоменклатураПредставление,
	|		ХарактеристикаНоменклатуры КАК Характеристика,
	|		NULL КАК Серия,
	|		Заказ КАК Заказ,
	|		Заказ.Номер КАК ЗаказНомер,
	|		Заказ.Дата КАК ЗаказДата,
	|		Количество,
	|		ПРЕДСТАВЛЕНИЕ(ПланПродаж.СоставПлана.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|		Цена,
	|		Сумма,
	|		СуммаНДС
	|	)
	|ИЗ
	|	Документ.ПланПродаж КАК ПланПродаж
	|ГДЕ
	|	ПланПродаж.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	ВыборкаСоставПлана = Шапка.СоставПлана.Выбрать();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПланПродаж_ПланПродаж";
	Макет = ПолучитьМакет("ПланПродаж");

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "План продаж");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	
	ДатаНачала = Шапка.ДатаПланирования;
	ДатаОкончания = Шапка.ДатаПланирования;
	УправлениеПланированием.ВыровнятьПериод(ДатаНачала, ДатаОкончания, Шапка.Периодичность);

	ОбластьМакета.Параметры.ПериодПланирования = ПредставлениеПериода(ДатаНачала, ДатаОкончания, "ФП=Истина");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	ВыборкаСоставПлана = Шапка.СоставПлана.Выбрать();
	Пока ВыборкаСоставПлана.Следующий() Цикл
		
		ОбластьСтроки.Параметры.Заполнить(ВыборкаСоставПлана);
		ОбластьСтроки.Параметры.НоменклатураПредставление = ВыборкаСоставПлана.НоменклатураПредставление + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСоставПлана);
		Если НЕ ЗначениеЗаполнено(ВыборкаСоставПлана.Заказ) Тогда
			ОбластьСтроки.Параметры.ЗаказПредставление = "";
		Иначе
			ОбластьСтроки.Параметры.ЗаказПредставление = ВыборкаСоставПлана.ЗаказНомер + " от " + Формат(ВыборкаСоставПлана.ЗаказДата, "ДФ=dd.MM.yyyy");
		КонецЕсли;
		ОбластьСтроки.Параметры.Всего = ВыборкаСоставПлана.Сумма + ?(Шапка.СуммаВключаетНДС = Истина, 0, ВыборкаСоставПлана.СуммаНДС);

		ТабДокумент.Вывести(ОбластьСтроки);
		
	КонецЦикла;

	ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ОтветственныйПредставление = "/" + Шапка.ОтветственныйПредставление + "/";
	ОбластьМакета.Параметры.ИтогоВсего = СоставПлана.Итог("Сумма") + ?(Шапка.СуммаВключаетНДС = Истина, 0, СоставПлана.Итог("СуммаНДС"));
	ОбластьМакета.Параметры.ИтогоСтоимость = СоставПлана.Итог("Сумма");
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьПланаПродаж()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Сценарий) Тогда
		Сообщить("Не указан сценарий планирования!");
		Возврат;
	КонецЕсли;
	
	Если ИмяМакета = "ПланПродаж" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьПланаПродаж();
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ПланПродаж", "План продаж");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоСоставПлана - результат запроса по табличной части "СоставПлана",
//  ВыборкаПоШапкеДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуСоставПлана(РезультатЗапросаПоСоставПлана, ВыборкаПоШапкеДокумента)

	ТаблицаСоставПлана = РезультатЗапросаПоСоставПлана.Выгрузить();

	// Переименуем колонку "Сумма" в "Стоимость" (как в регистрах).
	ТаблицаСоставПлана.Колонки.Сумма.Имя = "Стоимость";

	// Надо рассчитать стоимость без НДС.
	Для каждого СтрокаТаблицы Из ТаблицаСоставПлана Цикл

		СтрокаТаблицы.Стоимость = СтрокаТаблицы.Стоимость - 
		                          ?(УчитыватьНДС И СуммаВключаетНДС, СтрокаТаблицы.НДС, 0);

		// Суммы пересчитаем в валюту упр. учета
		СтрокаТаблицы.Стоимость = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Стоимость, ВалютаДокумента,
		                                 ВыборкаПоШапкеДокумента.ВалютаУправленческогоУчета, 
		                                 КурсДокумента,
		                                 ВыборкаПоШапкеДокумента.КурсВалютыУправленческогоУчета, 
		                                 КратностьДокумента,
		                                 ВыборкаПоШапкеДокумента.КратностьВалютыУправленческогоУчета);

		СтрокаТаблицы.НДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.НДС, ВалютаДокумента,
		                                 ВыборкаПоШапкеДокумента.ВалютаУправленческогоУчета, 
		                                 КурсДокумента,
		                                 ВыборкаПоШапкеДокумента.КурсВалютыУправленческогоУчета, 
		                                 КратностьДокумента,
		                                 ВыборкаПоШапкеДокумента.КратностьВалютыУправленческогоУчета);
										 
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументПланирования) Тогда
			
			СтрокаТаблицы.ДокументПланирования = Ссылка;
			
		КонецЕсли;

	КонецЦикла;

	Возврат ТаблицаСоставПлана;

КонецФункции // ПодготовитьТаблицуСоставПлана()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ВалютаДокумента, КурсДокумента, КратностьДокумента,
	                        					 |ДатаПланирования, Сценарий");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "СоставПлана".
//
// Параметры:
// Параметры: 
//  ТаблицаПоСоставПлана    - таблица значений, содержащая данные для проведения и проверки ТЧ СоставПлана
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиСоставПлана(ТаблицаПоСоставПлана, ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура");
	
	Если Сценарий.УчетПоКоличеству Тогда
		
		СтруктураОбязательныхПолей.Вставить("Количество");
		
	КонецЕсли;
	
	Если Сценарий.УчетПоСуммам И НЕ Сценарий.УчетПоКоличеству Тогда
		
		СтруктураОбязательныхПолей.Вставить("Сумма");
		СтруктураОбязательныхПолей.Вставить("СтавкаНДС");
		
	КонецЕсли;

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "СоставПлана", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "СоставПлана", ТаблицаПоСоставПлана, Отказ, Заголовок);
	
	// Здесь наборов-комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "СоставПлана", ТаблицаПоСоставПлана, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиСоставПлана()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  ВыборкаПоШапкеДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоСоставПлана      - таблица значений, содержащая данные для проведения и проверки ТЧ СоставПлана
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, ТаблицаПоСоставПлана, Отказ, Заголовок)

	// ПО регистру "ПланыПродаж".
	
	НаборДвижений = Движения.ПланыПродаж;
	
	// Получим таблицу значений, совпадающую со структурой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	// Заполним таблицу движений.
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаПоСоставПлана, ТаблицаДвижений);
	
	// Недостающие поля.
	ТаблицаДвижений.ЗаполнитьЗначения(Сценарий, "Сценарий");
	ТаблицаДвижений.ЗаполнитьЗначения(Подразделение, "Подразделение");
	Если УправлениеПроектами.ВедениеУчетаПоПроектам() Тогда
		ТаблицаДвижений.ЗаполнитьЗначения(Проект, "Проект");
	КонецЕсли;	
	
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Если Не Отказ Тогда
		
		Движения.ПланыПродаж.ДобавитьДвижение();
		
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, СоставПлана);
	
	Для каждого Строка из СоставПлана Цикл
		
		Если НЕ Сценарий.УчетПоКоличеству И Строка.Количество <> 0 Тогда
			
			Строка.Количество =  0;
			
		КонецЕсли;
		
		Если НЕ Сценарий.УчетПоСуммам  
			И (Строка.Цена <> 0 ИЛИ Строка.Сумма <> 0 ИЛИ Строка.СуммаНДС <> 0) 
			Тогда
			
			Строка.Цена = 0;
			Строка.Сумма = 0;
			Строка.СуммаНДС = 0;
			
		КонецЕсли;
		
	КонецЦикла;

	// Посчитать сумму документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "СоставПлана");

	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
		
	КонецЕсли;

	ГраницаФиксации = УправлениеПланированием.ПолучитьГраницуФиксацииПериодов(Перечисления.ВидыПланирования.Продажи, Подразделение, Проект, Сценарий);
	
	Если ДатаПланирования <= ГраницаФиксации Тогда
		
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Документ не может быть проведен, поскольку дата планирования находится в закрытом периоде (до " + Формат(ГраницаФиксации, "ДФ=dd.MM.yyyy; ДЛФ=D") + ").", Отказ);
		Возврат;
		
	КонецЕсли;
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "ВалютаУправленческогоУчета", "ВалютаУправленческогоУчета");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "КурсВалютыУправленческогоУчета", "КурсВалютыУправленческогоУчета");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Получим необходимые данные для проведения и проверки заполнения данные по табличной части "СоставПлана".
	СтруктураПолей = УправлениеЗапасами.СформироватьСтруктуруПолейТовары();
	
	СтруктураПолей.Вставить("Набор", "Номенклатура.Набор");
 	СтруктураПолей.Вставить("Комплект", "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Заказ", "Заказ");
	СтруктураПолей.Вставить("Контрагент", "Контрагент");
	СтруктураПолей.Вставить("Договор", "Договор");
	СтруктураПолей.Вставить("Источник", "Источник");
	СтруктураПолей.Вставить("ДокументПланирования", "Источник");
	СтруктураПолей.Вставить("ВариантРаспределения", "ВариантРаспределения");
	СтруктураПолей.Удалить("СтавкаНДС");
	СтруктураПолей.Удалить("СерияНоменклатуры");

	СтруктураСложныхПолей = Новый Структура;
	СтруктураСложныхПолей.Вставить("Период",
	"ВЫБОР
	|	КОГДА РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(Док.Период, " + ?(ПериодичностьДетализации = Перечисления.Периодичность.ПустаяСсылка(), ?(Сценарий.Периодичность = Перечисления.Периодичность.ПустаяСсылка(), "ДЕНЬ", Строка(Сценарий.Периодичность)), Строка(ПериодичностьДетализации)) + "), Док.Ссылка.ДатаПланирования, ДЕНЬ) > 0
	|		ТОГДА Док.Ссылка.ДатаПланирования
	|	ИНАЧЕ НАЧАЛОПЕРИОДА(Док.Период, " + ?(ПериодичностьДетализации = Перечисления.Периодичность.ПустаяСсылка(), ?(Сценарий.Периодичность = Перечисления.Периодичность.ПустаяСсылка(), "ДЕНЬ", Строка(Сценарий.Периодичность)), Строка(ПериодичностьДетализации)) + ")
	|КОНЕЦ");
	РезультатЗапросаПоСоставПлана = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "СоставПлана", СтруктураПолей, СтруктураСложныхПолей);
	
	// Подготовим таблицу СоставПлана для проведения.
	ТаблицаПоСоставПлана = ПодготовитьТаблицуСоставПлана(РезультатЗапросаПоСоставПлана, СтруктураШапкиДокумента);
	
	// Проверить заполнение ТЧ "СоставПлана".
	ПроверитьЗаполнениеТабличнойЧастиСоставПлана(ТаблицаПоСоставПлана, СтруктураШапкиДокумента, Отказ, Заголовок);
										
	// Движения по документу
	Если Не Отказ Тогда

		ДвиженияПоРегистрам(РежимПроведения, ТаблицаПоСоставПлана, Отказ, Заголовок);

	КонецЕсли; 

КонецПроцедуры	// ОбработкаПроведения

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");