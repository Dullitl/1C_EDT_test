
//////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РЕГИСТРАЦИИ ИЗМЕНЕНИЙ ПО ПЛАНУ ОБМЕНА

Функция ПолучитьМассивУзловДляРегистрации(РегистрацияДляТоваров = Истина) Экспорт
	
	МассивУзлов = Новый Массив();
	
	Если РегистрацияДляТоваров Тогда
		
		Для Каждого Элемент Из ПараметрыСеанса.ВсеУзлыДляОбменаССайтомТоварами Цикл
			МассивУзлов.Добавить(Элемент);
		КонецЦикла;
		
	Иначе
		
		Для Каждого Элемент Из ПараметрыСеанса.ВсеУзлыДляОбменаССайтомЗаказами Цикл
			МассивУзлов.Добавить(Элемент);
		КонецЦикла;	
		
	КонецЕсли;
	
	Возврат МассивУзлов;
	
КонецФункции

Процедура ЗарегистрироватьИзменения(Объект)
	
	Если Не ПараметрыСеанса.НаличиеОбменаССайтом Тогда
		Возврат;
	КонецЕсли;
		
	ТипОбъекта = ТипЗнч(Объект);
	
	// Номенклатура и картинки
	Если ТипОбъекта = Тип("РегистрСведенийНаборЗаписей.ЗначенияСвойствОбъектов") Тогда
		
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Истина);
		Для каждого Запись Из Объект Цикл
			
			ТипДанных = ТипЗнч(Запись.Объект);
			
			Если ТипДанных = Тип("СправочникСсылка.Номенклатура") Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.Объект);
			ИначеЕсли ТипДанных = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.Объект.Владелец);
			КонецЕсли;	
			
		КонецЦикла;
		
	ИначеЕсли ТипОбъекта = Тип("РегистрНакопленияНаборЗаписей.ТоварыНаСкладах")
		  ИЛИ ТипОбъекта = Тип("РегистрСведенийНаборЗаписей.ЦеныНоменклатуры") Тогда 
		  
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Истина);  
		Для каждого Запись Из Объект Цикл
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.Номенклатура);
			
		КонецЦикла;
		
	ИначеЕсли ТипОбъекта = Тип("РегистрСведенийНаборЗаписей.ШтрихКоды") Тогда
		
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Истина);
		Для каждого Запись Из Объект Цикл
			
			Если ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.Владелец);
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ХранилищеДополнительнойИнформации") Тогда		
		
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Истина);
		
		Если ТипЗнч(Объект.Объект) = Тип("СправочникСсылка.Номенклатура")
		   И Объект.ВидДанных = Перечисления.ВидыДополнительнойИнформацииОбъектов.Изображение Тогда	
		   
		   ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Объект);   
		   ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Ссылка);
			
		КонецЕсли;	
		
	ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ХарактеристикиНоменклатуры")
		  ИЛИ ТипОбъекта = Тип("СправочникОбъект.ЕдиницыИзмерения") Тогда			
		  
		Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда 
		  
			МассивУзлов = ПолучитьМассивУзловДляРегистрации(Истина);	  
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Владелец);
			
		КонецЕсли;
	   
	// Заказы   

	ИначеЕсли ТипОбъекта = Тип("РегистрНакопленияНаборЗаписей.ЗаказыПокупателей") Тогда
		
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Ложь);
		Для каждого Запись Из Объект Цикл
			
			Если ЗначениеЗаполнено(Запись.ЗаказПокупателя) Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.ЗаказПокупателя);
			КонецЕсли;	
			
		КонецЦикла;

	ИначеЕсли ТипОбъекта = Тип("РегистрНакопленияНаборЗаписей.ВзаиморасчетыСКонтрагентами") Тогда
		
		МассивУзлов = ПолучитьМассивУзловДляРегистрации(Ложь);
		Для каждого Запись Из Объект Цикл
			
			Если ТипЗнч(Запись.Сделка) = Тип("ДокументСсылка.ЗаказПокупателя")
				И ЗначениеЗаполнено(Запись.Сделка) Тогда
				
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Запись.Сделка);
				
			КонецЕсли;	
			
		КонецЦикла;
						   
	КонецЕсли;		
		
