Перем мУдалятьДвижения;

// Хранит результаты отбора по заявкам
Перем ТабЗаявки Экспорт;

// Настройка периода
Перем НП Экспорт;

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

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Создает запрос для получения остатков по регистрам "ЗаявкиНаРасходованиеСредств"
// и "ДенежныеСредстваВРезерве"
//
Функция СформироватьЗапрос(Заявка="") Экспорт
	
	Запрос=Новый Запрос;
	СтруктураПараметров=Новый Структура;
	
	ТекстОтбора="";
	
	Если Заявка="" Тогда // Формируем запрос для заполнения ТЧ
		
		Если ОтборЦФО Тогда
			
			Если ЦФО.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.ЦФО = &ЦФО)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.ЦФО В ИЕРАРХИИ (&ЦФО))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("ЦФО",ЦФО);
			
		КонецЕсли;
				
		Если ОтборКонтрагент Тогда
			
			Если Контрагент.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.Контрагент = &Контрагент)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.Контрагент В ИЕРАРХИИ (&Контрагент))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("Контрагент",Контрагент);
			
		КонецЕсли;
				
		Если ОтборОтветственный Тогда
			
			Если Ответственный.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.Ответственный = &Ответственный)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.Ответственный В ИЕРАРХИИ (&Ответственный))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("Ответственный",ОтветственныйЗаявка);
			
		КонецЕсли;
		
		Если НЕ (ОтборДатаНач='00010101' ИЛИ ОтборДатаКон='00010101') Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода МЕЖДУ &ДатаНач И &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		ИначеЕсли НЕ ОтборДатаНач='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода >= &ДатаНач)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			
		ИначеЕсли НЕ ОтборДатаКон='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода <= &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		КонецЕсли;

		ТекстОтбора=Сред(ТекстОтбора,4);
		
	Иначе // Формируем запрос по конкретной заявке
		
		ТекстОтбора="##=&Заявка";
		СтруктураПараметров.Вставить("Заявка",Заявка);
		
	КонецЕсли;
	
	ТекстОтбораЗаявок = ?(ПустаяСтрока(ТекстОтбора), "", "ЗаявкаНаРасходование В (ВЫБРАТЬ Ссылка ИЗ Документ.ЗаявкаНаРасходованиеСредств ГДЕ "+ТекстОтбора+")");
	
	Запрос.Текст="ВЫБРАТЬ
	|	ЗаявкиОстаток.Заявка КАК Заявка,
	|	СУММА(ЗаявкиОстаток.СуммаЗаявкиОстаток) КАК ОстатокЗаявка,
	|	СУММА(ЗаявкиОстаток.СуммаРезерваОстаток) КАК ОстатокРезерв,
	|	СУММА(ЗаявкиОстаток.СуммаРазмещенияОстаток) КАК ОстатокРазмещение,
	|	ЗаявкиОстаток.Заявка.Ответственный КАК Ответственный,
	|	ЗаявкиОстаток.Заявка.ВалютаДокумента КАК ВалютаЗаявка,
	|	ЗаявкиОстаток.Заявка.Контрагент КАК Контрагент
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаявкиНаРасходованиеСредствОстатки.ЗаявкаНаРасходование КАК Заявка,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток КАК СуммаЗаявкиОстаток,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток КАК СуммаУпрЗаявкиОстаток,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетовЗаявкиОстаток,
	|		0 КАК СуммаРезерваОстаток,
	|       0 КАК СуммаРазмещенияОстаток
	|	ИЗ
	//|		РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки(&МоментДокумента,"+СтрЗаменить(ТекстОтбора,"##","ЗаявкаНаРасходование")+" ) КАК ЗаявкиНаРасходованиеСредствОстатки
	|		РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки(&МоментДокумента,"+СтрЗаменить(ТекстОтбораЗаявок,"##","Ссылка")+" ) КАК ЗаявкиНаРасходованиеСредствОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДенежныеСредстваВРезервеОстатки.ДокументРезервирования,
	|		0,
	|		0,
	|		0,
	|		ДенежныеСредстваВРезервеОстатки.СуммаОстаток,
	|		0
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментДокумента,"+СтрЗаменить(ТекстОтбора,"##","ДокументРезервирования")+" ) КАК ДенежныеСредстваВРезервеОстатки
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументРезервирования,
	|		0,
	|		0,
	|		0,
	|		0,
	|		РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(,"+СтрЗаменить(ТекстОтбора,"##","ДокументРезервирования")+" ) КАК РазмещениеЗаявокНаРасходованиеСредствОстатки) КАК ЗаявкиОстаток
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаявкиОстаток.Заявка";
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
		
		Запрос.УстановитьПараметр(Параметр.Ключ,Параметр.Значение);
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("МоментДокумента",МоментВремени());
	
	Возврат Запрос;
	
КонецФункции // СформироватьЗапрос()

// Добавляет в табличную часть заявки, по которым есть остатки в регистрах
// "ЗаявкиНаРасходованиеСредств" и (или) в регистре "ДенежныеСредстваВРезерве"
//
Процедура ЗаполнитьЗаявкиПоОстаткам() Экспорт
	
	Запрос=СформироватьЗапрос();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ЗаявкиНаРасходованиеСредств.Добавить();
		НоваяСтрока.Заявка = Выборка.Заявка;
		НоваяСтрока.ВалютаЗаявка=Выборка.ВалютаЗаявка;
		НоваяСтрока.ОстатокЗаявка=Выборка.ОстатокЗаявка;
		НоваяСтрока.ОстатокРезерв=Выборка.ОстатокРезерв;
		НоваяСтрока.ОстатокРазмещение=Выборка.ОстатокРазмещение;
		НоваяСтрока.Контрагент=Выборка.Контрагент;
		НоваяСтрока.Ответственный=Выборка.Ответственный;
	КонецЦикла; 
		
КонецПроцедуры // ЗаполнитьЗаявкиПоОстаткам()

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(Отказ, Заголовок)
	
	Запрос = Новый Запрос;
	МенеджерВремТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВремТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ 
	|	ЗаявкиКЗакрытию.Заявка КАК Заявка,
	|	ЗаявкиКЗакрытию.Заявка.ВидОперации КАК ВидОперации,
	|	ЗаявкиКЗакрытию.Заявка.ВключатьВПлатежныйКалендарь КАК ВключатьВПлатежныйКалендарь
	|ПОМЕСТИТЬ
	|	ЗаявкиКЗакрытию
	|ИЗ
	|	Документ.ЗакрытиеЗаявокНаРасходованиеСредств.ЗаявкиНаРасходованиеСредств КАК ЗаявкиКЗакрытию
	|ГДЕ
	|	ЗаявкиКЗакрытию.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
	// По регистрам "ЗаявкиНаРасходованиеСредств" и "РасчетыСКонтрагентами"
	
	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных") Тогда
		
		СтруктураПараметровБлокировки = Новый Структура(
			"ИмяТаблицы, ИсточникДанных, ИмяВременнойТаблицы", 
			"ЗаявкиНаРасходованиеСредств", МенеджерВремТаблиц, "ЗаявкиКЗакрытию");
		СтруктураИсточникаДанных = Новый Структура(
			"ЗаявкаНаРасходование", "Заявка");
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, , СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкиКЗакрытию.Заявка КАК ЗаявкаНаРасходование,
	|	ЗаявкиКЗакрытию.ВидОперации КАК ВидОперации,
	|	ЗаявкиКЗакрытию.ВключатьВПлатежныйКалендарь КАК ВключатьВПлатежныйКалендарь,
	|	ЗаявкиНаРасходованиеСредствОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗаявкиНаРасходованиеСредствОстатки.Контрагент КАК Контрагент,
	|	ЗаявкиНаРасходованиеСредствОстатки.Организация КАК Организация,
	|	ЗаявкиНаРасходованиеСредствОстатки.Сделка КАК Сделка,
	|	ЗаявкиНаРасходованиеСредствОстатки.ДокументРасчетовСКонтрагентом,
	|	ЗаявкиНаРасходованиеСредствОстатки.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ЗаявкиНаРасходованиеСредствОстатки.Проект КАК Проект,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетов,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток КАК СуммаУпр,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки(,
	|		ЗаявкаНаРасходование В (ВЫБРАТЬ РАЗЛИЧНЫЕ Заявка ИЗ ЗаявкиКЗакрытию)) КАК ЗаявкиНаРасходованиеСредствОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			ЗаявкиКЗакрытию
	|		ПО ЗаявкиКЗакрытию.Заявка = ЗаявкиНаРасходованиеСредствОстатки.ЗаявкаНаРасходование
	|ГДЕ
	|	НЕ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток ЕСТЬ NULL
	|			ИЛИ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток = 0)) 
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки";
	
	ТаблицаЗаявкиНаРасходованиеСредств = Движения.ЗаявкиНаРасходованиеСредств.ВыгрузитьКолонки();
	ТаблицаРасчетыСКонтрагентами       = Движения.РасчетыСКонтрагентами.ВыгрузитьКолонки();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвиженийЗаявки = ТаблицаЗаявкиНаРасходованиеСредств.Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийЗаявки, Выборка);
		
		Если Выборка.ВключатьВПлатежныйКалендарь
			И
			(Выборка.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаРасходование.ВозвратДенежныхСредствПокупателю 
				ИЛИ Выборка.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику
				ИЛИ Выборка.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаРасходование.РасчетыПоКредитамИЗаймамСКонтрагентами) Тогда
			
			СтрокаДвиженийРасчеты = ТаблицаРасчетыСКонтрагентами.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДвиженийРасчеты, Выборка);
			РасчетыВозврат = УправлениеДенежнымиСредствами.НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(Выборка.ВидОперации);
			СтрокаДвиженийРасчеты.РасчетыВозврат = РасчетыВозврат;
			
			КоэффициентСторно = ?(РасчетыВозврат = Перечисления.РасчетыВозврат.Возврат, -1, 1);
			
			// По регистру "Расчеты с контрагентами" делаем сторнирующие движения 
			// для правильного показа этой операции в анализе заказа и определения процента предоплаты по заказу
			Если КоэффициентСторно = 1 Тогда
				СтрокаДвиженийРасчеты.ВидДвижения = ВидДвиженияНакопления.Приход;
			Иначе
				СтрокаДвиженийРасчеты.ВидДвижения = ВидДвиженияНакопления.Расход;
			КонецЕсли;
			СтрокаДвиженийРасчеты.СуммаВзаиморасчетов = -СтрокаДвиженийРасчеты.СуммаВзаиморасчетов * КоэффициентСторно;
			СтрокаДвиженийРасчеты.СуммаУпр            = -СтрокаДвиженийРасчеты.СуммаУпр * КоэффициентСторно;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ЗаявкиНаРасходованиеСредств.мПериод          = Дата;
	Движения.ЗаявкиНаРасходованиеСредств.мТаблицаДвижений = ТаблицаЗаявкиНаРасходованиеСредств;
	Движения.ЗаявкиНаРасходованиеСредств.ВыполнитьРасход();
	
	ТаблицаРасчетыСКонтрагентами.ЗаполнитьЗначения(Дата, "Период");
	ТаблицаРасчетыСКонтрагентами.ЗаполнитьЗначения(Истина, "Активность");
	Движения.РасчетыСКонтрагентами.мТаблицаДвижений = ТаблицаРасчетыСКонтрагентами;
	Движения.РасчетыСКонтрагентами.ВыполнитьДвижения();
	
	// Закрываем резерв по заявкам
	
	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных") Тогда
		
		СтруктураПараметровБлокировки = Новый Структура(
			"ИмяТаблицы, ИсточникДанных, ИмяВременнойТаблицы", 
			"ДенежныеСредстваВРезерве", МенеджерВремТаблиц, "ЗаявкиКЗакрытию");
		СтруктураИсточникаДанных = Новый Структура(
			"ДокументРезервирования", "Заявка");
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, , СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДенежныеСредстваВРезервеОстатки.ДокументРезервирования КАК ДокументРезервирования,
	|	ДенежныеСредстваВРезервеОстатки.ВидДенежныхСредств КАК ВидДенежныхСредств,
	|	ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКасса,
	|	ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
	|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(,
	|		ДокументРезервирования В (ВЫБРАТЬ РАЗЛИЧНЫЕ Заявка ИЗ ЗаявкиКЗакрытию)) КАК ДенежныеСредстваВРезервеОстатки	
	|ГДЕ
	|	НЕ (ДенежныеСредстваВРезервеОстатки.СуммаОстаток ЕСТЬ NULL ИЛИ ДенежныеСредстваВРезервеОстатки.СуммаОстаток = 0)
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки";
	
	ТаблицаДенежныеСредстваВРезерве = Движения.ДенежныеСредстваВРезерве.ВыгрузитьКолонки();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвиженийРезерв = ТаблицаДенежныеСредстваВРезерве.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийРезерв, Выборка);
		
	КонецЦикла;
	
	Движения.ДенежныеСредстваВРезерве.мПериод            = Дата;
	Движения.ДенежныеСредстваВРезерве.мТаблицаДвижений   = ТаблицаДенежныеСредстваВРезерве;
	Движения.ДенежныеСредстваВРезерве.ВыполнитьРасход();
	
	//Закрываем размещение по заявкам
	
	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных") Тогда
		
		СтруктураПараметровБлокировки = Новый Структура(
			"ИмяТаблицы, ИсточникДанных, ИмяВременнойТаблицы", 
			"РазмещениеЗаявокНаРасходованиеСредств", МенеджерВремТаблиц, "ЗаявкиКЗакрытию");
		СтруктураИсточникаДанных = Новый Структура(
			"ДокументРезервирования", "Заявка");
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, , СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументРезервирования КАК ДокументРезервирования,
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументПланирования КАК ДокументПланирования,
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(,
	|		ДокументРезервирования В (ВЫБРАТЬ РАЗЛИЧНЫЕ Заявка ИЗ ЗаявкиКЗакрытию)) КАК РазмещениеЗаявокНаРасходованиеСредствОстатки
	|ГДЕ
	|	НЕ (РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток ЕСТЬ NULL ИЛИ РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток = 0)
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки";
	
	ТаблицаРазмещениеЗаявокНаРасходованиеСредств = Движения.РазмещениеЗаявокНаРасходованиеСредств.Выгрузить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвиженийРазмещение = ТаблицаРазмещениеЗаявокНаРасходованиеСредств.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийРазмещение, Выборка);
		
	КонецЦикла;
	
	Движения.РазмещениеЗаявокНаРасходованиеСредств.мПериод          = Дата;
	Движения.РазмещениеЗаявокНаРасходованиеСредств.мТаблицаДвижений = ТаблицаРазмещениеЗаявокНаРасходованиеСредств;
	Движения.РазмещениеЗаявокНаРасходованиеСредств.ВыполнитьРасход();
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, Режим)

	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура("Ответственный,Состояние"), Отказ, Заголовок);
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(Отказ, Заголовок);
		
	КонецЕсли; 
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#Если Клиент Тогда
НП = Новый НастройкаПериода;
#КонецЕсли

