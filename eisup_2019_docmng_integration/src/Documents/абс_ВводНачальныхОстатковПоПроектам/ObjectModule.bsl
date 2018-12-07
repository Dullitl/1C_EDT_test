Перем мУдалятьДвижения;

// Процедура проверяет корректность заполнения реквизитов шапки документа
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтруктураРеквизитовШапки = Новый Структура;
	СтруктураРеквизитовШапки.Вставить("Организация");
	СтруктураРеквизитовШапки.Вставить("ВидЗаполнения");
					
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураРеквизитовШапки, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет корректность заполнения реквизитов таб. части документа
//
Процедура ПроверитьЗаполнениеТабЧасти(РежимПроведения, ИмяТЧ, ТабТЧ, СтруктураШапкиДокумента, Отказ, Заголовок);

	ОбязательныеРеквизиты = "Проект";

	// Обязательные реквизиты...
	Если ИмяТЧ = "ОборотыБюджетов" Тогда
		
		ОбязательныеРеквизиты = ОбязательныеРеквизиты 
		                      + ", абс_ТипРасхода,
		                        |абс_КВ,
		                        |ЦФО,
								|абс_ЦФУ,
								|СтатьяОборотов,
								|Валюта,
								|СуммаУпр,
								|СуммаСценария,
								|ВалютнаяСумма,
		                        |";
	Иначе
		
		 ОбязательныеРеквизиты = ОбязательныеРеквизиты 
		                      + ", ФактОперФакт,
								|ПриходРасход,
								|ОплатаАванс,
								|Сумма,
								|СуммаРегл,
		                        |";
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ВидЗаполнения = "ПоДокументам" Тогда
		
		ОбязательныеРеквизиты = ОбязательныеРеквизиты 
		                      + ", ДокументРегистратор,
		                        |Документ
								|";
							  
	КонецЕсли;
																														
	// Проверка заполнения обязательных реквизитов.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТЧ, Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);
	
	Если Отказ Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Документ не может быть проведен!");
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТабЧасти()

//**************************************************
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Проверим правильность заполнения документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеТЧ_Регистру = НОвый Соответствие;
	СоответствиеТЧ_Регистру.Вставить("ОборотыБюджетов", "ОборотыБюджетов");
	СоответствиеТЧ_Регистру.Вставить("абс_ДДСПоПроектам", "ПлатежиПоПроектам");
	
	Для каждого ЭлементСоответствия Из СоответствиеТЧ_Регистру Цикл
		
		ТаблицаТЧ = ЭтотОбъект[ЭлементСоответствия.Значение].Выгрузить();
		ТаблицаТЧ.Колонки.Удалить("НомерСтроки");
		
		ПроверитьЗаполнениеТабЧасти(РежимПроведения, ЭлементСоответствия.Значение, ТаблицаТЧ, СтруктураШапкиДокумента, Отказ, Заголовок);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ЕСли ВидЗаполнения = "Сводно" Тогда
						
			ПодготовитьДвижения(ЭлементСоответствия, ТаблицаТЧ);
			
		ИначеЕСли ВидЗаполнения = "ПоДокументам" Тогда
			
			ПодготовитьДвиженияПоДокументам(ЭлементСоответствия, ТаблицаТЧ);
			
		КонецЕСли;
		
	КонецЦикла;
	
КонецПроцедуры

//-------------------------------------------------
//
Процедура ПодготовитьДвижения(ДанныеСоответствия, ТаблицаДанных, ДокРегистратор = Неопределено)
	
	Если ТаблицаДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаИзмерений = "";
	СтрокаРесурсов  = "";
	Для каждого Измерение Из Метаданные.РегистрыНакопления[ДанныеСоответствия.Ключ].Измерения Цикл
		Если ТаблицаДанных.Колонки.Найти(Измерение.Имя) <> Неопределено Тогда
			СтрокаИзмерений = ?(ПустаяСтрока(СтрокаИзмерений), "", СтрокаИзмерений + ",") + Измерение.Имя;
		КонецЕСли;
	КонецЦикла;
	Для каждого Ресурс Из Метаданные.РегистрыНакопления[ДанныеСоответствия.Ключ].Ресурсы Цикл
		Если ТаблицаДанных.Колонки.Найти(Ресурс.Имя) <> Неопределено Тогда
			СтрокаРесурсов = ?(ПустаяСтрока(СтрокаРесурсов), "", СтрокаРесурсов + ",") + Ресурс.Имя;
		КонецЕСли;
	КонецЦикла;
	
	ТаблицаДанных.Свернуть(СтрокаИзмерений, СтрокаРесурсов);
	
	ДвиженияДляДокумента(ДанныеСоответствия.Ключ, ТаблицаДанных, ДокРегистратор);
	
