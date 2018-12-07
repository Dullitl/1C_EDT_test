
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрДлина(КодБК) <> 20 Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("КБК должен состоять из 20 знаков", Отказ, "Вид платежа в бюджет: " + Наименование);
	ИначеЕсли (НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(КодБК)) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("КБК должен содержать только цифры", Отказ, "Вид платежа в бюджет: " + Наименование);
	КонецЕсли;
	
КонецПроцедуры
