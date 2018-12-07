#Если Клиент Тогда
	
// Переменные, хранящие сведения о ПВРах
Перем мСведенияОВидахРасчета Экспорт;

Процедура ВыводПоказателя(Макет, Показатель, СтрокаЗначения, ТекущийРаздел)
	
	// Печать значения.
	Область = Макет.ПолучитьОбласть("Показатель");
	Область.Параметры.Показатель = Строка (Показатель);
	
	Область.Параметры.ТипПоказателя = СтрокаЗначения;
	ТекущийРаздел.Вывести(Область);

КонецПроцедуры
	
// Печатает Схему мотивации по переданной таблице.
//
// Параметры
//  ТаблицаВидовРасчета  – Таблица значений. Колонки:
//                 ВидРасчета - сотавной тип Упр.Начисления 
//                 и Уп.Удержания плна видов расчета.
//  
Процедура ПечатьСМ(ТаблицаВидовРасчета, ВидОрганизационнойСтруктурыПредприятия) Экспорт

	Если ТаблицаВидовРасчета.Количество() < 1 Тогда 
		Возврат
	КонецЕсли;	
	
	// Заведение печатной формы
	ПечатныйДокумент = Новый ТабличныйДокумент;
	ТекущийРаздел    = Новый ТабличныйДокумент;	
	ПечатныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СхемаМотивации";
	Макет = ПолучитьОбщийМакет("МакетСхемыМотивации");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ПечатныйДокумент.Вывести(ОбластьЗаголовок);
	
	// Распечатка таблицы видов расчета.
	Для Каждого СтрокаВидаРасчета Из ТаблицаВидовРасчета Цикл
		
		ВидРасчета = СтрокаВидаРасчета.ВидРасчета;
		
		Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
			Продолжить;
		КонецЕсли;
		
		СведенияОВидеРасчета = РаботаСДиалогамиПереопределяемый.ПолучитьСведенияОВидеРасчетаСхемыМотивации(мСведенияОВидахРасчета, ВидРасчета);
		КоличествоПоказателей = СведенияОВидеРасчета["КоличествоПоказателей"];
		
		// Вывод шапки печатной формы.
		Подразделение = СтрокаВидаРасчета.Подразделение;
		Если ЗначениеЗаполнено(Подразделение) Тогда
			ОбластьПодразделение = Макет.ПолучитьОбласть("Шапка|Подразделение");
			ОбластьПодразделение.Параметры.Подразделение = Подразделение;
			ПечатныйДокумент.Вывести(ОбластьПодразделение);
		КонецЕсли;
		Должность = СтрокаВидаРасчета.Должность;
		Если ЗначениеЗаполнено(Должность) Тогда
			ОбластьДолжность = Макет.ПолучитьОбласть("Шапка|Должность");
			ОбластьДолжность.Параметры.Должность 	= Должность; 
			ПечатныйДокумент.Вывести(ОбластьДолжность);
		КонецЕсли;
		ОбластьВидСМИлиОрганизация = Макет.ПолучитьОбласть("Шапка|ВидСМИлиОрганизация");
		Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
			ВидСхемыМотивации = СтрокаВидаРасчета.ВидСхемыМотивации;
			Если ЗначениеЗаполнено(ВидСхемыМотивации) Тогда
				ОбластьВидСМИлиОрганизация.Параметры.ВидСхемыМотивации = "Вид схемы мотивации:" + Символы.Таб + ВидСхемыМотивации;
				ПечатныйДокумент.Вывести(ОбластьВидСМИлиОрганизация);
			КонецЕсли;
		Иначе
			Организация = СтрокаВидаРасчета.Организация;
			Если ЗначениеЗаполнено(Организация) Тогда
				ОбластьВидСМИлиОрганизация.Параметры.ВидСхемыМотивации = "Организация:" + Символы.Таб + СтрокаВидаРасчета.Организация;			
				ПечатныйДокумент.Вывести(ОбластьВидСМИлиОрганизация);
			КонецЕсли;
		КонецЕсли;
		
		ВидРасчетаОбъект = ВидРасчета.ПолучитьОбъект();
		
		// Вывод на печать Вида расчета.
		Область = Макет.ПолучитьОбласть("ВидРасчета");
		Область.Параметры.ВидРасчета = ВидРасчета;
		Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
			Область.Параметры.Описание = ВидРасчетаОбъект.Комментарий;
		КонецЕсли;
		ТекущийРаздел.Вывести(Область);
		
		СтрокаВалюта = Строка(СтрокаВидаРасчета["Валюта1"]);
		
		Формула = "Размер начисления = " + ПроведениеРасчетов.ВизуализироватьФормулуРасчета(ВидРасчетаОбъект, "Текст");
		
		СпособРасчета = ВидРасчетаОбъект.СпособРасчета;
		
		Если КоличествоПоказателей > 0 Тогда
			СтрокаЗначения = "Устанавливается в размере " + Строка(СтрокаВидаРасчета.показатель1) + " "+СтрокаВалюта + " и корректируется при начислении.";
		Иначе
			СтрокаЗначения = "Корректируется при начислении.";
		КонецЕсли;
		СтрокаЗначения_2 = "Значение вводится при расчете.";	
		
		Если  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ФиксированнойСуммой Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоДоговоруФиксированнойСуммой
			Тогда
			
			// Формирование строки значения и вида показателя.		
			ВыводПоказателя(Макет, "Фиксированная сумма", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистФиксСуммойДоПредела Тогда
			
			// Формирование строки значения и вида показателя.			
			ВыводПоказателя(Макет, "Фиксированная сумма, до удержания указанной в документе суммы", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.СдельныйЗаработок Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Сдельная выработка", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.НулеваяСумма Тогда
			Значение   = 0;
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "0", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоначислениеПоУправленческомуУчету Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "От обратного", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПособиеПоУходуЗаРебенкомДо3Лет Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Пособие по уходу за ребенком до 3х лет", СтрокаЗначения, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоДневнойТарифнойСтавке Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Тарифная ставка", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавке Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Тарифная ставка", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в часах", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.Процентом Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Тарифная ставка", СтрокаЗначения, ТекущийРаздел);
				
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Расчетная база", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПроцентомОтОблагаемыхЕСННачислений Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Процент", СтрокаЗначения, ТекущийРаздел);
				
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Облагаемый ЕСН доход", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПочтовыйСбор Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Процент сбора", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Сумма по исполнительному листу", СтрокаЗначения_2, ТекущийРаздел);
						
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистПроцентом 
			Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистПроцентомДоПредела Тогда
								
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Процент удержаний", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Расчетная база", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.	
			ВыводПоказателя(Макет, "Исчисленный НДФЛ", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаВечерниеЧасы Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Часовая тарифная ставка", СтрокаЗначения, ТекущийРаздел);
									
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Процент доплаты", СтрокаЗначения_2, ТекущийРаздел);
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Вечернее время в часах", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаНочныеЧасы Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Часовая тарифная ставка", СтрокаЗначения, ТекущийРаздел);
						
			// Формирование строки значения и вида показателя.	
			ВыводПоказателя(Макет, "Процент доплаты", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Ночное время в часах", СтрокаЗначения_2, ТекущийРаздел);
					
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработку 
			Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработкуДляОтпускаПоКалендарнымДням Тогда
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Средний дневной (часовой) заработок", СтрокаЗначения, ТекущийРаздел);
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Время в днях (часах)", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработкуФСС Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Средний дневной заработок", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Время в календарных днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли  СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПособиеПоУходуЗаРебенкомДо1_5Лет Тогда
								
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Средний дневной заработок", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Число календарных дней в месяце", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Число календарных дней выплаты пособия", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработкуДляОтпускаПоШестидневке Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Средний дневной заработок", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Время в днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеПоДням Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Тарифная ставка (оклад)", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Норма времени за месяц в днях", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеПоЧасам Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Тарифная ставка (оклад)", СтрокаЗначения, ТекущийРаздел);
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Норма времени за месяц в часах", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в часах", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПоДневнойТарифнойСтавке Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Стаж", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Шкала дневной тарифной ставки", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПоМесячнойТарифнойСтавкеПоДням Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Стаж", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Шкала месячной тарифной ставки", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Норма времени за месяц в днях", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в днях", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПоЧасовойТарифнойСтавке Тогда
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Стаж", СтрокаЗначения, ТекущийРаздел);
						
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Шкала часовой тарифной ставки", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в часах", СтрокаЗначения_2, ТекущийРаздел);

		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПоМесячнойТарифнойСтавкеПоЧасам Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Стаж", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.	
			ВыводПоказателя(Макет, "Шкала месячной тарифной ставки", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.	
			ВыводПоказателя(Макет, "Норма времени за месяц в часах", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Отработанное время в часах", СтрокаЗначения_2, ТекущийРаздел);

		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПроцентом Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Стаж", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Шкала процентов оплаты", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Расчетная база", СтрокаЗначения_2, ТекущийРаздел);
			
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.СевернаяНадбавка Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Северный стаж", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Шкала надбавок", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Расчетная база", СтрокаЗначения_2, ТекущийРаздел);
				
		ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоплатаДоСреднегоЗаработка Тогда
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Средний заработок", СтрокаЗначения, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "Начислено", СтрокаЗначения_2, ТекущийРаздел);
			
			// Формирование строки значения и вида показателя.
			ВыводПоказателя(Макет, "0", СтрокаЗначения_2, ТекущийРаздел);
			
		Иначе
			
			// По все показателям данного вида расчета.
			Для позиция = 1 По КоличествоПоказателей Цикл
				
				Показатель = "";
				Значение   = 0;
				Валюта     = "";
				ТипПоказателя = "";
				ВозможностьИзменения = "";
				
				Показатель				= СведенияОВидеРасчета["Показатель" + позиция];
				Значение				= СтрокаВидаРасчета["Показатель"+позиция];
				Валюта					= СтрокаВидаРасчета["Валюта"+позиция];
				ТипПоказателя			= СтрокаВидаРасчета["ТипПоказателя"+позиция];
				Предопределенный		= СтрокаВидаРасчета["Предопределенный"+позиция];
				ВозможностьИзменения	= СтрокаВидаРасчета["ВозможностьИзменения"+позиция];
				
				// Формулировка валюты или единиц измерения.
				Если  ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Процентный Тогда
					Валюта = "% (в процентах)";
				КонецЕсли;
				
				Если  ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Числовой Тогда
					Валюта = "как число";
				КонецЕсли;
				
				// Печать показателя уместна, если показатель не пустое значение.
				Если ЗначениеЗаполнено(Показатель) Тогда
					
					
					// Печать показателей.
					
					Если  ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаПроцентная 
						Или  ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаЧисловая тогда
						
						// Печать таблицы.
						Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
						Область.Параметры.Показатель = Строка (Показатель) ;
						ТекущийРаздел.Вывести(Область);
						
						Если ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаПроцентная Тогда
							Размерность = "%";
						Иначе
							Размерность = "";
						КонецЕсли;
						
						
						// Получить таблицу оценок.
						Запрос = новый Запрос;
						Запрос.Текст = "ВЫБРАТЬ
						|	СоставШкалОценкиПоказателейРасчета.ЗначениеС,
						|	СоставШкалОценкиПоказателейРасчета.ЗначениеПо,
						|	СоставШкалОценкиПоказателейРасчета.Размер
						|ИЗ
						|	РегистрСведений.СоставШкалОценкиПоказателейРасчета КАК СоставШкалОценкиПоказателейРасчета
						|
						|ГДЕ
						|	СоставШкалОценкиПоказателейРасчета.ШкалаОценкиПоказателя.Ссылка = &Показатель";
						
						Запрос.УстановитьПараметр("Показатель",Показатель);
						
						ТаблицаОценок = Запрос.Выполнить().Выгрузить();
						
						// Печать таблицы с оценками.
						Область = Макет.ПолучитьОбласть("СтрокаТаблицы");
						
						Для Каждого СтрокаОценки из ТаблицаОценок Цикл
							Область.Параметры.От        = Строка (СтрокаОценки.ЗначениеС);
							Область.Параметры.По        = Строка (СтрокаОценки.ЗначениеПо);
							Область.Параметры.Результат = Строка (СтрокаОценки.Размер) + Размерность;
							ТекущийРаздел.Вывести(Область);
						КонецЦикла;
						
						Область = Макет.ПолучитьОбласть("КонецТаблицы");
						ТекущийРаздел.Вывести(Область);
						
					Иначе
						// Печать значения.
						Область = Макет.ПолучитьОбласть("Показатель");
						Область.Параметры.Показатель = Строка (Показатель) ;
						
						// Формирование строки значения и вида показателя.
						Если ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.НеИзменяется Тогда
							СтрокаЗначения = "Устанавливается в размере " + Строка(Значение) + " " + Строка (Валюта);
							
						ИначеЕсли ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.ИзменяетсяПриРасчете 
							Или ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.Ежемесячно Тогда
							СтрокаЗначения = "Вводится ежемесячно.";
							
						ИначеЕсли ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.ВводитсяПриРасчете Или
							НЕ ЗначениеЗаполнено(ВозможностьИзменения) Тогда
							
							Если ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Денежный Тогда
								СтрокаЗначения = "Значение и валюта вводятся при расчете.";
							ИначеЕсли Предопределенный Тогда
								СтрокаЗначения = "Значение вычисляется автоматически.";
							Иначе	
								СтрокаЗначения = "Значение вводится при расчете.";
							КонецЕсли;
						КонецЕсли;
						
						Область.Параметры.ТипПоказателя = СтрокаЗначения ;
						ТекущийРаздел.Вывести(Область);
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
				
		// Вывод на печать конца вида расчета.
		Область = Макет.ПолучитьОбласть("КонецВидаРасчета");
		Область.Параметры.Формула = Формула; 
		ТекущийРаздел.Вывести(Область);		
		
		// вывод на печать раздела.
		ПечатныйДокумент.Вывести(ТекущийРаздел);
		ТекущийРаздел.Очистить();
		
	КонецЦикла;
	
	// Вывод печатной формы на экран.
	УниверсальныеМеханизмы.НапечататьДокумент(ПечатныйДокумент,,, "Данные по схеме мотивации.");

КонецПроцедуры // ПечатьСМ()

// Формирует запрос к регистру сведений "Схемы мотиваций"
// и вызывает процедуру печати схемы мотиваций.
//
// Параметры
//  Режим  – Текст. Режим формирования запроса
//			Может принимать значения:
//				"ПоВсем" - по всей организации или по всему предприятию
//				"По подразделению" - по текущему подразделению
//				"По должности" - по текущей должности 
//  
Процедура СформироватьЗапросДляПечати(
			ВидОрганизационнойСтруктурыПредприятия,
			ВидСхемыМотивации,
			Организация,
			ПоддерживатьНесколькоСхемМотивации,
			ОбработкаКомментариев,
			ЭлементыФормы,
			Режим = "ПоВсем") Экспорт
	
	Если Режим = "По подразделению" Тогда
		Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
			Подразделение	= ЭлементыФормы.ТабличноеПолеПодразделенияПоЦФО.ТекущаяСтрока;
		Иначе
			Подразделение	= ЭлементыФормы.ТабличноеПолеПодразделенияОрганизаций.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
	Если Режим <> "ПоВсем" Тогда
		Должность		= ЭлементыФормы.ТабличноеПолеДолжности.ТекущаяСтрока;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидСхемыМотивации",ВидСхемыМотивации);
	Запрос.УстановитьПараметр("ПодразделениеНеопределено", Неопределено);
	Запрос.УстановитьПараметр("Должность", Должность);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("ВидСхемыМотивации",ВидСхемыМотивации);
	Запрос.УстановитьПараметр("Подразделение",Подразделение);
	Запрос.УстановитьПараметр("парамКонец",ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
	
	Если Режим = "По подразделению" И ЗначениеЗаполнено(Подразделение) Тогда

		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ШтатноеРасписаниеОрганизаций.Должность
			|ПОМЕСТИТЬ ВТДолжности
			|ИЗ
			|	РегистрСведений.ШтатноеРасписаниеОрганизаций КАК ШтатноеРасписаниеОрганизаций
			|ГДЕ
			|	ШтатноеРасписаниеОрганизаций.ПодразделениеОрганизации = &Подразделение";
		Иначе
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СхемыМотивацииРаботников.Должность
			|ПОМЕСТИТЬ ВТДолжности
			|ИЗ
			|	РегистрСведений.СхемыМотивацииРаботников КАК СхемыМотивацииРаботников
			|ГДЕ
			|	СхемыМотивацииРаботников.Подразделение = &Подразделение";
		КонецЕсли;
		ВТДолжности = "ВТДолжности";
		Запрос.Выполнить();
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СхемыМотивацииРаботников.ВидСхемыМотивации,
	|	СхемыМотивацииРаботников.Организация,
	|	СхемыМотивацииРаботников.Подразделение,
	|	СхемыМотивацииРаботников.Должность,
	|	СхемыМотивацииРаботников.ВидРасчета,
	|	СхемыМотивацииРаботников.Показатель1,
	|	ВЫБОР КОГДА (СхемыМотивацииРаботников.Валюта1 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта1 = Значение(Справочник.Валюты.ПустаяСсылка)) ТОГДА Показатели1.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта1 КОНЕЦ КАК Валюта1,
	|	СхемыМотивацииРаботников.Показатель2,
	|	ВЫБОР КОГДА СхемыМотивацииРаботников.Валюта2 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта2 = Значение(Справочник.Валюты.ПустаяСсылка) ТОГДА Показатели2.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта2 КОНЕЦ КАК Валюта2,
	|	СхемыМотивацииРаботников.Показатель3,
	|	ВЫБОР КОГДА СхемыМотивацииРаботников.Валюта3 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта3 = Значение(Справочник.Валюты.ПустаяСсылка) ТОГДА Показатели3.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта3 КОНЕЦ КАК Валюта3,
	|	СхемыМотивацииРаботников.Показатель4,
	|	ВЫБОР КОГДА СхемыМотивацииРаботников.Валюта4 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта4 = Значение(Справочник.Валюты.ПустаяСсылка) ТОГДА Показатели4.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта4 КОНЕЦ КАК Валюта4,
	|	СхемыМотивацииРаботников.Показатель5,
	|	ВЫБОР КОГДА СхемыМотивацииРаботников.Валюта5 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта5 = Значение(Справочник.Валюты.ПустаяСсылка) ТОГДА Показатели5.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта5 КОНЕЦ КАК Валюта5,
	|	СхемыМотивацииРаботников.Показатель6,
	|	ВЫБОР КОГДА СхемыМотивацииРаботников.Валюта6 ЕСТЬ NULL ИЛИ СхемыМотивацииРаботников.Валюта6 = Значение(Справочник.Валюты.ПустаяСсылка) ТОГДА Показатели6.Показатель.Валюта ИНАЧЕ СхемыМотивацииРаботников.Валюта6 КОНЕЦ КАК Валюта6,
	|	СхемыМотивацииРаботников.ТарифныйРазряд1,
	|	СхемыМотивацииРаботников.ТарифныйРазряд2,
	|	СхемыМотивацииРаботников.ТарифныйРазряд3,
	|	СхемыМотивацииРаботников.ТарифныйРазряд4,
	|	СхемыМотивацииРаботников.ТарифныйРазряд5,
	|	СхемыМотивацииРаботников.ТарифныйРазряд6,
	|	Показатели1.Показатель.Предопределенный КАК Предопределенный1,
	|	Показатели2.Показатель.Предопределенный КАК Предопределенный2,
	|	Показатели3.Показатель.Предопределенный КАК Предопределенный3,
	|	Показатели4.Показатель.Предопределенный КАК Предопределенный4,
	|	Показатели5.Показатель.Предопределенный КАК Предопределенный5,
	|	Показатели6.Показатель.Предопределенный КАК Предопределенный6,
	|	Показатели1.Показатель.ТипПоказателя КАК ТипПоказателя1,
	|	Показатели2.Показатель.ТипПоказателя КАК ТипПоказателя2,
	|	Показатели3.Показатель.ТипПоказателя КАК ТипПоказателя3,
	|	Показатели4.Показатель.ТипПоказателя КАК ТипПоказателя4,
	|	Показатели5.Показатель.ТипПоказателя КАК ТипПоказателя5,
	|	Показатели6.Показатель.ТипПоказателя КАК ТипПоказателя6,
	|	Показатели1.Показатель.ВозможностьИзменения КАК ВозможностьИзменения1,
	|	Показатели2.Показатель.ВозможностьИзменения КАК ВозможностьИзменения2,
	|	Показатели3.Показатель.ВозможностьИзменения КАК ВозможностьИзменения3,
	|	Показатели4.Показатель.ВозможностьИзменения КАК ВозможностьИзменения4,
	|	Показатели5.Показатель.ВозможностьИзменения КАК ВозможностьИзменения5,
	|	Показатели6.Показатель.ВозможностьИзменения КАК ВозможностьИзменения6
	|ПОМЕСТИТЬ ВТПоказатели
	|ИЗ
	|	РегистрСведений.СхемыМотивацииРаботников КАК СхемыМотивацииРаботников";
	Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели1
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели1.Ссылка
		|			И (Показатели1.НомерСтроки = 1)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели2
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели2.Ссылка
		|			И (Показатели2.НомерСтроки = 2)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели3
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели3.Ссылка
		|			И (Показатели3.НомерСтроки = 3)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели4
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели4.Ссылка
		|			И (Показатели4.НомерСтроки = 4)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели5
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели5.Ссылка
		|			И (Показатели5.НомерСтроки = 5)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК Показатели6
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели6.Ссылка
		|			И (Показатели6.НомерСтроки = 6)
		|ГДЕ
		|	СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.ОсновныеНачисленияОрганизаций";
		Если Режим <> "ПоВсем" Тогда
			ТекстЗапроса = ТекстЗапроса + "
		|	И СхемыМотивацииРаботников.Организация <> Значение(Справочник.Организации.ПустаяСсылка)";
		КонецЕсли;
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели1
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели1.Ссылка
		|			И (Показатели1.НомерСтроки = 1)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели2
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели2.Ссылка
		|			И (Показатели2.НомерСтроки = 2)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели3
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели3.Ссылка
		|			И (Показатели3.НомерСтроки = 3)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели4
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели4.Ссылка
		|			И (Показатели4.НомерСтроки = 4)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели5
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели5.Ссылка
		|			И (Показатели5.НомерСтроки = 5)
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УправленческиеНачисления.Показатели КАК Показатели6
		|		ПО СхемыМотивацииРаботников.ВидРасчета = Показатели6.Ссылка
		|			И (Показатели6.НомерСтроки = 6)
		
		|ГДЕ
		|	СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.УправленческиеНачисления
		|	И СхемыМотивацииРаботников.Организация = Значение(Справочник.Организации.ПустаяСсылка)
		|";
		Если ПоддерживатьНесколькоСхемМотивации = Неопределено Тогда
			глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналу").Свойство("ПоддерживатьНесколькоСхемМотивации",ПоддерживатьНесколькоСхемМотивации);
		КонецЕсли;
		Если ПоддерживатьНесколькоСхемМотивации Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|	И СхемыМотивацииРаботников.ВидСхемыМотивации = &ВидСхемыМотивации";
		КонецЕсли;
	КонецЕсли;

	Если Режим = "По подразделению" И ЗначениеЗаполнено(Подразделение) Тогда
		ТекстЗапроса = ТекстЗапроса + "
	|	И (СхемыМотивацииРаботников.Подразделение = &Подразделение
	|	ИЛИ СхемыМотивацииРаботников.Подразделение = &ПодразделениеНеопределено И Должность В (ВЫБРАТЬ Должность ИЗ ВТДолжности))";
	ИначеЕсли Режим = "По должности" Тогда
		ТекстЗапроса = ТекстЗапроса + "
	|	И СхемыМотивацииРаботников.Должность = &Должность
	|	И СхемыМотивацииРаботников.Подразделение = &ПодразделениеНеопределено";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|ИНДЕКСИРОВАТЬ ПО
	|ТарифныйРазряд1, ТарифныйРазряд2, ТарифныйРазряд3, ТарифныйРазряд4, ТарифныйРазряд5, ТарифныйРазряд6;
	
	|ВЫБРАТЬ 
	|	ТарифныеСтавки.ТарифныйРазряд,
	|	ТарифныеСтавки.Размер,
	|	ТарифныеСтавки.Валюта
	|ПОМЕСТИТЬ ВТТарифныеСтавки
	|ИЗ РегистрСведений.РазмерТарифныхСтавок.СрезПоследних(&парамКонец, ) КАК ТарифныеСтавки
	|ИНДЕКСИРОВАТЬ ПО ТарифныйРазряд;
	|
	|ВЫБРАТЬ
	|	Показатели.ВидСхемыМотивации,
	|	Показатели.Организация,
	|	Показатели.Подразделение,
	|	Показатели.Должность,
	|	Показатели.ВидРасчета,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя1 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки1.Размер
	|		ИНАЧЕ	Показатели.Показатель1
	|	КОНЕЦ КАК Показатель1,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя1 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки1.Валюта
	|		ИНАЧЕ	Показатели.Валюта1
	|	КОНЕЦ КАК Валюта1,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя2 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки2.Размер
	|		ИНАЧЕ	Показатели.Показатель2
	|	КОНЕЦ КАК Показатель2,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя2 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки2.Валюта
	|		ИНАЧЕ Показатели.Валюта2
	|	КОНЕЦ КАК Валюта2,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя3 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки3.Размер
	|		ИНАЧЕ	Показатели.Показатель3
	|	КОНЕЦ КАК Показатель3,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя3 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки3.Валюта
	|		ИНАЧЕ Показатели.Валюта3
	|	КОНЕЦ КАК Валюта3,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя4 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки4.Размер
	|		ИНАЧЕ	Показатели.Показатель4
	|	КОНЕЦ КАК Показатель4,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя4 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки4.Валюта
	|		ИНАЧЕ Показатели.Валюта4
	|	КОНЕЦ КАК Валюта4,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя5 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки5.Размер
	|		ИНАЧЕ	Показатели.Показатель5
	|	КОНЕЦ КАК Показатель5,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя5 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки5.Валюта
	|		ИНАЧЕ	Показатели.Валюта5
	|	КОНЕЦ КАК Валюта5,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя6 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки6.Размер
	|		ИНАЧЕ	Показатели.Показатель6
	|	КОНЕЦ КАК Показатель6,
	|	ВЫБОР
	|		КОГДА Показатели.ТипПоказателя6 = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ТарифныеСтавки6.Валюта
	|		ИНАЧЕ	Показатели.Валюта6
	|	КОНЕЦ КАК Валюта6,
	|	Показатели.Предопределенный1,
	|	Показатели.Предопределенный2,
	|	Показатели.Предопределенный3,
	|	Показатели.Предопределенный4,
	|	Показатели.Предопределенный5,
	|	Показатели.Предопределенный6,
	|	Показатели.ТипПоказателя1,
	|	Показатели.ТипПоказателя2,
	|	Показатели.ТипПоказателя3,
	|	Показатели.ТипПоказателя4,
	|	Показатели.ТипПоказателя5,
	|	Показатели.ТипПоказателя6,
	|	Показатели.ВозможностьИзменения1,
	|	Показатели.ВозможностьИзменения2,
	|	Показатели.ВозможностьИзменения3,
	|	Показатели.ВозможностьИзменения4,
	|	Показатели.ВозможностьИзменения5,
	|	Показатели.ВозможностьИзменения6
	|ИЗ ВТПоказатели КАК Показатели
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки1
	|		ПО Показатели.ТарифныйРазряд1 = ТарифныеСтавки1.ТарифныйРазряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки2
	|		ПО Показатели.ТарифныйРазряд2 = ТарифныеСтавки2.ТарифныйРазряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки3
	|		ПО Показатели.ТарифныйРазряд3 = ТарифныеСтавки3.ТарифныйРазряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки4
	|		ПО Показатели.ТарифныйРазряд4 = ТарифныеСтавки4.ТарифныйРазряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки5
	|		ПО Показатели.ТарифныйРазряд5 = ТарифныеСтавки5.ТарифныйРазряд
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТарифныеСтавки КАК ТарифныеСтавки6
	|		ПО Показатели.ТарифныйРазряд6 = ТарифныеСтавки6.ТарифныйРазряд
	|УПОРЯДОЧИТЬ ПО
	|	Показатели.ВидСхемыМотивации.Наименование,
	|	Показатели.Организация.Наименование,";
	Если Режим = "По подразделению" Или Режим = "По подразделению" Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	Показатели.Должность,
		|	Показатели.ВидРасчета";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	Показатели.Подразделение.Наименование,
		|	Показатели.Должность.Наименование,
		|	Показатели.ВидРасчета.ЗачетОтработанногоВремени,
		|	Показатели.ВидРасчета.Наименование";
	КонецЕсли;

	
	Запрос.Текст = ТекстЗапроса;
	
	//Запрос.Выполнить().Выгрузить().ВыбратьСтроку();
	
	РезультатЗапроса = Запрос.Выполнить();
		
	Если РезультатЗапроса.Пустой() Тогда
		ОбработкаКомментариев.УдалитьСообщения();
		Если Режим = "По должности" Тогда
			Если Должность = Неопределено Тогда
				ОбработкаКомментариев.ДобавитьСообщение("Не выбрана должность!", Перечисления.ВидыСообщений.Информация);
			Иначе
				Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
					ОбработкаКомментариев.ДобавитьСообщение("Для организации "+ Организация = " по должности: "+ Должность +" не введены начисления!", Перечисления.ВидыСообщений.Информация);
				Иначе
					ОбработкаКомментариев.ДобавитьСообщение("По должности: "+ Должность +" не введены начисления!", Перечисления.ВидыСообщений.Информация);
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Режим = "По подразделению" Тогда
			Если Подразделение = Неопределено Тогда
				ОбработкаКомментариев.ДобавитьСообщение("Не выбрана должность!", Перечисления.ВидыСообщений.Информация);
			Иначе
				Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
					ОбработкаКомментариев.ДобавитьСообщение("Для организации "+ Организация = " подразделению: "+ Подразделение +" не введены начисления!", Перечисления.ВидыСообщений.Информация);
				Иначе
					ОбработкаКомментариев.ДобавитьСообщение("По подразделению: "+ Подразделение +" не введены начисления!", Перечисления.ВидыСообщений.Информация);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ОбработкаКомментариев.ДобавитьСообщение("Отсутствуют начисления!", Перечисления.ВидыСообщений.Информация);
		КонецЕсли;
		
		ОбработкаКомментариев.ПоказатьСообщения();
		
		Возврат;
		
	КонецЕсли;
	ТаблицаВидовРасчета = РезультатЗапроса.Выгрузить();

	ПечатьСМ(ТаблицаВидовРасчета, ВидОрганизационнойСтруктурыПредприятия);

КонецПроцедуры //СформироватьЗапросДляПечати

#КонецЕсли

