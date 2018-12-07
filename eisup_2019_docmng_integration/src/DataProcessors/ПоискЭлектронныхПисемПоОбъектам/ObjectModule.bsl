
// Процедура устанавливает отбор для списка электронных писем, для заданных объектов
// 
// Параметры:
//  ЭлектронныеПисьмаСписок - ДокументСписок.ЭлектронноеПисьмо, для которого необходимо установить отбор.
// 
Процедура ОбновитьТаблицуПисем(ЭлектронныеПисьмаСписок) Экспорт

	ПостроительОтчета.Выполнить();
	
	МассивЗначений = ПостроительОтчета.Результат.Выгрузить().ВыгрузитьКолонку("Представление");
	
	Для а = 0 по МассивЗначений.Количество() - 1 Цикл
		МассивЗначений[а] = СокрЛП(МассивЗначений[а]);
	КонецЦикла;
	
	Если МассивЗначений.Количество() = 0 ИЛИ МассивЗначений.Количество() = 1 Тогда
		Если ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.Равно
		 ИЛИ ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.ВСписке
		 ИЛИ ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.ВСпискеПоИерархии Тогда
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.ВидСравнения = ВидСравнения.Равно;
		Иначе
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.ВидСравнения = ВидСравнения.НеРавно;
		КонецЕсли; 
		Если МассивЗначений.Количество() = 0 Тогда
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.Значение = "";
		Иначе
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.Значение = МассивЗначений[0];
		КонецЕсли;
	Иначе
		Если ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.Равно
		 ИЛИ ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.ВСписке
		 ИЛИ ПостроительОтчета.Отбор.ОбъектПоиска.ВидСравнения = ВидСравнения.ВСпискеПоИерархии Тогда
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.ВидСравнения = ВидСравнения.ВСписке;
		Иначе
			ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.ВидСравнения = ВидСравнения.НеВСписке;
		КонецЕсли; 
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(МассивЗначений);
		ЭлектронныеПисьмаСписок.Отбор.ЭлектронныеПисьмаПоАдресуЭлектроннойПочты.Значение = СписокЗначений;
	КонецЕсли;
	
	ЭлектронныеПисьмаСписок.Обновить();
	
КонецПроцедуры

// Настроим построитель отчета для поиска адресов эл.почты по объектам.
ПостроительОтчета.Текст = "
|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК Строка(100)) КАК Представление
|ИЗ
|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
|ГДЕ
|	КонтактнаяИнформация.Тип = &Тип
|{ГДЕ
|	КонтактнаяИнформация.Объект КАК ОбъектПоиска}
|";

ПостроительОтчета.Отбор.Добавить("ОбъектПоиска", "ОбъектПоиска", "Объект поиска");
ПостроительОтчета.Отбор.ОбъектПоиска.Использование = Истина;

ПостроительОтчета.Параметры.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
