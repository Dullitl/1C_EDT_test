
Процедура ПриЗаписи(Отказ)
	
	Если (НЕ ОбменДанными.Загрузка) И (НЕ ЗначениеЗаполнено(ВидОбъектаКонтактнойИнформации) ИЛИ НЕ ЗначениеЗаполнено(Тип)) Тогда
		#Если Клиент Тогда
		Предупреждение("Укажите вид и тип объекта контактной информации.");
		#КонецЕсли
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

