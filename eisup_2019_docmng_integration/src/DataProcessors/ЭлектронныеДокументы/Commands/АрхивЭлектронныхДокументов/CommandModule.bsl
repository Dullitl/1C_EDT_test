
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Обработка.ЭлектронныеДокументы.Форма.АрхивЭлектронныхДокументов", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
								ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
