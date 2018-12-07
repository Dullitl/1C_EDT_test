///////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция ПроверитьИдентификатор(Идентификатор) Экспорт
	
	Результат = Истина;
	
	ДопустимыеСимволы = "_абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvxyz1234567890";
	ДопустимыеПервыеСимволы = "_абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvxyz"; 
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Найти(ДопустимыеПервыеСимволы,НРег(Лев(Идентификатор,1)))=0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаИдентификатора = СтрДлина(Идентификатор);
	
	Для Сч = 2 По ДлинаИдентификатора Цикл
		Если Найти(ДопустимыеСимволы,НРег(Сред(Идентификатор,Сч,1)))=0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьЗацикливание() Экспорт
	
	Если ЭтоНовый() Тогда
		// новый объект не может быть зацикленным
		Возврат Ложь;
	КонецЕсли;
	
	МассивИсточников = ВременныеТаблицы.ВыгрузитьКолонку("ВременнаяТаблица");
	
	Пока МассивИсточников.Количество()>0 Цикл
		
		Если МассивИсточников.Найти(Ссылка)<>Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	абс_ФинансовыеПоказателиВременныеТаблицыВременныеТаблицы.ВременнаяТаблица
		                      |ИЗ
		                      |	Справочник.абс_ФинансовыеПоказателиВременныеТаблицы.ВременныеТаблицы КАК абс_ФинансовыеПоказателиВременныеТаблицыВременныеТаблицы
		                      |ГДЕ
		                      |	абс_ФинансовыеПоказателиВременныеТаблицыВременныеТаблицы.Ссылка В(&МассивВТ)");
		Запрос.УстановитьПараметр("МассивВТ", МассивИсточников);
		МассивИсточников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВременнаяТаблица");

	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции



///////////////////////////////////////////////////////////////////////
// Обработчики событий объекта

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьИдентификатор(Код) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Идентификатор не соответствует правилам именования!";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если ПроверитьЗацикливание() Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Обнаружено зацикливание ссылок на временные таблицы! Запись невозможна!";
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры
