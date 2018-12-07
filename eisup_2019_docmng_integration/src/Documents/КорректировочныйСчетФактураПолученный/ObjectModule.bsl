Перем мВалютаРегламентированногоУчета Экспорт;
Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Функция ПолучитьРеквизитыПродавца(Контрагент, Дата) Экспорт
	
	РеквизитыПродавца = Новый Структура;
	СведенияОПродавце = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Контрагент, Дата);
	
	РеквизитыПродавца.Вставить("НаименованиеПродавца", СведенияОПродавце.ПолноеНаименование);
	РеквизитыПродавца.Вставить("ИННПродавца",          СведенияОПродавце.ИНН);
	РеквизитыПродавца.Вставить("КПППродавца",          СведенияОПродавце.КПП);
	
	Возврат РеквизитыПродавца;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОДГОТОВКИ ПЕЧАТНОЙ ФОРМЫ ДОКУМЕНТА

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА

Функция ПодготовитьТаблицыДокумента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаВосстановлениеНДС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВосстановлениеНДС.Ссылка.Дата КАК Период,
	|	ТаблицаВосстановлениеНДС.Ссылка.Организация КАК Организация,
	|	ТаблицаВосстановлениеНДС.Ссылка.Контрагент КАК Покупатель,
	|	НЕОПРЕДЕЛЕНО КАК ДоговорКонтрагента,
	|	ТаблицаВосстановлениеНДС.Ссылка КАК СчетФактура,
	|	ТаблицаВосстановлениеНДС.ВидЦенности КАК ВидЦенности,
	|	ТаблицаВосстановлениеНДС.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВосстановлениеНДС.Сумма КАК СуммаСНДС,
	|	ТаблицаВосстановлениеНДС.Сумма - ТаблицаВосстановлениеНДС.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаВосстановлениеНДС.СуммаНДС КАК НДС,
	|	ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПродажи.ВосстановлениеНДС) КАК Событие,
	|	ТаблицаВосстановлениеНДС.Ссылка.Дата КАК ДатаСобытия,
	|	ЛОЖЬ КАК ЗаписьДополнительногоЛиста,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК КорректируемыйПериод,
	|	ЛОЖЬ КАК СторнирующаяЗаписьДопЛиста
	|ИЗ
	|	Документ.КорректировочныйСчетФактураПолученный.ВосстановлениеНДС КАК ТаблицаВосстановлениеНДС
	|ГДЕ
	|	ТаблицаВосстановлениеНДС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВычетНДС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВычетНДС.Ссылка.Дата КАК Период,
	|	ТаблицаВычетНДС.Ссылка.Организация,
	|	ТаблицаВычетНДС.Ссылка.Контрагент КАК Поставщик,
	|	НЕОПРЕДЕЛЕНО КАК ДоговорКонтрагента,
	|	ТаблицаВычетНДС.Ссылка КАК СчетФактура,
	|	ТаблицаВычетНДС.ВидЦенности КАК ВидЦенности,
	|	ТаблицаВычетНДС.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВычетНДС.СчетУчетаНДС КАК СчетУчетаНДС,
	|	ТаблицаВычетНДС.Сумма КАК СуммаСНДС,
	|	ТаблицаВычетНДС.Сумма - ТаблицаВычетНДС.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаВычетНДС.СуммаНДС КАК НДС,
	|	ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПокупки.ПредъявленНДСКВычету) КАК Событие,
	|	ТаблицаВычетНДС.Ссылка.Дата КАК ДатаСобытия,
	|	ЛОЖЬ КАК ЗаписьДополнительногоЛиста,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК КорректируемыйПериод
	|ИЗ
	|	Документ.КорректировочныйСчетФактураПолученный.ВычетНДС КАК ТаблицаВычетНДС
	|ГДЕ
	|	ТаблицаВычетНДС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицыДокумента = Новый Структура;
	ТаблицыДокумента.Вставить("Восстановление", Результат[0].Выгрузить());
	ТаблицыДокумента.Вставить("Вычет",          Результат[1].Выгрузить());
	
	Возврат ТаблицыДокумента;	
	
КонецФункции

