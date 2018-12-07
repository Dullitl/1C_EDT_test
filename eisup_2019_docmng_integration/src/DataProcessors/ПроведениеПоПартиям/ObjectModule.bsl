Перем мТекущаяНастройка Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СОХРАНЕНИЯ И ВОССТАНОВЛЕНИЯ НАСТРОЕК
#Если Клиент Тогда

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
	
	СтруктураСНастройками.Вставить("Останавливаться", Останавливаться);
	СтруктураСНастройками.Вставить("ОтражатьВБухгалтерскомУчете", ОтражатьВБухгалтерскомУчете);
	СтруктураСНастройками.Вставить("ОтражатьВУправленческомУчете", ОтражатьВУправленческомУчете);
	СтруктураСНастройками.Вставить("ВыполнятьНаСервере", ВыполнятьНаСервере);
	СтруктураСНастройками.Вставить("МаксимальноеКоличествоСтрокВТранзакции", МаксимальноеКоличествоСтрокВТранзакции);
	СтруктураСНастройками.Вставить("МаксимальноеКоличествоДокументовВВыборке", МаксимальноеКоличествоДокументовВВыборке);
	СтруктураСНастройками.Вставить("РежимПараллельнойРаботы", РежимПараллельнойРаботы);
	СтруктураСНастройками.Вставить("ФормироватьПроводки", ФормироватьПроводки);
	СтруктураСНастройками.Вставить("ПроводитьПоНДС", ПроводитьПоНДС);
	СтруктураСНастройками.Вставить("Режим", Режим);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт

	Перем СохраненныеНастройкиПостроителя;
	
	Если ТипЗнч(СтруктураСНастройками) = Тип("Структура") Тогда
		
		Для каждого Настройка из СтруктураСНастройками Цикл
			
			Если Настройка.Значение <> Неопределено Тогда
				
				//Настройки старой версии, таких реквизитов больше нет
				Если Настройка.Ключ = "ОтражатьВНалоговомУчете" 
				  ИЛИ Настройка.Ключ = "ПроводитьПоНДС" Тогда
					Продолжить;
				КонецЕсли;	
				
				ЭтотОбъект[Настройка.Ключ] = Настройка.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ВосстановитьНастройкиИзСтруктуры()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОСНОВНАЯ ПРОЦЕДУРА ОБРАБОТКИ
Функция ПолучитьГраницуПоследовательности(Учет="", Организация = Неопределено) Экспорт

	Если Учет = "Упр" ИЛИ Учет ="" Тогда
		СтрОкончание = "";
		СтрРеквизит = "Управленческом";
	ИначеЕсли Учет = "Бух" Тогда
		СтрОкончание = "БУ";
		СтрРеквизит = "Бухгалтерском";
	Иначе
		Возврат Новый МоментВремени('00010101');
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПартионныйУчетГраницы.МоментВремени КАК МоментВремени
	|ИЗ
	|	Последовательность.ПартионныйУчет" + СтрОкончание + ".Границы КАК ПартионныйУчетГраницы
	|ГДЕ
	|	ПартионныйУчетГраницы.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПартионныйУчет.МоментВремени
	|ИЗ
	|	Последовательность.ПартионныйУчет" + СтрОкончание + " КАК ПартионныйУчет
	|ГДЕ
	|	(НЕ ПартионныйУчет.ПроведенВХронологическойПоследовательности)
	|	И	ПартионныйУчет.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	МоментВремени";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат  Выборка.МоментВремени;
	Иначе
		Возврат Новый МоментВремени('00010101');
	КонецЕсли;

КонецФункции // ПолучитьГраницуПоследовательности(Задача)

МаксимальноеКоличествоДокументовВВыборке = 1000;

МаксимальноеКоличествоСтрокВТранзакции = 1000;

