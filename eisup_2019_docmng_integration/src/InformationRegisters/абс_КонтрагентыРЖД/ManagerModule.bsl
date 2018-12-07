
////////////////////////////////////////////////////////////////////////////////
// ПОЛУЧЕНИЕ ДАННЫХ


Функция ПолучитьКонтрагентаПоКодуРЖД(КодРЖД) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_КонтрагентыРЖДСрезПоследних.Контрагент КАК Контрагент
	                      |ИЗ
	                      |	РегистрСведений.абс_КонтрагентыРЖД.СрезПоследних(, КодРЖД = &КодРЖД) КАК абс_КонтрагентыРЖДСрезПоследних");
						  
	Запрос.УстановитьПараметр("КодРЖД", КодРЖД);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Выборка.Следующий();	
	Возврат Выборка.Контрагент;
	
КонецФункции

Функция ПолучитьКодРЖДПоКонтрагенту(Контрагент) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_КонтрагентыРЖДСрезПоследних.Контрагент КАК КодРЖД
	                      |ИЗ
	                      |	РегистрСведений.абс_КонтрагентыРЖД.СрезПоследних(, Контрагент = &Контрагент) КАК абс_КонтрагентыРЖДСрезПоследних");
						  
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат "";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Выборка.Следующий();	
	Возврат Выборка.КодРЖД;
	
КонецФункции

Функция ПолучитьСтруктуруЗаписи(КодРЖД) Экспорт
	
	СтруктуаЗаписи = Новый Структура("Период, Контрагент, КодРЖД");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_КонтрагентыРЖДСрезПоследних.Контрагент КАК Контрагент,
	                      |	абс_КонтрагентыРЖДСрезПоследних.КодРЖД,
	                      |	абс_КонтрагентыРЖДСрезПоследних.Период
	                      |ИЗ
	                      |	РегистрСведений.абс_КонтрагентыРЖД.СрезПоследних(, КодРЖД = &КодРЖД) КАК абс_КонтрагентыРЖДСрезПоследних");
						  
	Запрос.УстановитьПараметр("КодРЖД", КодРЖД);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(СтруктуаЗаписи, Выборка);
	Возврат СтруктуаЗаписи;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ЗАПИСЬ ДАННЫХ


Функция ЗаписатьКодРЖД(КодРЖД, СтруктураЗаписи = Неопределено, ПериодЗаписи = Неопределено) Экспорт
	
	ОпределитьПериодЗаписи(ПериодЗаписи);
	
	НаборЗаписей = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
	НаборЗаписей.Отбор.КодРЖД.Установить(КодРЖД);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда 
		строкаНабора = НаборЗаписей[0];
	Иначе
		строкаНабора = НаборЗаписей.Добавить();
	КонецЕсли;
	
	строкаНабора.Период = ПериодЗаписи;
	строкаНабора.КодРЖД = КодРЖД;
	
	Если СтруктураЗаписи <> Неопределено Тогда 
		ЗаполнитьЗначенияСвойств(строкаНабора, СтруктураЗаписи);
	КонецЕсли;
		
	НаборЗаписей.Записать();
	
КонецФункции

Процедура ОчиститьКонтрагента(КодРЖД, ПериодЗаписи = Неопределено, Ссылка = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КодРЖД) Тогда 
		Возврат;
	КонецЕсли;
	
	ОпределитьПериодЗаписи(ПериодЗаписи);
	
	НаборЗаписей = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
	НаборЗаписей.Отбор.КонтрагентЕИСУП.Установить(Ссылка);
	//НаборЗаписей.Отбор.КодРЖД.Установить(КодРЖД);
	//НаборЗаписей.Прочитать();
	//
	//Если НаборЗаписей.Количество() > 0 Тогда 
	//	строкаНабора = НаборЗаписей[0];
	//Иначе
	//	Возврат;
	//КонецЕсли;
	//
	//строкаНабора.Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	НаборЗаписей.Записать();
		
КонецПроцедуры

