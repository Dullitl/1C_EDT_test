////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы документа

#Если Клиент Тогда

Процедура ДополнитьСоставКолонок(ЭтаФорма) Экспорт
	
	РаботаСДиалогами.ВставитьКолонкуВТабличноеПоле(1, ЭтаФорма.ЭлементыФормы.ДокументСписок, "ОтражатьВУправленческомУчете", "УУ", , "ОтражатьВУправленческомУчете", , , Тип("Флажок"), , 2);
	РаботаСДиалогами.ВставитьКолонкуВТабличноеПоле(2, ЭтаФорма.ЭлементыФормы.ДокументСписок, "ОтражатьВБухгалтерскомУчете", "БУ", , "ОтражатьВБухгалтерскомУчете", , , Тип("Флажок"), , 2);
	
КонецПроцедуры

#КонецЕсли