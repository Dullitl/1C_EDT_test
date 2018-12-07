////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкаПроксиНаКлиенте = Параметры.НастройкаПроксиНаКлиенте;
	
	Если НастройкаПроксиНаКлиенте Тогда
		НастройкаПроксиСервера = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаПроксиСервера");
	Иначе
		НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.ПолучитьНастройкиПроксиНаСервере1СПредприятие();
	КонецЕсли;
	
	Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		Сервер       = НастройкаПроксиСервера.Получить("Сервер");
		Пользователь = НастройкаПроксиСервера.Получить("Пользователь");
		Пароль       = НастройкаПроксиСервера.Получить("Пароль");
		Порт         = НастройкаПроксиСервера.Получить("Порт");
		НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера.Получить("НеИспользоватьПроксиДляЛокальныхАдресов");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// Варианты настройки прокси-сервера:
	// 0 - Не использовать прокси-сервер (по-умолчанию, соответствует Новый ИнтернетПрокси(Ложь))
	// 1 - Использовать системные настройки прокси-сервера (соответствует Новый ИнтернетПрокси(Истина))
	// 2 - Использовать свои настройки прокси-сервера (соответствует ручной настройке параметров прокси-сервера)
	// Для последнего становятся достуно ручное изменение параметров прокси-сервера
	ВариантИспользованияПроксиСервера = ?(ИспользоватьПрокси, ?(ИспользоватьСистемныеНастройки = Истина, 1, 2), 0);
	Если (ВариантИспользованияПроксиСервера = 0) Тогда
		ПоказатьПустыеНастройкиПроксиСервера();
	ИначеЕсли (ВариантИспользованияПроксиСервера = 1) Тогда
		ПоказатьСистемныеНастройкиПроксиСервера();
	КонецЕсли;
	Элементы.ПараметрыПрокси.Доступность = ?(ВариантИспользованияПроксиСервера = 2, Истина, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик события нажатия на кнопку "ОК" командной панели формы
// Закрывает форму, передавая в качестве возвращаемого результата
// параметры прокси.
//
&НаКлиенте
Процедура ОкВыполнить()
	
	НастройкаПроксиСервера = Новый Соответствие;
	НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", ИспользоватьПрокси);
	НастройкаПроксиСервера.Вставить("Пользователь", Пользователь);
	НастройкаПроксиСервера.Вставить("Пароль", Пароль);
	НастройкаПроксиСервера.Вставить("Порт", Порт);
	НастройкаПроксиСервера.Вставить("Сервер", Сервер);
	НастройкаПроксиСервера.Вставить("НеИспользоватьПроксиДляЛокальныхАдресов", НеИспользоватьПроксиДляЛокальныхАдресов);
	НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", ИспользоватьСистемныеНастройки);
	
	СохранитьНастройкиПроксиСервера(НастройкаПроксиНаКлиенте, НастройкаПроксиСервера);
	
	Закрыть(НастройкаПроксиСервера);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Сохранение настроек прокси
//
&НаСервереБезКонтекста
Процедура СохранитьНастройкиПроксиСервера(НастройкаПроксиНаКлиенте, НастройкаПроксиСервера)
	
	Если НастройкаПроксиНаКлиенте Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкаПроксиСервера", , НастройкаПроксиСервера);
		ОбновитьПовторноИспользуемыеЗначения();
	Иначе
		ПолучениеФайловИзИнтернета.СохранитьНастройкиПроксиНаСервере1СПредприятие(НастройкаПроксиСервера);
	КонецЕсли;
	
КонецПроцедуры


// Изменяем доступность группы редактирования параметров прокси в зависимости от варианта использования прокси-сервера
//
&НаКлиенте
Процедура ИспользоватьСистемныеНастройкиПроксиСервераПриИзменении(Элемент)
	
	// Варианты настройки прокси-сервера:
	// 0 - Не использовать прокси-сервер (по-умолчанию, соответствует Новый ИнтернетПрокси(Ложь))
	// 1 - Использовать системные настройки прокси-сервера (соответствует Новый ИнтернетПрокси(Истина))
	// 2 - Использовать свои настройки прокси-сервера (соответствует ручной настройке параметров прокси-сервера)
	// Для последнего становятся достуно ручное изменение параметров прокси-сервера
	ИспользоватьПрокси = Не (ВариантИспользованияПроксиСервера = 0);
	ИспользоватьСистемныеНастройки = (ВариантИспользованияПроксиСервера = 1);
	Если (ВариантИспользованияПроксиСервера = 0) Тогда
		ПоказатьПустыеНастройкиПроксиСервера();
	ИначеЕсли (ВариантИспользованияПроксиСервера = 1) Тогда
		ПоказатьСистемныеНастройкиПроксиСервера();
	КонецЕсли;
	Элементы.ПараметрыПрокси.Доступность = ?(ВариантИспользованияПроксиСервера = 2, Истина, Ложь);
	
КонецПроцедуры

// Загружаем в форму системные настройки прокси-сервера
//
&НаКлиенте
Процедура ПоказатьСистемныеНастройкиПроксиСервера()
	
	Прокси = Новый ИнтернетПрокси(Истина);
	Сервер       = Прокси.Сервер();
	Порт         = Прокси.Порт();
	Пользователь = Прокси.Пользователь;
	Пароль       = Прокси.Пароль;
	НеИспользоватьПроксиДляЛокальныхАдресов = Прокси.НеИспользоватьПроксиДляЛокальныхАдресов;
	
КонецПроцедуры

// Загружаем в форму пустые настройки прокси-сервера
//
&НаКлиенте
Процедура ПоказатьПустыеНастройкиПроксиСервера()
	
	Прокси = Новый ИнтернетПрокси(Ложь);
	Сервер       = "";
	Порт         = 0;
	Пользователь = "";
	Пароль       = "";
	НеИспользоватьПроксиДляЛокальныхАдресов = Ложь;
	
КонецПроцедуры


