///////////////////////////////////////////////////////////////////////////////////////////
//ЗАРПЛАТА И УПРАВЛЕНИЕ ПЕРСОНАЛОМ

// Устанавливает реквизиты элемента плана видов расчета "ОсновныеНачисленияОрганизаций" 
//
Процедура УстановитьРеквизитыОсновногоНачисленияОрганизации(
								ВидРасчета,
								СпособРасчета,
								ВидВремени,
								КатегорияРасчета,
								ОбозначениеВТабелеУчетаРабочегоВремени,
								ЗачетОтработанногоВремени,
								ЗачетНормыВремени,
								КодДоходаНДФЛ = Неопределено,
								КодДоходаЕСН = Неопределено,
								КодДоходаСтраховыеВзносы = Неопределено,
								КодДоходаФСС_НС,
								СпособОтраженияВБухучете = Неопределено,
								ВидНачисленияПоСт255НК = Неопределено,
								ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка = Неопределено,
								ПериодДействияБазовый = Ложь,
								ПроверятьПравильностьУстановкиРеквизитов = Истина,
								ВидПособияСоциальногоСтрахования = Неопределено) Экспорт

	Если ТипЗнч(ОбозначениеВТабелеУчетаРабочегоВремени) = Тип("Строка") Тогда
		КодУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.НайтиПоРеквизиту("БуквенныйКод", СокрЛП(ОбозначениеВТабелеУчетаРабочегоВремени));
	Иначе
		КодУчетаРабочегоВремени = ОбозначениеВТабелеУчетаРабочегоВремени
	КонецЕсли;

	ОбъектВР = ВидРасчета.ПолучитьОбъект();
	
	ОбъектВР.СпособРасчета							= СпособРасчета;
	ОбъектВР.ВидВремени								= ВидВремени;
	ОбъектВР.КатегорияРасчета						= КатегорияРасчета;
	ОбъектВР.ОбозначениеВТабелеУчетаРабочегоВремени = КодУчетаРабочегоВремени;
	ОбъектВР.ЗачетОтработанногоВремени              = ЗачетОтработанногоВремени;
	ОбъектВР.ЗачетНормыВремени                      = ЗачетНормыВремени;
	ОбъектВР.КодДоходаНДФЛ                          = КодДоходаНДФЛ;
	ОбъектВР.КодДоходаЕСН                           = КодДоходаЕСН;
	ОбъектВР.КодДоходаСтраховыеВзносы               = КодДоходаСтраховыеВзносы;
	ОбъектВР.КодДоходаФСС_НС				        = КодДоходаФСС_НС;
	ОбъектВР.СпособОтраженияВБухучете               = СпособОтраженияВБухучете;
	ОбъектВР.ВидПособияСоциальногоСтрахования       = ВидПособияСоциальногоСтрахования;
	ОбъектВР.СтратегияОтраженияВУчете               = ?(СпособОтраженияВБухучете = Справочники.СпособыОтраженияЗарплатыВРеглУчете.РаспределятьПоБазовымНачислениям, Перечисления.СтратегииОтраженияВРеглУчетеНачислений.КакБазовыеНачисления,
														?(ЗначениеЗаполнено(СпособОтраженияВБухучете), Перечисления.СтратегииОтраженияВРеглУчетеНачислений.КакЗаданоВидуРасчета,Перечисления.СтратегииОтраженияВРеглУчетеНачислений.КакЗаданоНаНачалоСобытия));
	ОбъектВР.ВидНачисленияПоСт255НК                 = ВидНачисленияПоСт255НК;
	ОбъектВР.ОтнесениеРасходовКДеятельностиЕНВД     = ?(КодДоходаЕСН = Справочники.ДоходыЕСН.ВыплатыЗаСчетПрибыли,Перечисления.ОтнесениеРасходовКДеятельностиЕНВД.РасходыОтносятсяКнеЕНВД,Перечисления.ОтнесениеРасходовКДеятельностиЕНВД.РасходыРаспределяются);
	ОбъектВР.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка = ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка;
	ОбъектВР.ВидСтажаСЗВ4 = ПроцедурыПерсонифицированногоУчетаПереопределяемый.ПолучитьПорядокВключенияПериодаВСтраховойСтаж(ВидПособияСоциальногоСтрахования, ВидВремени, КодУчетаРабочегоВремени);

	Если НЕ ОбъектВР.Предопределенный Тогда
		ОбъектВР.ПериодДействияБазовый = ПериодДействияБазовый;
	КонецЕсли;
	
	Если НЕ ПроверятьПравильностьУстановкиРеквизитов Тогда
		ОбъектВР.ОбменДанными.Загрузка = Истина;
	КонецЕсли;
	
	Попытка
		ОбъектВР.Записать();
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры // УстановитьРеквизитыОсновногоНачисленияОрганизации()

// Процедура заполняет реквизиты ВР (в т.ч. вытесняемые и вытесняющие начисления)
// Запускается при обновлении на 1.2.15
//
Процедура ЗаполнитьРеквизитыПВРДниНеоплачиваемыеСогласноТабелю()Экспорт
	
	// Заполнение реквизитов для Вида расчета ДниНеоплачиваемыеСогласноТабелю
	СпРасчета  = Перечисления.СпособыРасчетаОплатыТруда;
	НеОтражатьВБухУчете = Справочники.СпособыОтраженияЗарплатыВРеглУчете.НеОтражатьВБухучете;
	УчетВремени = Справочники.КлассификаторИспользованияРабочегоВремени;
	АнализируемоеНачисление = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ДниНеоплачиваемыеСогласноТабелю;
	УстановитьРеквизитыОсновногоНачисленияОрганизации(АнализируемоеНачисление, СпРасчета.НулеваяСумма, Перечисления.ВидыВремени.ЦелодневноеНеотработанное, Справочники.КатегорииРасчетов.Первичное, УчетВремени.НеявкиПоНевыясненнымПричинам, Ложь,   Истина, , , , Перечисления.ДоходыФСС_НС.Облагается, НеОтражатьВБухУчете,,,,Ложь);
	
	СписокПредопределенныхВытесняющихПВР = Новый Массив;
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаБЛПоТравмеВБыту);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтпускБезОплатыУчебный);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаБЛПоТравмеНаПроизводстве);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднемуБЛ);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаВыходныхДнейПоУходуЗаДетьмиИнвалидами);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднемуОтпКалендарныеДни);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднемуОтпШестидневка);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОплатаПоСреднему);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПростойОкладПоДням);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПростойОкладПоЧасам);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПростойТарифДневной);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПростойТарифЧасовой);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтпускБезОплатыПоТКРФ);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтпускЗаСвойСчет);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтпускПоБеременностиИРодам);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтсутствиеПоБолезни);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОтсутствиеПоБолезниПоБеременности);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.Прогул);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПростойПоВинеРаботодателя);
	СписокПредопределенныхВытесняющихПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.Невыход);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокПВР", СписокПредопределенныхВытесняющихПВР);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыбранныеВР.ВидРасчета,
	|	ВЫБОР
	|		КОГДА ВыбранныеВР.ВидРасчета В (&СписокПВР)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета КАК ВидРасчета
	|	ИЗ
	|		ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
	|	ГДЕ
	|		ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка В(&СписокПВР)
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ОсновныеНачисленияОрганизаций.Ссылка
	|	ИЗ
	|		ПланВидовРасчета.ОсновныеНачисленияОрганизаций КАК ОсновныеНачисленияОрганизаций
	|	ГДЕ
	|		ОсновныеНачисленияОрганизаций.Ссылка В(&СписокПВР)) КАК ВыбранныеВР
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
	|		ПО ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета = ВыбранныеВР.ВидРасчета
	|			И (ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ДниНеоплачиваемыеСогласноТабелю))
	|ГДЕ
	|	ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
				   
	АнализируемоеНачислениеОбъект = АнализируемоеНачисление.ПолучитьОбъект();			   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		АнализируемоеНачислениеОбъект.ВытесняющиеВидыРасчета.Добавить().ВидРасчета = Выборка.ВидРасчета;
	КонецЦикла;
	АнализируемоеНачислениеОбъект.ОбменДанными.Загрузка = Истина;
	АнализируемоеНачислениеОбъект.Записать();
	
	СписокПредопределенныхВытесняемыхПВР = Новый Массив;
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ДоплатаЗаВечерниеЧасы);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ДоплатаЗаНочныеЧасы);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОкладПоДням);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОкладПоЧасам);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ТарифДневной);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ТарифЧасовой);
	СписокПредопределенныхВытесняемыхПВР.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.СдельнаяОплата);
	Запрос.УстановитьПараметр("СписокПВР", СписокПредопределенныхВытесняемыхПВР);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыбранныеВР.ВидРасчета,
	|	ВЫБОР
	|		КОГДА ВыбранныеВР.ВидРасчета В (&СписокПВР)
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка КАК ВидРасчета
	|	ИЗ
	|		ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
	|	ГДЕ
	|		ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета В(&СписокПВР)
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ОсновныеНачисленияОрганизаций.Ссылка
	|	ИЗ
	|		ПланВидовРасчета.ОсновныеНачисленияОрганизаций КАК ОсновныеНачисленияОрганизаций
	|	ГДЕ
	|		ОсновныеНачисленияОрганизаций.Ссылка В(&СписокПВР)) КАК ВыбранныеВР
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
	|		ПО ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка = ВыбранныеВР.ВидРасчета
	|			И (ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ДниНеоплачиваемыеСогласноТабелю))
	|ГДЕ
	|	ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписываемоеНачислениеОбъект = Выборка.ВидРасчета.ПолучитьОбъект();
		ЗаписываемоеНачислениеОбъект.ВытесняющиеВидыРасчета.Добавить().ВидРасчета = АнализируемоеНачисление;
		ЗаписываемоеНачислениеОбъект.ОбменДанными.Загрузка = Истина;
		ЗаписываемоеНачислениеОбъект.Записать();
	КонецЦикла;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
				   |	ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка Как ВидРасчета
				   |ИЗ
				   |	ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
				   |ГДЕ
				   |	ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка <> &ПВРТабель
				   |	И ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета = &ПВРНеявка
				   |	И (НЕ ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка В
				   |				(ВЫБРАТЬ
				   |					ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.Ссылка
				   |				ИЗ
				   |					ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета
				   |				ГДЕ
				   |					ОсновныеНачисленияОрганизацийВытесняющиеВидыРасчета.ВидРасчета = &ПВРТабель))";
	Запрос.УстановитьПараметр("ПВРТабель", ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ДниНеоплачиваемыеСогласноТабелю);
	Запрос.УстановитьПараметр("ПВРНеявка", ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.Невыход);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписываемоеНачислениеОбъект = Выборка.ВидРасчета.ПолучитьОбъект();
		ЗаписываемоеНачислениеОбъект.ВытесняющиеВидыРасчета.Добавить().ВидРасчета = АнализируемоеНачисление;
		ЗаписываемоеНачислениеОбъект.ОбменДанными.Загрузка = Истина;
		ЗаписываемоеНачислениеОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

