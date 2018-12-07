////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора) Экспорт

	Перем Номенклатура, ЕдиницаИзмерения, ЕдиницаИзмеренияМест, Количество, Коэффициент, СведенияЕдиницаИзмеренияМест;
	Перем ХарактеристикаНоменклатуры, СерияНоменклатуры;

	// Получим параметры подбора из структуры подбора.
	ЗначениеВыбора.Свойство("Номенклатура",					Номенклатура);
	ЗначениеВыбора.Свойство("ХарактеристикаНоменклатуры",	ХарактеристикаНоменклатуры);
	ЗначениеВыбора.Свойство("СерияНоменклатуры",			СерияНоменклатуры);
	ЗначениеВыбора.Свойство("ЕдиницаИзмерения",				ЕдиницаИзмерения);
	ЗначениеВыбора.Свойство("ЕдиницаИзмеренияМест",			ЕдиницаИзмеренияМест);
	ЗначениеВыбора.Свойство("Коэффициент",					Коэффициент);
	ЗначениеВыбора.Свойство("Количество",					Количество);
	ЗначениеВыбора.Свойство("СведенияЕдиницаИзмеренияМест", СведенияЕдиницаИзмеренияМест);
	
	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	СтруктураОтбора.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	СтруктураОтбора.Вставить("СерияНоменклатуры", СерияНоменклатуры);


	МассивСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, увеличиваем количество в первой найденной строке.
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + Количество;
		РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.Номенклатура     			= Номенклатура;
		СтрокаТабличнойЧасти.Количество       			= Количество;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения 			= ЕдиницаИзмерения;
		СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест		= ЕдиницаИзмеренияМест;
		СтрокаТабличнойЧасти.Коэффициент      			= Коэффициент;
		РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, СведенияЕдиницаИзмеренияМест);
	КонецЕсли;
		
КонецПроцедуры //

&НаКлиенте
Процедура ДействиеПодбор()

	Команда = "ПодборВТабличнуюЧастьМатериалы";
	ЕстьУслуги = Истина;
	
	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("Команда", Команда);
	
	СтруктураПараметровПодбора.Вставить("ПодбиратьУслуги", ЕстьУслуги);
	Если ЕстьУслуги Тогда
		СтруктураПараметровПодбора.Вставить("ОтборУслугПоСправочнику", Ложь);
	КонецЕсли;
	
	ВременнаяДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов", ВременнаяДатаРасчетов);
	
	РаботаСДиалогамиКлиент.ОткрытьПодборНоменклатуры(ЭтаФорма, СтруктураПараметровПодбора);
		
