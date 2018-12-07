Процедура УдалитьДвижения(Движения)
		Для каждого ПроводкиДокумента из Движения Цикл

			//Если (НЕ ПроводкиДокумента.Модифицированность()) И 
			//		(НЕ ПроводкиДокумента.Выбран()) И
			//		(НЕ ЭтоНовыйДокумент) Тогда

				ПроводкиДокумента.Прочитать();

			//КонецЕсли;

			КоличествоПроводок = ПроводкиДокумента.Количество();

			Если КоличествоПроводок > 0 Тогда
                ПроводкиДокумента.Очистить();
				//// Определяем текущую активность проводок по первой проводке
				//ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;
				//НужнаяАктивностьПроводок  = НЕ ПометкаУдаления;

				//Если ТекущаяАктивностьПроводок <> НужнаяАктивностьПроводок Тогда
				//	ПроводкиДокумента.УстановитьАктивность(НужнаяАктивностьПроводок);
				//КонецЕсли;
                ПроводкиДокумента.Записать();
			КонецЕсли;
		КонецЦикла;
	
КонецПроцедуры

Функция СформироватьСтруктуруДвижений() Экспорт
	СтруктураДвижений = Новый Структура;
	Для каждого Движение из Метаданные().Движения Цикл
		Движения[Движение.Имя].Очистить();
		СтруктураДвижений.Вставить(Движение.имя,Движения[Движение.Имя].Выгрузить());
	КонецЦикла;
	СтруктураДвижений.Вставить("Период", КонецМесяца(Дата));
	СтруктураДвижений.Вставить("Организация",Организация);
	возврат СтруктураДвижений;
КонецФункции


