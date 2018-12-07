
&НаКлиенте
Процедура Принять(Команда)
	
	Обработки.абс_ПроверкаНеЗакрытыхЗадач.Создать().ЗаписьВРегистр(ОтложитьНаВремя);
	ЭтаФорма.Закрыть(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьНаВремяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элементы.ОтложитьНаВремя.СписокВыбора.Очистить();
	Элементы.ОтложитьНаВремя.СписокВыбора.Добавить("30 мин.");
	Элементы.ОтложитьНаВремя.СписокВыбора.Добавить("Один час");
	Элементы.ОтложитьНаВремя.СписокВыбора.Добавить("Два часа");
	
КонецПроцедуры

&НаКлиенте
Процедура Закрытьформу(Команда)
	
	ЭтаФорма.Закрыть(0);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Результат = Новый ТаблицаЗначений;
	ОбновитьНаСервере(Результат);
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере(Результат = Неопределено)
	
	Массив = Новый Массив;
	Массив.Добавить(Перечисления.абс_СтатусыЗаявокВПоддержку.ТестированиеИнициатором);
	Массив.Добавить(Перечисления.абс_СтатусыЗаявокВПоддержку.Уточнение);
	
	ДатаКонтроля = ТекущаяДата();
	Пользователь = глЗначениеПеременной("глТекущийПользователь");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПроверкиЗаяков.Пользователь КАК Пользователь,
	               |	ЕСТЬNULL(РАЗНОСТЬДАТ(&ТекущаяДата, ПроверкиЗаяков.ОтложенноВСекундах, СЕКУНДА), 0) КАК Время
	               |ПОМЕСТИТЬ пр
	               |ИЗ
	               |	РегистрСведений.абс_ОтложенныеЗадачиПоПроверкиЗаяков.СрезПоследних(, Пользователь = &Пользователь) КАК ПроверкиЗаяков
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	абс_ЗадачаВТехподдержку.Ссылка КАК ЗадачаВТехподдержку,
	               |	абс_ЗадачаВТехподдержку.Статус КАК ТекущийСтатус,
	               |	абс_ЗадачаВТехподдержку.Инициатор КАК Инициатор,
	               |	ЕСТЬNULL(пр.Время, 0) КАК Время
	               |ПОМЕСТИТЬ вр
	               |ИЗ
	               |	пр КАК пр
	               |		ПОЛНОЕ СОЕДИНЕНИЕ Документ.абс_ЗадачаВТехподдержку КАК абс_ЗадачаВТехподдержку
	               |		ПО пр.Пользователь = абс_ЗадачаВТехподдержку.Инициатор
	               |ГДЕ
	               |	(НЕ абс_ЗадачаВТехподдержку.ПометкаУдаления)
	               |	И абс_ЗадачаВТехподдержку.Инициатор = &Пользователь
	               |	И абс_ЗадачаВТехподдержку.Статус В(&Статус)
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ЗадачаВТехподдержку,
	               |	Инициатор,
	               |	ТекущийСтатус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	вр.ЗадачаВТехподдержку,
	               |	вр.ТекущийСтатус,
	               |	вр.Инициатор,
	               |	вр.Время
	               |ИЗ
	               |	вр КАК вр
	               |ГДЕ
	               |	вр.Время <= 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ пр
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ вр";
				   
	Запрос.УстановитьПараметр("Статус",Массив);	
	Запрос.УстановитьПараметр("ТекущаяДата",ДатаКонтроля);
	Запрос.УстановитьПараметр("Пользователь"  ,Пользователь);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() > 0 Тогда
		
		 Объект.СписокЗадач.Загрузить(Результат);
		 		 
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗадачаВТехподдержку = Элемент.ТекущиеДанные.ЗадачаВТехподдержку;
	Если ЗначениеЗаполнено(ЗадачаВТехподдержку) Тогда
		П = Новый Структура("Ключ", ЗадачаВТехподдержку);
		Ф = ПолучитьФорму("Документ.абс_ЗадачаВТехподдержку.ФормаОбъекта", П);
		Ф.Открыть();	
	КонецЕсли;	
	
КонецПроцедуры

