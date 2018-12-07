Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет регистр сведений СоответствиеСчетовБУиНУ значениями по умолчанию
//
Процедура ЗаполнитьСоответствиеСчетовБУиНУпоУмолчанию() Экспорт
	
	СоответствиеСчетовБУиНУ.Очистить();
	
	#Если Клиент Тогда
	Состояние("Установка соответствий между счетами бухгалтерского и налогового учета...");
	#КонецЕсли
	Макет = ПолучитьМакет("СоответствияСчетовБУиНУ");
	
	Для Индекс = 3 По Макет.ВысотаТаблицы Цикл

		ИмяСчетаБУ     = Макет.Область(Индекс, 1, Индекс, 1).Текст;
		КодСчетаБУ     = Макет.Область(Индекс, 2, Индекс, 2).Текст;
		ИмяСчетаКоррБУ = Макет.Область(Индекс, 5, Индекс, 5).Текст;
		КодСчетаКоррБУ = Макет.Область(Индекс, 6, Индекс, 6).Текст;
		ИмяСчетаНУ     = Макет.Область(Индекс, 3, Индекс, 3).Текст;
		КодСчетаНУ     = Макет.Область(Индекс, 4, Индекс, 4).Текст;
		ИмяВидЗатратНУ = Макет.Область(Индекс, 7, Индекс, 7).Текст;
		

		Если КодСчетаБУ = "" Тогда
			Продолжить;
		КонецЕсли;
			
			СчетБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчетаБУ);
			#Если Клиент Тогда
				Состояние("Установка соответствий для счета: " + Строка(СчетБУ));
			#КонецЕсли
			
			Если СчетБУ = Неопределено Тогда
				Продолжить; // Нет счета с таким именем
			КонецЕсли;
			
			Если СчетБУ.ЗапретитьИспользоватьВПроводках Тогда
				Продолжить; // Счета - группы пропускаются
			КонецЕсли;

			СчетКоррБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчетаКоррБУ);
		Если СчетКоррБУ= Неопределено Тогда
			СчетКоррБУ = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		КонецЕсли;

		Если КодСчетаНУ = "" Тогда
			Продолжить;
		КонецЕсли;	
			СчетНУ = ПланыСчетов.Налоговый.НайтиПоКоду(КодСчетаНУ);
			Если СчетНУ = Неопределено Тогда
				Продолжить; // Нет счета с таким именем
			КонецЕсли;
			
			Если СчетНУ.ЗапретитьИспользоватьВПроводках Тогда
				Продолжить; // Счета - группы пропускаются
			КонецЕсли;
	
		Если НЕ ЗначениеЗаполнено(СчетБУ) Или НЕ ЗначениеЗаполнено(СчетНУ) Тогда
			Продолжить;
		КонецЕсли;
		

		Если ЗначениеЗаполнено(ИмяВидЗатратНУ) Тогда
			Если Лев(КодСчетаБУ, 2) = "91" Тогда
				ВидЗатратНУ = Перечисления.ВидыПрочихДоходовИРасходов[ИмяВидЗатратНУ];
			Иначе
				ВидЗатратНУ = Перечисления.ВидыРасходовНУ[ИмяВидЗатратНУ];
			КонецЕсли;
		Иначе
			Если Лев(КодСчетаБУ, 2) = "91" Тогда
				ВидЗатратНУ = Перечисления.ВидыПрочихДоходовИРасходов.ПустаяСсылка();
			Иначе
				ВидЗатратНУ = Перечисления.ВидыРасходовНУ.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;

		Запись = СоответствиеСчетовБУиНУ.Добавить();

		Запись.СчетБУ = СчетБУ;
		
		Если ЗначениеЗаполнено(СчетКоррБУ) Тогда
			Запись.СчетКоррБУ = СчетКоррБУ;
		КонецЕсли;


		Запись.СчетНУ = СчетНУ;
		
		Если ЗначениеЗаполнено(ВидЗатратНУ) Тогда
			Запись.ВидЗатратНУ = ВидЗатратНУ;
		КонецЕсли;
		Запись.Учитывается = Истина;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСоответствиеСчетовБУиНУпоУмолчанию()

// Удаляет из регистра сведений СоответствиеСчетовБУиНУ соответствия со счетами группами
//
Процедура УдалитьГруппыИзСоответствиеСчетовБУиНУпоУмолчанию() Экспорт
	
	ТаблицаСтрая = СоответствиеСчетовБУиНУ.Выгрузить();
	ТаблицаНовая = Новый ТаблицаЗначений;
	ТаблицаНовая.Колонки.Добавить("СчетБУ");
	ТаблицаНовая.Колонки.Добавить("СчетКоррБУ");
	ТаблицаНовая.Колонки.Добавить("ВидЗатратНУ");
	ТаблицаНовая.Колонки.Добавить("СчетНУ");
	ТаблицаНовая.Колонки.Добавить("Учитывается");
	ТаблицаНовая.Колонки.Добавить("Комментарий");
	
	СоответствиеСчетовБУиНУ.Очистить();
	
	#Если Клиент Тогда
	Состояние("Удаление групп из соответствий между счетами бухгалтерского и налогового учета...");
	#КонецЕсли

