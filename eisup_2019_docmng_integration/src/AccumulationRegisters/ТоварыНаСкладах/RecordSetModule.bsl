Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		ОбщегоНазначения.ВыполнитьДвиженияПоРегиструСвободныеОстатки(ЭтотОбъект, Отбор.Регистратор.Значение, Замещение, Перечисления.ВидыРегистровОснованийРегистраСвободныеОстатки.ТоварыНаСкладах, Отказ);
		
	КонецЕсли;

КонецПроцедуры