КонецПроцедуры	

Процедура ВыполнитьАвтообмен(Настройка, ФлагАвтообмена = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Настройка) Тогда
	 
		Возврат;
		
	КонецЕсли;	
	
	ОбработкаОбмена = Обработки.ОбменССайтом.Создать();	
	ОбработкаОбмена.НастройкаСсылка = Настройка;
	//ОбработкаОбмена.Автообмен = ФлагАвтообмена;
	ОбработкаОбмена.ВыгрузитьДанные();	
	
КонецПроцедуры	



Процедура ПриЗаписиСправочникаОбменССайтомПриЗаписи(Источник, Отказ) Экспорт
	
	ЗарегистрироватьИзменения(Источник);
	
КонецПроцедуры

Процедура ПриЗаписиРегистраСведенийОбменССайтомПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	ЗарегистрироватьИзменения(Источник);
	
КонецПроцедуры

Процедура ПриЗаписиРегистраНакопленияОбменССайтомПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	ЗарегистрироватьИзменения(Источник);
	
КонецПроцедуры


// сервисные функции для работы обмена

Функция РазобратьАдресСайта(Знач АдресСайта) Экспорт
	
	АдресСайта = СокрЛП(АдресСайта); 
	
	HTTPСервер		 = ""; 
	HTTPПорт		 = 0;
	HTTPАдресСкрипта = "";
	
	Если ЗначениеЗаполнено(АдресСайта) Тогда
		
		АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
		АдресСайта = СтрЗаменить(АдресСайта, " ", "");
		АдресСайта = СтрЗаменить(АдресСайта, "http://", "");
		ПозицияСлэша = Найти(АдресСайта, "/");
		Если ПозицияСлэша > 0 Тогда
			HTTPСервер 		 = Лев(АдресСайта, ПозицияСлэша - 1);	
			HTTPАдресСкрипта = Прав(АдресСайта, СтрДлина(АдресСайта) - ПозицияСлэша);
		Иначе	
			HTTPСервер 		 = АдресСайта;	
			HTTPАдресСкрипта = "";
		КонецЕсли;	
		ПозицияДвоеточия = Найти(HTTPСервер, ":");
		Если ПозицияДвоеточия > 0 Тогда
			HTTPСерверСПортом = HTTPСервер;
			HTTPСервер		  = Лев(HTTPСерверСПортом, ПозицияДвоеточия - 1);
			HTTPПортСтрока 	  = Прав(HTTPСерверСПортом, СтрДлина(HTTPСерверСПортом) - ПозицияДвоеточия);
		Иначе
			HTTPПортСтрока = "0";
		КонецЕсли;
		
		Попытка
			HTTPПорт = Число(HTTPПортСтрока);
		Исключение
			HTTPПорт = 0;
		КонецПопытки;	
		
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("HTTPСервер"	  , HTTPСервер); 
	СтруктураРезультата.Вставить("HTTPПорт"		  , HTTPПорт);
	СтруктураРезультата.Вставить("HTTPАдресСкрипта", HTTPАдресСкрипта);
	
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ВыполнитьТестовоеПодключениеКСерверуHTTP(Объект, СтрокаСообщенияПользователю, 
	РезультатСоединения = Неопределено, ТипСоединения = "catalog") Экспорт
	
	СтруктураПараметровСайта = ПолучитьСтруктуруПараметровДляСоединения(Объект, Объект.HTTPОбменАдресСайта);
		
	Соединение = ПроцедурыОбменаССайтом.HTTPУстановитьСоединение(СтруктураПараметровСайта);
	
	Если Соединение = Неопределено Тогда
		Возврат "Ошибка при установке соединения с сайтом.";
	КонецЕсли;
	
	ОтветСервера = "";
	РезультатСоединения = HTTPВыполнитьАвторизациюДляСоединения(Соединение, СтруктураПараметровСайта, ОтветСервера, СтрокаСообщенияПользователю, ТипСоединения);
	
	Если Не РезультатСоединения Тогда
		Возврат "Соединение с сайтом не установлено.";
	Иначе
		Возврат "Соединение выполнено успешно.";
	КонецЕсли;
	
