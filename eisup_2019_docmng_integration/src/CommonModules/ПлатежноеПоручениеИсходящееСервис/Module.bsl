
Функция СписокДокументовВводимыхНаОсновании(ТекущиеДанные) Экспорт
	
	ДокументыВводимыеНаОсновании = Новый Массив;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ДокументыВводимыеНаОсновании.Добавить("ПлатежныйОрдерСписаниеДенежныхСредств");
	КонецЕсли;
	
	Возврат ДокументыВводимыеНаОсновании;
	
КонецФункции
