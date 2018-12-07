
////////////////////////////////////////////////////////////////////////////////
// Процедуры проверки условий и выборов вариантов
////////////////////////////////////////////////////////////////////////////////

Процедура УсловиеУслугаСвязиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	// Результат = СчетНаОплату.ЗакупочныйЗаказ.БюджетнаяСтатья.абс_УслугаСвязи И СчетНаОплату.ЗакупочныйЗаказ.НефиксированнаяСумма;
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеДРУ;
	
КонецПроцедуры

Процедура УсловиеСогласованОФКПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ;
	
КонецПроцедуры

Процедура УсловиеСогласованДРУПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеОФК;
	
КонецПроцедуры

Процедура УсловиеУтвержденРуководителемДФМПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован) 
			ИЛИ (СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеВицеПрезидентом)
			ИЛИ (СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеЗЗ);
			
КонецПроцедуры
		
Процедура УсловиеУтвержденПВППроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован) 
			ИЛИ (СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеПрезидентом);

КонецПроцедуры

Процедура УсловиеНеобходимоУтверждениеПВППроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СуммаПлатежа > абс_БизнесПроцессы.ПолучитьПределСуммыУтвержденияПоРоли(
		Перечисления.абсВидыБизнесПроцессовТТК.СогласованиеСчетовНаОплату, 
		Справочники.РолиИсполнителей.ПервыйВицеПрезидент);
	
КонецПроцедуры

Процедура УсловиеНеобходимоУтверждениеПрезидентомПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СуммаПлатежа > абс_БизнесПроцессы.ПолучитьПределСуммыУтвержденияПоРоли(
		Перечисления.абсВидыБизнесПроцессовТТК.СогласованиеСчетовНаОплату, 
		Справочники.РолиИсполнителей.Президент);

КонецПроцедуры

Процедура УсловиеУтвержденПрезидентомПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован;
	
КонецПроцедуры

Процедура УсловиеЗЗСогласованПроверкаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = 	СчетНаОплату.ЗакупочныйЗаказ.ЗЗСогласован
				ИЛИ СчетНаОплату.Технический;
			
КонецПроцедуры

Процедура УсловиеЗЗСогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = 	СчетНаОплату.ЗакупочныйЗаказ.ЗЗСогласован
				ИЛИ СчетНаОплату.Технический;
	
КонецПроцедуры

Процедура УсловиеСчетТехническийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.Технический;
	
КонецПроцедуры

Процедура УсловиеСчетСогласованДирККРПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован;
	
КонецПроцедуры

Процедура ВыборВариантаУтвержденРуководителемДФМОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если    СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Уточнить
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеДРУ
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеОФК Тогда
		
		Если СогласованиеДРУ Тогда
			Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнитьДРУ;
		Иначе
			Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнитьОФК;
		КонецЕсли;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеЗЗ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласованиеЗЗ;
		
	ИначеЕсли   СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован
			ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеВицеПрезидентом
			ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеПрезидентом Тогда
			
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласованДФМ;
		
	//Филиализация
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.ДопСогласованиеКТТК Тогда
		Результат = ТочкаВыбораВарианта.Варианты.ДопСогласованиеКТТК;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.ДопСогласованиеОФК Тогда
		Результат = ТочкаВыбораВарианта.Варианты.ДопСогласованиеОФК;
	//Филиализация
		
	Иначе
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
			
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВыборВариантаУтвержденПВПОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если    СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован 
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеПрезидентом
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеЗЗ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласован;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнитьДФМ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборВариантаУтвержденПрезидентомОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеЗЗ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласован;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
		
	ИначеЕсли   СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеВицеПрезидентом
			ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Уточнить Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнениеПВП;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВыборВариантаСогласованОФКОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласованиеДФМ;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Уточнить Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнить;
		
		//Филиализация	
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеДЭФ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.СогласованиеДЭФ;
		//Филиализация
		
	Иначе
		// Отказ	
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборВариантаСогласованДРУОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласованиеДФМ;
		
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Уточнить Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУточнить;
		
	Иначе
		// Отказ	
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборВариантаОжиданиеЗЗОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)

	Если СтатусОжиданияЗЗ = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУтверждениеРуководителемДФМ;
	ИначеЕсли СтатусОжиданияЗЗ = Перечисления.абсСтатусыСчетов.УтверждениеВицеПрезидентом Тогда
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУтверждениеПВП;
	ИначеЕсли СтатусОжиданияЗЗ = Перечисления.абсСтатусыСчетов.УтверждениеПрезидентом Тогда
		Результат = ТочкаВыбораВарианта.Варианты.ВариантУтверждениеПрезидентом;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры создания групповых задач
