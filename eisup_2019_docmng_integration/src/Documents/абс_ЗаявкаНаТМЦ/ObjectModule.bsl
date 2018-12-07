Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

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
		Предупреждение(Нстр("ru = 'Документ можно распечатать только после его записи'"));
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение(Нстр("ru = 'Недостаточно полномочий для печати непроведенного документа!'"));
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	

	// Получить экземпляр документа на печать
	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли;
	Иначе
		//Печать макетов ТОРГ13, М4, М11, Ведомость - из модуля менеджера объекта
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(Ссылка);
		
		Если НаПринтер Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Документ.абс_ЗаявкаНаТМЦ", ИмяМакета, 
										ПараметрКоманды, Неопределено);
		Иначе
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.абс_ЗаявкаНаТМЦ", ИмяМакета, 
										ПараметрКоманды, Неопределено, Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт

	СтруктураМакетов = Новый Структура();
	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

//АБС ВСТАВКА 45921  26.08.2014 10:22:34  Стрельцов
Процедура ЗаполнитьДокументНаОснованииПоступленияТоваровИУслуг(ДокОснование)
	
	//ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, ДокОснование);
	 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокПоступлениеТоваровУслуг.Ссылка КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА ДокПоступлениеТоваровУслуг.СкладОрдер ССЫЛКА Справочник.Склады
		|			ТОГДА ДокПоступлениеТоваровУслуг.СкладОрдер
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|	КОНЕЦ КАК СкладОтправитель,
		|	ДокПоступлениеТоваровУслуг.Контрагент,
		|	ДокПоступлениеТоваровУслуг.ДоговорКонтрагента,
		|	ДокПоступлениеТоваровУслуг.Ответственный,
		|	ДокПоступлениеТоваровУслуг.Организация
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ДокПоступлениеТоваровУслуг
		|ГДЕ
		|	ДокПоступлениеТоваровУслуг.Ссылка = &ДокОснование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ПоступлениеТоваровУслугТовары.НомерСтроки) КАК НомерСтроки,
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.ЕдиницаИзмерения,
		|	СУММА(ПоступлениеТоваровУслугТовары.Количество) КАК Количество,
		|	ПоступлениеТоваровУслугТовары.Коэффициент,
		|	ПоступлениеТоваровУслугТовары.абс_Проект КАК Проект,
		|	ПоступлениеТоваровУслугТовары.СерияНоменклатуры,
		|	ПоступлениеТоваровУслугТовары.ХарактеристикаНоменклатуры
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка = &ДокОснование
		|	И ПоступлениеТоваровУслугТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслугТовары.ЕдиницаИзмерения,
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Коэффициент,
		|	ПоступлениеТоваровУслугТовары.ХарактеристикаНоменклатуры,
		|	ПоступлениеТоваровУслугТовары.абс_Проект,
		|	ПоступлениеТоваровУслугТовары.СерияНоменклатуры
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	МИНИМУМ(ПоступлениеТоваровУслугОборудование.НомерСтроки),
		|	ПоступлениеТоваровУслугОборудование.Номенклатура,
		|	ПоступлениеТоваровУслугОборудование.ЕдиницаИзмерения,
		|	СУММА(ПоступлениеТоваровУслугОборудование.Количество),
		|	ПоступлениеТоваровУслугОборудование.Коэффициент,
		|	ПоступлениеТоваровУслугОборудование.абс_Проект,
		|	ПоступлениеТоваровУслугОборудование.СерияНоменклатуры,
		|	ПоступлениеТоваровУслугОборудование.ХарактеристикаНоменклатуры
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Оборудование КАК ПоступлениеТоваровУслугОборудование
		|ГДЕ
		|	ПоступлениеТоваровУслугОборудование.Ссылка = &ДокОснование
		|	И ПоступлениеТоваровУслугОборудование.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслугОборудование.Номенклатура,
		|	ПоступлениеТоваровУслугОборудование.ХарактеристикаНоменклатуры,
		|	ПоступлениеТоваровУслугОборудование.СерияНоменклатуры,
		|	ПоступлениеТоваровУслугОборудование.абс_Проект,
		|	ПоступлениеТоваровУслугОборудование.ЕдиницаИзмерения,
		|	ПоступлениеТоваровУслугОборудование.Коэффициент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";

	Запрос.УстановитьПараметр("ДокОснование", ДокОснование);

	Результат = Запрос.ВыполнитьПакет();

	ВыборкаШапка = Результат[0].Выбрать();
    ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	ВидОперации = Перечисления.абс_ВидыОперацийЗаявкаТМЦ.СписаниеНаРасходы;
	
	ВыборкаТМЦ = Результат[1].Выбрать();
	Товары.Очистить();
	Пока ВыборкаТМЦ.Следующий() Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаТМЦ);
	КонецЦикла;

	
