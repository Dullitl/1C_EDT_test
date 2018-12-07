

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НачисляетсяВЦеломЗаМесяц = ПроведениеРасчетов.УстановитьФлагНачисляетсяВЦеломЗаМесяц(Истина, Показатели, СпособРасчета, ПериодДействияБазовый);

	УправленческиеНачисленияПереопределяемый.ПередЗаписьюДополнительно(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью()
