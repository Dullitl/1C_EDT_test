
&НаКлиенте
Процедура БратьЦФУиЦФОПоУмолчаниюПриИзменении(Элемент)
	
	Элементы.ЦФО.Доступность = Объект.БратьЦФУиЦФОПоУмолчанию;
	Элементы.ЦФУ.Доступность = Объект.БратьЦФУиЦФОПоУмолчанию;
	
КонецПроцедуры

&НаКлиенте
Процедура АгрегированнаяЗагрузкаПриИзменении(Элемент)
	
	Элементы.АгрегированныйДоговор.Доступность = Объект.АгрегированнаяЗагрузка;
	Элементы.АгрегированныйКонтрагент.Доступность = Объект.АгрегированнаяЗагрузка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БратьЦФУиЦФОПоУмолчаниюПриИзменении(Элементы.БратьЦФУиЦФОПоУмолчанию);
	АгрегированнаяЗагрузкаПриИзменении(Элементы.АгрегированнаяЗагрузка);
	
КонецПроцедуры
