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
	 УниверсальныйОтчет.ИмяРегистра = "ОборотыБюджетов";
	
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
	
	// Описание исходного текста запроса.

	//ТекстЗапроса = 
	//"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//|	ОборотыБюджетовОбороты.Сценарий,
	//|	ОборотыБюджетовОбороты.Проект,
	//|	ОборотыБюджетовОбороты.ЦФО,
	//|	ОборотыБюджетовОбороты.СтатьяОборотов,
	//|	ОборотыБюджетовОбороты.Контрагент,
	//|	ОборотыБюджетовОбороты.Номенклатура,
	//|	ОборотыБюджетовОбороты.Валюта,
	//|	ОборотыБюджетовОбороты.абс_ТипКонтрагента,
	//|	ОборотыБюджетовОбороты.абс_ТипСети,
	//|	ОборотыБюджетовОбороты.абс_КВ,
	//|	ОборотыБюджетовОбороты.абс_ТЭО,
	//|	ОборотыБюджетовОбороты.абс_ЦФУ,
	//|	ОборотыБюджетовОбороты.абс_ТипРасхода,
	//|	ОборотыБюджетовОбороты.Организация,
	//|	ОборотыБюджетовОбороты.КоличествоОборот КАК Количество,
	//|	ОборотыБюджетовОбороты.СуммаУпрОборот КАК СуммаУпр,
	//|	ОборотыБюджетовОбороты.ВалютнаяСуммаОборот КАК ВалютнаяСумма,
	//|	ОборотыБюджетовОбороты.СуммаСценарияОборот КАК СуммаСценария
	//|{ВЫБРАТЬ
	//|	Сценарий.*,
	//|	Проект.*,
	//|	ЦФО.*,
	//|	СтатьяОборотов.*,
	//|	Контрагент.*,
	//|	Номенклатура.*,
	//|	Валюта.*,
	//|	абс_ТипКонтрагента.*,
	//|	абс_ТипСети.*,
	//|	абс_КВ.*,
	//|	абс_ТЭО.*,
	//|	абс_ЦФУ.*,
	//|	абс_ТипРасхода.*,
	//|	Организация.*}
	//|ИЗ
	//|	РегистрНакопления.ОборотыБюджетов.Обороты(&ДатаНач, &ДатаКон, Авто, ) КАК ОборотыБюджетовОбороты
	//|{ГДЕ
	//|	ОборотыБюджетовОбороты.Сценарий.*,
	//|	ОборотыБюджетовОбороты.Проект.*,
	//|	ОборотыБюджетовОбороты.ЦФО.*,
	//|	ОборотыБюджетовОбороты.СтатьяОборотов.*,
	//|	ОборотыБюджетовОбороты.Контрагент.*,
	//|	ОборотыБюджетовОбороты.Номенклатура.*,
	//|	ОборотыБюджетовОбороты.Валюта.*,
	//|	ОборотыБюджетовОбороты.абс_ТипКонтрагента.*,
	//|	ОборотыБюджетовОбороты.абс_ТипСети.*,
	//|	ОборотыБюджетовОбороты.абс_КВ.*,
	//|	ОборотыБюджетовОбороты.абс_ТЭО.*,
	//|	ОборотыБюджетовОбороты.абс_ЦФУ.*,
	//|	ОборотыБюджетовОбороты.абс_ТипРасхода.*,
	//|	ОборотыБюджетовОбороты.Организация.*}
	//|{УПОРЯДОЧИТЬ ПО
	//|	Сценарий.*,
	//|	Проект.*,
	//|	ЦФО.*,
	//|	СтатьяОборотов.*,
	//|	Контрагент.*,
	//|	Номенклатура.*,
	//|	Валюта.*,
	//|	абс_ТипКонтрагента.*,
	//|	абс_ТипСети.*,
	//|	абс_КВ.*,
	//|	абс_ТЭО.*,
	//|	абс_ЦФУ.*,
	//|	абс_ТипРасхода.*,
	//|	Организация.*}
	//|ИТОГИ
	//|	СУММА(Количество),
	//|	СУММА(СуммаУпр),
	//|	СУММА(ВалютнаяСумма),
	//|	СУММА(СуммаСценария)
	//|ПО
	//|	ОБЩИЕ
	//|{ИТОГИ ПО
	//|	Сценарий.*,
	//|	Проект.*,
	//|	ЦФО.*,
	//|	СтатьяОборотов.*,
	//|	Контрагент.*,
	//|	Номенклатура.*,
	//|	Валюта.*,
	//|	абс_ТипКонтрагента.*,
	//|	абс_ТипСети.*,
	//|	абс_КВ.*,
	//|	абс_ТЭО.*,
	//|	абс_ЦФУ.*,
	//|	абс_ТипРасхода.*,
	//|	Организация.*}";



	// В универсальном отчете включен флаг использования свойств и категорий.
	//Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
	//	
	//	
	//КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	//УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НормаАмортизации", "Норма амортизации");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОставшийсяСрок", "Оставшийся срок");
	//
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПервоначальнаяСтоимость", "Первоначальная стоимость");

	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаПоступления", "Дата приобретения");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаВвода", "Дата ввода в эксплуатацию");

	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаНач", "Сумма на начало");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Поступление", "Поступление");
	//
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВводВЭксплуатацию", "Ввод в эксплуатацию (Дт счета 01)");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПрочееВыбытие", "Прочее выбытие");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПрочееПеремещение", "Прочее перемещение (счета 07, 08)");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаКон", "Сумма на конец"); 
	
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВаловаяНач", "GM");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьПриход", "REV");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВаловаяПриход", "GM ");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьРасход", "REV");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВаловаяРасход", "GM ");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьКон", "REV");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВаловаяКон", "GM ");

	
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Себестоимость", "Себестоимость");
	//
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВаловаяПрибыль", "Валовая прибыль");
	//
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Эффективность", "Эффективность, %");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Рентабельность", "Рентабельность, %");

	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	//ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	//УниверсальныйОтчет.ДобавитьПоказатель("Количество", "Ед. хранения", Истина, "ЧЦ=15; ЧДЦ=3", "Количество", "Количество");
	//УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдиниц", "Базовых ед.", Ложь, "ЧЦ=15; ЧДЦ=3", "Количество", "Количество");
	//УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетов", "Ед. отчетов", Ложь, "ЧЦ=15; ЧДЦ=3", "Количество", "Количество");
	
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьНач", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Начальные данные","Начальные данные");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяНач", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Начальные данные","Начальные данные");
	////УниверсальныйОтчет.ДобавитьПоказатель("Номер", "Номер п/п", Истина, "ЧЦ=15; ЧДЦ=2", "Объект строительства","Объект строительства");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпр", "Сумма (упр.)", Истина, "", "Сумма","Сумма");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВалютнаяСумма", "Сумма (вал.) ", Истина, "", "Валютная сумма","Валютная сумма");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаСценария", "Сумма сценария", Истина, "", "Сумма сценария","Сумма сценария");
	//УниверсальныйОтчет.ДобавитьПоказатель("Количество", "Количество", Истина, "", "Количество","Количество");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаОплаты", "Сумма оплаты", Истина, "", "","");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаПлатежаРегл", "Сумма оплаты (руб.)", Истина, "", "","");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаБУ01Нач", "Балансовая стоимость", Истина, "", "Данные на начало БУ","Данные на начало БУ");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаБУ02Нач", "Амортизация", Истина, "ДФ=dd.MM.yy", "Данные на начало БУ","Данные на начало БУ");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаБУОСТНач", "Остаточная стоимость", Истина, "ДФ=dd.MM.yy", "Данные на начало БУ","Данные на начало БУ");


 
	//УниверсальныйОтчет.ДобавитьПоказатель("ПрочееПеремещение", "Прочее перемещение (счета 07, 08)", Истина, "ЧЦ=15; ЧДЦ=2", "","");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаКон", "Сумма на конец", Истина, "ЧЦ=15; ЧДЦ=2", "","");
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьРасход", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Отрицательные изменения","Отрицательные изменения");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяРасход", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Отрицательные изменения","Отрицательные изменения");
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьКон", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Конечные данные","Конечные данные");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяКон", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Конечные данные","Конечные данные");
		
	
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьВалНач", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Начальные данные (в валюте)","Начальные данные (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяВалНач", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Начальные данные (в валюте)","Начальные данные (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьВалПриход", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Положительные изменения (в валюте)","Положительные изменения (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяВалПриход", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Положительные изменения (в валюте)","Положительные изменения (в валюте)");

	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьВалРасход", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Отрицательные изменения (в валюте)","Отрицательные изменения (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяВалРасход", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Отрицательные изменения (в валюте)","Отрицательные изменения (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьВалКон", "REV", Истина, "ЧЦ=15; ЧДЦ=2", "Конечные данные (в валюте)","Конечные данные (в валюте)");
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяВалКон", "GM", Истина, "ЧЦ=15; ЧДЦ=2", "Конечные данные (в валюте)","Конечные данные (в валюте)");
		
	
	//УниверсальныйОтчет.ДобавитьПоказатель("Себестоимость", "Себестоимость  (" + ВалютаУпр + ")", Ложь, "ЧЦ=15; ЧДЦ=2");
	//
	//УниверсальныйОтчет.ДобавитьПоказатель("ВаловаяПрибыль", "Валовая прибыль (" + ВалютаУпр + ")", Истина, "ЧЦ=15; ЧДЦ=2");
	//
	//УниверсальныйОтчет.ДобавитьПоказатель("Эффективность", "Эффективность, %", Ложь, "ЧЦ=15; ЧДЦ=2");
	//УниверсальныйОтчет.ДобавитьПоказатель("Рентабельность", "Рентабельность, %", Истина, "ЧЦ=15; ЧДЦ=2");

	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("РМ");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Регистратор");
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Сценарий");


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
	//УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	//
	//УниверсальныйОтчет.ДобавитьОтбор("РМ");

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
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
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

	//
	МассивОплат = Новый Массив;
	массивОплат.Добавить(Перечисления.абсСтатусыПлатежей.Отправлено);
	массивОплат.Добавить(Перечисления.абсСтатусыПлатежей.ГотовКОплате);
	массивОплат.Добавить(Перечисления.абсСтатусыПлатежей.ПеренесенаВГК);
	массивОплат.Добавить(Перечисления.абсСтатусыПлатежей.Оплачен);
	//
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СЧет90_02",ПланыСчетов.Хозрасчетный.СебестоимостьПродаж);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаНач",Новый Граница(УниверсальныйОтчет.ДатаНач,ВидГраницы.Включая));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаКон",Новый Граница(КонецДня(УниверсальныйОтчет.ДатаКон),ВидГраницы.Включая));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Ввод",Перечисления.СостоянияОС.ВведеноВЭксплуатацию);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("МассивОплат",МассивОплат);

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
