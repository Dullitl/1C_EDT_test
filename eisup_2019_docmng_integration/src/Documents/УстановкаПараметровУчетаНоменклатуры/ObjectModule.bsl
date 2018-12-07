Перем мДатаПередЗаписью; //хранит момент времени, который был в базе до записи объекта

Перем СтрокаДляВсехОрганизаций Экспорт; 	//константа с текстом, обозначающим, что настройка будет действовать для всех организаций
Перем СтрокаДляВсейНоменклатуры Экспорт; 	//константа с текстом, обозначающим, что настройка будет действовать для всей номенклатуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если Клиент Тогда
	
//Возвращает область табличного документа, при необходимости (в зависимости от булевого параметра ПризнакВывода)
//скрывая Опциональную колонку и увеличивая на ширину скрытой колонки Изменяемую колонку.
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

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;


	// Получить экземпляр документа на печать
	Если	ИмяМакета = "УстановленныеСчетаНоменклатуры" Тогда
		
		ТабДокумент = ПечатьУстановленныхСчетовУчета();
		
	ИначеЕсли	ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ), Ссылка);

КонецПроцедуры // Печать

// Функция формирует табличный документ с печатной формой результатов смены
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьУстановленныхСчетовУчета()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УстановкаПараметровУчетаНоменклатуры";
	
	Макет = ПолучитьМакет("УстановленныеСчетаУчетаНоменклатуры");
	
	// ШАПКА
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УстановкаПараметровУчетаНоменклатуры.Номер,
	|	УстановкаПараметровУчетаНоменклатуры.Дата,
	|	УстановкаПараметровУчетаНоменклатуры.Ответственный,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	УстановкаПараметровУчетаНоменклатуры.Ответственный.Представление
	|ИЗ
	|	Документ.УстановкаПараметровУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатуры
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатуры.Ссылка = &Ссылка";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	// Выводим шапку
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ТекстЗаголовка 			= ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Установка параметров учета номенклатуры");
	//ОбластьМакета.Параметры.ДатаОкончанияДействия	= ПолучитьДатуОкончанияДействия();
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	//СЧЕТА УЧЕТА ТОВАРОВ
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Номенклатура,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Организация,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.НомерСтроки КАК НомерСтроки,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетУчетаБУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетДоходовБУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетРасходовБУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетУчетаНУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетДоходовНУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетРасходовНУ,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.ПринадлежностьНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Номенклатура),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Организация),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетУчетаБУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетДоходовБУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетРасходовБУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетУчетаНУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетДоходовНУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.СчетРасходовНУ),
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.ПринадлежностьНоменклатуры КАК ПринадлежностьНоменклатуры1,
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.ПринадлежностьНоменклатуры)
	|ИЗ
	|	Документ.УстановкаПараметровУчетаНоменклатуры.СчетаУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВыводитьПринадлежностьНоменклатуры = Истина;
	
	Если Выборка.Количество() > 0 Тогда
	
		Область	= ПолучитьОбластьСОпцией(Макет, "ЗаголовокСчетаУчетаНоменклатуры", "ПринадлежностьНоменклатуры", "ВидНоменклатуры", ВыводитьПринадлежностьНоменклатуры);
		ТабДокумент.Вывести(Область);
		
		Область	= ПолучитьОбластьСОпцией(Макет, "СтрокаСчетаУчетаНоменклатуры", "ПринадлежностьНоменклатуры", "ВидНоменклатуры", ВыводитьПринадлежностьНоменклатуры);
		
		// Вывод строк таблицы
		Пока Выборка.Следующий() Цикл
		
			Область.Параметры.Заполнить(Выборка);
			
			Если Выборка.Организация.Пустая() Тогда
				Область.Параметры.Организация = СтрокаДляВсехОрганизаций;
			КонецЕсли;
			
			Если Выборка.Номенклатура = Неопределено Тогда
				Область.Параметры.Номенклатура = СтрокаДляВсейНоменклатуры;
			КонецЕсли;
			
			Если НЕ ВыводитьПринадлежностьНоменклатуры Тогда
				Область.Параметры.ПринадлежностьНоменклатуры = "";
			КонецЕсли;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
		
		Область	= ПолучитьОбластьСОпцией(Макет, "ИтогиСчетаУчетаНоменклатуры", "ПринадлежностьНоменклатуры", "ВидНоменклатуры", ВыводитьПринадлежностьНоменклатуры);
		ТабДокумент.Вывести(Область);
		
	КонецЕсли;

	//СЧЕТА УЧЕТА УСЛУГ
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Номенклатура,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Организация,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.НомерСтроки КАК НомерСтроки,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетЗатрат,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетДоходовБУ,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетРасходовБУ,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетЗатратНУ,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетДоходовНУ,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетРасходовНУ,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Подразделение,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.ПодразделениеОрганизации,
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.НоменклатурнаяГруппа,
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Номенклатура),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Организация),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетЗатрат),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетДоходовБУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетРасходовБУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетЗатратНУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетДоходовНУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.СчетРасходовНУ),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Подразделение),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.ПодразделениеОрганизации),
	|	ПРЕДСТАВЛЕНИЕ(УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.НоменклатурнаяГруппа)
	|ИЗ
	|	Документ.УстановкаПараметровУчетаНоменклатуры.ПараметрыУчетаУслуг КАК УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатурыПараметрыУчетаУслуг.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
	
		Область	= Макет.ПолучитьОбласть("ЗаголовокУслуги");
		ТабДокумент.Вывести(Область);
		
		Область	= Макет.ПолучитьОбласть("СтрокаУслуги");
		
		// Вывод строк таблицы
		Пока Выборка.Следующий() Цикл
		
			Область.Параметры.Заполнить(Выборка);
			
			Если Выборка.Организация.Пустая() Тогда
				Область.Параметры.Организация = СтрокаДляВсехОрганизаций;
			КонецЕсли;
			
			Если Выборка.Номенклатура = Неопределено Тогда
				Область.Параметры.Номенклатура = СтрокаДляВсейНоменклатуры;
			КонецЕсли;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
		
		Область	= Макет.ПолучитьОбласть("ИтогиУслуги");
		ТабДокумент.Вывести(Область);
		
	КонецЕсли;
	
	
	//ПОДВАЛ
	Область = Макет.ПолучитьОбласть("Подвал");
	Область.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(Область);

	Возврат ТабДокумент;

