Перем мПериод Экспорт;
Перем мТаблицаДвижений Экспорт;

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()
