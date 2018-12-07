Перем мУдалятьДвижения;

// Хранит результаты отбора по заявкам

Перем ТабПоступление Экспорт;

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
Функция СформироватьЗапрос(ДокументПланирования="") Экспорт
	
	Запрос=Новый Запрос;
	СтруктураПараметров=Новый Структура;
	
	ТекстОтбора="";
	
	Если ДокументПланирования="" Тогда // Формируем запрос для заполнения ТЧ
		
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
			
			СтруктураПараметров.Вставить("Ответственный",ОтветственныйПоступление);
			
		КонецЕсли;
		
		Если НЕ (ОтборДатаНач='00010101' ИЛИ ОтборДатаКон='00010101') Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаПоступления МЕЖДУ &ДатаНач И &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		ИначеЕсли НЕ ОтборДатаНач='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаПоступления >= &ДатаНач)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			
		ИначеЕсли НЕ ОтборДатаКон='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаПоступления <= &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		КонецЕсли;
		
		ТекстОтбора=Сред(ТекстОтбора,4);
		
	Иначе // Формируем запрос по конкретной заявке
		
		ТекстОтбора="##=&ДокументПланирования";
		СтруктураПараметров.Вставить("ДокументПланирования",ДокументПланирования);
		
	КонецЕсли;
	
	Запрос.Текст="ВЫБРАТЬ
	|	ПланируемоеПоступлениеОстаток.ДокументПланирования КАК ДокументПланирования,
	|	СУММА(ПланируемоеПоступлениеОстаток.СуммаПоступленияОстаток) КАК ОстатокПоступление,
	|	СУММА(ПланируемоеПоступлениеОстаток.СуммаРазмещенияОстаток) КАК ОстатокРазмещение,
	|	ПланируемоеПоступлениеОстаток.ДокументПланирования.Ответственный КАК Ответственный,
	|	ПланируемоеПоступлениеОстаток.ДокументПланирования.ВалютаДокумента КАК ВалютаПоступление,
	|	ПланируемоеПоступлениеОстаток.ДокументПланирования.Контрагент КАК Контрагент
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПоступлениеДСОстатки.ДокументПланирования КАК ДокументПланирования,
	|		ПоступлениеДСОстатки.СуммаОстаток КАК СуммаПоступленияОстаток,
	|		ПоступлениеДСОстатки.СуммаУпрОстаток КАК СуммаУпрПоступленияОстаток,
	|		ПоступлениеДСОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетовПоступленияОстаток,
	|       0 КАК СуммаРазмещенияОстаток
	|	ИЗ
	|		РегистрНакопления.ПланируемыеПоступленияДенежныхСредств.Остатки(&МоментВремени,"+СтрЗаменить(ТекстОтбора,"##","ДокументПланирования")+" ) КАК ПоступлениеДСОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументПланирования,
	|		0,
	|		0,
	|		0,
	|		РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(,"+СтрЗаменить(ТекстОтбора,"##","ДокументПланирования")+" ) КАК РазмещениеЗаявокНаРасходованиеСредствОстатки) КАК ПланируемоеПоступлениеОстаток
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланируемоеПоступлениеОстаток.ДокументПланирования";
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
		
		Запрос.УстановитьПараметр(Параметр.Ключ,Параметр.Значение);
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("МоментВремени",МоментВремени());
	
	Возврат Запрос;
	
КонецФункции // СформироватьЗапрос()

// Добавляет в табличную часть документы планирования, по которым есть остатки в регистрах
// "ПланируемыеПоступленияДенежныхСредств" и (или) в регистре "РазмещениеЗаявокНаРасходованиеСредств"
//
Процедура ЗаполнитьДокументыПланированияПоОстаткам() Экспорт
	
	Запрос=СформироватьЗапрос();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ПланируемыеПоступленияДС.Добавить();
		НоваяСтрока.ДокументПланирования = Выборка.ДокументПланирования;
		НоваяСтрока.ВалютаПоступление=Выборка.ВалютаПоступление;
		НоваяСтрока.ОстатокПоступление=Выборка.ОстатокПоступление;
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
	|	ПланируемыеПоступленияКЗакрытию.ДокументПланирования КАК ДокументПланирования,
	|	ПланируемыеПоступленияКЗакрытию.ДокументПланирования.ВидОперации КАК ВидОперации
	|ПОМЕСТИТЬ
	|	ПланируемыеПоступленияКЗакрытию
	|ИЗ
	|	Документ.ЗакрытиеПланируемыхПоступленийДенежныхСредств.ПланируемыеПоступленияДС КАК ПланируемыеПоступленияКЗакрытию
	|ГДЕ
	|	ПланируемыеПоступленияКЗакрытию.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
	// По регистрам "ПланируемыеПоступленияДенежныхСредств" и "РасчетыСКонтрагентами"
	
	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных") Тогда
		
		СтруктураПараметровБлокировки = Новый Структура(
			"ИмяТаблицы, ИсточникДанных, ИмяВременнойТаблицы", 
			"ПланируемыеПоступленияДенежныхСредств", МенеджерВремТаблиц, "ПланируемыеПоступленияКЗакрытию");
		СтруктураИсточникаДанных = Новый Структура(
			"ДокументПланирования", "ДокументПланирования");
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, , СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланируемыеПоступленияКЗакрытию.ДокументПланирования КАК ДокументПланирования,
	|	ПланируемыеПоступленияКЗакрытию.ВидОперации КАК ВидОперации,
	|	ПланируемыеПоступленияОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПланируемыеПоступленияОстатки.Организация КАК Организация,
	|	ПланируемыеПоступленияОстатки.Контрагент КАК Контрагент,
	|	ПланируемыеПоступленияОстатки.Сделка КАК Сделка,
	|	ПланируемыеПоступленияОстатки.ДокументРасчетовСКонтрагентом,
	|	ПланируемыеПоступленияОстатки.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ПланируемыеПоступленияОстатки.Проект КАК Проект,
	|	ПланируемыеПоступленияОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетов,
	|	ПланируемыеПоступленияОстатки.СуммаУпрОстаток КАК СуммаУпр,
	|	ПланируемыеПоступленияОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ПланируемыеПоступленияДенежныхСредств.Остатки(,
	|		ДокументПланирования В (ВЫБРАТЬ РАЗЛИЧНЫЕ ДокументПланирования ИЗ ПланируемыеПоступленияКЗакрытию)) КАК ПланируемыеПоступленияОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			ПланируемыеПоступленияКЗакрытию
	|		ПО ПланируемыеПоступленияКЗакрытию.ДокументПланирования = ПланируемыеПоступленияОстатки.ДокументПланирования
	|ГДЕ
	|	НЕ (ПланируемыеПоступленияОстатки.СуммаОстаток ЕСТЬ NULL 
	|			ИЛИ (ПланируемыеПоступленияОстатки.СуммаОстаток = 0 
	|				И ПланируемыеПоступленияОстатки.СуммаВзаиморасчетовОстаток = 0 
	|				И ПланируемыеПоступленияОстатки.СуммаУпрОстаток = 0))
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.ПланируемыеПоступленияДенежныхСредств.Остатки";
	
	ТаблицаПланируемыеПоступленияДенежныхСредств = Движения.ПланируемыеПоступленияДенежныхСредств.ВыгрузитьКолонки();
	ТаблицаРасчетыСКонтрагентами = Движения.РасчетыСКонтрагентами.ВыгрузитьКолонки();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвиженийЗаявки = ТаблицаПланируемыеПоступленияДенежныхСредств.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийЗаявки, Выборка);
		
		Если НЕ Выборка.ВидОперации = Перечисления.ВидыОперацийПланируемоеПоступлениеДС.ПриходДенежныхСредствРозничнаяВыручка Тогда 			
			
			СтрокаДвиженийРасчеты = ТаблицаРасчетыСКонтрагентами.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДвиженийРасчеты, Выборка);
			РасчетыВозврат=УправлениеДенежнымиСредствами.НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(Выборка.ВидОперации);
			СтрокаДвиженийРасчеты.РасчетыВозврат = РасчетыВозврат;
			
			КоэффициентСторно = ?(РасчетыВозврат = Перечисления.РасчетыВозврат.Возврат, -1, 1);
			
			// По регистру "Расчеты с контрагентами" делаем сторнирующие движения 
			// для правильного показа этой операции в анализе заказа и определения процента предоплаты по заказу
			Если КоэффициентСторно = 1 Тогда
				СтрокаДвиженийРасчеты.ВидДвижения = ВидДвиженияНакопления.Расход;
			Иначе
				СтрокаДвиженийРасчеты.ВидДвижения = ВидДвиженияНакопления.Приход;
			КонецЕсли;
			СтрокаДвиженийРасчеты.СуммаВзаиморасчетов = -СтрокаДвиженийРасчеты.СуммаВзаиморасчетов * КоэффициентСторно;
			СтрокаДвиженийРасчеты.СуммаУпр            = -СтрокаДвиженийРасчеты.СуммаУпр * КоэффициентСторно;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ПланируемыеПоступленияДенежныхСредств.мПериод			= Дата;
	Движения.ПланируемыеПоступленияДенежныхСредств.мТаблицаДвижений	= ТаблицаПланируемыеПоступленияДенежныхСредств;
	Движения.ПланируемыеПоступленияДенежныхСредств.ВыполнитьРасход();
	
	ТаблицаРасчетыСКонтрагентами.ЗаполнитьЗначения(Дата, "Период");
	ТаблицаРасчетыСКонтрагентами.ЗаполнитьЗначения(Истина, "Активность");
	Движения.РасчетыСКонтрагентами.мТаблицаДвижений = ТаблицаРасчетыСКонтрагентами;
	Движения.РасчетыСКонтрагентами.ВыполнитьДвижения();
	
	//Закрываем размещение по заявкам
	
	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных") Тогда
		
		СтруктураПараметровБлокировки = Новый Структура(
			"ИмяТаблицы, ИсточникДанных, ИмяВременнойТаблицы", 
			"РазмещениеЗаявокНаРасходованиеСредств", МенеджерВремТаблиц, "ПланируемыеПоступленияКЗакрытию");
		СтруктураИсточникаДанных = Новый Структура(
			"ДокументПланирования", "ДокументПланирования");
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, , СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументПланирования КАК ДокументПланирования,
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументРезервирования КАК ДокументРезервирования,
	|	РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(,
	|		ДокументПланирования В (ВЫБРАТЬ РАЗЛИЧНЫЕ ДокументПланирования ИЗ ПланируемыеПоступленияКЗакрытию)) КАК РазмещениеЗаявокНаРасходованиеСредствОстатки
	|ГДЕ
	|	НЕ (РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток ЕСТЬ NULL ИЛИ РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток = 0)
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки";
	
	ТаблицаРазмещениеЗаявокНаРасходованиеСредств = Движения.РазмещениеЗаявокНаРасходованиеСредств.ВыгрузитьКолонки();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвиженийРазмещение = ТаблицаРазмещениеЗаявокНаРасходованиеСредств.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийРазмещение, Выборка);
		
	КонецЦикла;
	
	Движения.РазмещениеЗаявокНаРасходованиеСредств.мПериод			= Дата;
	Движения.РазмещениеЗаявокНаРасходованиеСредств.мТаблицаДвижений	= ТаблицаРазмещениеЗаявокНаРасходованиеСредств;
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

