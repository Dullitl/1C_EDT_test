#Если Клиент Тогда
Перем НП Экспорт;

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	ДокументРезультат.Очистить();

	Макет = ПолучитьМакет("Макет");
    Если ПоказыватьЗаголовок Тогда
		Заголовок = Макет.ПолучитьОбласть("Заголовок");
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		СтрокаТаблицы 	 = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ИтогиТаблицы 	 = Макет.ПолучитьОбласть("СтрокаИтогов");
		
		УчетнаяПолитика = ttk_ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(ДатаКон, Организация);
		Если НЕ ЗначениеЗаполнено(УчетнаяПолитика) Тогда
			УчетнаяПолитика = Новый Структура("МоментОпределенияНалоговойБазыНДС",Перечисления.МоментыОпределенияНалоговойБазыНДС.ПоОтгрузке);
		КонецЕсли; 

		
		Заголовок.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
		Заголовок.Параметры.Заголовок = "Сравнение данных о суммах НДС по реализованным ценностям в бухгалтерском учете и специализированных регистрах";
		Заголовок.Параметры.ОписаниеПериода = "" + Формат(ДатаНач, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") + " - " + 
												   Формат(ДатаКон, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");
												   
		Если УчетнаяПолитика.МоментОпределенияНалоговойБазыНДС = Перечисления.МоментыОпределенияНалоговойБазыНДС.ПоОплате Тогда
			Заголовок.Параметры.ОписаниеПериода = "Учетная политика: ""По оплате""";
		Иначе
			Заголовок.Параметры.ОписаниеПериода = "Учетная политика: ""По отгрузке""";
		КонецЕсли;
												   
		// Параметр для показа заголовка
		ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;

		ДокументРезультат.Вывести(Заголовок);
		
		// Когда нужен только заголовок:
		Если ТолькоЗаголовок Тогда
			Возврат;
		КонецЕсли;

		Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
			ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
		КонецЕсли;
    КонецЕсли;
	
	// Сначала формируется таблица, отражающая сравнение НДС отложенного к уплате в бюджет
	// между БухИтогами и данными подсистемы НДС
	РезультирующаяТаблица = ПолучитьДанныеОРеализации();
	
	Счетчик = 1;
	Если РезультирующаяТаблица.Количество()>0 Тогда
		ЗаголовокТаблицы.Параметры.ОписаниеТаблицы = Строка(Счетчик) + ". Суммы НДС, отложенные к уплате в бюджет";
		ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиБухИтогов = "Сумма НДС по кредиту счета 76.Н";
		ДокументРезультат.Вывести(ЗаголовокТаблицы);
		
		Если НЕ СводныеИтоги Тогда
			Для Каждого СтрокаРез Из РезультирующаяТаблица Цикл
				СтрокаТаблицы.Параметры.ДатаПоступления = Формат(СтрокаРез.Дата, "ДФ=dd.MM.yyyy");
				СтрокаТаблицы.Параметры.Контрагент      = СтрокаРез.Контрагент;
				СтрокаТаблицы.Параметры.СчетФактура     = СтрокаРез.СчетФактура;
				
				СтрокаТаблицы.Параметры.СуммаРеализации    = СтрокаРез.СуммаРеализации;
				СтрокаТаблицы.Параметры.СуммаНДСПоРегистру = СтрокаРез.СуммаНДСПоРегистру;
				СтрокаТаблицы.Параметры.СуммаНДСПоБухСчету = СтрокаРез.СуммаНДСПоБухСчету;
				СтрокаТаблицы.Параметры.Разница            = СтрокаРез.Разница;
				
				ДокументРезультат.Вывести(СтрокаТаблицы);
				
			КонецЦикла;
		КонецЕсли;
		
		ИтогиТаблицы.Параметры.ИтогСуммаРеализации = 	РезультирующаяТаблица.Итог("СуммаРеализации");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоРегистру = РезультирующаяТаблица.Итог("СуммаНДСПоРегистру");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоБухСчету = РезультирующаяТаблица.Итог("СуммаНДСПоБухСчету");
		ИтогиТаблицы.Параметры.ИтогРазница = 			РезультирующаяТаблица.Итог("Разница");
		
		ДокументРезультат.Вывести(ИтогиТаблицы);
		Счетчик = Счетчик + 1;
	КонецЕсли;
	
	// Формируется таблица, отражающая уплату в бюджет НДС, отложенного 
	// при моменте определения налоговой базы "по оплате"
	
	РезультирующаяТаблица = ПолучитьДанныеОНачисленииКУплате( УчетнаяПолитика);
	Если РезультирующаяТаблица.Количество()>0 Тогда
	
		ЗаголовокТаблицы.Параметры.ОписаниеТаблицы = Строка(Счетчик) + ". Суммы НДС, отложенные ранее, начисленные к уплате бюджет";
		ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиБухИтогов = "Сумма НДС по дебету счета 76.Н";
		ДокументРезультат.Вывести(ЗаголовокТаблицы);
	
	
		Если НЕ СводныеИтоги Тогда
			Для Каждого СтрокаРез Из РезультирующаяТаблица Цикл
				СтрокаТаблицы.Параметры.ДатаПоступления = Формат(СтрокаРез.Дата, "ДФ=dd.MM.yyyy");
				СтрокаТаблицы.Параметры.Контрагент      = СтрокаРез.Контрагент;
				СтрокаТаблицы.Параметры.СчетФактура     = СтрокаРез.СчетФактура;
				
				СтрокаТаблицы.Параметры.СуммаРеализации    = СтрокаРез.СуммаРеализации;
				СтрокаТаблицы.Параметры.СуммаНДСПоРегистру = СтрокаРез.СуммаНДСПоРегистру;
				СтрокаТаблицы.Параметры.СуммаНДСПоБухСчету = СтрокаРез.СуммаНДСПоБухСчету;
				СтрокаТаблицы.Параметры.Разница            = СтрокаРез.Разница;
				
				ДокументРезультат.Вывести(СтрокаТаблицы);
				
			КонецЦикла;
			
		КонецЕсли;
		
		ИтогиТаблицы.Параметры.ИтогСуммаРеализации = 	РезультирующаяТаблица.Итог("СуммаРеализации");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоРегистру = РезультирующаяТаблица.Итог("СуммаНДСПоРегистру");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоБухСчету = РезультирующаяТаблица.Итог("СуммаНДСПоБухСчету");
		ИтогиТаблицы.Параметры.ИтогРазница = 			РезультирующаяТаблица.Итог("Разница");
		
		ДокументРезультат.Вывести(ИтогиТаблицы);
		Счетчик = Счетчик + 1;
	КонецЕсли;
	
	// Формируется таблица, отражающая уплату в бюджет НДС "по отгрузке"
	РезультирующаяТаблица = ПолучитьДанныеОНачисленииКУплатеПоОтгрузке();
	Если РезультирующаяТаблица.Количество()>0 Тогда
	
		ЗаголовокТаблицы.Параметры.ОписаниеТаблицы = Строка(Счетчик) + ". Суммы НДС, начисленные к уплате бюджет";
		ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиБухИтогов = "Сумма НДС по кредиту счета 68.2";
		
		ДокументРезультат.Вывести(ЗаголовокТаблицы);
		
		Если НЕ СводныеИтоги Тогда
			Для Каждого СтрокаРез Из РезультирующаяТаблица Цикл
				СтрокаТаблицы.Параметры.ДатаПоступления = Формат(СтрокаРез.Дата, "ДФ=dd.MM.yyyy");
				СтрокаТаблицы.Параметры.Контрагент      = СтрокаРез.Контрагент;
				СтрокаТаблицы.Параметры.СчетФактура     = СтрокаРез.СчетФактура;
				
				СтрокаТаблицы.Параметры.СуммаРеализации    = СтрокаРез.СуммаРеализации;
				СтрокаТаблицы.Параметры.СуммаНДСПоРегистру = СтрокаРез.СуммаНДСПоРегистру;
				СтрокаТаблицы.Параметры.СуммаНДСПоБухСчету = СтрокаРез.СуммаНДСПоБухСчету;
				СтрокаТаблицы.Параметры.Разница            = СтрокаРез.Разница;
				
				ДокументРезультат.Вывести(СтрокаТаблицы);
				
			КонецЦикла;
			
		КонецЕсли;
		
		ИтогиТаблицы.Параметры.ИтогСуммаРеализации = 	РезультирующаяТаблица.Итог("СуммаРеализации");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоРегистру = РезультирующаяТаблица.Итог("СуммаНДСПоРегистру");
		ИтогиТаблицы.Параметры.ИтогСуммаНДСПоБухСчету = РезультирующаяТаблица.Итог("СуммаНДСПоБухСчету");
		ИтогиТаблицы.Параметры.ИтогРазница = 			РезультирующаяТаблица.Итог("Разница");
		
		ДокументРезультат.Вывести(ИтогиТаблицы);
		
		Счетчик = Счетчик + 1;
	КонецЕсли;
	
	ДокументРезультат.Автомасштаб = Истина;

КонецПроцедуры

// Функция получает данные о реализации
//
Функция ПолучитьДанныеОРеализации()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходныеДанные.Дата КАК Дата,
		|	ИсходныеДанные.Контрагент,
		|	ИсходныеДанные.СчетФактура,
		|	СУММА(ИсходныеДанные.СуммаРеализации) КАК СуммаРеализации,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру) КАК СуммаНДСПоРегистру,
		|	СУММА(ИсходныеДанные.СуммаНДСПоБухСчету) КАК СуммаНДСПоБухСчету,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру - ИсходныеДанные.СуммаНДСПоБухСчету) КАК Разница
		|ИЗ
		|	(ВЫБРАТЬ
		|		РегистрНачисление76Н.СчетФактура КАК СчетФактура,
		|		РегистрНачисление76Н.Покупатель КАК Контрагент,
		|		РегистрНачисление76Н.СчетФактура.Дата КАК Дата,
		|		РегистрНачисление76Н.НДСПриход КАК СуммаНДСПоРегистру,
		|		РегистрНачисление76Н.СуммаБезНДСПриход + РегистрНачисление76Н.НДСПриход КАК СуммаРеализации,
		|		0 КАК СуммаНДСПоБухСчету
		|	ИЗ
		|		РегистрНакопления.НДСНачисленный.Обороты(
		|				&ДатаНач,
		|				&ДатаКон,
		|				Период,
		|				Организация = &Организация
		|					И ВидНачисления В (&ВидНачисленияРеализация)
		|					И (НЕ(СчетФактура ССЫЛКА Документ.ОтчетОРозничныхПродажах
		|							ИЛИ СчетФактура ССЫЛКА Документ.ПриходныйКассовыйОрдер))) КАК РегистрНачисление76Н
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ПроводкиНачисление76Н.Субконто2,
		|		ПроводкиНачисление76Н.Субконто1,
		|		ПроводкиНачисление76Н.Субконто2.Дата,
		|		0,
		|		0,
		|		ПроводкиНачисление76Н.СуммаОборотКт
		|	ИЗ
		|		РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНДСОтложенномуДляУплатыВБюджет)), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&КоррСчета), ) КАК ПроводкиНачисление76Н) КАК ИсходныеДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|		ПО (УчетнаяПолитикаНалоговыйУчет.Период В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(УчетнаяПолитикаНалоговыйУчет.Период)
		|				ИЗ
		|					РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|				ГДЕ
		|					ИсходныеДанные.Дата >= УчетнаяПолитикаНалоговыйУчет.Период
		|					И УчетнаяПолитикаНалоговыйУчет.Организация = &Организация))
		|			И (УчетнаяПолитикаНалоговыйУчет.Организация = &Организация)
		|ГДЕ
		|	УчетнаяПолитикаНалоговыйУчет.МоментОпределенияНалоговойБазыНДС = ЗНАЧЕНИЕ(Перечисление.МоментыОпределенияНалоговойБазыНДС.ПоОплате)
		|	И ИсходныеДанные.Дата < &Начало2006Года
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсходныеДанные.Дата,
		|	ИсходныеДанные.СчетФактура,
		|	ИсходныеДанные.Контрагент
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр( "ДатаНач"		, ?(НЕ ЗначениеЗаполнено(ДатаНач),неопределено,Новый Граница( ДатаНач, ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "ДатаКон"		, ?(НЕ ЗначениеЗаполнено(ДатаКон),неопределено,Новый Граница( КонецДня(ДатаКон), ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "Организация"	, Организация);
	Запрос.УстановитьПараметр( "Начало2006Года"	, '20060101');
	
	МассивВидовНачислений = Новый Массив;
	МассивВидовНачислений.Добавить(Перечисления.НДСВидНачисления.РеализацияСНДС);
	МассивВидовНачислений.Добавить(Перечисления.НДСВидНачисления.РеализацияБезНДС);
	МассивВидовНачислений.Добавить(Перечисления.НДСВидНачисления.Реализация0);
	
	Запрос.УстановитьПараметр( "ВидНачисленияРеализация", МассивВидовНачислений);
	
	МассивКоррСчетов = Новый Массив;
	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.Продажи);
	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.ПрочиеДоходыИРасходы);
	
	Запрос.УстановитьПараметр( "КоррСчета", МассивКоррСчетов);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции // ПолучитьДанныеОРеализации()

// Функция получает данные о реализации
//
Функция ПолучитьДанныеОНачисленииКУплате(УчетнаяПолитика)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходныеДанные.Дата,
		|	ИсходныеДанные.Контрагент,
		|	ИсходныеДанные.СчетФактура,
		|	СУММА(ИсходныеДанные.СуммаРеализации) КАК СуммаРеализации,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру) КАК СуммаНДСПоРегистру,
		|	СУММА(ИсходныеДанные.СуммаНДСПоБухСчету) КАК СуммаНДСПоБухСчету,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру - ИсходныеДанные.СуммаНДСПоБухСчету) КАК Разница
		|ИЗ
		|	(ВЫБРАТЬ
		|		НДСНачисленныйОбороты.СчетФактура.Дата КАК Дата,
		|		НДСНачисленныйОбороты.Покупатель КАК Контрагент,
		|		НДСНачисленныйОбороты.СчетФактура КАК СчетФактура,
		|		НДСНачисленныйОбороты.СуммаБезНДСРасход + НДСНачисленныйОбороты.НДСРасход КАК СуммаРеализации,
		|		НДСНачисленныйОбороты.НДСРасход КАК СуммаНДСПоРегистру,
		|		0 КАК СуммаНДСПоБухСчету
		|	ИЗ
		|		РегистрНакопления.НДСНачисленный.Обороты(
		|				&ДатаНач,
		|				&ДатаКон,
		|				Период,
		|				Организация = &Организация
		|					И ВидНачисления В (&ВидНачисленияРеализация)
		|					И (НЕ(СчетФактура ССЫЛКА Документ.ОтчетОРозничныхПродажах
		|							ИЛИ СчетФактура ССЫЛКА Документ.ПриходныйКассовыйОрдер))) КАК НДСНачисленныйОбороты
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ХозрасчетныйОбороты.Субконто2.Дата,
		|		ХозрасчетныйОбороты.Субконто1,
		|		ХозрасчетныйОбороты.Субконто2,
		|		0,
		|		0,
		|		ХозрасчетныйОбороты.СуммаОборотДт
		|	ИЗ
		|		РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетАнализа), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&КоррСчет), ) КАК ХозрасчетныйОбороты) КАК ИсходныеДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|		ПО (УчетнаяПолитикаНалоговыйУчет.Период В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(УчетнаяПолитикаНалоговыйУчет.Период)
		|				ИЗ
		|					РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|				ГДЕ
		|					ИсходныеДанные.Дата >= УчетнаяПолитикаНалоговыйУчет.Период
		|					И УчетнаяПолитикаНалоговыйУчет.Организация = &Организация))
		|			И (УчетнаяПолитикаНалоговыйУчет.Организация = &Организация)
		|ГДЕ
		|	УчетнаяПолитикаНалоговыйУчет.МоментОпределенияНалоговойБазыНДС = ЗНАЧЕНИЕ(Перечисление.МоментыОпределенияНалоговойБазыНДС.ПоОплате)
		|	И ИсходныеДанные.Дата < &Начало2006Года
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсходныеДанные.Контрагент,
		|	ИсходныеДанные.Дата,
		|	ИсходныеДанные.СчетФактура";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр( "ДатаНач"		, ?(НЕ ЗначениеЗаполнено(ДатаНач),неопределено,Новый Граница( ДатаНач, ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "ДатаКон"		, ?(НЕ ЗначениеЗаполнено(ДатаКон),неопределено,Новый Граница( КонецДня(ДатаКон), ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "Организация"	, Организация);
	Запрос.УстановитьПараметр( "Начало2006Года"	, '20060101');
	
	Запрос.УстановитьПараметр( "СчетАнализа", 	ПланыСчетов.Хозрасчетный.РасчетыПоНДСОтложенномуДляУплатыВБюджет);
	
	МассивКоррСчетов = Новый Массив;
	//Если УчетнаяПолитика.МоментОпределенияНалоговойБазыНДС = Перечисления.МоментыОпределенияНалоговойБазыНДС.ПоОплате Тогда
		МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.НДС);
	//Иначе
	//	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.Продажи);
	//	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.ПрочиеДоходыИРасходы);
	//КонецЕсли;
	
	Запрос.УстановитьПараметр("КоррСчет", МассивКоррСчетов);
	
	МассивВидовНачислений = Новый Массив;
	МассивВидовНачислений.Добавить(Перечисления.НДСВидНачисления.РеализацияСНДС);
	
	Запрос.УстановитьПараметр( "ВидНачисленияРеализация", МассивВидовНачислений);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции // ПолучитьДанныеОНачисленииКУплате()

