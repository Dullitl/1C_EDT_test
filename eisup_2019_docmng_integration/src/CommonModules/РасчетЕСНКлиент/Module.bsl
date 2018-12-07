
Процедура РассчитатьЕСН(Кнопка, ДокументОбъект, ФормаДокумента, МассивТаблиц) Экспорт
	
	ТекстВопроса1 = "Для автоматического расчета ЕСН необходимо отменить проведение документа. Продолжить?";
	ТекстВопроса2 = "Текущие данные расчета ЕСН будут удалены. Продолжить?";
	Если НЕ РаботаСДиалогами.ЗаписатьДокументОчиститьТаблицыПередВыполнениемДействия(ДокументОбъект, ФормаДокумента, МассивТаблиц, ТекстВопроса1, ТекстВопроса2) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТабличнаяЧасть Из МассивТаблиц Цикл
		ТабличнаяЧасть.Очистить();
	КонецЦикла;
	
	ФормаДокумента.Обновить();
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	ДокументОбъект.ЗаполнитьИРассчитать(Ложь, Истина);
	
	ОбработкаКомментариев.ПоказатьСообщения();

КонецПроцедуры

Процедура ЗаполнитьИРассчитать(Кнопка, ДокументОбъект, ФормаДокумента, МассивТаблиц) Экспорт
	
	ТекстВопроса1 = "Автоматически заполнить документ можно только после отмены его проведения. Продолжить?";
	ТекстВопроса2 = "Текущие данные документа будут удалены. Продолжить?";
	Если НЕ РаботаСДиалогами.ЗаписатьДокументОчиститьТаблицыПередВыполнениемДействия(ДокументОбъект, ФормаДокумента, МассивТаблиц, ТекстВопроса1, ТекстВопроса2) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТабличнаяЧасть Из МассивТаблиц Цикл
		ТабличнаяЧасть.Очистить();
	КонецЦикла;
	
	ФормаДокумента.Обновить();
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();

	ДокументОбъект.ЗаполнитьИРассчитать();
	
	Если ОбработкаКомментариев.Сообщения.Строки.Количество() = 0 Тогда
		// проверим заполнение табличных частей документа
		ЕстьДанные = Ложь;
		Для каждого ТабличнаяЧасть Из МассивТаблиц Цикл
			ЕстьДанные = ЕстьДанные или ТабличнаяЧасть.Количество() > 0;
		КонецЦикла;
		Если Не ЕстьДанные Тогда
			ОбщегоНазначения.ВывестиИнформациюОбОшибке("Не обнаружены данные для записи в документ.", , , Перечисления.ВидыСообщений.Информация);
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();

КонецПроцедуры

Процедура РассчитатьСкидку(Кнопка, ДокументОбъект, ФормаДокумента) Экспорт
	
	ТекстВопроса1 = "Автоматически рассчитать скидки можно только после отмены проведения документа. Выполнить отмену проведения документа?";
	ТекстВопроса2 = "Для перерасчета скидок документ необходимо записать. Записать?";
	Если НЕ РаботаСДиалогами.ЗаписатьДокументОтменивПроведениеПередВыполнениемДействия(ДокументОбъект, ФормаДокумента, , ТекстВопроса1, ТекстВопроса2) Тогда
		Возврат;
	КонецЕсли;

	ДокументОбъект.ЗаполнитьИРассчитать(Истина, Ложь);

КонецПроцедуры