КонецФункции

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктПечатныхФорм = Новый Структура;
	
	СтруктПечатныхФорм.Вставить("УстановленныеСчетаНоменклатуры", "Установленные счета номенклатуры");
	
	Возврат СтруктПечатныхФорм;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()
#КонецЕсли

//Возвращает дату окончания действия этого документа
Функция ПолучитьДатуОкончанияДействия() Экспорт
	
	//Дата окончания действия - это дата следующего проведенного документа
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УстановкаПараметровУчетаНоменклатуры.Дата
	|ИЗ
	|	Документ.УстановкаПараметровУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатуры
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатуры.Проведен
	|	И УстановкаПараметровУчетаНоменклатуры.Ссылка <> &Ссылка
	|	И УстановкаПараметровУчетаНоменклатуры.Дата > &Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	УстановкаПараметровУчетаНоменклатуры.Дата"
	);
	
	Запрос.УстановитьПараметр("Дата",	Дата);
	Запрос.УстановитьПараметр("Ссылка",	Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаОкончанияДействия = Выборка.Дата;
	Иначе
		//аналогично учетной политике организаций
		ДатаОкончанияДействия = "";
	КонецЕсли;
	
	Возврат ДатаОкончанияДействия;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

//Проверяет, что в табличной части нет неоднозначных строк (дублей с одинаковым набором ключевых реквизитов)
Процедура ПроверитьЗаполнениеТабличнойЧастиСчетаУчетаНоменклатуры(Отказ, Заголовок, ИмяТабличнойЧасти="СчетаУчетаНоменклатуры")
	
	//Не допускаем наличие двух записей с одинаковыми ключевыми полями
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДублиСтрок.Организация КАК Организация,
	|	ДублиСтрок.Номенклатура КАК Номенклатура,
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.НомерСтроки КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ДублиСтрок.Организация),
	|	ПРЕДСТАВЛЕНИЕ(ДублиСтрок.Номенклатура)
	|ИЗ
	|	(ВЫБРАТЬ
	|		УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Организация КАК Организация,
	|		УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Номенклатура КАК Номенклатура
	|	ИЗ
	|		Документ.УстановкаПараметровУчетаНоменклатуры.СчетаУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры
	|	ГДЕ
	|		УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Ссылка = &Ссылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Организация,
	|		УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Номенклатура
	|	
	|	ИМЕЮЩИЕ
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.НомерСтроки) > 1) КАК ДублиСтрок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаПараметровУчетаНоменклатуры.СчетаУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры
	|		ПО ДублиСтрок.Организация = УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Организация
	|			И ДублиСтрок.Номенклатура = УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Номенклатура
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатурыСчетаУчетаНоменклатуры.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	Организация,
	|	Номенклатура"
	);
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"СчетаУчетаНоменклатуры",ИмяТабличнойЧасти);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаОрганизаций = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизаций.Следующий() Цикл
			
			ВыборкаНоменклатуры = ВыборкаОрганизаций.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаНоменклатуры.Следующий() Цикл
				
				СписокСтрок = "";
				
				Выборка = ВыборкаНоменклатуры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока Выборка.Следующий() Цикл
					СписокСтрок = СписокСтрок + ", " + Выборка.НомерСтроки;
				КонецЦикла;
				
				Если СтрДлина(СписокСтрок)>0 Тогда
					СписокСтрок = Сред(СписокСтрок, 2);
				КонецЕсли;
				
				ttk_ОбщегоНазначения.СообщитьОбОшибке("В строках №№ "+СписокСтрок+" табличной части """ + ?(ИмяТабличнойЧасти = "СчетаУчетаНоменклатуры", "Товары","Услуги") + """ совпадают значения Организации и Номенклатуры ("
				+?(ЗначениеЗаполнено(ВыборкаНоменклатуры.Организация),	ВыборкаНоменклатуры.Организация, 	СтрокаДляВсехОрганизаций) + ", " 
				+?(ЗначениеЗаполнено(ВыборкаНоменклатуры.Номенклатура),	ВыборкаНоменклатуры.Номенклатура,	СтрокаДляВсейНоменклатуры)+")"
				, Отказ, Заголовок);
					
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//Проверяет, что в табличной части нет неоднозначных строк (дублей с одинаковым набором ключевых реквизитов)
Процедура ПроверитьЗаполнениеТабличнойЧастиСпособыРасчетаСебестоимостиВФормах(Отказ, Заголовок)
	
	//Не допускаем наличие двух записей с одинаковыми ключевыми полями
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДублиСтрок.Организация КАК Организация,
	|	УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.НомерСтроки КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ДублиСтрок.Организация)
	|ИЗ
	|	(ВЫБРАТЬ
	|		УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.Организация КАК Организация
	|	ИЗ
	|		Документ.УстановкаПараметровУчетаНоменклатуры.СпособыРасчетаСебестоимостиВФормах КАК УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах
	|	ГДЕ
	|		УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.Ссылка = &Ссылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.Организация
	|	
	|	ИМЕЮЩИЕ
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.НомерСтроки) > 1) КАК ДублиСтрок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаПараметровУчетаНоменклатуры.СпособыРасчетаСебестоимостиВФормах КАК УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах
	|		ПО ДублиСтрок.Организация = УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.Организация
	|ГДЕ
	|	УстановкаПараметровУчетаНоменклатурыСпособыРасчетаСебестоимостиВФормах.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	Организация"
	);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаОрганизаций = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизаций.Следующий() Цикл
			
			СписокСтрок = "";
			
			Выборка = ВыборкаОрганизаций.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборка.Следующий() Цикл
				СписокСтрок = СписокСтрок + ", " + Выборка.НомерСтроки;
			КонецЦикла;
			
			Если СтрДлина(СписокСтрок)>0 Тогда
				СписокСтрок = Сред(СписокСтрок, 2);
			КонецЕсли;
			
			ttk_ОбщегоНазначения.СообщитьОбОшибке("В строках №№ "+СписокСтрок+" табличной части ""Способы расчета себестоимости в формах"" совпадают значения Организации ("
			+?(ЗначениеЗаполнено(ВыборкаОрганизаций.Организация),	ВыборкаОрганизаций.Организация, 	СтрокаДляВсехОрганизаций)+")"
			, Отказ, Заголовок);
		КонецЦикла;
	КонецЕсли;
	
	//Проверим заполнение способа расчета
	Для Каждого ТекущаяСтрока Из СпособыРасчетаСебестоимостиВФормах Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.СпособРасчета) Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("В строке № "+ТекущаяСтрока.НомерСтроки+" табличной части ""Способы расчета себестоимости в формах"" не заполнен ""Способ расчета""", Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

//Если изменение документа привело к изменению даты начала действия режима определения счетов, то
// - изменяет значение глобальной переменной ДатаНачалаОпределенияСчетовПриПроведенииДокументов
// - выдает пользователю соответствующее сообщение.
Процедура ПроверитьИзменениеДатыНачалаОпределенияСчетовПриПроведенииДокумента(флПроведение,ДатаДокументаДоОтменыПроведения=неопределено)
	
	СтараяДатаНачалаОпределенияСчетов = глЗначениеПеременной("ДатаНачалаОпределенияСчетовПриПроведенииДокументов");
	
	флИзмененРежим = ложь;
	НоваяДатаНачалаОпределенияСчетов = неопределено;
	Если флПроведение Тогда
		
		//документ проводится
		Если СтараяДатаНачалаОпределенияСчетов=неопределено Тогда
			флИзмененРежим = истина;
			СтрокаДействие = "Включен режим";
			НоваяДатаНачалаОпределенияСчетов = Дата;
		ИначеЕсли СтараяДатаНачалаОпределенияСчетов>Дата Тогда
			флИзмененРежим = истина;
			СтрокаДействие = "Изменена дата начала действия режима";
			НоваяДатаНачалаОпределенияСчетов = Дата;
		КонецЕсли;
		
	Иначе
		
		//документ распроводится
		Если СтараяДатаНачалаОпределенияСчетов=мДатаПередЗаписью Тогда
			флИзмененРежим = истина;
			//проверим есть ли другие документы позже этого
			НоваяДатаНачалаОпределенияСчетов = СчетаУчетаВДокументах.ПолучитьДатуПервогоДокументаУстановкиСчетовУчетаНоменклатуры(Ссылка);
			Если НоваяДатаНачалаОпределенияСчетов = неопределено Тогда
				СтрокаДействие = "Отключен режим";
			Иначе
				СтрокаДействие = "Изменена дата начала действия режима";
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если флИзмененРежим Тогда
		
		// заполним новое значение в кеше
		глЗначениеПеременнойУстановить("ДатаНачалаОпределенияСчетовПриПроведенииДокументов",НоваяДатаНачалаОпределенияСчетов);
		// выведем сообщение
		Если СтараяДатаНачалаОпределенияСчетов = Неопределено Тогда
			ВажнаяОсобенностьРежима = "";
		ИначеЕсли НоваяДатаНачалаОпределенияСчетов = Неопределено Тогда
			ВажнаяОсобенностьРежима = "
			|При заполнении документов будут использоваться данные регистра сведений ""Счета учета номенклатуры""";
		КонецЕсли;
		
		ОбщегоНазначения.Сообщение(СтрокаДействие+" ""Определение счетов при проведении документов""" 
		+ ВажнаяОсобенностьРежима + "
		|Для того чтобы это изменение начало действовать для других пользователей, им необходимо перезапустить программу.
		|Для вас новая настройка уже вступила в силу, перезапускать программу не требуется");
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	ПроверитьЗаполнениеТабличнойЧастиСчетаУчетаНоменклатуры(Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиСчетаУчетаНоменклатуры(Отказ, Заголовок, "ПараметрыУчетаУслуг");
	ПроверитьЗаполнениеТабличнойЧастиСпособыРасчетаСебестоимостиВФормах(Отказ, Заголовок);

	Если Не Отказ Тогда
		//проверка изменения даты начала действия режима определения счетов при проведении документа
		ПроверитьИзменениеДатыНачалаОпределенияСчетовПриПроведенииДокумента(истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если НЕ ЭтоНовый() Тогда
		
		//Получим дату документа в ИБ
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	УстановкаПараметровУчетаНоменклатуры.Дата КАК Дата
		|ИЗ
		|	Документ.УстановкаПараметровУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатуры
		|ГДЕ
		|	УстановкаПараметровУчетаНоменклатуры.Ссылка = &Ссылка"
		);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		мДатаПередЗаписью = Выборка.Дата;
		
	КонецЕсли;
	
	//Пустую номенклатуру и виды номенклатуры приводим к Неопределено
	Для Каждого ДанныеСтроки Из СчетаУчетаНоменклатуры Цикл
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда
			ДанныеСтроки.Номенклатура = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	//Пустую номенклатуру и виды номенклатуры приводим к Неопределено
	Для Каждого ДанныеСтроки Из ПараметрыУчетаУслуг Цикл
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда
			ДанныеСтроки.Номенклатура = Неопределено;
		КонецЕсли;
	КонецЦикла;	
	
	//Не допускаем проведения двух документов с одинаковым временем
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УстановкаПараметровУчетаНоменклатуры.Ссылка
		|ИЗ
		|	Документ.УстановкаПараметровУчетаНоменклатуры КАК УстановкаПараметровУчетаНоменклатуры
		|ГДЕ
		|	УстановкаПараметровУчетаНоменклатуры.Дата = &Дата
		|	И УстановкаПараметровУчетаНоменклатуры.Ссылка <> &Ссылка
		|	И УстановкаПараметровУчетаНоменклатуры.Проведен"
		);
		Запрос.УстановитьПараметр("Дата", 	Дата);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Проведенные документы установки счетов учета номенклатуры не должны иметь одинаковые даты", Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	
	//Обращаемся к переменной, чтобы её значение не инициализировалось заведомо до проведения
	глЗначениеПеременной("ДатаНачалаОпределенияСчетовПриПроведенииДокументов"); 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	//проверка изменения даты начала действия режима определения счетов при проведении документа
	ПроверитьИзменениеДатыНачалаОпределенияСчетовПриПроведенииДокумента(ложь);

КонецПроцедуры

СтрокаДляВсехОрганизаций	= "<Для всех организаций>";
СтрокаДляВсейНоменклатуры	= "<Для всей номенклатуры>";
