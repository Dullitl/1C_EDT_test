
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();

	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
