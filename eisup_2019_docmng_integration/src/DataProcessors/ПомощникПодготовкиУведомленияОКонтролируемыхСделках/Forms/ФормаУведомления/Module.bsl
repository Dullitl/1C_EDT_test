&НаКлиенте
Перем ТЗ;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаСервере
Процедура ЗаполнитьСписокУведомлений(ТЗ)
	
	// {{ТТК Сладков А. Заявка № 31.05.2016 начало
	//СхемаКомпоновкиДанных = Обработки.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.ПолучитьМакет("Макет");            
	СхемаКомпоновкиДанных=РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет"); 
	// }}ТТК Сладков А. Заявка № 31.05.2016 окончание
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос);

	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	Запрос.УстановитьПараметр("ВидОтображения", ВидОтображения);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоГода(Дата(ОтчетныйГод, 1, 1)));
	
	// {{ТТК Сладков А. Заявка № 31.05.2016 начало
	Запрос.УстановитьПараметр("ТипУведомления", ЭтаФОрма.ТипУведомления);
	// }}ТТК Сладков А. Заявка № 31.05.2016 окончание

	ТЗ1 = Запрос.Выполнить().Выгрузить();
	ТЗ = ТЗ1.Скопировать();
	
	Листы1Б.Очистить();
	Если ТЗ1.Количество() > 0 Тогда
		Строки  = ТЗ1.НайтиСтроки(Новый Структура("Ссылка",ТЗ1[0].Ссылка));
		Для каждого Стр Из Строки Цикл
			НС = Листы1Б.Добавить();
			ЗаполнитьЗначенияСвойств(НС,Стр);
		КонецЦикла;
	КонецЕсли;
	
	
	Если ВидОтображения1 = 0 Тогда
		ТЗ1.Свернуть("Ссылка,КодНаименованияСделки,КодСтраныПроисхождения,КоличествоУчастниковСделки,ОтноситсяКГруппеОднородныхСделок,СпособОпределенияЦенКонтролируемыхСделок,КодОснованияОтнесенияСделки,ПрименяемаяМетодикаДляТрансфертногоЦенообразования,ОсобенностиОтнесенияСделкиККонтролируемой,КодСтороныСделки,СуммаДоходов,СуммаРасходов",);
		Уведомления.Загрузить(ТЗ1);
	Иначе
		УведомленияОбщийСписок.Загрузить(ТЗ1);
	КонецЕсли;
	
	ИтогоДоходы  = Уведомления.Итог("СуммаДоходов");
	ИтогоРасходы = Уведомления.Итог("СуммаРасходов");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ 

&НаКлиенте
Процедура УведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Уведомления.ТекущиеДанные;
	Если ТекущиеДанные <>  Неопределено Тогда
		Если Поле.Имя = "УведомленияДоговорКонтрагента" Тогда
			Если ЗначениеЗаполнено(Элементы.Уведомления.ТекущиеДанные.ДоговорКонтрагента) Тогда	
				Форма = Элементы.Уведомления.ТекущиеДанные.ДоговорКонтрагента.ПолучитьФорму();
				Форма.Открыть();
			КонецЕсли;	
		Иначе	
			Форма = Элементы.Уведомления.ТекущиеДанные.Ссылка.ПолучитьФорму();
			Форма.Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура УведомленияПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Уведомления.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Строки = ТЗ.НайтиСтроки(Новый Структура("Ссылка",ТекущиеДанные.Ссылка));
		
		Листы1Б.Очистить();
		Для каждого Стр Из Строки Цикл
			НС = Листы1Б.Добавить();
			ЗаполнитьЗначенияСвойств(НС,Стр);
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОтображенияПриИзменении(Элемент)
	ЗаполнитьСписокУведомлений(ТЗ);
КонецПроцедуры

 &НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
 
	СхемаКомпоновкиДанных = Обработки.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.ПолучитьМакет("Макет");            
	
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьНастройкиОтбораПоУмолчанию(); 
//	Листы1Б.Параметры.УстановитьЗначениеПараметра("Ссылка",Документы.КонтролируемаяСделка.ПустаяСсылка());
	ОтчетныйГод 	= Параметры.ОтчетныйГод;
	Организация	 	= Параметры.Организация;
	// {{ТТК Сладков А. Заявка № 31.05.2016 начало
	ТипУведомления 	= Параметры.ТипУведомления;
	// }}ТТК Сладков А. Заявка № 31.05.2016 окончание
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	ЗаполнитьСписокУведомлений(ТЗ);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомление(Команда)
	ОткрытьФорму("Документ.КонтролируемаяСделка.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьСписокУведомлений(ТЗ);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокУведомлений(ТЗ);
	 ИзменитьВидОтчета();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьНастройки(Команда)
	Если Элементы.КомпоновщикНастроекКомпоновкиДанныхПользовательскиеНастройки.Видимость Тогда
		Элементы.ПоказатьНастройки.Заголовок = "Показать настройки";	
	Иначе
		Элементы.ПоказатьНастройки.Заголовок = "Скрыть настройки";	
	КонецЕсли;
	
	Элементы.КомпоновщикНастроекКомпоновкиДанныхПользовательскиеНастройки.Видимость = Не Элементы.КомпоновщикНастроекКомпоновкиДанныхПользовательскиеНастройки.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура Листы1БВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "Листы1БДоговорКонтрагента" Тогда
	
		Договор = Элемент.ТекущиеДанные.ДоговорКонтрагента.ПолучитьФорму();
		Договор.Открыть();
	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидОтчета()

	Если ВидОтображения1 = 0 Тогда
		Элементы.Группа1.Видимость = Истина;
		Элементы.Группа2.Видимость = Истина;
		Элементы.УведомленияОбщийСписок.Видимость = Ложь;
	Иначе	
		Элементы.Группа1.Видимость = Ложь;
		Элементы.Группа2.Видимость = Ложь;
		Элементы.УведомленияОбщийСписок.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ВидОтображения1ПриИзменении(Элемент)
	ИзменитьВидОтчета();
	ЗаполнитьСписокУведомлений(ТЗ);
КонецПроцедуры

ТЗ = Новый ТаблицаЗначений;