Процедура ПроверитьЗаполнениеДокумента(СтруктураШапкиДокумента, ТаблицаВосстановление, ТаблицаВычет, Отказ, Заголовок)
	
	Если СтруктураШапкиДокумента.РазницаСНДСКУменьшению < ТаблицаВосстановление.Итог("СуммаСНДС") Тогда
		ТекстСообщения = НСтр("ru='Разница к уменьшению по счету-фактуре меньше восстанавливаемой суммы.'");
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
	КонецЕсли;
	Если СтруктураШапкиДокумента.РазницаНДСКУменьшению < ТаблицаВосстановление.Итог("НДС") Тогда
		ТекстСообщения = НСтр("ru='НДС к уменьшению по счету-фактуре меньше восстанавливаемой суммы НДС.'");
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
	КонецЕсли;
	Если СтруктураШапкиДокумента.РазницаСНДСКДоплате < ТаблицаВычет.Итог("СуммаСНДС") Тогда
		ТекстСообщения = НСтр("ru='Разница к доплате по счету-фактуре меньше принимаемой к вычету суммы.'");
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
	КонецЕсли;
	Если СтруктураШапкиДокумента.РазницаНДСКДоплате < ТаблицаВычет.Итог("НДС") Тогда
		ТекстСообщения = НСтр("ru='НДС к доплате по счету-фактуре меньше принимаемой к вычету суммы НДС.'");
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры

// Формирование записей книги продаж - восстановление НДС - при уменьшении стоимости (разницы к уменьшению)
//
Процедура СформироватьДвиженияУменьшениеСтоимостиПоступления(СтруктураШапкиДокумента, ТаблицаВосстановление, Отказ, Заголовок) 
	
	Если ТаблицаВосстановление.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаВосстановление Цикл
		
		Движение = Движения.НДСЗаписиКнигиПродаж.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТаблицы);
		
	КонецЦикла;
		
КонецПроцедуры	

// Формирование записей книги покупок - вычет НДС - при увеличении стоимости (разницы к доплате)
//
Процедура СформироватьДвиженияУвеличениеСтоимостиПоступления(СтруктураШапкиДокумента, ТаблицаВычет, Отказ, Заголовок) 
	           	
	Если ТаблицаВычет.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаВычет Цикл
		
		Движение = Движения.НДСЗаписиКнигиПокупок.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТаблицы);
		
	КонецЦикла;
		
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(
		ЭтотОбъект, "Покупка");
		
	//абс вставка Начало
	
	Попытка
		
		Если  ТипЗнч(ДанныеЗаполнения) = ТипЗнч(Документы.ПоступлениеТоваровУслуг.ПустаяСсылка()) ТОгда 
			
			Контрагент 			= ДанныеЗаполнения.Контрагент;
			ДоговорКонтрагента 	= ДанныеЗаполнения.ДоговорКонтрагента;
			Организация			= ДанныеЗаполнения.Организация;
			
			Абс_Основание = ДанныеЗаполнения;
			НовСтрокаДокументыОснования = ДокументыОснования.Добавить();
			НовСтрокаДокументыОснования.Абс_Основание = ДанныеЗаполнения;
			абс_ДокументыКорректировки.Очистить();
			НовСТрокаПоступленияПоследнее = абс_ДокументыКорректировки.Добавить();
			НовСТрокаПоступленияПоследнее.Документ = ДанныеЗаполнения;
			
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	//абс вставка Конец
		
КонецПроцедуры 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
    	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	ТаблицыДокумента = ПодготовитьТаблицыДокумента();
	
	ПроверитьЗаполнениеДокумента(
		СтруктураШапкиДокумента, ТаблицыДокумента.Восстановление, ТаблицыДокумента.Вычет, Отказ, Заголовок);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьДвиженияУменьшениеСтоимостиПоступления(
		СтруктураШапкиДокумента, ТаблицыДокумента.Восстановление, Отказ, Заголовок);
	
	СформироватьДвиженияУвеличениеСтоимостиПоступления(
		СтруктураШапкиДокумента, ТаблицыДокумента.Вычет, Отказ, Заголовок);	
		
		
	//абс вставка начало	
	Если отказ = Ложь ТОгда
		Движения.Хозрасчетный.Очистить();

		абс_СформироватьДВиженияУменьшенияСтоимостиПоступленияБУ(Отказ);
		абс_СформироватьДВиженияУвеличениеСтоимостиПоступленияБУ(Отказ);
		
		абс_СформироватьДВиженияНДСПредьявленыйКорректировки(Отказ);
		абс_СформироватьДВиженияНДСПредьявленыйПоступления(Отказ);
		
		
		
		
	КонецЕсли;
	
	
	
	//абс вставка конец		
КонецПроцедуры


