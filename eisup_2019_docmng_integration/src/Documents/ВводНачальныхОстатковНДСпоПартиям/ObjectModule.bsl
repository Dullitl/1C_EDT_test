Перем мУдалятьДвижения;


Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет корректность заполнения реквизитов шапки документа
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтрРекв = "Организация";
					
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(СтрРекв), Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет корректность заполнения реквизитов таб. части документа
//
Процедура ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);

	ОбязательныеРеквизиты = "СчетУчета, Номенклатура";
	
	УчетнаяПолитикаБух = ttk_ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(Дата, Организация);
    Если Не ЗначениеЗаполнено(УчетнаяПолитикаБух) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//БУ = ПланыСчетов.Хозрасчетный.Товары.ПолучитьОбъект();
	//ВестиПартионныйУчетБУ = ?(БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии, "ВидСубконто") = Неопределено, Ложь, Истина);
	
	ВестиПартионныйУчетБУ = УчетнаяПолитикаБух.СпособОценкиМПЗ = Перечисления.СпособыОценки.ФИФО
						ИЛИ УчетнаяПолитикаБух.СпособОценкиМПЗ = Перечисления.СпособыОценки.ЛИФО;
	
	//проверка заполнения обязательных реквизитов
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоПартиям", Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);
	
	//Проверка таблицы дополнительных сведений
	ОбязательныеРеквизиты = "ВидЦенности, СтавкаНДС, СчетУчетаНДС";
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);

	ОбязательныеРеквизиты = "СчетФактура";
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", Новый Структура(ОбязательныеРеквизиты), Неопределено, Заголовок);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Количество,0)) КАК Количество,
	|	МАКСИМУМ(ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Количество) КАК КоличествоПоПартии,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.НомерСтроки,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия
	|ИЗ
	|	Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоПартиям КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоСФ КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ
	|		ПО ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.КлючСтроки = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.КлючСтроки
	|			И ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Ссылка
	|ГДЕ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.НомерСтроки,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия
	|
	|";
		
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Результат Цикл
		Если Строка.Количество <> Строка.КоличествоПоПартии Тогда
			СтрокаСообщенияОбОшибке = "В строке номер """+ СокрЛП(Строка.НомерСтроки) +
			                               """ табличной части ""Данные по партиям"": Количество по партии не соответствует количеству по счетам-фактурам";
			ttk_ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщенияОбОшибке, Отказ, Заголовок);
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(Строка.Партия) и ВестиПартионныйУчетБУ Тогда
			СтрокаСообщенияОбОшибке = "В строке номер """+ СокрЛП(Строка.НомерСтроки) +
			                               """ табличной части ""Данные по партиям"": Не заполнена партия, возможно расхождение данных с бухгалтерским учетом.";
			ttk_ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщенияОбОшибке, , Заголовок, СтатусСообщения.Информация);
		КонецЕсли; 
			

	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабЧасти()

Функция ПодготовитьТаблицуДвиженийДокумента(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ТаблицаДокумента = Новый ТаблицаЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Номенклатура,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.СчетУчета,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Склад,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.СчетФактура,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.ВидЦенности,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.НДСВключенВСтоимость,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Количество,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Стоимость,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.СчетУчетаНДС,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.СтавкаНДС,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.НДС,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.ХарактеристикаНоменклатуры,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.СерияНоменклатуры,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Заказ
	|ИЗ
	|	Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоСФ КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоПартиям КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям
	|		ПО ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.КлючСтроки = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.КлючСтроки
	|ГДЕ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = &Ссылка";
	
	ТаблицаДокумента = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицыДокумента Из ТаблицаДокумента Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыДокумента.Партия) Тогда
			СтрокаТаблицыДокумента.Партия = Неопределено;
		КонецЕсли;
		
		БУ = СтрокаТаблицыДокумента.СчетУчета.ПолучитьОбъект();
		ВестиСкладскойУчетБУ  = ?(БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады, "ВидСубконто") = Неопределено, Ложь, Истина);
		Если ВестиСкладскойУчетБУ Тогда
			ВестиСуммовойУчетПоСкладамБУ = БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады, "ВидСубконто").Суммовой;
		Иначе
			ВестиСуммовойУчетПоСкладамБУ = Ложь;
		КонецЕсли;
		
		Если Не ВестиСуммовойУчетПоСкладамБУ Тогда
			СтрокаТаблицыДокумента.Склад = Справочники.Склады.ПустаяСсылка();
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат ТаблицаДокумента;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА ПО РЕГИСТРАМ

// Процедура формирования движений по регистрам.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок)

	Если ТаблицаДокумента.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДвижений = Движения.НДСПартииТоваров.Выгрузить();
	ТаблицаДвижений.Очистить();
	ТаблицаДокумента.Колонки.Добавить("Организация");
	ТаблицаДокумента.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация, "Организация");
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаДокумента,ТаблицаДвижений);
	
	Если ТаблицаДвижений.Количество() > 0 Тогда
		Движения.НДСПартииТоваров.мПериод          = СтруктураШапкиДокумента.Дата;
		Движения.НДСПартииТоваров.мТаблицаДвижений = ТаблицаДвижений;

		Движения.НДСПартииТоваров.ВыполнитьПриход();
		Движения.НДСПартииТоваров.Записать();

	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Не Отказ Тогда
				
		ТаблицаДокумента = ПодготовитьТаблицуДвиженийДокумента(СтруктураШапкиДокумента, Отказ, Заголовок);
		мВестиУчетНДС = УчетНДС.ПроводитьПоРазделуУчетаНДС(Дата);
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ, Заголовок);
			
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

