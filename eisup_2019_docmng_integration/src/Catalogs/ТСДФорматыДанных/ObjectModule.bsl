///////////////////////////////////////////////////////////////////////////////
//// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мПолеШтрихкод;
Перем мПолеНаименованиеНоменклатуры;
Перем мПолеАртикулНоменклатуры;
Перем мПолеХарактеристикаНоменклатуры;
Перем мПолеСерияНоменклатуры;
Перем мПолеЕдиницаИзмерения;
Перем мПолеКодНоменклатуры;
Перем мПолеЦенаНоменклатуры;
Перем мПолеКоличествоНоменклатуры;
Перем мПолеКачество;

///////////////////////////////////////////////////////////////////////////////
//// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ

// Функция осуществляет формирование соответствия, содержащего поля, которые
// учтены в данном формате данных.
//
// Параметры:
//  Штрихкод                       - <Строка>
//                                 - Штрихкод товара.
//
//  Номенклатура                   - <СправочникСсылка.Номенклатура>
//                                 - Номенклатура.
//
//  ЕдиницаИзмерения               - <СправочникСсылка.ЕдиницыИзмерения>
//                                 - Единица измерения номенклатуры.
//
//  ХарактеристикаНоменклатуры     - <СправочникСсылка.ХарактеристикиНоменклатуры>
//                                 - Характеристика номенклатуры.
//
//  СерияНоменклатуры              - <СправочникСсылка.СерииНоменклатуры>
//                                 - Серия номенклатуры.
//
//  Качество                       - <СправочникСсылка.Качество>
//                                 - Качество.
//
//  Цена                           - <Число>
//                                 - Цена номенклатуры.
//
//  Количество                     - <Число>
//                                 - Количество номенклатуры.
//
// Возвращаемое значение:
//  <Соответствие>                 - Соответствие полей.
//
Функция ПолучитьСоответствиеПолейТСД(Штрихкод, Номенклатура, ЕдиницаИзмерения,
                                     ХарактеристикаНоменклатуры, СерияНоменклатуры,
                                     Качество, Цена, Количество) Экспорт

	Результат       = Новый Соответствие();
	Поле            = Неопределено;
	Наименование    = СокрЛП(Номенклатура);
	Артикул         = "";
	Характеристика  = СокрЛП(ХарактеристикаНоменклатуры);
	Серия           = СокрЛП(СерияНоменклатуры);
	ЕдИзм           = СокрЛП(ЕдиницаИзмерения);
	КодНоменклатуры = "";
	ЦенаСтр         = Формат(Цена, "ЧЦ=15; ЧДЦ=2; ЧН=0; ЧГ=0");
	КолвоСтр        = Формат(Количество, "ЧЦ=15; ЧДЦ=2; ЧН=0; ЧГ=0");
	КачествоСтр     = СокрЛП(Качество);

	Для Каждого Поле Из СвязываемыеПоля Цикл
		ИмяПоля      = "Поле" + Формат(Поле.ПолеТСД, "ЧДЦ=0; ЧН=0; ЧГ=0");
		

		Если      Поле.ПараметрНоменклатуры = мПолеШтрихкод Тогда
			Результат[ИмяПоля] = Штрихкод;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеНаименованиеНоменклатуры Тогда
			Результат[ИмяПоля] = Наименование;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеАртикулНоменклатуры Тогда
			Результат[ИмяПоля] = Артикул;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеХарактеристикаНоменклатуры Тогда
			Результат[ИмяПоля] = Характеристика;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеСерияНоменклатуры Тогда
			Результат[ИмяПоля] = Серия;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеЕдиницаИзмерения Тогда
			Результат[ИмяПоля] = ЕдИзм;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеКодНоменклатуры Тогда
			Результат[ИмяПоля] = КодНоменклатуры;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеЦенаНоменклатуры Тогда
			Результат[ИмяПоля] = ЦенаСтр;
		ИначеЕсли Поле.ПараметрНоменклатуры = мПолеКоличествоНоменклатуры Тогда
			Результат[ИмяПоля] = КолвоСтр;
		Иначе // Если Поле.ПараметрНоменклатуры = мПолеКачество
			Результат[ИмяПоля] = КачествоСтр;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции // ПолучитьСоответствиеПолейТСД()