КонецФункции


Функция ПолучитьСтруктуруПараметровДляСоединения(Объект, Знач НачалоАдресаСкрипта = "") Экспорт
	
	СтруктураПараметровСайта = Новый Структура;
	СтруктураПараметровСайта.Вставить("ИмяПользователя", Объект.HTTPОбменИмяПользователя);
	СтруктураПараметровСайта.Вставить("Пароль"		   , Объект.HTTPОбменПароль);
	
	Если Не ПустаяСтрока(НачалоАдресаСкрипта) Тогда
		
		СтруктураАдреса = РазобратьАдресСайта(НачалоАдресаСкрипта);
		
		HTTPОбменПорт = СтруктураАдреса.HTTPПорт;
		HTTPОбменСервер = СтруктураАдреса.HTTPСервер;
		НачалоАдресаСкрипта = СтруктураАдреса.HTTPАдресСкрипта;
		
		СтруктураПараметровСайта.Вставить("АдресСкрипта", НачалоАдресаСкрипта);
		СтруктураПараметровСайта.Вставить("Сервер"		, HTTPОбменСервер);
		СтруктураПараметровСайта.Вставить("Порт"		, HTTPОбменПорт);
		
	Иначе
		
		СтруктураПараметровСайта.Вставить("АдресСкрипта", Объект.HTTPОбменАдресСкрипта);
		СтруктураПараметровСайта.Вставить("Сервер"		, Объект.HTTPОбменСервер);
		СтруктураПараметровСайта.Вставить("Порт"		, Объект.HTTPОбменПорт);

	КонецЕсли;
	
	СтруктураПараметровСайта.Вставить("ПроксиСервер"		 , Объект.HTTPОбменПроксиСервер);
	СтруктураПараметровСайта.Вставить("ПроксиПорт"		     , Объект.HTTPОбменПроксиПорт);
	СтруктураПараметровСайта.Вставить("ПроксиИмяПользователя", Объект.HTTPОбменПроксиИмяПользователя);
	СтруктураПараметровСайта.Вставить("ПроксиПароль"		 , Объект.HTTPОбменПроксиПароль);
	СтруктураПараметровСайта.Вставить("ПроксиИспользование"  , Объект.HTTPОбменПроксиИспользование);	
	
	Возврат СтруктураПараметровСайта;
	
КонецФункции


Функция HTTPПолучитьДанныеССервера(Соединение, ПараметрыЗапроса="", Заголовки="", СтрокаСообщенияПользователю = "") Экспорт
	
	ОтветСервера   = Неопределено; 
	ИмяФайлаОтвета = ПолучитьИмяВременногоФайла();
		
	Попытка
		Соединение.Получить(СокрЛП(ПараметрыЗапроса), ИмяФайлаОтвета, СокрЛП(Заголовки));
	Исключение
		СтрокаСообщенияПользователю = "Не удалось получить данные с сервера.Проверьте правильность адреса сервера, порт, имя пользователя и пароль,"
			+ Символы.ПС + "а также настройки подключения к Интернет.";
	КонецПопытки;	
	
	ФайлОтвета = Новый Файл(ИмяФайлаОтвета);
	
	Если ФайлОтвета.Существует() Тогда
		
		ТекстОтвета = Новый ТекстовыйДокумент();
		ТекстОтвета.Прочитать(ИмяФайлаОтвета);
		Если ТекстОтвета.КоличествоСтрок()>0 Тогда
			ОтветСервера = ТекстОтвета.ПолучитьТекст();	
		Иначе
			СтрокаСообщенияПользователю = "Получение данных с сервера: Получен пустой ответ сервера."; 	
		КонецЕсли;	
		
	Иначе	
		СтрокаСообщенияПользователю = "Получение данных с сервера: Ответ сервера не получен."; 
	КонецЕсли;	
	
	Попытка
		УдалитьФайлы(КаталогВременныхФайлов(), ИмяФайлаОтвета);
	Исключение
	КонецПопытки;
	
	Возврат ОтветСервера;
	
