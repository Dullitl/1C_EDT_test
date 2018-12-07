&НаКлиенте
Процедура УстановитьДоступность()
	ЭтоЮрЛицо = (Объект.ЮрФизЛицо = ЮрФизЛицо_ЮрЛицо);
	Элементы.КПП.Доступность = ЭтоЮрЛицо;
	Элементы.ДокументУдостоверяющийЛичность.Доступность = НЕ ЭтоЮрЛицо;
	Элементы.НаименованиеПолное.Заголовок = ?(ЭтоЮрЛицо, "Полное наименование", "ФИО");
КонецПроцедуры

// Процедура контолирует длину ИНН и выводит сообщение.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЮрФизЛицо_ЮрЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	
	// Заполним список доступных статусов контрагента
	ЗаполнитьСписокВыбораСтатусов();
	
	// Установим режим просмотра документа
	УстановитьРежимПросмотраЭлемента();
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Если НЕ ЗначениеЗаполнено(Объект.абс_Ответственный) Тогда
			Объект.абс_Ответственный = ТекПользователь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.абс_Куратор) Тогда
			Объект.абс_Куратор = абс_БизнесПроцессы.ПолучитьСотрудникаПользователя(
				ТекПользователь);
		КонецЕсли;
		
		Объект.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Подготовка;
		
	КонецЕсли;		
		
	мСтатус = Объект.абс_СтатусКонтрагента;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	// Проверим заполненность реквизитов
	Если НЕ (Объект.Поставщик ИЛИ Объект.Покупатель) Тогда
		Сообщить("Контрагент не является ни поставщиком, ни покупателем.", СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;	
	
	Если НЕ Объект.НеЯвляетсяРезидентом Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
			Отказ = Истина;
			Сообщить("ИНН контрагента не заполнен.", СтатусСообщения.Внимание);
		КонецЕсли;
		
		Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") Тогда
			
			Если НЕ ЗначениеЗаполнено(Объект.КПП) Тогда
				Отказ = Истина;
				Сообщить("КПП контрагента не заполнен.", СтатусСообщения.Внимание);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.абс_ТипыКонтрагентов) Тогда
		Отказ = Истина;
		Сообщить("Не выбран тип контрагента.", СтатусСообщения.Внимание);
	КонецЕсли;
	
	ПроверитьСтрануПоТипуКонтрагента(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// Проверим длину ИНН.
	Если НЕ ПроверитьИНН() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	
	// Сформируем параметры записи.
	
	ПараметрыЗаписи.Вставить("ЭтоНовый", НЕ ЗначениеЗаполнено(Объект.Ссылка));
	
	// асб Добавлено 20101130 
	// Добавлено заполнение параметров записи для поддержки работы с БП
	ПараметрыЗаписи.Вставить("ЗапуститьБПСогласования"		, ЛОЖЬ);
	ПараметрыЗаписи.Вставить("ЗапуститьБППереутверждения"	, ЛОЖЬ);
	ПараметрыЗаписи.Вставить("ЗапуститьБПСменыРеквизитов"	, ЛОЖЬ);
	ПараметрыЗаписи.Вставить("ЗапуститьБПЗавершения"		, ЛОЖЬ);
	
	ВопросЗапуститьБП = ПолучитьВопросЗапуститьБП();
	
	Если НЕ ВопросЗапуститьБП = Неопределено Тогда
		//ПараметрыЗаписи[ВопросЗапуститьБП.ИмяПараметра] = 
		//	Вопрос(ВопросЗапуститьБП.ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да;
		
		// Вопрос не надо задавать
		ПараметрыЗаписи[ВопросЗапуститьБП.ИмяПараметра] = Истина;
	КонецЕсли;
	
	Объект.абс_ПричинаИзмененияСтатуса = "";
	Если СпрашиватьПричинуИзмененияСтатуса() Тогда
		ВвестиСтроку(Объект.абс_ПричинаИзмененияСтатуса, "Введите причину изменения статуса",,Истина);
		
		// АБС ВСТАВКА Вводим номера телефонов 
		абс_БизнесПроцессыКлиент.ВвестиВнутреннийНомерТелефона(ПолучитьДанныеПользователя());		
		
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ПричинаИзмененияСтатуса", Объект.абс_ПричинаИзмененияСтатуса);
	
	СтатусСогласованиеДЭБ = ПредопределенноеЗначение("Перечисление.абсСтатусыКонтрагентов.СогласованиеДЭБ");
	
	Если  ПолучитьСтатусКонтрагентаИзСсылки() = СтатусСогласованиеДЭБ 
		И НЕ Объект.абс_СтатусКонтрагента = СтатусСогласованиеДЭБ Тогда
		
		Объект.абс_ДатаПроверкиДЭБ = абс_СерверныеФункции.ПолучитьДатуСервера();
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.абс_СтатусКонтрагента) Тогда
		Объект.абс_СтатусКонтрагента = ПредопределенноеЗначение("Перечисление.абсСтатусыКонтрагентов.Подготовка");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтрануПоТипуКонтрагента(Отказ)
	
	// АБС ВСТАВКА 13096
	Если Объект.Ссылка.абс_СтатусКонтрагента = ПредопределенноеЗначение("Перечисление.абсСтатусыКонтрагентов.Подготовка") И 
		НЕ Объект.абс_СтатусКонтрагента = ПредопределенноеЗначение("Перечисление.абсСтатусыКонтрагентов.Подготовка") И НЕ Объект.абс_СтатусКонтрагента = ПредопределенноеЗначение("Перечисление.абсСтатусыКонтрагентов.Архив") Тогда
		
		//Если абс_ТипыКонтрагентов.НеЯвляетсяРезидентом Тогда
			
		Если НЕ ЗначениеЗаполнено(Объект.абс_Страна) Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Не заполнена страна", Отказ);
		КонецЕсли;
		//КонецЕсли;		
	КонецЕсли;	
	// АБС ВСТАВКА 13096 КОНЕЦ	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПользователя() 
	
	СтруктураПользователя = Новый Структура("Пользователь, ВнутреннийНомер");
	
	СтруктураПользователя.Пользователь 		= глЗначениеПеременной("глТекущийПользователь");
	СтруктураПользователя.ВнутреннийНомер 	= СтруктураПользователя.Пользователь.абс_ВнутреннийНомер;
	
	Возврат СтруктураПользователя;
	
