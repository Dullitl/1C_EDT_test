
Процедура ЗаписатьИсторию(Запись)

	ОС = Запись.ОсновноеСредство;
	ОбъектОС = ОС.ПолучитьОбъект();
	Если ОбъектОС = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	ТЧИстория = ОбъектОС.абс_История;
	ПараметрыОтбора = Новый Структура("Код, Наименование, Организация, Состояние, Регистратор, абс_СтатусОС", 
	ОбъектОС.Код, ОбъектОС.Наименование, Запись.Организация, Запись.Состояние, ЭтотОбъект.Отбор.Регистратор.Значение, ОбъектОС.абс_СтатусОС);
	Если ТЧИстория.Количество() > 0 Тогда 
		НайденныеСтроки = ТЧИстория.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	НоваяСтрокаТЧ = ТЧИстория.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, ПараметрыОтбора);
	НоваяСтрокаТЧ.Период = НоваяСтрокаТЧ.Регистратор.Дата;
	НоваяСтрокаТЧ.ИнвентарныйНомер = ПолучитьИнвентарныйНомер(ОС);
	ОбъектОС.ОбменДанными.Загрузка = Истина;
	ОбъектОС.Записать();
	
КонецПроцедуры

Функция ПолучитьИнвентарныйНомер(ОсновноеСредство)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних";

	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ИнвентарныйНомер;
	
КонецФункции 

Процедура ПриЗаписи(Отказ, Замещение)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Состояние = Перечисления.СостоянияОС.ПринятоКУчету Тогда 
			Продолжить;
		КонецЕсли;	
		ЗаписатьИсторию(Запись);
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЭтотОбъект.Количество() = 0 Тогда 
		Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение; 
		ТипЗнчРегистратора = ТипЗнч(Регистратор);
		Если ТипЗнчРегистратора = Тип("ДокументСсылка.СписаниеОС") Или 
			ТипЗнчРегистратора = Тип("ДокументСсылка.ВводНачальныхОстатковОС") Тогда 
			ОчиститьИсториюВКарточкахОС(Регистратор);
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОчиститьИсториюВКарточкахОС(Регистратор)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОсновныеСредстваабс_История.Ссылка
		|ИЗ
		|	Справочник.ОсновныеСредства.абс_История КАК ОсновныеСредстваабс_История
		|ГДЕ
		|	ОсновныеСредстваабс_История.Регистратор = &Регистратор";

	Запрос.УстановитьПараметр("Регистратор", Регистратор);

	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		
		ОС = Выборка.Ссылка.ПолучитьОбъект();
		ИсторияТЧ = ОС.абс_История;
		ПараметрыОтбора = Новый Структура("Регистратор", Регистратор);
		СтрокиДляУдаления = ИсторияТЧ.НайтиСтроки(ПараметрыОтбора);
		
		Для каждого УдаляемаяСтрока Из СтрокиДляУдаления Цикл
			
			ИсторияТЧ.Удалить(УдаляемаяСтрока);	
			
		КонецЦикла;
		
		ОС.ОбменДанными.Загрузка = Истина;
		ОС.Записать();
		
	КонецЦикла;
	                                     
КонецПроцедуры



