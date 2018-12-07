
&НаСервереБезКонтекста
Функция ПроверитьНаличиеОсновногоДоговора(Договор)
	
	Если ЗначениеЗаполнено(Договор.абс_ОсновнойДоговор) Тогда
		Возврат Договор.абс_ОсновнойДоговор;
	КонецЕсли;
	
	Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЗаголовокГруппыЛимитов()
	
	Элементы.ГруппаЛимит.Заголовок =
		?(ЗначениеЗаполнено(Объект.ДоговорКонтрагента),
			"Лимит (в валюте договора), " + НРег(ПолучитьВалютуДоговора(Объект.ДоговорКонтрагента, 1)),
			"Лимит (в валюте договора)");
	Если Не ЗначениеЗаполнено(Объект.Валюта) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Объект.Валюта = ПолучитьВалютуДоговора(Объект.ДоговорКонтрагента, 2);
	КонецЕсли;
			
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуДоговора(Договор, Тип)
	
	Если Тип = 1 Тогда
		Возврат Строка(Договор.ВалютаВзаиморасчетов);
	Иначе 
		Возврат Договор.ВалютаВзаиморасчетов;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыНаСервере()
	
	ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("Дт", ТекущаяДата());
	ИсторияСогласования.Параметры.УстановитьЗначениеПараметра("РаспоряжениеНаЗакупку", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимость()
	
	//Элементы.Проект.ТолькоПросмотр = Истина;	
	//
	//УстановитьТолькоПросмотрВсемЭлементам(Ложь);
	//Если не мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.Подготовка") Тогда
	//	
	//	УстановитьТолькоПросмотрВсемЭлементам();
	//	
	//	Если мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.СогласованиеДЭИ") Тогда
	//		Элементы.ДоходыПроектов.ТолькоПросмотр  = Ложь;
	//		Элементы.РасходыПроектов.ТолькоПросмотр = Ложь;
	//		
	//	ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.СогласованиеДТР") Тогда	
	//		
	//		Элементы.ДоходыПроектов.ТолькоПросмотр 	= Ложь;
	//		
	//		
	//	ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.РазработкаТЭО") Тогда
	//		
	//		Элементы.ТЭО.ТолькоПросмотр            	= Ложь;
	//		
	//	ИначеЕсли мСтатус = ПредопределенноеЗначение("Перечисление.абс_СтатусыПроектов.Согласован") Тогда
	//		
	//		
	//		
	//	КонецЕсли;		
	//Иначе			
	//	
	//	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.абс_ВидыОперацийЗаявкаНаПроект.АктуализацияДанныхПроекта") Тогда
	//		Элементы.Проект.ТолькоПросмотр = Ложь;
	//	КонецЕсли;		
	//	
	//КонецЕсли;		
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСтатусыДокументаНаСервере()

	Документы.ttk_РаспоряжениеНаЗакупку.ЗаполнитьСписокДоступныхСтатусов(Элементы.мСтатус.СписокВыбора, Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура СуммаБезНДСПриИзменении(Элемент)
	
	Объект.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Объект.СуммаБезНДС, Истина, Ложь, УчетНДС.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	Объект.Сумма = Объект.СуммаБезНДС + Объект.СуммаНДС;
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	Объект.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Объект.СуммаБезНДС, Истина, Ложь, УчетНДС.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	Объект.Сумма = Объект.СуммаБезНДС + Объект.СуммаНДС;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСтатусыДокументаНаСервере();
	мСтатус = Объект.Статус;
	ОбновитьВидимость();

	СканКопияРаспоряжения = Документы.ttk_РаспоряжениеНаЗакупку.ПолучитьСсылкуНаСканКопиюРаспоряженияИзХранилища(Объект.Ссылка);
	НаименованиеФайла = СканКопияРаспоряжения.ИмяФайла;
	ОбновитьЗаголовокГруппыЛимитов();
	
	ДоговорКонтрагентаПриИзменении(Элементы.ДоговорКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = (Параметры.Ключ.Пустая() И Параметры.ЗначениеКопирования.Пустая());	
	УстановитьПараметрыНаСервере();	
	вСтатус = Объект.Статус;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура мСтатусПриИзменении(Элемент)
	
	ЗаполнитьСтатусыДокументаНаСервере();
	Объект.Статус = мСтатус;	
	ОбновитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьВидимость();
	УстановитьПараметрыНаСервере();
	Элементы.ИсторияСогласования.Обновить();
	ЗаполнитьСтатусыДокументаНаСервере();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если вСтатус <> Объект.Статус Тогда
		ПричинаИзмененияСтатуса = "";
		Если ВвестиСтроку(ПричинаИзмененияСтатуса, "Укажите причину изменения статуса.", , Истина) Тогда
			Объект.ПричинаИзмененияСтатуса = ПричинаИзмененияСтатуса;
		Иначе 
			мСтатус = вСтатус;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СканКопияРаспоряженияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	Если Не ЗначениеЗаполнено(СканКопияРаспоряжения) Тогда
		Возврат;
	КонецЕсли;
	
	ОткликФормы = Обработки.МенеджерКонтактов.ПолучитьФорму("ФормаОткрытияВложений").ОткрытьМодально();
	
	Если ОткликФормы = Неопределено ИЛИ ТипЗнч(ОткликФормы) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОткликФормы Тогда		
		Файл = абс_РаботаСФайлами.ПолучитьФайлИзВнешнегоХранилища(СканКопияРаспоряжения);		
		ПолныйПутьКФайлу = ПолучитьИмяВременногоФайла(РаботаСфайлами.ПолучитьРасширениеФайла(СканКопияРаспоряжения.Наименование));		
		Файл.Записать(ПолныйПутьКфайлу);		
		ЗапуститьПриложение("" + ПолныйПутьКфайлу);		
	Иначе		
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораФайла.Заголовок               = "Обзор...";		
		Если ДиалогВыбораФайла.Выбрать() Тогда			
			КаталогСохранения = ДиалогВыбораФайла.Каталог;			
			Файл = абс_РаботаСФайлами.ПолучитьФайлИзВнешнегоХранилища(СканКопияРаспоряжения);			
			Файл.Записать(КаталогСохранения + "\" + СканКопияРаспоряжения.Наименование);			
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СканКопияРаспоряженияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда		
		Возврат;
	КонецЕсли;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр                  = "Все файлы (*.*)|*.*";
	ДиалогВыбораФайла.Заголовок               = "Обзор...";
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Если НЕ Документы.ttk_РаспоряжениеНаЗакупку.ПроверитьРасширениеФайла(ДиалогВыбораФайла.ПолноеИмяФайла) Тогда
			Возврат;
		КонецЕсли;		
		Наименование = СтрЗаменить(ДиалогВыбораФайла.ПолноеИмяФайла, ДиалогВыбораФайла.Каталог, "");
		ВнешнийФайл = Новый ДвоичныеДанные(ДиалогВыбораФайла.ПолноеИмяФайла);		
		РезультатЗаписи = абс_РаботаСФайлами.ЗаписатьФайлВоВнешнееХранилище(Объект.Ссылка, ВнешнийФайл, Наименование, , );
		
		Если РезультатЗаписи.Успешно Тогда
			НаименованиеФайла = Наименование;
			СканКопияРаспоряжения = РезультатЗаписи.ХранилищеСсылка;
			
			Если ТипЗнч(СканКопияРаспоряжения) = Тип("СправочникСсылка.ХранилищеДополнительнойИнформации") Тогда
				обХранилище = СканКопияРаспоряжения.ПолучитьОбъект();
				обХранилище.абс_ТипДокумента = Справочники.абс_ТипыДокументов.РаспоряжениеНаЗакупку;
				обХранилище.Записать();
			КонецЕсли;
		
			НайденныйФайлПоДоговору = Документы.ttk_РаспоряжениеНаЗакупку.ПолучитьСсылкуНаСканКопиюРаспоряженияИзХранилища(Объект.ДоговорКонтрагента, Наименование);
			Если НайденныйФайлПоДоговору = Справочники.ХранилищеДополнительнойИнформации.ПустаяСсылка() Тогда
				ТекущийФайлПоДоговору = Справочники.ХранилищеДополнительнойИнформации.СоздатьЭлемент();
				ТекущийФайлПоДоговору.ВидДанных = Перечисления.ВидыДополнительнойИнформацииОбъектов.Файл;
				ТекущийФайлПоДоговору.ИмяФайла = СканКопияРаспоряжения.ИмяФайла; //ДиалогВыбораФайла.ПолноеИмяФайла;
				ТекущийФайлПоДоговору.Наименование = СканКопияРаспоряжения.Наименование;
				ТекущийФайлПоДоговору.абс_ТипДокумента = Справочники.абс_ТипыДокументов.РаспоряжениеНаЗакупку;
				ТекущийФайлПоДоговору.Объект = Объект.ДоговорКонтрагента;
				ТекущийФайлПоДоговору.абс_ДатаПрикрепленияФайла = СканКопияРаспоряжения.абс_ДатаПрикрепленияФайла;
			Иначе
				ТекущийФайлПоДоговору = НайденныйФайлПоДоговору.ПолучитьОбъект();
			КонецЕсли;
			ТекущийФайлПоДоговору.Записать();			
			
			Если Объект.МетодКонтроля = 2 И ЗначениеЗаполнено(ОсновнойДоговор) Тогда
				НайденныйФайлПоОсновномуДоговору = Документы.ttk_РаспоряжениеНаЗакупку.ПолучитьСсылкуНаСканКопиюРаспоряженияИзХранилища(ОсновнойДоговор, Наименование);
				Если НайденныйФайлПоОсновномуДоговору = Справочники.ХранилищеДополнительнойИнформации.ПустаяСсылка() Тогда
					ТекущийФайлПоОсновномуДоговору = Справочники.ХранилищеДополнительнойИнформации.СоздатьЭлемент();
					ТекущийФайлПоОсновномуДоговору.ВидДанных = Перечисления.ВидыДополнительнойИнформацииОбъектов.Файл;
					ТекущийФайлПоОсновномуДоговору.ИмяФайла = СканКопияРаспоряжения.ИмяФайла;
					ТекущийФайлПоОсновномуДоговору.Наименование = СканКопияРаспоряжения.Наименование;
					ТекущийФайлПоОсновномуДоговору.абс_ТипДокумента = Справочники.абс_ТипыДокументов.РаспоряжениеНаЗакупку;
					ТекущийФайлПоОсновномуДоговору.Объект = ОсновнойДоговор;
					ТекущийФайлПоОсновномуДоговору.абс_ДатаПрикрепленияФайла = СканКопияРаспоряжения.абс_ДатаПрикрепленияФайла;
				Иначе
					ТекущийФайлПоОсновномуДоговору = НайденныйФайлПоОсновномуДоговору.ПолучитьОбъект();
				КонецЕсли;
				ТекущийФайлПоОсновномуДоговору.Записать();			
			КонецЕсли;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	Объект.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Объект.Сумма, Истина, Истина, УчетНДС.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	Объект.СуммаБезНДС = Объект.Сумма - Объект.СуммаНДС;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	ОбновитьЗаголовокГруппыЛимитов();
	
	ОсновнойДоговор = ПроверитьНаличиеОсновногоДоговора(Объект.ДоговорКонтрагента);
	Если Не ЗначениеЗаполнено(ОсновнойДоговор) Тогда
		Элементы.МетодКонтроля.Доступность = Ложь;
		Объект.МетодКонтроля = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ОсновнойДоговор", ОсновнойДоговор);
	
КонецПроцедуры