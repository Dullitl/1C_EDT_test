Перем мУдалятьДвижения;

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

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА
Процедура ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если (НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете) И (НЕ СтруктураШапкиДокумента.ОтражатьВНалоговомУчете) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОбязательныхПолей 	= Новый Структура;
	СтруктураОбязательныхПолей.Вставить("Организация");
	СтруктураОбязательныхПолей.Вставить("СобытиеРегл");
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Проверим чем заполнено событие
	ВидыСобытий = ПолучитьСписокЗначенийВидыСобытий();
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.СобытиеРегл.Представление();
	УправлениеВнеоборотнымиАктивами.ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.СобытиеРегл.ВидСобытияОС,
							  ВидыСобытий,
							  ПредставлениеРеквизита,Отказ);

КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей 
		= Новый Структура("Событие");

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок, Истина);

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Проверим чем заполнено событие
	ВидыСобытий = ПолучитьСписокЗначенийВидыСобытий();
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.Событие.Представление();
	УправлениеВнеоборотнымиАктивами.ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.Событие.ВидСобытияОС,
							  ВидыСобытий,
							  ПредставлениеРеквизита,Отказ);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОС(РежимПроведения,Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ОсновноеСредство");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураОбязательныхПолей, Отказ, Заголовок);

	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		// Проверим возможность изменения состояния ОС
		Для каждого СтрокаОС из ОС Цикл
			Если ОтражатьВБухгалтерскомУчете тогда
				УправлениеВнеоборотнымиАктивами.ПроверитьВозможностьИзмененияСостоянияОС(СтрокаОС.ОсновноеСредство,Дата,СобытиеРегл,Отказ,Организация);
			КонецЕсли;
			Если ОтражатьВУправленческомУчете тогда
				УправлениеВнеоборотнымиАктивами.ПроверитьВозможностьИзмененияСостоянияОС(СтрокаОС.ОсновноеСредство,Дата,Событие,Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ)

	ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС);
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС);
	
	Если СтруктураШапкиДокумента.ВидСобытияОС = Перечисления.ВидыСобытийОС.ВводВЭксплуатацию Тогда
		ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ);
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам

// Процедура вызывается из тела процедуры ДвиженияПоРегистрам
// Формирует движения по регистрам подсистемы учета НДС.
//
Процедура ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ)
	
	Если Не УчетНДС.ПроводитьДокументДляЦелейНДС(СтруктураШапкиДокумента) Тогда
		// Движения по этому документу делать не нужно
		Возврат;
	КонецЕсли;
	
	Если Не ТаблицаПоОС.Количество() = 0 И
		СтруктураШапкиДокумента.ВидСобытияОС = Перечисления.ВидыСобытийОС.ВводВЭксплуатацию Тогда

		МассивОбъектов = ТаблицаПоОС.ВыгрузитьКолонку("ОсновноеСредство");
			
		// Вычет остается заблокированным до начала следующего месяца после ввода в эксплуатацию ОС,
		// полученного из объекта строительства.
		ДатаЗаписи = НачалоМесяца(ДобавитьМесяц((СтруктураШапкиДокумента.Дата), 1));
			
		// Разблокируется весь НДС, заблокированный до момента ввода в эксплуатацию. Остатков быть не может,
		// так как один объект ОС нельзя ввести в эксплуатацию частично (в этом случае это должны быть разные объекты).
		КоэффициентРаспределения = 1;
			
		//Разблокируем полностью вычет, отразим погашение события ОжидаетсяВводВЭксплуатацию
		УчетНДСФормированиеДвижений.СформироватьДвиженияПоРегиструНДСпоОСиНМА_ИзменениеТекущегоСостоянияНДС(СтруктураШапкиДокумента,
															МассивОбъектов,
															Перечисления.НДССостоянияОСНМА.ОжидаетсяВводВЭксплуатацию,
															Перечисления.СобытияПоНДСПокупки.ОСВведеноВЭксплуатацию,
															ДатаЗаписи,КоэффициентРаспределения, Отказ);
		УчетНДСФормированиеДвижений.СформироватьДвиженияПоРегиструНДСпоОСиНМА_ИзменениеТекущегоСостоянияНДС_Хозспособ(СтруктураШапкиДокумента,
															МассивОбъектов,
															Перечисления.НДССостоянияОСНМА.ОжидаетсяВводВЭксплуатацию,
															Перечисления.СобытияПоНДСПокупки.ОСВведеноВЭксплуатацию,
															ДатаЗаписи,КоэффициентРаспределения, Отказ);
	КонецЕсли;
	
КонецПроцедуры // ДвиженияРегистровПодсистемыНДС()

