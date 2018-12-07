
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БольшеНеСпрашивать = Ложь;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда
		
		Элементы.КакОткрывать.Заголовок = НСтр("ru ='Режим открытия файла'");
		Элементы.КакОткрывать.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.КакОткрывать.ВидПереключателя = ВидПереключателя.Переключатель;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.Справка.Видимость = Ложь;
		Элементы.ДекорацияНадпись.Высота = 2;
		Элементы.КоманднаяПанельМобильныйКлиент.Видимость = Истина;
		Элементы.ОткрытьФайлМобильныйКлиент.КнопкаПоУмолчанию = Истина;
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если БольшеНеСпрашивать = Истина Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла", Ложь,,, Истина);
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеСпрашивать", БольшеНеСпрашивать);
	РезультатВыбора.Вставить("КакОткрывать", КакОткрывать);
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ОповеститьОВыборе(КодВозвратаДиалога.Отмена);
КонецПроцедуры

#КонецОбласти
