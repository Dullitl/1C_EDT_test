
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");                                        
	ОрганизацияКТТК = ПараметрыСеанса.абс_НастройкиСистемы.ОрганизацияКТТК;
	мРолиПользователяПоОрганизации = абс_БизнесПроцессы.ПолучитьСписокДоступныхРолейПользователя(мТекущийПользователь, ОрганизацияКТТК);
	
	Если мРолиПользователяПоОрганизации.Найти(Справочники.РолиИсполнителей.РуководительБухгалтерскойГруппы) = Неопределено Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Недостаточно прав для записи, требуется роль «Руководитель бухгалтерской группы», организации «КТТК»!", Отказ);
	КонецЕсли;

КонецПроцедуры
