Перем мУдалятьДвижения;

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
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ttk_ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура УстановитьСубконтоПроводки(Куда, Счет, ВидСубконто, Значение)

	Если Счет.ВидыСубконто.Найти(ВидСубконто, "ВидСубконто") <> Неопределено Тогда
		Куда[ВидСубконто] = Значение;
	КонецЕсли;

КонецПроцедуры


Функция СформироватьТаблицуПериодов()
	
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("НомерМесяца",Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	ТаблицаПериодов.Колонки.Добавить("Месяц",Новый ОписаниеТипов("Дата"));
	ТекДата = '19970101';
	ТекДата = НачалоМесяца(ТекДата);
	Ограничение = НачалоМесяца(ТекущаяДата());
	НомерМесяца = 1;
	Пока НачалоМесяца(ТекДата)<=Ограничение Цикл
		
		НоваяЗапись = ТаблицаПериодов.Добавить();
		НоваяЗапись.НомерМесяца = НомерМесяца;
		НоваяЗапись.Месяц = ТекДата;
		ТекДата = ДобавитьМесяц(ТекДата,1);
		НомерМесяца = НомерМесяца+1;
		
	КонецЦикла;	
	
	Возврат ТаблицаПериодов;
	
КонецФункции

Функция ПолучитьВыборкуДанныхРасчета()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",      Ссылка);
	Запрос.УстановитьПараметр("Период",      КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетнаяПолитикаМеждународныйУчетСрезПоследних.МетодОценкиОсновныхСредств КАК МетодОценкиОсновныхСредств
	|ПОМЕСТИТЬ УчетнаяПолитика
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаМеждународныйУчет.СрезПоследних(&Период, Организация = &Организация) КАК УчетнаяПолитикаМеждународныйУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АмортизацияОСМеждународныйОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство,
	|	АмортизацияОСМеждународныйОсновныеСредства.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	АмортизацияОСМеждународныйОсновныеСредства.КоличествоВыпущеннойПродукции КАК КоличествоВыпущеннойПродукции
	|ПОМЕСТИТЬ СведенияДокумента
	|ИЗ
	|	Документ.абс_АмортизацияОСМеждународныйРЖД.ОсновныеСредства КАК АмортизацияОСМеждународныйОсновныеСредства
	|ГДЕ
	|	АмортизацияОСМеждународныйОсновныеСредства.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ДатаПринятияКУчету КАК ДатаПринятияКУчету,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СчетУчета КАК СчетУчета,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СчетЗатрат КАК СчетЗатрат,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СчетСниженияСтоимости КАК СчетСниженияСтоимости,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.КоэффициентУскорения КАК КоэффициентУскорения,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ПредполагаемыйОбъемПродукции КАК ПредполагаемыйОбъемПродукции,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СправедливаяСтоимость КАК СправедливаяСтоимость,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.МестонахождениеОбъекта КАК МестонахождениеОбъекта,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.МОЛ КАК МОЛ,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.СуммаНачисленнойАмортизации КАК СуммаНачисленнойАмортизации,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.Состояние КАК Состояние,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.Субконто1 КАК Субконто1,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.Субконто2 КАК Субконто2,
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ СведенияИнформационнойБазы
	|ИЗ
	|	РегистрСведений.абс_ОсновныеСредстваРЖД.СрезПоследних(
	|			&Период,
	|			ОсновноеСредство В
	|				(ВЫБРАТЬ
	|					СведенияДокумента.ОсновноеСредство
	|				ИЗ
	|					СведенияДокумента)) КАК ОсновныеСредстваМеждународныйУчетСрезПоследних
	|ГДЕ
	|	ОсновныеСредстваМеждународныйУчетСрезПоследних.НачислятьАмортизацию = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияДокумента.ОсновноеСредство,
	|	СведенияДокумента.МетодНачисленияАмортизации,
	|	СведенияДокумента.КоличествоВыпущеннойПродукции,
	|	СведенияИнформационнойБазы.ОсновноеСредство КАК ОсновноеСредство1,
	|	СведенияИнформационнойБазы.ДатаПринятияКУчету,
	|	СведенияИнформационнойБазы.СрокПолезногоИспользования,
	|	СведенияИнформационнойБазы.СчетУчета,
	|	СведенияИнформационнойБазы.СчетЗатрат,
	|	СведенияИнформационнойБазы.СчетНачисленияАмортизации,
	|	СведенияИнформационнойБазы.СчетСниженияСтоимости,
	|	СведенияИнформационнойБазы.ЛиквидационнаяСтоимость,
	|	СведенияИнформационнойБазы.КоэффициентУскорения,
	|	СведенияИнформационнойБазы.ПредполагаемыйОбъемПродукции,
	|	СведенияИнформационнойБазы.ПервоначальнаяСтоимость,
	|	СведенияИнформационнойБазы.СправедливаяСтоимость,
	|	СведенияИнформационнойБазы.МестонахождениеОбъекта,
	|	СведенияИнформационнойБазы.МОЛ,
	|	СведенияИнформационнойБазы.НачислятьАмортизацию,
	|	СведенияИнформационнойБазы.СуммаНачисленнойАмортизации,
	|	СведенияИнформационнойБазы.Состояние,
	|	СведенияИнформационнойБазы.Субконто1,
	|	СведенияИнформационнойБазы.Субконто2,
	|	СведенияИнформационнойБазы.Субконто3
	|ПОМЕСТИТЬ СведенияОС
	|ИЗ
	|	СведенияДокумента КАК СведенияДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СведенияИнформационнойБазы КАК СведенияИнформационнойБазы
	|		ПО СведенияДокумента.ОсновноеСредство = СведенияИнформационнойБазы.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОС.СчетУчета КАК Счет
	|ПОМЕСТИТЬ СчетаУчетаОС
	|ИЗ
	|	СведенияОС КАК СведенияОС
	|ГДЕ
	|	СведенияОС.МетодНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СведенияОС.СчетНачисленияАмортизации
	|ИЗ
	|	СведенияОС КАК СведенияОС
	|ГДЕ
	|	СведенияОС.МетодНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОС.СчетСниженияСтоимости
	|ИЗ
	|	СведенияОС КАК СведенияОС
	|ГДЕ
	|	СведенияОС.МетодНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МеждународныйОстатки.Субконто1 КАК ОсновноеСредство,
	|	МеждународныйОстатки.Счет КАК Счет,
	|	МеждународныйОстатки.СуммаОстатокДт КАК СуммаОстатокДт,
	|	МеждународныйОстатки.СуммаОстатокКт КАК СуммаОстатокКт
	|ПОМЕСТИТЬ ОстаткиПоСчетамОС
	|ИЗ
	|	РегистрБухгалтерии.абс_МеждународныйОСРЖД.Остатки(
	|			&Период,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					СчетаУчетаОС.Счет
	|				ИЗ
	|					СчетаУчетаОС),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						СведенияОС.ОсновноеСредство
	|					ИЗ
	|						СведенияОС
	|					ГДЕ
	|						СведенияОС.МетодНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка))) КАК МеждународныйОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаУчетаОССрезПоследних.ОсновноеСредство,
	|	СчетаУчетаОССрезПоследних.Период,
	|	ОсновныеСредстваМеждународныйУчет.СчетУчета,
	|	ОсновныеСредстваМеждународныйУчет.СчетНачисленияАмортизации,
	|	ОсновныеСредстваМеждународныйУчет.СчетСниженияСтоимости
	|ПОМЕСТИТЬ СведенияОСМетодУменьшаемогоОстатка
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДатыСнятияОстатков.ОсновноеСредство КАК ОсновноеСредство,
	|		ДатыСнятияОстатков.Период КАК Период,
	|		МАКСИМУМ(ОсновныеСредстваМеждународныйУчет.Период) КАК ПериодСрезаПоследних
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ИзменениеСтоимостиОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
	|			ВЫБОР
	|				КОГДА ИзменениеСтоимостиОССрезПоследних.Период > НАЧАЛОПЕРИОДА(&Период, ГОД)
	|					ТОГДА ИзменениеСтоимостиОССрезПоследних.Период
	|				ИНАЧЕ НАЧАЛОПЕРИОДА(&Период, ГОД)
	|			КОНЕЦ КАК Период
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ИзменениеСтоимостиОССрезПервых.ОсновноеСредство КАК ОсновноеСредство,
	|				МАКСИМУМ(ИзменениеСтоимостиОССрезПервых.Период) КАК Период
	|			ИЗ
	|				(ВЫБРАТЬ
	|					ОсновныеСредстваМеждународныйУчет.ОсновноеСредство КАК ОсновноеСредство,
	|					МИНИМУМ(ОсновныеСредстваМеждународныйУчет.Период) КАК Период
	|				ИЗ
	|					РегистрСведений.абс_ОсновныеСредстваРЖД КАК ОсновныеСредстваМеждународныйУчет
	|				ГДЕ
	|					ОсновныеСредстваМеждународныйУчет.ОсновноеСредство В
	|							(ВЫБРАТЬ
	|								СведенияОС.ОсновноеСредство
	|							ИЗ
	|								СведенияОС
	|							ГДЕ
	|								СведенияОС.МетодНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка))
	|					И ОсновныеСредстваМеждународныйУчет.Период <= &Период
	|				
	|				СГРУППИРОВАТЬ ПО
	|					ОсновныеСредстваМеждународныйУчет.ОсновноеСредство,
	|					ОсновныеСредстваМеждународныйУчет.ПервоначальнаяСтоимость,
	|					ОсновныеСредстваМеждународныйУчет.СправедливаяСтоимость) КАК ИзменениеСтоимостиОССрезПервых
	|			
	|			СГРУППИРОВАТЬ ПО
	|				ИзменениеСтоимостиОССрезПервых.ОсновноеСредство) КАК ИзменениеСтоимостиОССрезПоследних) КАК ДатыСнятияОстатков
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.абс_ОсновныеСредстваРЖД КАК ОсновныеСредстваМеждународныйУчет
	|			ПО ДатыСнятияОстатков.ОсновноеСредство = ОсновныеСредстваМеждународныйУчет.ОсновноеСредство
	|				И ДатыСнятияОстатков.Период >= ОсновныеСредстваМеждународныйУчет.Период
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДатыСнятияОстатков.ОсновноеСредство,
	|		ДатыСнятияОстатков.Период) КАК СчетаУчетаОССрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.абс_ОсновныеСредстваРЖД КАК ОсновныеСредстваМеждународныйУчет
	|		ПО СчетаУчетаОССрезПоследних.ОсновноеСредство = ОсновныеСредстваМеждународныйУчет.ОсновноеСредство
	|			И СчетаУчетаОССрезПоследних.ПериодСрезаПоследних = ОсновныеСредстваМеждународныйУчет.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОСМетодУменьшаемогоОстатка.СчетУчета КАК Счет
	|ПОМЕСТИТЬ СчетаУчетаОСМетодУменьшаемогоОстатка
	|ИЗ
	|	СведенияОСМетодУменьшаемогоОстатка КАК СведенияОСМетодУменьшаемогоОстатка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СведенияОСМетодУменьшаемогоОстатка.СчетНачисленияАмортизации
	|ИЗ
	|	СведенияОСМетодУменьшаемогоОстатка КАК СведенияОСМетодУменьшаемогоОстатка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СведенияОСМетодУменьшаемогоОстатка.СчетСниженияСтоимости
	|ИЗ
	|	СведенияОСМетодУменьшаемогоОстатка КАК СведенияОСМетодУменьшаемогоОстатка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МеждународныйОстаткиИОбороты.Субконто1 КАК ОсновноеСредство,
	|	МеждународныйОстаткиИОбороты.Счет КАК Счет,
	|	МеждународныйОстаткиИОбороты.Период КАК Период,
	|	МеждународныйОстаткиИОбороты.СуммаКонечныйОстатокДт КАК СуммаОстатокДт,
	|	МеждународныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК СуммаОстатокКт
	|ПОМЕСТИТЬ ДвиженияПоСчетамОС
	|ИЗ
	|	РегистрБухгалтерии.абс_МеждународныйОСРЖД.ОстаткиИОбороты(
	|			НАЧАЛОПЕРИОДА(&Период, ГОД),
	|			&Период,
	|			Запись,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					СчетаУчетаОСМетодУменьшаемогоОстатка.Счет
	|				ИЗ
	|					СчетаУчетаОСМетодУменьшаемогоОстатка),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						СведенияОС.ОсновноеСредство
	|					ИЗ
	|						СведенияОС
	|					ГДЕ
	|						СведенияОС.МетодНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка))) КАК МеждународныйОстаткиИОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияПоСчетамОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
	|	ДвиженияПоСчетамОССрезПоследних.Счет КАК Счет,
	|	ДвиженияПоСчетамОС.СуммаОстатокДт КАК СуммаОстатокДт,
	|	ДвиженияПоСчетамОС.СуммаОстатокКт КАК СуммаОстатокКт
	|ПОМЕСТИТЬ ОстаткиПоСчетамОСУменьшаемогоОстатка
	|ИЗ
	|	(ВЫБРАТЬ
	|		СведенияОСМетодУменьшаемогоОстатка.ОсновноеСредство КАК ОсновноеСредство,
	|		ДвиженияПоСчетамОС.Счет КАК Счет,
	|		МАКСИМУМ(ДвиженияПоСчетамОС.Период) КАК Период
	|	ИЗ
	|		СведенияОСМетодУменьшаемогоОстатка КАК СведенияОСМетодУменьшаемогоОстатка
	|			ЛЕВОЕ СОЕДИНЕНИЕ ДвиженияПоСчетамОС КАК ДвиженияПоСчетамОС
	|			ПО СведенияОСМетодУменьшаемогоОстатка.Период >= ДвиженияПоСчетамОС.Период
	|				И СведенияОСМетодУменьшаемогоОстатка.ОсновноеСредство = ДвиженияПоСчетамОС.ОсновноеСредство
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СведенияОСМетодУменьшаемогоОстатка.ОсновноеСредство,
	|		ДвиженияПоСчетамОС.Счет) КАК ДвиженияПоСчетамОССрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДвиженияПоСчетамОС КАК ДвиженияПоСчетамОС
	|		ПО ДвиженияПоСчетамОССрезПоследних.Период = ДвиженияПоСчетамОС.Период
	|			И ДвиженияПоСчетамОССрезПоследних.ОсновноеСредство = ДвиженияПоСчетамОС.ОсновноеСредство
	|			И ДвиженияПоСчетамОССрезПоследних.Счет = ДвиженияПоСчетамОС.Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОС.ОсновноеСредство КАК ОсновноеСредство,
	|	СведенияОС.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	СведенияОС.КоличествоВыпущеннойПродукции КАК КоличествоВыпущеннойПродукции,
	|	СведенияОС.ДатаПринятияКУчету КАК ДатаПринятияКУчету,
	|	СведенияОС.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
	|	СведенияОС.СчетУчета КАК СчетУчета,
	|	СведенияОС.СчетЗатрат КАК СчетЗатрат,
	|	СведенияОС.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации,
	|	СведенияОС.СчетСниженияСтоимости КАК СчетСниженияСтоимости,
	|	ВЫБОР
	|		КОГДА СведенияОС.ЛиквидационнаяСтоимость = 0
	|			ТОГДА ВЫБОР
	|					КОГДА &Период < &Год2017
	|						ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(ГруппыОСРЖД.ПроцентЛиквидационнойСтоимости, 0) * СведенияОС.ПервоначальнаяСтоимость / 100 КАК ЧИСЛО(15, 2))
	|					ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СоответствиеОКОФАмортизационнаяГруппа.ПроцентЛиквидационнойСтоимости, 0) * СведенияОС.ПервоначальнаяСтоимость / 100 КАК ЧИСЛО(15, 2))
	|				КОНЕЦ
	|		ИНАЧЕ СведенияОС.ЛиквидационнаяСтоимость
	|	КОНЕЦ КАК ЛиквидационнаяСтоимость,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(&ДатаРасчета, МЕСЯЦ), ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(СведенияОС.ДатаПринятияКУчету, МЕСЯЦ), МЕСЯЦ, СведенияОС.СрокПолезногоИспользования + 1), МЕСЯЦ) КАК ОставшеесяЧислоМесяцев,
	|	СведенияОС.КоэффициентУскорения КАК КоэффициентУскорения,
	|	СведенияОС.ПредполагаемыйОбъемПродукции КАК ПредполагаемыйОбъемПродукции,
	|	СведенияОС.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	СведенияОС.СправедливаяСтоимость КАК СправедливаяСтоимость,
	|	СведенияОС.МестонахождениеОбъекта КАК МестонахождениеОбъекта,
	|	СведенияОС.МОЛ КАК МОЛ,
	|	СведенияОС.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|	СведенияОС.СуммаНачисленнойАмортизации КАК СуммаНачисленнойАмортизации,
	|	СведенияОС.Состояние КАК Состояние,
	|	СведенияОС.Субконто1 КАК Субконто1,
	|	СведенияОС.Субконто2 КАК Субконто2,
	|	СведенияОС.Субконто3 КАК Субконто3,
	|	ЕСТЬNULL(СтоимостьОС.СуммаОстатокДт, 0) - ЕСТЬNULL(АмортизацияОС.СуммаОстатокКт, 0) - ЕСТЬNULL(СнижениеСтоимостиОС.СуммаОстатокКт, 0) КАК ОстаточнаяСтоимость,
	|	УчетнаяПолитика.МетодОценкиОсновныхСредств КАК МетодОценкиОсновныхСредств,
	|	0 КАК Месяц
	|ИЗ
	|	СведенияОС КАК СведенияОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОС КАК СтоимостьОС
	|		ПО СведенияОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство
	|			И СведенияОС.СчетУчета = СтоимостьОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОС КАК АмортизацияОС
	|		ПО СведенияОС.ОсновноеСредство = АмортизацияОС.ОсновноеСредство
	|			И СведенияОС.СчетНачисленияАмортизации = АмортизацияОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОС КАК СнижениеСтоимостиОС
	|		ПО СведенияОС.ОсновноеСредство = СнижениеСтоимостиОС.ОсновноеСредство
	|			И СведенияОС.СчетСниженияСтоимости = СнижениеСтоимостиОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.абс_СоответствиеОКОФГруппОСРЖД КАК ГруппыОСРЖД
	|		ПО СведенияОС.ОсновноеСредство.КодПоОКОФ = ГруппыОСРЖД.ОКОФ
	|			И СведенияОС.ОсновноеСредство.абс_ГруппаОСРЖД = ГруппыОСРЖД.ГруппаОСРЖД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ttk_СоответствиеОКОФАмортизационнаяГруппа.СрезПоследних(&Период, ) КАК СоответствиеОКОФАмортизационнаяГруппа
	|		ПО СведенияОС.ОсновноеСредство.КодПоОКОФ = СоответствиеОКОФАмортизационнаяГруппа.ОКОФ
	|			И СведенияОС.ОсновноеСредство.АмортизационнаяГруппа = СоответствиеОКОФАмортизационнаяГруппа.АмортизационнаяГруппа,
	|	УчетнаяПолитика КАК УчетнаяПолитика
	|ГДЕ
	|	СведенияОС.МетодНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СведенияОС.ОсновноеСредство,
	|	СведенияОС.МетодНачисленияАмортизации,
	|	СведенияОС.КоличествоВыпущеннойПродукции,
	|	СведенияОС.ДатаПринятияКУчету,
	|	СведенияОС.СрокПолезногоИспользования,
	|	СведенияОС.СчетУчета,
	|	СведенияОС.СчетЗатрат,
	|	СведенияОС.СчетНачисленияАмортизации,
	|	СведенияОС.СчетСниженияСтоимости,
	|	ВЫБОР
	|		КОГДА СведенияОС.ЛиквидационнаяСтоимость = 0
	|			ТОГДА ВЫБОР
	|					КОГДА &Период < &Год2017
	|						ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(ГруппыОСРЖД.ПроцентЛиквидационнойСтоимости, 0) * СведенияОС.ПервоначальнаяСтоимость / 100 КАК ЧИСЛО(15, 2))
	|					ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СоответствиеОКОФАмортизационнаяГруппа.ПроцентЛиквидационнойСтоимости, 0) * СведенияОС.ПервоначальнаяСтоимость / 100 КАК ЧИСЛО(15, 2))
	|				КОНЕЦ
	|		ИНАЧЕ СведенияОС.ЛиквидационнаяСтоимость
	|	КОНЕЦ,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(СведенияОС.ДатаПринятияКУчету, МЕСЯЦ), НАЧАЛОПЕРИОДА(&ДатаРасчета, МЕСЯЦ), МЕСЯЦ),
	|	СведенияОС.КоэффициентУскорения,
	|	СведенияОС.ПредполагаемыйОбъемПродукции,
	|	СведенияОС.ПервоначальнаяСтоимость,
	|	СведенияОС.СправедливаяСтоимость,
	|	СведенияОС.МестонахождениеОбъекта,
	|	СведенияОС.МОЛ,
	|	СведенияОС.НачислятьАмортизацию,
	|	СведенияОС.СуммаНачисленнойАмортизации,
	|	СведенияОС.Состояние,
	|	СведенияОС.Субконто1,
	|	СведенияОС.Субконто2,
	|	СведенияОС.Субконто3,
	|	ЕСТЬNULL(СтоимостьОС.СуммаОстатокДт, 0) - ЕСТЬNULL(АмортизацияОС.СуммаОстатокКт, 0) - ЕСТЬNULL(СнижениеСтоимостиОС.СуммаОстатокКт, 0),
	|	УчетнаяПолитика.МетодОценкиОсновныхСредств,
	|	МЕСЯЦ(СведенияОСМетодУменьшаемогоОстатка.Период)
	|ИЗ
	|	СведенияОС КАК СведенияОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОСУменьшаемогоОстатка КАК СтоимостьОС
	|		ПО СведенияОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство
	|			И СведенияОС.СчетУчета = СтоимостьОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОСУменьшаемогоОстатка КАК АмортизацияОС
	|		ПО СведенияОС.ОсновноеСредство = АмортизацияОС.ОсновноеСредство
	|			И СведенияОС.СчетНачисленияАмортизации = АмортизацияОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоСчетамОСУменьшаемогоОстатка КАК СнижениеСтоимостиОС
	|		ПО СведенияОС.ОсновноеСредство = СнижениеСтоимостиОС.ОсновноеСредство
	|			И СведенияОС.СчетСниженияСтоимости = СнижениеСтоимостиОС.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ СведенияОСМетодУменьшаемогоОстатка КАК СведенияОСМетодУменьшаемогоОстатка
	|		ПО СведенияОС.ОсновноеСредство = СведенияОСМетодУменьшаемогоОстатка.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.абс_СоответствиеОКОФГруппОСРЖД КАК ГруппыОСРЖД
	|		ПО СведенияОС.ОсновноеСредство.КодПоОКОФ = ГруппыОСРЖД.ОКОФ
	|			И СведенияОС.ОсновноеСредство.абс_ГруппаОСРЖД = ГруппыОСРЖД.ГруппаОСРЖД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ttk_СоответствиеОКОФАмортизационнаяГруппа.СрезПоследних(&Период, ) КАК СоответствиеОКОФАмортизационнаяГруппа
	|		ПО СведенияОС.ОсновноеСредство.КодПоОКОФ = СоответствиеОКОФАмортизационнаяГруппа.ОКОФ
	|			И СведенияОС.ОсновноеСредство.АмортизационнаяГруппа = СоответствиеОКОФАмортизационнаяГруппа.АмортизационнаяГруппа,
	|	УчетнаяПолитика КАК УчетнаяПолитика
	|ГДЕ
	|	СведенияОС.МетодНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка)";
	
	Запрос.УстановитьПараметр("ДатаРасчета", ПериодРегистрации);
	//+ Романова Н.Г. #7794034 С 2017 года новый мэппинг по ОС МСФО	
	Запрос.УстановитьПараметр("Год2017", Дата(2017,1,1));
	//-
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции



Процедура ОбработкаПроведения(Отказ, Режим)
	
	//мТаблицаПериодов = СформироватьТаблицуПериодов();
	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ВыборкаОС = ПолучитьВыборкуДанныхРасчета();
	
	Счета = ПланыСчетов.абс_МеждународныйОСРЖД;
	
	// рассчитываем сальдо по резерву переоценки - для списания пропрционально амортизации
	БухИтогиР = Обработки.БухгалтерскиеИтоги.Создать();
	Резервы = Справочники.ВидыФинРезервов.РезервыНаПереоценку;
	МассивСубконто = Новый Массив();
	МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
	МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Резервы);
	СчетРезервыНаПереоценку = ПланыСчетов.абс_МеждународныйОСРЖД.Служебный;
	БухИтогиР.РассчитатьИтоги("абс_МеждународныйОСРЖД", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет, Субконто1, Субконто2", Дата, Дата, , ПланыСчетов.абс_МеждународныйОСРЖД.Служебный, МассивСубконто, , , "Организация", Организация);
		    	
	Пока ВыборкаОС.Следующий() Цикл
		
		Сумма                     = 0;
		СчетУчета                 = ВыборкаОС.СчетУчета;
		СчетЗатрат                = ВыборкаОС.СчетЗатрат;
		СчетНачисленияАмортизации = ВыборкаОС.СчетНачисленияАмортизации;
		СчетСниженияСтоимости     = ВыборкаОС.СчетСниженияСтоимости;
		ДатаУстановки             = НачалоМесяца(ВыборкаОС.ДатаПринятияКУчету);
		//ОставшеесяЧислоМесяцев    = ВыборкаОС.СрокПолезногоИспользования - Окр((НачалоМесяца(ПериодРегистрации) - ДатаУстановки) / 60 / 60 / 24 / 30, 0);
		//НомМесяц1 = 0;
		//НомМесяц2 = 0;
		//
		//СтрокаТЧ = мТаблицаПериодов.Найти(НачалоМесяца(ПериодРегистрации),"Месяц");
		//Если СтрокаТЧ<>Неопределено Тогда
		//	НомМесяц2 = СтрокаТЧ.НомерМесяца;
		//	
		//КонецЕсли;
		//СтрокаТЧ = мТаблицаПериодов.Найти(ДатаУстановки,"Месяц");
		//Если СтрокаТЧ<>Неопределено Тогда
		//	НомМесяц1 = СтрокаТЧ.НомерМесяца;
		//	
		//КонецЕсли;
		//ИспользованныйСрок = 0;
		//ИспользованныйСрок = НомМесяц2-НомМесяц1;
		//
		//ОставшеесяЧислоМесяцев    = ВыборкаОС.СрокПолезногоИспользования - ИспользованныйСрок;

		//АБс
		Если ВыборкаОС.ОставшеесяЧислоМесяцев<=0 Тогда
			Сообщить(""+ВыборкаОС.ОсновноеСредство.Код+"; оставшийся срок ;"+ВыборкаОС.ОставшеесяЧислоМесяцев+"; срок использования ;"+ВыборкаОС.СрокПолезногоИспользования);
			Продолжить;
		КонецЕсли;
		
		//АБС
		Если ВыборкаОС.МетодНачисленияАмортизации = Перечисления.МетодыНачисленияАмортизацииОСМеждународный.Линейный Тогда
			
			Сумма = (ВыборкаОС.ОстаточнаяСтоимость - ВыборкаОС.ЛиквидационнаяСтоимость) / ВыборкаОС.ОставшеесяЧислоМесяцев;			
			
		ИначеЕсли ВыборкаОС.МетодНачисленияАмортизации = Перечисления.МетодыНачисленияАмортизацииОСМеждународный.УменьшаемогоОстатка Тогда
			
			Сумма = ВыборкаОС.ОстаточнаяСтоимость * ВыборкаОС.КоэффициентУскорения * 12 / ВыборкаОС.СрокПолезногоИспользования / (12 - ВыборкаОС.Месяц + 1);
					
		ИначеЕсли ВыборкаОС.МетодНачисленияАмортизации = Перечисления.МетодыНачисленияАмортизацииОСМеждународный.ПропорциональноОбъемуПродукции Тогда

			Если ВыборкаОС.ПредполагаемыйОбъемПродукции = 0 Тогда
				
				#Если Клиент Тогда
				Сообщить("По объекту ОС '" + ВыборкаОС.ОсновноеСредство + "' амортизация не начислена:");
				Сообщить("	в регистре сведений не указан предполагаемый объем продукции");
				#КонецЕсли
				
			ИначеЕсли ВыборкаОС.КоличествоВыпущеннойПродукции >	ВыборкаОС.ПредполагаемыйОбъемПродукции Тогда
				
				#Если Клиент Тогда
				Сообщить("По объекту ОС '" + ВыборкаОС.ОсновноеСредство + "' амортизация не начислена:");
				Сообщить("	в регистре сведений указан предполагаемый объем продукции " + ВыборкаОС.ПредполагаемыйОбъемПродукции + ", в документе - больше: " + ВыборкаОС.КоличествоВыпущеннойПродукции);
				#КонецЕсли
				
			Иначе
				
				Если ВыборкаОС.МетодОценкиОсновныхСредств = Перечисления.МетодыОценкиАктивов.ПоПервоначальнойСтоимости Тогда
					Сумма = ВыборкаОС.ПервоначальнаяСтоимость * ВыборкаОС.КоличествоВыпущеннойПродукции / ВыборкаОС.ПредполагаемыйОбъемПродукции;
				ИначеЕсли ВыборкаОС.МетодОценкиОсновныхСредств = Перечисления.МетодыОценкиАктивов.ПоСправедливойСтоимости Тогда
					Сумма = ВыборкаОС.СправедливаяСтоимость * ВыборкаОС.КоличествоВыпущеннойПродукции / ВыборкаОС.ПредполагаемыйОбъемПродукции;
				Иначе
				#Если Клиент Тогда
					Сообщить("В учетной политике по международному учету не указан Метод учета основных средств. ОС " + ВыборкаОС.ОсновноеСредство + " не амортизировано.", СтатусСообщения.ОченьВажное);
				#КонецЕсли
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Сумма = Мин (Сумма, ВыборкаОС.ОстаточнаяСтоимость);
		Если (ЗначениеЗаполнено(СчетЗатрат)) 
			и (ЗначениеЗаполнено(СчетНачисленияАмортизации)) 
			и (Сумма <> 0) Тогда
			Движение = Движения.абс_МеждународныйОСРЖД.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.СчетДт = СчетЗатрат;
			Движение.СчетКт = СчетНачисленияАмортизации;
			Движение.Организация = Организация;
			Движение.Сумма = Сумма;
			Движение.Содержание = "Амортизация ОС";
			Движение.НомерЖурнала = "Рег";
			
			СтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка();
			НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
			
			Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
				ЗначениеСубконто = ВыборкаОС["Субконто" + Ном];
				Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ЗначениеСубконто;
				
				Если ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.СтатьиЗатрат") Тогда
					СтатьяЗатрат = ЗначениеСубконто;
				ИначеЕсли ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда
					НоменклатурнаяГруппа = ЗначениеСубконто;
				КонецЕсли;
			КонецЦикла;
			
			Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства,) = Неопределено Тогда
				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства] = ВыборкаОС.ОсновноеСредство;
			КонецЕсли;
			
			//АБС Кряковкин 20150122
			Движения.абс_СтоимостьОСРЖД.Записывать = Истина;
			Движение = Движения.абс_СтоимостьОСРЖД.Добавить();
			Движение.Амортизация = Сумма;
			Движение.Организация = Организация;
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.ОсновноеСредство = ВыборкаОС.ОсновноеСредство;
			Движение.Период = КонецМесяца(ПериодРегистрации);
			//\\Кряковкин
		
			
			// регистр ОсновныеСредстваМеждународныйУчет 
			Движение = Движения.абс_ОсновныеСредстваРЖД.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.ОсновноеСредство = ВыборкаОС.ОсновноеСредство;
			Движение.Организация = Организация;
			Движение.ДатаПринятияКУчету = ВыборкаОС.ДатаПринятияКУчету;
			Движение.МестонахождениеОбъекта = ВыборкаОС.МестонахождениеОбъекта;
			Движение.МОЛ = ВыборкаОС.МОЛ;
			Движение.СчетУчета = ВыборкаОС.СчетУчета;
			Движение.СрокПолезногоИспользования = ВыборкаОС.СрокПолезногоИспользования;
			Движение.НачислятьАмортизацию = ВыборкаОС.НачислятьАмортизацию;
			Движение.МетодНачисленияАмортизации = ВыборкаОС.МетодНачисленияАмортизации;
			Движение.СчетНачисленияАмортизации = ВыборкаОС.СчетНачисленияАмортизации;
			Движение.ПервоначальнаяСтоимость = ВыборкаОС.ПервоначальнаяСтоимость;
			Движение.ЛиквидационнаяСтоимость = ВыборкаОС.ЛиквидационнаяСтоимость;
			Движение.СчетЗатрат = ВыборкаОС.СчетЗатрат;
			Движение.Субконто1 = ВыборкаОС.Субконто1;
			Движение.Субконто2 = ВыборкаОС.Субконто2;
			Движение.Субконто3 = ВыборкаОС.Субконто3;
			Движение.ПредполагаемыйОбъемПродукции = ВыборкаОС.ПредполагаемыйОбъемПродукции;
			Движение.СуммаНачисленнойАмортизации = ВыборкаОС.СуммаНачисленнойАмортизации + Сумма;
			Движение.СправедливаяСтоимость = ВыборкаОС.СправедливаяСтоимость;
			Движение.Состояние = ВыборкаОС.Состояние;
			Движение.СчетСниженияСтоимости = ВыборкаОС.СчетСниженияСтоимости;
			Движение.КоэффициентУскорения = ВыборкаОС.КоэффициентУскорения;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