////////////////////////////////////////////////////////////////////////////////

// Универсальня процедура формирования групповых задач
Процедура СформироватьГрупповуюЗадачу(ТочкаМаршрута, ФормируемыеЗадачи, Организация = Неопределено)
	
	ФормируемыеЗадачи.Очистить();
	
	абс_БизнесПроцессы.СформироватьГрупповуюЗадачуИсполнителямСчетаНаОплату(ЭтотОбъект.Ссылка, ТочкаМаршрута, ФормируемыеЗадачи,,Организация);	
	
	Если ФормируемыеЗадачи.Количество() = 0 Тогда
		Отказ = Истина;
		
		Сообщить("Ошибка при формировании задач по точке " + ТочкаМаршрута + ". " + Символы.ПС 
			+ "Не найдено ответственных.");
	КонецЕсли;
		
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрута, ФормируемыеЗадачи);
	
КонецПроцедуры

// Процедуры-обработчики ПриСозданииЗадач
Процедура ДействиеСогласованиеДРУПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	//СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	
	ПодразделениеДРУ = Константы.абс_ПодразделениеДРУ.Получить();
	
	//ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяРуководителяПодразделения(
	//	глЗначениеПеременной("глТекущийПользователь"), 
	//	ПодразделениеДФМ);
	
	ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(
		абс_БизнесПроцессы.ПолучитьОтветственныхПодразделения(ПодразделениеДРУ,,СчетНаОплату.Организация));
		
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		Сообщить("Не найден пользователь руководитель ДРУ: " + ПодразделениеДРУ + ".");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);	

	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДействиеСогласованиеОФКПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	//СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);	
	
	ПодразделениеОФК = Константы.абс_ПодразделениеОФК.Получить();
	
	//ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяРуководителяПодразделения(
	//	глЗначениеПеременной("глТекущийПользователь"), 
	//	ПодразделениеОФК);
	
	ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(
	абс_БизнесПроцессы.ПолучитьОтветственныхПодразделения(ПодразделениеОФК,,СчетНаОплату.Организация));
	
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		Сообщить("Не найден пользователь руководитель ОФК: " + ПодразделениеОФК + ".");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);

	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);	
	
КонецПроцедуры

Процедура ДействиеУтверждениеРуководителемДФМПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	//СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	
	ПодразделениеДФМ = Константы.абс_ПодразделениеДФМ.Получить();
	
	//ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяРуководителяПодразделения(
	//	глЗначениеПеременной("глТекущийПользователь"), 
	//	ПодразделениеДФМ);
	
	ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(
		абс_БизнесПроцессы.ПолучитьОтветственныхПодразделения(ПодразделениеДФМ,,СчетНаОплату.Организация));
		
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		Сообщить("Не найден пользователь руководитель ДФМ: " + ПодразделениеДФМ + ".");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);

КонецПроцедуры

Процедура ДействиеСогласованиеЗЗПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	ФормируемыеЗадачи.Очистить();
	
	НоваяЗадача = Задачи.абсЗадачаДоговора.СоздатьЗадачу();
	
	НоваяЗадача.БизнесПроцесс 		= ЭтотОбъект.Ссылка;
	НоваяЗадача.ТочкаМаршрута 		= ТочкаМаршрутаБизнесПроцесса;
	НоваяЗадача.Дата 				= ТекущаяДата();
	НоваяЗадача.Наименование 		= Строка(СчетНаОплату) + " " + ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + ".";
	
	НоваяЗадача.Исполнитель			= ПользовательИнициаторБП;
	
	НоваяЗадача.ОбъектЗадачи 		= СчетНаОплату;
	
	НоваяЗадача.Записать();
	
	ФормируемыеЗадачи.Добавить(НоваяЗадача);
		
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);

	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДействиеУточнениеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	//АБС Изменение 36495  20.02.2014 11:20:34  Родин  Оптимизация бизнес-процессов
	//ФормируемыеЗадачи.Очистить();
	
	//Для Каждого ФормируемаяЗадача Из ФормируемыеЗадачи Цикл
		
		НоваяЗадача = Задачи.абсЗадачаДоговора.СоздатьЗадачу();
		
		НоваяЗадача.БизнесПроцесс 		= ЭтотОбъект.Ссылка;
		НоваяЗадача.ТочкаМаршрута 		= ТочкаМаршрутаБизнесПроцесса;
		НоваяЗадача.Дата 				= ТекущаяДата();
		НоваяЗадача.Наименование 		= Строка(СчетНаОплату) + " " + ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + ".";
		
		НоваяЗадача.Исполнитель			= ПользовательИнициаторБП;
		
		НоваяЗадача.ОбъектЗадачи 		= СчетНаОплату;
		
		НоваяЗадача.Записать();
		
		ФормируемыеЗадачи.Добавить(НоваяЗадача);

	//КонецЦикла;

	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДействиеПодготовкаСчетаНаОплатуПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт

	Для Каждого ФормируемаяЗадача Из ФормируемыеЗадачи Цикл
		ФормируемаяЗадача.Исполнитель 	= ПользовательИнициаторБП;
		ФормируемаяЗадача.ОбъектЗадачи	= СчетНаОплату;
		
		ФормируемаяЗадача.Наименование = СокрЛП(СчетНаОплату) + " "
			+ ФормируемаяЗадача.Наименование + ".";

	КонецЦикла;
		
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);	
	
КонецПроцедуры

Процедура ДействиеУточнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	Для Каждого ФормируемаяЗадача Из ФормируемыеЗадачи Цикл
		ФормируемаяЗадача.Исполнитель 	= ПользовательИнициаторБП;
		ФормируемаяЗадача.ОбъектЗадачи	= СчетНаОплату;
		
		ФормируемаяЗадача.Наименование = СокрЛП(СчетНаОплату) + " "
			+ ФормируемаяЗадача.Наименование + ".";

	КонецЦикла;

КонецПроцедуры
                                                                                                          
Процедура ДействиеУтверждениеПВППриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СчетНаОплату.Организация);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДействиеУтверждениеПрезидентомПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
	
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СчетНаОплату.Организация);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);	
	
КонецПроцедуры

Процедура ДействиеСогласованиеДРУПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ) Экспорт
	
	СогласованиеДРУ = Истина;
	
	Записать();
	
КонецПроцедуры