// Процедура возвращает параметры номенклатуры из соответствия полей ТСД.
//
// Параметры:
//  СоответствиеПолей - <Соответствие>
//                    - Соответствие, содержащее значения полей таблицы ТСД.
//                      Значению поля X ТСД соответствует ключ "ПолеX".
//
//  Штрихкод          - <Строка>
//                    - Выходной параметр; штрихкод товара.
//
//  Количество        - <Число>
//                    - Выходной параметр; количество товара.
//
Процедура ПолучитьСодержимоеСоответствияПолейТСД(СоответствиеПолей, Штрихкод,
                                               Количество) Экспорт

	ПолеШтрихкод   = СвязываемыеПоля.Найти(Перечисления.ТСДПоляДанных.ШтрихКод,
	                                         "ПараметрНоменклатуры");
	ПолеКоличество = СвязываемыеПоля.Найти(Перечисления.ТСДПоляДанных.КоличествоНаСкладе,
	                                         "ПараметрНоменклатуры");
	СтрокаШтрихкод   = ?(ПолеШтрихкод = Неопределено,
	                     "",
	                     "Поле" + Формат(ПолеШтрихкод.ПолеТСД, "ЧГ=0"));
	СтрокаКоличество = ?(ПолеКоличество = Неопределено,
	                     "",
	                     "Поле" + Формат(ПолеКоличество.ПолеТСД, "ЧГ=0"));
	ВремШтрихкод     = СоответствиеПолей[СтрокаШтрихкод];
	ВремКоличество   = СоответствиеПолей[СтрокаКоличество];

	Штрихкод         = ?(ВремШтрихкод = Неопределено, "", ВремШтрихкод);
	Попытка
		Количество = Число(ВремКоличество);
	Исключение
		Количество = 0;
	КонецПопытки;

КонецПроцедуры // ПолучитьСодержимоеСоответствияПолейТСД()