//абс вставка начало
Процедура абс_СформироватьДВиженияУменьшенияСтоимостиПоступленияБУ(Отказ)
	
	ТекДВиженияХозрасчетный = Движения.Хозрасчетный;
	Для Каждого СТрокаТЧ из ВосстановлениеНДС Цикл
		
		НовПроводка = ТекДВиженияХозрасчетный.Добавить();	
		НовПроводка.Организация = Организация;
		НовПроводка.Период = Дата;
		
		НовПроводка.СчетДт = абс_СчетУчетаНДС;
		
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетДт, НовПроводка.СубконтоДт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетДт, НовПроводка.СубконтоДт, "СФПолученные",Абс_Основание);//СчетФактура
		
		НовПроводка.СчетКт = ПланыСчетов.Хозрасчетный.НДС;
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетКт, НовПроводка.СубконтоКт, "ВидыПлатежейВГосБюджет", Перечисления.ВидыПлатежейВГосБюджет.Налог);
		
        НовПроводка.Сумма  = СТрокаТЧ.СуммаНДС; 
		НовПроводка.Содержание = "Восстановление НДС по корректировочной СФ полученной";
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура абс_СформироватьДВиженияУвеличениеСтоимостиПоступленияБУ(Отказ)
	
	
	
	ТекДВиженияХозрасчетный = Движения.Хозрасчетный;
	Для Каждого СТрокаТЧ из ВычетНДС Цикл
		
		НовПроводка = ТекДВиженияХозрасчетный.Добавить();	
		НовПроводка.Организация = Организация;
		НовПроводка.Период = Дата;
		
		НовПроводка.СчетДт = ПланыСчетов.Хозрасчетный.НДС;
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетДт, НовПроводка.СубконтоДт, "ВидыПлатежейВГосБюджет", Перечисления.ВидыПлатежейВГосБюджет.Налог);
		
		НовПроводка.СчетКт =  СТрокаТЧ.СчетУчетаНДС;
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетКт, НовПроводка.СубконтоКт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(НовПроводка.СчетКт, НовПроводка.СубконтоКт, "СФПолученные", Абс_Основание);//СчетФактура
				
        НовПроводка.Сумма  = СТрокаТЧ.СуммаНДС; 
		НовПроводка.Содержание = "Вычет НДС по корректировочной СФ полученной";
		
	КонецЦикла;
	
	
КонецПроцедуры
Процедура абс_СформироватьДВиженияНДСПредьявленыйКорректировки(Отказ)
	
	СЗКорректировок = новый СписокЗначений;
	
	
	ДЛя Каждого СТрокаТЧ из абс_ДокументыКорректировки Цикл
		
		Если  Не ЗначениеЗаполнено(СТрокаТЧ.Документ) ТОгда
			Продолжить;
		КонецЕсли;
		//АБС Коломиец+
		//
		//Если СТрокаТЧ.Документ.Метаданные().Имя <>  "КорректировкаЗаписейРегистров" ТОгда
		//	Продолжить;		
		//КонецЕсли;
		//
		//Если СЗКорректировок.НайтиПоЗначению(СТрокаТЧ.Документ) <>Неопределено ТОгда
		//	Продолжить;
		//КонецЕсли;
		//
		//РегНабор = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		//РегНабор.Отбор.Регистратор.Установить(СТрокаТЧ.Документ);
		//РегНабор.Прочитать();
		//СЗКорректировок.Добавить(СТрокаТЧ.Документ);
		//Для Каждого СтрокаНабора из РегНабор Цикл
		//	
		//	НовДВижение = Движения.НДСПредъявленный.Добавить();	
		//	ЗаполнитьЗначенияСвойств(НовДВижение,СтрокаНабора);
		//	НовДВижение.СуммаБезНДС = - НовДВижение.СуммаБезНДС;
		//	НовДВижение.НДС = - НовДВижение.НДС;
		//	НовДВижение.Период = Дата;
		//	
		//КонецЦикла;
		
		
		Если СТрокаТЧ.Документ.Метаданные().Имя <>  "КорректировкаЗаписейРегистров" ТОгда
			Продолжить;		
		КонецЕсли;
		
		Если СЗКорректировок.НайтиПоЗначению(СТрокаТЧ.Документ) <>Неопределено ТОгда
			Продолжить;
		КонецЕсли;
		
		РегНабор = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		РегНабор.Отбор.Регистратор.Установить(СТрокаТЧ.Документ);
		РегНабор.Прочитать();
				
		СЗКорректировок.Добавить(СТрокаТЧ.Документ);
		Для Каждого СтрокаНабора из РегНабор Цикл
			
			Если абс_ДокументыКорректировки.Найти(СтрокаНабора.СчетФактура, "Документ") = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НовДВижение = Движения.НДСПредъявленный.Добавить();	
			ЗаполнитьЗначенияСвойств(НовДВижение,СтрокаНабора);
			НовДВижение.СуммаБезНДС = - НовДВижение.СуммаБезНДС;
			НовДВижение.НДС = - НовДВижение.НДС;
		    НовДВижение.Период = Дата;
			
		КонецЦикла;
		//АБС Коломиец-

		
		
	КонецЦикла;
	