Для Каждого Строка Из ТаблицаСтрая Цикл
	
	Если Строка.СчетБУ.ЗапретитьИспользоватьВПроводках Или Строка.СчетНУ.ЗапретитьИспользоватьВПроводках Тогда
		Продолжить;
	КонецЕсли;
	
	НоваяСтрока = ТаблицаНовая.Добавить();
	НоваяСтрока.СчетБУ      = Строка.СчетБУ;
	НоваяСтрока.СчетКоррБУ  = Строка.СчетКоррБУ;
	НоваяСтрока.ВидЗатратНУ = Строка.ВидЗатратНУ;
	НоваяСтрока.СчетНУ      = Строка.СчетНУ;
	НоваяСтрока.Учитывается  = Строка.Учитывается;
	НоваяСтрока.Комментарий  = Строка.Комментарий;
КонецЦикла;

СоответствиеСчетовБУиНУ.Загрузить(ТаблицаНовая);	

КонецПроцедуры

// Дополняет регистр сведений СоответствиеСчетовБУиНУ недостающими значениями по умолчанию 
//
Процедура ДополнитьСоответствиеСчетовБУиНУпоУмолчанию() Экспорт
	
	Макет = ПолучитьМакет("СоответствияСчетовБУиНУ");
	
	Для Индекс = 3 По Макет.ВысотаТаблицы Цикл

		ИмяСчетаБУ     = Макет.Область(Индекс, 1, Индекс, 1).Текст;
		КодСчетаБУ     = Макет.Область(Индекс, 2, Индекс, 2).Текст;
		ИмяСчетаКоррБУ = Макет.Область(Индекс, 5, Индекс, 5).Текст;
		КодСчетаКоррБУ = Макет.Область(Индекс, 6, Индекс, 6).Текст;
		ИмяСчетаНУ     = Макет.Область(Индекс, 3, Индекс, 3).Текст;
		КодСчетаНУ     = Макет.Область(Индекс, 4, Индекс, 4).Текст;
		ИмяВидЗатратНУ = Макет.Область(Индекс, 7, Индекс, 7).Текст;

		Если НЕ ЗначениеЗаполнено(ИмяСчетаБУ) Тогда
			Продолжить; // Нет прямого соответствия.
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(ИмяСчетаНУ) Тогда
			Продолжить; // Нет прямого соответствия.
		КонецЕсли;
		

		СчетБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчетаБУ);
 			#Если Клиент Тогда
			Состояние("Установка соответствий для счета: " + Строка(СчетБУ));
			#КонецЕсли
		
		Если СчетБУ = Неопределено Тогда
			Продолжить; // Нет счета с таким именем
		КонецЕсли;
		
			СчетКоррБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчетаКоррБУ);
		Если СчетКоррБУ= Неопределено Тогда
			СчетКоррБУ = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		КонецЕсли;

		
		СчетНУ = ПланыСчетов.Налоговый.НайтиПоКоду(КодСчетаНУ);
		Если СчетНУ = Неопределено Тогда
			Продолжить; // Нет счета с таким именем
		КонецЕсли;

		Если ЗначениеЗаполнено(ИмяВидЗатратНУ) Тогда
			Если Лев(КодСчетаБУ, 2) = "91" Тогда
				ВидЗатратНУ = Перечисления.ВидыПрочихДоходовИРасходов[ИмяВидЗатратНУ];
			Иначе
				ВидЗатратНУ = Перечисления.ВидыРасходовНУ[ИмяВидЗатратНУ];
			КонецЕсли;
		Иначе
			Если Лев(КодСчетаБУ, 2) = "91" Тогда
				ВидЗатратНУ = Перечисления.ВидыПрочихДоходовИРасходов.ПустаяСсылка();
			Иначе
				ВидЗатратНУ = Перечисления.ВидыРасходовНУ.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;

		Если ЗначениеЗаполнено(СчетКоррБУ) Тогда
			Отбор = Новый Структура("СчетБУ, СчетКоррБУ");

			Отбор.СчетБУ     = СчетБУ;
			Отбор.СчетКоррБУ = СчетКоррБУ;

		ИначеЕсли ЗначениеЗаполнено(ВидЗатратНУ) Тогда
			Отбор = Новый Структура("СчетБУ, ВидЗатратНУ");

			Отбор.СчетБУ      = СчетБУ;
			Отбор.ВидЗатратНУ = ВидЗатратНУ;

		Иначе
			Отбор = Новый Структура("СчетБУ", СчетБУ);

		КонецЕсли;

		Результат = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Отбор);

		Если НЕ ЗначениеЗаполнено(СчетБУ) и НЕ ЗначениеЗаполнено(СчетНУ) Тогда
			Продолжить;
		КонецЕсли;

		Запись = СоответствиеСчетовБУиНУ.Добавить();

		Запись.СчетБУ = СчетБУ;

		Если ЗначениеЗаполнено(СчетКоррБУ) Тогда
			Запись.СчетКоррБУ = СчетКоррБУ;
		КонецЕсли;


		Запись.СчетНУ = СчетНУ;

		Если ЗначениеЗаполнено(ВидЗатратНУ) Тогда
			Запись.ВидЗатратНУ = ВидЗатратНУ;
		КонецЕсли;
		Запись.Учитывается = Истина;
		
	КонецЦикла;
	
	ТекущийНабор = СоответствиеСчетовБУиНУ.Выгрузить();
	ТекущийНабор.Колонки.Добавить("Флаг", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1,0)));
	ТекущийНабор.Свернуть("СчетБУ, СчетКоррБУ, ВидЗатратНУ, СчетНУ, Учитывается, Комментарий", "Флаг");
	
	НаборПроверки = СоответствиеСчетовБУиНУ.Выгрузить();
	НаборПроверки.Колонки.Добавить("Флаг", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1,0)));
	НаборПроверки.Свернуть("СчетБУ, СчетКоррБУ, ВидЗатратНУ, СчетНУ, Учитывается, Комментарий", "Флаг");
	НаборПроверки.ЗаполнитьЗначения(1, "Флаг");
	НаборПроверки.Свернуть("СчетБУ, СчетКоррБУ, ВидЗатратНУ", "Флаг");
	Для Каждого СтрокаПроверки Из НаборПроверки Цикл
		КоличествоПовторений = СтрокаПроверки.Флаг;
		Если КоличествоПовторений > 1 Тогда
			Для Каждого СтрокаНабора Из ТекущийНабор Цикл
				Если СтрокаНабора.СчетБУ = СтрокаПроверки.СчетБУ И СтрокаНабора.СчетКоррБУ = СтрокаПроверки.СчетКоррБУ И СтрокаНабора.ВидЗатратНУ = СтрокаПроверки.ВидЗатратНУ Тогда
					ТекущийНабор.Удалить(СтрокаНабора);
					КоличествоПовторений = КоличествоПовторений - 1;
					Если КоличествоПовторений = 1 Тогда
					Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСоответствиеСчетовБУиНУпоУмолчанию()

