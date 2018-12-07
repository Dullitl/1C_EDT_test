&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Попытка
		МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии(Отказ);
		#Если ВебКлиент Тогда
			Если МенеджерКриптографии=Неопределено Тогда
				ТекстОшибки = НСтр("ru = 'Расширение для работы с криптографией не установлено, операция прервана.'");
				ЭлектронныеДокументыКлиент.ОбработатьИсключениеПоЭДНаКлиенте(НСтр("ru = 'открытие обработки документов на подпись'"), ТекстОшибки);
			КонецЕсли	
		#КонецЕсли		
	Исключение
		ЭлектронныеДокументыКлиент.ОбработатьИсключениеПоЭДНаКлиенте(НСтр("ru = 'открытие обработки документов на подпись'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Отказ = Истина;
	КонецПопытки;
	
	Если НЕ Отказ Тогда
		МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
		ЗаполнитьСписокСертификатовИДокументов(МассивСтруктурСертификатов);
		
		Если ТаблицаСертификатов.Количество() = 0 Тогда
			ТекстПредупреждения = НСтр("ru = 'Нет сертификатов подписи для пользователя или не настроены правила подписи документов!'"); 
			Предупреждение(ТекстПредупреждения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ТаблицаСертификатов.Количество() > 1 Тогда
			ПерейтиНаСтраницу(Ложь);
		Иначе
			СертификатПодписи = ТаблицаСертификатов[0].Сертификат;
			ЗаполнитьСписокДокументовПоСертификату();
			ПерейтиНаСтраницу(Истина);
			Элементы.ГруппаКнопкиНазад.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатовИДокументов(МассивСтруктурСертификатов)
	
	ТаблицаДоступныхСертификатов = ЭлектронныеДокументы.ТаблицаДоступныхДляПодписиСертификатов(МассивСтруктурСертификатов);							 
	ЗаполнитьСводнуюТаблицу(ТаблицаДоступныхСертификатов);
	ЗаполнитьСписокСертификатов(ТаблицаДоступныхСертификатов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатов(ТаблицаДоступныхСертификатов)
	
	ТаблицаСертификатов.Очистить();
	Для Каждого ТекСтрока Из ТаблицаДоступныхСертификатов Цикл
		СтрокаТаблицы = ТаблицаСертификатов.Добавить();
		СтрокаТаблицы.Сертификат = ТекСтрока.Ссылка;
		ПараметрыОтбора = Новый Структура("Сертификат", ТекСтрока.Ссылка);
		СтрокаТаблицы.КоличествоДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора).Количество();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСводнуюТаблицу(ТаблицаДоступныхСертификатов)
	
	ЗапросПоДокументам = Новый Запрос;
	
	СтруктураДопОтбора = Новый Структура;
	Если ЗначениеЗаполнено(Контрагент) Тогда 
		СтруктураДопОтбора.Вставить("Контрагент", Контрагент);
		ЗапросПоДокументам.УстановитьПараметр("Контрагент", Контрагент);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидЭД) Тогда 
		СтруктураДопОтбора.Вставить("ВидЭД", ВидЭД);
		ЗапросПоДокументам.УстановитьПараметр("ВидЭД", ВидЭД);
	КонецЕсли;
	Если ЗначениеЗаполнено(НаправлениеЭД) Тогда 
		СтруктураДопОтбора.Вставить("НаправлениеЭД", НаправлениеЭД);
		ЗапросПоДокументам.УстановитьПараметр("НаправлениеЭД", НаправлениеЭД);
	КонецЕсли;
	
	ЗапросСоставаИсполнителей = Новый Запрос;
	ЗапросСоставаИсполнителей.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                                  |	СертификатыЭЦП.Ссылка,
	                                  |	СертификатыЭЦП.ПроверятьСоставИсполнителей КАК ПроверятьСоставИсполнителей,
	                                  |	СертификатыЭЦПСоставИсполнителей.Исполнитель
	                                  |ИЗ
	                                  |	Справочник.СертификатыЭЦП КАК СертификатыЭЦП
	                                  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СертификатыЭЦП.СоставИсполнителей КАК СертификатыЭЦПСоставИсполнителей
	                                  |		ПО СертификатыЭЦПСоставИсполнителей.Ссылка = СертификатыЭЦП.Ссылка
	                                  |ГДЕ
	                                  |	СертификатыЭЦП.Ссылка В(&СписокДоступныхСертификатов)";
	ЗапросСоставаИсполнителей.УстановитьПараметр("СписокДоступныхСертификатов", ТаблицаДоступныхСертификатов.ВыгрузитьКолонку("Ссылка"));
	ВыборкаПоСоставу = ЗапросСоставаИсполнителей.Выполнить().Выгрузить();
	// проверим, что нет таких сертификатов, по которым нет контроля на состав исполнителей
	ЛюбойИсполнитель = ВыборкаПоСоставу.Найти(Ложь,"ПроверятьСоставИсполнителей");
	Если ЛюбойИсполнитель = Неопределено Тогда // есть строгое ограничение на состав исполнителей по всем доступным сертификатам
		МассивИсполнителей = ВыборкаПоСоставу.ВыгрузитьКолонку("Исполнитель");		
		СтруктураДопОтбора.Вставить("ОтборПоИсполнителям", Истина);
		ЗапросПоДокументам.УстановитьПараметр("СоставИсполнителей", МассивИсполнителей);
	КонецЕсли;
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыЭД.Утвержден);
	МассивСтатусов.Добавить(Перечисления.СтатусыЭД.ЧастичноПодписан);
	ЗапросПоДокументам.Текст = ЭлектронныеДокументы.ПолучитьТекстЗапросаЭлектронныхДокументовНаПодписи(Ложь, СтруктураДопОтбора);							   
	ЗапросПоДокументам.УстановитьПараметр("СтатусЭД", МассивСтатусов);
	ЗапросПоДокументам.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
	Таблица = ЗапросПоДокументам.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(Таблица,"СводнаяТаблица");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьМассивДокументов(МассивДокументовНаПодпись)
	
	Если МассивДокументовНаПодпись.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	// спросим пароль для ЭЦП
	ПараметрыФормы = Новый Структура("Заголовок, ПредставлениеСертификата",
		НСтр("ru = 'Введите пароль для ЭЦП'"), СертификатПодписи);
	КодВозврата = ОткрытьФормуМодально("ОбщаяФорма.ЗапросПароляНаЭЦПШифрование", ПараметрыФормы);
	
	Если ТипЗнч(КодВозврата) = Тип("Строка") Тогда
		ПарольПользователя = КодВозврата;
	Иначе // отказались вводить пароль
		Возврат;
	КонецЕсли;

	//передадим на подпись
	КолПодписанных = ЭлектронныеДокументыКлиент.ПодписатьЭДОпределеннымСертификатом(МассивДокументовНаПодпись, СертификатПодписи, ПарольПользователя);
	
	// а потом еще и отправляет в случае успеха
	КолПодготовленных = 0;
	Если КолПодписанных > 0 Тогда
		КолПодготовленных = ЭлектронныеДокументыКлиент.ПодготовитьКОтправкеЭД(МассивДокументовНаПодпись, Истина);
		Оповестить("ОбновитьСостояниеЭД");
		МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
		ЗаполнитьСписокСертификатовИДокументов(МассивСтруктурСертификатов);
		ЗаполнитьСписокДокументовПоСертификату();
	КонецЕсли;
	
	ЭлектронныеДокументыКлиент.ВывестиИнформациюОбОбработанныхЭД(0, 0, КолПодписанных, КолПодготовленных);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	МассивДокументовНаПодпись = Новый Массив;
	// подписываем только выбранные строки
	Для Каждого ТекСтрока Из ТаблицаДокументов Цикл
		Если ТекСтрока.Выбрать Тогда
			МассивДокументовНаПодпись.Добавить(ТекСтрока.ЭлектронныйДокумент);
		КонецЕсли;
	КонецЦикла;
	
	ПодписатьМассивДокументов(МассивДокументовНаПодпись);

КонецПроцедуры

&НаКлиенте
Процедура ПодписатьВсе(Команда)
	
	// если есть, что подписывать
	Если НЕ ПроверитьНаличиеДокументовПоСертификату() Тогда
		Возврат;
	КонецЕсли;
	
	// по выделенному сертификату найдем все документы на подпись в сводной таблице
	СертификатПодписи = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено, 
						ТаблицаСертификатов[0].Сертификат, Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат);
	
	ПараметрыОтбора = Новый Структура("Сертификат", СертификатПодписи);
	СтрокиДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора);
	
	МассивДокументовНаПодпись = Новый Массив;
	// составим массив из имен электронных документов 
	Для Каждого ЭлементТаблицы Из СтрокиДокументов Цикл
		МассивДокументовНаПодпись.Добавить(ЭлементТаблицы.ЭлектронныйДокумент);
	КонецЦикла;
	
	ПодписатьМассивДокументов(МассивДокументовНаПодпись);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронныеДокументыКлиент.ОткрытьЭДДляПросмотра(Элементы.ТаблицаДокументов.ТекущиеДанные.ЭлектронныйДокумент);	
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПерезаполнитьТаблицы()
	
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
	ЗаполнитьСписокСертификатовИДокументов(МассивСтруктурСертификатов);
	ЗаполнитьСписокДокументовПоСертификату();
	