///////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПередЗаписью"
//
// Параметры
//  Отказ - <Булево>
//        - признак отказа от записи элемента. Если в теле 
//          процедуры-обработчика установить данному параметру
//          значение Истина, запись элемента выполнена не будет
//
Процедура ПередЗаписью(Отказ)
	
	Перем Ошибки;
	Перем ШтрихКод;
	Перем ЕстьШтрихКод;
	Перем ЗаполненыПараметрыНоменклатуры;
	Перем ЗаполненыПоляТСД;
	Перем УникальныеПараметрыНоменклатуры;
	Перем УникальныеПоляТСД;
	Перем ПараметрыНоменклатуры;
	Перем ПоляТСД;
	Перем СтрокаТЧ;
	
	Если Не ОбменДанными.Загрузка Тогда
		
		Ошибки                          = "";
		ЕстьШтрихКод                    = Ложь;
		ЗаполненыПараметрыНоменклатуры  = Истина;
		ЗаполненыПоляТСД                = Истина;
		УникальныеПараметрыНоменклатуры = Истина;
		УникальныеПоляТСД               = Истина;
		ПараметрыНоменклатуры           = Новый Соответствие();
		ПоляТСД                         = Новый Соответствие();
		
		Если НЕ ЗначениеЗаполнено(Наименование) Тогда
			Ошибки = " - Не задано имя формата.";
		КонецЕсли;
		
		Для Каждого СтрокаТЧ Из СвязываемыеПоля Цикл
			
			Если СтрокаТЧ.ПараметрНоменклатуры = Перечисления.ТСДПоляДанных.ШтрихКод Тогда
				ЕстьШтрихКод = Истина;
			КонецЕсли;
		
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ПараметрНоменклатуры) Тогда
				ЗаполненыПараметрыНоменклатуры = Ложь;
			ИначеЕсли ПараметрыНоменклатуры[СтрокаТЧ.ПараметрНоменклатуры] = Истина Тогда
				УникальныеПараметрыНоменклатуры = Ложь;
			Иначе
				ПараметрыНоменклатуры.Вставить(СтрокаТЧ.ПараметрНоменклатуры, Истина);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ПолеТСД) Тогда
				ЗаполненыПоляТСД = Ложь;
			ИначеЕсли ПоляТСД[СтрокаТЧ.ПолеТСД] = Истина Тогда
				УникальныеПоляТСД = Ложь;
			Иначе
				ПоляТСД.Вставить(СтрокаТЧ.ПолеТСД, Истина);
			КонецЕсли;
		
		КонецЦикла;
		
		Если Не ЕстьШтрихКод Тогда
			Если Не ПустаяСтрока(Ошибки) Тогда
				Ошибки = Ошибки + "
				|";
			КонецЕсли;
			Ошибки = Ошибки + " - Параметр номенклатуры ""Штрих-Код"" должен выгружаться в обязательном порядке.";
		КонецЕсли;
		
		Если Не ЗаполненыПараметрыНоменклатуры Тогда
			Если Не ПустаяСтрока(Ошибки) Тогда
				Ошибки = Ошибки + "
				|";
			КонецЕсли;
			Ошибки = Ошибки + " - Обнаружены незаполненные параметры номенклатуры.";
		КонецЕсли;
		
		Если Не ЗаполненыПоляТСД Тогда
			Если Не ПустаяСтрока(Ошибки) Тогда
				Ошибки = Ошибки + "
				|";
			КонецЕсли;
			Ошибки = Ошибки + " - Обнаружены незаполненные поля терминала.";
		КонецЕсли;
		
		Если Не УникальныеПараметрыНоменклатуры Тогда
			Если Не ПустаяСтрока(Ошибки) Тогда
				Ошибки = Ошибки + "
				|";
			КонецЕсли;
			Ошибки = Ошибки + " - Обнаружен параметр номенклатуры, выгружаемый в два поля одновременно.";
		КонецЕсли;
		
		Если Не УникальныеПоляТСД Тогда
			Если Не ПустаяСтрока(Ошибки) Тогда
				Ошибки = Ошибки + "
				|";
			КонецЕсли;
			Ошибки = Ошибки + " - Обнаружено поле терминала, в которое выгружаются несколько параметров одновременно.";
		КонецЕсли;
		
		Если Не ПустаяСтрока(Ошибки) Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("При попытке записи были обнаружены следующие ошибки:
			                 |" + Ошибки);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()


///////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мПолеШтрихкод                   = Перечисления.ТСДПоляДанных.ШтрихКод;
мПолеНаименованиеНоменклатуры   = Перечисления.ТСДПоляДанных.НоменклатураНаименование;
мПолеАртикулНоменклатуры        = Перечисления.ТСДПоляДанных.НоменклатураАртикул;
мПолеХарактеристикаНоменклатуры = Перечисления.ТСДПоляДанных.НоменклатураХарактеристика;
мПолеСерияНоменклатуры          = Перечисления.ТСДПоляДанных.НоменклатураСерия;
мПолеЕдиницаИзмерения           = Перечисления.ТСДПоляДанных.НоменклатураИзмерение;
мПолеКодНоменклатуры            = Перечисления.ТСДПоляДанных.НоменклатураКод;
мПолеЦенаНоменклатуры           = Перечисления.ТСДПоляДанных.НоменклатураЦена;
мПолеКоличествоНоменклатуры     = Перечисления.ТСДПоляДанных.КоличествоНаСкладе;
мПолеКачество                   = Перечисления.ТСДПоляДанных.Качество;