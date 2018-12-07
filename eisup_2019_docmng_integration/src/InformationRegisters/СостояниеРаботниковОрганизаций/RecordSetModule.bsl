////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Управление необходимостью делать движения по фактическим отпускам
Перем мВыполнятьСписаниеФактическогоОтпуска Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура СписатьФактическиеОтпуска()
	
	Регистратор = Отбор.Регистратор.Значение;
	
	ПорядокСписанияФактическихОтпусков = ПроцедурыУправленияПерсоналом.ЗначениеУчетнойПолитикиПоПерсоналуОрганизации(глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"), ЭтотОбъект[0].Организация, "ПорядокСписанияФактическихОтпусков");
	Если ПорядокСписанияФактическихОтпусков <> Перечисления.ПорядокСписанияФактическихОтпусков.КадровымиПриказами Тогда
		НаборЗаписей = РегистрыНакопления.ФактическиеОтпускаОрганизаций.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
	
	// Если состояние = ЕжегодныйОтпуск и заполнен ПериодЗавершения, отпуск списывается регистратором;
	// Для всех других состояний или пустого ПериодЗавершения отпуск списывается тем регистратором,
	//  который прекращает отпуск;
	// Если пользователь вводит "Возврат на работу", тем самым досрочно прекращая отпуск, документ
	//  делает корректирующее движение. Остальные документы корректирующие движения не делают.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор",	Регистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕжегодныеОтпуска.Сотрудник КАК Сотрудник,
	|	ЕжегодныеОтпуска.Период КАК ДатаНачала,
	|	ДОБАВИТЬКДАТЕ(ЕжегодныеОтпуска.ПериодЗавершения, СЕКУНДА, -1) КАК ДатаОкончания,
	|	ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднемуОтпКалендарныеДни) КАК ВидОсновногоОтпуска,
	|	ЕжегодныеОтпуска.ДатаНачалаДоп,
	|	ЕжегодныеОтпуска.ВидДополнительногоОтпуска,
	|	ЛОЖЬ КАК КорректироватьОтпуск,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК НоваяДатаОкончания,
	|	ЕжегодныеОтпуска.Регистратор КАК РегистраторНачалаОтпуска
	|ПОМЕСТИТЬ ВТ_ОтпускаСотрудников
	|ИЗ
	|	РегистрСведений.СостояниеРаботниковОрганизаций КАК ЕжегодныеОтпуска
	|ГДЕ
	|	ЕжегодныеОтпуска.Регистратор = &Регистратор
	|	И (НЕ ЕжегодныеОтпуска.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1))
	|	И ЕжегодныеОтпуска.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияРаботникаОрганизации.ОтпускЕжегодный)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕжегодныеОтпускаНачало.Сотрудник,
	|	ЕжегодныеОтпускаНачало.Период,
	|	ВЫБОР
	|		КОГДА ЕжегодныеОтпускаНачало.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕжегодныеОтпускаОкончание.Период, СЕКУНДА, -1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ЕжегодныеОтпускаНачало.ПериодЗавершения, СЕКУНДА, -1)
	|	КОНЕЦ,
	|	ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднемуОтпКалендарныеДни),
	|	ЕжегодныеОтпускаНачало.ДатаНачалаДоп,
	|	ЕжегодныеОтпускаНачало.ВидДополнительногоОтпуска,
	|	ВЫБОР
	|		КОГДА ЕжегодныеОтпускаОкончание.Регистратор ССЫЛКА Документ.ВозвратНаРаботуОрганизаций
	|				И ЕжегодныеОтпускаНачало.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕжегодныеОтпускаОкончание.Регистратор ССЫЛКА Документ.ВозвратНаРаботуОрганизаций
	|				И ЕжегодныеОтпускаНачало.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ЕжегодныеОтпускаОкончание.Период, СЕКУНДА, -1)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ,
	|	ЕжегодныеОтпускаНачало.Регистратор
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЕжегодныеОтпускаОкончание.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(ЕжегодныеОтпускаНачало.Период) КАК ДатаНачала,
	|		ЕжегодныеОтпускаОкончание.Период КАК ДатаОкончания
	|	ИЗ
	|		РегистрСведений.СостояниеРаботниковОрганизаций КАК ЕжегодныеОтпускаНачало
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ЕжегодныеОтпускаОкончание
	|			ПО ЕжегодныеОтпускаНачало.Сотрудник = ЕжегодныеОтпускаОкончание.Сотрудник
	|				И ЕжегодныеОтпускаНачало.Период < ЕжегодныеОтпускаОкончание.Период
	|				И (ЕжегодныеОтпускаОкончание.Регистратор = &Регистратор)
	|				И (ЕжегодныеОтпускаОкончание.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияРаботникаОрганизации.ОтпускЕжегодный))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЕжегодныеОтпускаОкончание.Сотрудник,
	|		ЕжегодныеОтпускаОкончание.Период) КАК ЕжегодныеОтпускаНачалоСрез
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ЕжегодныеОтпускаНачало
	|		ПО ЕжегодныеОтпускаНачалоСрез.Сотрудник = ЕжегодныеОтпускаНачало.Сотрудник
	|			И ЕжегодныеОтпускаНачалоСрез.ДатаНачала = ЕжегодныеОтпускаНачало.Период
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ЕжегодныеОтпускаОкончание
	|		ПО ЕжегодныеОтпускаНачалоСрез.Сотрудник = ЕжегодныеОтпускаОкончание.Сотрудник
	|			И ЕжегодныеОтпускаНачалоСрез.ДатаОкончания = ЕжегодныеОтпускаОкончание.Период
	|ГДЕ
	|	ЕжегодныеОтпускаНачало.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияРаботникаОрганизации.ОтпускЕжегодный)
	|	И ВЫБОР
	|			КОГДА ЕжегодныеОтпускаНачало.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ВЫБОР
	|						КОГДА ЕжегодныеОтпускаОкончание.Регистратор ССЫЛКА Документ.ВозвратНаРаботуОрганизаций
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА ЕжегодныеОтпускаОкончание.Регистратор ССЫЛКА Документ.ВозвратНаРаботуОрганизаций
	|					И ЕжегодныеОтпускаНачало.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЕжегодныеОтпускаНачало.ПериодЗавершения > ЕжегодныеОтпускаОкончание.Период
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускаСотрудников.Сотрудник,
	|	ОтпускаСотрудников.ДатаНачала КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|				ИЛИ ОтпускаСотрудников.ДатаОкончания < ОтпускаСотрудников.ДатаНачалаДоп
	|			ТОГДА ОтпускаСотрудников.ДатаОкончания
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|	КОНЕЦ КАК ДатаОкончания,
	|	ОтпускаСотрудников.ВидОсновногоОтпуска.ВидЕжегодногоОтпуска КАК ВидЕжегодногоОтпуска,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.КорректироватьОтпуск
	|				И ОтпускаСотрудников.НоваяДатаОкончания < ВЫБОР
	|					КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|							ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|						ТОГДА ОтпускаСотрудников.ДатаОкончания
	|					ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|				КОНЕЦ
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КорректироватьОтпуск,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.НоваяДатаОкончания < ВЫБОР
	|				КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|						ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|					ТОГДА ОтпускаСотрудников.ДатаОкончания
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|			КОНЕЦ
	|			ТОГДА ОтпускаСотрудников.НоваяДатаОкончания
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК НоваяДатаОкончания,
	|	СУММА(ВЫБОР
	|			КОГДА ОтпускаСотрудников.ВидОсновногоОтпуска.ВидЕжегодногоОтпуска.СпособРасчетаОстаткаОтпуска = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОстаткаОтпуска.ПоРабочимДням)
	|				ТОГДА ЕСТЬNULL(ПроизводственныйКалендарь.Шестидневка, 0)
	|			ИНАЧЕ ЕСТЬNULL(ПроизводственныйКалендарь.КалендарныеДни, 0)
	|		КОНЕЦ) КАК ДнейОтпуска,
	|	ОтпускаСотрудников.РегистраторНачалаОтпуска
	|ПОМЕСТИТЬ ВТ_КадровыеОтпуска
	|ИЗ
	|	ВТ_ОтпускаСотрудников КАК ОтпускаСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК ПроизводственныйКалендарь
	|		ПО (ПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ ОтпускаСотрудников.ДатаНачала И ВЫБОР
	|				КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|						ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|						ИЛИ ОтпускаСотрудников.ДатаОкончания < ОтпускаСотрудников.ДатаНачалаДоп
	|					ТОГДА ОтпускаСотрудников.ДатаОкончания
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|			КОНЕЦ)
	|ГДЕ
	|	(НЕ ОтпускаСотрудников.ВидОсновногоОтпуска.ВидЕжегодногоОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыЕжегодныхОтпусков.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускаСотрудников.Сотрудник,
	|	ОтпускаСотрудников.ДатаНачала,
	|	ОтпускаСотрудников.ВидОсновногоОтпуска.ВидЕжегодногоОтпуска,
	|	ОтпускаСотрудников.РегистраторНачалаОтпуска,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|				ИЛИ ОтпускаСотрудников.ДатаОкончания < ОтпускаСотрудников.ДатаНачалаДоп
	|			ТОГДА ОтпускаСотрудников.ДатаОкончания
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.КорректироватьОтпуск
	|				И ОтпускаСотрудников.НоваяДатаОкончания < ВЫБОР
	|					КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|							ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|						ТОГДА ОтпускаСотрудников.ДатаОкончания
	|					ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|				КОНЕЦ
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.НоваяДатаОкончания < ВЫБОР
	|				КОГДА ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1)
	|						ИЛИ ОтпускаСотрудников.ВидДополнительногоОтпуска = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|					ТОГДА ОтпускаСотрудников.ДатаОкончания
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ОтпускаСотрудников.ДатаНачалаДоп, СЕКУНДА, -1)
	|			КОНЕЦ
	|			ТОГДА ОтпускаСотрудников.НоваяДатаОкончания
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтпускаСотрудников.Сотрудник,
	|	ОтпускаСотрудников.ДатаНачалаДоп,
	|	ОтпускаСотрудников.ДатаОкончания,
	|	ОтпускаСотрудников.ВидДополнительногоОтпуска.ВидЕжегодногоОтпуска,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.КорректироватьОтпуск
	|				И ОтпускаСотрудников.НоваяДатаОкончания < ОтпускаСотрудников.ДатаОкончания
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.НоваяДатаОкончания < ОтпускаСотрудников.ДатаОкончания
	|			ТОГДА ОтпускаСотрудников.НоваяДатаОкончания
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ,
	|	СУММА(ВЫБОР
	|			КОГДА ОтпускаСотрудников.ВидДополнительногоОтпуска.ВидЕжегодногоОтпуска.СпособРасчетаОстаткаОтпуска = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОстаткаОтпуска.ПоРабочимДням)
	|				ТОГДА ЕСТЬNULL(ПроизводственныйКалендарь.Шестидневка, 0)
	|			ИНАЧЕ ЕСТЬNULL(ПроизводственныйКалендарь.КалендарныеДни, 0)
	|		КОНЕЦ),
	|	ОтпускаСотрудников.РегистраторНачалаОтпуска
	|ИЗ
	|	ВТ_ОтпускаСотрудников КАК ОтпускаСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК ПроизводственныйКалендарь
	|		ПО (ПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ ОтпускаСотрудников.ДатаНачалаДоп И ОтпускаСотрудников.ДатаОкончания)
	|ГДЕ
	|	(НЕ ОтпускаСотрудников.ВидДополнительногоОтпуска.ВидЕжегодногоОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыЕжегодныхОтпусков.ПустаяСсылка))
	|	И (НЕ ОтпускаСотрудников.ДатаНачалаДоп = ДАТАВРЕМЯ(1, 1, 1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускаСотрудников.Сотрудник,
	|	ОтпускаСотрудников.ДатаНачалаДоп,
	|	ОтпускаСотрудников.ДатаОкончания,
	|	ОтпускаСотрудников.ВидДополнительногоОтпуска.ВидЕжегодногоОтпуска,
	|	ОтпускаСотрудников.РегистраторНачалаОтпуска,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.КорректироватьОтпуск
	|				И ОтпускаСотрудников.НоваяДатаОкончания < ОтпускаСотрудников.ДатаОкончания
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ОтпускаСотрудников.НоваяДатаОкончания < ОтпускаСотрудников.ДатаОкончания
	|			ТОГДА ОтпускаСотрудников.НоваяДатаОкончания
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаНачала,
	|	ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СостояниеРаботниковОрганизаций.Регистратор.Дата КАК ДатаРегистрации
	|ПОМЕСТИТЬ ВТ_ДатаРегистрации
	|ИЗ
	|	РегистрСведений.СостояниеРаботниковОрганизаций КАК СостояниеРаботниковОрганизаций
	|ГДЕ
	|	СостояниеРаботниковОрганизаций.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Отпуска.Сотрудник КАК Сотрудник,
	|	Отпуска.ВидЕжегодногоОтпуска,
	|	ВЫБОР
	|		КОГДА Отпуска.КорректироватьОтпуск
	|			ТОГДА Отпуска.ДатаНачала
	|		ИНАЧЕ Отпуска.ДатаНачала
	|	КОНЕЦ КАК ДатаНачала,
	|	Отпуска.ДатаОкончания,
	|	ВЫБОР
	|		КОГДА Отпуска.КорректироватьОтпуск
	|			ТОГДА Отпуска.НовоеКоличествоКадровыхДнейОтпуска - Отпуска.КадровыхДнейОтпуска
	|		ИНАЧЕ Отпуска.КадровыхДнейОтпуска - Отпуска.РасчетныхДнейОтпуска
	|	КОНЕЦ КАК ДнейОтпуска,
	|	ВТ_ДатаРегистрации.ДатаРегистрации
	|ИЗ
	|	(ВЫБРАТЬ
	|		КадровыеОтпуска.Сотрудник КАК Сотрудник,
	|		КадровыеОтпуска.ВидЕжегодногоОтпуска КАК ВидЕжегодногоОтпуска,
	|		КадровыеОтпуска.ДатаНачала КАК ДатаНачала,
	|		КадровыеОтпуска.ДатаОкончания КАК ДатаОкончания,
	|		СУММА(ЕСТЬNULL(ФактическиеОтпускаОрганизаций.Количество, 0)) КАК РасчетныхДнейОтпуска,
	|		КадровыеОтпуска.ДнейОтпуска КАК КадровыхДнейОтпуска,
	|		КадровыеОтпуска.НовоеКоличествоДнейОтпуска КАК НовоеКоличествоКадровыхДнейОтпуска,
	|		КадровыеОтпуска.КорректироватьОтпуск КАК КорректироватьОтпуск
	|	ИЗ
	|		(ВЫБРАТЬ
	|			КадровыеОтпуска.Сотрудник КАК Сотрудник,
	|			КадровыеОтпуска.ВидЕжегодногоОтпуска КАК ВидЕжегодногоОтпуска,
	|			ВЫБОР
	|				КОГДА КадровыеОтпуска.КорректироватьОтпуск
	|					ТОГДА ДОБАВИТЬКДАТЕ(КадровыеОтпуска.НоваяДатаОкончания, СЕКУНДА, 1)
	|				ИНАЧЕ КадровыеОтпуска.ДатаНачала
	|			КОНЕЦ КАК ДатаНачала,
	|			КадровыеОтпуска.ДатаОкончания КАК ДатаОкончания,
	|			КадровыеОтпуска.ДнейОтпуска КАК ДнейОтпуска,
	|			КадровыеОтпуска.КорректироватьОтпуск КАК КорректироватьОтпуск,
	|			СУММА(ВЫБОР
	|					КОГДА КадровыеОтпуска.ВидЕжегодногоОтпуска.СпособРасчетаОстаткаОтпуска = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОстаткаОтпуска.ПоРабочимДням)
	|						ТОГДА ЕСТЬNULL(ПроизводственныйКалендарьКорректировка.Шестидневка, 0)
	|					ИНАЧЕ ЕСТЬNULL(ПроизводственныйКалендарьКорректировка.КалендарныеДни, 0)
	|				КОНЕЦ) КАК НовоеКоличествоДнейОтпуска,
	|			КадровыеОтпуска.РегистраторНачалаОтпуска КАК РегистраторНачалаОтпуска
	|		ИЗ
	|			ВТ_КадровыеОтпуска КАК КадровыеОтпуска
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК ПроизводственныйКалендарьКорректировка
	|				ПО (ПроизводственныйКалендарьКорректировка.ДатаКалендаря МЕЖДУ КадровыеОтпуска.ДатаНачала И КадровыеОтпуска.НоваяДатаОкончания)
	|					И (КадровыеОтпуска.КорректироватьОтпуск)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			КадровыеОтпуска.Сотрудник,
	|			КадровыеОтпуска.ВидЕжегодногоОтпуска,
	|			КадровыеОтпуска.ДатаОкончания,
	|			КадровыеОтпуска.КорректироватьОтпуск,
	|			КадровыеОтпуска.ДнейОтпуска,
	|			КадровыеОтпуска.РегистраторНачалаОтпуска,
	|			ВЫБОР
	|				КОГДА КадровыеОтпуска.КорректироватьОтпуск
	|					ТОГДА ДОБАВИТЬКДАТЕ(КадровыеОтпуска.НоваяДатаОкончания, СЕКУНДА, 1)
	|				ИНАЧЕ КадровыеОтпуска.ДатаНачала
	|			КОНЕЦ) КАК КадровыеОтпуска
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ФактическиеОтпускаОрганизаций КАК ФактическиеОтпускаОрганизаций
	|			ПО КадровыеОтпуска.Сотрудник = ФактическиеОтпускаОрганизаций.Сотрудник
	|				И КадровыеОтпуска.ВидЕжегодногоОтпуска = ФактическиеОтпускаОрганизаций.ВидЕжегодногоОтпуска
	|				И (ФактическиеОтпускаОрганизаций.Период МЕЖДУ КадровыеОтпуска.ДатаНачала И КадровыеОтпуска.ДатаОкончания
	|					ИЛИ ФактическиеОтпускаОрганизаций.ДатаОкончания МЕЖДУ КадровыеОтпуска.ДатаНачала И КадровыеОтпуска.ДатаОкончания
	|					ИЛИ КадровыеОтпуска.ДатаНачала МЕЖДУ ФактическиеОтпускаОрганизаций.Период И ФактическиеОтпускаОрганизаций.ДатаОкончания
	|					ИЛИ КадровыеОтпуска.ДатаОкончания МЕЖДУ ФактическиеОтпускаОрганизаций.Период И ФактическиеОтпускаОрганизаций.ДатаОкончания)
	|				И (ФактическиеОтпускаОрганизаций.Регистратор <> &Регистратор)
	|				И КадровыеОтпуска.РегистраторНачалаОтпуска <> ФактическиеОтпускаОрганизаций.Регистратор
	|				И КадровыеОтпуска.РегистраторНачалаОтпуска.Дата > ФактическиеОтпускаОрганизаций.ДатаРегистрации
	|	
	|	СГРУППИРОВАТЬ ПО
	|		КадровыеОтпуска.Сотрудник,
	|		КадровыеОтпуска.ВидЕжегодногоОтпуска,
	|		КадровыеОтпуска.ДатаНачала,
	|		КадровыеОтпуска.ДатаОкончания,
	|		КадровыеОтпуска.ДнейОтпуска,
	|		КадровыеОтпуска.НовоеКоличествоДнейОтпуска,
	|		КадровыеОтпуска.КорректироватьОтпуск) КАК Отпуска,
	|	ВТ_ДатаРегистрации КАК ВТ_ДатаРегистрации
	|ГДЕ
	|	ВЫБОР
	|			КОГДА Отпуска.КорректироватьОтпуск
	|				ТОГДА Отпуска.НовоеКоличествоКадровыхДнейОтпуска - Отпуска.КадровыхДнейОтпуска <> 0
	|			ИНАЧЕ Отпуска.КадровыхДнейОтпуска - Отпуска.РасчетныхДнейОтпуска <> 0
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	ДатаНачала";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыНакопления.ФактическиеОтпускаОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
	Пока Выборка.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();
		
		// Свойства
		Движение.Период							= Выборка.ДатаНачала;
		
		// Измерения
		Движение.Сотрудник						= Выборка.Сотрудник;
		Движение.ВидЕжегодногоОтпуска			= Выборка.ВидЕжегодногоОтпуска;
		
		// Ресурсы
		Движение.Количество						= Выборка.ДнейОтпуска;
		
		// Реквизиты
		Движение.ДатаОкончания					= Выборка.ДатаОкончания;
		Движение.ДатаРегистрации				= Выборка.ДатаРегистрации;
	КонецЦикла;
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
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

///////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВыполнятьСписаниеФактическогоОтпуска	= Ложь;
