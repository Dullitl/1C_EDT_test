Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	ЗарегистрироватьПерерасчеты();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьПерерасчеты();
	
КонецПроцедуры

Процедура ЗарегистрироватьПерерасчеты()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ФизЛицо,
	|	Основные.Регистратор КАК Регистратор,
	|	Основные.Организация,
	|	Основные.Сотрудник
	|ИЗ
	|	РегистрНакопления.РабочееВремяРаботниковОрганизаций КАК РабочееВремя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Основные
	|		ПО РабочееВремя.Период >= Основные.ПериодДействияНачало
	|			И РабочееВремя.Период <= Основные.ПериодДействияКонец
	|			И РабочееВремя.Сотрудник = Основные.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|		ПО (Перерасчеты.ОбъектПерерасчета = Основные.Регистратор)
	|			И (Перерасчеты.ФизЛицо = Основные.ФизЛицо)
	|			И (Перерасчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка))
	|ГДЕ
	|	РабочееВремя.Регистратор = &Регистратор
	|	И Перерасчеты.ФизЛицо ЕСТЬ NULL 
	|	И Основные.Регистратор ЕСТЬ НЕ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	
КонецПроцедуры