Процедура ЗаписатьСтатусВыгрузкиВSQL(КодРЖД, Период, Статус) Экспорт
	
	НаборЗаписей = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(Период);
	НаборЗаписей.Отбор.КодРЖД.Установить(КодРЖД);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда 
		строкаНабора = НаборЗаписей[0];
	Иначе
		Возврат;
	КонецЕсли;
	
	строкаНабора.ВыгруженВSQL = Статус;
	НаборЗаписей.Записать();
		
КонецПроцедуры

Процедура УдалитьПривязкуКонтрагента(КодРЖД, Период, КонтрагентЕИСУП) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_КонтрагентыРЖДСрезПоследних.Период,
	                      |	абс_КонтрагентыРЖДСрезПоследних.КодРЖД,
	                      |	абс_КонтрагентыРЖДСрезПоследних.КонтрагентЕИСУП,
	                      |	абс_КонтрагентыРЖДСрезПоследних.Контрагент
	                      |ИЗ
	                      |	РегистрСведений.абс_КонтрагентыРЖД.СрезПоследних(, КодРЖД = &КодРЖД) КАК абс_КонтрагентыРЖДСрезПоследних");
						  
	Запрос.УстановитьПараметр("КодРЖД", КодРЖД);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() > 1 Тогда 
		НаборЗаписей = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КодРЖД.Установить(КодРЖД);
		НаборЗаписей.Отбор.КонтрагентЕИСУП.Установить(КонтрагентЕИСУП);
		НаборЗаписей.Записать();
	Иначе
		НаборЗаписей = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КодРЖД.Установить(КодРЖД);
		НаборЗаписей.Отбор.Период.Установить(Период);
        НаборЗаписей.Прочитать();
		Для Каждого строка из НаборЗаписей Цикл
			Если строка.КонтрагентЕИСУП = КонтрагентЕИСУП Тогда 	 
				строка.КонтрагентЕИСУП = Справочники.Контрагенты.ПустаяСсылка();
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей.Записать();	
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С МЕНЕДЖЕРОМ ЗАПИСИ


Функция МенеджерЗаписиПолучитьПоКонтрагенту(Контрагент) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	абс_КонтрагентыРЖДСрезПоследних.КодРЖД КАК КодРЖД,
	                      |	абс_КонтрагентыРЖДСрезПоследних.Период
	                      |ИЗ
	                      |	РегистрСведений.абс_КонтрагентыРЖД.СрезПоследних(, Контрагент = &Контрагент) КАК абс_КонтрагентыРЖДСрезПоследних");
						  
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Результат = Запрос.Выполнить();
	МенеджерЗаписи = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьМенеджерЗаписи();
	
	Если Результат.Пустой() Тогда 
		Возврат МенеджерЗаписи;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Выборка.Следующий();	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);	
	Возврат МенеджерЗаписи;
	
КонецФункции

Функция МенеджерЗаписиПолучитьПоКлючу(КлючЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.абс_КонтрагентыРЖД.СоздатьМенеджерЗаписи();	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, КлючЗаписи);
	МенеджерЗаписи.Прочитать();
	Возврат МенеджерЗаписи;
	
КонецФункции

Процедура МененджерЗаписиЗаписатьКонтрагента(МененджерЗаписи, Контрагент) Экспорт

	Если НЕ ЗначениеЗаполнено(МененджерЗаписи.КодРЖД) ИЛИ НЕ ЗначениеЗаполнено(МененджерЗаписи.Период) Тогда 
		Возврат;
	КонецЕсли;
	
	//МененджерЗаписи.Прочитать();
	МененджерЗаписи.КонтрагентЕИСУП = Контрагент;
	МененджерЗаписи.Записать();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ


Процедура ОпределитьПериодЗаписи(ПериодЗаписи)
	
	Если ПериодЗаписи = Неопределено Тогда 
		ПериодЗаписи = ТекущаяДата();
	КонецЕсли;
		
КонецПроцедуры







