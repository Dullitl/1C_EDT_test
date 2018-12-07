
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Статус = Перечисления.абсСтатусыКонтрагентов.Подготовка;
		Ответственный = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	ДатаСеанса = ТекущаяДатаСеанса();
	
	НаборЗаписей = РегистрыСведений.абс_ИзменениеСтатусовКонтрагентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ДатаСеанса);
	НаборЗаписей.Отбор.Контрагент.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = ДатаСеанса;
	Запись.Контрагент = Ссылка;
	Запись.Пользователь = ТекПользователь;	
	Запись.СтатусКонтрагента = Статус;	
	Запись.Комментарий = ПричинаИзмененияСтатуса;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.абсСтатусыКонтрагентов.Подготовка;
	Комментарий = "";
	Ответственный = глЗначениеПеременной("глТекущийПользователь");
	
КонецПроцедуры