КонецПроцедуры
//\\АБС ВСТАВКА 45921 КОНЕЦ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
	
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)
	
	Если ЭтоНовый() Тогда	
		Статус = Перечисления.абс_СтатусыЗаявокНаОбеспечениеТМЦ.Подготовка;	
	КонецЕсли;
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.НастройкиЗаполненияФорм") Тогда
		
		ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектПоНастройке(ЭтотОбъект, Основание, Документы.абс_ЗаявкаНаТМЦ.СтруктураДополнительныхДанныхФормы());
		
	//АБС ВСТАВКА 45921  26.08.2014 10:22:34  Стрельцов
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ЗаполнитьДокументНаОснованииПоступленияТоваровИУслуг(Основание);
	//\\АБС ВСТАВКА 45921 КОНЕЦ
		
	Иначе
		
	    ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

		Если НЕ ЗначениеЗаполнено(СкладОтправитель) Тогда
			СкладОтправитель = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойСклад");
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(СкладПолучатель) Тогда
			СкладПолучатель  = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойСклад");
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	Если НЕ РежимЗаписи = РежимЗаписиДокумента.Запись 
			и НЕ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Если 
			 Статус = Перечисления.абс_СтатусыЗаявокНаОбеспечениеТМЦ.Отказ Тогда 		
			Если Проведен Тогда			
				РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
			Иначе                			
				РежимЗаписи = РежимЗаписиДокумента.Запись;
			КонецЕсли;  		   		
		Иначе         		
			РежимЗаписи = РежимЗаписиДокумента.Проведение; 		
		КонецЕсли; 	
		
	КонецЕсли;
	             	
	СуммаДокументаРозничная = 0;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
		
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Не указан ответственный", Отказ);
	КонецЕсли;	
	
КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	
	СтатусПоРегистру = абс_БизнесПроцессы.ПолучитьСтатусЗаявкиНаОбеспечениеТМЦ(Ссылка);

	Если НЕ Статус = СтатусПоРегистру Тогда
		
		ЗаписатьНовыйСтатус(Статус, ПричинаИзмененияСтатуса);
				
	КонецЕсли;  	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	//Если мУдалятьДвижения Тогда
	//	ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, Истина, РежимПроведения);
	//КонецЕсли;

	Если Статус = Перечисления.абс_СтатусыЗаявокНаОбеспечениеТМЦ.Отказ Или 
		 Статус = Перечисления.абс_СтатусыЗаявокНаОбеспечениеТМЦ.Подготовка Тогда 
		Возврат;
	КонецЕсли;
		
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура"                , "Номенклатура");
	СтруктураПолей.Вставить("Количество"                  , "Количество");
	СтруктураПолей.Вставить("СерияНоменклатуры"           , "СерияНоменклатуры");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры"  , "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("Проект"                      , "Проект");
	СтруктураПолей.Вставить("КлючСтроки"                  , "КлючСтроки");
	СтруктураПолей.Вставить("Комплект"                    , "Номенклатура.Комплект");
	
	РезультатЗапросаПоТоварам = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);
	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураШапкиДокумента.Вставить("Склад", СкладПолучатель);
	
	Для каждого СтрТЗ Из ТаблицаТоваров Цикл
	    НайденыеСтроки = РаспределениеНоменклатурыПоПроектам.НайтиСтроки(Новый Структура("КлючСтроки", СтрТЗ.КлючСтроки));
				
		Если НайденыеСтроки.Количество()>0 Тогда
			Для каждого СтрМас Из НайденыеСтроки Цикл
			
				Движение 				= Движения.абс_ЗаявкиНаОбеспечение.Добавить();
				Движение.Активность 	= Истина;
				Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
				
				Движение.Номенклатура 		= СтрМас.Номенклатура;
				Движение.Склад 				= СтруктураШапкиДокумента.Склад;
				Движение.СерияНоменклатуры 	= СтрТЗ.СерияНоменклатуры;
				Движение.ХарактеристикаНоменклатуры 	= СтрТЗ.ХарактеристикаНоменклатуры;
				Движение.Заказ 				= СтруктураШапкиДокумента.Ссылка;
				Движение.Организация 		= СтруктураШапкиДокумента.Организация;
				Движение.Проект 			= СтрМас.Проект;		
				Движение.Период 			= СтруктураШапкиДокумента.Дата;		
				Движение.Количество  		= СтрМас.Количество;
				Движение.СписаниеПартий 	= Ложь;		
			
			КонецЦикла;
		Иначе	
			Движение 				= Движения.абс_ЗаявкиНаОбеспечение.Добавить();
			Движение.Активность 	= Истина;
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			
			Движение.Номенклатура 		= СтрТЗ.Номенклатура;
			Движение.Склад 				= СтруктураШапкиДокумента.Склад;
			Движение.СерияНоменклатуры 	= СтрТЗ.СерияНоменклатуры;
			Движение.Заказ 				= СтруктураШапкиДокумента.Ссылка;
			Движение.Организация 		= СтруктураШапкиДокумента.Организация;
			Движение.ХарактеристикаНоменклатуры 	= СтрТЗ.ХарактеристикаНоменклатуры;
			Движение.Проект 			= СтрТЗ.Проект;		
			Движение.Период 			= СтруктураШапкиДокумента.Дата;		
			Движение.Количество  		= СтрТЗ.Количество;
			Движение.СписаниеПартий 	= Ложь;		
		КонецЕсли;
	
	КонецЦикла;
		
	//Сделаем переменные доступными из подписок на события
	ДополнительныеСвойства.Вставить("СтруктураШапкиДокумента", СтруктураШапкиДокумента);
	ДополнительныеСвойства.Вставить("СтруктураТабличныхЧастей", Новый Структура("ТаблицаПоТоварам", ТаблицаТоваров));
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПриКопировании(ОбъектКопирования)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект,,ОбъектКопирования.Ссылка);
КонецПроцедуры

Процедура ЗаписатьНовыйСтатус(НовыйСтатус, Комментарий = Неопределено) Экспорт
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	
	НаборЗаписей = РегистрыСведений.абс_ИзменениеСтатусовЗаявокНаОбеспечениеТМЦ.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Заявка.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = абс_СерверныеФункции.ПолучитьДатуСервера();

	Запись.Заявка					= Ссылка;
	Запись.Пользователь 			= ТекПользователь;	
	Запись.СтатусДокумента			= НовыйСтатус;
	
	Запись.Комментарий 				= Комментарий;
	
	ОтветственныйСотрудник = абс_БизнесПроцессы.ПолучитьСотрудникаПользователя(ТекПользователь);
	
	Если НЕ ОтветственныйСотрудник = Неопределено Тогда
		Запись.ДолжностьОтветственного	= ОтветственныйСотрудник.Должность;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьРежимЗаписиДокумента() Экспорт
	
	РежимЗаписи = Неопределено;                       	
	Если Статус = Перечисления.абс_СтатусыЗаявокНаОбеспечениеТМЦ.Отказ Тогда			
		Если Проведен Тогда                                                          			
			РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;                     
		Иначе			
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли;		
	Иначе         		
		РежимЗаписи = РежимЗаписиДокумента.Проведение;		
	КонецЕсли;
	
	Возврат РежимЗаписи;
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//абс Урал 20.12.2013
	Если ВидОперации <> Перечисления.абс_ВидыОперацийЗаявкаТМЦ.ПередачаПодрядчику Тогда
		Индекс = ПроверяемыеРеквизиты.Найти("Контрагент");
		Если Индекс <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(Индекс);
		КонецЕсли;
	//АБС ВСТАВКА 45921  26.08.2014 12:28:58  Стрельцов
	Иначе
	    Индекс = ПроверяемыеРеквизиты.Найти("СкладПолучатель");
		Если Индекс <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(Индекс);
		КонецЕсли;
	//\\АБС ВСТАВКА 45921 КОНЕЦ
    		
	КонецЕсли;
	//\\
	
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");