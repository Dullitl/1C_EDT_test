Процедура ПередЗаписью(Отказ, Замещение, ТолькоЗапись)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьПерерасчетыНДФЛ();
	СправкиПоНДФЛ.ОчиститьКодыОКТМО(ЭтотОбъект, "Период");

	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение, ТолькоЗапись)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьПерерасчетыНДФЛ();
	
КонецПроцедуры

Процедура ЗарегистрироватьПерерасчетыНДФЛ()
	
	Если ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.НачислениеЗарплатыРаботникамОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НДФЛРасчетыСБюджетом.Регистратор КАК Регистратор,
	|	НДФЛРасчетыСБюджетом.ФизЛицо,
	|	НДФЛРасчетыСБюджетом.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СотрудникиОрганизаций.ПустаяСсылка) КАК Сотрудник
	|ИЗ
	|	РегистрНакопления.НДФЛСведенияОДоходах КАК НДФЛСведенияОДоходах
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.НДФЛРасчетыСБюджетом КАК НДФЛРасчетыСБюджетом
	|		ПО НДФЛСведенияОДоходах.ФизЛицо = НДФЛРасчетыСБюджетом.ФизЛицо
	|			И НДФЛСведенияОДоходах.Организация = НДФЛРасчетыСБюджетом.Организация
	|			И НАЧАЛОПЕРИОДА(НДФЛСведенияОДоходах.ПериодРегистрации, МЕСЯЦ) = НАЧАЛОПЕРИОДА(НДФЛРасчетыСБюджетом.МесяцНалоговогоПериода, МЕСЯЦ)
	|			И (НДФЛРасчетыСБюджетом.СтавкаНалогообложенияРезидента = &Ставка13)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|		ПО (Перерасчеты.ОбъектПерерасчета = НДФЛРасчетыСБюджетом.Регистратор)
	|			И (Перерасчеты.ФизЛицо = НДФЛРасчетыСБюджетом.ФизЛицо)
	|			И (Перерасчеты.ВидРасчета = &ПустойВидРасчета)
	|ГДЕ
	|	НДФЛСведенияОДоходах.Регистратор = &Регистратор
	|	И ВЫБОР
	|			КОГДА ИСТИНА
	|				ТОГДА НДФЛРасчетыСБюджетом.Регистратор
	|		КОНЕЦ ССЫЛКА Документ.НачислениеЗарплатыРаботникамОрганизаций
	|	И Перерасчеты.ФизЛицо ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("Ставка13", Перечисления.НДФЛСтавкиНалогообложенияРезидента.Ставка13);
	Запрос.УстановитьПараметр("ПустойВидРасчета", ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	
КонецПроцедуры