КонецПроцедуры
Процедура абс_СформироватьДВиженияНДСПредьявленыйПоступления(Отказ)
	
	
	ДЛя Каждого СТрокаТЧ из ДокументыОснования Цикл
		
		Если  Не ЗначениеЗаполнено(СТрокаТЧ.Абс_Основание) ТОгда
			Продолжить;
		КонецЕсли;
		
				
		РегНабор = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		РегНабор.Отбор.Регистратор.Установить(СТрокаТЧ.Абс_Основание);
		РегНабор.Прочитать();
		
		Для Каждого СтрокаНабора из РегНабор Цикл
			
			НовДВижение = Движения.НДСПредъявленный.Добавить();	
			ЗаполнитьЗначенияСвойств(НовДВижение,СтрокаНабора);
			НовДВижение.СуммаБезНДС = - НовДВижение.СуммаБезНДС;
			НовДВижение.НДС = - НовДВижение.НДС;
		    НовДВижение.Период = Дата;
			
		КонецЦикла;
		
		
		
	КонецЦикла;
	
	
КонецПроцедуры

//абс вставка конец



Процедура ОбработкаУдаленияПроведения(Отказ)
		
	ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка, Ложь);

КонецПроцедуры
//абс вставка начало
Процедура ЗаполнитьДокумент() Экспорт
	
	ВосстановлениеНДС.Очистить();
	ВычетНДС.Очистить();
	
		
	СЗДокументов = новый СписокЗначений;
	
	
	
	
	Структура = новый Структура;
	Структура.Вставить("СуммаСНДС",0);
	Структура.Вставить("СуммаНДС",0);
	
	
	Запрос  = новый запрос;
	Запрос.УстановитьПараметр("СЗДокументов",СЗДокументов);
	
	
	ЗАпрос.Текст = "ВЫБРАТЬ
	               |	СУММА(НДСПредъявленныйОбороты.СуммаБезНДСПриход - НДСПредъявленныйОбороты.СуммаБезНДСРасход + (НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход)) КАК СуммаСНДС,
	               |	СУММА(НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход) КАК СуммаНДС,
	               |	НДСПредъявленныйОбороты.ВидЦенности,
	               |	НДСПредъявленныйОбороты.СчетУчетаНДС
	               |ИЗ
	               |	РегистрНакопления.НДСПредъявленный.Обороты(, , Регистратор, ) КАК НДСПредъявленныйОбороты
	               |ГДЕ
	               |	НДСПредъявленныйОбороты.Регистратор В(&СЗДокументов)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НДСПредъявленныйОбороты.ВидЦенности,
	               |	НДСПредъявленныйОбороты.СчетУчетаНДС";
				   
	ТЗВыборка = ЗАпрос.Выполнить().Выгрузить();
	
	
	
	Если ТЗВыборка.Количество() = 0 ТОгда
		
		
		
		
	КонецЕсли;
	

	
	
КонецПроцедуры
Функция Абс_ПолучитьСТруктуруНДСПредъявленный(ТекДокумент)  Экспорт
	
	
	СЗДокументов = новый СписокЗначений;
	
	Если ТипЗнч(ТекДокумент) <> ТипЗнч(Новый СписокЗначений) ТОгда
		СЗДокументов.Добавить(ТекДокумент);	
	Иначе
		СЗДокументов = ТекДокумент;	
	КонецЕсли;
	
	Структура = новый Структура;
	Структура.Вставить("СуммаСНДС",0);
	Структура.Вставить("СуммаНДС",0);
	
	
	Запрос  = новый запрос;
	Запрос.УстановитьПараметр("ТекДокумент",ТекДокумент);
	
	
	ЗАпрос.Текст = "ВЫБРАТЬ
	               |	СУММА(НДСПредъявленныйОбороты.СуммаБезНДСПриход - НДСПредъявленныйОбороты.СуммаБезНДСРасход + (НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход)) КАК СуммаСНДС,
	               |	СУММА(НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход) КАК СуммаНДС
	               |ИЗ
	               |	РегистрНакопления.НДСПредъявленный.Обороты(, , Регистратор, ) КАК НДСПредъявленныйОбороты
	               |ГДЕ
	               |	НДСПредъявленныйОбороты.Регистратор В (&ТекДокумент) ";
	               
				   
	ТЗВыборка = ЗАпрос.Выполнить().Выгрузить();
	Если ТЗВыборка.Количество() = 0 ТОгда
		Возврат Структура;
	Иначе
		Структура.Вставить("СуммаСНДС",ТЗВыборка[0].СуммаСНДС);
		Структура.Вставить("СуммаНДС",ТЗВыборка[0].СуммаНДС);
		Возврат Структура;
	КонецЕсли;
	
				   