КонецПроцедуры

//----------------------------------------------------
//
Процедура ПодготовитьДвиженияПоДокументам(ДанныеСоответствия, ТаблицаДанных)
	
	Если ТаблицаДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕСли;
	
	ТекстЗапросаПолей = "";
	Для каждого КолонкаТЧ Из ТаблицаДанных.Колонки Цикл
		ТекстЗапросаПолей = ?(ПустаяСтрока(ТекстЗапросаПолей), "", ТекстЗапросаПолей + ", "+Символы.ПС) + "ИсточникДанных."+КолонкаТЧ.Имя;
	КонецЦикла;	
	ТекстЗапросаИсточникДанных = Символы.ПС + Символы.ПС + "ИЗ" + Символы.ПС + " Документ." + Метаданные().Имя + "." + ДанныеСоответствия.Значение + " КАК ИсточникДанных";
	ТекстЗапросаУсловие = Символы.ПС + Символы.ПС + "ГДЕ" + Символы.ПС + " ИсточникДанных.Ссылка = &ТекущийДокумент"; 
	ТекстЗапросаИтоги = Символы.ПС + Символы.ПС + "ИТОГИ ПО ДокументРегистратор";
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ "+ТекстЗапросаПолей+ТекстЗапросаИсточникДанных+ТекстЗапросаУсловие+ТекстЗапросаИтоги;
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	
	ДеревоДанныхДокументов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
	Для каждого СтрокаДереваДанныхДокументов Из ДеревоДанныхДокументов.Строки Цикл
		
		ТаблицаДанных.Очистить();
		
		Для Каждого СтрокаДетальныхДанныхДокумента Из СтрокаДереваДанныхДокументов.Строки Цикл
			
			СтрокаТаблицы = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаДетальныхДанныхДокумента);
					
		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(СтрокаДереваДанныхДокументов.ДокументРегистратор) ИЛИ СтрокаДереваДанныхДокументов.ДокументРегистратор = Неопределено Тогда					
			ПодготовитьДвижения(ДанныеСоответствия, ТаблицаДанных);
		Иначе
			ПодготовитьДвижения(ДанныеСоответствия, ТаблицаДанных, СтрокаДереваДанныхДокументов.ДокументРегистратор);
		КонецЕСли;
		
	КонецЦикла;
	
КонецПроцедуры

//----------------------------------------------------
//
Процедура ДвиженияДляДокумента(ИмяРегистра, ТаблицаИсточникДанных, ДокументРегистратор = Неопределено)
	
	ЕСли ДокументРегистратор = Неопределено Тогда
		ДвиженияДокумента = Движения[ИмяРегистра];
		ДвиженияДокумента.Записывать = Истина;
		ДвиженияДокумента.Очистить();
		ДвиженияДокумента.Записать();
	Иначе
		//Движения[ИмяРегистра].Очистить();
		//Движения[ИмяРегистра].Записать();
		
		ДвиженияДокумента = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
		ДвиженияДокумента.Отбор.Регистратор.Установить(ДокументРегистратор);
		ДвиженияДокумента.Прочитать();
	КонецЕСли;
	
	Для каждого СтрокаТаблицы Из ТаблицаИсточникДанных Цикл
		Движение = ДвиженияДокумента.Добавить();
		Если Не ДокументРегистратор = Неопределено Тогда
			Движение.Регистратор = ДокументРегистратор;
			Движение.Период = ДокументРегистратор.Дата;	
		Иначе
			Движение.Период = Дата;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Движение, Ссылка);
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТаблицы);
	КонецЦикла;
	
	Если Не ДокументРегистратор = Неопределено Тогда
		ДвиженияДокумента.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры
