#Если Клиент Тогда
	
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
	 УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	
	УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	 УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Ложь;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	абс_СтрокиАБФРЖД.Ссылка КАК СтрокиАБФ,
	|	абс_СтрокиАБФРЖД.Владелец КАК ФормаАБФ,
	|	абс_ЗначенияПоказателейСтрокАБФОбороты.СуммаОборот КАК Сумма,
	|	абс_СтрокиАБФРЖД.Порядок КАК Порядок
	|{ВЫБРАТЬ
	|	СтрокиАБФ.*,
	|	ФормаАБФ.*,
	|	Сумма}
	|ИЗ
	|	Справочник.абс_СтрокиАБФРЖД КАК абс_СтрокиАБФРЖД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.абс_ЗначенияПоказателейСтрокАБФ.Обороты(&ДатаНач, &ДатаКон, , ) КАК абс_ЗначенияПоказателейСтрокАБФОбороты
	|		ПО абс_ЗначенияПоказателейСтрокАБФОбороты.СтрокаФормы = абс_СтрокиАБФРЖД.Ссылка
	|ГДЕ
	|	абс_СтрокиАБФРЖД.Используется
	|{ГДЕ
	|	абс_СтрокиАБФРЖД.Ссылка.* КАК СтрокаАБФ,
	|	абс_СтрокиАБФРЖД.Владелец.* КАК ФормаАБФ}
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок
	|{ИТОГИ ПО
	|	СтрокиАБФ.*}";
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	//
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаСогласования"			, "Дата согласования");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатьяУУ"			, "Статья УУ");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаБУ"			, "Сумма БУ");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУУ"			, "Сумма УУ");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	ВалютаУпр = глЗначениеПеременной("ВалютаУправленческогоУчета");
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	
	УниверсальныйОтчет.ДобавитьПоказатель("Сумма"			, "Сумма "			, Истина	, "ЧЦ=15; ЧДЦ=2");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаНДС"			, "Сумма НДС"			, Истина	, "ЧЦ=15; ЧДЦ=2");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаСНДС"			, "Сумма с НДС"			, Истина	, "ЧЦ=15; ЧДЦ=2");
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СтатьяУУ");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	 УниверсальныйОтчет.ДобавитьОтбор("ФормаАБФ");
	
	
	/// Отбор!!!!
	
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("СтатьяБУ"		, ТипРазмещенияРеквизитовИзмерений.Отдельно, 3);
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	УчетнаяПолитика = ttk_ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиУпр(?(НЕ ЗначениеЗаполнено(УниверсальныйОтчет.ДатаКон), ТекущаяДата(), УниверсальныйОтчет.ДатаКон), Ложь);
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("НеВключатьНДСВСтоимостьПартий", ?(НЕ ЗначениеЗаполнено(УчетнаяПолитика), Ложь, УчетнаяПолитика.НеВключатьНДСВСтоимостьПартий));
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СтатьиЗатрат", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат);
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СценарийФакт", Константы.абс_СценарийДляФакта.Получить());
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаНач", НачалоДня(УниверсальныйОтчет.ДатаКон));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаКон", ?(НЕ ЗначениеЗаполнено(УниверсальныйОтчет.ДатаКон), ТекущаяДата(), КонецДня(УниверсальныйОтчет.ДатаКон)));
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
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли