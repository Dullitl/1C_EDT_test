Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	ЗначениеПанелипользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(ЭтотОбъект);
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра <> Неопределено И ЗначениеПараметра.Значение = '00010101'Тогда
		ЗначениеПараметра.Значение = КонецДня(ТекущаяДата());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	Возврат Результат;
		
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Процедура ПередВыводомЭлементРезультата(МакетКомпоновки, ПроцессорКомпоновки, ЭлементРезультата) Экспорт
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки, ПроцессорКомпоновки) Экспорт
	
	
КонецПроцедуры

Процедура ПриВыводеЗаголовкаОтчета(ОбластьЗаголовок) Экспорт
КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("ДанныеОРаботнике.Организация", "ОсновнаяОрганизация");
	
	Возврат Новый Структура("ИспользоватьСобытияПриФормированииОтчета,
	|ПриВыводеЗаголовкаОтчета,
	|ПослеВыводаПанелиПользователя,
	|ПослеВыводаПериода,
	|ПослеВыводаПараметра,
	|ПослеВыводаГруппировки,
	|ПослеВыводаОтбора,
	|ДействияПанелиИзменениеФлажкаДопНастроек,
	|ПриПолучениеНастроекПользователя, 
	|ЗаполнитьОтборыПоУмолчанию, 
	|СписокПолейПодстановкиОтборовПоУмолчанию", 
	ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию);
КонецФункции

Функция ПолучитьИмяВычисляемогоПоля(Префикс, Код)
	Возврат Префикс + СтрЗаменить(Код, " ", "_");
КонецФункции

#Если Клиент Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
КонецПроцедуры