Процедура ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС)

	ДатаДока = Дата;
	
	Если ОтражатьВУправленческомУчете Тогда
		СобытиеОС	            = Движения.СобытияОС;
		НачислениеАмортизацииОС = Движения.НачислениеАмортизацииОС;
		СостояниеОС             = Движения.СостоянияОС;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
		Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
			
			Движение = СобытиеОС.Добавить();
			Движение.Период            = ДатаДока;
			Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
			Движение.Событие           = СтруктураШапкиДокумента.Событие;
			Движение.НазваниеДокумента = Метаданные().Представление();
			Движение.НомерДокумента    = Номер;
			
			// Движения по регистру СостоянияОС
			Если СтруктураШапкиДокумента.Событие.ВидСобытияОС = Перечисления.ВидыСобытийОС.ВводВЭксплуатацию Тогда
				Движение = СостояниеОС.Добавить();
				Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
				Движение.Состояние         = Перечисления.СостоянияОС.ВведеноВЭксплуатацию;
				Движение.ДатаСостояния     = ДатаДока;
			КонецЕсли;
			
			Если СтруктураШапкиДокумента.ВлияетНаНачислениеАмортизации Тогда
				Движение = НачислениеАмортизацииОС.Добавить();
				Движение.Период           = ДатаДока;
				Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
				Движение.НачислятьАмортизацию = СтруктураШапкиДокумента.НачислятьАмортизацию;
				Движение.НачислятьАмортизациюВТекущемМесяце = СтруктураШапкиДокумента.НачислятьАмортизациюВТекущемМесяце;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС)

	ДатаДока = Дата;

	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		НачислениеАмортизацииБух = Движения.НачислениеАмортизацииОСБухгалтерскийУчет;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		НачислениеАмортизацииНал = Движения.НачислениеАмортизацииОСНалоговыйУчет;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете 
	   или СтруктураШапкиДокумента.ОтражатьВНалоговомУчете 
	   или СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСН
	   тогда 
		СостояниеОС              = Движения.СостоянияОСОрганизаций;
		СобытиеОС                = Движения.СобытияОСОрганизаций;
	КонецЕсли;

	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл

		Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда

			Если СтруктураШапкиДокумента.ВлияетНаНачислениеАмортизации Тогда
				Движение = НачислениеАмортизацииБух.Добавить();
				Движение.Период                   = ДатаДока;
				Движение.ОсновноеСредство         = СтрокаТЧ.ОсновноеСредство;
				Движение.Организация         	  = СтруктураШапкиДокумента.Организация;
				Движение.НачислятьАмортизацию 	  = СтруктураШапкиДокумента.НачислятьАмортизацию;
				//Движение.НачислятьАмортизациюВТекущемМесяце = СтруктураШапкиДокумента.НачислятьАмортизациюВТекущемМесяце;
			КонецЕсли;

		КонецЕсли;

		Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда

			Если СтруктураШапкиДокумента.ВлияетНаНачислениеАмортизации Тогда
				Движение = НачислениеАмортизацииНал.Добавить();
				Движение.Период                   = ДатаДока;
				Движение.ОсновноеСредство         = СтрокаТЧ.ОсновноеСредство;
				Движение.Организация         	  = СтруктураШапкиДокумента.Организация;
				Движение.НачислятьАмортизацию = СтруктураШапкиДокумента.НачислятьАмортизацию;
				//Движение.НачислятьАмортизациюВТекущемМесяце = СтруктураШапкиДокумента.НачислятьАмортизациюВТекущемМесяце;
			КонецЕсли;

		КонецЕсли;
		
		Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете 
		   или СтруктураШапкиДокумента.ОтражатьВНалоговомУчете
		   или СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСН
		   тогда
		
			Движение = СобытиеОС.Добавить();

			Движение.Период                   = ДатаДока;
			Движение.ОсновноеСредство         = СтрокаТЧ.ОсновноеСредство;
			Движение.Организация         	  = СтруктураШапкиДокумента.Организация;
			Движение.Событие                  = СтруктураШапкиДокумента.Событие;
			Движение.НазваниеДокумента 		  = Метаданные().Представление();
			Движение.НомерДокумента    		  = Номер;
			
			// Движения по регистру сведений СостоянияОСОрганизаций
			Если СтруктураШапкиДокумента.СобытиеРегл.ВидСобытияОС = Перечисления.ВидыСобытийОС.ВводВЭксплуатацию Тогда
				
				Движение = СостояниеОС.Добавить();
				
				Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
				Движение.Организация       = СтруктураШапкиДокумента.Организация;
				Движение.Состояние         = Перечисления.СостоянияОС.ВведеноВЭксплуатацию;
				Движение.ДатаСостояния     = ДатаДока;
				
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ПолучитьУчасткиЗапросаПоТабличнойЧастиОСУпр(ПоляУпр, СоединенияУпр)

	ПоляУпр = ",
	|	НачислениеАмортизацииСрезПоследних.НачислятьАмортизацию КАК НачислятьАмортизациюУпр,
	|	НачислениеАмортизацииСрезПоследних.НачислятьАмортизациюВТекущемМесяце";

	СоединенияУпр = "
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НачислениеАмортизацииОС.СрезПоследних(&Период, ) КАК НачислениеАмортизацииСрезПоследних
	|		ПО ИзменениеСостоянияОсновногоСредстваОсновныеСредства.ОсновноеСредство = НачислениеАмортизацииСрезПоследних.ОсновноеСредство";

