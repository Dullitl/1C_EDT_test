#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция возвращает АВС-каласс контрагента отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка - класс контрагента отчета
//
Функция ПолучитьАВСКласс()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ABCКлассификацияПокупателейСрезПоследних.ABCКлассПокупателя КАК ABCКласс
	|ИЗ
	|	РегистрСведений.ABCКлассификацияПокупателей.СрезПоследних(&ДатаСреза, Контрагент = &Контрагент) КАК ABCКлассификацияПокупателейСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("ДатаСреза", ?(ДатаОтчета = '00010101000000', Неопределено, ДатаОтчета));
	Запрос.УстановитьПараметр("Контрагент", КонтрагентОтчета);
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЗапроса.Количество() = 0 Тогда
		Возврат "Не задан";
	Иначе
		Если НЕ ЗначениеЗаполнено(ТаблицаЗапроса[0].ABCКласс) Тогда
			Возврат "Не задан";
		Иначе
			Возврат Строка(ТаблицаЗапроса[0].ABCКласс);
		КонецЕсли; 
	КонецЕсли; 

КонецФункции // ПолучитьАВСКласс()

// Функция возвращает стадию взаимоотношений с контрагентом отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка - стадия взаимоотношений с контрагентом отчета
//
Функция ПолучитьСтадиюВзаимоотношений()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтадииВзаимоотношенийСПокупателямиСрезПоследних.Стадия КАК Стадия,
	|	СтадииВзаимоотношенийСПокупателямиСрезПоследних.КлассПостоянногоПокупателя КАК КлассПостоянногоПокупателя
	|ИЗ
	|	РегистрСведений.СтадииВзаимоотношенийСПокупателями.СрезПоследних(&ДатаСреза, Контрагент = &Контрагент) КАК СтадииВзаимоотношенийСПокупателямиСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("ДатаСреза", ?(ДатаОтчета = '00010101000000', Неопределено, ДатаОтчета));
	Запрос.УстановитьПараметр("Контрагент", КонтрагентОтчета);
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЗапроса.Количество() = 0 Тогда
		Возврат "Не задана";
	Иначе
		Если НЕ ЗначениеЗаполнено(ТаблицаЗапроса[0].Стадия) Тогда
			Возврат "Не задана";
		Иначе
			Возврат (Строка(ТаблицаЗапроса[0].Стадия) + ?(ЗначениеЗаполнено(ТаблицаЗапроса[0].КлассПостоянногоПокупателя), (", " + Строка(ТаблицаЗапроса[0].КлассПостоянногоПокупателя)), ""));
		КонецЕсли; 
	КонецЕсли; 

КонецФункции // ПолучитьСтадиюВзаимоотношений()

// Функция возвращает источник информации при обращении контрагента отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка - стадия взаимоотношений с контрагентом отчета
//
Функция ПолучитьИсточникИнформацииПриОбращении()
	
	СтруктураИсточника = РегистрыСведений.ИсточникИнформацииПриОбращении.ПолучитьПоследнее(?(ДатаОтчета = '00010101000000', Неопределено, ДатаОтчета), Новый Структура("Контрагент",КонтрагентОтчета));
	ИсточникРегистра  = СтруктураИсточника.ИсточникИнформации;
	
	Если ЗначениеЗаполнено(ИсточникРегистра) Тогда
		ИсточникИнформации = ИсточникРегистра;
	Иначе
		ИсточникИнформации = "Не указан";
	КонецЕсли;
	
	Возврат ИсточникИнформации;
КонецФункции // ПолучитьИсточникИнформацииПриОбращении()

