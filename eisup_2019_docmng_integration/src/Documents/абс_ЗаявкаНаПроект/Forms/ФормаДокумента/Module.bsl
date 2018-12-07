     
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСтатустНаСервере();
	мСтатус = Объект.СтатусПроекта;
	ОбновитьВидимость();
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("ЗаявкаНаПроект", Объект.Ссылка);
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.СтатусПроекта = Перечисления.абс_СтатусыПроектов.Подготовка;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаНачалаПроекта) ИЛИ НЕ ЗначениеЗаполнено(Объект.ДатаОкончанияПроекта) Тогда
		
		СрокиПроекта = "ввести сроки проекта";
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура мСтатусПриИзменении(Элемент)
	
	ЗаполнитьСтатустНаСервере();
	Объект.СтатусПроекта = мСтатус;
	ОбновитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатустНаСервере()

	Документы.абс_ЗаявкаНаПроект.ЗаполнитьСписокДоступныхСтатусов(Элементы.мСтатус.СписокВыбора,Объект.Ссылка);

КонецПроцедуры // ()

&НаКлиенте
Процедура ОбновитьВидимость()
	
	УстановитьТолькоПросмотрВсемЭлементам(Ложь);
	Если не мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.Подготовка") Тогда
		
		УстановитьТолькоПросмотрВсемЭлементам();
		
		Если мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.СогласованиеДЭИ") Тогда
            Элементы.СуммаДохода.ТолькоПросмотр  = Ложь;
			Элементы.СуммаРасхода.ТолькоПросмотр = Ложь;
			
		ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.СогласованиеДТР") Тогда	
			
			Элементы.ДоходыПроектов.ТолькоПросмотр = Ложь;
			Элементы.ТЭО.ТолькоПросмотр            = Ложь;
			
			
		ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.РазработкаТЭО") Тогда
			
			Элементы.ТЭО.ТолькоПросмотр            = Ложь;
		ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.Согласован") Тогда
			
			
			
		КонецЕсли;	
	КонецЕсли;	
    //сроки проекта
	Если Не ЗначениеЗаполнено(Объект.ДатаНачалаПроекта) ИЛИ НЕ ЗначениеЗаполнено(Объект.ДатаОкончанияПроекта) Тогда
		СрокиПроекта = "ввести сроки проекта";
	Иначе
		СрокиПроекта = "с "+Формат(Объект.ДатаНачалаПроекта,"ДЛФ=DD")+" по "+Формат(Объект.ДатаОкончанияПроекта,"ДЛФ=DD"); 
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьТолькоПросмотрВсемЭлементам(мТолькоПросмотр = Истина)

	Для каждого Элемент Из Элементы Цикл
		Если Элемент = Элементы.ФормаКоманднаяПанель ИЛИ
			Элемент = Элементы.мСтатус ИЛИ
			Элемент = Элементы.мСтатусКонтекстноеМеню ИЛИ
			Элемент = Элементы.Группа3 ИЛИ
			Элемент = Элементы.Группа1 ИЛИ
			Элемент = Элементы.Группа2 ИЛИ
			Элемент = Элементы.Группа4 ИЛИ
			Элемент = Элементы.Группа5 ИЛИ
			Элемент = Элементы.ПлановаяСтоимость ИЛИ
			Элемент = Элементы.ГруппаПроекты ИЛИ
            Элемент = Элементы.ПроектыТЧ ИЛИ
			Элемент = Элементы.НомерДата Тогда
			Продолжить;
		КонецЕсли;	
		//Сообщить(Элемент);
		Попытка
			Элемент.ТолькоПросмотр = мТолькоПросмотр;
		Исключение
			//Элемент.Доступность    = НЕ мТолькоПросмотр;
		КонецПопытки;	
	КонецЦикла;

КонецПроцедуры // ()