КонецФункции
Функция Абс_ПолучитьТЗНДСПредъявленныйПлюсВидЦенности(ТекДокумент,Знак)  Экспорт
	
	
	СЗДокументов = новый СписокЗначений;
	
	Если ТипЗнч(ТекДокумент) <> ТипЗнч(Новый СписокЗначений) ТОгда
		СЗДокументов.Добавить(ТекДокумент);	
	Иначе
		СЗДокументов = ТекДокумент;	
	КонецЕсли;
	
	
	ТЗНДС = новый ТаблицаЗначений;
	ТЗНДС.Колонки.Добавить("СуммаСНДС");
	ТЗНДС.Колонки.Добавить("СуммаНДС");
	ТЗНДС.Колонки.Добавить("ВидЦенности");
	ТЗНДС.Колонки.Добавить("СчетУчетаНДС");
	ТЗНДС.Колонки.Добавить("СтавкаНДС");
	
	
	
	
	
	
	
	Запрос  = новый запрос;
	Запрос.УстановитьПараметр("ТекДокумент",ТекДокумент);
	
	
	ЗАпрос.Текст = "ВЫБРАТЬ
	               |	СУММА(НДСПредъявленныйОбороты.СуммаБезНДСПриход - НДСПредъявленныйОбороты.СуммаБезНДСРасход + (НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход)) КАК СуммаСНДС,
	               |	СУММА(НДСПредъявленныйОбороты.НДСПриход - НДСПредъявленныйОбороты.НДСРасход) КАК СуммаНДС,
	               |	НДСПредъявленныйОбороты.ВидЦенности,
	               |	НДСПредъявленныйОбороты.СчетУчетаНДС,
	               |	НДСПредъявленныйОбороты.СтавкаНДС
	               |ИЗ
	               |	РегистрНакопления.НДСПредъявленный.Обороты(, , Регистратор, ) КАК НДСПредъявленныйОбороты
	               |ГДЕ
	               |	НДСПредъявленныйОбороты.Регистратор В(&ТекДокумент)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НДСПредъявленныйОбороты.ВидЦенности,
	               |	НДСПредъявленныйОбороты.СчетУчетаНДС,
	               |	НДСПредъявленныйОбороты.СтавкаНДС";
	               
				   
	Выборка = ЗАпрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовСТрока = ТЗНДС.Добавить();	
		НовСТрока.СуммаСНДС = Знак*Выборка.СуммаСНДС;
		НовСТрока.СуммаНДС = Знак*Выборка.СуммаНДС;
		НовСТрока.ВидЦенности = Выборка.ВидЦенности;
		НовСТрока.СчетУчетаНДС = Выборка.СчетУчетаНДС;
		НовСТрока.СтавкаНДС = Выборка.СтавкаНДС;
		
		
		
	КонецЦикла;
	
		
	Возврат ТЗНДС;	
				   
