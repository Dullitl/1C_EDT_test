
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьЗаполнениеЗаписейРегистра(Отказ);
	
КонецПроцедуры

Функция ПолучитьСоответствиеВидовАналитик()
	          
	СоответствиеВидовАналитик = Новый Соответствие;
	
	СтруктураАналитикОбщий = Новый Структура();
	СтруктураАналитикОбщий.Вставить("Подразделение"				, Ложь);
	СтруктураАналитикОбщий.Вставить("Должность"					, Ложь);
	СтруктураАналитикОбщий.Вставить("Сотрудник"					, Ложь);
		
	СоответствиеВидовАналитик.Вставить(Перечисления.абс_ВидыАналитикиЗначенийПоказателейКПЭ.Общий, СтруктураАналитикОбщий);
	
	СтруктураАналитикПодразделение = Новый Структура();
	СтруктураАналитикПодразделение.Вставить("Подразделение"		, Истина);
	СтруктураАналитикПодразделение.Вставить("Должность"			, Ложь);
	СтруктураАналитикПодразделение.Вставить("Сотрудник"			, Ложь);
		
	СоответствиеВидовАналитик.Вставить(Перечисления.абс_ВидыАналитикиЗначенийПоказателейКПЭ.Подразделение, СтруктураАналитикПодразделение);
	
	СтруктураАналитикШтатнаяЕдиница = Новый Структура();
	СтруктураАналитикШтатнаяЕдиница.Вставить("Подразделение"	, Истина);
	СтруктураАналитикШтатнаяЕдиница.Вставить("Должность"		, Истина);
	СтруктураАналитикШтатнаяЕдиница.Вставить("Сотрудник"		, Ложь);
		
	СоответствиеВидовАналитик.Вставить(Перечисления.абс_ВидыАналитикиЗначенийПоказателейКПЭ.ШтатнаяЕдиница, СтруктураАналитикШтатнаяЕдиница);
	
	СтруктураАналитикСотрудник = Новый Структура();
	СтруктураАналитикСотрудник.Вставить("Подразделение"			, Ложь);
	СтруктураАналитикСотрудник.Вставить("Должность"				, Ложь);
	СтруктураАналитикСотрудник.Вставить("Сотрудник"				, Истина);
		
	СоответствиеВидовАналитик.Вставить(Перечисления.абс_ВидыАналитикиЗначенийПоказателейКПЭ.Сотрудник, СтруктураАналитикСотрудник);	
	
	Возврат СоответствиеВидовАналитик;
	
КонецФункции	

Процедура ПроверитьЗаполнениеЗаписейРегистра(Отказ)
	
	НастройкаВидовАналитик = ПолучитьСоответствиеВидовАналитик();
	
	Для Каждого ТекЗапись Из ЭтотОбъект Цикл
		
		// Проверим заполнение аналитик
		Для Каждого НастройкаЗаполнения Из НастройкаВидовАналитик.Получить(ТекЗапись.ВидАналитикиКПЭ) Цикл
			
			Если НЕ ЗначениеЗаполнено(ТекЗапись[НастройкаЗаполнения.Ключ]) = НастройкаЗаполнения.Значение Тогда
				
				ttk_ОбщегоНазначения.СообщитьОбОшибке("Некорректно заполнены значения аналитик! Документ: " + ТекЗапись.Регистратор + ", номер строки: " + ТекЗапись.НомерСтроки + ".", Отказ);
				
			КонецЕсли;
      
		КонецЦикла;
		
		// Проверим заполнение плановой записи
		Если ТекЗапись.ВидОперации = Перечисления.абс_ВидыОперацийВводаЗначенийПоказателейДляРасчетаКПЭ.ПлановыеЗначения И ЗначениеЗаполнено(ТекЗапись.НомерКорректировки) Тогда
			
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Некорректно заполнена запись ввода плана, номер корректировки не должен быть заполнен! Документ: " + ТекЗапись.Регистратор + ", номер строки: " + ТекЗапись.НомерСтроки + ".", Отказ);
			
		КонецЕсли;
		
		// Проверим заполнение корректировочной записи
		Если ТекЗапись.ВидОперации = Перечисления.абс_ВидыОперацийВводаЗначенийПоказателейДляРасчетаКПЭ.КорректировкаПлановыхЗначений И НЕ ЗначениеЗаполнено(ТекЗапись.НомерКорректировки) Тогда
			
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Некорректно заполнена запись корректировки плана, должен быть заполнен номер корректировки! Документ: " + ТекЗапись.Регистратор + ", номер строки: " + ТекЗапись.НомерСтроки + ".", Отказ);
			
		КонецЕсли;		
		
	КонецЦикла;
	
КонецПроцедуры

