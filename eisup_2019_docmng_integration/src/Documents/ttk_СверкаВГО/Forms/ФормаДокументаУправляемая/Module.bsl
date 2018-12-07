# Область СобытияФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
	мСтатус = Объект.Статус;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьДоступностьЭлементов();
	УстановитьПараметрыНаСервере();
	мСтатус = Объект.Статус;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	РаботаСДиалогами.ОбработчикНастройкаПериодаНажатие(Объект.ДатаНач, Объект.ДатаКон);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Документы.ttk_СверкаВГО.ПолучитьДоступныеСтатусы(мСтатус);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласованияПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыгрузкиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеВыгрузки(Команда)
	ПолучитьДанныеВыгрузкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	РезультатВыбора = РаботаСФайлами.ВыбратьКаталог(Объект.ПутьКФайлуВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	ПутьКФайлуВыгрузки = Объект.ПутьКФайлуВыгрузки;
	Если ЗначениеЗаполнено(СокрЛП(ПутьКФайлуВыгрузки)) Тогда
		Если РаботаСФайлами.ПроверитьСуществованиеКаталога(ПутьКФайлуВыгрузки) Тогда
			ИмяФайла = "Сальдо и обороты по организации: " + Объект.Организация + " за период: " + Формат(Объект.ДатаНач,"ДЛФ=DD") + " - " + Формат(Объект.ДатаКон,"ДЛФ=DD");
			Состояние("Сохраняется файл: " + ИмяФайла);
			ПутьКФайлу = РаботаСФайлами.ПолучитьИмяФайла(ПутьКФайлуВыгрузки, РаботаСФайлами.УдалитьЗапрещенныеСимволыИмени(ИмяФайла)) + ".txt";
			КаталогНаДиске = Новый Файл(ПутьКФайлу);
			Если КаталогНаДиске.Существует() Тогда
				Если Вопрос("Файл с именем: " + """" + ИмяФайла + """" + " уже существует. 
					|Перезаписать его?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Нет, "Внимание..."
					, КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Нет Тогда
					Сообщить("Выгрузка отменена.");
					Возврат;
				КонецЕсли;
			КонецЕсли;
			ДанныеВыгрузки = Объект.ДанныеВыгрузки;
			ТекстовыйДокИзФайла = Новый ТекстовыйДокумент;                    
			Для каждого Стр из ДанныеВыгрузки Цикл       
				
				абс_КодРЖД = Стр.Организация.абс_КодРЖД;
				//Сторчевой А.Н. 30.01.2017 7770982 {                                   
				//КодКонрагентаВГО = Стр.КонтрагентВГО.Код;
				КодКонрагентаВГО = Стр.КонтрагентВГО.КодАСВГО;
				// } Сторчевой А.Н. 30.01.2017 7770982
				КодСтатьиВГО = Стр.СтатьяЗатратВГО.Код;
				Сумма = СтрЗаменить(Строка(Формат(Стр.Сумма, "ЧЦ=17; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧО=3")),Символы.НПП,"") + ?(Стр.Сумма >=0, " ", "");
				СуммаНДС = СтрЗаменить(Строка(Формат(0, "ЧЦ=17; ЧДЦ=2; ЧРД=.; ЧН=0.00")),Символы.НПП,"");
				
				Строка = "" + абс_КодРЖД + СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 10 - СтрДлина(абс_КодРЖД)) + "|" 
							+ КодКонрагентаВГО  + СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 10 - СтрДлина(КодКонрагентаВГО)) + "|" 
							+ КодСтатьиВГО + СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 10 - СтрДлина(КодСтатьиВГО)) + "|"
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 64) + "|00000000|" 
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 35) + "|00000000|" 
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 17 - СтрДлина(Сумма)) + Сумма + "|"
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 50) + "|RUB|"
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 5) + "|"
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 50) + "|"
							+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", 17 - СтрДлина(СуммаНДС)) + СуммаНДС;
				ТекстовыйДокИзФайла.ДобавитьСтроку(Строка);
			КонецЦикла;
			ТекстовыйДокИзФайла.Записать(ПутьКФайлу);
			Сообщить("Выгружен файл: " + """" + ИмяФайла + """" + " в каталог: " + ПутьКФайлуВыгрузки);
		КонецЕсли;
	Иначе 	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен путь к файлу выгрузки на закладке ""Дополнительно"".'"), ,"Объект.ПутьКФайлуВыгрузки"); 
	КонецЕсли;
КонецПроцедуры

# КонецОбласти

# Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыНаСервере()
	ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("Дт", ТекущаяДата());
	ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("СсылкаНаДокумент", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()

	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Объект.Организация);
	Отбор.Вставить("ДатаНач", Объект.ДатаНач);
	Отбор.Вставить("ДатаКон", КонецДня(Объект.ДатаКон));
	Отбор.Вставить("ПериметрВыверки", Объект.ПериметрВыверки);

	ОсновнаяТЧ = Объект.Основная;
	ОсновнаяТЧ.Очистить();
	ТЗ = ОсновнаяТЧ.Выгрузить();
	
	ТЗ  = Документы.ttk_СверкаВГО.ПолучитьОстаткиИОборотыПоСчетам(Отбор, ТЗ);
	
	ОсновнаяТЧ.Загрузить(ТЗ);
	Объект.ДанныеВыгрузки.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеВыгрузкиНаСервере()
	
	ОсновнаяТЧ = Объект.Основная;
	ТЗ = ОсновнаяТЧ.Выгрузить();
	ТЗ.Свернуть("Организация, КонтрагентВГО, СтатьяЗатратВГО" ,"Сумма, СуммаПоОСВ");
	
	ДанныеВыгрузкиТЧ = Объект.ДанныеВыгрузки;
	ЗаполнитьТЧПоТЗ(ДанныеВыгрузкиТЧ, ТЗ);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЧПоТЗ(ТЧ, ТЗ)
	
	ТЧ.Очистить();
	ТЧ.Загрузить(ТЗ);
	
КонецПроцедуры

# КонецОбласти