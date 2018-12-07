
&НаКлиенте
Процедура ПроставитьНомерДляПечати(Команда)
    ОткрытьФорму("Документ.абс_РаспределяемыеДоходыРасходы.Форма.ФормаПечати");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьВедомостьПоРаспределяемымДоходам(Команда)
	
	ТабДок = ПолучитьТабличныйДокументВедомостьПоРаспределяемымДоходамСервер();
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДок, 1, Ложь,"Ведомость по распределяемым доходам");

КонецПроцедуры

&НаСервере
Функция ПолучитьТабличныйДокументВедомостьПоРаспределяемымДоходамСервер()
	Документ =  РеквизитФормыВЗначение("Объект");
	Возврат Документы.абс_РаспределяемыеДоходыРасходы.ВыполнитьПечатьВедомостьПоРаспределяемымДоходам(Документ);
КонецФункции

&НаКлиенте
Процедура ОткрытьПериодыРедактирования(Команда)
	
	ОткрытьФорму("РегистрСведений.абс_РаспределяемыеДоходыРасходыПериодыРедактирования.ФормаСписка");
	
КонецПроцедуры