Процедура ДействиеСогласованПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ) Экспорт
		
	ФормируемыеЗадачи.Очистить();
	
	НоваяЗадача = Задачи.абсЗадачаДоговора.СоздатьЗадачу();
	
	НоваяЗадача.БизнесПроцесс 		= ЭтотОбъект.Ссылка;
	НоваяЗадача.ТочкаМаршрута 		= ТочкаМаршрутаБизнесПроцесса;
	НоваяЗадача.Дата 				= ТекущаяДата();
	НоваяЗадача.Наименование 		= Строка(СчетНаОплату) + " " + ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + ".";
	
	НоваяЗадача.Исполнитель			= ПользовательИнициаторБП;
	
	НоваяЗадача.ОбъектЗадачи 		= СчетНаОплату;
	
	НоваяЗадача.Записать();
	
	ФормируемыеЗадачи.Добавить(НоваяЗадача);
		
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура СформироватьЗадачуИсполнителям(ТочкаМаршрута, ФормируемыеЗадачи, Исполнители)
	
	абс_БизнесПроцессы.СформироватьЗадачуИсполнителямСчетаНаоплату(Ссылка, ТочкаМаршрута, ФормируемыеЗадачи, Исполнители);
	
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрута, ФормируемыеЗадачи, СчетНаОплату.Организация);	

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Процедуры открытия счетов 
////////////////////////////////////////////////////////////////////////////////

// Процедура открытия счета на оплату
Процедура ОткрытьФормуСчетаНаОплату()
	
	ФормаСчета = СчетНаОплату.ПолучитьФорму("ФормаДокумента");
	
	Если ФормаСчета.Открыта() Тогда
		ФормаСчета.Активизировать();
	Иначе
		ФормаСчета.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедуры обработчики события ПриИнтерактивнойАктивации
Процедура ДействиеСогласованиеЗЗОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеУточнениеОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеПодготовкаСчетаНаОплатуОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеСогласованиеДРУОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеСогласованиеОФКОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеУтверждениеРуководителемДФМОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеУтверждениеПВПОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеУтверждениеПрезидентомОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура ДействиеСогласованОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
			
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
	
КонецПроцедуры

Процедура УсловиеСогласованиеЗЗПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеЗЗ;
	
КонецПроцедуры

Процедура ЗавершениеОтказПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура УсловиеОтменаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отменен;
	
КонецПроцедуры

Процедура КонтрагентНеРезидентПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	//Результат = СчетНаОплату.Контрагент.НеЯвляетсяРезидентом;
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.НалоговыйКонтроль;
КонецПроцедуры

Процедура ПроведенНалоговыйКонтрольОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеДРУ
		ИЛИ СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеОФК Тогда// Вставить содержимое обработчика.
		Результат = ТочкаВыбораВарианта.Варианты.ВариантСогласован;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ВариантОтказ;
	КонецЕсли;
КонецПроцедуры

Процедура НалоговыйКонтрольПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
		
	//Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
	//	Сообщить("Не найден пользователь руководитель ДРУ: " + ПодразделениеДРУ + ".");
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	//
	//СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);	

	//абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
КонецПроцедуры

Процедура НалоговыйКонтрольОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
КонецПроцедуры

Процедура НеобходимоСогласованиеРППроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	//АБС Изменение 36495  20.02.2014 11:20:34  Родин  Оптимизация бизнес-процессов
	мТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");
	ИспользоватьПроектныйУчет =  глЗначениеПеременной("абс_СогласованиеРП");
	
	СписокРуководителей = Новый Массив;
	Для каждого Стр Из СчетНаОплату.РаспределениеПоПроектам Цикл
		Если ЗначениеЗаполнено(Стр.Проект.абс_РуководительПроекта) Тогда
			
			ПользовательРуководитель = Справочники.Пользователи.НайтиПоРеквизиту("абс_Сотрудник",Стр.Проект.абс_РуководительПроекта);
			
			Если ПользовательРуководитель <> Справочники.Пользователи.ПустаяСсылка() и СписокРуководителей.Найти(ПользовательРуководитель) = Неопределено Тогда
				СписокРуководителей.Добавить(ПользовательРуководитель);	
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если  ИспользоватьПроектныйУчет и СчетНаОплату.ЗакупочныйЗаказ.НефиксированнаяСумма и СписокРуководителей.Найти(мТекущийПользователь) = Неопределено Тогда
		Результат = Истина;	
	Иначе
		Результат = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