КонецПроцедуры

Процедура ПолучитьУчасткиЗапросаПоТабличнойЧастиОСРегл(ПоляРегл, СоединенияРегл)

	ПоляРегл = ",
	|	НачислениеАмортизацииБухгалтерскийУчетСрезПоследних.НачислятьАмортизацию  КАК НачислятьАмортизациюБух,
	|	НачислениеАмортизацииНалоговыйУчетСрезПоследних.НачислятьАмортизацию      КАК НачислятьАмортизациюНал";

	СоединенияРегл = "
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НачислениеАмортизацииОСБухгалтерскийУчет.СрезПоследних(&Период,Организация=&Организация ) КАК НачислениеАмортизацииБухгалтерскийУчетСрезПоследних
	|		ПО ИзменениеСостоянияОсновногоСредстваОсновныеСредства.ОсновноеСредство = НачислениеАмортизацииБухгалтерскийУчетСрезПоследних.ОсновноеСредство,
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НачислениеАмортизацииОСНалоговыйУчет.СрезПоследних(&Период,Организация=&Организация )     КАК НачислениеАмортизацииНалоговыйУчетСрезПоследних
	|		ПО ИзменениеСостоянияОсновногоСредстваОсновныеСредства.ОсновноеСредство = НачислениеАмортизацииНалоговыйУчетСрезПоследних.ОсновноеСредство";

КонецПроцедуры

Функция ПолучитьСписокЗначенийВидыСобытий() Экспорт
	
	ВидыСобытий = Новый СписокЗначений;
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.ВводВЭксплуатацию);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.ВнутреннееПеремещение);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.ТекущийРемонт);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.СреднийРемонт);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.КапитальныйРемонт);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Переоценка);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Реконструкция);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Достройка);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Дооборудование);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.ЧастичнаяЛиквидация);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Модернизация);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.ПодготовкаКПередаче);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Передача);
	ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Прочее);
	Возврат ВидыСобытий;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание.Ссылка;
		//Событие = ПолучитьСостояниеОСИзСправочника(Перечисления.ВидыСостоянийОС.ВведеноВЭксплуатацию);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ,РежимПроведения)

	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = "";

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("ВидСобытияОС",СтруктураШапкиДокумента.Событие.ВидСобытияОС);
	
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиОС(РежимПроведения,Отказ, Заголовок);

	ПоляУпр        = "";
	ПоляРегл       = "";
	СоединенияУпр  = "";
	СоединенияРегл = "";

	ПолучитьУчасткиЗапросаПоТабличнойЧастиОСУпр(ПоляУпр, СоединенияУпр);
	ПолучитьУчасткиЗапросаПоТабличнойЧастиОСРегл(ПоляРегл, СоединенияРегл);

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", МоментВремени());
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "ВЫБРАТЬ
	|	ИзменениеСостоянияОсновногоСредстваОсновныеСредства.НомерСтроки,
	|	ИзменениеСостоянияОсновногоСредстваОсновныеСредства.ОсновноеСредство"
	+ ПоляУпр
	+ ПоляРегл + "
	|ИЗ
	|	Документ.ИзменениеСостоянияОС.ОС КАК ИзменениеСостоянияОсновногоСредстваОсновныеСредства"
	+ СоединенияУпр
	+ СоединенияРегл + "
	|
	|ГДЕ
	|	ИзменениеСостоянияОсновногоСредстваОсновныеСредства.Ссылка = &Ссылка";
	ТаблицаПоОС = Запрос.Выполнить().Выгрузить();
 	
	УправлениеВнеоборотнымиАктивами.ПроверитьДубли(ТаблицаПоОС, "Основные средства", "ОсновноеСредство", "Основное средство", Отказ, Заголовок);	
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ);
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




