
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗакупочныйЗаказ") Тогда
		ОтборЗаказ = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЗаказ.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ОтборЗаказ.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ЗакупочныйЗаказ");
		ОтборЗаказ.ПравоеЗначение		= Параметры.ЗакупочныйЗаказ;
		ОтборЗаказ.Использование		= Истина;
		ОтборЗаказ.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
КонецПроцедуры