Процедура СоздатьНовыеСоответствияСчетовБУиНУ (ТекДата) Экспорт
	
	// Отмена соответствия БУ: 91.02 НУ: 91.02.9 Вид: прочие операционные доходы (расходы)
	// добавление соответствия БУ: 91.02 НУ: 91.02.9 Вид: прочие косвенные расходы
	Если ТекДата = '20060101' Тогда
		Строка = СоответствиеСчетовБУиНУ.Добавить();
		Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПрочиеРасходы;
		Строка.СчетНУ = Планысчетов.Налоговый.ПрочиеКосвенныеРасходы;
		Строка.ВидЗатратНУ = Перечисления.ВидыПрочихДоходовИРасходов.ПрочиеКосвенныеРасходы;
		Строка.Учитывается = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Для Каждого ТекСтрокаСоответствиеСчетовБУиНУ Из СоответствиеСчетовБУиНУ Цикл
		Движение = Движения.СоответствиеСчетовБУиНУ.Добавить();
		Движение.Период = Дата;
		Движение.СчетБУ = ТекСтрокаСоответствиеСчетовБУиНУ.СчетБУ;
		Движение.СчетКоррБУ = ТекСтрокаСоответствиеСчетовБУиНУ.СчетКоррБУ;
		Движение.ВидЗатратНУ = ТекСтрокаСоответствиеСчетовБУиНУ.ВидЗатратНУ;
		Движение.СчетНУ = ТекСтрокаСоответствиеСчетовБУиНУ.СчетНУ;
		Движение.Учитывается = ТекСтрокаСоответствиеСчетовБУиНУ.Учитывается;
		Движение.Комментарий = ТекСтрокаСоответствиеСчетовБУиНУ.Комментарий;
		Движение.РеквизитПредставление = "";
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	Для Каждого СтрокаТабличнойЧасти Из СоответствиеСчетовБУиНУ Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидЗатратНУ) 
		     И СтрокаТабличнойЧасти.ВидЗатратНУ <> Неопределено Тогда
			 СтрокаТабличнойЧасти.ВидЗатратНУ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


