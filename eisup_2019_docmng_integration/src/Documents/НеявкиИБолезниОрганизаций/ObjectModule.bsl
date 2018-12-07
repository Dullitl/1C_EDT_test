////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;

// Механизм исправлений
Перем мВосстанавливатьДвижения;
Перем мСоответствиеДвижений;
Перем мИсправляемыйДокумент;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет документ по перерассчитываемому документу
// ИсходныйДокумент - тип ДокументОбъект.НеявкиИБолезниОрганизаций
//
Процедура ЗаполнитьПоПерерассчитываемомуДокументу(ИсходныйДокумент, Сотрудники = Неопределено) Экспорт
	
	ПроведениеРасчетов.ЗаполнитьИсправлениеПоКадровомуДокументу(ЭтотОбъект, ИсходныйДокумент.Ссылка, Сотрудники);
	
КонецПроцедуры // ЗаполнитьПоПерерассчитываемомуДокументу()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация",	Справочники.Организации.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Дата,
	|	Док.Организация,
	|	ВЫБОР
	|		КОГДА Док.Организация.ГоловнаяОрганизация = &ПустаяОрганизация
	|			ТОГДА Док.Организация
	|		ИНАЧЕ Док.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	Док.Ссылка
	|ИЗ
	|	Документ.НеявкиИБолезниОрганизаций КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим	- режим проведения