// Функция оределяет надежность поставщика - контрагента отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка, надежность поставщика
//
Функция ОпределитьНадежностьПоставщика()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НадежностьПоставщиковСрезПоследних.Надежность
	|ИЗ
	|	РегистрСведений.НадежностьПоставщиков.СрезПоследних(&ДатаСреза, Контрагент = &Контрагент) КАК НадежностьПоставщиковСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("ДатаСреза", ?(ДатаОтчета = '00010101000000', Неопределено, ДатаОтчета));
	Запрос.УстановитьПараметр("Контрагент", КонтрагентОтчета);
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЗапроса.Количество() = 0 Тогда
		Возврат "Не задана";
	Иначе
		Если НЕ ЗначениеЗаполнено(ТаблицаЗапроса[0].Надежность) Тогда
			Возврат "Не задана";
		Иначе
			Возврат Строка(ТаблицаЗапроса[0].Надежность);
		КонецЕсли; 
	КонецЕсли; 

КонецФункции // ОпределитьНадежностьПоставщика(КонтрагентОтчета)

//Функция определяет контактных лиц контрагента
//Параметры:
//Контрагент - СправочникСсылка.Контрагенты, по которому происходит отбор
//ВыбТипКЛ - Тип контактного лица
//Возвращается таблица значений с колонками
//КонтактноеЛицо, ДолжностьКЛ
Функция ПолучитьКонтакныхЛицКонтрагента()
	
	Запрос = Новый Запрос();

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Ссылка                           КАК КонтактноеЛицо,
	|	КонтактныеЛицаКонтрагентов.Должность            КАК Должность,
	|	КонтактныеЛицаКонтрагентов.РольКонтактногоЛица  КАК Роль,
	|	КонтактныеЛица.Фамилия                          КАК Фамилия,
	|	КонтактныеЛица.Имя                              КАК Имя,
	|	КонтактныеЛица.Отчество                         КАК Отчество
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛицаКонтрагентов
	|ПО
	|	КонтактныеЛицаКонтрагентов.КонтактноеЛицо = КонтактныеЛица.Ссылка
	|
	|ГДЕ
	|	КонтактныеЛицаКонтрагентов.Владелец = &ВыбКонтрагент
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтактныеЛица.Наименование ВОЗР
	|";

	Запрос.УстановитьПараметр("ВыбКонтрагент", КонтрагентОтчета);

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьКонтакныхЛицКонтрагента()

//Возвращает таблицу значений с данными о контактной информации по заданным параметрам
//
Функция ПолучитьДанныеКонтактнойИнформации(Объект, ТипИнформации = Неопределено, ВидИнформации = Неопределено)

	Запрос = Новый Запрос;
	
	СтрокаВиртуальныхПараметров = "КонтактнаяИнформация.Объект = &Объект";
	
	Если ТипИнформации <> Неопределено Тогда
		СтрокаВиртуальныхПараметров = СтрокаВиртуальныхПараметров + " И КонтактнаяИнформация.Тип = &Тип";
		Запрос.УстановитьПараметр("Тип", ТипИнформации);
	КонецЕсли; 
	Если ВидИнформации <> Неопределено Тогда
		СтрокаВиртуальныхПараметров = СтрокаВиртуальныхПараметров + " И КонтактнаяИнформация.Вид = &Вид";
		Запрос.УстановитьПараметр("Вид", ВидИнформации);
	КонецЕсли; 
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактнаяИнформация.Объект        КАК Объект,
	|	КонтактнаяИнформация.Вид           КАК Вид,
	|	КонтактнаяИнформация.Тип           КАК Тип,
	|	КонтактнаяИнформация.Представление КАК Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|
	|ГДЕ
	|	" + СтрокаВиртуальныхПараметров + "
	|";
	
	Запрос.УстановитьПараметр("ДатаСреза", ?(ДатаОтчета = '00010101000000', Неопределено, ДатаОтчета));
	Запрос.УстановитьПараметр("Объект"   , Объект);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьДанныеКонтактнойИнформации()

// Функция возвращает данные о принадлежности объекта к категориям
//
// Переметры
//  ВыбОбъект - анализируемый объект
//
// Возвращаемое значение
//  ТаблицаЗапроса - таблица значений с данными о принадлежности
//   объекта к категориям
Функция ПрочитатьКатегорииОбъекта()

	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("НазначениеКатегорий",   ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
	Запрос.УстановитьПараметр("ОбъектОтбораКатегорий", КонтрагентОтчета);

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ  РАЗЛИЧНЫЕ
	|	КатегорииОбъектов.ПометкаУдаления                            КАК ПометкаУдаления,
	|	КатегорииОбъектов.Ссылка                                     КАК Категория,
	|
	|	ВЫБОР КОГДА
	|		РегистрСведений.КатегорииОбъектов.Объект ЕСТЬ НЕ NULL
	|	ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ                                                        КАК Принадлежность
	|
	|
	|ИЗ
	|// Отбираются категории, предназначенные для заданного типа объектов.
	|	(
	|	ВЫБРАТЬ 
	|		Справочник.КатегорииОбъектов.Ссылка          КАК Ссылка,
	|		Справочник.КатегорииОбъектов.ПометкаУдаления КАК ПометкаУдаления
	|
	|	ИЗ
	|		Справочник.КатегорииОбъектов
	|
	|	ГДЕ
	|		Справочник.КатегорииОбъектов.НазначениеКатегории В ( &НазначениеКатегорий )
	|
	|	)                                                            КАК КатегорииОбъектов
	|
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|// Присоединяются категории, назначенные для заданного объекта.
	|	РегистрСведений.КатегорииОбъектов
	|ПО
	|	РегистрСведений.КатегорииОбъектов.Категория = КатегорииОбъектов.Ссылка
	|	И
	|	РегистрСведений.КатегорииОбъектов.Объект = &ОбъектОтбораКатегорий
	|
	|ГДЕ
	|     (РегистрСведений.КатегорииОбъектов.Объект ЕСТЬ НЕ NULL) и (КатегорииОбъектов.ПометкаУдаления = Ложь)
	|УПОРЯДОЧИТЬ ПО
	|	КатегорииОбъектов.Ссылка.Наименование
	|";


	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗапроса;
	
КонецФункции

// Функция свойства и значения свойст объекта
//
// Переметры
//  ВыбОбъект - анализируемый объект
//
// Возвращаемое значение
//  ТаблицаЗапроса - таблица значений с данными о всойствах объекта
Функция ПрочитатьСвойстваИЗначенияОбъекта()

	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("НазначениеСвойств",       ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
	Запрос.УстановитьПараметр("ОбъектОтбораЗначений",    КонтрагентОтчета);
	Запрос.УстановитьПараметр("СписокНазначенийСвойств", КонтрагентОтчета);

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СвойстваОбъектов.ПометкаУдаления                            КАК ПометкаУдаления,
	|	СвойстваОбъектов.Ссылка                                     КАК Свойство,
	|	РегистрСведений.ЗначенияСвойствОбъектов.Значение            КАК Значение
	|
	|ИЗ
	|	(
	|	ВЫБРАТЬ 
	|		ПланВидовХарактеристик.СвойстваОбъектов.Ссылка          КАК Ссылка,
	|		ПланВидовХарактеристик.СвойстваОбъектов.ПометкаУдаления КАК ПометкаУдаления
	|
	|	ИЗ
	|		ПланВидовХарактеристик.СвойстваОбъектов
	|
	|	ГДЕ
	|		ПланВидовХарактеристик.СвойстваОбъектов.НазначениеСвойства В ( &НазначениеСвойств )
	|
	|	)                                                           КАК СвойстваОбъектов
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЗначенияСвойствОбъектов
	|ПО
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
	|	И
	|	РегистрСведений.ЗначенияСвойствОбъектов.Объект = &ОбъектОтбораЗначений
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.НазначенияСвойствОбъектов
	|ПО
	|	РегистрСведений.НазначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
	|	И
	|	РегистрСведений.ЗначенияСвойствОбъектов.Значение ЕСТЬ NULL
	|
	|ГДЕ
	|	РегистрСведений.НазначенияСвойствОбъектов.Объект ЕСТЬ NULL
	|	ИЛИ
	|	РегистрСведений.НазначенияСвойствОбъектов.Объект = &СписокНазначенийСвойств
	|
	|УПОРЯДОЧИТЬ ПО
	|	СвойстваОбъектов.Ссылка.Наименование
	|";

	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗапроса;

КонецФункции

// Процедура заполняет поле табличного документа
//
// Переметры
//  Таб - поле табличного документа
//  ПорядковыйНомер - порядковый номер выводимого параметра
//  Имя - строка, имя выводимого параметра
//
// Возвращаемое значение
//  НЕТ
Процедура ВывестиДанные(Таб, ПорядковыйНомер, Имя)
	
	//Общая информация
	
	Макет = ПолучитьМакет("Макет");

	Если Имя = "ОбщиеДанные" Тогда
		Секция = Макет.ПолучитьОбласть("Шапка_Общие");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);
		Секция = Макет.ПолучитьОбласть("Строка_Общие");
		Если ЗначениеЗаполнено(КонтрагентОтчета.ЮрФизЛицо) Тогда
			Если КонтрагентОтчета.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
				Секция.Параметры.ЮрФизЛицо = "Юридическое лицо";
			Иначе //Физическое лицо
				Секция.Параметры.ЮрФизЛицо = "Физическое лицо";
			КонецЕсли; 
		Иначе
			Секция.Параметры.ЮрФизЛицо = "Не задано";
		КонецЕсли; 

		Если ЗначениеЗаполнено(КонтрагентОтчета.ГоловнойКонтрагент) Тогда
			СтрокаГоловногоКонтрагента = Строка(КонтрагентОтчета.ГоловнойКонтрагент);
			Если ЗначениеЗаполнено(КонтрагентОтчета.ГоловнойКонтрагент.ЮрФизЛицо) Тогда
				Если КонтрагентОтчета.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
					СтрокаГоловногоКонтрагента = СтрокаГоловногоКонтрагента + " (Юридическое лицо)";
				Иначе //Физическое лицо
					СтрокаГоловногоКонтрагента = СтрокаГоловногоКонтрагента + " (Физическое лицо)";
				КонецЕсли; 
			КонецЕсли; 
			Секция.Параметры.ГоловнойКонтрагент = СтрокаГоловногоКонтрагента;
			Секция.Области.ГоловнойКонтрагент.Расшифровка = КонтрагентОтчета.ГоловнойКонтрагент;
		Иначе
			Секция.Параметры.ГоловнойКонтрагент = "Не задан";
		КонецЕсли;
		
		СтрокаВидовДеятельности = "";
		Для каждого ВидДеятельности Из КонтрагентОтчета.ВидыДеятельности Цикл
			Если НЕ ПустаяСтрока(СтрокаВидовДеятельности) Тогда
				СтрокаВидовДеятельности = СтрокаВидовДеятельности + ", ";
			КонецЕсли;
			СтрокаВидовДеятельности = СтрокаВидовДеятельности + ВидДеятельности.ВидДеятельности.Наименование;
		КонецЦикла;
		
		Секция.Параметры.ВидыДеятельности = СокрЛП(СтрокаВидовДеятельности);
		
		МассивКатегорий = ПрочитатьКатегорииОбъекта().ВыгрузитьКолонку("Категория");
		СтрокаКатегорий = "";
		Для а=0 По (МассивКатегорий.Количество()-1) Цикл
			Если а=0 Тогда
				СтрокаКатегорий = СтрокаКатегорий + Строка(СокрЛП(МассивКатегорий[а].Наименование));
			Иначе
				СтрокаКатегорий = СтрокаКатегорий + ", " + Символы.ПС + Строка(СокрЛП(МассивКатегорий[а].Наименование));
			КонецЕсли; 
		КонецЦикла; 
		Секция.Параметры.СтрокаКатегорий = СокрЛП(СтрокаКатегорий);
		
		Таб.Вывести(Секция,2);

		Секция = Макет.ПолучитьОбласть("Шапка_ИнформацияКонтрагента");
		Таб.Вывести(Секция, 2);

		Если КонтрагентОтчета.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда //Юридическое лицо
			
			Секция = Макет.ПолучитьОбласть("ИнформацияЮрЛицо");
			Секция.Параметры.ИНН       = КонтрагентОтчета.ИНН;
			Секция.Параметры.КПП       = КонтрагентОтчета.КПП;
			Секция.Параметры.КодПоОКПО = КонтрагентОтчета.КодПоОКПО;
			
		Иначе //Физическое лицо
			
			Секция = Макет.ПолучитьОбласть("ИнформацияФизЛицо");
			Секция.Параметры.ИНН                = КонтрагентОтчета.ИНН;
			Секция.Параметры.ДокументУдЛичность = КонтрагентОтчета.ДокументУдостоверяющийЛичность;
			
		КонецЕсли; 
		
		ЮрАдрес   = ПолучитьДанныеКонтактнойИнформации(КонтрагентОтчета, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
		Секция.Параметры.ЮрАдрес   = ?(ЮрАдрес.Количество() = 0, "", ЮрАдрес[0].Представление);
		ФактАдрес = ПолучитьДанныеКонтактнойИнформации(КонтрагентОтчета, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
		Секция.Параметры.ФактАдрес = ?(ФактАдрес.Количество() = 0, "", ФактАдрес[0].Представление);
		Телефон   = ПолучитьДанныеКонтактнойИнформации(КонтрагентОтчета, Перечисления.ТипыКонтактнойИнформации.Телефон, Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
		Секция.Параметры.Телефон   = ?(Телефон.Количество() = 0, "", Телефон[0].Представление);
		
		Таб.Вывести(Секция,3);

		Если ЗначениеЗаполнено(КонтрагентОтчета.ОсновнойБанковскийСчет) тогда
			Секция = Макет.ПолучитьОбласть("БанкКонтрагента");
			Секция.Параметры.НомерСчета = КонтрагентОтчета.ОсновнойБанковскийСчет.НомерСчета;
			Если ЗначениеЗаполнено(КонтрагентОтчета.ОсновнойБанковскийСчет.Банк) Тогда
				Секция.Параметры.Банк       = КонтрагентОтчета.ОсновнойБанковскийСчет.Банк.ПолноеНаименование() + " " + КонтрагентОтчета.ОсновнойБанковскийСчет.Банк.Город;
				Секция.Параметры.Бик        = КонтрагентОтчета.ОсновнойБанковскийСчет.Банк.Код;
				Секция.Параметры.КорСчет    = КонтрагентОтчета.ОсновнойБанковскийСчет.Банк.КоррСчет;
			КонецЕсли; 
			Таб.Вывести(Секция,3);
		КонецЕсли;

		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);
		
	ИначеЕсли Имя = "РежимРаботы" Тогда
		
		//Режим работы
		Секция = Макет.ПолучитьОбласть("Шапка_РежимРаботы");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);
		Секция = Макет.ПолучитьОбласть("Строка_РежимРаботы");
		Секция.Параметры.График = ?(ПустаяСтрока(КонтрагентОтчета.РасписаниеРаботыСтрокой), "Не задан", КонтрагентОтчета.РасписаниеРаботыСтрокой);
		Таб.Вывести(Секция,2);

		
		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);

	ИначеЕсли Имя = "КонтИнф" Тогда
		
		//Контактная информация контрагента
		Секция = Макет.ПолучитьОбласть("Шапка_КонтактнаяИнформация");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);

		ТЗКонтИнф = ПолучитьДанныеКонтактнойИнформации(КонтрагентОтчета);
		ТЗКонтИнф.Сортировать("Тип ВОЗР");
		ПрошлыйТип = Неопределено;
		Для каждого СтрокаКИ Из ТЗКонтИнф Цикл
			Если ПрошлыйТип <> СтрокаКИ.Тип Тогда
				Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
				Таб.Вывести(Секция, 2);
				СекцияКИ_Тип = Макет.ПолучитьОбласть("КонтИнфТип");
				СекцияКИ_Тип.Параметры.ТипКИ = СтрокаКИ.Тип;
				Таб.Вывести(СекцияКИ_Тип,2);
			КонецЕсли; 
			Секция = Макет.ПолучитьОбласть("Строка_КонтактнаяИнформация");
			Секция.Параметры.ВидКИ = ?(ТипЗнч(СтрокаКИ.Вид)=Тип("Строка"),СокрЛП(СтрокаКИ.Вид),СтрокаКИ.Вид.Наименование);
			Секция.Параметры.Значение = СтрокаКИ.Представление;
			Таб.Вывести(Секция,2);
			ПрошлыйТип = СтрокаКИ.Тип;
		КонецЦикла; 

		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);

	ИначеЕсли Имя = "КонтЛица" Тогда
		
		//Контактные лица контрагента
		Секция = Макет.ПолучитьОбласть("Шапка_КонтактныеЛица");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);
		ТаблицаКЛ = ПолучитьКонтакныхЛицКонтрагента();
		Ном=0;
		Для каждого СтрокаКЛ Из ТаблицаКЛ Цикл
			Ном=Ном+1;
			Секция = Макет.ПолучитьОбласть("Строка_КонтактныеЛица");
			ПредставлениеКонтактногоЛица = СокрЛП(СтрокаКЛ.Фамилия) + " "+ СокрЛП(СтрокаКЛ.Имя) + " " + СокрЛП(СтрокаКЛ.Отчество);
			Если НЕ ПустаяСтрока(СтрокаКЛ.Должность) Тогда
				ПредставлениеКонтактногоЛица = ПредставлениеКонтактногоЛица + ", " + СокрЛП(СтрокаКЛ.Должность);
			КонецЕсли; 
			Если ЗначениеЗаполнено(СтрокаКЛ.Роль) Тогда
				ПредставлениеКонтактногоЛица = ПредставлениеКонтактногоЛица + " (роль: " + СокрЛП(СтрокаКЛ.Роль) + ")";
			КонецЕсли; 
			Секция.Параметры.ПредставлениеКонтактногоЛица   = ПредставлениеКонтактногоЛица;
			Секция.Области.ПредставлениеКонтактногоЛица.Расшифровка = СтрокаКЛ.КонтактноеЛицо;
			Таб.Вывести(Секция,2);

			Если ВыводитьДопКонтИнф Тогда
				ТЗКонтИнф = ПолучитьДанныеКонтактнойИнформации(СтрокаКЛ.КонтактноеЛицо);
				ТЗКонтИнф.Сортировать("Тип ВОЗР");
				ПрошлыйТип = Неопределено;
				Для каждого СтрокаКИ Из ТЗКонтИнф Цикл
					Если ПрошлыйТип <> СтрокаКИ.Тип Тогда
						Если ПрошлыйТип <> Неопределено Тогда
							Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
							Таб.Вывести(Секция);
						КонецЕсли; 
						СекцияКИ_Тип = Макет.ПолучитьОбласть("КонтИнфТип");
						СекцияКИ_Тип.Параметры.ТипКИ = СтрокаКИ.Тип;
						Таб.Вывести(СекцияКИ_Тип,2);
					КонецЕсли; 
					СекцияКИ = Макет.ПолучитьОбласть("КонтИнф_КонтактныеЛица");
					СекцияКИ.Параметры.ВидКИ = ?(ТипЗнч(СтрокаКИ.Вид)=Тип("Строка"),СокрЛП(СтрокаКИ.Вид),СтрокаКИ.Вид.Наименование);
					СекцияКИ.Параметры.Значение = СтрокаКИ.Представление;
					Таб.Вывести(СекцияКИ,3);
					ПрошлыйТип = СтрокаКИ.Тип;
				КонецЦикла; 
				Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
				Таб.Вывести(Секция, 2);
			КонецЕсли; 
			
		КонецЦикла; 

		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);

	ИначеЕсли Имя = "СвойстваИЗначения" Тогда
		
		//ПрочаяИнформация по свойствам
		ТаблицаСвойств = ПрочитатьСвойстваИЗначенияОбъекта();
		Секция = Макет.ПолучитьОбласть("Шапка_Свойства");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);
		Секция = Макет.ПолучитьОбласть("Строка_Свойства");
		Ном=0;
		Для каждого СтрокаСвойств Из ТаблицаСвойств Цикл
			Ном=Ном+1;
			Секция.Параметры.ИмяСвойства = ""+Ном+". "+СтрокаСвойств.Свойство.Наименование;
			Секция.Параметры.ЗначениеСвойства = ""+СтрокаСвойств.Значение;
			Таб.Вывести(Секция,2);
		КонецЦикла; 

		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);
		
	ИначеЕсли Имя = "ПараметрыПоставщикаПокупателя" Тогда
		
		Секция = Макет.ПолучитьОбласть("Шапка_ПараметрыПоставщикаПокупателя");
		Секция.Параметры.ПорядковыйНомер = ПорядковыйНомер;
		Таб.Вывести(Секция,1);
		
		Если КонтрагентОтчета.Поставщик Тогда
			
			Секция = Макет.ПолучитьОбласть("Шапка_ПараметрыПоставщика");
			Таб.Вывести(Секция,2);
			
			Секция = Макет.ПолучитьОбласть("Строка_ПараметрыПоставщика");
			Секция.Параметры.Надежность           = ОпределитьНадежностьПоставщика();
			Секция.Параметры.СрокВыполненияЗаказа = КонтрагентОтчета.СрокВыполненияЗаказаПоставщиком;
			Таб.Вывести(Секция,2);
			
			Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
			Таб.Вывести(Секция, 2);

		КонецЕсли; 
		
		Если КонтрагентОтчета.Покупатель Тогда
			
			Секция = Макет.ПолучитьОбласть("Шапка_ПараметрыПокупателя");
			Таб.Вывести(Секция,2);
			
			Секция = Макет.ПолучитьОбласть("Строка_ПараметрыПокупателя");
			Секция.Параметры.ИсточникИнформации    = ПолучитьИсточникИнформацииПриОбращении();
			Секция.Параметры.АВСКласс              = ПолучитьАВСКласс();
			Секция.Параметры.СтадияВзаимоотношений = ПолучитьСтадиюВзаимоотношений();
			Секция.Параметры.Менеджер = ?(КонтрагентОтчета.ОсновнойМенеджерПокупателя.Пустая(),"НЕТ",СокрЛП(КонтрагентОтчета.ОсновнойМенеджерПокупателя.Наименование));
			Таб.Вывести(Секция,2);
			
			Если ВыводитьДопКонтИнф И ЗначениеЗаполнено(КонтрагентОтчета.ОсновнойМенеджерПокупателя) И ЗначениеЗаполнено(КонтрагентОтчета.ОсновнойМенеджерПокупателя.ФизЛицо) Тогда
				
				Секция = Макет.ПолучитьОбласть("Шапка_КонтИнф_Менеджер");
				Таб.Вывести(Секция,3);
				
				ТЗКонтИнф = ПолучитьДанныеКонтактнойИнформации(КонтрагентОтчета.ОсновнойМенеджерПокупателя.ФизЛицо);
				ТЗКонтИнф.Сортировать("Тип ВОЗР");
				ПрошлыйТип = Неопределено;
				Для каждого СтрокаКИ Из ТЗКонтИнф Цикл
					Если ПрошлыйТип <> СтрокаКИ.Тип Тогда
						Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
						Таб.Вывести(Секция);
						СекцияКИ_Тип = Макет.ПолучитьОбласть("КонтИнфТип");
						СекцияКИ_Тип.Параметры.ТипКИ = СтрокаКИ.Тип;
						Таб.Вывести(СекцияКИ_Тип,3);
					КонецЕсли; 
					СекцияКИ_Менеджер = Макет.ПолучитьОбласть("КонтИнф_Менеджер");
					СекцияКИ_Менеджер.Параметры.ВидКИ = СокрЛП(СтрокаКИ.Вид);
					СекцияКИ_Менеджер.Параметры.Значение = СтрокаКИ.Представление;
					Таб.Вывести(СекцияКИ_Менеджер,3);
					ПрошлыйТип = СтрокаКИ.Тип;
				КонецЦикла; 
				
			КонецЕсли; 

			Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
			Таб.Вывести(Секция, 2);

		КонецЕсли; 
		
		Секция = Макет.ПолучитьОбласть("ПустаяСтрока");
		Таб.Вывести(Секция);

	КонецЕсли; 

	