&НаКлиенте
Процедура ПроектыПередУдалением(Элемент, Отказ)
	
	ТекСтрока = Элементы.Проекты.ТекущиеДанные;
    УдалитьСвязанные(ТекСтрока.КлючСтроки);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязанные(КлючСтроки)
	
	СтруктураПоиска = Новый Структура("КлючСтроки",КлючСтроки);
	ОбъектЗначение   = РеквизитФормыВЗначение("Объект");
	СтрокиДляУдаления = ОбъектЗначение.ВнутренниеЛимитыПроектов.НайтиСтроки(СтруктураПоиска);
	
	Для каждого Строка Из СтрокиДляУдаления Цикл
	
		 ОбъектЗначение.ВнутренниеЛимитыПроектов.Удалить(Строка);
	
	КонецЦикла;
	
	СтрокиДляУдаления = ОбъектЗначение.ДоходыПроектов.НайтиСтроки(СтруктураПоиска);
	
	Для каждого Строка Из СтрокиДляУдаления Цикл
	
		 ОбъектЗначение.ДоходыПроектов.Удалить(Строка);
	
	КонецЦикла;
	
	СтрокиДляУдаления = ОбъектЗначение.РасходыПроектов.НайтиСтроки(СтруктураПоиска);
	
	Для каждого Строка Из СтрокиДляУдаления Цикл
	
		 ОбъектЗначение.РасходыПроектов.Удалить(Строка);
	
	 КонецЦикла;
	 
	 ЗначениеВРеквизитФормы(ОбъектЗначение,"Объект");
	 
КонецПроцедуры 


&НаКлиенте
Процедура ПроектыПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Проекты.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекСтрока.КлючСтроки) Тогда
		ТекСтрока.КлючСтроки = ПолучитьНовыйКлюч(Объект.Проекты);
	КонецЕсли;
	
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Отбор     = Новый ФиксированнаяСтруктура("КлючСтроки",ТекСтрока.КлючСтроки);
	
	Элементы.ДоходыПроектов.ОтборСтрок           = Отбор;
	Элементы.РасходыПроектов.ОтборСтрок          = Отбор;
	Элементы.ВнутренниеЛимитыПроектов.ОтборСтрок = Отбор;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьНовыйКлюч(Таблица)
	
	 НовыйКлюч = 0;
	 Для каждого СтрокаТаблицы Из Таблица Цикл
	 
	 	НовыйКлюч = ?(СтрокаТаблицы.КлючСтроки > НовыйКлюч, СтрокаТаблицы.КлючСтроки,НовыйКлюч);
	 
	 КонецЦикла;
	 
	 Возврат НовыйКлюч + 1;
	 
КонецФункции	

&НаКлиенте
Процедура ВнутренниеЛимитыПроектовПриИзменении(Элемент)
	
	ТекСтрокаПроекты = Элементы.Проекты.ТекущиеДанные;
	
	Если ТекСтрокаПроекты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекСтрока = Элементы.ВнутренниеЛимитыПроектов.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекСтрока.КлючСтроки) Тогда
		ТекСтрока.КлючСтроки = ТекСтрокаПроекты.КлючСтроки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоходыПроектовПриИзменении(Элемент)
	
	ТекСтрокаПроекты = Элементы.Проекты.ТекущиеДанные;
	Если ТекСтрокаПроекты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекСтрока = Элементы.ДоходыПроектов.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекСтрока.КлючСтроки) Тогда
		ТекСтрока.КлючСтроки = ТекСтрокаПроекты.КлючСтроки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасходыПроектовПриИзменении(Элемент)
	
	ТекСтрокаПроекты = Элементы.Проекты.ТекущиеДанные;
	Если ТекСтрокаПроекты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекСтрока = Элементы.РасходыПроектов.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекСтрока.КлючСтроки) Тогда
		ТекСтрока.КлючСтроки = ТекСтрокаПроекты.КлючСтроки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроектыПриАктивизацииСтроки(Элемент)
	
	ТекСтрока = Элементы.Проекты.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Отбор     = Новый ФиксированнаяСтруктура("КлючСтроки",ТекСтрока.КлючСтроки);
	
	Элементы.ДоходыПроектов.ОтборСтрок           = Отбор;
	Элементы.РасходыПроектов.ОтборСтрок          = Отбор;
	Элементы.ВнутренниеЛимитыПроектов.ОтборСтрок = Отбор;
