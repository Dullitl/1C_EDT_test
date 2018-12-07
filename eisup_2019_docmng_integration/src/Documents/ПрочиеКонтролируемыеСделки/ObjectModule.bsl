
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УведомлениеОКонтролируемойСделке) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УведомлениеОКонтролируемойСделке, "Организация");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РеквизитыУведомления = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(УведомлениеОКонтролируемойСделке, "ОтчетныйГод");
	НачалоГода = НачалоГода(РеквизитыУведомления.ОтчетныйГод);
	ОкончаниеГода = КонецГода(РеквизитыУведомления.ОтчетныйГод);
	
	Для Каждого Сделка Из Сделки Цикл
		Если ЗначениеЗаполнено(Сделка.ДатаСовершенияСделки) И (Сделка.ДатаСовершенияСделки > ОкончаниеГода 
			ИЛИ Сделка.ДатаСовершенияСделки < НачалоГода) Тогда
			
			Префикс = "Сделки[" + Формат(Сделка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
			
			ТекстСообщения = НСтр("ru = 'Дата совершения сделки в строке %1 не соответствует отчетному году уведомления. Сделка должна попадать в %2 год.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сделка.НомерСтроки, Формат(НачалоГода, "ДФ=yyyy"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Префикс+"ДатаСовершенияСделки",, Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	СуммаДокумента = ЭтотОбъект.Сделки.Итог("СуммаБезНДСВРублях") + ЭтотОбъект.Сделки.Итог("СуммаНДСВРублях");
	
	Для Каждого Сделка Из Сделки Цикл
		
		Если Сделка.ТипПредметаСделки <> Перечисления.ТипыПредметовКонтролируемыхСделок.Товар Тогда
			Сделка.Грузоотправитель = Неопределено;
		КонецЕсли;
		
		Если Сделка.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.РаботаУслуга Тогда
			Сделка.СтранаПроисхожденияПредметаСделки = Справочники.КлассификаторСтранМира.ПустаяСсылка();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, Истина, РежимПроведения);
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПрочиеКонтролируемыеСделки.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Зачет аванса
	КонтролируемыеСделки.СформироватьДвиженияКонтролируемыхСделокОрганизаций(ПараметрыПроведения.КонтролируемыеСделкиОрганизаций,
		Движения, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ttk_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, Истина, РежимПроведенияДокумента.Неоперативный);
КонецПроцедуры

#КонецЕсли
