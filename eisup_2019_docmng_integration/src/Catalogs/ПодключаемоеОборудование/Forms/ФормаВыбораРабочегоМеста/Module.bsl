&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РабочееМесто = МенеджерОборудованияСервер.ПолучитьРабочееМестоКлиента();

	ОткрыватьПриПервомОбращении = Параметры.ОткрыватьПриПервомОбращении;
	ИдентификаторКлиента        = Параметры.ИдентификаторКлиента;

	// Если передали имя компьютера, то значит необходимо выбрать рабочее место
	// из уже существующего (не пустого) списка рабочих мест
	Если Не ПустаяСтрока(ИдентификаторКлиента) Тогда
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Код", ИдентификаторКлиента));
		НовыйФиксированныйМассив = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.РабочееМесто.ПараметрыВыбора = НовыйФиксированныйМассив;

		Элементы.НадписьНастройки.Доступность = Ложь;
		Элементы.ПодключитьИНастроитьПО.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ПодключитьИНастроитьПО.Доступность = ЗначениеЗаполнено(РабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИНастроитьПО(Команда)
	
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		
		МенеджерОборудованияСервер.УстановитьРабочееМестоКлиента(РабочееМесто);
		Оповестить("ИзмененоРабочееМестоТекущегоСеанса", РабочееМесто);
		
		Закрыть();
		
		ОткрытьФормуМодально("Справочник.ПодключаемоеОборудование.ФормаСписка");
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Команда)

	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		Параметры.РабочееМесто = РабочееМесто;

		СписокНастроек = Новый Структура();
		СписокНастроек.Вставить("ОткрытьФормуВыбораРМПриПервомОбращении", ОткрыватьПриПервомОбращении);
		МенеджерОборудованияКлиент.СохранитьПользовательскиеНастройкиПодключаемогоОборудования(СписокНастроек);

		ОчиститьСообщения();
		Закрыть(КодВозвратаДиалога.ОК);
	Иначе
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выберите рабочее место'"), РабочееМесто, "РабочееМесто");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	
	Элементы.ПодключитьИНастроитьПО.Доступность = ЗначениеЗаполнено(РабочееМесто);
	
КонецПроцедуры
