///////////////////////////////////////////////////////////////////////////////
//// ПЕРЕМЕННЫЕ МОДУЛЯ

#Если Клиент Тогда

Перем мТипЦен;
Перем мНомерСекции;
Перем мВозврат;
Перем мПродажа;
Перем мВалютаРеглУчета;
Перем мНаличные;
Перем мККМOnLine;
Перем мСклад;

#КонецЕсли

///////////////////////////////////////////////////////////////////////////////
//// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ

// Процедура осуществляет инициализацию работы с сервером торгового оборудования.
//
// Параметры:
//  Нет.
//
Процедура НачатьРаботу() Экспорт

	#Если Клиент Тогда

	ПолучитьСерверТО().ПодключитьКлиента(ЭтотОбъект);

	#КонецЕсли

КонецПроцедуры // НачатьРаботу()

// Процедура завершает работу с сервером торгового оборудования.
//
// Параметры:
//  Нет.
//
Процедура ЗавершитьРаботу() Экспорт

	#Если Клиент Тогда

	ПолучитьСерверТО().ОтключитьКлиента(ЭтотОбъект);

	#КонецЕсли

КонецПроцедуры // ЗавершитьРаботу()

// Процедура - обработчик внешнего событие, которое возникает при посылке
// внешним приложением сообщения, сформированного в специальном формате.
// Внешнее событие сначала обрабатывается всеми открытыми формами, имеющими
// обработчик этого события, а затем может быть обработано в процедуре модуля
// приложения с именем ОбработкаВнешнегоСобытия().
//
// Параметры:
//  Источник - <Строка>
//           - Источник внешнего события.
//
//  Событие  - <Строка>
//           - Наименование события.
//
//  Данные   - <Строка>
//           - Данные для события.
//
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт

	#Если Клиент Тогда

	ПолучитьСерверТО().ОбработатьВнешнееСобытие(Источник, Событие, Данные, ЭтотОбъект);

	#КонецЕсли

КонецПроцедуры // ВнешнееСобытие()

///////////////////////////////////////////////////////////////////////////////
//// ФУНКЦИИ ВЗАИМОДЕЙСТВИЯ С ТОРГОВЫМ ОБОРУДОВАНИЕМ (ОБЩИЕ ФУНКЦИИ API)

// Функция возвращает признак того, что клиент поддерживает работу с видом ТО,
// переданным в качестве параметра.
//
// Параметры:
//  Вид      - <ПеречислениеСсылка.ВидыТорговогоОборудования>
//           - Вид торгового оборудования, информация о поддержке
//             которого запрашивается.
//
// Возвращаемое значение:
//  <Булево> - Признак поддержки указанного класса торгового оборудования.
//
Функция ПоддерживаетсяВидТО(Вид) Экспорт

	Результат = Ложь;

	#Если Клиент Тогда

	Если Вид = мККМOnLine Тогда
		Результат = Истина;
	КонецЕсли;

	#КонецЕсли

	Возврат Результат;

КонецФункции // ПоддерживаетсяВидТО()

///////////////////////////////////////////////////////////////////////////////
//// ФУНКЦИИ ВЗАИМОДЕЙСТВИЯ С ТОРГОВЫМ ОБОРУДОВАНИЕМ (ККМ ON-LINE)

// Функция осуществляет обработку запроса ККМ, подключенной в режиме On-Line, о товаре.
//
// Параметры:
//  Номенклатура   - <СправочникСсылка.Номенклатура>
//                 - Номенклатура, информация о которой запрашивается.
//
//  Характеристика – <СправочникСсылка.ХарактеристикиНоменклатуры>
//                 - Характеристика номенклатуры.
//
//  Серия          - <СправочникСсылка.СерииНоменклатуры>
//                 - Серия номенклатуры.
//
//  Качество       - <СправочникСсылка.Качество>
//                 - Качество номенклатуры.
//
//  Единица        - <СправочникСсылка.ЕдиницыИзмерения>
//                 - Единица измерения номенклатуры.
//
//  Количество     - <Число>
//                 - Количество номенклатуры.
//
//  Цена           - <Число>
//                 - Выходной параметр; цена за единицу номенклатуры.
//
//  Скидка         - <Число>
//                 - Выходной параметр; процент скидки (>0) или наценки (<0);
//
//  НомерСекции    - <Число>
//                 - Выходной параметр; номер секции склада.
//
//  ККМ            - <Строка>
//                 - Идентификатор ККМ, с которой связано данное
//                   событие.
//
// Возвращаемое значение:
//  <Булево>       - Данная ситуация обработана.
//
Функция ОбработатьЗапросККМ(Номенклатура, Характеристика, Серия, Качество,
                            Единица, Количество, Цена, Скидка, НомерСекции, ККМ) Экспорт

	Результат = Истина;

	#Если Клиент Тогда

	Если      НЕ ЗначениеЗаполнено(мСклад) Тогда
		Сигнал();
		Сообщение = "Не задан склад по умолчанию.";
		Результат = Ложь;
	ИначеЕсли НЕ ЗначениеЗаполнено(мТипЦен) Тогда
		Сигнал();
		Сообщение = "Не задан тип цен.";
		Результат = Ложь;
	Иначе
		Цена        = Ценообразование.ПолучитьЦенуНоменклатуры(Номенклатура, Характеристика, мТипЦен, Неопределено, Единица);
		Скидка      = Ценообразование.ПолучитьПроцентСкидкиНаценкиЦеныНоменклатуры(Номенклатура, Характеристика, мТипЦен);
		НомерСекции = мНомерСекции;
	КонецЕсли;

	#КонецЕсли

	Возврат Результат;

КонецФункции // ОбработатьЗапросККМ()