Процедура СогласованиеРППриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	ПользовательИсполнитель = Новый Массив;
	Для каждого Стр Из СчетНаОплату.РаспределениеПоПроектам Цикл
		Если ЗначениеЗаполнено(Стр.Проект.абс_РуководительПроекта) Тогда
			ПользовательРуководитель = Справочники.Пользователи.НайтиПоРеквизиту("абс_Сотрудник",Стр.Проект.абс_РуководительПроекта);

			Если ПользовательРуководитель <> Справочники.Пользователи.ПустаяСсылка() и ПользовательИсполнитель.Найти(ПользовательРуководитель) = Неопределено Тогда
				ПользовательИсполнитель.Добавить(ПользовательРуководитель);	
			КонецЕсли;
						
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Не найден пользователь руководитель проекта.", Отказ);
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);	
	
КонецПроцедуры

Процедура СогласованоРППроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)

	Если СчетНаОплату.СтатусСчета =  Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = Ложь;
	Иначе
		Результат =  Истина;
	КонецЕсли;	
		
КонецПроцедуры

Процедура ДействиеУточнениеПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	// Start КТТК Ермолов Е.Л.  09.07.2014 000026925
	Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.абсСогласованиеСчетаНаОплату.ТочкиМаршрута.ДействиеУточнение Тогда 
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	// Stop КТТК Ермолов Е.Л.  09.07.2014
КонецПроцедуры

//Филиализация
Процедура ПроверкаЛимитовОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Если Не ПараметрыСеанса.абс_НастройкиСистемы.СогласованиеЛимитаОФК Тогда
		Результат = ТочкаВыбораВарианта.Варианты.СогласованиеОФК;
	Иначе	
		Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СогласованиеОФК Тогда
			Результат = ТочкаВыбораВарианта.Варианты.СогласованиеОФК;
		ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ Тогда
			Результат = ТочкаВыбораВарианта.Варианты.СогласованиеРуководителемЦФК;
		ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеВицеПрезидентом Тогда
			Результат = ТочкаВыбораВарианта.Варианты.УтверждениеПервымВицеПрезидентом;
		ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеПрезидентом Тогда
			Результат = ТочкаВыбораВарианта.Варианты.УтверждениеПрезидентом;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборВарианта5ОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласовано;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ТребуетсяДальнейшееСогласование;
	КонецЕсли;
КонецПроцедуры

Процедура ВыборВарианта1ОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласовано;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ТребуетсяДальнейшееСогласование;
	КонецЕсли;
КонецПроцедуры

Процедура ВыборВарианта4ОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласовано;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ТребуетсяДальнейшееСогласование;
	КонецЕсли;
КонецПроцедуры

Процедура ВыборВарианта3ОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласовано;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ТребуетсяДальнейшееСогласование;
	КонецЕсли;
КонецПроцедуры

Процедура СогласованоОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласовано;
	Иначе
		Результат = ТочкаВыбораВарианта.Варианты.ТребуетсяДальнейшееСогласование;
	КонецЕсли;
КонецПроцедуры

Процедура СогласованоДЭФПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.УтверждениеРуководителемДФМ;	
КонецПроцедуры

Процедура СогласованПослеПодготовкиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован;	
КонецПроцедуры

Процедура ДопСогласованиеОФКПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	ПодразделениеОФК = Константы.абс_ПодразделениеОФК.Получить();
	
	ОрганизацияКТТК = Справочники.Организации.НайтиПоНаименованию("КТТК");
	ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(
	абс_БизнесПроцессы.ПолучитьОтветственныхПодразделения(ПодразделениеОФК,,ОрганизацияКТТК));
	
	
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		Сообщить("Не найден пользователь руководитель ОФК: " + ПодразделениеОФК + ".");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДопДействиеУтверждениеРуководителемДФМПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	ПодразделениеДФМ = Константы.абс_ПодразделениеДФМ.Получить();
	
	ОрганизацияКТТК = Справочники.Организации.НайтиПоНаименованию("КТТК");
	ПользовательИсполнитель = абс_БизнесПроцессы.ПолучитьПользователяПоСотруднику(
	абс_БизнесПроцессы.ПолучитьОтветственныхПодразделения(ПодразделениеДФМ,,ОрганизацияКТТК));
		
	Если НЕ ЗначениеЗаполнено(ПользовательИсполнитель) Тогда
		Сообщить("Не найден пользователь руководитель ДФМ: " + ПодразделениеДФМ + ".");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СформироватьЗадачуИсполнителям(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, ПользовательИсполнитель);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДопДействиеУтверждениеПВППриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СчетНаОплату.Организация);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