Процедура ЗаполнитьВычисляемыеПоля()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СемейноеПоложениеФизЛиц.Ссылка,
	|	СемейноеПоложениеФизЛиц.Код КАК Код,
	|	СемейноеПоложениеФизЛиц.Представление,
	|	""СемейноеПоложениеФизЛиц"" КАК ИмяСправочника,
	|	СемейноеПоложениеФизЛицКод.Код КАК КодПовторяющийся
	|ИЗ
	|	Справочник.СемейноеПоложениеФизЛиц КАК СемейноеПоложениеФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СемейноеПоложениеФизЛиц КАК СемейноеПоложениеФизЛицКод
	|		ПО СемейноеПоложениеФизЛиц.Код = СемейноеПоложениеФизЛицКод.Код
	|			И СемейноеПоложениеФизЛиц.Ссылка <> СемейноеПоложениеФизЛицКод.Ссылка
	|ГДЕ
	|	(НЕ СемейноеПоложениеФизЛиц.ПометкаУдаления)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыОбразованияФизЛиц.Ссылка,
	|	ВидыОбразованияФизЛиц.Код,
	|	ВидыОбразованияФизЛиц.Представление,
	|	""ВидыОбразованияФизЛиц"",
	|	ВидыОбразованияФизЛицКод.Код
	|ИЗ
	|	Справочник.ВидыОбразованияФизЛиц КАК ВидыОбразованияФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыОбразованияФизЛиц КАК ВидыОбразованияФизЛицКод
	|		ПО ВидыОбразованияФизЛиц.Код = ВидыОбразованияФизЛицКод.Код
	|			И ВидыОбразованияФизЛиц.Ссылка <> ВидыОбразованияФизЛицКод.Ссылка
	|ГДЕ
	|	(НЕ ВидыОбразованияФизЛиц.ПометкаУдаления)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтепениЗнанияЯзыка.Ссылка,
	|	СтепениЗнанияЯзыка.Код,
	|	СтепениЗнанияЯзыка.Представление,
	|	""СтепениЗнанияЯзыка"",
	|	СтепениЗнанияЯзыкаКод.Код
	|ИЗ
	|	Справочник.СтепениЗнанияЯзыка КАК СтепениЗнанияЯзыка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтепениЗнанияЯзыка КАК СтепениЗнанияЯзыкаКод
	|		ПО СтепениЗнанияЯзыка.Код = СтепениЗнанияЯзыкаКод.Код
	|			И СтепениЗнанияЯзыка.Ссылка <> СтепениЗнанияЯзыкаКод.Ссылка
	|ГДЕ
	|	(НЕ СтепениЗнанияЯзыка.ПометкаУдаления)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтепениРодстваФизЛиц.Ссылка,
	|	СтепениРодстваФизЛиц.Код,
	|	СтепениРодстваФизЛиц.Представление,
	|	""СтепениРодстваФизЛиц"",
	|	СтепениРодстваФизЛицКод.Код
	|ИЗ
	|	Справочник.СтепениРодстваФизЛиц КАК СтепениРодстваФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтепениРодстваФизЛиц КАК СтепениРодстваФизЛицКод
	|		ПО СтепениРодстваФизЛиц.Код = СтепениРодстваФизЛицКод.Код
	|			И СтепениРодстваФизЛиц.Ссылка <> СтепениРодстваФизЛицКод.Ссылка
	|ГДЕ
	|	(НЕ СтепениРодстваФизЛиц.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИмяСправочника,
	|	Код";
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() цикл
		Если Выборка.КодПовторяющийся <> Null тогда
			Продолжить;
		КонецЕсли;
		Если Выборка.ИмяСправочника = "СтепениРодстваФизЛиц" тогда
			НовоеОписаниеВычисляемогоПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
			НовоеОписаниеВычисляемогоПоля.Выражение = "ВЫБОР КОГДА ДанныеФизлица.СоставСемьиФизЛиц.ФизическиеЛица_Состав_Семьи__СтепеньРодства = &"  + ПолучитьИмяВычисляемогоПоля("СтепеньРодства", Выборка.Код) + " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			НовоеОписаниеВычисляемогоПоля.Заголовок = "Количество записей (родственник по степени: " + Выборка.Представление + ")";
			НовоеОписаниеВычисляемогоПоля.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СтепеньРодства", Выборка.Код); 
			НовоеОписаниеВычисляемогоПоля.ОграничениеИспользования.Условие = Истина;
            НовыйПараметрВычисляемогоПоля = СхемаКомпоновкиДанных.Параметры.Добавить();
			НовыйПараметрВычисляемогоПоля.Значение = Выборка.Ссылка; 
			НовыйПараметрВычисляемогоПоля.Имя = ПолучитьИмяВычисляемогоПоля("СтепеньРодства", Выборка.Код);
			НовыйПараметрВычисляемогоПоля.ОграничениеИспользования = Истина;
			НовыйРесурс = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
			НовыйРесурс.Выражение = "Сумма(" + ПолучитьИмяВычисляемогоПоля("СтепеньРодства", Выборка.Код) + ")";
			НовыйРесурс.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СтепеньРодства", Выборка.Код);
			
		ИначеЕсли Выборка.ИмяСправочника = "ВидыОбразованияФизЛиц" тогда
			НовоеОписаниеВычисляемогоПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
			НовоеОписаниеВычисляемогоПоля.Выражение = "ВЫБОР КОГДА ДанныеФизлица.ОбразованиеФизЛиц.ФизическиеЛица_Образование__ВидОбразования.Код = &"  + ПолучитьИмяВычисляемогоПоля("Образование", Выборка.Код) + " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			НовоеОписаниеВычисляемогоПоля.Заголовок = "Имеют образование : " + Выборка.Представление;
			НовоеОписаниеВычисляемогоПоля.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("Образование", Выборка.Код); 
			НовоеОписаниеВычисляемогоПоля.ОграничениеИспользования.Условие = Истина;
			НовыйПараметрВычисляемогоПоля = СхемаКомпоновкиДанных.Параметры.Добавить();
			НовыйПараметрВычисляемогоПоля.Значение = Выборка.Код; 
			НовыйПараметрВычисляемогоПоля.Имя = ПолучитьИмяВычисляемогоПоля("Образование", Выборка.Код);
			НовыйПараметрВычисляемогоПоля.ОграничениеИспользования = Истина;
			НовыйРесурс = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
			НовыйРесурс.Выражение = "Сумма(" + ПолучитьИмяВычисляемогоПоля("Образование", Выборка.Код) + ")";
			НовыйРесурс.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("Образование", Выборка.Ссылка.Код);
			
		ИначеЕсли Выборка.ИмяСправочника = "СтепениЗнанияЯзыка" тогда	
			НовоеОписаниеВычисляемогоПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
			НовоеОписаниеВычисляемогоПоля.Выражение = "ВЫБОР КОГДА ДанныеФизлица.ФизическиеЛица_ЗнаниеЯзыков.ФизическиеЛица_Знание_Языков__Степень_Знания_Языка.Код = &"  + ПолучитьИмяВычисляемогоПоля("СтепениЗнанияЯзыка", Выборка.Код) + " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			НовоеОписаниеВычисляемогоПоля.Заголовок = "Владеют иностранным языком : " + Выборка.Представление;
			НовоеОписаниеВычисляемогоПоля.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СтепениЗнанияЯзыка", Выборка.Код); 
			НовоеОписаниеВычисляемогоПоля.ОграничениеИспользования.Условие = Истина;
			НовыйПараметрВычисляемогоПоля = СхемаКомпоновкиДанных.Параметры.Добавить();
			НовыйПараметрВычисляемогоПоля.Значение = Выборка.Код; 
			НовыйПараметрВычисляемогоПоля.Имя = ПолучитьИмяВычисляемогоПоля("СтепениЗнанияЯзыка", Выборка.Код);
			НовыйПараметрВычисляемогоПоля.ОграничениеИспользования = Истина;
			НовыйРесурс = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
			НовыйРесурс.Выражение = "Сумма(" + ПолучитьИмяВычисляемогоПоля("СтепениЗнанияЯзыка", Выборка.Код) + ")";
			НовыйРесурс.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СтепениЗнанияЯзыка", Выборка.Код);
			
		ИначеЕсли Выборка.ИмяСправочника = "СемейноеПоложениеФизЛиц" тогда				
			НовоеОписаниеВычисляемогоПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
			НовоеОписаниеВычисляемогоПоля.Выражение = "ВЫБОР КОГДА ДанныеФизлица.СемейноеПоложениеФизЛиц.ФизическиеЛица__СемейноеПоложение = &"  + ПолучитьИмяВычисляемогоПоля("СемейноеПоложение", Выборка.Код) + " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			НовоеОписаниеВычисляемогоПоля.Заголовок = "Имеют семейное положение : " + Выборка.Представление;
			НовоеОписаниеВычисляемогоПоля.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СемейноеПоложение", Выборка.Код); 
			НовоеОписаниеВычисляемогоПоля.ОграничениеИспользования.Условие = Истина;
			НовыйПараметрВычисляемогоПоля = СхемаКомпоновкиДанных.Параметры.Добавить();
			НовыйПараметрВычисляемогоПоля.Значение = Выборка.Ссылка.Код; 
			НовыйПараметрВычисляемогоПоля.Имя = ПолучитьИмяВычисляемогоПоля("СемейноеПоложение", Выборка.Код);
			НовыйПараметрВычисляемогоПоля.ОграничениеИспользования = Истина;
			НовыйРесурс = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
			НовыйРесурс.Выражение = "Сумма(" + ПолучитьИмяВычисляемогоПоля("СемейноеПоложение", Выборка.Код) + ")";
			НовыйРесурс.ПутьКДанным = ПолучитьИмяВычисляемогоПоля("СемейноеПоложение", Выборка.Код);

   		КонецЕсли;	

	КонецЦикла;	
	МетаданныеПеречисления = Метаданные.Перечисления.СостоянияРаботникаОрганизации;
	Для Каждого Значение ИЗ МетаданныеПеречисления.ЗначенияПеречисления цикл
			Если Значение.Имя = "НеРаботает" Тогда
				Продолжить;
			КонецЕсли;
			НовоеОписаниеВычисляемогоПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
			НовоеОписаниеВычисляемогоПоля.Выражение = "ВЫБОР КОГДА СостояниеРаботниковОрганизаций__Состояние = &"  + "Состояние_" + Значение.Имя + " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			НовоеОписаниеВычисляемогоПоля.Заголовок = "Имеют состояние : " + Значение.Представление();
			НовоеОписаниеВычисляемогоПоля.ПутьКДанным = "Состояние_" + Значение.Имя; 
			НовоеОписаниеВычисляемогоПоля.ОграничениеИспользования.Условие = Истина;
			НовыйПараметрВычисляемогоПоля = СхемаКомпоновкиДанных.Параметры.Добавить();
			НовыйПараметрВычисляемогоПоля.Значение = Перечисления.СостоянияРаботникаОрганизации[Значение.Имя]; 
			НовыйПараметрВычисляемогоПоля.Имя = "Состояние_" + Значение.Имя;
			НовыйПараметрВычисляемогоПоля.ОграничениеИспользования = Истина;
			НовыйРесурс = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
			НовыйРесурс.Выражение = "Сумма(Состояние_" + Значение.Имя + ")";
			НовыйРесурс.ПутьКДанным ="Состояние_" + Значение.Имя;
	КонецЦикла;	
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
КонецПроцедуры

ЗаполнитьВычисляемыеПоля();

#КонецЕсли

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;
УправлениеОтчетами.ЗаменитьНазваниеПолейСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);