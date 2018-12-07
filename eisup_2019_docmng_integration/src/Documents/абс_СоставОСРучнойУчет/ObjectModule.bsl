
Процедура ОбработкаПроведения(Отказ, Режим)
	                              	
	Движения.СоставОС.Записывать = Истина;
	Движения.СоставОС.Очистить();
	запрос = новый запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ТЧ.ОсновноеСредство,
	                      |	ТЧ.ВСоставе,
	                      |	ТЧ.Ссылка.Дата КАК Период
	                      |ИЗ
	                      |	Документ.абс_СоставОСРучнойУчет.ТабличнаяЧасть КАК ТЧ
	                      |ГДЕ
	                      |	ТЧ.Ссылка = &Ссылка
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ТЧ.Ссылка.Дата,
	                      |	ТЧ.ВСоставе,
	                      |	ТЧ.ОсновноеСредство");
	Запрос.УстановитьПараметр("Ссылка",Ссылка);					  
	Движения.СоставОС.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
