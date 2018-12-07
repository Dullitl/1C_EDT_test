Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения(ОтражатьВНалоговомУчетеУСН=Ложь) Экспорт

	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");
	
	// {{ТТК Сладков А. Заявка № 12.04.2016 начало
	
	////АБС НАЧАЛО Задача №08759
	//мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "СписыватьТолькоПоЗаказу");
	////\\АБС КОНЕЦ Задача №08759
	
	Если  НЕ( 	ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение) =  Тип("ДокументСсылка.ТребованиеНакладная") 
				ИЛИ ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение) =  Тип("ДокументСсылка.СписаниеТоваров")
				ИЛИ ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение) =  Тип("ДокументСсылка.ПеремещениеТоваров"))Тогда
		//АБС НАЧАЛО Задача №08759
		мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "СписыватьТолькоПоЗаказу");
		//\\АБС КОНЕЦ Задача №08759
	Иначе
		
		мТаблицаДвижений.ЗаполнитьЗначения( Ложь,  "СписыватьТолькоПоЗаказу");
		
	КонецЕсли;	
	
	//}}ТТК Сладков А. Заявка № 12.04.2016 окончание
	
	Если ОтражатьВНалоговомУчетеУСН Тогда
		Для Каждого ТекущаяСтрока Из мТаблицаДвижений Цикл
			ТекущаяСтрока.СчетУчетаНУ = ТекущаяСтрока.СчетУчетаБУ;
			ТекущаяСтрока.КорСчетНУ = ТекущаяСтрока.КорСчетБУ;
		КонецЦикла;
	КонецЕсли;	
	
	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);

КонецПроцедуры // ВыполнитьДвижения()