КонецПроцедуры
	
&НаКлиенте
Функция ПроверитьНаличиеДокументовПоСертификату() 
	
	ПроверочныеДанные = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено, 
							ТаблицаСертификатов[0], Элементы.ТаблицаСертификатов.ТекущиеДанные);
	
	Если ПроверочныеДанные.КоличествоДокументов = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'По данному сертификату нет документов на подпись'");
		Предупреждение(ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаСертификатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СертификатПодписи = Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат;
	Если НЕ ПроверитьНаличиеДокументовПоСертификату() Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьСписокДокументовПоСертификату();
	ПерейтиНаСтраницу(Истина);
	
КонецПроцедуры

&НаКлиенте
Функция ПерейтиНаСтраницу(КДетализации)
	
	Если КДетализации Тогда
		Элементы.СтраницыАРМ.ТекущаяСтраница = Элементы.СтраницыАРМ.ПодчиненныеЭлементы.СтраницаДетализации; 
		ЭтаФорма.Заголовок = "Документы на подпись по сертификату: "+СертификатПодписи;
	Иначе
		Элементы.СтраницыАРМ.ТекущаяСтраница = Элементы.СтраницыАРМ.ПодчиненныеЭлементы.СтраницаСводки;
		ЭтаФорма.Заголовок = "Документы на подпись";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокДокументовПоСертификату()
	
	ТаблицаДокументов.Очистить();
	ПараметрыОтбора = Новый Структура("Сертификат", СертификатПодписи);
	СтрокиДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаСДокументом Из СтрокиДокументов Цикл
		СтрокаТаблицы = ТаблицаДокументов.Добавить();
		СтрокаТаблицы.ЭлектронныйДокумент 	= СтрокаСДокументом.ЭлектронныйДокумент;
		СтрокаТаблицы.СуммаДокумента 		= СтрокаСДокументом.СуммаДокумента;
		СтрокаТаблицы.ДатаДокумента 		= СтрокаСДокументом.ДатаДокумента;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКСпискуСертификатов(Команда)
	ПерейтиНаСтраницу(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСпискуДокументов(Команда)
	
	СертификатПодписи = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено, 
							ТаблицаСертификатов[0].Сертификат, Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат);
	Если НЕ ПроверитьНаличиеДокументовПоСертификату() Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьСписокДокументовПоСертификату();
	ПерейтиНаСтраницу(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЭлектронныеДокументы.ИспользуетсяОбменЭД() Тогда
		ТекстСообщения = НСтр("ru = 'Для работы с электронными документами необходимо в настройках системы включить использование обмена электронными документами'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;
	
	Если НЕ Константы.ИспользоватьЭлектронныеЦифровыеПодписи.Получить() Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности подписания ЭД необходимо в настройках системы включить опцию использования электронных цифровых подписей'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;
		
	Элементы.СтраницыАРМ.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВыделенные(Команда)
		
	МассивСтрок = Элементы.ТаблицаДокументов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаДокументов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбрать = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсехСтрок(Команда)
		
	Для Каждого ТекДокумент Из ТаблицаДокументов Цикл
	 	Если ТекДокумент.Выбрать Тогда
			ТекДокумент.Выбрать = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		ПерезаполнитьТаблицы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭДПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