Процедура СформироватьДвижения() Экспорт
	УдалитьДвижения(Движения);
	СтруктураДвижений = СформироватьСтруктуруДвижений();

	Для каждого СтрПравило из ПравилаЗакрытия Цикл
		Попытка
			Справочники.абс_ПравилаЗакрытияСчетов.СформироватьПроводки(СтрПравило.Правило,СтруктураДвижений);		

		исключение
			ttk_ОбщегоНазначения.СообщитьОбОшибке("ошибка в правиле "+СтрПравило.Правило+"
			|"+ОписаниеОшибки());

		КонецПопытки;
	КонецЦикла;
	
	Для каждого ЭлСтруктуры из СтруктураДвижений Цикл
		Если ЭлСтруктуры.Ключ = "Период" Тогда
			продолжить;
		КонецЕсли;
		
		Если ЭлСтруктуры.Ключ = "Организация" Тогда
			продолжить;
		КонецЕсли;
		
		Движения[ЭлСтруктуры.Ключ].Загрузить(ЭлСтруктуры.Значение);
	КонецЦикла;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
// Функция формирует табличный документ с печатной формой бухгалтерской справки.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Табличный документ - печатная форма бухгалтерской справки.
//
Функция ПечатьБухгалтерскойСправки()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОперацияБух.Организация,
	|	ОперацияБух.Номер,
	|	ОперацияБух.Дата,
	|	ОперацияБух.Содержание
	|ИЗ
	|	Документ.абс_УниверсальноеЗакрытиеСчета КАК ОперацияБух
	|ГДЕ
	|	ОперацияБух.Ссылка = &Ссылка";
	
	Док = Запрос.Выполнить().Выбрать();
	Док.Следующий();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХозрасчетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйДвиженияССубконто.СчетДт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт3,
	|	ХозрасчетныйДвиженияССубконто.СчетКт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт3,
	|	ХозрасчетныйДвиженияССубконто.Организация,
	|	ХозрасчетныйДвиженияССубконто.ВалютаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютаКт,
	|	ХозрасчетныйДвиженияССубконто.Сумма,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоДт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоКт,
	|	ХозрасчетныйДвиженияССубконто.Содержание
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор = &Регистратор) КАК ХозрасчетныйДвиженияССубконто
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ВыборкаДвижений = Запрос.Выполнить().Выбрать();
	
	Макет = ПолучитьМакет("БухгалтерскаяСправка");
	
	// Получаем области макета для вывода в табличный документ.
	ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ПодвалТаблицы    = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ПодвалДокумента  = Макет.ПолучитьОбласть("Подвал");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию.
	ТабДокумент.ПолеСверху              = 10;
	ТабДокумент.ПолеСлева               = 0;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 0;
	ТабДокумент.РазмерКолонтитулаСверху = 10;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	
	// Загрузим настройки пользователя.
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОперацияБух_БухгалтерскаяСправка";

	// Выведем шапку документа.
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Док.Организация, Док.Дата);
	
	ШапкаДокумента.Параметры.Организация    = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
	ШапкаДокумента.Параметры.НомерДокумента = ОбщегоНазначения.ПолучитьНомерНаПечать(Док);
	ШапкаДокумента.Параметры.ДатаДокумента  = Формат(Док.Дата, "ДЛФ=D");
	ШапкаДокумента.Параметры.Содержание     = Док.Комментарий;
	
	ТабДокумент.Вывести(ШапкаДокумента);
	
	// Выведем заголовок таблицы.
	ТабДокумент.Вывести(ЗаголовокТаблицы);
	
	// Выведем строки документа.
	Пока ВыборкаДвижений.Следующий() Цикл
		
		СтрокаТаблицы.Параметры.Заполнить(ВыборкаДвижений);
		
		АналитикаДт = Строка(ВыборкаДвижений.СубконтоДт1) + Символы.ПС
		            + Строка(ВыборкаДвижений.СубконтоДт2) + Символы.ПС
                    + Строка(ВыборкаДвижений.СубконтоДт3);
					
		АналитикаКт = Строка(ВыборкаДвижений.СубконтоКт1) + Символы.ПС
		            + Строка(ВыборкаДвижений.СубконтоКт2) + Символы.ПС
                    + Строка(ВыборкаДвижений.СубконтоКт3);
					
		СтрокаТаблицы.Параметры.АналитикаДт = АналитикаДт;
		СтрокаТаблицы.Параметры.АналитикаКт = АналитикаКт;
									 
		// Проверим, помещается ли строка с подвалом.
		СтрокаСПодвалом = Новый Массив;
		СтрокаСПодвалом.Добавить(СтрокаТаблицы);
		СтрокаСПодвалом.Добавить(ПодвалТаблицы);
		СтрокаСПодвалом.Добавить(ПодвалДокумента);
		
		Если НЕ ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
			
			// Выведем подвал таблицы.
			ТабДокумент.Вывести(ПодвалТаблицы);
				
			// Выведем разрыв страницы.
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

			// Выведем заголовок таблицы.
			ТабДокумент.Вывести(ЗаголовокТаблицы);
			
		КонецЕсли;
		
		ТабДокумент.Вывести(СтрокаТаблицы);
		
	КонецЦикла;
	
	// Выведем подвал таблицы.
	ТабДокумент.Вывести(ПодвалТаблицы);
	
	// Выведем подвал документа.
	ПодвалДокумента.Параметры.РасшифровкаПодписиИсполнителя = ?(НЕ ЗначениеЗаполнено(Ответственный), "", ОбщегоНазначения.ФамилияИнициалыФизЛица(Ответственный.ФизЛицо));
	ТабДокумент.Вывести(ПодвалДокумента);
	
	Возврат ТабДокумент;
		
