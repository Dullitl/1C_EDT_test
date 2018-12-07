
&НаСервере
Процедура ОбновитьСписок(НачДт, КонДт)
	
	Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", ПараметрыСеанса.ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("НачДт", НачДт);
	Список.Параметры.УстановитьЗначениеПараметра("КонДт", КонДт);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//ТекДата = НачалоМесяца(абс_СерверныеФункции.ПолучитьДатуСервера())-1;
	//ГодМесяц = Год(ТекДата) * 100 + Месяц(ТекДата);
	//ЭтаФорма.Список.Отбор.Элементы[0].ПравоеЗначение=ГодМесяц;
	//йГод = Цел(ГодМесяц / 100);
	//йМесяц = ГодМесяц - йГод * 100;
	//ЭтаФорма.РеквизитМесяцЗагрузки = Формат(Дата(йГод, йМесяц, 1, 0, 0, 0), "ДФ='ММММ гггг'") + " г.";
	
	//Запрос = Новый Запрос;
	//Запрос.Текст =
	//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	//	|	ввв_МестонахождениеБиллингаОтветственные.Ссылка КАК Местонахождение
	//	|ИЗ
	//	|	Справочник.ввв_МестонахождениеБиллинга.Ответственные КАК ввв_МестонахождениеБиллингаОтветственные
	//	|ГДЕ
	//	|	(ввв_МестонахождениеБиллингаОтветственные.ТипОтветственного = ЗНАЧЕНИЕ(Перечисление.ttk_ТипыОтветственныхПриЗагрузкеБиллинга.ОтветственныйЗаЗагрузку)
	//	|			ИЛИ ввв_МестонахождениеБиллингаОтветственные.ТипОтветственного = ЗНАЧЕНИЕ(Перечисление.ttk_ТипыОтветственныхПриЗагрузкеБиллинга.ОтветственныйЗаПроверкуВЕИСУПе)
	//	|			ИЛИ ввв_МестонахождениеБиллингаОтветственные.ТипОтветственного = ЗНАЧЕНИЕ(Перечисление.ttk_ТипыОтветственныхПриЗагрузкеБиллинга.Аудитор))
	//	|	И ввв_МестонахождениеБиллингаОтветственные.Ответственный = &Исполнитель";
	//Запрос.УстановитьПараметр("Исполнитель",ПараметрыСеанса.ТекущийПользователь);
	//СписокМест = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Местонахождение");
	//Если СписокМест.Количество() = 0 Тогда                                                                             
	//	Предупреждение("У Вас нет прав на работу с загрузкой из биллингов");
	//	Отказ=Истина;
	//	Возврат;
	//КонецЕсли;
	//Для каждого йМест Из СписокМест Цикл
	//	ЭтаФорма.Список.Отбор.Элементы[1].ПравоеЗначение.Добавить(йМест);
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеМесяцЗагрузкиНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	//Запрос=Новый Запрос;
	//Запрос.Текст="ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	//             |	ttk_ЗагрузкаНачисленийИзБиллинга.MONT_F КАК ГодМесяц
	//             |ИЗ
	//             |	Документ.ttk_ЗагрузкаНачисленийИзБиллинга КАК ttk_ЗагрузкаНачисленийИзБиллинга
	//             |ГДЕ
	//			 |	ttk_ЗагрузкаНачисленийИзБиллинга.МестонахождениеБиллинга В (&Места)
	//             |
	//             |УПОРЯДОЧИТЬ ПО
	//             |	ttk_ЗагрузкаНачисленийИзБиллинга.MONT_F";
	//Запрос.УстановитьПараметр("Места",ЭтаФорма.Список.Отбор.Элементы[1].ПравоеЗначение);
	//Монты = Запрос.Выполнить().Выбрать();
	//Элемент.СписокВыбора.Очистить();
	//Пока Монты.Следующий() Цикл
	//	йГод=Цел(Монты.ГодМесяц/100);
	//	йМесяц=Монты.ГодМесяц-йГод*100;
	//	Элемент.СписокВыбора.Добавить(Формат(Дата(йГод,йМесяц,1,0,0,0),"ДФ='ММММ гггг'")+" г.");
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеМесяцЗагрузкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	//йМесяцы = Новый Массив();
	//йМесяцы.Добавить("Янв");
	//йМесяцы.Добавить("Фев");
	//йМесяцы.Добавить("Мар");
	//йМесяцы.Добавить("Апр");
	//йМесяцы.Добавить("Май");
	//йМесяцы.Добавить("Июн");
	//йМесяцы.Добавить("Июл");
	//йМесяцы.Добавить("Авг");
	//йМесяцы.Добавить("Сен");
	//йМесяцы.Добавить("Окт");
	//йМесяцы.Добавить("Ноя");
	//йМесяцы.Добавить("Дек");
	//йМесяц = йМесяцы.Найти(Сред(ВыбранноеЗначение, 1, 3));
	//Если йМесяц = Неопределено Тогда
	//	СтандартнаяОбработка = Ложь;
	//	Возврат;
	//КонецЕсли;
	//йГод = Число(Лев(Прав(ВыбранноеЗначение, 7), 4));
	
	//ЭтаФорма.Список.Отбор.Элементы[0].ПравоеЗначение=йГод*100+(йМесяц+1);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачДт = Число(Формат(ДобавитьМесяц(ТекущаяДатаСеанса(), -1), "ДФ=yyyyMM"));
	КонДт = Число(Формат(ДобавитьМесяц(ТекущаяДатаСеанса(), -1), "ДФ=yyyyMM"));
	
	МесяцЗагрузки.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
	МесяцЗагрузки.ДатаНачала = НачалоМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));	
	МесяцЗагрузки.ДатаОкончания = КонецМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));
	
	ОбновитьСписок(НачДт, КонДт);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцЗагрузкиПриИзменении(Элемент)
	
	НачДт = Число(Формат(МесяцЗагрузки.ДатаНачала, "ДФ=yyyyMM"));
	КонДт = Число(Формат(МесяцЗагрузки.ДатаОкончания, "ДФ=yyyyMM"));
	
	ОбновитьСписок(НачДт, КонДт);
	
КонецПроцедуры