//
// Возвращаемое значение:
//	Результат запроса. В запросе данные документа дополняются значениями
//	проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.НомерСтроки КАК НомерСтроки,
	|	Док.ДатаНачала КАК ДатаНачала,
	|	Док.Сотрудник КАК Сотрудник,
	|	Док.ОсвобождатьСтавку КАК ОсвобождатьСтавку,
	|	Док.ПричинаОтсутствия КАК ПричинаОтсутствия,
	|	Док.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТСтрокиДокумента
	|ИЗ
	|	Документ.НеявкиИБолезниОрганизаций.РаботникиОрганизации КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|	И (НЕ Док.Сторно)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ДатаНачала";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат[0].Количество = 0 Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Док.Ссылка КАК Ссылка
		|ИЗ
		|	ВТСтрокиДокумента КАК Док";
	Иначе
		
		// Описание текста запроса:
		// 1. Выборка "СтрокиДокумента": 
		//	Во вложенном запросе выбираются строки документа, к ним добавляется 
		//	дата предшествующего "дате начала" движения из рег-ра РаботникиОрганизации
		//
		// 2. Выборка "РаботникиОрганизации": 
		//	Для каждой строки документа выполняем срез по регистру РаботникиОрганизации на 
		//	дату ДатаНачала для выполнения движений по штатному расписаниюи и проверки, 
		//	работает ли работник на эту дату (использует данные выборки "СтрокиДокумента")
		//
		// 3. Выборка "ПересекающиесяСтроки": 
		//	Среди остальных строк документа ищем строки, имеющие ту же дату ДатаНачала
		//
		// 4. Выборка "ИмеющиесяСостояния": 
		//	В рег-ре СостояниеРаботниковОрганизации ищем движения на дату ДатаНачала
		//
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ПодразделениеОрганизацииЗавершения
		|		ИНАЧЕ РаботникиОрганизации.ПодразделениеОрганизации
		|	КОНЕЦ КАК ПодразделениеОрганизации,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ДолжностьЗавершения
		|		ИНАЧЕ РаботникиОрганизации.Должность
		|	КОНЕЦ КАК Должность,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ЗанимаемыхСтавокЗавершения
		|		ИНАЧЕ РаботникиОрганизации.ЗанимаемыхСтавок
		|	КОНЕЦ КАК ЗанимаемыхСтавок,
		|	СтрокиДокумента.НомерСтроки,
		|	СтрокиДокумента.ДатаНачала,
		|	СтрокиДокумента.Сотрудник,
		|	СтрокиДокумента.СотрудникНаименование,
		|	СтрокиДокумента.Физлицо,
		|	СтрокиДокумента.ОсвобождатьСтавку,
		|	СтрокиДокумента.ПричинаОтсутствия,
		|	СтрокиДокумента.Ссылка,
		|	СтрокиДокумента.ДатаИзменения,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.СотрудникОрганизация = &ГоловнаяОрганизация
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
		|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрока,
		|	ИмеющиесяСостояния.Состояние КАК КонфликтноеСостояние,
		|	ИмеющиесяСостояния.Регистратор КАК КонфликтныйДокумент
		|ИЗ
		|	(ВЫБРАТЬ
		|		Док.НомерСтроки КАК НомерСтроки,
		|		Док.ДатаНачала КАК ДатаНачала,
		|		Док.Сотрудник КАК Сотрудник,
		|		Док.Сотрудник.Физлицо КАК Физлицо,
		|		Док.Сотрудник.Наименование КАК СотрудникНаименование,
		|		Док.Сотрудник.Организация КАК СотрудникОрганизация,
		|		Док.ОсвобождатьСтавку КАК ОсвобождатьСтавку,
		|		Док.ПричинаОтсутствия КАК ПричинаОтсутствия,
		|		Док.Ссылка КАК Ссылка,
		|		МАКСИМУМ(Работники.Период) КАК ДатаИзменения
		|	ИЗ
		|		ВТСтрокиДокумента КАК Док
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
		|			ПО Док.ДатаНачала >= Работники.Период
		|				И Док.Сотрудник = Работники.Сотрудник
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Док.НомерСтроки,
		|		Док.ДатаНачала,
		|		Док.ОсвобождатьСтавку,
		|		Док.ПричинаОтсутствия,
		|		Док.Ссылка,
		|		Док.Сотрудник.Физлицо,
		|		Док.Сотрудник.Организация,
		|		Док.Сотрудник.Наименование,
		|		Док.Сотрудник) КАК СтрокиДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
		|		ПО СтрокиДокумента.ДатаИзменения = РаботникиОрганизации.Период
		|			И СтрокиДокумента.Сотрудник = РаботникиОрганизации.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтрокиДокумента КАК ПересекающиесяСтроки
		|		ПО СтрокиДокумента.Сотрудник = ПересекающиесяСтроки.Сотрудник
		|			И СтрокиДокумента.ДатаНачала = ПересекающиесяСтроки.ДатаНачала
		|			И СтрокиДокумента.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ИмеющиесяСостояния
		|		ПО СтрокиДокумента.ДатаНачала = ИмеющиесяСостояния.Период
		|			И СтрокиДокумента.Ссылка <> ИмеющиесяСостояния.Регистратор
		|			И СтрокиДокумента.Сотрудник = ИмеющиесяСостояния.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ПодразделениеОрганизацииЗавершения
		|		ИНАЧЕ РаботникиОрганизации.ПодразделениеОрганизации
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ДолжностьЗавершения
		|		ИНАЧЕ РаботникиОрганизации.Должность
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
		|				И РаботникиОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА РаботникиОрганизации.ЗанимаемыхСтавокЗавершения
		|		ИНАЧЕ РаботникиОрганизации.ЗанимаемыхСтавок
		|	КОНЕЦ,
		|	СтрокиДокумента.НомерСтроки,
		|	СтрокиДокумента.ДатаНачала,
		|	СтрокиДокумента.ОсвобождатьСтавку,
		|	СтрокиДокумента.ПричинаОтсутствия,
		|	СтрокиДокумента.Ссылка,
		|	ИмеющиесяСостояния.Состояние,
		|	СтрокиДокумента.ДатаИзменения,
		|	СтрокиДокумента.Сотрудник,
		|	СтрокиДокумента.СотрудникНаименование,
		|	СтрокиДокумента.Физлицо,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.СотрудникОрганизация = &ГоловнаяОрганизация
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ИмеющиесяСостояния.Регистратор";
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("Не указана организация!"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры:
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//								  из результата запроса по товарам документа, 
//	Отказ						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке =
		"В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + """ табл. части ""Сотрудники"": ";
		
	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("указанный сотрудник оформлен на другую организацию!"), Отказ, Заголовок);
	КонецЕсли;
	
	// Дата "с"
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаНачала) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата изменения состояния!", Отказ, Заголовок);
	КонецЕсли;
	
	// Причина отсутствия
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПричинаОтсутствия) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указано состояние!", Отказ, Заголовок);
	КонецЕсли;
	
	// Работник не должен быть уволенным.
	Если ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = 0 Тогда
		СтрокаСообщениеОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаНачала, "ДЛФ=DD") + " сотрудник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " уже уволен (с " + Формат(ВыборкаПоСтрокамДокумента.ДатаИзменения, "ДЛФ=DD") + ")!";
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
		// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока <> NULL Тогда
		СтрокаСообщениеОбОшибке = "в строке " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока + " указана та же дата изменения состояния!"; 
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка: в регистре уже есть такое движение
	Если ВыборкаПоСтрокамДокумента.КонфликтноеСостояние <> NULL Тогда
		Расшифровки = Новый Массив;
		Расшифровки.Добавить(Новый Структура("Представление, Расшифровка", ВыборкаПоСтрокамДокумента.КонфликтныйДокумент, ВыборкаПоСтрокамДокумента.КонфликтныйДокумент));
		СтрокаСообщениеОбОшибке = "сотрудник уже переведен в состояние """ + ВыборкаПоСтрокамДокумента.КонфликтноеСостояние + """ документом ";
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок, , Расшифровки);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// Создает и заполняет структуру, содержащую имена регистров сведений
// по которым надо проводить документ
//
// Параметры: 
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров сведений 
//											  по которым надо проводить документ
//
// Возвращаемое значение:
//	Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	СтруктураПроведенияПоРегистрамСведений.Вставить("СостояниеРаботниковОрганизаций");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров 
//											  сведений по которым надо проводить документ,
//  СтруктураПараметров						- структура параметров проведения,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "СостояниеРаботниковОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаНачала;
		
		// Измерения
		Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;

		// Ресурсы
		Движение.Состояние			= ВыборкаПоРаботникиОрганизации.ПричинаОтсутствия;
		
		// Реквизиты
		Движение.ПервичныйДокумент	= ВыборкаПоШапкеДокумента.Ссылка;
		
	КонецЕсли;
	
	Если ВыборкаПоРаботникиОрганизации.ОсвобождатьСтавку Тогда
		
		Движение = Движения.СотрудникиОсвободившиеСтавкиВОрганизациях.Добавить();
		
		// Свойства
		Движение.Период						= ВыборкаПоРаботникиОрганизации.ДатаНачала;
		Если ВыборкаПоРаботникиОрганизации.ПричинаОтсутствия = Перечисления.СостоянияРаботникаОрганизации.Работает Тогда
			Движение.ОсвобождатьСтавку	= ложь;
		Иначе
			Движение.ОсвобождатьСтавку		= Истина;
		КонецЕсли;
		
		// Измерения
		Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	КонецЕсли;


КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров накопления, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;
	//структура, содержащая имена регистров сведений, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	//структура, содержащая имена регистров расчета, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамРасчета;
	
	// Если документ перенесен - движения не делаем
	Если ДанныеПрошлойВерсии Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ttk_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		Движения.СостояниеРаботниковОрганизаций.мВыполнятьСписаниеФактическогоОтпуска	= Истина;
		
		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			ВыборкаПоРаботникиОрганизации = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента).Выбрать();

			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);

				Если НЕ Отказ Тогда

					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, СтруктураПроведенияПоРегистрамСведений);

				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаЗаполнения" модуля объекта
//
Процедура ОбработкаЗаполнения(Основание)

	ТипОснования = ТипЗнч(Основание);
	Если ТипОснования = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда	
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
		|	СотрудникиОрганизаций.Физлицо,
		|	СотрудникиОрганизаций.Организация,
		|	СотрудникиОрганизаций.ОбособленноеПодразделение
		|ИЗ
		|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
		|ГДЕ
		|	СотрудникиОрганизаций.Ссылка = &Сотрудник";
		Запрос.УстановитьПараметр("Сотрудник",	Основание);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если Не Выборка.ОбособленноеПодразделение.Пустая() Тогда
				Организация = Выборка.ОбособленноеПодразделение;
			Иначе
				Организация = Выборка.Организация;
			КонецЕсли;
			
			НоваяСтрока = РаботникиОрганизации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ДатаНачала	= ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ);
	
	ПроведениеРасчетов.ИсправлениеКадровогоДокументаПередЗаписью(Отказ, РежимЗаписи, РежимПроведения, ЭтотОбъект, мВосстанавливатьДвижения, мИсправляемыйДокумент, мСоответствиеДвижений);
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеРасчетов.ИсправлениеКадровогоДокументаПриЗаписи(Отказ, мВосстанавливатьДвижения, мИсправляемыйДокумент, мСоответствиеДвижений);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;

мВосстанавливатьДвижения = Ложь;