КонецФункции

&НаСервере
Функция ПолучитьСтатусКонтрагентаИзСсылки()
	
	Возврат Объект.Ссылка.абс_СтатусКонтрагента;
	
КонецФункции

&НаКлиенте
Функция ПроверитьИНН()

	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// АБС ВСТАВКА ПроверкаИНН
	Если НЕ Объект.НеЯвляетсяРезидентом Тогда
		Возврат Истина;
	КонецЕсли;
	// АБС ВСТАВКА ПроверкаИНН КОНЕЦ

	ДлинаИНН       = СтрДлина(Объект.ИНН);
	ТекстСообщения = "";

	Сообщить("Проверка ИНН, Длина ИНН: " + ДлинаИНН);
	
	Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо") Тогда
		Если НЕ ДлинаИНН = 12 Тогда
			ТекстСообщения = """ИНН"" физического лица 12 символов!";
		КонецЕсли;
	Иначе
		Если НЕ ДлинаИНН = 10 Тогда
			ТекстСообщения = """ИНН"" юридического лица 10 символов!";
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Длина ""ИНН"" не соответствует требованиям: " + ТекстСообщения);
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ПараметрыЗаписи.ЭтоНовый ИЛИ ТекущийОбъект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	//Если  НЕ ЗначениеЗаполнено(ТекущийОбъект.ОсновнойДоговорКонтрагента) Тогда
	//	ПроверитьОсновнойДоговорКонтрагента(ТекущийОбъект, Отказ);
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущийОбъект.ГоловнойКонтрагент) Тогда
		ТекущийОбъект.ГоловнойКонтрагент = ТекущийОбъект.Ссылка;
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ПроверитьОсновнойДоговорКонтрагента(ТекущийОбъект, Отказ)
	ВыборкаДоговоров = Справочники.ДоговорыКонтрагентов.Выбрать(, ТекущийОбъект.Ссылка);
	Если ВыборкаДоговоров.Следующий() Тогда
		ТекущийОбъект.ОсновнойДоговорКонтрагента = ВыборкаДоговоров.Ссылка;
	Иначе
		НайденныйДоговорОбъект              = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
		НайденныйДоговорОбъект.Наименование = "Основной договор";

		НайденныйДоговорОбъект.ВалютаВзаиморасчетов = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяВалютаВзаиморасчетов");
		Если НЕ ЗначениеЗаполнено(НайденныйДоговорОбъект.ВалютаВзаиморасчетов) Тогда
			НайденныйДоговорОбъект.ВалютаВзаиморасчетов = Константы.ВалютаУправленческогоУчета.Получить();
		КонецЕсли;

		НайденныйДоговорОбъект.Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Если НЕ ЗначениеЗаполнено(НайденныйДоговорОбъект.Организация) Тогда
			Запрос = Новый Запрос();
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			               |	Организации.Ссылка
			               |ИЗ
			               |	Справочник.Организации КАК Организации";
			Результат = Запрос.Выполнить();
			Если НЕ Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				НайденныйДоговорОбъект.Организация = Выборка.Ссылка;
			Иначе
				СтрокаСообщения = Нстр("ru = 'Не удалось записать основной договор контрагента (не найдена организация)'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, ТекущийОбъект,,, Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;

		НайденныйДоговорОбъект.Владелец           = ТекущийОбъект.Ссылка;
		НайденныйДоговорОбъект.ВидУсловийДоговора = Перечисления.ВидыУсловийДоговоровВзаиморасчетов.БезДополнительныхУсловий;

		Если ТекущийОбъект.Покупатель Тогда
			НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем;
			НайденныйДоговорОбъект.ТипЦен      = Справочники.ТипыЦенНоменклатуры.ПустаяСсылка();
		ИначеЕсли ТекущийОбъект.Поставщик Тогда
			НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
			НайденныйДоговорОбъект.ТипЦен      = Справочники.ТипыЦенНоменклатурыКонтрагентов.ПустаяСсылка();
		Иначе
			НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее;
		КонецЕсли;

		Если НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда
			НайденныйДоговорОбъект.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
		Иначе
			НайденныйДоговорОбъект.ВедениеВзаиморасчетов = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновноеВедениеВзаиморасчетовПоДоговорам");
			Если НЕ ЗначениеЗаполнено(НайденныйДоговорОбъект.ВедениеВзаиморасчетов) Тогда
				НайденныйДоговорОбъект.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
			КонецЕсли;
			НайденныйДоговорОбъект.ВестиПоДокументамРасчетовСКонтрагентом = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновныеРасчетыПоДокументамСКонтрагентами");
		КонецЕсли;


		Если (НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком
		 ИЛИ  НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем)
		   И НайденныйДоговорОбъект.ВалютаВзаиморасчетов <> Константы.ВалютаРегламентированногоУчета.Получить() Тогда
			НайденныйДоговорОбъект.РасчетыВУсловныхЕдиницах = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновныеРасчетыПоДоговоруВУсловныхЕдиницах");
		КонецЕсли;

		Если НайденныйДоговорОбъект.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
		 ИЛИ НайденныйДоговорОбъект.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
			НайденныйДоговорОбъект.ОбособленныйУчетТоваровПоЗаказамПокупателей = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОбособленныйУчетТоваровПоЗаказамПокупателей");
		КонецЕсли;

		Если НайденныйДоговорОбъект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
			НайденныйДоговорОбъект.ПроцентПредоплаты = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойРазмерПредоплатыПоЗаказуПокупателя");
		КонецЕсли;
		СтрокаСообщения = "";
		Попытка
			// АБС ВСТАВКА СогласованиеДоговоров
			НайденныйДоговорОбъект.абс_СтатусДоговора = Перечисления.абсСтатусыДоговоров.Подготовка;		
			// АБС ВСТАВКА СогласованиеДоговоров КОНЕЦ
			
			НайденныйДоговорОбъект.Записать();
			
			// АБС ВСТАВКА СогласованиеДоговоров
			НайденныйДоговорОбъект.ЗаписатьНовыйСтатус(Перечисления.абсСтатусыДоговоров.Подготовка);
			// АБС ВСТАВКА СогласованиеДоговоров КОНЕЦ
		Исключение
			СтрокаСообщения = Нстр("ru = 'Не удалось записать основной договор контрагента: '") + ОписаниеОшибки();
		КонецПопытки;
		Если СтрокаСообщения <> "" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, ТекущийОбъект,,, Отказ);
			Возврат;
		КонецЕсли;
		
		ТекущийОбъект.ОсновнойДоговорКонтрагента = НайденныйДоговорОбъект.Ссылка;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	// заполним КПП по первым 4-м цифрам ИНН
	Если (СтрДлина(Объект.ИНН) < 4) Тогда
		Возврат;
	КонецЕсли;
	ПравыеСимволыИНН = Лев(Объект.ИНН, 4);
	Объект.КПП = ПравыеСимволыИНН + "01001";
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатусов()
	
	Список = Элементы.Статус.СписокВыбора;
	
	мТекущийПользователь 	= глЗначениеПеременной("глТекущийПользователь");	
	мРолиПользователя 		= абс_БизнесПроцессы.ПолучитьСписокДоступныхРолейПользователя(мТекущийПользователь);
	
	Список.Очистить();
	
	ТекСтатус = абс_БизнесПроцессы.ПолучитьСтатусКонтрагентаПоРегистру(Объект.Ссылка);
	//ТекСтатус = Объект.Ссылка.абс_СтатусКонтрагента;
	
	// Если еще нету никакого статуса
	Если НЕ ЗначениеЗаполнено(ТекСтатус) Тогда
		Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Подготовка);
		
		Возврат;
	Иначе
		Список.Добавить(ТекСтатус);
	КонецЕсли;
	
	Если ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Подготовка Тогда
		
		//АБС+
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СотрудникИнициаторКомпании) = Неопределено
			или НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СуперПользователь) = Неопределено Тогда
			
			Если ЗначениеЗаполнено(НайтиБПСогласование()) 
				И абс_БизнесПроцессы.КонтрагентИзБиллинга(Объект.Ссылка) Тогда
				Список.Добавить(Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ);
			Иначе
				Список.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
			КонецЕсли;		
			
			//Если  абс_БизнесПроцессы.ПроверитьДоговорыКонтрагентаАрхив(Объект.Ссылка)
			//	И Объект.абс_Ответственный = мТекущийПользователь Тогда
			
			// Сотрудник ДФМ или Суперпользователь может отправить контрагента в архив
			Если  абс_БизнесПроцессы.ПроверитьДоговорыКонтрагентаАрхив(Объект.Ссылка)
				И  	   (НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.ПроверкаДФМ) = Неопределено
				ИЛИ НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СуперПользователь) = Неопределено) Тогда
				
				Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Архив);
				
			КонецЕсли;
			
		КонецЕсли;
		//\\АБС-
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ Тогда
		
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СогласованиеДЭБ) = Неопределено Тогда
			
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ);
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Отказ);
		КонецЕсли;			
		
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ Тогда
		
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.ПроверкаКонтрагентаДФМ) = Неопределено Тогда
			
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Активный);			
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Отказ);	
		КонецЕсли;
		
	// АБС 20101206 Удалили проверку ПД
	//ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СогласованиеПД Тогда
	//	
	//	Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СогласованиеПД) = Неопределено Тогда
	//		СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
	//		СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ);
	//		СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.Отказ);
	//	КонецЕсли;		
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Активный Тогда
		
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.Переутверждение) = Неопределено Тогда
			
			// АБС ИЗМЕНЕНО 55627
			// СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.Переутверждение);
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
		КонецЕсли;
		
		Если    (НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.ПроверкаДФМ) 	= Неопределено)
			ИЛИ (НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СогласованиеДЭБ) = Неопределено) 
			ИЛИ (НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СогласованиеБухгалтером) = Неопределено)
			ИЛИ (мТекущийПользователь = Объект.абс_Ответственный)
			ИЛИ (абс_БизнесПроцессы.ПолучитьСотрудникаПользователя(мТекущийПользователь) = Объект.абс_Куратор) Тогда
			
			//Список.Добавить(Перечисления.абсСтатусыКонтрагентов.СменаРеквизитов);
		КонецЕсли;
		
		Если Объект.абс_Ответственный = мТекущийПользователь
			ИЛИ (НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СуперПользователь) = Неопределено) Тогда
			
			Если абс_БизнесПроцессы.ПроверитьДоговорыКонтрагентаЗавершениеОтношений(Объект.Ссылка) Тогда
				Список.Добавить(Перечисления.абсСтатусыКонтрагентов.ЗавершениеОтношений);
			КонецЕсли;
		КонецЕсли;
		
	// АБС ИЗМЕНЕНО 55627	
	// Состояние Переутвеждение удаляем
	//ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Переутверждение Тогда
	//	
	//	Если Не МассивРолей.Найти(Справочники.РолиИсполнителей.Переутверждение) = Неопределено Тогда
	//		СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
	//	КонецЕсли;
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СменаРеквизитов Тогда
		
		Если Не мРолиПользователя.Найти(Справочники.РолиИсполнителей.ИзменениеРеквизитовКонтрагентов) = Неопределено Тогда
			//Список.Добавить(Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ);
		КонецЕсли;			
		
		// АБС ИЗМЕНЕНО АБС-Ф 20111117 Заявка на изменение реквизитов контрагентов
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.Переутверждение) = Неопределено Тогда
			
			// АБС ИЗМЕНЕНО 55627
			// СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.Переутверждение);
			//Список.Добавить(Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ);
		КонецЕсли;
			
	
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.ЗавершениеОтношений Тогда
		
		Если НЕ мРолиПользователя.Найти(Справочники.РолиИсполнителей.СогласованиеДЭБ) = Неопределено Тогда
						
			Если абс_БизнесПроцессы.ПроверитьДоговорыКонтрагентаЗакрытие(Объект.Ссылка) Тогда
				Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Закрыт);
			КонецЕсли;
			
			Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Активный);
		КонецЕсли;		
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Отказ Тогда
		МассивПользователей =Новый Массив;
		МассивСотрудников  =Новый Массив;
		МассивСотрудников.Добавить(Объект.абс_Куратор);
		МассивПользователей = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(МассивСотрудников);
		
		//Если  (Объект.абс_Ответственный = мТекущийПользователь) 
		//	ИЛИ (МассивПользователей.Найти(мТекущийПользователь)<>Неопределено)
		//	ИЛИ (мРолиПользователя.Найти(Справочники.РолиИсполнителей.СуперПользователь) <> Неопределено) Тогда
		//	
		//	Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Подготовка);
		//КонецЕсли;
		
		// АБС ВСТАВКА Фролов Подготовка доступна для всех пользователей
		Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Подготовка);

		//Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Подготовка);
		//Список.Добавить(Перечисления.абсСтатусыКонтрагентов.Переутверждение);
		
	// АБС ИЗМЕНЕНО 55627
	// Состояние Переутверждение удаляем.
	//ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Закрыт Тогда
	//	СписокСтатусов.Добавить(Перечисления.абсСтатусыКонтрагентов.Переутверждение);
	    
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокДоступныхРолейПользователя()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РолиИИсполнители.Роль
	                      |ИЗ
	                      |	РегистрСведений.РолиИИсполнители КАК РолиИИсполнители
	                      |ГДЕ
	                      |	РолиИИсполнители.Исполнитель = &ТекПользователь
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	РолиИИсполнители.Роль");
	Запрос.УстановитьПараметр("ТекПользователь", глЗначениеПеременной("глТекущийПользователь"));
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Роль");
КонецФункции

