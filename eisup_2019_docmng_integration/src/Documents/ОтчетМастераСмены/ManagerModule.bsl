// Скрывает колонку в области табличного документа, увеличивая на ширину скрытой колонки другую колонку.
//
// Параметры
//  Макет 				- табличный документ
//  ИмяОбластиСтроки 	- имя горизонтальной области табличного документа (модифицируемой)
//	ИмяОбластиОпциональнойКолонки - имя вертикальной области, соответствующей опциональной колонке
//  ИмяОбластиИзменяемойКолонки - имя вертикальной области, соответствующей колонке, ширина которой будет увеличена
//	ПризнакВывода		- булево, выводить (оставлять) опциональную область или нет
//
// Возвращаемое значение
//	Модифицированная область табличного документа, соответствующая области ИмяОбластиСтроки
//
Функция ПолучитьОбластьСОпцией(Макет, ИмяОбластиСтроки, ИмяОбластиОпциональнойКолонки, ИмяОбластиИзменяемойКолонки, ПризнакВывода)
	
	Если ПризнакВывода Тогда
		//отдаем как есть
	Иначе
		//надо спрятать область
		ОбластьДляУдаления 	= Макет.Область(ИмяОбластиСтроки+"|"+ИмяОбластиОпциональнойКолонки);
		ОбластьДляИзменения = Макет.Область(ИмяОбластиСтроки+"|"+ИмяОбластиИзменяемойКолонки);
		ОбластьДляИзменения.ШиринаКолонки 	= ОбластьДляИзменения.ШиринаКолонки + ОбластьДляУдаления.ШиринаКолонки;
		ОбластьДляУдаления.ШиринаКолонки 	= 0;
	КонецЕсли;
	
	Возврат Макет.ПолучитьОбласть(ИмяОбластиСтроки);
	
КонецФункции