КонецПроцедуры

&НаКлиенте
Процедура Файлы(Команда)
	
	//Если НЕ РаботаСДиалогами.ЗаписатьНовыйОбъектВФорме(ЭтаФорма) Тогда
	//	Возврат;
	//КонецЕсли;
	
	СтруктураДляСпискаИзображдений = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	СтруктураДляСпискаДополнительныхФайлов = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	ОбязательныеОтборы = Новый Структура("Объект", Объект.Ссылка);
	
	РаботаСФайлами.ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображдений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	врСтатус =  абс_БизнесПроцессы.ПолучитьСтатусСогласованияПроекта(Объект.Ссылка);
	
	Если мСтатус <> врСтатус Тогда
		
		Объект.ПричинаИзмененияСтатуса = "";
		ВвестиСтроку(Объект.ПричинаИзмененияСтатуса, "Укажите причину изменения статуса.",,Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СрокиПроектаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Результат = ОткрытьФормуМодально("Документ.абс_ЗаявкаНаПроект.Форма.ФормаВыбораПериода",Новый Структура("ДатаНачала,ДатаОкончания",
																							ОБъект.ДатаНачалаПроекта,ОБъект.ДатаОкончанияПроекта));
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОБъект.ДатаНачалаПроекта    = Результат.ДатаНачала;
	ОБъект.ДатаОкончанияПроекта = Результат.ДатаОкончания;
	СрокиПроекта = "с "+Формат(Объект.ДатаНачалаПроекта,"ДЛФ=DD")+" по "+Формат(Объект.ДатаОкончанияПроекта,"ДЛФ=DD");
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаполнитьСтатустНаСервере();
	мСтатус = Объект.СтатусПроекта;
	ОбновитьВидимость();
    Элементы.ИсторияСогласования1.Обновить();
	
	Если Объект.СтатусПроекта = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.Согласован") Тогда
		 ТекстВопроса = "Создать номенклатурные группы и проекты?";
		 Кнопки       = РежимДиалогаВопрос.ДаНет;
		 Если Вопрос(ТекстВопроса,Кнопки) = КодВозвратаДиалога.Да Тогда
			 
			 Документы.абс_ЗаявкаНаПроект.СформироватьНоменклатурныеГруппыИПроекты(Объект.Ссылка);
			 ПечитатьДанныеФОрмы();
			 Элементы.Проекты.Обновить();
			 ЭтаФорма.ОбновитьОтображениеДанных();
			 
		 КонецЕсли;
		
	 КонецЕсли;
	 
	 УстановитьПараметрСпискаНаСервере();
	 Элементы.Проекты.Обновить();
	 ЭтаФорма.ОбновитьОтображениеДанных();
 КонецПроцедуры
 
 &НаСервере
 Процедура УстановитьПараметрСпискаНаСервере()
	 ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("ЗаявкаНаПроект", Объект.Ссылка);
 КонецПроцедуры	 

  &НаСервере
 Процедура ПечитатьДанныеФОрмы()
	 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	абс_ЗаявкаНаПроектПроекты.НоменклатурнаяГруппа,
		|	абс_ЗаявкаНаПроектПроекты.Проект,
		|	абс_ЗаявкаНаПроектПроекты.НомерСтроки
		|ИЗ
		|	Документ.абс_ЗаявкаНаПроект.Проекты КАК абс_ЗаявкаНаПроектПроекты
		|ГДЕ
		|	абс_ЗаявкаНаПроектПроекты.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ТЧПроекты = Объект.Проекты;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЧ = ТЧПроекты.НайтиСтроки(Новый Структура("НомерСтроки",ВыборкаДетальныеЗаписи.НомерСтроки));
		СтрокаТЧ[0].НоменклатурнаяГруппа = ВыборкаДетальныеЗаписи.НоменклатурнаяГруппа;
		СтрокаТЧ[0].Проект               = ВыборкаДетальныеЗаписи.Проект;
	КонецЦикла;
 
	 
 КонецПроцедуры	 

&НаКлиенте
 Процедура ПроектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	 
	 
	 
 КонецПроцедуры
