////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Управление необходимостью делать движения по фактическим отпускам
Перем мВыполнятьСписаниеФактическогоОтпуска Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура СписатьФактическиеОтпуска()
	
	Регистратор = Отбор.Регистратор.Значение;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор",	Регистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.ДатаНачалаСобытия КАК ПериодДействия,
	|	Начисления.Сторно КАК Сторно,
	|	Начисления.ВидРасчета.ВидЕжегодногоОтпуска КАК ВидЕжегодногоОтпуска,
	|	Начисления.ОплаченоДнейЧасов КАК ДнейОтпуска,
	|	Начисления.Регистратор.Дата КАК ДатаРегистрации
	|ИЗ
	|	РегистрРасчета.ДополнительныеНачисленияРаботниковОрганизаций КАК Начисления
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|	И (НЕ Начисления.ВидРасчета.ВидЕжегодногоОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыЕжегодныхОтпусков.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Сторно УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыНакопления.ФактическиеОтпускаОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
	НаборЗаписей.Прочитать();
	Пока Выборка.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();
		
		// Свойства
		Движение.Период					= Выборка.ПериодДействия;
		
		// Измерения
		Движение.Сотрудник				= Выборка.Сотрудник;
		Движение.ВидЕжегодногоОтпуска	= Выборка.ВидЕжегодногоОтпуска;
		
		// Ресурсы
		Движение.Количество				= Выборка.ДнейОтпуска * ?(Выборка.Сторно, -1, 1);
		
		// Реквизиты
		Движение.Компенсация			= Истина;
		Движение.ДатаРегистрации		= Выборка.ДатаРегистрации;
	КонецЦикла;
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если мВыполнятьСписаниеФактическогоОтпуска Тогда
		СписатьФактическиеОтпуска();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВыполнятьСписаниеФактическогоОтпуска	= Ложь;