КонецПроцедуры // ВывестиОбщиеДанные()

// Процедура формирует отчет
//
// Переметры
//  Таб - поле табличного документа
//
// Возвращаемое значение
//  НЕТ
Процедура СформироватьОтчет(Таб) Экспорт

	Если НЕ ЗначениеЗаполнено(КонтрагентОтчета) Тогда
		Предупреждение("Выберите контрагента!");
		Возврат;
	КонецЕсли;
	
	Если КонтрагентОтчета.ЭтоГруппа Тогда
		Предупреждение("Отчет нельзя формировать по группе элементов!");
		Возврат;
	КонецЕсли; 
	
	Таб.Очистить();

	Макет = ПолучитьМакет("Макет");
	Таб.НачатьАвтогруппировкуСтрок();
	//Шапка
	Секция = Макет.ПолучитьОбласть("Шапка");
	Секция.Параметры.ПечВыбКонтрагент = КонтрагентОтчета.Наименование;
	Секция.Параметры.ДатаОтчета = Формат(ДатаОтчета,"ДФ=dd.MM.yyyy");
	Таб.Вывести(Секция,1);

	ПрядковыйНомер = 0;
	Для а=0 По СписокНастроек.Количество()-1 Цикл
		Если НЕ СписокНастроек[а].Пометка Тогда
			Продолжить;
		КонецЕсли; 
		ПрядковыйНомер = ПрядковыйНомер + 1;
		ВывестиДанные(Таб, ПрядковыйНомер, СписокНастроек[а].Значение);
	КонецЦикла; 
	
	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	Таб.ПоказатьУровеньГруппировокСтрок(2);

	Таб.ТолькоПросмотр = Истина;
	Таб.Показать();

КонецПроцедуры

ДатаОтчета = НачалоДня(ТекущаяДата());

СписокНастроек.Добавить("ОбщиеДанные","Общие данные контрагента"                           ,Истина);
СписокНастроек.Добавить("РежимРаботы","Режим работы контрагента"                           ,Истина);
СписокНастроек.Добавить("ПараметрыПоставщикаПокупателя","Параметры поставщика и покупателя",Истина);
СписокНастроек.Добавить("КонтИнф","Контактная информация контрагента"                      ,Истина);
СписокНастроек.Добавить("КонтЛица","Контактные лица контрагента"                           ,Истина);
СписокНастроек.Добавить("СвойстваИЗначения","Прочие свойства и значения контрагента"       ,Истина);

ВыводитьДопКонтИнф = Истина;
#КонецЕсли