КонецФункции
Процедура абс_ЗаполнитТЧВычетИлиВосстановлениеНДС() Экспорт
	СЗДокументов = новый СписокЗначений;
	
	Для Каждого СТрокаТЧ из абс_ДокументыКорректировки Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Документ)  ТОгда
			Продолжить;
		КонецЕсли;
		
		Если  ТипЗнч(СтрокаТЧ.Документ) = ТипЗнч(Документы.КорректировкаЗаписейРегистров.ПустаяСсылка()) ТОгда
			Продолжить;
		КонецЕсли;
		
		СЗДокументов.Добавить(СТрокаТЧ.Документ);
		
	КонецЦикла;
	
	ТЗНДССтарых = Абс_ПолучитьТЗНДСПредъявленныйПлюсВидЦенности(СЗДокументов,1);
	
	СЗДокументов.Очистить();
	Для Каждого СтрокаОснование Из ДокументыОснования Цикл
	СЗДокументов.Добавить(СтрокаОснование.Абс_Основание);
	
	ТЗНДС=Абс_ПолучитьТЗНДСПредъявленныйПлюсВидЦенности(СЗДокументов,-1);
	
	ТЗОбщая = ТЗНДС.Скопировать();
	
	КонецЦикла;
	
	Для Каждого СТрокаТз из  ТЗНДССтарых Цикл
		НовСТрока = ТЗОбщая.добавить();			
		ЗаполнитьЗначенияСвойств(НовСТрока,СТрокаТЗ);
	КонецЦикла;
	
	
	
	
	Если  ТЗОбщая.Итог("СуммаСНДС") <0 ТОгда
		
		Для Каждого СТрокаТЧ из ТЗОбщая Цикл
			НовСТрока 				= ВычетНДС.Добавить();	
			НовСТрока.ВидЦенности 	= СТрокаТЧ.ВидЦенности;
			НовСТрока.СтавкаНДС 	= СТрокаТЧ.СтавкаНДС;
			НовСТрока.Сумма 		= -СТрокаТЧ.СуммаСНДС;
			НовСТрока.СуммаНДС 		= -СТрокаТЧ.СуммаНДС;
			НовСТрока.СчетУчетаНДС 	= СТрокаТЧ.СчетУчетаНДС;
		КонецЦикла;
		ВычетНДС.Свернуть("ВидЦенности,СтавкаНДС,СчетУчетаНДС","Сумма,СуммаНДС");
		
	Иначе
		 Для Каждого СТрокаТЧ из ТЗОбщая Цикл
			НовСТрока 				= ВосстановлениеНДС.Добавить();	
			НовСТрока.ВидЦенности 	= СТрокаТЧ.ВидЦенности;
			НовСТрока.СтавкаНДС 	= СТрокаТЧ.СтавкаНДС;
			НовСТрока.Сумма 		= СТрокаТЧ.СуммаСНДС;
			НовСТрока.СуммаНДС 		= СТрокаТЧ.СуммаНДС;
			
		КонецЦикла;
		ВосстановлениеНДС.Свернуть("ВидЦенности,СтавкаНДС","Сумма,СуммаНДС");

		
		
	КонецЕсли;
	
КонецПРоцедуры

Процедура Абс_РасчитатьДокумент()Экспорт
	
	
	СЗДокументов = новый СписокЗначений;
	
	Для Каждого СТрокаТЧ из абс_ДокументыКорректировки Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Документ)  ТОгда
			Продолжить;
		КонецЕсли;
		
		Если  ТипЗнч(СтрокаТЧ.Документ) = ТипЗнч(Документы.КорректировкаЗаписейРегистров.ПустаяСсылка()) ТОгда
			Продолжить;
		КонецЕсли;
		
		СЗДокументов.Добавить(СТрокаТЧ.Документ);
		
	КонецЦикла;
	
	ТекСТруктураСтарыхПоступлений=Абс_ПолучитьСТруктуруНДСПредъявленный(СЗДокументов);
	
	СЗДокументов.Очистить();
	Для Каждого СтрокаОснование Из ДокументыОснования Цикл
	СЗДокументов.Добавить(СтрокаОснование.Абс_Основание);
	
	ТекСТруктураНовогоПоступления=Абс_ПолучитьСТруктуруНДСПредъявленный(СЗДокументов);
	
	Если  ТекСТруктураСтарыхПоступлений.СуммаСНДС>ТекСТруктураНовогоПоступления.СуммаСНДС ТОгда
		
		РазницаСНДСКУменьшению = -ТекСТруктураНовогоПоступления.СуммаСНДС+ТекСТруктураСтарыхПоступлений.СуммаСНДС;
		РазницаНДСКУменьшению 	= -ТекСТруктураНовогоПоступления.СуммаНДС+ТекСТруктураСтарыхПоступлений.СуммаНДС;
		
	Иначе
		
	РазницаСНДСКДоплате = ТекСТруктураНовогоПоступления.СуммаСНДС - ТекСТруктураСтарыхПоступлений.СуммаСНДС;
	РазницаНДСКДоплате = ТекСТруктураНовогоПоступления.СуммаНДС-ТекСТруктураСтарыхПоступлений.СуммаНДС;
		
		
	КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры



//абс вставка Конец

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