// Функция формирует табличный документ с печатной формой результатов смены
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьОтчетаМастераСмены(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОтчетМастераСмены_Отчет";
	
	Макет = ПолучитьМакет("ОтчетМастераСмены");
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// ШАПКА
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтчетМастераСмены.Номер,
		|	ОтчетМастераСмены.Дата,
		|	ОтчетМастераСмены.Подразделение,
		|	ОтчетМастераСмены.Ответственный,
		|	Неопределено КАК Организация,
		|	ОтчетМастераСмены.Смена,
		|	ОтчетМастераСмены.ГраницаСмены,
		|	Представление(ОтчетМастераСмены.Подразделение),
		|	Представление(ОтчетМастераСмены.Ответственный)
		|ИЗ
		|	Документ.ОтчетМастераСмены КАК ОтчетМастераСмены
		|ГДЕ
		|	ОтчетМастераСмены.Ссылка = &Ссылка";

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		// Выводим шапку
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ТекстЗаголовка 		= ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, Ссылка.Метаданные().Синоним);
		ОбластьМакета.Параметры.ПредставлениеСмены 	= ОперативныйУчетПроизводства.ПредставлениеСмены(Шапка.ГраницаСмены, Шапка.Смена);
		
		ТабДокумент.Вывести(ОбластьМакета);

		
		ДопКолонка      = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
		Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
			
			ВыводитьАртикул 	= Истина;
			КолонкаАртикул 		= "Артикул";
			ИмяКолонкиАртикул	= "Артикул";
			
		ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
			
			ВыводитьАртикул 	= Истина;
			КолонкаАртикул 		= "Код";
			ИмяКолонкиАртикул	= "Код";
			
		Иначе
			
			ВыводитьАртикул		= Ложь;
			КолонкаАртикул 		= "Артикул";
			
		КонецЕсли;
		
		//ВЫПУСК
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеСтроки.Номенклатура,
		|	ДанныеСтроки.Номенклатура.Артикул КАК Артикул,
		|	ДанныеСтроки.ЕдиницаИзмерения,
		|	ДанныеСтроки.Количество,
		|	ДанныеСтроки.ХарактеристикаНоменклатуры КАК Характеристика,
		|	ДанныеСтроки.СерияНоменклатуры КАК Серия,
		|	ДанныеСтроки.НомерПартии,
		|	ДанныеСтроки.ВремяВыпуска,
		|	ДанныеСтроки.Спецификация,
		|	Представление(ДанныеСтроки.ХарактеристикаНоменклатуры),
		|	Представление(ДанныеСтроки.СерияНоменклатуры),
		|	Представление(ДанныеСтроки.Спецификация),
		|	Представление(ДанныеСтроки.Номенклатура),
		|	Представление(ДанныеСтроки.ЕдиницаИзмерения),
		|	ДанныеСтроки.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ОтчетМастераСмены.Выпуск КАК ДанныеСтроки
		|ГДЕ
		|	ДанныеСтроки.Ссылка = &Ссылка
		|	И ДанныеСтроки.Количество <> 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Если ВыводитьАртикул Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Артикул КАК Артикул,", "."+КолонкаАртикул+" КАК Артикул,");
		КонецЕсли;
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
		
			Область = ПолучитьОбластьСОпцией(Макет, "ЗаголовокВыпуск", 	"АртикулВыпуск", "НоменклатураВыпуск", ВыводитьАртикул);
			Область.Параметры.ИмяКолонкиАртикул = ИмяКолонкиАртикул;
			ТабДокумент.Вывести(Область);
			
			Область = ПолучитьОбластьСОпцией(Макет, "СтрокаВыпуск", 		"АртикулВыпуск", "НоменклатураВыпуск", ВыводитьАртикул);
			
			// Вывод строк таблицы
			Индекс = 0;
			Пока Выборка.Следующий() Цикл
			
				Индекс = Индекс + 1;
				
				Область.Параметры.НомерСтроки = Индекс;
				Область.Параметры.Заполнить(Выборка);
				Область.Параметры.НоменклатураПредставление = "" + Выборка.Номенклатура + ФормированиеПечатныхФормСервер.ПредставлениеСерий(Выборка);
				ТабДокумент.Вывести(Область);
				
			КонецЦикла;
			
			Область = ПолучитьОбластьСОпцией(Макет, "ИтогиВыпуск", 		"АртикулВыпуск", "НоменклатураВыпуск", ВыводитьАртикул);
			ТабДокумент.Вывести(Область);
			
		КонецЕсли;

		//ПАРАМЕТРЫ ВЫПУСКА
		
		ВыборкаНазначений = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОтчетМастераСменыПараметрыВыпуска.ВидПараметра КАК ВидПараметра,
		|	ОтчетМастераСменыПараметрыВыпуска.Значение КАК Значение,
		|	ОтчетМастераСменыВыпуск.КлючСвязи КАК КлючСвязи,
		|	Представление(ОтчетМастераСменыПараметрыВыпуска.ВидПараметра)
		|ИЗ
		|	Документ.ОтчетМастераСмены.Выпуск КАК ОтчетМастераСменыВыпуск
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетМастераСмены.ПараметрыВыпуска КАК ОтчетМастераСменыПараметрыВыпуска
		|		ПО ОтчетМастераСменыВыпуск.КлючСвязи = ОтчетМастераСменыПараметрыВыпуска.КлючСвязи
		|ГДЕ
		|	ОтчетМастераСменыВыпуск.Ссылка = &Ссылка
		|	И ОтчетМастераСменыПараметрыВыпуска.Ссылка = &Ссылка
		|ИТОГИ ПО
		|	КлючСвязи";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		ВыборкаНазначений = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		БылиПараметрыВыпуска = Ложь;
		
		Если ВыборкаНазначений.Количество() > 0 Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ОтчетМастераСменыВыпуск.Номенклатура,
			|	ОтчетМастераСменыВыпуск.ХарактеристикаНоменклатуры КАК Характеристика,
			|	ОтчетМастераСменыВыпуск.СерияНоменклатуры КАК Серия,
			|	ОтчетМастераСменыВыпуск.НомерПартии,
			|	ОтчетМастераСменыВыпуск.ВремяВыпуска,
			|	ОтчетМастераСменыВыпуск.Спецификация,
			|	ОтчетМастераСменыВыпуск.КлючСвязи КАК КлючСвязи,
			|	Представление(ОтчетМастераСменыВыпуск.Номенклатура),
			|	Представление(ОтчетМастераСменыВыпуск.ЕдиницаИзмерения),
			|	Представление(ОтчетМастераСменыВыпуск.ХарактеристикаНоменклатуры),
			|	Представление(ОтчетМастераСменыВыпуск.СерияНоменклатуры),
			|	Представление(ОтчетМастераСменыВыпуск.Спецификация)
			|ИЗ
			|	Документ.ОтчетМастераСмены.Выпуск КАК ОтчетМастераСменыВыпуск
			|ГДЕ
			|	ОтчетМастераСменыВыпуск.Ссылка = &Ссылка");
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			ДанныеКлючей = Запрос.Выполнить().Выгрузить();
			
			Область = Макет.ПолучитьОбласть("ЗаголовокПараметры");
			ТабДокумент.Вывести(Область);
			
			Область 	  = Макет.ПолучитьОбласть("СтрокаНазначениеПараметров");
			ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаПараметры");
			
			Пока ВыборкаНазначений.Следующий() Цикл
				
				ДанныеКлюча = ДанныеКлючей.Найти(ВыборкаНазначений.КлючСвязи, "КлючСвязи"); //есть уверенность, что найдет, так как запрос по значениям параметров использует внутреннее соединение с выпуском
				
				Область.Параметры.НазначениеПараметров = "" + ДанныеКлюча.Номенклатура + ФормированиеПечатныхФормСервер.ПредставлениеСерий(ДанныеКлюча);
				
				ТабДокумент.Вывести(Область);
				
				// Вывод строк таблицы
				Выборка = ВыборкаНазначений.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока Выборка.Следующий() Цикл
				
					ОбластьСтроки.Параметры.Заполнить(Выборка);
					ТабДокумент.Вывести(ОбластьСтроки);
					
				КонецЦикла;
				
			КонецЦикла;
			
			БылиПараметрыВыпуска = Истина;
			
		КонецЕсли;

		//ТЕХНОЛОГИЧЕСКИЕ ПАРАМЕТРЫ
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОтчетМастераСменыТехнологическиеПараметры.ВидПараметра,
		|	ОтчетМастераСменыТехнологическиеПараметры.Значение,
		|	ОтчетМастераСменыТехнологическиеПараметры.ВидПараметра.Представление КАК ВидПараметраПредставление
		|ИЗ
		|	Документ.ОтчетМастераСмены.ТехнологическиеПараметры КАК ОтчетМастераСменыТехнологическиеПараметры
		|ГДЕ
		|	ОтчетМастераСменыТехнологическиеПараметры.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидПараметраПредставление";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		БылиТехнологическиеПараметры = Ложь;
		
		Если Выборка.Количество() > 0 Тогда
			
			БылиТехнологическиеПараметры = Истина;
			
			Если НЕ БылиПараметрыВыпуска Тогда
				Область = Макет.ПолучитьОбласть("ЗаголовокПараметры");
				ТабДокумент.Вывести(Область);
			Иначе
				Область 	  = Макет.ПолучитьОбласть("СтрокаНазначениеПараметров");
				Область.Параметры.НазначениеПараметров = "Общие технологические параметры:";
				ТабДокумент.Вывести(Область);
			КонецЕсли;
			
			Область = Макет.ПолучитьОбласть("СтрокаПараметры");
				
			// Вывод строк таблицы
			Пока Выборка.Следующий() Цикл
				
				Область.Параметры.Заполнить(Выборка);
				ТабДокумент.Вывести(Область);
					
			КонецЦикла;
				
		КонецЕсли;

		Если БылиТехнологическиеПараметры ИЛИ БылиПараметрыВыпуска Тогда
			Область = Макет.ПолучитьОбласть("ИтогиПараметры");
			ТабДокумент.Вывести(Область);
		КонецЕсли;
			
		//РАСХОД МАТЕРИАЛОВ
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеСтроки.Номенклатура,
		|	ДанныеСтроки.Номенклатура.Артикул КАК Артикул,
		|	ДанныеСтроки.ЕдиницаИзмерения,
		|	СУММА(ДанныеСтроки.Количество) КАК Количество,
		|	ДанныеСтроки.ХарактеристикаНоменклатуры КАК Характеристика,
		|	ДанныеСтроки.СерияНоменклатуры КАК Серия,
		|	Представление(ДанныеСтроки.ХарактеристикаНоменклатуры),
		|	Представление(ДанныеСтроки.СерияНоменклатуры),
		|	ДанныеСтроки.Номенклатура.Представление КАК НоменклатураПредставление,
		|	Представление(ДанныеСтроки.ЕдиницаИзмерения),
		|	СУММА(ДанныеСтроки.КоличествоПоНормативу) КАК КоличествоПоНормативу
		|ИЗ
		|	Документ.ОтчетМастераСмены.РасходМатериалов КАК ДанныеСтроки
		|ГДЕ
		|	ДанныеСтроки.Ссылка = &Ссылка
		|	И (ДанныеСтроки.Количество <> 0
		|			ИЛИ ДанныеСтроки.КоличествоПоНормативу <> 0)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеСтроки.Номенклатура,
		|	ДанныеСтроки.ЕдиницаИзмерения,
		|	ДанныеСтроки.ХарактеристикаНоменклатуры,
		|	ДанныеСтроки.СерияНоменклатуры,
		|	ДанныеСтроки.Номенклатура.Артикул
		|
		|УПОРЯДОЧИТЬ ПО
		|	НоменклатураПредставление";
		
		Если ВыводитьАртикул Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Артикул КАК Артикул,", "."+КолонкаАртикул+" КАК Артикул,");
		КонецЕсли;
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
		
			Область = ПолучитьОбластьСОпцией(Макет, "ЗаголовокРасходМатериалов", 	"АртикулРасходМатериалов", "НоменклатураРасходМатериалов", ВыводитьАртикул);
			Область.Параметры.ИмяКолонкиАртикул = ИмяКолонкиАртикул;
			ТабДокумент.Вывести(Область);
			
			Область = ПолучитьОбластьСОпцией(Макет, "СтрокаРасходМатериалов", 		"АртикулРасходМатериалов", "НоменклатураРасходМатериалов", ВыводитьАртикул);
			
			// Вывод строк таблицы
			Индекс = 0;
			Пока Выборка.Следующий() Цикл
			
				Индекс = Индекс + 1;
				
				Область.Параметры.НомерСтроки  = Индекс;
				Область.Параметры.Заполнить(Выборка);
				Область.Параметры.НоменклатураПредставление = "" + Выборка.Номенклатура + ФормированиеПечатныхФормСервер.ПредставлениеСерий(Выборка);
				Область.Параметры.КоличествоПоНормативу = ?(Выборка.КоличествоПоНормативу=Выборка.Количество, " = ", Выборка.КоличествоПоНормативу);
				ТабДокумент.Вывести(Область);
				
			КонецЦикла;
			
			Область = ПолучитьОбластьСОпцией(Макет, "ИтогиРасходМатериалов", 	"АртикулРасходМатериалов", "НоменклатураРасходМатериалов", ВыводитьАртикул);
			ТабДокумент.Вывести(Область);
			
		КонецЕсли;

		
		//ПОДВАЛ
		Область = Макет.ПолучитьОбласть("Подвал");
		Область.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(Область);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла; 

	Возврат ТабДокумент;

