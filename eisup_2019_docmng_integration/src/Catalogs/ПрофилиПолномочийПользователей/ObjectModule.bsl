
////////////////////////////////////////////////////////////////////////////////
// МЕХАНИЗМ ОБНОВЛЕНИЯ ДАННЫХ ПОЛЬЗОВАТЕЛЕЙ ИБ

Функция СоставРолейИзменен(СтарыйСоставРолей)

	Если СтарыйСоставРолей.Количество() <> СоставРолей.Количество() Тогда
		Возврат Истина;
	КонецЕсли;
	
	СоставРолейКопия = СоставРолей.Выгрузить(,"ИмяРоли");
	СоставРолейКопия.Сортировать("ИмяРоли");
	
	СтарыйСоставРолей.Сортировать("ИмяРоли"); // Сортируем здесь, чтобы был одинаковый алгоритм сортировки
	
	ИндексСтроки = 0;
	Для каждого ЭлКоллекции Из СоставРолей Цикл
		Если ЭлКоллекции.ИмяРоли <> СтарыйСоставРолей[ИндексСтроки].ИмяРоли Тогда
			Возврат Истина;
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла; 
	
	Возврат Ложь;

КонецФункции // СоставРолейИзменен

// Функция возвращает структуру содержащую изменения этого профиля
//
Функция ПолучитьСтуктуруИзменений()
	
	СтруктураИзменений = Новый Структура;
	
	Если ЭтоНовый() Тогда
		Возврат СтруктураИзменений;
	КонецЕсли; 
	
	Если СоставРолейИзменен(Ссылка.СоставРолей.Выгрузить()) Тогда
		СтруктураИзменений.Вставить("СоставРолей");		
	КонецЕсли; 
	
	Если Ссылка.ОсновнойИнтерфейс <> ОсновнойИнтерфейс Тогда
		СтруктураИзменений.Вставить("ОсновнойИнтерфейс");
	КонецЕсли;
	
	Возврат СтруктураИзменений;
	
КонецФункции // ПолучитьСтуктуруИзменений

// Процедура обновляет даные пользователей ИБ, имеющих данный профиль
//
Процедура ОбновитьДанныеПользователейИБ(Отказ)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураИзменений = ПолучитьСтуктуруИзменений();
	
	Если СтруктураИзменений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	Если СтруктураИзменений.Свойство("СоставРолей") Тогда
		МассивРолей = СоставРолей.ВыгрузитьКолонку("ИмяРоли");
		СтруктураДанных.Вставить("СоставРолей", МассивРолей);
	КонецЕсли;
	
	Если СтруктураИзменений.Свойство("ОсновнойИнтерфейс") Тогда
		СтруктураДанных.Вставить("ОсновнойИнтерфейс", ОсновнойИнтерфейс);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПрофильПолномочий", Ссылка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Пользователи.Код КАК ИмяПользователя
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ПрофильПолномочийПользователя = &ПрофильПолномочий";
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		УправлениеПользователями.ИзменитьДанныеПользователяИБ(Выборка.ИмяПользователя, СтруктураДанных);
	КонецЦикла;
	
КонецПроцедуры // ОбновитьРолиПользователейИБ


////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ОБЪЕКТА

Процедура ПередЗаписью(Отказ)
	
	ОбновитьДанныеПользователейИБ(Отказ);
	
КонецПроцедуры
