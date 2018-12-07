#Если Клиент Тогда
	
Перем ИмяРегистраБухгалтерии Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Формирует запрос по установленным условия, фильтрам и группировкам
//
Функция СформироватьЗапрос(СтруктураПараметров) Экспорт

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("НачПериода",  НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("КонПериода",  КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидУчета",  ВидУчета);

	ТекстЗапроса = "";
	ТекстИтогов  = "";
	ТекстЗапроса = ТекстЗапроса + 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Счет КАК Счет,
	|	Счет.Наименование КАК СчетНаименование,
	|	Счет.Представление КАК СчетПредставление,
	|	Счет.Код КАК СчетКод,
	|	Счет.Порядок КАК Порядок";
	
	// Добавим в текст запроса все выбранные ресурсы 
	ТекстЗапроса = ТекстЗапроса + БухгалтерскиеОтчеты.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомость(СтруктураПараметров.МассивПоказателей, Истина, 
			Истина, Истина);
			
	ТекстИтогов = ТекстИтогов + БухгалтерскиеОтчеты.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомость(СтруктураПараметров.МассивПоказателей, Ложь);
	
	СтрокаТекстаВыборкиИзТаблицы = БухгалтерскиеОтчеты.СформироватьТекстВыборкиИзТаблицыОборотовИОстатковРегистраБухгалтерии(СтруктураПараметров, "БухРегОстаткиИОбороты");
	
	ТекстЗапроса = ТекстЗапроса + СтрокаТекстаВыборкиИзТаблицы;
		
	ТекстЗапроса = ТекстЗапроса + "
	|АВТОУПОРЯДОЧИВАНИЕ
	|ИТОГИ " + Сред(ТекстИтогов, 2) + "
	|ПО
	|	Счет ИЕРАРХИЯ";

	Запрос.Текст = ТекстЗапроса;

	// АБС ВСТАВКА 11170
	Если абс_ВключаяПодчиненныеОрганизации Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " = &Организация", " В ИЕРАРХИИ (&Организация)");
		
	КонецЕсли;
	// АБС ВСТАВКА 11170 КОНЕЦ			
	
	Возврат Запрос;

КонецФункции // СформироватьЗапрос()

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ ОТЧЕТА
//

// Формирует табличный документ с заголовком отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт

	ОписаниеПериода = БухгалтерскиеОтчеты.СформироватьСтрокуВыводаПараметровПоДатам(ДатаНач, ДатаКон);
	
	Если Не ЗначениеЗаполнено(ВидУчета) Тогда
		ОписаниеПериода = ОписаниеПериода + " По всем видам учета.";
	Иначе
		Если ВидУчета = Перечисления.ВидыУчетаПоПБУ18.НУ Тогда
			СтрВидУчета = "налоговый учет";
		ИначеЕсли ВидУчета = Перечисления.ВидыУчетаПоПБУ18.ПР Тогда
			СтрВидУчета = "постоянные разницы";
		ИначеЕсли ВидУчета = Перечисления.ВидыУчетаПоПБУ18.ВР Тогда
			СтрВидУчета = "временные разницы";
		КонецЕсли;
			
		ОписаниеПериода = ОписаниеПериода + " Вид учета: "+СтрВидУчета+".";
	КонецЕсли;
	
	Макет = ПолучитьОбщийМакет("ОборотноСальдоваяВедомость");
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	
	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета();

	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;

	Возврат ЗаголовокОтчета;
	
КонецФункции // СформироватьЗаголовок()

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт

	БухгалтерскиеОтчеты.СформироватьОтчетОборотноСальдовойВедомости(ЭтотОбъект, ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, 
		Ложь, Ложь, , ВидУчета); 
			
КонецПроцедуры // СформироватьОтчет()

//Функция возвращает общую структуру для расшифровки
Функция СформироватьОбщуюСтруктуруДляРасшифровки() Экспорт
	
	СтруктураНастроекОтчета = Новый Структура;
	
	СтруктураНастроекОтчета.Вставить("ДатаНач", ДатаНач);
	СтруктураНастроекОтчета.Вставить("ДатаКон", ДатаКон);
	СтруктураНастроекОтчета.Вставить("Организация", Организация);
	СтруктураНастроекОтчета.Вставить("ВидУчета", ВидУчета);
			
	Возврат СтруктураНастроекОтчета;
	
КонецФункции

//Функция возвращает массив показателей для отчета
Функция СформироватьМассивПоказателей() Экспорт
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("Сумма");
	
	Возврат МассивПоказателей;
		
КонецФункции

Функция ЗаголовокОтчета() Экспорт
	Возврат "Оборотно-сальдовая ведомость (налоговый учет)";
КонецФункции // ЗаголовокОтчета()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

ИмяРегистраБухгалтерии = "Налоговый";

БухгалтерскиеОтчеты.СоздатьКолонкиУПравилВыводаИтоговИПравилаРазвернутогоСальдо(ПравилаВыводаИтогов, ПравилаРазвернутогоСальдо, ИмяРегистраБухгалтерии);

#КонецЕсли