// Функция получает данные о реализации
//
Функция ПолучитьДанныеОНачисленииКУплатеПоОтгрузке()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходныеДанные.Дата КАК Дата,
		|	ИсходныеДанные.СчетФактура,
		|	МАКСИМУМ(ИсходныеДанные.Контрагент) КАК Контрагент,
		|	СУММА(ИсходныеДанные.СуммаРеализации) КАК СуммаРеализации,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру) КАК СуммаНДСПоРегистру,
		|	СУММА(ИсходныеДанные.СуммаНДСПоБухСчету) КАК СуммаНДСПоБухСчету,
		|	СУММА(ИсходныеДанные.СуммаНДСПоРегистру - ИсходныеДанные.СуммаНДСПоБухСчету) КАК Разница
		|ИЗ
		|	(ВЫБРАТЬ
		|		НДСНачисленныйОбороты.СчетФактура.Дата КАК Дата,
		|		НДСНачисленныйОбороты.Покупатель КАК Контрагент,
		|		НДСНачисленныйОбороты.СчетФактура КАК СчетФактура,
		|		НДСНачисленныйОбороты.СуммаБезНДСРасход + НДСНачисленныйОбороты.НДСРасход КАК СуммаРеализации,
		|		НДСНачисленныйОбороты.НДСРасход КАК СуммаНДСПоРегистру,
		|		0 КАК СуммаНДСПоБухСчету
		|	ИЗ
		|		РегистрНакопления.НДСНачисленный.Обороты(
		|				&ДатаНач,
		|				&ДатаКон,
		|				Период,
		|				Организация = &Организация
		|					И ВидНачисления В (&ВидНачисленияРеализация)) КАК НДСНачисленныйОбороты
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ХозрасчетныйОбороты.Период,
		|		НЕОПРЕДЕЛЕНО,
		|		ХозрасчетныйОбороты.Регистратор,
		|		0,
		|		0,
		|		ХозрасчетныйОбороты.СуммаОборотКт
		|	ИЗ
		|		РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Регистратор, Счет В ИЕРАРХИИ (&СчетАнализа), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&КоррСчет), ) КАК ХозрасчетныйОбороты) КАК ИсходныеДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|		ПО (УчетнаяПолитикаНалоговыйУчет.Период В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(УчетнаяПолитикаНалоговыйУчет.Период)
		|				ИЗ
		|					РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет
		|				ГДЕ
		|					ИсходныеДанные.Дата >= УчетнаяПолитикаНалоговыйУчет.Период
		|					И УчетнаяПолитикаНалоговыйУчет.Организация = &Организация))
		|			И (УчетнаяПолитикаНалоговыйУчет.Организация = &Организация)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ИсходныеДанные.Дата >= &Начало2006Года
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ (НЕ УчетнаяПолитикаНалоговыйУчет.МоментОпределенияНалоговойБазыНДС = ЗНАЧЕНИЕ(Перечисление.МоментыОпределенияНалоговойБазыНДС.ПоОплате))
		|					ИЛИ (ИсходныеДанные.СчетФактура ССЫЛКА Документ.ОтчетОРозничныхПродажах
		|						ИЛИ ИсходныеДанные.СчетФактура ССЫЛКА Документ.ПриходныйКассовыйОрдер)
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсходныеДанные.Дата,
		|	ИсходныеДанные.СчетФактура
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр( "ДатаНач"		, ?(НЕ ЗначениеЗаполнено(ДатаНач),неопределено,Новый Граница( ДатаНач, ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "ДатаКон"		, ?(НЕ ЗначениеЗаполнено(ДатаКон),неопределено,Новый Граница( КонецДня(ДатаКон), ВидГраницы.Включая)));
	Запрос.УстановитьПараметр( "Организация"	, Организация);
	Запрос.УстановитьПараметр( "Начало2006Года"	, '20060101');
	
	Запрос.УстановитьПараметр( "СчетАнализа", 	ПланыСчетов.Хозрасчетный.НДС);  // 68.02
	
	МассивКоррСчетов = Новый Массив;
	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.Продажи);               // 90
	МассивКоррСчетов.Добавить( ПланыСчетов.Хозрасчетный.ПрочиеДоходыИРасходы);  // 91
	
	Запрос.УстановитьПараметр("КоррСчет", МассивКоррСчетов);
	
	МассивВидовНачислений = Новый Массив;
	МассивВидовНачислений.Добавить(Перечисления.НДСВидНачисления.РеализацияСНДС);
	
	Запрос.УстановитьПараметр( "ВидНачисленияРеализация", МассивВидовНачислений);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаРезультата Из РезультатЗапроса Цикл
		Если СтрокаРезультата.Контрагент = Неопределено
			И ЗначениеЗаполнено(СтрокаРезультата.СчетФактура) 
			И СтрокаРезультата.СчетФактура.Метаданные().Реквизиты.Найти("Контрагент") <> Неопределено Тогда
			СтрокаРезультата.Контрагент = СтрокаРезультата.СчетФактура.Контрагент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатЗапроса;
	
КонецФункции // ПолучитьДанныеОНачисленииКУплате()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 
НП = Новый НастройкаПериода;
#КонецЕсли
