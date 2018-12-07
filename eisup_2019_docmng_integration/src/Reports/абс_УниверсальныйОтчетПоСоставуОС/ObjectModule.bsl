#Если Клиент Тогда
Перем Таб;	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	УниверсальныйОтчет.ИмяРегистра = "абс_СоставОС";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	//УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	УниверсальныйОтчет.ДобавитьПолеГруппировка("ЕдиницаИзмерения", "Номенклатура", "ЕдиницаХраненияОстатков", "Ед.изм.");

	УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);

	// В универсальном отчете включен флаг использования свойств и категорий.
	//Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
	//	
	//	
	//КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);


	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	////УниверсальныйОтчет.ДобавитьПоказатель("Номер", "Номер п/п", Истина, "ЧЦ=15; ЧДЦ=2", "Объект строительства","Объект строительства");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество (в ед.изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход",           "Приход",            Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество (в ед.изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество (в ед.изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток",  "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество (в ед.изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество (в ед.изм.)");
	 
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ВнеоборотныйАктив");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ХарактеристикаНоменклатуры");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СерияНоменклатуры");

	//МассивДанных = Новый массив;
	//МассивДанных.Добавить("PM");
	//МассивДанных.Добавить("Контрагент");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки(МассивДанных);
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	//УниверсальныйОтчет.ДобавитьОтбор("Проект");

	УниверсальныйОтчет.ДобавитьОтбор("ВнеоборотныйАктив");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	УниверсальныйОтчет.ДобавитьОтбор("ХарактеристикаНоменклатуры");
	УниверсальныйОтчет.ДобавитьОтбор("СерияНоменклатуры");
	
	//УниверсальныйОтчет.ДобавитьОтбор("Наименование");
		//УниверсальныйОтчет.ДобавитьОтбор("Покупатель");
	//УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	//УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	//УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ЕдиницаИзмерения");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
ВидыСубконто = Новый Массив;
ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства);
//ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
ВидыСубконтоНом  = Новый Массив;
Если ВалютаУпр.Пустая() Тогда
	валютаУпр = Справочники.Валюты.НайтиПоКоду("000");
КонецЕсли;

ОбрКурс = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(?(УниверсальныйОтчет.ДатаКон = Дата('00010101'),ТекущаяДата(),УниверсальныйОтчет.ДатаКон),Новый Структура("Валюта", ВалютаУпр)).Курс;
Если ЗначениеЗаполнено(ОбрКурс) Тогда
 	Курс = 1/ОбрКурс;
Иначе
	Курс =1;
КонецЕсли;
    МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовОсновныхСредств);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств);
    ВидыСубконтоНом.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	//УчетнаяПолитика = ttk_ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиУпр(?(НЕ ЗначениеЗаполнено(УниверсальныйОтчет.ДатаКон), ТекущаяДата(), УниверсальныйОтчет.ДатаКон), Ложь);
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("НеВключатьНДСВСтоимостьПартий", ?(НЕ ЗначениеЗаполнено(УчетнаяПолитика), Ложь, УчетнаяПолитика.НеВключатьНДСВСтоимостьПартий));
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СЧет20", ПланыСчетов.Хозрасчетный.ОсновноеПроизводство);
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Нулевой", Справочники.Проекты.НайтиПоКоду("000000015"));
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ВТЗ",Таб);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СЧет90_02",ПланыСчетов.Хозрасчетный.СебестоимостьПродаж);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаНач",УниверсальныйОтчет.ДатаНач);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаКон",КонецДня(УниверсальныйОтчет.ДатаКон));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Ввод",Перечисления.СостоянияОС.ВведеноВЭксплуатацию);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет01",ПланыСчетов.Хозрасчетный.ОСвОрганизации);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет07",ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет0804",ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовОсновныхСредств);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет02НУ",ПланыСчетов.Налоговый.АмортизацияОС_01);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет01НУ",ПланыСчетов.Налоговый.ОСвОрганизации);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СчетКВ",ПланыСчетов.Налоговый.РасходыНаКапитальныеВложения);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет01БУ",ПланыСчетов.Хозрасчетный.ОСвОрганизации);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Счет02БУ",ПланыСчетов.Хозрасчетный.АмортизацияОС_01);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустаяДата",'00010101');	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("МассивСчетов",МассивСчетов);
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент,,, ЭтотОбъект);

КонецПроцедуры // СформироватьОтчет()

Функция ПолучитьТекстСправкиФормы() Экспорт
	
	Возврат "";
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
 УниверсальныйОтчет.мРежимВводаПериода = 0;

#КонецЕсли
