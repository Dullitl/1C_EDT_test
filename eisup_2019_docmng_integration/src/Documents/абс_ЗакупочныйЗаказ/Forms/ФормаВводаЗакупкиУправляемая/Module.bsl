
&НаКлиенте
Процедура КомандаПоказатьГрафик(Команда)
	// Вставить содержимое обработчика.
//	ТЗ = ТаблицаГрафикаОплаты.Выгрузить();
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ТаблицаГрафикаОплаты.Загрузить(Параметры.ТаблицаГрафикОплаты.выгрузить());
	ТаблицаДоговоров.Загрузить(Параметры.ТаблицаДоговоры.выгрузить());
	
	Ссылка 			= Параметры.Ссылка;
	ДатаПоставки 	= ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСчет(Команда)
	
	// Вставить содержимое обработчика.
	СтруктураОплаты = Новый Структура;
	
	СтруктураОплаты.Вставить("ДатаПоставки"			, ДатаПоставки);
	СтруктураОплаты.Вставить("СуммаПоставки"		, СуммаПоставки);
	СтруктураОплаты.Вставить("ДоговорКонтрагента"	, Элементы.ТаблицаДоговоров.ТекущиеДанные.ДоговорКонтрагента);
	СтруктураОплаты.Вставить("ТипДоговора"			, Элементы.ТаблицаДоговоров.ТекущиеДанные.ТипДоговора);
	СтруктураОплаты.Вставить("ВходящийНомер"		, Элементы.ТаблицаДоговоров.ТекущиеДанные.ВходящийНомер);
	СтруктураОплаты.Вставить("ДатаДоговора"			, Элементы.ТаблицаДоговоров.ТекущиеДанные.ДатаДоговора);
	СтруктураОплаты.Вставить("Сумма"				, Элементы.ТаблицаДоговоров.ТекущиеДанные.Сумма);
	СтруктураОплаты.Вставить("ВалютаДоговора"		, Элементы.ТаблицаДоговоров.ТекущиеДанные.ВалютаДоговора);


	//СуммаПоГрафику = ПолучитьСуммаПоГрафику(ДатаПлатежа);
	//Если СуммаПоГрафику>=СтруктураОплаты.СуммаОплаты или Ссылка.НефиксированнаяСумма Тогда
		ЭтаФорма.Закрыть(СтруктураОплаты);
	//Иначе
	//	сообщить("Сумма оплаты превышает сумму по графику. Сумма по графику на "+Формат(ДатаПлатежа,"ЧЦ=15; ЧДЦ=1; ДЛФ=DD")+" равна "+СуммаПоГрафику);
	//КонецЕсли;
	
КонецПроцедуры
