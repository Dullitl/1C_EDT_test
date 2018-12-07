
Перем мТаблицаДвижений Экспорт; // Таблица движений


// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ТекРегистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	// Запрещаем пользователям корректировать остатки лимитов по бюджету
	Если ЭтотОбъект.Количество() > 0 и не РольДоступна("ПолныеПрава") Тогда
		Если ТипЗнч(ТекРегистратор) = Тип("ДокументСсылка.КорректировкаЗаписейРегистров") Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Запрещено корректировать регистр """ + ЭтотОбъект.Метаданные().Синоним + """", Отказ);
		КонецЕсли;
	КонецЕсли;
	                              	
	ПлюсОдинГод = Ложь;
	Если ЭтотОбъект.Количество() > 0 и ТипЗнч(ТекРегистратор) = Тип("ДокументСсылка.абс_ЗакупочныйЗаказ") Тогда
		ПлюсОдинГод = ТекРегистратор.СледГодОплат или ТекРегистратор.СледГодПоставок;
	КонецЕсли;
	
	Если глЗначениеПеременной("абс_КонтрольГодаВБюджетныхАналитиках") Тогда
		Если ЭтотОбъект.Количество() > 0 Тогда	
			
			ТекПериод = НачалоГода(ЭтотОбъект[0].Период);
			абс_ИсключитьДатуИзГрафикаПоставок = глЗначениеПеременной("абс_ИсключитьДатуИзГрафикаПоставок");
			Если (ТипЗнч(ТекРегистратор) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
					или ТипЗнч(ТекРегистратор) = Тип("ДокументСсылка.АвансовыйОтчет")) 
				и ЗначениеЗаполнено(абс_ИсключитьДатуИзГрафикаПоставок) 
				и НачалоДня(ЭтотОбъект[0].Период) = НачалоДня(абс_ИсключитьДатуИзГрафикаПоставок) Тогда     				
				ТекПериод = НачалоДня(абс_ИсключитьДатуИзГрафикаПоставок)-1; 				
			КонецЕсли;			
			
			СтатьиБС = ЭтотОбъект.Выгрузить(, "СтатьяОборотов");
			СтатьиБС.Свернуть("СтатьяОборотов", ""); 			
			абс_Бюджетирование.ПроверитьСтатьюОборотовПоГодуИспользования(СтатьиБС.ВыгрузитьКолонку("СтатьяОборотов"), ТекПериод, ТекРегистратор, Отказ, ПлюсОдинГод); 			
			СпЦФО = ЭтотОбъект.Выгрузить(, "ЦФО");
			СпЦФО.Свернуть("ЦФО", ""); 			
			абс_Бюджетирование.ПроверитьЦФОПоГодуИспользования(СпЦФО.ВыгрузитьКолонку("ЦФО"), ТекПериод, ТекРегистратор, Отказ, ПлюсОдинГод);
			
		КонецЕсли; 		
	КонецЕсли;	
	
КонецПроцедуры
