
#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет табличный документ
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//
Процедура СформироватьОтчет(ДокументРезультат) Экспорт

	Отказ = Ложь;
	
	// Проверка параметров
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("Не указана организация!"), Отказ);
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Не указан налоговый период!", Отказ);
	КонецЕсли; 
	Если Отказ Тогда
		Возврат ;
	КонецЕсли; 	
	
	ДокументРезультат.Очистить();
	Макет =	ПолучитьМакет("СводнаяКарточкаЕСН");

	// Расчет вычисляемых параметров
	ДатаНачалаНП = НачалоГода(Дата(НалоговыйПериод,1,1));
	ДатаКонцаНП = КонецГода(Дата(НалоговыйПериод,1,1));
	
	НалоговыйУчет.ОбновитьДанныеУчетнойПолитикиПоНалоговомуУчету(глЗначениеПеременной("УчетнаяПолитикаОтраженияЗарплатыВУчете"), ДатаНачалаНП, Организация);
	УчетнаяПолитика = глЗначениеПеременной("УчетнаяПолитикаОтраженияЗарплатыВУчете")[КонецМесяца(ДатаНачалаНП)][Организация];
	
	// Создание запроса и установка всех необходимых параметров
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц; 
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОбщегоНазначения.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("парамГоловнаяОрганизация", ОбщегоНазначения.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("НачалоНП", ДатаНачалаНП);
	Запрос.УстановитьПараметр("ГодНП", НалоговыйПериод);
	Запрос.УстановитьПараметр("КонецНП", ДатаКонцаНП);
	
	// ---------------------------------------------------------------------------
	// Тексты запросов
	//

	// Сформируем текст запроса выборки месяцев налогового периода
	МесяцыНПТекст = "ВЫБРАТЬ 1 КАК МЕСЯЦ ПОМЕСТИТЬ ВТМесяцыНП";
	Для Сч = 2 По 12 Цикл
    	МесяцыНПТекст = МесяцыНПТекст +" ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ " + Сч;
	КонецЦикла;
	
	Запрос.Текст = МесяцыНПТекст;
	МассивЗапросов = Новый Массив;
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	Запрос.Выполнить();
	
	// первый месяц
	КонецМесяца = КонецМесяца(ДатаНачалаНП);
	ПериодыТекст = "ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(КонецМесяца,"ДФ=гггг,М,д,Ч,м,с") + ") КАК Период ПОМЕСТИТЬ ВТПериоды";
	// прибавим остальные месяцы
	Для Сч = 2 По 12 Цикл
		КонецМесяца = КонецМесяца(КонецМесяца+1);
		ПериодыТекст = ПериодыТекст +" ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(КонецМесяца,"ДФ=гггг,М,д,Ч,м,с") + ")";
	КонецЦикла;
	
	Запрос.Текст = ПериодыТекст;
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	Запрос.Выполнить();
	
	// УчетнаяПолитикаНалоговыйУчет
	// Таблица УчетнаяПолитикаНалоговыйУчетУСН - это список периодов, когда организация переходила на УСН
	// поля:
	//		УСН, 
	//		Месяц - месяц налогового периода
	
	Запрос.Текст = ЗаполнениеРегламентированнойОтчетностиПереопределяемый.ТекстЗапросаУСН();
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	Запрос.Выполнить();
	
	ДанныеОбОрганизации = 
	"ВЫБРАТЬ
	|	Организации.ИНН,
	|	Организации.КПП,
	|	ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(300)) КАК НаименованиеПолное
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация";
									   
	//-----------------------------------------------------------------------------
	// ВЫБОРКА СВЕДЕНИЙ О ФИЗЛИЦЕ 
	// 	

	// ДанныеОПравеНаПенсию
	// Таблица Таблица Данные о праве на пенсию: - таблица это список иностранцев и периодов
	// Поля:
	//		Физлицо, 
	//		Месяц - месяц налогового периода
	// 
	// Описание:
	//	Выбираем Из Списка периодов
	//	Внутреннее соединение с ГражданствоФизЛиц.СрезПоследних
	//  по равенству периодов
	//  условие: что физлицо - не имеет права на пенсию
	//
	
    // УчетнаяПолитикаНалоговыйУчет
	// Таблица УчетнаяПолитикаНалоговыйУчетУСН - это список периодов, когда организация переходила на УСН
	// поля:
	//		УСН, 
	//		Месяц - месяц налогового периода
	
	// ДоходыПоМесяцамКодамТекст
	// Таблица доходов ЕСН по Месяцам налогового периода и кодам дохода
    // Поля:
	//		Месяц
	//		ФизЛицо
	//		КодДоходаЕСН
	//		Результат
	//		Скидка
	// Описание:
	// 	Выбираем зарегистрированные доходы из ЕСНСведенияОДоходах 	
	//  Запрос выполняется для списка обособленных подразделений.
	
	// ПоказателиДоходовПоМесяцам
	// Описание:
	//  Вычисляет показатели отчета, основанные на сведениях о доходах
					 
	// ПоказателиДоходовНарастающимИтогом
	// Описание:
	//  Вычисляет показатели отчета, основанные на сведениях о доходах - нарастающим итогом
	
	// ПоказателиНалогПоМесяцам
	// Описание:
	//	Вычисляет показатели отчета, основанные на сведениях о налогах.
	//  Из по ЕСН автоматически отнимается налог, приходящийся  на налоговую льготу инвалидов.
	
	// ПоказателиНалоговНарастающимИтогом
	// Описание:
	//  Вычисляет показатели отчета, основанные на сведениях о налогах - нарастающим итогом
	
	//ДанныеРасчетаТекст
	// Описание: объединяет показатели доходов и налогов и рассчитывает колонку 29						   
	
	ДанныеРасчетаТекст = 
	"ВЫБРАТЬ
	|	ЕСНСведенияОДоходах.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТФизлицаБезНалоговойБазы
	|ИЗ
	|	РегистрНакопления.ЕСНСведенияОДоходах КАК ЕСНСведенияОДоходах
	|ГДЕ
	|	ЕСНСведенияОДоходах.Период МЕЖДУ &НачалоНП И &КонецНП
	|	И ЕСНСведенияОДоходах.Организация = &ГоловнаяОрганизация
	|	И (НЕ ЕСНСведенияОДоходах.ОблагаетсяЕНВД)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСНСведенияОДоходах.ФизЛицо
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВЫБОР
	|			КОГДА ЕСНСведенияОДоходах.КодДоходаЕСН.ВходитВБазуФОМС
	|				ТОГДА ЕСНСведенияОДоходах.Результат - ЕСНСведенияОДоходах.Скидка
	|			ИНАЧЕ 0
	|		КОНЕЦ) < 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МЕСЯЦ(ЕСННачисления.Период) КАК Месяц,
	|	ЕСННачисления.ФизЛицо КАК ФизЛицо,
	|	ЕСННачисления.КодДоходаЕСН КАК КодДоходаЕСН,
	|	СУММА(ЕСННачисления.Результат) КАК Результат,
	|	СУММА(ЕСННачисления.Скидка) КАК Скидка
	|ПОМЕСТИТЬ ВТДоходыПоМесяцамКодам
	|ИЗ
	|	РегистрНакопления.ЕСНСведенияОДоходах КАК ЕСННачисления
	|ГДЕ
	|	ЕСННачисления.Период МЕЖДУ &НачалоНП И &КонецНП
	|	И ЕСННачисления.Организация = &ГоловнаяОрганизация
	|	И (НЕ ЕСННачисления.ОблагаетсяЕНВД)
	|	И ЕСННачисления.ОбособленноеПодразделение = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	МЕСЯЦ(ЕСННачисления.Период),
	|	ЕСННачисления.ФизЛицо,
	|	ЕСННачисления.КодДоходаЕСН
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц,
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МЕСЯЦ(Периоды.Период) КАК Месяц,
	|	ГражданствоФизЛиц.ФизЛицо КАК Физлицо
	|ПОМЕСТИТЬ ВТДанныеОПравеНаПенсию
	|ИЗ
	|	(ВЫБРАТЬ
	|		Периоды.Период КАК Период,
	|		ГражданствоФизЛиц.ФизЛицо КАК Физлицо,
	|		МАКСИМУМ(ГражданствоФизЛиц.Период) КАК ПериодРегистра
	|	ИЗ
	|		ВТПериоды КАК Периоды
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц КАК ГражданствоФизЛиц
	|			ПО Периоды.Период >= ГражданствоФизЛиц.Период
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ГражданствоФизЛиц.ФизЛицо,
	|		Периоды.Период) КАК Периоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц КАК ГражданствоФизЛиц
	|		ПО Периоды.ПериодРегистра = ГражданствоФизЛиц.Период
	|			И Периоды.Физлицо = ГражданствоФизЛиц.ФизЛицо
	|			И (ГражданствоФизЛиц.НеИмеетПравоНаПенсию)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц,
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Доходы.Месяц КАК Месяц,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|					И Доходы.КодДоходаЕСН.ВходитВБазуФедеральныйБюджет
	|					И ФизлицаБезНалоговойБазы.ФизЛицо ЕСТЬ NULL 
	|				ТОГДА Доходы.Результат - Доходы.Скидка
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НалоговаяБазаФБ,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|					И Доходы.КодДоходаЕСН.ВходитВБазуФедеральныйБюджет
	|					И ФизлицаБезНалоговойБазы.ФизЛицо ЕСТЬ NULL 
	|					И Иностр.Физлицо ЕСТЬ NULL 
	|				ТОГДА Доходы.Результат - Доходы.Скидка
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК БазаПФР,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|					И Доходы.КодДоходаЕСН.ВходитВБазуФСС
	|					И ФизлицаБезНалоговойБазы.ФизЛицо ЕСТЬ NULL 
	|				ТОГДА Доходы.Результат - Доходы.Скидка
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НалоговаяБазаФСС,
	|	СУММА(ВЫБОР
	|			КОГДА (НЕ Доходы.КодДоходаЕСН В (ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.НеЯвляетсяОбъектом), ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДенежноеДовольствиеВоеннослужащих)))
	|				ТОГДА Доходы.Результат
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НачисленоВсего,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ВыплатыЗаСчетПрибыли)
	|				ТОГДА Доходы.Результат
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВыплатыЗаСчетПрибыли,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН В (ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ПособияЗаСчетФСС), ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.НеОблагаетсяЦеликом))
	|				ТОГДА Доходы.Результат
	|			КОГДА Доходы.КодДоходаЕСН В (ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДоговораГПХ), ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДоговораАвторские))
	|				ТОГДА 0
	|			ИНАЧЕ Доходы.Скидка
	|		КОНЕЦ) КАК НеОблагаетсяПоСт238КромеДоговоров,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДоговораГПХ)
	|				ТОГДА Доходы.Результат
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДоговораАвторские)
	|				ТОГДА Доходы.Результат - Доходы.Скидка
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВыплатыПоДоговорам,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДенежноеДовольствиеВоеннослужащих)
	|				ТОГДА Доходы.Результат
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ДенежноеДовольствиеВоеннослужащих,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ДенежноеСодержаниеПрокуроров)
	|				ТОГДА Доходы.Результат
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВыплатыПрокуроров,
	|	СУММА(ВЫБОР
	|			КОГДА Доходы.КодДоходаЕСН = ЗНАЧЕНИЕ(Справочник.ДоходыЕСН.ПособияЗаСчетФСС)
	|				ТОГДА Доходы.Результат
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПособияЗаСчетФСС
	|ПОМЕСТИТЬ ВТПоказателиДоходовПоМесяцам
	|ИЗ
	|	ВТДоходыПоМесяцамКодам КАК Доходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизлицаБезНалоговойБазы КАК ФизлицаБезНалоговойБазы
	|		ПО Доходы.ФизЛицо = ФизлицаБезНалоговойБазы.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОПравеНаПенсию КАК Иностр
	|		ПО Доходы.Месяц = Иностр.Месяц
	|			И Доходы.ФизЛицо = Иностр.Физлицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчетУСН
	|		ПО Доходы.Месяц = УчетнаяПолитикаНалоговыйУчетУСН.Месяц
	|
	|СГРУППИРОВАТЬ ПО
	|	Доходы.Месяц
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МесяцыНП.Месяц КАК Месяц,
	|	СУММА(ПоказателиДоходов.НалоговаяБазаФБ) КАК НалоговаяБазаФБ,
	|	СУММА(ПоказателиДоходов.БазаПФР) КАК БазаПФР,
	|	СУММА(ПоказателиДоходов.НалоговаяБазаФСС) КАК НалоговаяБазаФСС,
	|	СУММА(ПоказателиДоходов.НачисленоВсего) КАК НачисленоВсего,
	|	СУММА(ПоказателиДоходов.ВыплатыЗаСчетПрибыли) КАК ВыплатыЗаСчетПрибыли,
	|	СУММА(ПоказателиДоходов.НеОблагаетсяПоСт238КромеДоговоров) КАК НеОблагаетсяПоСт238КромеДоговоров,
	|	СУММА(ПоказателиДоходов.ВыплатыПоДоговорам) КАК ВыплатыПоДоговорам,
	|	СУММА(ПоказателиДоходов.ВыплатыПрокуроров) КАК ВыплатыПрокуроров,
	|	СУММА(ПоказателиДоходов.ДенежноеДовольствиеВоеннослужащих) КАК ДенежноеДовольствиеВоеннослужащих,
	|	СУММА(ПоказателиДоходов.ПособияЗаСчетФСС) КАК ПособияЗаСчетФСС
	|ПОМЕСТИТЬ ВТПоказателиДоходовНарастающимИтогом
	|ИЗ
	|	ВТМесяцыНП КАК МесяцыНП
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиДоходовПоМесяцам КАК ПоказателиДоходов
	|		ПО МесяцыНП.Месяц >= ПоказателиДоходов.Месяц
	|
	|СГРУППИРОВАТЬ ПО
	|	МесяцыНП.Месяц
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МЕСЯЦ(ЕСНИсчисленный.Период) КАК Месяц,
	|	СУММА(ЕСНИсчисленный.ФедеральныйБюджет) КАК ИсчисленоФБ,
	|	СУММА(ЕСНИсчисленный.ФСС) КАК ИсчисленоФСС,
	|	СУММА(ЕСНИсчисленный.ФФОМС) КАК ИсчисленоФФОМС,
	|	СУММА(ЕСНИсчисленный.ТФОМС) КАК ИсчисленоТФОМС,
	|	СУММА(ЕСНИсчисленный.ПримененнаяЛьготаФБ * (Ставки.ФедеральныйБюджетВПроцентах - Ставки.ПФРНакопительная1вПроцентах - Ставки.ПФРСтраховая1вПроцентах)) / 100 КАК НеПодлежитФБ,
	|	СУММА(ЕСНИсчисленный.ПримененнаяЛьготаФСС * Ставки.ФССвПроцентах / 100) КАК НеПодлежитФСС,
	|	СУММА(ЕСНИсчисленный.ПримененнаяЛьготаФОМС * Ставки.ФФОМСвПроцентах / 100) КАК НеПодлежитФФОМС,
	|	СУММА(ЕСНИсчисленный.ПримененнаяЛьготаФОМС * Ставки.ТФОМСвПроцентах / 100) КАК НеПодлежитТФОМС,
	|	СУММА(ЕСНИсчисленный.ФедеральныйБюджет - ЕСНИсчисленный.ПримененнаяЛьготаФБ * (Ставки.ФедеральныйБюджетВПроцентах - Ставки.ПФРНакопительная1вПроцентах - Ставки.ПФРСтраховая1вПроцентах) / 100 - ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|				ТОГДА ЕСНИсчисленный.ПФРСтраховая - ЕСНИсчисленный.ПФРСтраховаяЕНВД + ЕСНИсчисленный.ПФРНакопительная - ЕСНИсчисленный.ПФРНакопительнаяЕНВД
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НачисленоФБ,
	|	СУММА(ЕСНИсчисленный.ФСС - ЕСНИсчисленный.ПримененнаяЛьготаФСС * Ставки.ФССвПроцентах / 100) КАК НачисленоФСС,
	|	СУММА(ЕСНИсчисленный.ФФОМС - ЕСНИсчисленный.ПримененнаяЛьготаФОМС * Ставки.ФФОМСвПроцентах / 100) КАК НачисленоФФОМС,
	|	СУММА(ЕСНИсчисленный.ТФОМС - ЕСНИсчисленный.ПримененнаяЛьготаФОМС * Ставки.ТФОМСвПроцентах / 100) КАК НачисленоТФОМС,
	|	СУММА(ЕСНИсчисленный.ПримененнаяЛьготаФБ) КАК ПримененнаяЛьготаИнвалида,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|				ТОГДА ЕСНИсчисленный.ПФРНакопительная - ЕСНИсчисленный.ПФРНакопительнаяЕНВД
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НачисленоПФРНакопительная,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|				ТОГДА ЕСНИсчисленный.ПФРСтраховая - ЕСНИсчисленный.ПФРСтраховаяЕНВД
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НачисленоПФРСтраховая,
	|	СУММА(ВЫБОР
	|			КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL 
	|				ТОГДА ЕСНИсчисленный.ПФРСтраховая - ЕСНИсчисленный.ПФРСтраховаяЕНВД + ЕСНИсчисленный.ПФРНакопительная - ЕСНИсчисленный.ПФРНакопительнаяЕНВД
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НачисленоПФР
	|ПОМЕСТИТЬ ВТПоказателиНалоговПоМесяцам
	|ИЗ
	|	РегистрНакопления.ЕСНИсчисленный КАК ЕСНИсчисленный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчетУСН
	|		ПО (МЕСЯЦ(ЕСНИсчисленный.Период) = УчетнаяПолитикаНалоговыйУчетУСН.Месяц)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОСтавкахЕСНиПФР КАК Ставки
	|		ПО (Ставки.Год = &ГодНП)
	|			И (Ставки.НомерСтрокиСтавок = 1)
	|			И ЕСНИсчисленный.Организация.ВидСтавокЕСНиПФР = Ставки.ВидСтавокЕСНиПФР
	|ГДЕ
	|	ЕСНИсчисленный.Период МЕЖДУ &НачалоНП И &КонецНП
	|	И ЕСНИсчисленный.ОбособленноеПодразделение = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	МЕСЯЦ(ЕСНИсчисленный.Период),
	|	Ставки.ФедеральныйБюджетВПроцентах,
	|	Ставки.ПФРНакопительная1вПроцентах,
	|	Ставки.ПФРСтраховая1вПроцентах,
	|	Ставки.ФССвПроцентах,
	|	Ставки.ФФОМСвПроцентах,
	|	Ставки.ТФОМСвПроцентах
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МесяцыНП.Месяц КАК Месяц,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.ИсчисленоФБ) КАК ЧИСЛО(15, 1)) КАК ИсчисленоФБ,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.ИсчисленоФСС) КАК ЧИСЛО(15, 1)) КАК ИсчисленоФСС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.ИсчисленоФФОМС) КАК ЧИСЛО(15, 1)) КАК ИсчисленоФФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.ИсчисленоТФОМС) КАК ЧИСЛО(15, 1)) КАК ИсчисленоТФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НеПодлежитФБ) КАК ЧИСЛО(15, 1)) КАК НеПодлежитФБ,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НеПодлежитФСС) КАК ЧИСЛО(15, 1)) КАК НеПодлежитФСС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НеПодлежитФФОМС) КАК ЧИСЛО(15, 1)) КАК НеПодлежитФФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НеПодлежитТФОМС) КАК ЧИСЛО(15, 1)) КАК НеПодлежитТФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоФБ) КАК ЧИСЛО(15, 1)) КАК НачисленоФБ,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоФСС) КАК ЧИСЛО(15, 1)) КАК НачисленоФСС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоФФОМС) КАК ЧИСЛО(15, 1)) КАК НачисленоФФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоТФОМС) КАК ЧИСЛО(15, 1)) КАК НачисленоТФОМС,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.ПримененнаяЛьготаИнвалида) КАК ЧИСЛО(15, 1)) КАК ПримененнаяЛьготаИнвалида,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоПФРНакопительная) КАК ЧИСЛО(15, 3)) КАК НачисленоПФРНакопительная,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоПФРСтраховая) КАК ЧИСЛО(15, 3)) КАК НачисленоПФРСтраховая,
	|	ВЫРАЗИТЬ(СУММА(ПоказателиНалогов.НачисленоПФР) КАК ЧИСЛО(15, 3)) КАК НачисленоПФР
	|ПОМЕСТИТЬ ВТПоказателиНалоговНарастающимИтогом
	|ИЗ
	|	ВТМесяцыНП КАК МесяцыНП
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНалоговПоМесяцам КАК ПоказателиНалогов
	|		ПО МесяцыНП.Месяц >= ПоказателиНалогов.Месяц
	|
	|СГРУППИРОВАТЬ ПО
	|	МесяцыНП.Месяц
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МесяцыНП.Месяц КАК Месяц,
	|	ПоказателиДоходов.НалоговаяБазаФБ,
	|	ПоказателиДоходовНарастающимИтогом.НалоговаяБазаФБ КАК НарастНалоговаяБазаФБ,
	|	ПоказателиДоходов.БазаПФР,
	|	ПоказателиДоходовНарастающимИтогом.БазаПФР КАК НарастБазаПФР,
	|	ПоказателиДоходов.НалоговаяБазаФСС,
	|	ПоказателиДоходовНарастающимИтогом.НалоговаяБазаФСС КАК НарастНалоговаяБазаФСС,
	|	ПоказателиДоходов.НачисленоВсего,
	|	ПоказателиДоходовНарастающимИтогом.НачисленоВсего КАК НарастНачисленоВсего,
	|	ПоказателиДоходов.ВыплатыЗаСчетПрибыли,
	|	ПоказателиДоходовНарастающимИтогом.ВыплатыЗаСчетПрибыли КАК НарастВыплатыЗаСчетПрибыли,
	|	ПоказателиДоходов.НеОблагаетсяПоСт238КромеДоговоров,
	|	ПоказателиДоходовНарастающимИтогом.НеОблагаетсяПоСт238КромеДоговоров КАК НарастНеОблагаетсяПоСт238КромеДоговоров,
	|	ПоказателиДоходов.ВыплатыПоДоговорам,
	|	ПоказателиДоходовНарастающимИтогом.ВыплатыПоДоговорам КАК НарастВыплатыПоДоговорам,
	|	ПоказателиДоходов.ПособияЗаСчетФСС,
	|	ПоказателиДоходовНарастающимИтогом.ПособияЗаСчетФСС КАК НарастПособияЗаСчетФСС,
	|	ПоказателиДоходов.ВыплатыПрокуроров,
	|	ПоказателиДоходовНарастающимИтогом.ВыплатыПрокуроров КАК НарастВыплатыПрокуроров,
	|	ПоказателиДоходов.ДенежноеДовольствиеВоеннослужащих,
	|	ПоказателиДоходовНарастающимИтогом.ДенежноеДовольствиеВоеннослужащих КАК НарастДенежноеДовольствиеВоеннослужащих,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФБ - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.ИсчисленоФБ, 0) КАК ИсчисленоФБ,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФБ КАК НарастИсчисленоФБ,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФСС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.ИсчисленоФСС, 0) КАК ИсчисленоФСС,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФСС КАК НарастИсчисленоФСС,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.ИсчисленоФФОМС, 0) КАК ИсчисленоФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоФФОМС КАК НарастИсчисленоФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоТФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.ИсчисленоТФОМС, 0) КАК ИсчисленоТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.ИсчисленоТФОМС КАК НарастИсчисленоТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФБ - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НеПодлежитФБ, 0) КАК НеПодлежитФБ,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФБ КАК НарастНеПодлежитФБ,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФСС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НеПодлежитФСС, 0) КАК НеПодлежитФСС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФСС КАК НарастНеПодлежитФСС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НеПодлежитФФОМС, 0) КАК НеПодлежитФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитФФОМС КАК НарастНеПодлежитФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитТФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НеПодлежитТФОМС, 0) КАК НеПодлежитТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НеПодлежитТФОМС КАК НарастНеПодлежитТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФБ - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоФБ, 0) КАК НачисленоФБ,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФБ КАК НарастНачисленоФБ,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФСС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоФСС, 0) КАК НачисленоФСС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФСС КАК НарастНачисленоФСС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоФФОМС, 0) КАК НачисленоФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоФФОМС КАК НарастНачисленоФФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоТФОМС - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоТФОМС, 0) КАК НачисленоТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоТФОМС КАК НарастНачисленоТФОМС,
	|	ПоказателиНалоговНарастающимИтогом.ПримененнаяЛьготаИнвалида - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.ПримененнаяЛьготаИнвалида, 0) КАК ПримененнаяЛьготаИнвалида,
	|	ПоказателиНалоговНарастающимИтогом.ПримененнаяЛьготаИнвалида КАК НарастПримененнаяЛьготаИнвалида,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФРНакопительная - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоПФРНакопительная, 0) КАК НачисленоПФРНакопительная,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФРНакопительная КАК НарастНачисленоПФРНакопительная,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФРСтраховая - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоПФРСтраховая, 0) КАК НачисленоПФРСтраховая,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФРСтраховая КАК НарастНачисленоПФРСтраховая,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФР - ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоПФР, 0) КАК НачисленоПФР,
	|	ПоказателиНалоговНарастающимИтогом.НачисленоПФР КАК НарастНачисленоПФР,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПоказателиНалоговНарастающимИтогом.НачисленоФСС, 0) > ЕСТЬNULL(ПоказателиДоходовНарастающимИтогом.ПособияЗаСчетФСС, 0)
	|			ТОГДА ЕСТЬNULL(ПоказателиНалоговНарастающимИтогом.НачисленоФСС, 0) - ЕСТЬNULL(ПоказателиДоходовНарастающимИтогом.ПособияЗаСчетФСС, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоФСС, 0) > ЕСТЬNULL(ПоказателиДоходовПоПрошлыйМесяц.ПособияЗаСчетФСС, 0)
	|			ТОГДА ЕСТЬNULL(ПоказателиНалоговПоПрошлыйМесяц.НачисленоФСС, 0) - ЕСТЬNULL(ПоказателиДоходовПоПрошлыйМесяц.ПособияЗаСчетФСС, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КНачислениюФСС,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПоказателиНалоговНарастающимИтогом.НачисленоФСС, 0) > ЕСТЬNULL(ПоказателиДоходовНарастающимИтогом.ПособияЗаСчетФСС, 0)
	|			ТОГДА ЕСТЬNULL(ПоказателиНалоговНарастающимИтогом.НачисленоФСС, 0) - ЕСТЬNULL(ПоказателиДоходовНарастающимИтогом.ПособияЗаСчетФСС, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НарастКНачислениюФСС
	|ИЗ
	|	ВТМесяцыНП КАК МесяцыНП
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиДоходовПоМесяцам КАК ПоказателиДоходов
	|		ПО МесяцыНП.Месяц = ПоказателиДоходов.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНалоговПоМесяцам КАК ПоказателиНалогов
	|		ПО МесяцыНП.Месяц = ПоказателиНалогов.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиДоходовНарастающимИтогом КАК ПоказателиДоходовНарастающимИтогом
	|		ПО МесяцыНП.Месяц = ПоказателиДоходовНарастающимИтогом.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНалоговНарастающимИтогом КАК ПоказателиНалоговНарастающимИтогом
	|		ПО МесяцыНП.Месяц = ПоказателиНалоговНарастающимИтогом.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНалоговНарастающимИтогом КАК ПоказателиНалоговПоПрошлыйМесяц
	|		ПО (МесяцыНП.Месяц - 1 = ПоказателиНалоговПоПрошлыйМесяц.Месяц)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиДоходовНарастающимИтогом КАК ПоказателиДоходовПоПрошлыйМесяц
	|		ПО (МесяцыНП.Месяц - 1 = ПоказателиДоходовПоПрошлыйМесяц.Месяц)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц";							   

	// округлим результаты, как указал пользователь в учетной политике
	Если УчетнаяПолитика.ТочностьИсчисленияЕСН = Перечисления.ПорядкиОкругленияЕСН.ВРубляхИКопейках Тогда
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 1)","ЧИСЛО(15, 2)");
	ИначеЕсли УчетнаяПолитика.ТочностьИсчисленияЕСН = Перечисления.ПорядкиОкругленияЕСН.ВРублях Тогда
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 1)","ЧИСЛО(15, 0)");
	Иначе 	
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 1)","ЧИСЛО(15, 5)");
	КонецЕсли;
	Если УчетнаяПолитика.ТочностьИсчисленияПФР = Перечисления.ПорядкиОкругленияЕСН.ВРубляхИКопейках Тогда
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 3)","ЧИСЛО(15, 2)");
	ИначеЕсли УчетнаяПолитика.ТочностьИсчисленияПФР = Перечисления.ПорядкиОкругленияЕСН.ВРублях Тогда
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 3)","ЧИСЛО(15, 0)");
	Иначе 	
		ДанныеРасчетаТекст = СтрЗаменить(ДанныеРасчетаТекст,"ЧИСЛО(15, 3)","ЧИСЛО(15, 5)");
	КонецЕсли;
	
	//-----------------------------------------------------------------------------
	// ВЫПОЛНЕНИЕ ЗАПРОСОВ
	
	// Сведения об организации
	Запрос.Текст = ДанныеОбОрганизации;
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	Попытка
		ДанныеОбОрганизации  = Запрос.Выполнить().Выбрать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ФормированиеПечатныхФорм.ПроверитьОшибкуЗапрос(МассивЗапросов, ИнформацияОбОшибке, , истина);
		Возврат;
	КонецПопытки;
	ДанныеОбОрганизации.Следующий();
	
	// Данные расчета
	Запрос.Текст = ДанныеРасчетаТекст;
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	Попытка
		ДанныеРасчета  = Запрос.Выполнить().Выбрать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ФормированиеПечатныхФорм.ПроверитьОшибкуЗапрос(МассивЗапросов, ИнформацияОбОшибке, , истина);
		Возврат;
	КонецПопытки;
	
	//-----------------------------------------------------------------------------
	// ЗАПОЛНЕНИЕ ФОРМЫ
	
	// Области макета
    ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМесяц = Макет.ПолучитьОбласть("Месяц");
	ОбластьПустойМесяц = Макет.ПолучитьОбласть("ПустойМесяц");
	
	// настроим формат вывода данных о налогах
	Если УчетнаяПолитика.ТочностьИсчисленияЕСН = Перечисления.ПорядкиОкругленияЕСН.ВРубляхИКопейках Тогда
		ФорматВыводаЕСН = "ЧДЦ=2; ЧРД=.";
	ИначеЕсли УчетнаяПолитика.ТочностьИсчисленияЕСН = Перечисления.ПорядкиОкругленияЕСН.ВРублях Тогда
		ФорматВыводаЕСН = "ЧДЦ=0; ЧРД=.";
	Иначе 	
		ФорматВыводаЕСН = "ЧДЦ=5; ЧРД=.";
	КонецЕсли;
	Если УчетнаяПолитика.ТочностьИсчисленияПФР = Перечисления.ПорядкиОкругленияЕСН.ВРубляхИКопейках Тогда
		ФорматВыводаПФР = "ЧДЦ=2; ЧРД=.";
	ИначеЕсли УчетнаяПолитика.ТочностьИсчисленияПФР = Перечисления.ПорядкиОкругленияЕСН.ВРублях Тогда
		ФорматВыводаПФР = "ЧДЦ=0; ЧРД=.";
	Иначе 	
		ФорматВыводаПФР = "ЧДЦ=5; ЧРД=.";
	КонецЕсли;
	
	ОбластиСтроки = ОбластьМесяц.Области;
	Для НомерКолонки = 10 По 13 Цикл
		ОбластиСтроки["П" + НомерКолонки].Формат = ФорматВыводаЕСН;
		ОбластиСтроки["СНГ" + НомерКолонки].Формат = ФорматВыводаЕСН;
	КонецЦикла;
	Для НомерКолонки = 15 По 17 Цикл
		ОбластиСтроки["П" + НомерКолонки].Формат = ФорматВыводаПФР;
		ОбластиСтроки["СНГ" + НомерКолонки].Формат = ФорматВыводаПФР;
	КонецЦикла;
	Для НомерКолонки = 19 По 26 Цикл
		ОбластиСтроки["П" + НомерКолонки].Формат = ФорматВыводаЕСН;
		ОбластиСтроки["СНГ" + НомерКолонки].Формат = ФорматВыводаЕСН;
	КонецЦикла;
	Для НомерКолонки = 29 По 29 Цикл
		ОбластиСтроки["П" + НомерКолонки].Формат = ФорматВыводаЕСН;
		ОбластиСтроки["СНГ" + НомерКолонки].Формат = ФорматВыводаЕСН;
	КонецЦикла;
	
	// Вывод шапки отчета
	ОбластьШапка.Параметры.Заполнить(ДанныеОбОрганизации);
	ОбластьШапка.Параметры.НалоговыйПериод = Формат(НалоговыйПериод,"ЧГ=");
	ДокументРезультат.Вывести(ОбластьШапка);
	
	// Вывод сведений о доходах и налогах по месяцам налогового периода
	
	Месяц = 0;
	
	Пока ДанныеРасчета.Следующий() Цикл
		
		Месяц = ДанныеРасчета.Месяц; // месяц, который выводим
		
		ОбластьМесяц.Параметры.Заполнить(ДанныеРасчета);
		ОбластьМесяц.Параметры.Месяц = Формат(Дата(НалоговыйПериод,Месяц,1),"ДФ=ММММ");
		
		// проставим в расшифровки название области, для того чтобы потом понять, что нам надо расшифровывать 
		Для Каждого Область Из ОбластьМесяц.Области Цикл
			Если Область.Имя = "Месяц" Или Найти(Область.Имя, "R") > 0 Тогда 
				Продолжить
			Иначе
				ОбластьМесяц.Области[Область.Имя].Расшифровка = Новый Структура("Имя,Месяц",Область.Имя,Месяц);
			КонецЕсли;
		КонецЦикла;				
		
		// Выведем месяц
		ДокументРезультат.Вывести(ОбластьМесяц);
		
	КонецЦикла; 
	
	Если Месяц < 12 Тогда  // дополним таблицу пустыми строками
		Для СчМесяцев = Месяц + 1 По 12 Цикл
			// Выведем пустой месяц
			ОбластьПустойМесяц.Параметры.Месяц = Формат(Дата(НалоговыйПериод,СчМесяцев,1),"ДФ=ММММ");
			ДокументРезультат.Вывести(ОбластьПустойМесяц);
		КонецЦикла;		
	КонецЕсли; 
	
	//-----------------------------------------------------------------------------

	//Параметры документа
	ДокументРезультат.Автомасштаб 			= 	Истина;
	ДокументРезультат.ОриентацияСтраницы 	= 	ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ТолькоПросмотр		= 	Истина;
	
КонецПроцедуры


#КонецЕсли