КонецФункции // ПечатьБухгалтерскойСправки()
	
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
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	ИначеЕсли ИмяМакета = "БухгалтерскаяСправка" Тогда

		ТабДокумент = ПечатьБухгалтерскойСправки();
		
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
	
	Возврат Новый Структура("БухгалтерскаяСправка", "Бухгалтерская справка");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)

	Если ТипЗнч(ОбъектКопирования) <> Тип("ДокументОбъект.ОперацияБух") Тогда
		Возврат;
	КонецЕсли;

	Организация   = ОбъектКопирования.Организация;
	Комментарий   = ОбъектКопирования.Комментарий;
	Содержание    = ОбъектКопирования.Содержание;
	Ответственный = ОбъектКопирования.Ответственный;

	ДвиженияБУ = РегистрыБухгалтерии.Хозрасчетный.ВыбратьПоРегистратору(ОбъектКопирования.Ссылка);

	Пока ДвиженияБУ.Следующий() Цикл

		Проводка = Движения.Хозрасчетный.Добавить();

		Проводка.СчетДт          = ДвиженияБУ.СчетДт;
		Проводка.СчетКт          = ДвиженияБУ.СчетКт;

		Для каждого Субконто Из ДвиженияБУ.СубконтоДт Цикл
			Проводка.СубконтоДт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Для каждого Субконто Из ДвиженияБУ.СубконтоКт Цикл
			Проводка.СубконтоКт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Проводка.ВалютаДт        = ДвиженияБУ.ВалютаДт;
		Проводка.ВалютаКт        = ДвиженияБУ.ВалютаКт;
		Проводка.ВалютнаяСуммаДт = ДвиженияБУ.ВалютнаяСуммаДт;
		Проводка.ВалютнаяСуммаКт = ДвиженияБУ.ВалютнаяСуммаКт;
		Проводка.КоличествоДт    = ДвиженияБУ.КоличествоДт;
		Проводка.КоличествоКт    = ДвиженияБУ.КоличествоКт;
		Проводка.НомерЖурнала    = ДвиженияБУ.НомерЖурнала;
		Проводка.Организация     = ДвиженияБУ.Организация;
		Проводка.Содержание      = ДвиженияБУ.Содержание;
		Проводка.Сумма           = ДвиженияБУ.Сумма;

	КонецЦикла;

	ДвиженияНУ = РегистрыБухгалтерии.Налоговый.ВыбратьПоРегистратору(ОбъектКопирования.Ссылка);

	Пока ДвиженияНУ.Следующий() Цикл

		Проводка = Движения.Налоговый.Добавить();

		Проводка.СчетДт          = ДвиженияНУ.СчетДт;
		Проводка.СчетКт          = ДвиженияНУ.СчетКт;

		Для каждого Субконто Из ДвиженияНУ.СубконтоДт Цикл
			Проводка.СубконтоДт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Для каждого Субконто Из ДвиженияНУ.СубконтоКт Цикл
			Проводка.СубконтоКт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Проводка.КоличествоДт    = ДвиженияНУ.КоличествоДт;
		Проводка.КоличествоКт    = ДвиженияНУ.КоличествоКт;
		Проводка.НомерЖурнала    = ДвиженияНУ.НомерЖурнала;
		Проводка.Организация     = ДвиженияНУ.Организация;
		Проводка.ВидУчетаДт      = ДвиженияНУ.ВидУчетаДт;
		Проводка.ВидУчетаКт      = ДвиженияНУ.ВидУчетаКт;
		Проводка.Содержание      = ДвиженияНУ.Содержание;
		Проводка.Сумма           = ДвиженияНУ.Сумма;

	КонецЦикла;

КонецПроцедуры // ПриКопировании()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	ЭтоНовыйДокумент = Ссылка.Пустая();

	Если ЭтоНовыйДокумент Тогда
		РанееУстановленнаяПометкаУдаления = Ложь;

	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст ="
		|ВЫБРАТЬ 
		|	0 
		|ИЗ
		|	Документ.ОперацияБух КАК Операция
		|
		|ГДЕ
		|	(Операция.Ссылка = &СсылкаНаОперацию) И
		|	(Операция.ПометкаУдаления = Ложь)";

		Запрос.УстановитьПараметр("СсылкаНаОперацию", Ссылка); 
		Результат = Запрос.Выполнить();
		РанееУстановленнаяПометкаУдаления = Результат.Пустой();

	КонецЕсли;

	Если ПометкаУдаления <> РанееУстановленнаяПометкаУдаления Тогда

		Для каждого ПроводкиДокумента из Движения Цикл

			Если (НЕ ПроводкиДокумента.Модифицированность()) И 
					(НЕ ПроводкиДокумента.Выбран()) И
					(НЕ ЭтоНовыйДокумент) Тогда

				ПроводкиДокумента.Прочитать();

			КонецЕсли;

			КоличествоПроводок = ПроводкиДокумента.Количество();

			Если КоличествоПроводок > 0 Тогда

				// Определяем текущую активность проводок по первой проводке
				ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;
				НужнаяАктивностьПроводок  = НЕ ПометкаУдаления;

				Если ТекущаяАктивностьПроводок <> НужнаяАктивностьПроводок Тогда
					ПроводкиДокумента.УстановитьАктивность(НужнаяАктивностьПроводок);
				КонецЕсли;

			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры


