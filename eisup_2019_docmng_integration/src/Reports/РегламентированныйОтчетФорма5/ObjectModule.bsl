////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;// таблица со счетчиками номеров листов при поиске
Перем мТаблицаФормОтчета Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мДеревоВыбранныхСтраниц Экспорт;

Перем мОтключитьАвтоматическоеУправлениеВариантами Экспорт;
Перем мГруппаОрганизаций Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

Перем мПечатьБезШтрихкодаРазрешена Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ОПРЕДЕЛЕНИЯ ДЕРЕВА ФОРМ И ФОРМАТОВ

Функция СоздатьДеревоФормИФорматов()
	
	мФормыИФорматы = Новый ДеревоЗначений;
	мФормыИФорматы.Колонки.Добавить("Код");
	мФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	мФормыИФорматы.Колонки.Добавить("НомерПриказа");
	мФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	мФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	мФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	мФормыИФорматы.Колонки.Добавить("Описание");
	Возврат мФормыИФорматы;
	
КонецФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОПРЕДЕЛЕНИЕ ДЕРЕВА ФОРМ И ФОРМАТОВ ОТЧЕТА

мФормыИФорматы = СоздатьДеревоФормИФорматов();

Форма20030101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710005", '20030722', "67н",	"ФормаОтчета2003Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20030101, "2.01002");

Форма20060101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710005", '20060918', "115н",	"ФормаОтчета2006Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20060101, "2.01002", , , , '20081231');
ОпределитьФорматВДеревеФормИФорматов(Форма20060101, "5.02", , , '20100101');

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

мГруппаОрганизаций = Новый СписокЗначений;

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);

мТаблицаСоставПоказателей         = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);

мСтруктураВариантыЗаполнения      = Новый Структура;

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2003Кв4";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина РФ от 22.07.2003 N 67н";
НоваяФорма.ДатаНачалоДействия = '20031001';
НоваяФорма.ДатаКонецДействия  = '20061130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв4";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина РФ от 22.07.2003 N 67н (в редакции приказа Минфина РФ от 18.09.2006 N 115н)";
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = '20101231';