КонецФункции

Функция HTTPВыполнитьАвторизациюДляСоединения(Соединение, СтруктураПараметровСайта, 
	ОтветСервера, СтрокаСообщенияПользователю, ТипСоединения = "catalog") Экспорт
	
	Успешно    = Истина;
	#Если Клиент Тогда
	Состояние("Установка соединения с сервером...");
	#КонецЕсли

	Соединение = ПроцедурыОбменаССайтом.HTTPУстановитьСоединение(СтруктураПараметровСайта);
	 
	Если Соединение = Неопределено Тогда
		СтрокаСообщенияПользователю = "Не удалось установить соединение с сервером.";
		Возврат Ложь;
	КонецЕсли;
	
	#Если Клиент Тогда
	Состояние("Проверка имени пользователя и пароля...");
	#КонецЕсли
	
	ОтветСервера = HTTPПолучитьДанныеССервера(Соединение, СтруктураПараметровСайта.АдресСкрипта + "?type=" + ТипСоединения + "&mode=checkauth");
		
	Если ОтветСервера = Неопределено Тогда 
		СтрокаСообщенияПользователю = "Не удалось установить соединение с сервером. Авторизация пользователя не выполнена." + Символы.ПС + ОписаниеОшибки();
		Возврат Ложь;
	КонецЕсли;
		
	Если НРег(СтрПолучитьСтроку(ОтветСервера,1)) <> "success" Тогда
		СтрокаСообщенияПользователю = "Не удалось установить соединение с сервером. Проверьте имя пользователя и пароль." + Символы.ПС + ОписаниеОшибки();
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция HTTPУстановитьСоединение(СтруктураПараметровСайта) Экспорт
	
	Соединение = НеОпределено;
		
	ИнтернетПрокси = НеОпределено;
	
	Если СтруктураПараметровСайта.ПроксиИспользование Тогда
		
		ИнтернетПрокси = Новый ИнтернетПрокси;
		ИнтернетПрокси.Пользователь = СтруктураПараметровСайта.ПроксиИмяПользователя;
		ИнтернетПрокси.Пароль		= СтруктураПараметровСайта.ПроксиПароль;
		
		Если СтруктураПараметровСайта.ПроксиПорт = 0 Тогда
			ИнтернетПрокси.Установить("HTTP", СтруктураПараметровСайта.ПроксиСервер);
		Иначе	
			ИнтернетПрокси.Установить("HTTP", СтруктураПараметровСайта.ПроксиСервер, СтруктураПараметровСайта.ПроксиПорт);
		КонецЕсли;	
		
	КонецЕсли;	
	
	Порт = ?(ЗначениеЗаполнено(СтруктураПараметровСайта.Порт), СтруктураПараметровСайта.Порт, 80);
	Попытка
		
		Соединение = Новый HTTPСоединение(СтруктураПараметровСайта.Сервер, Порт, СтруктураПараметровСайта.ИмяПользователя, СтруктураПараметровСайта.Пароль, ИнтернетПрокси);
		
	Исключение
		
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Не удалось установить соединение с сервером " + СтруктураПараметровСайта.Сервер + ":" + Строка(СтруктураПараметровСайта.Порт) + ".
			|Проверьте правильность адреса сервера, порт, имя пользователя и пароль.");
			
		Соединение = Неопределено;
			
	Конецпопытки;	
		
	Возврат Соединение;
	
