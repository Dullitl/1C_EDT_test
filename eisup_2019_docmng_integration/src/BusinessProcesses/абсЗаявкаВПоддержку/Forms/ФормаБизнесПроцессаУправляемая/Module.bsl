
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КартаБизнесПроцесса = Объект.Ссылка.ПолучитьОбъект().ПолучитьКартуМаршрута();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	КартаБизнесПроцесса = Объект.Ссылка.ПолучитьОбъект().ПолучитьКартуМаршрута();
	
КонецПроцедуры