&НаСервере
Процедура УстановитьРежимПросмотраЭлемента()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_ТаблицаСтатусовБПТТК.РедактированиеДокумента КАК Редактирование,
	                      |	абс_ТаблицаСтатусовБПТТК.ОтветственныйЗаИзменениеСтатуса
	                      |ИЗ
	                      |	РегистрСведений.абс_ТаблицаСтатусовБПТТК КАК абс_ТаблицаСтатусовБПТТК
	                      |ГДЕ
	                      |	абс_ТаблицаСтатусовБПТТК.ВидБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.абсВидыБизнесПроцессовТТК.СогласованиеКонтрагентов)
	                      |	И абс_ТаблицаСтатусовБПТТК.Статус = &ТекСтатус");
						  
	Запрос.УстановитьПараметр("ТекСтатус", Объект.абс_СтатусКонтрагента);
	
	РазрешеноРедактирование = Ложь;
	РазрешеноМенятьСтатус 	= Ложь;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивРолей = абс_БизнесПроцессы.ПолучитьСписокДоступныхРолейПользователя();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ МассивРолей.Найти(Выборка.ОтветственныйЗаИзменениеСтатуса) = Неопределено Тогда
			РазрешеноМенятьСтатус = Истина
		КонецЕсли;
		
		РазрешеноРедактирование = РазрешеноРедактирование ИЛИ Выборка.Редактирование;
	КонецЦикла;
	
	// Если есть задачи текущему пользователю, то ему разрешено изменить статус
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абсЗадачаДоговораЗадачиПоИсполнителю.Ссылка
	                      |ИЗ
	                      |	Задача.абсЗадачаДоговора.ЗадачиПоИсполнителю(
	                      |			&ТекПользователь,
	                      |			ОбъектЗадачи = &КонтрагентСсылка
	                      |				И Выполнена = ЛОЖЬ) КАК абсЗадачаДоговораЗадачиПоИсполнителю");
						  
	Запрос.УстановитьПараметр("ТекПользователь"	, ТекПользователь);
	Запрос.УстановитьПараметр("КонтрагентСсылка", Объект.Ссылка);
	
	ВыборкаЗадач = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗадач.Следующий() Тогда
		
		РазрешеноМенятьСтатус = Истина;
		
	КонецЕсли;
	
	// АБС ВСТАВКА ПереутверждениеКонтрагентов
	// Если статус активный и у пользователя есть роль переутверждения то он может менять статус
	// АБС ИЗМЕНЕНО АБС-Ф 20111117 Заявка на изменение реквизитов контрагентов
	Если (Объект.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Активный ИЛИ 
		  Объект.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.СменаРеквизитов) И 
			НЕ МассивРолей.Найти(Справочники.РолиИсполнителей.Переутверждение) = Неопределено Тогда
		
		РазрешеноМенятьСтатус = Истина;
		
	КонецЕсли;
	
	// АБС ВСТАВКА ПереутверждениеКонтрагентов КОНЕЦ
	
	//АБС+
	Если (Объект.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Подготовка или Объект.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Отказ) 
		и (НЕ МассивРолей.Найти(Справочники.РолиИсполнителей.СотрудникИнициаторКомпании) = Неопределено 
		      или НЕ МассивРолей.Найти(Справочники.РолиИсполнителей.СуперПользователь) = Неопределено ) Тогда
		
		РазрешеноМенятьСтатус   = Истина;
		РазрешеноРедактирование = Истина;
		
	КонецЕсли;
	//\\АБС-
	
	// Список статусов заполняется до установки режима просмотра документа
	//  с учетом прав и ролей пользователя
	// Поэтому проверяем возможность изменения статуса по наличию элементов в списке статусов
	Если Элементы.Статус.СписокВыбора.Количество() > 1 Тогда
		РазрешеноМенятьСтатус = Истина;
	Иначе
		РазрешеноМенятьСтатус = Ложь;
	КонецЕсли;	
			
	// Установим необходимый вид просмотра документа
	Если НЕ РазрешеноРедактирование Тогда
		
		ТолькоПросмотр = Истина;
		
		//ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ЗаписатьСтатус.Доступность = РазрешеноМенятьСтатус;
	
	КонецЕсли;
	
	// Установим доступность кнопок Записать и закрыть и Записать
	Элементы.КнопкаЗаписатьСтатусЗакрыть.Доступность 	= РазрешеноРедактирование ИЛИ РазрешеноМенятьСтатус;
	Элементы.КнопкаЗаписатьСтатус.Доступность 			= РазрешеноРедактирование ИЛИ РазрешеноМенятьСтатус;	
	
	// Файлы разрешено прикреплять только в статусе Подготовка
	
	//ЭлементыФормы.ДействияФормы.Кнопки.Файлы.Доступность = 
	//	Ссылка.абс_СтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Подготовка;
	//
	//ЭлементыФормы.Статус.Доступность = РазрешеноМенятьСтатус;
	
	мСтатусКонтрагента = Объект.абс_СтатусКонтрагента;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВопросЗапуститьБП()
	// В принципе возможен только один вариант вопроса.
	ТекСтатус = Объект.абс_СтатусКонтрагента;
	
	Если ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Подготовка И НайтиБПСогласование() = Неопределено Тогда
		Возврат Новый Структура("ИмяПараметра, ТекстВопроса", "ЗапуститьБПСогласования"		
			, "Запустить бизнес-процесс согласования контрагента?");
	ИначеЕсли  (ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ 
			ИЛИ ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СменаРеквизитов) 
			И НайтиБППереутверждение() = Неопределено Тогда
			
			Если ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ Тогда
				Возврат Новый Структура("ИмяПараметра, ТекстВопроса", "ЗапуститьБППереутверждения"	
					, "Запустить бизнес-процесс переутверждения контрагента?");
			ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СменаРеквизитов Тогда
				Возврат Новый Структура("ИмяПараметра, ТекстВопроса", "ЗапуститьБПСменыРеквизитов"	
					, "Запустить бизнес-процесс смены реквизитов контрагента?");				
			КонецЕсли;
			
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.ЗавершениеОтношений И НайтиБПЗавершениеОтношений() = Неопределено Тогда
		Возврат Новый Структура("ИмяПараметра, ТекстВопроса", "ЗапуститьБПЗавершения"		
			, "Запустить бизнес-процесс завершения отношений с контрагентом?");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция СпрашиватьПричинуИзмененияСтатуса()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	Возврат НЕ Объект.абс_СтатусКонтрагента = Объект.Ссылка.абс_СтатусКонтрагента;
	
КонецФункции

// Процедура ПослеЗаписи
//  запускает необходимые процедуры и функции для поддержки БП
//   1. Изменение статуса контрагента в регистре сведений
//	 2. Запускает соответствующие изменению состоянию бизнес-процессы
// 	 3. Выполняет соответствующие изменению состоянию задачи по бизнес-процессу
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		
	// Обновим список досупных состояний
	ЗаполнитьСписокВыбораСтатусов();
	
	// Установим режим просмотра документа
	УстановитьРежимПросмотраЭлемента();
		
	мСтатус = Объект.абс_СтатусКонтрагента;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачиТТКПоКонтрагенту()
	
	// Попробуем закрыть задачу согласования
	ЗадачаСогласование = ПолучитьЗадачуПоКонтрагентуСогласование();
	
	Если НЕ ЗадачаСогласование = Неопределено Тогда	
		Если НЕ ЗадачаСогласование.Выполнена Тогда
			
			ЗадачаОбъект = ЗадачаСогласование.ПолучитьОбъект();	
			
			ЗадачаОбъект.ВыполнитьЗадачу();
			
			ЗадачаОбъект.Записать();
			
			Если Не ЗначениеЗаполнено(ЗадачаОбъект.БизнесПроцесс.Контрагент) Тогда
				
				БПОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
				
				БПОбъект.Контрагент = Объект.Ссылка;
				
				БПОбъект.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// Попробуем закрыть задачу переутрвеждения				
	ЗадачаПереутверждение = ПолучитьЗадачуПоКонтрагентуПереутверждение();
	
	Если НЕ ЗадачаПереутверждение = Неопределено Тогда
		Если НЕ ЗадачаПереутверждение.Выполнена Тогда
			
			ЗадачаОбъект = ЗадачаПереутверждение.ПолучитьОбъект();	
			
			ЗадачаОбъект.ВыполнитьЗадачу();
			
			ЗадачаОбъект.Записать();
			
		КонецЕсли;		
	КонецЕсли;
		
	// Попробуем закрыть задачу завершения				
	ЗадачаЗавершение = ПолучитьЗадачуПоКонтрагентуЗавершение();
	
	Если НЕ ЗадачаЗавершение = Неопределено Тогда	
		
		Если НЕ ЗадачаЗавершение.Выполнена Тогда
			
			ЗадачаОбъект = ЗадачаЗавершение.ПолучитьОбъект();	
			
			ЗадачаОбъект.ВыполнитьЗадачу();
			
			ЗадачаОбъект.Записать();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНовыйСтатус(НовыйСтатус, Комментарий = Неопределено) Экспорт
	НаборЗаписей = РегистрыСведений.абс_ИзменениеСтатусовКонтрагентов.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Контрагент.Установить(Объект.Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = абс_СерверныеФункции.ПолучитьДатуСервера();

	Запись.Контрагент			= Объект.Ссылка;
	Запись.Пользователь 		= глЗначениеПеременной("глТекущийПользователь");	
	Запись.СтатусКонтрагента	= НовыйСтатус;
	
	Запись.Комментарий 			= Комментарий;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусКонтрагентаВРегистре(ПараметрыЗаписи)
	
	Если НЕ Объект.абс_СтатусКонтрагента = абс_БизнесПроцессы.ПолучитьСтатусКонтрагентаПоРегистру(Объект.Ссылка) Тогда
		ЗаписатьНовыйСтатус(Объект.абс_СтатусКонтрагента, ПараметрыЗаписи.ПричинаИзмененияСтатуса);
	КонецЕсли;
	
КонецПроцедуры

// Функции поиска бизнес процессов
&НаСервере
Функция НайтиБизнесПроцессПоКонтрагенту(ИмяБизнесПроцесса)
	БП = Неопределено;
	
	ЗапросБП = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                        |	абсБП.Ссылка
	                        |ИЗ
	                        |	БизнесПроцесс." + ИмяБизнесПроцесса + " КАК абсБП
	                        |ГДЕ
	                        |	абсБП.Контрагент = &Контрагент И
							|	абсБП.Завершен = ЛОЖЬ
	                        |
	                        |УПОРЯДОЧИТЬ ПО
	                        |	абсБП.Дата УБЫВ");
							
	ЗапросБП.УстановитьПараметр("Контрагент", Объект.Ссылка);
	
	ВыборкаБП = ЗапросБП.Выполнить().Выбрать();
	
	Если ВыборкаБП.Следующий() Тогда
		БП = ВыборкаБП.Ссылка;
	КонецЕсли;
	
	Возврат БП;
		
КонецФункции

&НаСервере
Функция НайтиБПСогласование()
	
	Возврат абс_БизнесПроцессы.НайтиБизнесПроцессПоКонтрагенту(Объект.Ссылка, "абсСогласованиеКонтрагентов");
	
КонецФункции

&НаСервере
Функция НайтиБППереутверждение()
	
	Возврат абс_БизнесПроцессы.НайтиБизнесПроцессПоКонтрагенту(Объект.Ссылка, "абсПереутверждениеКонтрагентов");
	
КонецФункции

&НаСервере
Функция НайтиБПЗавершениеОтношений()
	
	Возврат абс_БизнесПроцессы.НайтиБизнесПроцессПоКонтрагенту(Объект.Ссылка, "абсЗавершениеОтношенийСКонтрагентами");
	
КонецФункции

// Функции для поиска задач бизнесс процессов
&НаСервере
Функция НайтиЗадачуКонтрагента(БизнесПроцесс, ТочкаМаршрута, Исполнитель = Неопределено)
	Если Исполнитель = Неопределено Тогда
		Исполнитель = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;	
	
	ЗапросЗадач = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                           |	абсЗадачаДоговора.Ссылка
	                           |ИЗ
	                           |	Задача.абсЗадачаДоговора КАК абсЗадачаДоговора
	                           |ГДЕ
	                           |	абсЗадачаДоговора.БизнесПроцесс = &БизнесПроцесс
	                           |	И абсЗадачаДоговора.ТочкаМаршрута В (&ТочкаМаршрута)
	                           |	И абсЗадачаДоговора.Исполнитель = &Исполнитель
	                           |
	                           |УПОРЯДОЧИТЬ ПО
	                           |	абсЗадачаДоговора.Дата УБЫВ");
							   
							   
	ЗапросЗадач.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	ЗапросЗадач.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	ЗапросЗадач.УстановитьПараметр("Исполнитель", Исполнитель);
	
	ВыборкаЗадач = ЗапросЗадач.Выполнить().Выбрать();
	
	ЗадачаСсылка = Неопределено;
	
	Если ВыборкаЗадач.Следующий() Тогда
		ЗадачаСсылка = ВыборкаЗадач.Ссылка;
	КонецЕсли;
	
	Возврат ЗадачаСсылка;
	
КонецФункции

&НаСервере
Функция ПолучитьЗадачуПоКонтрагентуСогласование()
	
	БП = НайтиБПСогласование();
	
	Если БП = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекСтатусКонтрагента = Объект.Ссылка.абс_СтатусКонтрагента;

	СпТочек = Новый Массив;
	
	Если ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Подготовка Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеОтказ);
	ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ЗаполнениеКонтрагента);
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	//ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.СогласованиеПД Тогда		
	//	СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
	//	СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
	ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Активный Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
	ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Отказ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
		//СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеПД);
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	ИначеЕсли ТекСтатусКонтрагента = Перечисления.абсСтатусыКонтрагентов.Архив Тогда
		СпТочек.Добавить(БизнесПроцессы.абсСогласованиеКонтрагентов.ТочкиМаршрута.ЗаполнениеКонтрагента);
	КонецЕсли;
			
	Возврат абс_БизнесПроцессы.НайтиЗадачуКонтрагента(БП, СпТочек);

КонецФункции

&НаСервере
Функция ПолучитьЗадачуПоКонтрагентуЗавершение()
	
	БП = НайтиБПЗавершениеОтношений();
	
	Если БП = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТочкаМаршрута = Неопределено;
	
	ТекСтатус = Объект.Ссылка.абс_СтатусКонтрагента;
	
	Если ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Активный Тогда
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.ЗавершениеОтношений Тогда
		
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Закрыт Тогда		
		ТочкаМаршрута = БизнесПроцессы.абсЗавершениеОтношенийСКонтрагентами.ТочкиМаршрута.ДействиеСогласованиеДЭБ;
	КонецЕсли;
	
	Возврат абс_БизнесПроцессы.НайтиЗадачуКонтрагента(БП, ТочкаМаршрута);

КонецФункции

&НаСервере
Функция ПолучитьЗадачуПоКонтрагентуПереутверждение()
	
	БП = НайтиБППереутверждение();
	
	Если БП = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	СпТочек = Новый Массив;
	
	ТекСтатус = Объект.Ссылка.абс_СтатусКонтрагента;
	
	Если ТекСтатус = Перечисления.абсСтатусыКонтрагентов.ПроверкаДФМ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.Переутверждение);
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.СогласованиеДЭБ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Активный Тогда
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	ИначеЕсли ТекСтатус = Перечисления.абсСтатусыКонтрагентов.Отказ Тогда
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.ДействиеПроверкаДФМ);
		СпТочек.Добавить(БизнесПроцессы.абсПереутверждениеКонтрагентов.ТочкиМаршрута.ДействиеСогласованиеДЭБ);
	КонецЕсли;
			
	Возврат абс_БизнесПроцессы.НайтиЗадачуКонтрагента(БП, СпТочек);
	
КонецФункции

// Процедуры запуска бизнес-процессов

&НаКлиенте
Процедура ЗаписатьСтатусЗакрыть(Команда)
	
	Записать();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьСтатус(Команда)
	
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура мСтатусПриИзменении(Элемент)
	
	Объект.абс_СтатусКонтрагента = мСтатус;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипКонтрагентаПриИзменении(Элемент)
	
	ЗаполнитьПриИзмененииТипаКонтрагента();
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПриИзмененииТипаКонтрагента()
	
	Объект.ЮрФизЛицо 				= Объект.абс_ТипыКонтрагентов.ЮрФизЛицо;
	Объект.НеЯвляетсяРезидентом     = Объект.абс_ТипыКонтрагентов.НеЯвляетсяРезидентом;
	
	// АБС ВСТАВКА Фролов 13096
	Если Объект.НеЯвляетсяРезидентом И Объект.абс_Страна = Справочники.КлассификаторСтранМира.Россия Тогда
			
		Объект.абс_Страна = Справочники.КлассификаторСтранМира.ПустаяСсылка();
				
	ИначеЕсли НЕ Объект.НеЯвляетсяРезидентом И НЕ Объект.абс_Страна = Справочники.КлассификаторСтранМира.Россия Тогда
		
		Объект.абс_Страна = Справочники.КлассификаторСтранМира.Россия;
		
	КонецЕсли;
	// АБС ВСТАВКА Фролов 13096 КОНЕЦ	
	