КонецФункции


Процедура НастроитьПостроительОтчета(ПостроительОбъект) Экспорт
	
	МассивДопустимыхТиповНоменклатуры = Новый Массив;
	МассивДопустимыхТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Товар);
	//МассивДопустимыхТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Услуга);
	
	ПостроительОбъект.Параметры.Вставить("МассивДопустимыхТиповНоменклатуры", МассивДопустимыхТиповНоменклатуры);
		
	ПостроительОбъект.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Товары.НоменклатураСсылка КАК НоменклатураСсылка,
		|	Товары.НоменклатураСсылка.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Товары.НоменклатураСсылка.ЕдиницаХраненияОстатков КАК ЕдиницаДляШтрихКода,
		|	Товары.НоменклатураСсылка.ВидНоменклатуры.Наименование КАК ВидНоменклатуры,
		|	Товары.НоменклатураСсылка.ВидНоменклатуры.ТипНоменклатуры КАК ТипНоменклатуры,
		|	РегистрШтрихКоды.Штрихкод КАК ШтрихКод,
		|	Товары.ХарактеристикаСсылка КАК ХарактеристикаСсылка,
		|	ЗначенияСвойствХарактеристик.Свойство КАК ХарактеристикаСвойство,
		|	ЗначенияСвойствХарактеристик.Значение КАК ХарактеристикаЗначениеСвойства,
		|	Выбор Когда ЦеныНоменклатуры.Цена Есть NULL
		|		Тогда ЦеныНоменклатурыБезХарактеристики.ТипЦен
		|		Иначе ЦеныНоменклатуры.ТипЦен
		|	КОНЕЦ КАК ТипЦен,
		|	Выбор Когда ЦеныНоменклатуры.Цена Есть NULL
		|		Тогда ЦеныНоменклатурыБезХарактеристики.Валюта
		|		Иначе ЦеныНоменклатуры.Валюта
		|	КОНЕЦ КАК Валюта,
		|	Выбор Когда ЦеныНоменклатуры.Цена Есть NULL
		|		Тогда ЦеныНоменклатурыБезХарактеристики.Цена
		|		Иначе ЦеныНоменклатуры.Цена
		|	КОНЕЦ КАК Цена,
		|	Выбор Когда ЦеныНоменклатуры.Цена Есть NULL
		|		Тогда ЦеныНоменклатурыБезХарактеристики.ЕдиницаИзмерения
		|		Иначе ЦеныНоменклатуры.ЕдиницаИзмерения
		|	КОНЕЦ КАК ЕдиницаИзмеренияЦены,
		|	ЕстьNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) + ЕстьNULL(ТоварыВРозницеОстатки.КоличествоОстаток, 0) + 
		|		ЕстьNULL(ТоварыВНТТОстатки.КоличествоОстаток, 0) - ЕстьNULL(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток, 0) -
		|		ЕстьNULL(ТоварыКПередачеСоСкладовОстатки.КоличествоОстаток, 0)	КАК Остаток,
		|   		
		|	ЗначенияСвойствОбъектов.Значение КАК СвойствоНоменклатурыЗначение,
		|	ЗначенияСвойствОбъектов.Свойство КАК СвойствоНоменклатуры
		|ИЗ
		|	(ВЫБРАТЬ
		|		Номенклатура.Ссылка КАК НоменклатураСсылка,
		|		Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаДляШтрихКода,
        |       ХарактеристикиНоменклатуры.Наименование КАК ХарактеристикаНаименование,
		|		ВЫБОР
		|			КОГДА ХарактеристикиНоменклатуры.Ссылка ЕСТЬ NULL 
		|				ТОГДА Значение(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|			ИНАЧЕ ХарактеристикиНоменклатуры.Ссылка
		|		КОНЕЦ КАК ХарактеристикаСсылка
		|	ИЗ
		|		Справочник.Номенклатура КАК Номенклатура
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|			ПО Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
		|	ГДЕ
		|		Номенклатура.ЭтоГруппа = ЛОЖЬ
		|		И Номенклатура.ВидНоменклатуры.ТипНоменклатуры В(&МассивДопустимыхТиповНоменклатуры)
		|	{ГДЕ
		|		Номенклатура.Ссылка.* КАК Номенклатура}) КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствХарактеристик
		|			ПО ЗначенияСвойствХарактеристик.Объект = Товары.ХарактеристикаСсылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК РегистрШтрихКоды
		|			ПО Товары.НоменклатураСсылка = РегистрШтрихКоды.Владелец
		|				И Товары.ХарактеристикаСсылка = РегистрШтрихКоды.ХарактеристикаНоменклатуры
		|				И Товары.ЕдиницаДляШтрихКода = РегистрШтрихКоды.ЕдиницаИзмерения
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ЗначенияСвойствОбъектов.Объект КАК Объект,
		|			ЗначенияСвойствОбъектов.Свойство КАК Свойство,
		|			ЗначенияСвойствОбъектов.Значение КАК Значение
		|		ИЗ
		|			РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ГДЕ
		|			ЗначенияСвойствОбъектов.Свойство.НазначениеСвойства = Значение(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура)
		|		{ГДЕ
		|			ЗначенияСвойствОбъектов.Свойство КАК Свойство}) КАК ЗначенияСвойствОбъектов
		|
		|		ПО Товары.НоменклатураСсылка = ЗначенияСвойствОбъектов.Объект
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаОтчета, {(ТипЦен).*}) КАК ЦеныНоменклатуры
		|		ПО Товары.НоменклатураСсылка = ЦеныНоменклатуры.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ЦеныНоменклатуры.ХарактеристикаНоменклатуры
		|
		| 		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаОтчета, {(ТипЦен).*}) КАК ЦеныНоменклатурыБезХарактеристики
		|		ПО Товары.НоменклатураСсылка = ЦеныНоменклатурыБезХарактеристики.Номенклатура
		|			И ЦеныНоменклатурыБезХарактеристики.ХарактеристикаНоменклатуры = Значение(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)		
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаОтчета, {(Склад).*}) КАК ТоварыНаСкладахОстатки
		|		ПО Товары.НоменклатураСсылка = ТоварыНаСкладахОстатки.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРознице.Остатки(&ДатаОтчета, {(Склад).*}) КАК ТоварыВРозницеОстатки
		|		ПО Товары.НоменклатураСсылка = ТоварыВРозницеОстатки.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ТоварыВРозницеОстатки.ХарактеристикаНоменклатуры
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВНТТ.Остатки(&ДатаОтчета, {(Склад).*}) КАК ТоварыВНТТОстатки
		|		ПО Товары.НоменклатураСсылка = ТоварыВНТТОстатки.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ТоварыВНТТОстатки.ХарактеристикаНоменклатуры
		|
		|       ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаОтчета, {(Склад).*}) КАК ТоварыВРезервеНаСкладахОстатки
		|		ПО Товары.НоменклатураСсылка = ТоварыВРезервеНаСкладахОстатки.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры
		|
		|       ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКПередачеСоСкладов.Остатки(&ДатаОтчета, {(Склад).*}) КАК ТоварыКПередачеСоСкладовОстатки
		|		ПО Товары.НоменклатураСсылка = ТоварыКПередачеСоСкладовОстатки.Номенклатура
		|			И Товары.ХарактеристикаСсылка = ТоварыКПередачеСоСкладовОстатки.ХарактеристикаНоменклатуры
		|
		|ГДЕ Истина
		|{ГДЕ
		|	ЕстьNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) + ЕстьNULL(ТоварыВРозницеОстатки.КоличествоОстаток, 0) + 
		|		ЕстьNULL(ТоварыВНТТОстатки.КоличествоОстаток, 0) - ЕстьNULL(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток, 0) -
		|		ЕстьNULL(ТоварыКПередачеСоСкладовОстатки.КоличествоОстаток, 0) КАК Остаток}
		|ИТОГИ
		|	МАКСИМУМ(ЕдиницаИзмерения),
		|	МАКСИМУМ(ЕдиницаДляШтрихКода),
		|	МАКСИМУМ(ВидНоменклатуры),
		|	МАКСИМУМ(ТипНоменклатуры),
		|	МАКСИМУМ(ШтрихКод),
		|	МАКСИМУМ(ХарактеристикаЗначениеСвойства),
		|	МАКСИМУМ(ТипЦен),
		|	МАКСИМУМ(Валюта),
		|	МАКСИМУМ(Цена),
		|	МАКСИМУМ(ЕдиницаИзмеренияЦены),
		|	МАКСИМУМ(Остаток),
		|	МАКСИМУМ(СвойствоНоменклатурыЗначение)
		|ПО
		|	НоменклатураСсылка,
		|	ХарактеристикаСсылка,
		|	ХарактеристикаСвойство,
		|	СвойствоНоменклатуры
		|АВТОУПОРЯДОЧИВАНИЕ";

