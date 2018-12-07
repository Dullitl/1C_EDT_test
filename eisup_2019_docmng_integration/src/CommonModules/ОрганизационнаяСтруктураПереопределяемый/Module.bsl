////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

Процедура ДополнитьСоставТиповПодразделения(МассивТиповПодразделений) Экспорт
	
	МассивТиповПодразделений.Добавить(Тип("СправочникСсылка.Подразделения"));
	
КонецПроцедуры

Процедура ДополнитьСоставТиповДолжности(МассивТиповДолжностей) Экспорт
	
	МассивТиповДолжностей.Добавить(Тип("СправочникСсылка.Должности"));
	
КонецПроцедуры

Функция ПолучитьНаименованиеКорневогоЭлементаДерева(Элементы) Экспорт
		
	РежимФормированияОтчета = Элементы.Найти("РежимФормированияОтчета");
	
	Если РежимФормированияОтчета = Неопределено ИЛИ РежимФормированияОтчета.Значение = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		ЭлементОрганизация = Элементы.Найти("Организация");
		ЗначениеПараметра 	= ?(ЭлементОрганизация <> Неопределено, ЭлементОрганизация.Значение, Справочники.Организации.ПустаяСсылка());
	Иначе
		ЗначениеПараметра 	= "Подразделения";
	КонецЕсли;	

	Возврат ЗначениеПараметра;
	
КонецФункции

Процедура ЗаполнитьСписокДоступныхНастроек(СписокНастроек) Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.СтруктраЮридическихЛиц);
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.СтруктраЦентровОтветственности);
	Иначе		
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОрганизационнаяСтруктура);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗадатьТипПоляПодразделенияВСКД(ОтчетОбъект) Экспорт
	
	ПараметрРежимФормированияОтчета = ТиповыеОтчеты.ПолучитьПараметр(ОтчетОбъект.КомпоновщикНастроек, "РежимФормированияОтчета");
	МассивТипов = Новый Массив;
	Если ПараметрРежимФормированияОтчета <> Неопределено Тогда
		Если ПараметрРежимФормированияОтчета.Значение = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
			МассивТипов.Добавить(Тип("СправочникСсылка.ПодразделенияОрганизаций"));
		Иначе
			МассивТипов.Добавить(Тип("СправочникСсылка.Подразделения"));
		КонецЕсли;
	КонецЕсли;
		
	ПолеПодразделение = ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.Данные.Поля.Найти("Подразделение");
	Если ПолеПодразделение <> Неопределено и МассивТипов.Количество() > 0 тогда
		ПолеПодразделение.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
	
	ОтчетОбъект.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтчетОбъект.СхемаКомпоновкиДанных));
	
КонецПроцедуры
