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
	 УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
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
	
	// Описание исходного текста запроса.
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	абс_РезервыПроизведенныхРасходовРезервы.Контрагент,
	|	абс_РезервыПроизведенныхРасходовРезервы.ДоговорКонтрагента,
	|	абс_РезервыПроизведенныхРасходовРезервы.ЗакупочныйЗаказ,
	|	абс_РезервыПроизведенныхРасходовРезервы.БюджетнаяСтатья,
	|	абс_РезервыПроизведенныхРасходовРезервы.ЦФУ,
	|	СУММА(абс_РезервыПроизведенныхРасходовРезервы.СуммаОстаткаПоГрафику) КАК СуммаОстаткаПоГрафику,
	|	СУММА(абс_РезервыПроизведенныхРасходовРезервы.СуммаРНП) КАК СуммаРНП,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоБУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоНУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратБУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратНУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СтатьяЗатрат,
	|	абс_РезервыПроизведенныхРасходовРезервы.НоменклатурнаяГруппа,
	|	абс_РезервыПроизведенныхРасходовРезервы.ВидДеятельности,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетУчетаНДС,
	|	СУММА(абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС) КАК СуммаНДС,
	|	СУММА(абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС_РПР) КАК СуммаНДС_РПР,
	|	СУММА(абс_РезервыПроизведенныхРасходовРезервы.СуммаРНП + абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС_РПР) КАК СуммаВсего
	|{ВЫБРАТЬ
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	ЗакупочныйЗаказ.*,
	|	БюджетнаяСтатья.*,
	|	ЦФУ.*,
	|	СчетЗатратАвтоБУ.*,
	|	СчетЗатратАвтоНУ.*,
	|	СчетЗатратБУ.*,
	|	СчетЗатратНУ.*,
	|	СтатьяЗатрат.*,
	|	НоменклатурнаяГруппа.*,
	|	ВидДеятельности.*,
	|	СчетУчетаНДС.*,
	|	СуммаОстаткаПоГрафику,
	|	СуммаРНП,
	|	СуммаНДС,
	|	СуммаНДС_РПР,
	|	СуммаВсего}
	|ИЗ
	|	Документ.абс_РезервыПроизведенныхРасходов.Резервы КАК абс_РезервыПроизведенныхРасходовРезервы
	|ГДЕ
	|	абс_РезервыПроизведенныхРасходовРезервы.Учитывать
	|	И абс_РезервыПроизведенныхРасходовРезервы.Ссылка = &Ссылка
	|{ГДЕ
	|	абс_РезервыПроизведенныхРасходовРезервы.Контрагент.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.ДоговорКонтрагента.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.ЗакупочныйЗаказ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.БюджетнаяСтатья.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.ЦФУ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СуммаОстаткаПоГрафику,
	|	абс_РезервыПроизведенныхРасходовРезервы.СуммаРНП,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоБУ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоНУ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратБУ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратНУ.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СтатьяЗатрат.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.НоменклатурнаяГруппа.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.ВидДеятельности.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетУчетаНДС.*,
	|	абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС,
	|	абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС_РПР,
	|	(абс_РезервыПроизведенныхРасходовРезервы.СуммаРНП + абс_РезервыПроизведенныхРасходовРезервы.СуммаНДС_РПР) КАК СуммаВсего}
	|
	|СГРУППИРОВАТЬ ПО
	|	абс_РезервыПроизведенныхРасходовРезервы.ЦФУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.ДоговорКонтрагента,
	|	абс_РезервыПроизведенныхРасходовРезервы.ЗакупочныйЗаказ,
	|	абс_РезервыПроизведенныхРасходовРезервы.БюджетнаяСтатья,
	|	абс_РезервыПроизведенныхРасходовРезервы.Контрагент,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоНУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.ВидДеятельности,
	|	абс_РезервыПроизведенныхРасходовРезервы.СтатьяЗатрат,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратАвтоБУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратБУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетЗатратНУ,
	|	абс_РезервыПроизведенныхРасходовРезервы.СчетУчетаНДС,
	|	абс_РезервыПроизведенныхРасходовРезервы.НоменклатурнаяГруппа
	|{УПОРЯДОЧИТЬ ПО
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	ЗакупочныйЗаказ.*,
	|	БюджетнаяСтатья.*,
	|	ЦФУ.*,
	|	СуммаОстаткаПоГрафику,
	|	СуммаРНП,
	|	СчетЗатратАвтоБУ.*,
	|	СчетЗатратАвтоНУ.*,
	|	СчетЗатратБУ.*,
	|	СчетЗатратНУ.*,
	|	СтатьяЗатрат.*,
	|	НоменклатурнаяГруппа.*,
	|	ВидДеятельности.*,
	|	СчетУчетаНДС.*,
	|	СуммаНДС,
	|	СуммаНДС_РПР,
	|	СуммаВсего}
	|{ИТОГИ ПО
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	ЗакупочныйЗаказ.*,
	|	БюджетнаяСтатья.*,
	|	ЦФУ.*,
	|	СуммаОстаткаПоГрафику,
	|	СуммаРНП,
	|	СчетЗатратАвтоБУ.*,
	|	СчетЗатратАвтоНУ.*,
	|	СчетЗатратБУ.*,
	|	СчетЗатратНУ.*,
	|	СтатьяЗатрат.*,
	|	НоменклатурнаяГруппа.*,
	|	ВидДеятельности.*,
	|	СчетУчетаНДС.*,
	|	СуммаНДС,
	|	СуммаНДС_РПР,
	|	СуммаВсего}";
	
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	// Покупатель
	// ДоговорКонтрагента
	ВалютаРегл = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Контрагент", "Контрагент");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗакупочныйЗаказ", "Закупочный заказ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("БюджетнаяСтатья", "Бюджетная статья");
    УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЦФУ", "ЦФУ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаОстаткаПоГрафику", "Сумма по проекту (руб.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРНП", "Сумма резерва (без НДС)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетЗатратАвтоБУ", "Счет авто БУ");
    УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетЗатратАвтоНУ", "Счет авто НУ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетЗатратБУ", "Счет БУ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетЗатратНУ", "Счет НУ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатьяЗатрат", "Статья затрат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НоменклатурнаяГруппа", "Номенклатурная группа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВидДеятельности", "Вид деятельности");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетУчетаНДС", "Счет учета НДС");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаНДС", "Сумма НДС");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаНДС_РПР", "Сумма НДС УН");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВсего", "Сумма УН (с НДС)");
	
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.    
	
	ВалютаУпр = глЗначениеПеременной("ВалютаУправленческогоУчета");
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
		
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаОстаткаПоГрафику", "Сумма по графику (руб.)", Истина, "ЧЦ=15; ЧДЦ=2");	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаРНП", "Сумма резерва (без НДС)", Истина, "ЧЦ=15; ЧДЦ=2");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаНДС", "Сумма НДС", Истина, "ЧЦ=15; ЧДЦ=2");	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаНДС_РПР", "Сумма НДС резерва", Истина, "ЧЦ=15; ЧДЦ=2");	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВсего", "Сумма резерва (с НДС)", Истина, "ЧЦ=15; ЧДЦ=2");

	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("БюджетнаяСтатья");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ЗакупочныйЗаказ");

	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	//УниверсальныйОтчет.ДобавитьОтбор("Организация");
	//УниверсальныйОтчет.ДобавитьОтбор("Подразделение");
	//УниверсальныйОтчет.ДобавитьОтбор("Поставщик");
	//УниверсальныйОтчет.ДобавитьОтбор("Покупатель");
	//УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	
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
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
	//УниверсальныйОтчет.РасширеннаяНастройка = Истина;
	//
	//УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	//
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Контрагент"					, ТипРазмещенияРеквизитовИзмерений.Отдельно);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Контрагент.Код"				, ТипРазмещенияРеквизитовИзмерений.Отдельно);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("ДоговорКонтрагента"			, ТипРазмещенияРеквизитовИзмерений.Отдельно);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("ДоговорКонтрагента.Код"		, ТипРазмещенияРеквизитовИзмерений.Отдельно);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Счет"						, ТипРазмещенияРеквизитовИзмерений.Отдельно);
		
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Ссылка", ДокументРПР);
	
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

УниверсальныйОтчет.мРежимВводаПериода = 1;

мСчета60 = Новый Массив;

мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.01"));
мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.02"));
мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.21"));
мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.22"));
мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.31"));
мСчета60.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.32"));

#КонецЕсли