// Процедура осуществляет обработку закрытия чека на ККМ, подключаемой в режиме On-Line.
//
// Параметры:
//  Товары          - <ТаблицаЗначений>
//                  - Таблица позиций чека. Таблица имеет следующие колонки:
//                      Номенклатура               - <СправочникСсылка.Номенклатура>
//                                                 - Номенклатура.
//                      ЕдиницаИзмерения           - <СправочникСсылка.ЕдиницыИзмерения>
//                                                 - Единица измерения номенклатуры.
//                      ХарактеристикаНоменклатуры - <СправочникСсылка.ХарактеристикиНоменклатуры>
//                                                 - Характеристика номенклатуры.
//                      СерияНоменклатуры          - <СправочникСсылка.СерииНоменклатуры>
//                                                 - Серия номенклатуры.
//                      Качество                   - <СправочникСсылка.Качество>
//                                                 - Качество номенклатуры.
//                      Цена                       - <Число>
//                                                 - Цена единицы номенклатуры.
//                      Количество                 - <Число>
//                                                 - Количество номенклатуры.
//                      Сумма                      - <Число>
//                                                 - Сумма позиции.
//
//  ПризнакВозврата - <Булево>
//                  - Признак того, что закрытый чек является чеком на возврат.
//
//  СуммаНал        - <Число>
//                  - Сумма нал., полученная от покупателя.
//
//  СуммаБезнал     - <Число>
//                  - Сумма безнал., полученная от покупателя.
//
//  НомерЧека       - <Число>
//                  - Номер закрытого чека.
//
//  НомерСмены      - <Число>
//                  - Номер текущей смены ККМ.
//
//  ККМ             - <Строка>
//                  - Идентификатор ККМ, с которой связано данное
//                    событие.
//
Процедура ЗакрытиеЧекаККМ(Товары, ПризнакВозврата, СуммаНал, СуммаБезнал,
                          НомерЧека, НомерСмены, ККМ) Экспорт

	#Если Клиент Тогда

	ДокЧек = Документы.ЧекККМ.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ДокЧек, "Продажа");

	ДокЧек.Дата           = РабочаяДата;
	ДокЧек.ВидОперации    = ?(ПризнакВозврата, мВозврат, мПродажа);
	ДокЧек.КассаККМ       = ПолучитьСерверТО().ПолучитьКассуККМ(ККМ);
	ДокЧек.НомерСменыККМ  = НомерСмены;
	ДокЧек.НомерЧекаККМ   = НомерЧека;
	ДокЧек.ЧекПробитНаККМ = Истина;

	Товар = Неопределено;
	Для Каждого Товар Из Товары Цикл
		Сумма                               = Товар.Цена * Товар.Количество;
		ПроцентСкидкиНаценки                = ?(Сумма = 0, 0, 100 * (1 - Товар.Сумма / Сумма));
		СтрокаТЧ                            = ДокЧек.Товары.Добавить();
		СтрокаТЧ.Артикул                    = Товар.Номенклатура.Артикул;
		СтрокаТЧ.ЕдиницаИзмерения           = Товар.ЕдиницаИзмерения;
		СтрокаТЧ.Количество                 = Товар.Количество;
		СтрокаТЧ.Коэффициент                = Товар.ЕдиницаИзмерения.Коэффициент;
		СтрокаТЧ.Номенклатура               = Товар.Номенклатура;
		СтрокаТЧ.ПроцентСкидкиНаценки       = ПроцентСкидкиНаценки;
		СтрокаТЧ.СерияНоменклатуры          = Товар.СерияНоменклатуры;
		СтрокаТЧ.Сумма                      = Товар.Сумма;
		СтрокаТЧ.ХарактеристикаНоменклатуры = Товар.ХарактеристикаНоменклатуры;
		СтрокаТЧ.Цена                       = Товар.Цена;
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(СтрокаТЧ, ДокЧек);
	КонецЦикла;

	Если СуммаНал <> 0 Тогда
		СтрокаТЧ           = ДокЧек.Оплата.Добавить();
		СтрокаТЧ.ВидОплаты = мНаличные;
		СтрокаТЧ.Сумма     = СуммаНал;
	КонецЕсли;

	Если СуммаБезнал <> 0 Тогда
		СтрокаТЧ           = ДокЧек.Оплата.Добавить();
		СтрокаТЧ.Сумма     = СуммаНал;
	КонецЕсли;

	Попытка
		ДокЧек.Записать(РежимЗаписиДокумента.Запись);
		Сообщить(СокрЛП(РабочаяДата) + ": Был создан чек """ + СокрЛП(ДокЧек) + """.",
		         СтатусСообщения.Информация);
	Исключение
		Сообщить(СокрЛП(ТекущаяДата()) + ": Был создан, но не был записан чек """ + СокрЛП(ДокЧек) + """.");
		ДокЧек.ПолучитьФорму().Открыть();
	КонецПопытки;

	#КонецЕсли

КонецПроцедуры // ЗакрытиеЧекаККМ()

///////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#Если Клиент Тогда

мВозврат         = Перечисления.ВидыОперацийЧекККМ.Возврат;
мПродажа         = Перечисления.ВидыОперацийЧекККМ.Продажа;
мВалютаРеглУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мНаличные        = Справочники.ВидыОплатЧекаККМ.Наличные;
мККМOnLine       = Перечисления.ВидыТорговогоОборудования.ККМOnLine;
мСклад           = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойСклад");

Если ЗначениеЗаполнено(мСклад) Тогда
	мНомерСекции = мСклад.НомерСекции;
	мТипЦен      = ?(мСклад.ВидСклада = Перечисления.ВидыСкладов.Оптовый,
	                 УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойТипЦенПродажи"),
	                 мСклад.ТипЦенРозничнойТорговли);
КонецЕсли;

#КонецЕсли