КонецПроцедуры

Процедура ЗаполнитьОтборПостроителя(ПостроительОбъект) Экспорт
	
	ОтборКоличество = ПостроительОбъект.Отбор.Количество();
	Для Н = 1 По ОтборКоличество Цикл
    	ПостроительОбъект.Отбор.Удалить(ОтборКоличество - Н);
	КонецЦикла;	
	
	ПостроительОбъект.Отбор.Добавить("Номенклатура", , "Номенклатура");
		
	ПостроительОбъект.Отбор.Добавить("ТипЦен", , "Тип цен");
	ПостроительОбъект.ДоступныеПоля.ТипЦен.Представление = "Тип цен";
	ПостроительОбъект.Отбор.Добавить("Склад", , "Остатки по складам");
	ПостроительОбъект.ДоступныеПоля.Склад.Представление = "Остатки по складам";
	ПостроительОбъект.Отбор.Добавить("Остаток", , "Остаток");
	ПостроительОбъект.ДоступныеПоля.Остаток.Представление = "Остаток";
	
КонецПроцедуры

Процедура ЗаданиеОбменССайтом(КодНастройки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КодНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	//АБС ВСТАВКА №40078 НАЧАЛО «25 апреля 2014 г.», Пополитов
	Если не абс_СерверныеФункции.абс_ДаннаяБазаНеКопия() Тогда
		Возврат;	
	КонецЕсли;	
	//\\АБС ВСТАВКА №40078 КОНЕЦ	
	
	НастройкаОбмена = Справочники.НастройкиОбменаССайтом.НайтиПоКоду(КодНастройки);
	
	Если НЕ ЗначениеЗаполнено(НастройкаОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаОбмена.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьАвтообмен(НастройкаОбмена, Истина);
	
КонецПроцедуры

Функция ПолучитьЗаказыСОплатойИОтгрузкойПоКатегориям(МассивИзменений, МассивЗагруженныхДокументов) Экспорт
	
	Запрос = Новый Запрос();
	КоличествоЗаказовОграничения = МассивИзменений.Количество();
		
	СтрокаОграниченияПоЗаказам = ?(КоличествоЗаказовОграничения = 0, "", ", ЗаказПокупателя В (&МассивДокументовСсылок) ");	
	СтрокаОграниченияПоРасчетам = ?(КоличествоЗаказовОграничения = 0, "", ", Сделка В (&МассивДокументовСсылок) ");
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|		Заказ.Ссылка КАК ДокументСсылка,
		|		ВЫБОР
		|			КОГДА ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток ЕСТЬ NULL 
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВЫБОР
		|					КОГДА ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток <= 0
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ
		|		КОНЕЦ КАК Отгружен,
		|		ВЫБОР
		|			КОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток ЕСТЬ NULL 
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВЫБОР
		|					КОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток <= 0
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ
		|		КОНЕЦ КАК Оплачен,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(ЗаказыПокупателей.Регистратор.Дата) ЕСТЬ NULL 
		|				ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ИНАЧЕ МАКСИМУМ(ЗаказыПокупателей.Регистратор.Дата)
		|		КОНЕЦ КАК ДатаОтгрузки,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(ЗаказыПокупателей.Регистратор.Номер) ЕСТЬ NULL 
		|				ТОГДА 0
		|			ИНАЧЕ МАКСИМУМ(ЗаказыПокупателей.Регистратор.Номер)
		|		КОНЕЦ КАК НомерОтгрузки,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(РасчетыСКонтрагентами.Регистратор.Дата) ЕСТЬ NULL 
		|				ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ИНАЧЕ МАКСИМУМ(РасчетыСКонтрагентами.Регистратор.Дата)
		|		КОНЕЦ КАК ДатаОплаты,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(РасчетыСКонтрагентами.Регистратор.Номер) ЕСТЬ NULL 
		|				ТОГДА 0
		|			ИНАЧЕ МАКСИМУМ(РасчетыСКонтрагентами.Регистратор.Номер)
		|		КОНЕЦ КАК НомерОплаты
		|	ИЗ
		|	
		|		Документ.ЗаказПокупателя КАК Заказ
		|		Внутреннее СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
		|		  ПО  КатегорииОбъектов.Объект = Заказ.Ссылка
		|		  И КатегорииОбъектов.Категория = Значение(Справочник.КатегорииОбъектов.ЗаказСWEBСайта)
		|		  
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки(" + СтрокаОграниченияПоЗаказам + ") КАК ЗаказыПокупателейОстатки
		|			ПО Заказ.Ссылка = ЗаказыПокупателейОстатки.ЗаказПокупателя
		|			
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами.Остатки(" + СтрокаОграниченияПоРасчетам + ") КАК РасчетыСКонтрагентамиОстатки
		|			ПО Заказ.Ссылка = РасчетыСКонтрагентамиОстатки.Сделка
		|			
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
		|			ПО Заказ.Ссылка = ЗаказыПокупателей.ЗаказПокупателя
		|			И (ЗаказыПокупателей.ВидДвижения = Значение(ВидДвиженияНакопления.расход))
		|			
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами КАК РасчетыСКонтрагентами
		|			ПО Заказ.Ссылка = РасчетыСКонтрагентами.Сделка
		|			И (РасчетыСКонтрагентами.ВидДвижения = Значение(ВидДвиженияНакопления.расход))
		|";
		
	Если КоличествоЗаказовОграничения > 0 Тогда
		
		Запрос.УстановитьПараметр("МассивДокументовСсылок", МассивИзменений);
		Запрос.Текст = Запрос.Текст + " ГДЕ Заказ.Ссылка В (&МассивДокументовСсылок)";
			
				
	ИначеЕсли МассивЗагруженныхДокументов.Количество() > 0 Тогда
				
		Запрос.УстановитьПараметр("МассивДокументовСсылокНеВыгружать", МассивЗагруженныхДокументов);
		Запрос.Текст = Запрос.Текст + " ГДЕ НЕ (Заказ.Ссылка В (&МассивДокументовСсылокНеВыгружать))";
		
	КонецЕсли;	
		
	Запрос.Текст = Запрос.Текст
		+ "
		|СГРУППИРОВАТЬ ПО
		|Заказ.Ссылка,
		|ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток,
		|РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток";
	
	ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаДокументов;
	
КонецФункции
