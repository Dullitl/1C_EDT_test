////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрУведомление(Отчет)
	
	Настройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	Для Каждого Элемент Из Настройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Уведомление") Тогда
			Элемент.Значение = Отчет.Уведомление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиУведомление(ТипПоиска)
	
	Если Не ЗначениеЗаполнено(Отчет.ОтчетныйГод) Тогда 
		Отчет.ОтчетныйГод = Год(ТекущаяДата());
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		
		НайденноеУведомление = КонтролируемыеСделки.НайтиУведомлениеОрганизацииВОтчетномГоду(Отчет.Организация,Отчет.ОтчетныйГод,ЭтаФорма.ТипУведомления,ЭтаФорма.НомерКорректировки,ТипПоиска);
		
		Если НайденноеУведомление <> Неопределено Тогда
			Отчет.Уведомление = НайденноеУведомление;
		ИначеЕсли ЗначениеЗаполнено(Отчет.Уведомление)Тогда
			НомерКорректировки = Отчет.Уведомление.НомерКорректировки;
			ТипУведомления = ?(НомерКорректировки = 0,0,1);
			Отчет.ОтчетныйГод = Год(Отчет.Уведомление.ОтчетныйГод);
		КонецЕсли;
	Иначе
		Отчет.Уведомление = Неопределено;	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отчет.Уведомление) И ЗначениеЗаполнено(Отчет.Организация) Тогда
		Элементы.ДекорацияУведомлениеНеНайдено.Заголовок = "За " + Отчет.ОтчетныйГод + " год у " + Отчет.Организация.НаименованиеСокращенное + " нет уведомлений";	
	КонецЕсли;
	ЭтаФорма.Элементы.НомерКорректировки.Доступность = ТипУведомления <> 0;
	УстановитьПараметрУведомление(Отчет);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	
	НомерКорректировки = 0;
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУведомленияПриИзменении(Элемент)
	
	Если ТипУведомления = 0 Тогда
		НомерКорректировки = 0;
		НайтиУведомление("Указанный");
	Иначе
		НайтиУведомление("Последний");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НомерКорректировки = НомерКорректировки + Направление;
	НайтиУведомление(?(Направление > 0,"Следующий","Предыдущий"));
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	НомерКорректировки = Число(Текст);
	НайтиУведомление("Указанный");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Уведомление", Отчет.Уведомление);
	
	Если ЗначениеЗаполнено(Отчет.Уведомление) Тогда
		ПараметрыУведомления = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Отчет.Уведомление, "Организация, ОтчетныйГод, НомерКорректировки");
		Отчет.Организация = ПараметрыУведомления.Организация;
		Отчет.ОтчетныйГод = Год(ПараметрыУведомления.ОтчетныйГод);
		НомерКорректировки = ПараметрыУведомления.НомерКорректировки;
		ТипУведомления = ?(НомерКорректировки = 0,0,1);
		ЭтаФорма.Элементы.НомерКорректировки.Доступность = ТипУведомления <> 0;
	Конецесли;	
	
КонецПроцедуры
