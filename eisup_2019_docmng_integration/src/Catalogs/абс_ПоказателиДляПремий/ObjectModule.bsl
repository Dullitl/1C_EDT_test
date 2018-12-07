// Для выполнения расчета
Перем Период Экспорт, Показатель Экспорт, Сотрудник Экспорт, НачалоПериода Экспорт, КонецПериода Экспорт, МесяцНачисления Экспорт, Значение Экспорт, СсылкаНаДокумент Экспорт, Месяц Экспорт, ДатаНачала Экспорт, ДатаОкончания Экспорт;

Перем ТаблицаПоказателейПоСотруднику Экспорт;

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЯвляетсяКПЭ И ЭтоНовый() Тогда
				
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(абс_ПоказателиДляПремий.Код) КАК Код
		|ИЗ
		|	Справочник.абс_ПоказателиДляПремий КАК абс_ПоказателиДляПремий
		|ГДЕ
		|	ПОДСТРОКА(абс_ПоказателиДляПремий.Код, 9, 1) <> """"";
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Попытка
				ПоследнийНомер = Число(ВыборкаДетальныеЗаписи.Код);
			Исключение
				ПоследнийНомер = 0;
			КонецПопытки;
		иначе	
			ПоследнийНомер = 0;
		КонецЕсли;
		
		ПоследнийНомер = ПоследнийНомер + 1;
		
		Код = Прав("000000000" + Формат(ПоследнийНомер, "ЧГ="),9);
		
	КонецЕсли;	
	
	ПолучитьИдентификатор(Наименование, Идентификатор);
	
	Если НЕ ЭтоГруппа и Модифицированность() Тогда
		абс_ПоследнийИзменивший = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
	Если ЯвляетсяКПЭ И НЕ ЗначениеЗаполнено(Организация) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Не выбрана организация!", Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьИдентификатор(СтрНаименование, Идентификатор) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Разделители	=  " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
		
		Идентификатор = "";
		БылСпецСимвол = Ложь;
		Для НомСимвола = 1 По СтрДлина(СтрНаименование) Цикл
			Символ = Сред(СтрНаименование,НомСимвола,1);
			Если Найти(Разделители, Символ) <> 0 Тогда
				БылСпецСимвол = Истина;
			ИначеЕсли БылСпецСимвол Тогда
				БылСпецСимвол = Ложь;
				Идентификатор = Идентификатор + ВРег(Символ);
			Иначе
				Идентификатор = Идентификатор + Символ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры //ПолучитьИдентификатор

Процедура ВыполнитьМодуль(СтруктураПараметров = Неопределено, ДопПараметры = Неопределено) Экспорт
	
	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = ПолучитьСтруктуруПараметров();
	КонецЕсли;
	
	Если СтруктураПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗаписьЖурналаРегистрации("Выполнение модулей расчета показателей для премий", УровеньЖурналаРегистрации.Информация, , , "Запущен модуль расчета показателей для премий " + СокрЛП(Код) + ".");
		
	ТекстыЗапросов = Неопределено;
	
	Попытка 
		ТекстыЗапросов = ПолучитьСтруктуруТекстовЗапросов();
	Исключение
		Сообщить("Ошибка при заполнении структуры запросов:" + Символы.ПС + ОписаниеОшибки());		
	КонецПопытки;
	
	Если ВидВыполнения = Перечисления.абс_ВидыВыполненияМодулей.НаСервере Тогда
		
		ПараметрыПоказателя = Новый Структура;
		ПараметрыПоказателя.Вставить("Период"				, Период);  
		ПараметрыПоказателя.Вставить("Показатель"			, Показатель); 
		ПараметрыПоказателя.Вставить("Сотрудник"			, Сотрудник); 
		ПараметрыПоказателя.Вставить("НачалоПериода"		, НачалоПериода); 
		ПараметрыПоказателя.Вставить("КонецПериода"			, КонецПериода); 
		ПараметрыПоказателя.Вставить("МесяцНачисления"		, МесяцНачисления);
		ПараметрыПоказателя.Вставить("Значение"				, Значение);
		
		// + смирнова 16.07.13
		ПараметрыПоказателя.Вставить("ДатаНачала"			, ДатаНачала);
		ПараметрыПоказателя.Вставить("ДатаОкончания"		, ДатаОкончания);
		// - смирнова 16.07.13
		
		абс_СерверныеФункции.ВыполнитьКодПоказателяНаСервере(ТекстМодуля, СтруктураПараметров, ТекстыЗапросов, ДопПараметры, ПараметрыПоказателя);
		
		Значение = ПараметрыПоказателя.Значение; 
		
	Иначе
		
		ВыполнитьКодНаКлиенте(ТекстМодуля, СтруктураПараметров, ТекстыЗапросов, ДопПараметры);
		
	КонецЕсли;
	
	ЗаполнитьТаблицуПараметров(СтруктураПараметров);
	
	ЗаписьЖурналаРегистрации("Выполнение модулей расчета показателей для премий", УровеньЖурналаРегистрации.Информация, , , "Выполнен модуль расчета показателей для премий " + СокрЛП(Код) + ".");
	
КонецПроцедуры

Функция ЗаполнитьТаблицуПараметров(СтруктураПараметров)
	
	Если СтруктураПараметров.Количество() > 0 Тогда
		Параметры.Очистить();
		Для Каждого Элемент Из СтруктураПараметров Цикл
			НоваяСтрока = Параметры.Добавить();	
			НоваяСтрока.ИмяПараметра = Элемент.Ключ;
			НоваяСтрока.ЗначениеПараметра = Элемент.Значение;
		КонецЦикла;	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСтруктуруТекстовЗапросов(Отказ = Ложь) Экспорт
	
	СтруктураТекстовЗапросов = Новый Структура;
	
	Для Каждого СтрокаЗапрос Из Запросы Цикл
		
		СтруктураТекстовЗапросов.Вставить(СтрокаЗапрос.ИмяЗапроса, СтрокаЗапрос.ТекстЗапроса);
		
	КонецЦикла;
	
	Возврат СтруктураТекстовЗапросов;
	
КонецФункции

Функция ПолучитьСтруктуруПараметров(Отказ = Ложь) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	Для Каждого СтрокаПараметра Из Параметры Цикл
		
		Попытка 
			
			СтруктураПараметров.Вставить(СтрокаПараметра.ИмяПараметра, СтрокаПараметра.ЗначениеПараметра);
			
		Исключение
			
			Отказ = Истина;
			Сообщить("Ошибка при установке параметра № " + СтрокаПараметра.НомерСтроки + ": " + СтрокаПараметра.ИмяПараметра + "");
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция ПолучитьТаблицуПараметров(Отказ = Ложь) Экспорт
	
	ТаблицаПараметров = Новый ТаблицаЗначений;
	ТаблицаПараметров.Колонки.Добавить("ИмяПараметра");
	ТаблицаПараметров.Колонки.Добавить("ЭтоВыражение");
	ТаблицаПараметров.Колонки.Добавить("ЗначениеПараметра");
	
	Для Каждого СтрокаПараметраМодуля Из Параметры Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаПараметров.Добавить(), СтрокаПараметраМодуля);
		
	КонецЦикла;
	
	Возврат ТаблицаПараметров;
	
КонецФункции

Процедура ВыполнитьКодНаКлиенте(ТекстМодуля, СтруктураПараметров = Неопределено, СтруктураЗапросов = Неопределено, ДопПараметры = Неопределено) Экспорт
	
	Выполнить(ТекстМодуля);
	
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЯвляетсяКПЭ = Ложь;
	
	Если ДанныеЗаполнения <> Неопределено И ДанныеЗаполнения.Свойство("ЯвляетсяКПЭ") Тогда
		ЯвляетсяКПЭ = ДанныеЗаполнения.ЯвляетсяКПЭ;
	КонецЕсли;
	
	Если ЯвляетсяКПЭ Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;

КонецПроцедуры