КонецПроцедуры //

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Это существующий документ. 
		// Проверим, что его можно менять.
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	Иначе
		//Заполним реквизиты специфичные для управляемой формы
		Объект.ВводитьЗаказыПоСтрокам = Истина;
		Объект.ВводитьНоменклатурныеГруппыПоСтрокам = Истина;
	КонецЕсли;
	ВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	ВалютаУправленческогоУчета = глЗначениеПеременной("ВалютаУправленческогоУчета");
	
	// Определим значение реквизита ИспользуетсяУправленческийУчетЗатрат.
	// Значение используется в диалогах заполнения.
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Дата = ТекущаяДата();
	Иначе
		Дата = Объект.Дата;
	КонецЕсли;
	
	Если УправлениеЗапасами.ИспользуетсяРасширеннаяАналитикаУчета(Дата)
	    И НЕ УправлениеЗапасами.ИспользуетсяУправленческийУчетЗатрат() Тогда
		ИспользуетсяУправленческийУчетЗатрат = Ложь;
	Иначе
		ИспользуетсяУправленческийУчетЗатрат = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем Команда;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ВыбранноеЗначение.Свойство("Команда", Команда);

		Если Команда = "ПодборВТабличнуюЧастьМатериалы" Тогда
			ОбработкаПодбора("Материалы", ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// СОХРАНЕНИЕ И ВОССТАНОВЛЕНИЕ ДАННЫХ ИЗ НАСТРОЕК

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ДобавитьДополнительныеДанныеВНастройку(Объект, Настройки, Документы.ИнвентаризацияНЗП.СтруктураДополнительныхДанныхФормы());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектДополнительнымиДанными(Объект, Настройки, Документы.ИнвентаризацияНЗП.СтруктураДополнительныхДанныхФормы());
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ПустаяСтрока(Объект.Номер) Тогда
		ПрефиксацияОбъектовСобытия.ОчиститьНомерОбъекта(Объект.Номер, Объект.Организация);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ ДАННЫХ В ТАБЛИЧНОЙ ЧАСТИ

&НаСервереБезКонтекста
Функция ПересчитатьВСуммуРегл(ДанныеДляЗаполнения)
	Возврат МодульВалютногоУчета.ПересчитатьВСуммуРегл( ДанныеДляЗаполнения.Сумма, 
		ДанныеДляЗаполнения.ВалютаРегламентированногоУчета, 
		ДанныеДляЗаполнения.ВалютаУправленческогоУчета, 
		ДанныеДляЗаполнения.Дата);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ "МАТЕРИАЛЫ" И ЕЁ РЕКВИЗИТОВ

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	
	ДанныеОбменаССервером = Новый Структура();
	ДанныеОбменаССервером.Вставить("Номенклатура",  СтрокаТабличнойЧасти.Номенклатура);
	
	// Получим все необходимые данные на сервере
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ИзменениеНоменклатуры(ДанныеОбменаССервером);
	
	// Заполним реквизиты строки
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияДляЗаполнения);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, ДанныеОбменаССервером.СведенияЕдиницаИзмеренияМест);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыЕдиницаИзмеренияПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	ДанныеОбменаССервером = Новый Структура();
	ДанныеОбменаССервером.Вставить("ЕдиницаИзмерения",     СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеОбменаССервером.Вставить("ЕдиницаИзмеренияМест", СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест);
	
	// Получим все необходимые данные на сервере
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ИзменениеЕдиницыИзмерения(ДанныеОбменаССервером);
	
	// Заполним реквизиты строки
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияДляЗаполнения);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, ДанныеОбменаССервером.СведенияЕдиницаИзмеренияМест);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыЕдиницаИзмеренияМестПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	РаботаСДиалогамиКлиент.ОчиститьКоличествоМестПриОчисткеЕдиницыМест(СтрокаТабличнойЧасти);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоМестПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	РаботаСДиалогамиКлиент.РассчитатьКоличествоТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыСчетЗатратБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СчетЗатратНУ = УправлениеЗатратами.ПолучитьСчетПрямыхРасходовНУ(СтрокаТабличнойЧасти.СчетЗатрат);

КонецПроцедуры

