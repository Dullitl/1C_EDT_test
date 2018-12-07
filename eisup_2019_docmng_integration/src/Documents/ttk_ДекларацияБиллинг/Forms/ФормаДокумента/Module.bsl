
&НаКлиенте
Процедура ТипФайлаЗагрузкиПриИзменении(Элемент)
	Если Объект.КнигаПокупок.Количество() > 0 ИЛИ Объект.КнигаПродаж.Количество() > 0 Тогда
		Ответ = Вопрос("Табличные части будут очищены. Продолжить?",РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.КнигаПокупок.Очистить();
			Объект.КнигаПродаж.Очистить();
			НастройкаВидимости();
		КонецЕсли; 	
	Иначе
		НастройкаВидимости();
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДопЛистаПриИзменении(Элемент)
	Если Объект.ЗагрузкаДопЛиста Тогда
		Элементы.КорректируемыйПериод.Видимость = Истина;
		Элементы.ПериодДоп.Видимость = Истина;
	Иначе
		Элементы.КорректируемыйПериод.Видимость = ложь;
		Элементы.ПериодДоп.Видимость = Ложь;
		Объект.КорректируемыйПериод = Дата(1,1,1);
		Объект.ПериодДоп = Дата(1,1,1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВидимости()
	Если Объект.ТипФайлаЗагрузки = "Книга покупок" Тогда
		Элементы.КнигаПокупок.Видимость = Истина;
		Элементы.КнигаПродаж.Видимость = Ложь;
	ИначеЕсли Объект.ТипФайлаЗагрузки = "Книга продаж" Тогда
		Элементы.КнигаПродаж.Видимость = Истина;
		Элементы.КнигаПокупок.Видимость = Ложь;
	Иначе
		Элементы.КнигаПродаж.Видимость = Ложь;
		Элементы.КнигаПокупок.Видимость = Ложь;
	КонецЕсли;
	//Бобылев А.А. 16.04.2018 СППР 00-00000068
	Если Объект.ЗагрузкаДопЛиста Тогда
		Элементы.КорректируемыйПериод.Видимость = Истина;
		Элементы.ПериодДоп.Видимость = Истина;
	Иначе
		Элементы.КорректируемыйПериод.Видимость = ложь;
		Элементы.ПериодДоп.Видимость = Ложь;
		Объект.КорректируемыйПериод = Дата(1,1,1);
		Объект.ПериодДоп = Дата(1,1,1);
	КонецЕсли;
	//Бобылев А.А. -------------
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда) 
	//Бобылев А.А. 16.04.2018 СППР 00-00000068
	Если Не ЗначениеЗаполнено(ЛистExcel) Тогда
		ЛистExcel = 1;
	КонецЕсли;
	//Бобылев А.А. ----------------------
	если ЗначениеЗаполнено(Объект.ТипФайлаЗагрузки) тогда
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "Табличный документ(*.xls);Табличный документ(*.xlsx)|*.xls;*.xlsx";
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;		
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяФайла);
		Состояние("Обработка файла Microsoft Excel...");
	Исключение
		Сообщить("Ошибка при открытии файла с помощью Excel! Загрузка не будет произведена!");
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	
	Если Объект.ТипФайлаЗагрузки = "Книга покупок" Тогда
		НомерПервойСтроки = 6;
	Иначе
		НомерПервойСтроки = 8;
	КонецЕсли;
	
	//Если Объект.ЗагрузкаДопЛиста Тогда
	//ВсегоЛистов = Excel.Sheets.Count;	
	//Иначе ВсегоЛистов = 1;		
	//КонецЕсли;
	//	Для КоличествоЛистов = 1 По ВсегоЛистов Цикл	
	//	Если КоличествоЛистов = 1 Тогда
	//		ДопЛист = Ложь;
	//	Иначе
	//		ДопЛист = истина;
	//	КонецЕсли;
		Попытка
			//Открываем необходимый лист
			//Бобылев А.А. 16.04.2018 СППР 00-00000068
			Excel.Sheets(ЛистExcel).Select(); // лист 1, по умолчанию
			//Бобылев А.А. ---------------------
		Исключение
			//Закрываем Excel
			Excel.ActiveWorkbook.Close();
			Excel = 0;
			Сообщить("Файл "+Строка(ИмяФайла)+" не соответствует необходимому формату! Первый лист не найден!");
			Возврат;
		КонецПопытки;
		
		ФайлСтрок = Excel.Cells(1,1).SpecialCells(11).Row;
		ФайлКолонок = Excel.Cells(1,1).SpecialCells(11).Column;
		
		Для НС = НомерПервойСтроки ПО ФайлСтрок Цикл
			Если Объект.ТипФайлаЗагрузки = "Книга покупок" Тогда
				Стр = Объект.КнигаПокупок.Добавить();
				Стр.КодВидаОперации = СокрЛП(Excel.Cells(НС, 2).Text);
				Стр.СчетФактура = СокрЛП(Excel.Cells(НС, 3).Text);
				Стр.СчетФактураИсправления = СокрЛП(Excel.Cells(НС, 4).Text);
				Стр.СчетФактураКорректировочный = СокрЛП(Excel.Cells(НС, 5).Text);
				Стр.СчетФактураИсправленияКор = СокрЛП(Excel.Cells(НС, 6).Text);
				Стр.НаименованиеПродавца = СокрЛП(Excel.Cells(НС, 9).Text);
				Стр.ИННКПППродавца = СокрЛП(Excel.Cells(НС, 10).Text);
				Стр.НаименованиеПосредника = СокрЛП(Excel.Cells(НС, 11).Text);
				Стр.ИННКПППосредника = СокрЛП(Excel.Cells(НС, 12).Text);
				Стр.ДокументУплаты = СокрЛП(Excel.Cells(НС, 7).Text);
				Стр.ДатаУчета = СокрЛП(Excel.Cells(НС, 8).Text);
				Стр.НомерТаможеннойДекларации = СокрЛП(Excel.Cells(НС, 13).Text);
				Стр.НаименованиеКодВалюты = СокрЛП(Excel.Cells(НС, 14).Text);
				Стр.Сумма = СокрЛП(Excel.Cells(НС, 15).Text);
				Стр.СуммаНДС = СокрЛП(Excel.Cells(НС, 16).Text);
				//Стр.ДопЛист = ДопЛист;
			Иначе
				Стр = Объект.КнигаПродаж.Добавить();
				Стр.КодВидаОперации = СокрЛП(Excel.Cells(НС, 2).Text);
				Стр.СчетФактура = СокрЛП(Excel.Cells(НС, 3).Text);
				Стр.СчетФактураИсправления = СокрЛП(Excel.Cells(НС, 4).Text);
				Стр.СчетФактураКорректировочный = СокрЛП(Excel.Cells(НС, 5).Text);
				Стр.СчетФактураИсправленияКор = СокрЛП(Excel.Cells(НС, 6).Text);
				Стр.НаименованиеПокупателя = СокрЛП(Excel.Cells(НС, 7).Text);
				Стр.ИННКПППокупателя = СокрЛП(Excel.Cells(НС, 8).Text);
				Стр.НаименованиеПосредника = СокрЛП(Excel.Cells(НС, 9).Text);
				Стр.ИННКПППосредника = СокрЛП(Excel.Cells(НС, 10).Text);
				Стр.ДокументОплаты = СокрЛП(Excel.Cells(НС, 11).Text);
				Стр.НаименованиеКодВалюты = СокрЛП(Excel.Cells(НС, 12).Text);
				Стр.СтоимостьВал = СокрЛП(Excel.Cells(НС, 13).Text);
				Стр.СтоимостьРуб = СокрЛП(Excel.Cells(НС, 14).Text);
				
				Стр.Стоимость18 = СокрЛП(Excel.Cells(НС, 15).Text);
				Стр.Стоимость10 = СокрЛП(Excel.Cells(НС, 16).Text);
				Стр.Стоимость0 = СокрЛП(Excel.Cells(НС, 17).Text);
								
				Стр.СуммаНДС18 = СокрЛП(Excel.Cells(НС, 18).Text);
				Стр.СуммаНДС10 = СокрЛП(Excel.Cells(НС, 19).Text);
				
				Стр.СтоимостьНеОблагаемая = СокрЛП(Excel.Cells(НС, 20).Text);
				//Стр.ДопЛист = ДопЛист;
			КонецЕсли;
			
		КонецЦикла;
		
		
	//КонецЦикла;
иначе 
	Сообщить("Не заполнен тип файла загрузки");
КонецЕсли;
Excel.ActiveWorkbook.Close();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкаВидимости();
КонецПроцедуры