КонецПроцедуры

Процедура ДопДействиеУтверждениеПрезидентомПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СчетНаОплату.Организация);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);	
КонецПроцедуры

Процедура СогласованиеДЭФПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ДопСогласованиеКТТКПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	// Start КТТК Ермолов Е.Л.  17.11.2015 Дубликаты задач
	СтандартнаяОбработка = Ложь;
	// Stop КТТК Ермолов Е.Л.  17.11.2015
	СформироватьГрупповуюЗадачу(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
КонецПроцедуры

//Бобылев А.А. 26.07.2018
Процедура ПроверкаПИППроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ttk_КонтрагентыАВЗ.Контрагент
	               |ИЗ
	               |	РегистрСведений.ttk_КонтрагентыАВЗ КАК ttk_КонтрагентыАВЗ
	               |ГДЕ
	               |	ttk_КонтрагентыАВЗ.Контрагент = &Контрагент";
	Запрос.УстановитьПараметр("Контрагент", СчетНаОплату.Контрагент);
	Количество = Запрос.Выполнить().Выгрузить().Количество();
	Если Количество > 0 Тогда 
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
КонецПроцедуры


Процедура ОформлениеАВЗПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	ФормируемыеЗадачи.Очистить();
	
	НоваяЗадача = Задачи.абсЗадачаДоговора.СоздатьЗадачу();
	
	НоваяЗадача.БизнесПроцесс 		= ЭтотОбъект.Ссылка;
	НоваяЗадача.ТочкаМаршрута 		= ТочкаМаршрутаБизнесПроцесса;
	НоваяЗадача.Дата 				= ТекущаяДата();
	НоваяЗадача.Наименование 		= Строка(СчетНаОплату) + " " + ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + ".";
	
	НоваяЗадача.Исполнитель			= ПользовательИнициаторБП;
	
	НоваяЗадача.ОбъектЗадачи 		= СчетНаОплату;
	
	НоваяЗадача.Записать();
	
	ФормируемыеЗадачи.Добавить(НоваяЗадача);
		
	// Добавим задачи для суперпользователей
	абс_БизнесПроцессы.ДобавитьЗадачиСуперПользователя(ЭтотОбъект.Ссылка, СчетНаОплату, ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи);
	
	абс_БизнесПроцессыУведомления.ЗарегестрироватьУведомление(Ссылка, ТочкаМаршрутаБизнесПроцесса, СчетНаОплату.СтатусСчета);
	
КонецПроцедуры

Процедура ОформлениеАВЗОбработкаИнтерактивнойАктивации(ТочкаМаршрутаБизнесПроцесса, Задача, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуСчетаНаОплату();
КонецПроцедуры

Процедура УсловиеУточнениеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПроводимВзаимозачетОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	Если СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Отказ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказ;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.Согласован Тогда
		Результат = ТочкаВыбораВарианта.Варианты.Согласован;
	ИначеЕсли СчетНаОплату.СтатусСчета = Перечисления.абсСтатусыСчетов.СчетСогласованАВЗ Тогда
		Результат = ТочкаВыбораВарианта.Варианты.АВЗСчетСогласован;
	КонецЕсли;
КонецПроцедуры


//Филиализация