КонецФункции // ПечатьОтчетаМастераСмены()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОтчетМастераСмены") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОтчетМастераСмены", "Отчет мастера смены", ПечатьОтчетаМастераСмены(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

// Определяет смену исходя из реквизитов документа.
//
Функция ПолучитьСмену(Подразделение, ГраницаСмены, Ответственный, Дата) Экспорт
	
	Смена = Неопределено;
	
	//Предполагаем, что мастер смены в 1 день работает только одну смену.
	//Т.е. если уже есть документы за сегодня с этим бригадиром и эта смена не закрыта, 
	//то он продолжает работать в свою смену и номер смены возьмем из существующего документа.
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ОтчетМастераСмены.Смена
	|ИЗ
	|	Документ.ОтчетМастераСмены КАК ОтчетМастераСмены
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗавершенныеСмены КАК ЗавершенныеСмены
	|		ПО ОтчетМастераСмены.Подразделение = ЗавершенныеСмены.Подразделение
	|ГДЕ
	|	ОтчетМастераСмены.Подразделение = &Подразделение
	|	И ОтчетМастераСмены.Проведен
	|	И ОтчетМастераСмены.Ответственный = &Ответственный
	|	И НАЧАЛОПЕРИОДА(ОтчетМастераСмены.ГраницаСмены, ДЕНЬ) = &Дата
	|	И ОтчетМастераСмены.ГраницаСмены > ЕСТЬNULL(ЗавершенныеСмены.ГраницаСмены, ДАТАВРЕМЯ(1, 1, 1))"
	);
	Запрос.УстановитьПараметр("Подразделение", 	Подразделение);
	Запрос.УстановитьПараметр("Ответственный", 	Ответственный);
	Запрос.УстановитьПараметр("Дата", 			НачалоДня(ГраницаСмены));
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		// Смена с этим бригадиром еще не началась.
		// Попробуем определить смену из графика работы.
		СменаПоГрафику = ОперативныйУчетПроизводства.ПолучитьСменуПоГрафику(Ответственный.ФизЛицо, Дата);
		Если ЗначениеЗаполнено(СменаПоГрафику) Тогда
			Смена = СменаПоГрафику;
		КонецЕсли;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий(); // В выборке будет ровно 1 запись
		Если ЗначениеЗаполнено(Выборка.Смена) Тогда
			Смена = Выборка.Смена;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Смена;
	
КонецФункции // 

// В функции описано, какие данные следует сохранять в шаблоне
//
Функция СтруктураДополнительныхДанныхФормы() Экспорт
	
	Возврат ХранилищаНастроек.ДанныеФорм.СформироватьСтруктуруДополнительныхДанных("Выпуск,ТехнологическиеПараметры,РасходМатериалов,ПараметрыВыпуска");
	
КонецФункции