КонецПроцедуры

&НаКлиенте
Процедура ОКОПФПриИзменении(Элемент)
	
	Объект.абс_ТипыКонтрагентов = ПредопределенноеЗначение("Справочник.абс_ТипыКонтрагентов.ПустаяСсылка");
	
	ЗаполнитьПриИзмененииТипаКонтрагента();
	
КонецПроцедуры

&НаСервере 
Функция СоздатьНовыйДокумент() 
  НовыйДокумент = Документы.ПриходнаяНакладная.СоздатьДокумент(); 
  НовыйДокумент.Номер = "111"; 
  НовыйДокумент.Дата = абс_СерверныеФункции.ПолучитьДатуСервера(); 
  НовыйДокумент.Записать(); 
  Возврат НовыйДокумент.Ссылка; 
КонецФункции 

&НаСервере
Процедура абс_ЗаявкаНаИзменениеНаСервере(МожноСоздавать,ДанныеФормы)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат ;
	КонецЕсли;
	
	//НовЗаявка = Документы.абс_ЗаявкаНаИзменениеРеквизитовКонтрагента.СоздатьДокумент();
	//НовЗаявка.Контрагент = Объект.Ссылка;
	МожноСоздавать = Документы.абс_ЗаявкаНаИзменениеРеквизитовКонтрагента.ЗаполнитьПрежниеЗначенияКонтрагента(Объект.Ссылка,ДанныеФормы);
	
КонецПРоцедуры

&НаКлиенте
Процедура абс_ЗаявкаНаИзменение(Команда)
	
	
	
	
	МожноСоздавать = Ложь;
	
	ФормаДок = ПолучитьФорму("Документ.абс_ЗаявкаНаИзменениеРеквизитовКонтрагента.Форма.ФормаДокументаУправляемая");
	ДанныеФормы = ФормаДок.Объект;
	абс_ЗаявкаНаИзменениеНаСервере(МожноСоздавать,ДанныеФормы);
	
	Если  МожноСоздавать = Истина ТОгда
	    КопироватьДанныеФормы(ДанныеФормы, ФормаДок.Объект);
		ФормаДок.Объект.Контрагент = Объект.Ссылка;
		ФормаДок.Открыть();
	Иначе
		
	КонецЕсли;
КонецПроцедуры