// Реализует диалог с пользователем при заполнении данными упр. учета о затратах.
// Проверяет, что упр. учет затрат ведется.
//
// Возвращаемое значение:
//  Истина - можно выполнять заполнение: упр. учет затрат ведется 
//           или пользователь согласился заполнять данными регл. учета
//  Ложь   - нельзя выполнять заполнение: упр. учет затрат НЕ ведется 
//           и пользователь НЕ согласился заполнять данными регл. учета
//
// Параметры:
//  ЗаполнятьДаннымиРеглУчета - в параметр будет возвращено Истина, если пользователь согласился заполнять данными регл. учета
&НаКлиенте
Функция ПроверитьИспользуетсяУправленческийУчетЗатрат(ЗаполнятьДаннымиРеглУчета)
	
	Если НЕ ИспользуетсяУправленческийУчетЗатрат Тогда
		
		ТекстВопроса = Нстр("ru = 'Управленческий учет затрат не ведется. Заполнить по данным регламентированного учета?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаполнятьДаннымиРеглУчета = Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


&НаСервере
Процедура ЗаполнитьОстаткамиМатериаловВПроизводстве()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
		
	ДокументОбъект.ЗаполнитьОстаткамиМатериаловВПроизводстве();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьОстаткамиМатериаловВПроизводстве(Команда)
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.Материалы) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткамиМатериаловВПроизводстве();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыПоНормативам(ПоДаннымРеглУчета = Истина)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ВидУчета = 
		?(ПоДаннымРеглУчета, 
		Перечисления.ВидыОтраженияВУчете.ОтражатьВРегламентированномУчете, 
		Перечисления.ВидыОтраженияВУчете.ОтражатьВУправленческомУчете);
		
	ДокументОбъект.ЗаполнитьМатериалыПоНормативам(ВидУчета);
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыПоНормативамУпр(Команда)
	
	ЗаполнятьДаннымиРеглУчета = Ложь;
	
	Если НЕ ПроверитьИспользуетсяУправленческийУчетЗатрат(ЗаполнятьДаннымиРеглУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.Материалы) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьМатериалыПоНормативам(ЗаполнятьДаннымиРеглУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыПоНормативамРегл(Команда)
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.Материалы) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьМатериалыПоНормативам(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыОстаткамиЗатрат(ПоДаннымРеглУчета = Истина)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ВидУчета = 
		?(ПоДаннымРеглУчета, 
		Перечисления.ВидыОтраженияВУчете.ОтражатьВРегламентированномУчете, 
		Перечисления.ВидыОтраженияВУчете.ОтражатьВУправленческомУчете);
		
	ДокументОбъект.ЗаполнитьМатериалыОстаткамиЗатрат(ВидУчета);
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыПоОстаткамЗатратУпр(Команда)
	
	ЗаполнятьДаннымиРеглУчета = Ложь;
	
	Если НЕ ПроверитьИспользуетсяУправленческийУчетЗатрат(ЗаполнятьДаннымиРеглУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.Материалы) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьМатериалыОстаткамиЗатрат(ЗаполнятьДаннымиРеглУчета); // По данным упр. учета
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыПоОстаткамЗатратРегл(Команда)
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.Материалы) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьМатериалыОстаткамиЗатрат();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрочиеЗатратыОстатками(ПоДаннымУпрУчета = Ложь, ПоДаннымРеглУчета = Ложь)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ПоДаннымУпрУчета И ПоДаннымРеглУчета Тогда 
		ВидУчета = Неопределено;
	Иначе
		ВидУчета = 
			?(ПоДаннымРеглУчета, 
			Перечисления.ВидыОтраженияВУчете.ОтражатьВРегламентированномУчете, 
			Перечисления.ВидыОтраженияВУчете.ОтражатьВУправленческомУчете);
	КонецЕсли;
		
	ДокументОбъект.ЗаполнитьПрочиеЗатратыПоОстаткам(ВидУчета);
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПрочиеЗатратыПоОстаткамРегл(Команда)
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.ПрочиеЗатраты) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПрочиеЗатратыОстатками(Ложь, Истина); // Только данные регл. учета
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПрочиеЗатратыПоОстаткамУпр(Команда)
	
	ЗаполнятьДаннымиРеглУчета = Ложь;
	
	Если НЕ ПроверитьИспользуетсяУправленческийУчетЗатрат(ЗаполнятьДаннымиРеглУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.ПрочиеЗатраты) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполнятьДаннымиРеглУчета Тогда
		ЗаполнитьПрочиеЗатратыОстатками(Ложь, Истина); // Только данные регл. учета
	Иначе
		ЗаполнитьПрочиеЗатратыОстатками(Истина, Ложь); // Только данные упр. учета
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПрочиеЗатратыПоОстаткамУпрРегл(Команда)
	
	Если РаботаСДиалогамиКлиент.ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(Объект.ПрочиеЗатраты) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПрочиеЗатратыОстатками(Истина, Истина); // Данные всех видов учета
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПодбор(Команда)
	ДействиеПодбор();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ "ПРОЧИЕ ЗАТРАТЫ" И ЕЁ РЕКВИЗИТОВ

&НаКлиенте
Процедура ПрочиеЗатратыСчетЗатратБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ПрочиеЗатраты.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СчетЗатратНУ = УправлениеЗатратами.ПолучитьСчетПрямыхРасходовНУ(СтрокаТабличнойЧасти.СчетЗатрат);

КонецПроцедуры

&НаКлиенте
Процедура ПрочиеЗатратыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ПрочиеЗатраты.ТекущиеДанные;
	Если ВалютаРегламентированногоУчета = ВалютаУправленческогоУчета ИЛИ СтрокаТабличнойЧасти.Сумма = 0 Тогда
		СтрокаТабличнойЧасти.СуммаРегл = СтрокаТабличнойЧасти.Сумма;
		СтрокаТабличнойЧасти.СуммаНал = СтрокаТабличнойЧасти.Сумма;
	Иначе
		ДанныеДляЗаполнения = Новый Структура("Сумма, ВалютаРегламентированногоУчета, ВалютаУправленческогоУчета, Дата",
			СтрокаТабличнойЧасти.Сумма, ВалютаРегламентированногоУчета, 
			ВалютаУправленческогоУчета, Объект.Дата);
		СтрокаТабличнойЧасти.СуммаРегл = ПересчитатьВСуммуРегл(ДанныеДляЗаполнения);
		СтрокаТабличнойЧасти.СуммаНал = СтрокаТабличнойЧасти.СуммаРегл;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеЗатратыСуммаРеглПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ПрочиеЗатраты.ТекущиеДанные;
	СтрокаТабличнойЧасти.СуммаНал = СтрокаТабличнойЧасти.СуммаРегл;
КонецПроцедуры


