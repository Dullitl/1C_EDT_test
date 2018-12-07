&НаКлиенте
Перем НужноУдалитьРегламентноеЗадание Экспорт; // Ответ пользователя на вопрос о необходимости удалять регл. задание (булево или неопределено)
&НаКлиенте
Перем РазрешеноРедактированиеДатыНачала; //Булево - спрашивали ли в сеансе работы с формой о разрешении редактирования даты начала обработки данных

// Устанавливает подпись к полю Задержка с учетом формы множественного числа
&НаКлиенте
Процедура НастроитьНадписьЗадержка()
	
	Если РасчитыватьСебестоимостьЗаПредыдущийПериод Тогда
	
		Элементы.НадписьПояснениеЗадержка.Заголовок = "";
		
	Иначе
		
		Элементы.НадписьПояснениеЗадержка.Заголовок = "Расчет будет проводиться за текущий месяц";
		
	КонецЕсли;
	
	Дней = ОбщегоНазначения.ФормаМножественногоЧисла("месяц","месяца","месяцев", Объект.Задержка);
	
	Элементы.Задержка.Заголовок = Дней + " назад";
	
КонецПроцедуры

// Устанавливает доступность элементов формы
//

&НаКлиенте
Процедура УправлениеДоступностью()
	
	Если ТолькоПросмотр Тогда
		// Доступность регулируется настройками в диалоге
		Возврат;
	КонецЕсли;
	
	Элементы.ПредставлениеРасписания.Доступность = Объект.ФормироватьДокументыАвтоматически;
	Элементы.РасчитыватьСебестоимостьЗаПредыдущийПериод.Доступность = Объект.ФормироватьДокументыАвтоматически;
	Элементы.Задержка.Доступность = Объект.ФормироватьДокументыАвтоматически И РасчитыватьСебестоимостьЗаПредыдущийПериод;
	Элементы.Организация.Доступность = (Объект.ВидОтраженияВУчете <> ВидОтраженияВУчетеОтражатьВУправленческомУчете);
	
	Элементы.СтраницаРасписание.Заголовок = Нстр("ru = 'Расписание '") + ?(Расписание = Неопределено, Нстр("ru = '(не задано)'"),"");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыполняемыеДействия()

	Если Объект.ВидОтраженияВУчете = Перечисления.ВидыОтраженияВУчете.ОтражатьВУправленческомУчете ТОгда
		ОтражатьВУправленческомУчете = Истина;
		ОтражатьВНалоговомУчете = Ложь;
	Иначе
		ОтражатьВУправленческомУчете = Ложь;
		ОтражатьВНалоговомУчете = Истина;
	КонецЕсли;	
	
	МассивДействий = ПроцедурыРасчетаСебестоимостиВыпуска.ПолучитьМассивВыполняемыхДействий(ТекущаяДата(), Объект.Организация, ОтражатьВУправленческомУчете, ОтражатьВНалоговомУчете, Истина);
	
	Объект.ВыполняемыеДействия.Очистить();
	Для Каждого ТекущееДействие Из МассивДействий Цикл
		НоваяСтрока = Объект.ВыполняемыеДействия.Добавить();
		НоваяСтрока.ВыполняемоеДействие = ТекущееДействие;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеДоступностью();
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	НастроитьНадписьЗадержка();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВидОтраженияВУчетеОтражатьВУправленческомУчете = Перечисления.ВидыОтраженияВУчете.ОтражатьВУправленческомУчете;
	Расписание = РегламентныеПроцедуры.ПолучитьРасписаниеРегламентногоЗадания(Объект.РегламентноеЗадание);
	РасчитыватьСебестоимостьЗаПредыдущийПериод = (Объект.Задержка <> 0);
	РегламентныеПроцедуры.НастроитьПредставлениеРасписания(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьДокументыАвтоматическиПриИзменении(Элемент)
	ФормироватьДокументыАвтоматически = Объект.ФормироватьДокументыАвтоматически;
	НужноУдалитьРегламентноеЗадание = РегламентныеПроцедуры.ПриИзмененииФлагаФормироватьДокументыАвтоматически(ЭтаФорма);
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияНажатие(Элемент)
	РегламентныеПроцедуры.РедактироватьРасписаниеРегламентногоЗадания(ЭтаФорма);
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПараметрыЗаписи.Вставить("НужноУдалитьРегламентноеЗадание", НужноУдалитьРегламентноеЗадание);
	ПараметрыЗаписи.Вставить("Расписание", Расписание);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПараметрыЗаписи.НужноУдалитьРегламентноеЗадание = Истина Тогда
		ЗаголовокСообщения = ТекущийОбъект.ЗаголовокПриЗаписи();
		РегламентныеПроцедуры.УдалитьРегламентноеЗаданиеПриЗаписиНастройки(ТекущийОбъект,ЗаголовокСообщения,Отказ);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Обрабатываем расписание регл. задания
	Если НЕ ТекущийОбъект.ФормироватьДокументыАвтоматически Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаголовокСообщения = ТекущийОбъект.ЗаголовокПриЗаписи();
	РегламентныеПроцедуры.ИзменитьРегламентноеЗаданиеПриЗаписиНастройки(ТекущийОбъект,ПараметрыЗаписи.Расписание,ЗаголовокСообщения,Отказ);

КонецПроцедуры

&НаКлиенте
Процедура РасчитыватьСебестоимостьЗаПредыдущийПериодПриИзменении(Элемент)
	Если НЕ РасчитыватьСебестоимостьЗаПредыдущийПериод Тогда
		Объект.Задержка = 0;
	Иначе
		Объект.Задержка = 1;
	КонецЕсли;
	
	УправлениеДоступностью();
	НастроитьНадписьЗадержка();
КонецПроцедуры

&НаКлиенте
Процедура ЗадержкаПриИзменении(Элемент)
	НастроитьНадписьЗадержка();
КонецПроцедуры

&НаКлиенте
Процедура ВыполняемыеДействияВыполняемоеДействиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	Элемент.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРасчетаСебестоимостиВыпуска.ПолучитьМассивВыполняемыхДействий(ТекущаяДата(), Объект.Организация, (Объект.ВидОтраженияВУчете = ВидОтраженияВУчетеОтражатьВУправленческомУчете), (Объект.ВидОтраженияВУчете <> ВидОтраженияВУчетеОтражатьВУправленческомУчете)));	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыполняемыхДействий(Команда)
	Если Объект.ВыполняемыеДействия.Количество() > 0 Тогда
	 
		Ответ = Вопрос("В документе уже присутствуют строки." + Символы.ПС
					 + "При заполнении они будут удалены!" + Символы.ПС
					 + "Продолжить?", РежимДиалогаВопрос.ДаНет,,
					 КодВозвратаДиалога.Нет,
					 "Заполнить список действий");
					 
		Если Не Ответ = КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
		Объект.ВыполняемыеДействия.Очистить();
	КонецЕсли;
	
	ЗаполнитьВыполняемыеДействия();
КонецПроцедуры

&НаКлиенте
Процедура ВидОтраженияВУчетеПриИзменении(Элемент)
	Если Объект.ВидОтраженияВУчете = ВидОтраженияВУчетеОтражатьВУправленческомУчете Тогда
		Организация = "";
	КонецЕсли;
	УправлениеДоступностью();
КонецПроцедуры
