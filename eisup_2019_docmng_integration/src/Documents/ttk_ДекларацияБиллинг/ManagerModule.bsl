
Процедура ЗаполнитьСписокДоступныхСтатусов(Список, Ссылка) Экспорт	
	
	мРолиПользователя = абс_БизнесПроцессы.ПолучитьСписокДоступныхРолейПользователя(глЗначениеПеременной("глТекущийПользователь"));
	
	Список.Очистить();
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Список.Добавить(Перечисления.абс_СтатусыПервичныхДокументов.Подготовка);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка.Статус) Тогда
		Список.Добавить(Перечисления.абс_СтатусыПервичныхДокументов.Подготовка);
		Возврат;
    Иначе
		Список.Добавить(Ссылка.Статус);
	КонецЕсли;
	
	Если Ссылка.Статус = Перечисления.абс_СтатусыПервичныхДокументов.Подготовка Тогда
		Список.Добавить(Перечисления.абс_СтатусыПервичныхДокументов.Согласован);		
	ИначеЕсли Ссылка.Статус = Перечисления.абс_СтатусыПервичныхДокументов.Согласован Тогда
		Если Не мРолиПользователя.Найти(Справочники.РолиИсполнителей.абс_СогласованиеБухгалтерией) = Неопределено Или
			 Не мРолиПользователя.Найти(Справочники.РолиИсполнителей.СуперПользователь) = Неопределено Тогда			
			Список.Добавить(Перечисления.абс_СтатусыПервичныхДокументов.Отмена);
		КонецЕсли;
	ИначеЕсли Ссылка.Статус = Перечисления.абс_СтатусыПервичныхДокументов.Отмена Тогда
		Список.Добавить(Перечисления.абс_СтатусыПервичныхДокументов.Подготовка);
	КонецЕсли;	
	
	Возврат;
	
КонецПроцедуры
