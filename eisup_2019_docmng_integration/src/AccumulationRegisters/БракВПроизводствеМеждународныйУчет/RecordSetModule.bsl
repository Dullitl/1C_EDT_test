Перем мПериод Экспорт; 
Перем мТаблицаДвижений Экспорт;

Процедура ВыполнитьПриход() Экспорт
	
	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);
	
КонецПроцедуры // ВыполнитьДвижение()

Процедура ВыполнитьРасход() Экспорт
	
	ttk_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);
	
КонецПроцедуры // ВыполнитьДвижение()
