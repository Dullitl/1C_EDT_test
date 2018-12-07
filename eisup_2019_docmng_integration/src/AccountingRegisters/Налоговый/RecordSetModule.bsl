Процедура ОтразитьНеПринимаемыеРасходы(Проводка, СчетУчетаНепринимаемыхРасходов)
	
	Проводка.КоличествоДт  = 0;
	Проводка.СчетДт        =  СчетУчетаНепринимаемыхРасходов;
	Проводка.СубконтоДт.Очистить();	
	Проводка.ВидУчетаДт = Перечисления.ВидыУчетаПоПБУ18.НУ;
	
КонецПроцедуры

Процедура ОтразитьНеПринимаемыеДоходы(Проводка)
	
	Проводка.КоличествоКт = 0;
	Проводка.СчетКт       =  ПланыСчетов.Налоговый.ДоходыНеУчитываемые;
	Проводка.СубконтоКт.Очистить();	
	Проводка.ВидУчетаКт = Перечисления.ВидыУчетаПоПБУ18.НУ;
	
КонецПроцедуры

Функция ПолучитьПоддержкаПБУ18(Период, Организация, КэшПоддержкаПБУ18)
	
	СтрокиКэша = КэшПоддержкаПБУ18.НайтиСтроки(Новый Структура("Период,Организация", НачалоМесяца(Период), Организация));
	
	Если СтрокиКэша.Количество() = 0 Тогда
		ПараметрыУчетнойПолитикиРегл = ttk_ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(Период, Организация, Ложь);
		СтрокаКэша = КэшПоддержкаПБУ18.Добавить();
		СтрокаКэша.Период = НачалоМесяца(Период);
		СтрокаКэша.Организация = Организация;
		Если ЗначениеЗаполнено(ПараметрыУчетнойПолитикиРегл) Тогда
			СтрокаКэша.ПоддержкаПБУ18 = ПараметрыУчетнойПолитикиРегл.ПоддержкаПБУ18;
		Иначе
			СтрокаКэша.ПоддержкаПБУ18 = Ложь;
		КонецЕсли; 
	Иначе
		СтрокаКэша = СтрокиКэша[0];
	КонецЕсли;
	
	Возврат СтрокаКэша.ПоддержкаПБУ18;
	
КонецФункции // ПолучитьПоддержкаПБУ18
 
//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ
// 

// Обработчик события "ПередЗаписью".
// Проверяет возможность изменения записей регистра.
// Замещает пустные значения субконто составного типа значением Неопределено.
// Проверяет и устанавливает вид учета.
// Отрабатывает ПБУ 18/02.
//
Процедура ПередЗаписью(Отказ)
	
	Перем ТипРегистратора;
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
	НалоговыйУчет.СвернутьНаборЗаписейРегистраБухгалтерии(ЭтотОбъект);
	КэшПоддержкаПБУ18 = Новый ТаблицаЗначений;
	КэшПоддержкаПБУ18.Колонки.Добавить("Период");
	КэшПоддержкаПБУ18.Колонки.Добавить("Организация");
	КэшПоддержкаПБУ18.Колонки.Добавить("ПоддержкаПБУ18");	
	Если Количество()>0 Тогда
		ТипРегистратора = ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение);
		ПеремДокумент = ЭтотОбъект.Отбор.Регистратор.Значение;
	Иначе
		Возврат;
	КонецЕсли;
	
	//АБС ВСТАВКА №38491 НАЧАЛО «31 марта 2014 г.», Пополитов
	НужнаяГруппаПериодаОтражения = глЗначениеПеременной("абс_КонтрольПоГруппеПериодаОтраженияВСчетах");	
	//\\АБС ВСТАВКА №38491 КОНЕЦ   		
	
	//Филиализация
	Если ПараметрыСеанса.абс_НастройкиСистемы.ИспользоватьМеханизмФизиализации Тогда
		
		ас_Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
		НеПроверятьНаЗакрытыеСчета = Ложь;
		ПроверкаНаДатуРеорганизацииНеТребуется = Ложь;
        ДатаРеорганизации = Неопределено;
		
		Если ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.ОперацияБух") ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.КорректировкаЗаписейРегистров") Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	абс_ПереносДанных.Ссылка
			|ИЗ
			|	Документ.абс_ПереносДанных КАК абс_ПереносДанных
			|ГДЕ
			|	(абс_ПереносДанных.ДокументДвижений = &ДокументДвижений
			|			ИЛИ абс_ПереносДанных.ДокументДвиженийОпераияБух = &ДокументДвижений)";
			
			Запрос.УстановитьПараметр("ДокументДвижений",ас_Регистратор);
			Результат = Запрос.Выполнить();
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				НеПроверятьНаЗакрытыеСчета 			   = Истина;
				ПроверкаНаДатуРеорганизацииНеТребуется = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если Не НеПроверятьНаЗакрытыеСчета Тогда
			
			Если ТипЗнч(ас_Регистратор)    = Тип("ДокументСсылка.ПлатежноеПоручениеВходящее") 
				ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") 
				ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") 
				ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") 
				ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств") 
				ИЛИ ТипЗнч(ас_Регистратор) = Тип("ДокументСсылка.ПлатежныйОрдерСписаниеДенежныхСредств")  Тогда
				
				ПроверкаНаДатуРеорганизацииНеТребуется = Истина;
				
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	НАЧАЛОПЕРИОДА(абс_ДатаРеорганизацииДЗО.ДатаРеорганизации, ДЕНЬ) КАК ДатаРеорганизации
			|ИЗ
			|	РегистрСведений.абс_ДатаРеорганизацииДЗО КАК абс_ДатаРеорганизацииДЗО
			|
			|СГРУППИРОВАТЬ ПО
			|	НАЧАЛОПЕРИОДА(абс_ДатаРеорганизацииДЗО.ДатаРеорганизации, ДЕНЬ)";
			
			//Запрос.УстановитьПараметр("Организация", ас_Регистратор.Организация);
			Результат = Запрос.Выполнить();
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				ДатаРеорганизации = ВыборкаДетальныеЗаписи.ДатаРеорганизации;	
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	//Филиализация
	
	
	Для Каждого Проводка Из ЭтотОбъект Цикл
		
		Если Проводка.Период = '00010101' Тогда
			Проводка.Период = ПеремДокумент.Дата;
			Проводка.Организация = ПеремДокумент.Организация;
		КонецЕсли;		
		
		ПоддержкаПБУ18 = ПолучитьПоддержкаПБУ18(Проводка.Период, Проводка.Организация, КэшПоддержкаПБУ18);
		
		Если НЕ ЗначениеЗаполнено(Проводка.ВидУчетаДт) ИЛИ НЕ ЗначениеЗаполнено(Проводка.ВидУчетаКт)  Тогда
			
			ВидУчетаДт = Проводка.ВидУчетаДт;
			ВидУчетаКт = Проводка.ВидУчетаКт;
			
			НалоговыйУчет.ВидУчетаПоПБУ18(Проводка, , ПоддержкаПБУ18);
			
			Если (ЗначениеЗаполнено(ВидУчетаДт)) И
				(ЗначениеЗаполнено(Проводка.СчетДт)) Тогда
				Проводка.ВидУчетаДт = ВидУчетаДт;
			КонецЕсли;		
			
			Если (ЗначениеЗаполнено(ВидУчетаКт)) И
				(ЗначениеЗаполнено(Проводка.СчетКт))  Тогда
				Проводка.ВидУчетаКт = ВидУчетаКт;
			КонецЕсли;
			
		КонецЕсли;
		
		// Приведение пустых значений субконто составного типа.
		Для Каждого Субконто Из Проводка.СубконтоДт Цикл
			Если Субконто.Ключ.ТипЗначения.Типы().Количество() > 1
				И НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И НЕ (Субконто.Значение = Неопределено) Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			//АБС ВСТАВКА №12214 НАЧАЛО
			Если ТипЗнч(Субконто.Значение) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы") 
				и НЕ ТипРегистратора = Тип("ДокументСсылка.ОперацияБух") //АБС ВСТАВКА №14656
				и НЕ ТипРегистратора = Тип("ДокументСсылка.КорректировкаЗаписейРегистров") //Сторчевой А.Н. 19.03.2018 00-00000034 {}
				и ЗначениеЗаполнено(Субконто.Значение)
				и Субконто.Значение.абс_УточнениеЗатрат
				и Проводка["ВидУчетаДт"] = Перечисления.ВидыУчетаПоПБУ18.ПР Тогда
				Проводка["ВидУчетаДт"] = Перечисления.ВидыУчетаПоПБУ18.ВР;
			КонецЕсли;	
			//\\АБС ВСТАВКА №12214 КОНЕЦ			
		КонецЦикла;
		
		Для Каждого Субконто Из Проводка.СубконтоКт Цикл
			Если Субконто.Ключ.ТипЗначения.Типы().Количество() > 1
				И НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И НЕ (Субконто.Значение = Неопределено) Тогда
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			//АБС ВСТАВКА №12214 НАЧАЛО
			Если ТипЗнч(Субконто.Значение) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы") 
				и НЕ ТипРегистратора = Тип("ДокументСсылка.ОперацияБух")//АБС ВСТАВКА №14656
				и ЗначениеЗаполнено(Субконто.Значение)
				и Субконто.Значение.абс_УточнениеЗатрат
				и Проводка["ВидУчетаКт"] = Перечисления.ВидыУчетаПоПБУ18.ПР Тогда
				Проводка["ВидУчетаКт"] = Перечисления.ВидыУчетаПоПБУ18.ВР;
			КонецЕсли;
			//\\АБС ВСТАВКА №12214 КОНЕЦ			
		КонецЦикла;		
		
		Если (Не Проводка.СчетКт = ПланыСчетов.Налоговый.ПустаяСсылка() И Проводка.СчетКт.ПринадлежитЭлементу(ПланыСчетов.Налоговый.ПрочиеДоходы))
			И (Не ТипРегистратора = Тип("ДокументСсылка.ОперацияБух"))  
            И (Не ТипРегистратора = Тип("ДокументСсылка.КорректировкаЗаписейРегистров")) Тогда
			ОтразитьНеПринимаемыеДоходы = НалоговыйУчет.ОпределитьНеПринимаемыеДоходыРасходы(Проводка);
		Иначе
			ОтразитьНеПринимаемыеДоходы = Ложь;
		КонецЕсли;
		
		Если ОтразитьНеПринимаемыеДоходы ИЛИ ТипРегистратора = Тип("ДокументСсылка.ОперацияБух") Или
			ТипРегистратора = Тип("ДокументСсылка.КорректировкаЗаписейРегистров") Или
			(ТипРегистратора = Тип("ДокументСсылка.АмортизацияОС") И НЕ ЗначениеЗаполнено(Проводка.СубконтоКт.ОсновныеСредства)) Или
			(ТипРегистратора = Тип("ДокументСсылка.АмортизацияНМА") И НЕ ЗначениеЗаполнено(Проводка.СубконтоКт.НематериальныеАктивы)) Или
			ТипРегистратора = Тип("ДокументСсылка.РасчетСебестоимостиВыпуска") Или
			(ТипРегистратора = Тип("ДокументСсылка.СписаниеРасходовБудущихПериодов") И НЕ ЗначениеЗаполнено(Проводка.СубконтоКт.РасходыБудущихПериодов)) Или
			(Проводка.ВидУчетаКт <> Перечисления.ВидыУчетаПоПБУ18.НУ И НЕ Лев(Проводка.СчетКт.Код, 2) = "97") Или
			Проводка.ВидУчетаДт = Перечисления.ВидыУчетаПоПБУ18.ВР Тогда
			
			ОтразитьНеПринимаемыеРасходы = Ложь;
			
		Иначе 
			ОтразитьНеПринимаемыеРасходы = НалоговыйУчет.ОпределитьНеПринимаемыеДоходыРасходы(Проводка);
			
		КонецЕсли;
		
		Если ОтразитьНеПринимаемыеРасходы Тогда 
			Если ПоддержкаПБУ18 Тогда
				ПроводкаПоНеПринимаемымРасходам = ЭтотОбъект.Добавить();
				ПроводкаПоНеПринимаемымРасходам.Организация = Проводка.Организация;
				ПроводкаПоНеПринимаемымРасходам.Период      = Проводка.Период;
				ПроводкаПоНеПринимаемымРасходам.Содержание  = Проводка.Содержание;
				ПроводкаПоНеПринимаемымРасходам.Сумма       = Проводка.Сумма;
				ПроводкаПоНеПринимаемымРасходам.СписаниеПартий = Проводка.СписаниеПартий;
			Иначе
				ПроводкаПоНеПринимаемымРасходам = Проводка;
			КонецЕсли;
			
			Если Проводка.СчетДт = ПланыСчетов.Налоговый.ВнереализационныеРасходы Или Проводка.СчетДт.ПринадлежитЭлементу(ПланыСчетов.Налоговый.ВнереализационныеРасходы) Тогда
				СчетУчетаНепринимаемыхРасходов     =   ПланыСчетов.Налоговый.ВнереализационныеРасходыНеУчитываемые;
			ИначеЕсли Проводка.СчетДт = ПланыСчетов.Налоговый.РасчетыСПерсоналомПоОплатеТруда Или Проводка.СчетКт = ПланыСчетов.Налоговый.РасчетыСПерсоналомПоОплатеТруда Тогда				
				СчетУчетаНепринимаемыхРасходов     =  ПланыСчетов.Налоговый.ВыплатыВпользуФизЛицПоП_1_48;
			Иначе
				СчетУчетаНепринимаемыхРасходов     =  ПланыСчетов.Налоговый.ДругиеВыплатыПоП_1_48;
			КонецЕсли;
			
			ОтразитьНеПринимаемыеРасходы(ПроводкаПоНеПринимаемымРасходам, СчетУчетаНепринимаемыхРасходов);
		КонецЕсли;
		
		Если ОтразитьНеПринимаемыеДоходы Тогда 
			Если ПоддержкаПБУ18 Тогда
				ПроводкаПоНеПринимаемымРасходам = ЭтотОбъект.Добавить();
				ПроводкаПоНеПринимаемымРасходам.Организация = Проводка.Организация;
				ПроводкаПоНеПринимаемымРасходам.Период      = Проводка.Период;
				ПроводкаПоНеПринимаемымРасходам.Содержание  = Проводка.Содержание;
				ПроводкаПоНеПринимаемымРасходам.Сумма       = Проводка.Сумма;
				ПроводкаПоНеПринимаемымРасходам.СписаниеПартий = Проводка.СписаниеПартий;
			Иначе
				ПроводкаПоНеПринимаемымРасходам = Проводка;
			КонецЕсли;
			
			ОтразитьНеПринимаемыеДоходы(ПроводкаПоНеПринимаемымРасходам);
		КонецЕсли;
		           		
		Если Не ПоддержкаПБУ18 И ((Проводка.ВидУчетаДт = Перечисления.ВидыУчетаПоПБУ18.ВР Или 
			Проводка.ВидУчетаКт = Перечисления.ВидыУчетаПоПБУ18.ВР Или 
			Проводка.ВидУчетаДт = Перечисления.ВидыУчетаПоПБУ18.ПР Или 
			Проводка.ВидУчетаКт = Перечисления.ВидыУчетаПоПБУ18.ПР)) Тогда
			ttk_ОбщегоНазначения.СообщитьОбОшибке("Для организации " + Проводка.Организация + " не применяется ПБУ 18/02, проведение по виду учета ""ПР"" и ""ВР"" некорректно");
		КонецЕсли;
		
		//АБС ВСТАВКА №38491 НАЧАЛО «31 марта 2014 г.», Пополитов
		абс_ЗаполнитьПериодОтраженияУСубконто(Проводка, НужнаяГруппаПериодаОтражения, ПеремДокумент);	
		//\\АБС ВСТАВКА №38491 КОНЕЦ 			
		
		//АБС ВСТАВКА №000029622,29620 НАЧАЛО «17 декабря 2014 г.», Пополитов
		ОбщегоНазначения.абс_ПроверитьТипСубконто(Проводка, Отказ);	
		//\\АБС ВСТАВКА №000029622,29620 КОНЕЦ		
		
	КонецЦикла;
	
	//Филиализация
	Если ПараметрыСеанса.абс_НастройкиСистемы.ИспользоватьМеханизмФизиализации Тогда
		Если ДатаРеорганизации <> Неопределено Тогда
			МассивДоступныхРолей = абс_БизнесПроцессы.ПолучитьСписокДоступныхРолейПользователя();
			Если (ДатаРеорганизации = НачалоДня(ас_Регистратор.Дата)) И (Не ПроверкаНаДатуРеорганизацииНеТребуется)
				И (МассивДоступныхРолей.Найти(Справочники.РолиИсполнителей.ПроведениеОперацийДатойРеорганизации) = Неопределено) 
				И (НЕ абс_Филиализация.ЭтоОперацияВГР(ас_Регистратор)) Тогда
				ТекстСообщения = "Налоговый учет : В день реорганизации запрещается проведение, отмена проведения и установка пометки на удаление!";
				ttk_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//Филиализация
	
КонецПроцедуры // ПередЗаписью	
   	
//АБС ВСТАВКА №38491 НАЧАЛО «31 марта 2014 г.», Пополитов
Процедура абс_ЗаполнитьПериодОтраженияУСубконто(Проводка, НужнаяГруппаПериодаОтражения, ас_Регистратор)
	
	Если Проводка.Период < '20140101000000' Тогда
		Возврат;
	КонецЕсли;		
	
	МассивВидовСчетов = Новый Массив;
	Если ЗначениеЗаполнено(Проводка.СчетДт) и Проводка.СчетДт.ПринадлежитЭлементу(ПланыСчетов.Налоговый.ПрочиеДоходыИРасходы) 
		и Проводка.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ас_ПериодыОтражения) <> Неопределено Тогда
		МассивВидовСчетов.Добавить("Дт");	
	КонецЕсли;	
	Если ЗначениеЗаполнено(Проводка.СчетКт) и Проводка.СчетКт.ПринадлежитЭлементу(ПланыСчетов.Налоговый.ПрочиеДоходыИРасходы)
		и Проводка.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ас_ПериодыОтражения) <> Неопределено Тогда
		МассивВидовСчетов.Добавить("Кт");	
	КонецЕсли;	
	Если МассивВидовСчетов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
		
	Для Каждого мВидСчета из МассивВидовСчетов Цикл
		
		ЗначениеСчета    = Проводка["Счет"+мВидСчета];
		ЗначениеСубконто = Проводка["Субконто"+мВидСчета][ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ас_ПериодыОтражения]; 
				    		
		Если не ЗначениеЗаполнено(ЗначениеСубконто)
			или (ЗначениеЗаполнено(ЗначениеСубконто) и не ЗначениеСубконто.ПринадлежитЭлементу(НужнаяГруппаПериодаОтражения)) Тогда
			
			ПериодыОтраженияБУ = НайтиСубконтоПериодыОтраженияПоБУ(Проводка,ас_Регистратор,мВидСчета);
			Если ЗначениеЗаполнено(ПериодыОтраженияБУ) Тогда
				БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ПериодыОтраженияБУ);
				Продолжить;
			КонецЕсли;	
			
			Если ПроверитьЗначениеРеквизита(ас_Регистратор, "абс_ПериодОтражения91", НужнаяГруппаПериодаОтражения) Тогда			
				БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ас_Регистратор.абс_ПериодОтражения91);
			ИначеЕсли ПроверитьЗначениеРеквизита(ас_Регистратор, "абс_ПериодОтражения", НужнаяГруппаПериодаОтражения) Тогда
				ПериодОтражения = абс_СерверныеФункции.КорректныйПериодОтраженияНеДляНДС(ас_Регистратор.абс_ПериодОтражения,ЗначениеСубконто,Проводка.Период);
				БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ПериодОтражения);
			ИначеЕсли ПроверитьЗначениеРеквизита(ас_Регистратор, "КорректируемыйПериод", НужнаяГруппаПериодаОтражения) Тогда
				ПериодОтражения = ПолучитьПериодНДСПоДате(ас_Регистратор.КорректируемыйПериод,НужнаяГруппаПериодаОтражения);
				БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ПериодОтражения);
			Иначе
				// определим период по дате документа
				Если ЗначениеЗаполнено(ас_Регистратор) Тогда 
					ПериодОтражения = ПолучитьПериодНДСПоДате(ас_Регистратор.Дата,НужнаяГруппаПериодаОтражения);
					БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ПериодОтражения);
				Иначе
					ПериодОтражения = ПолучитьПериодНДСПоДате(Проводка.Период,НужнаяГруппаПериодаОтражения);
					БухгалтерскийУчет.УстановитьСубконто(ЗначениеСчета, Проводка["Субконто"+мВидСчета], "ас_ПериодыОтражения", ПериодОтражения);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		         		
КонецПроцедуры	

Функция ПроверитьЗначениеРеквизита(ас_Регистратор, ИмяРеквизита, НужнаяГруппаПериодаОтражения)
	
	возврат ас_Регистратор.Метаданные().Реквизиты.Найти(ИмяРеквизита) <> Неопределено 
				и ЗначениеЗаполнено(ас_Регистратор[ИмяРеквизита]) 
				и ас_Регистратор[ИмяРеквизита].ПринадлежитЭлементу(НужнаяГруппаПериодаОтражения)	
	
КонецФункции	

Функция ПолучитьПериодНДСПоДате(ДатаПериода,НужнаяГруппа = Неопределено)
	
	Если НужнаяГруппа = Неопределено Тогда
		НужнаяГруппа = глЗначениеПеременной("абс_КонтрольПоГруппеПериодаОтраженияВСчетах");
	КонецЕсли;
	
	НомерГода = СтрЗаменить(СтрЗаменить(СокрЛП(Год(ДатаПериода)), " ",""), Символы.НПП, "");
	КодПоиска = СокрЛП(НомерГода);
	Элемент = Справочники.ас_ПериодыОтражения.НайтиПоНаименованию(КодПоиска,,НужнаяГруппа);  		
	Возврат Элемент; 		
		   	
КонецФункции

Функция НайтиСубконтоПериодыОтраженияПоБУ(Проводка,ас_Регистратор,мВидСчета)
	
	ЗначениеСубконтоПрочиеДоходыИРасходы = Проводка["Субконто"+мВидСчета][ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы];
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.Счет.Код = ""91.01""
	|				ИЛИ ХозрасчетныйОбороты.Счет.Код = ""91.02.1""
	|			ТОГДА ХозрасчетныйОбороты.Субконто2
	|		ИНАЧЕ ХозрасчетныйОбороты.Субконто3
	|	КОНЕЦ КАК Субконто
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&ДатаНачала,
	|			&ДатаОкончания,
	|			Регистратор,
	|			Счет.Код = ""91.01""
	|				ИЛИ Счет.Код = ""91.02.1""
	|				ИЛИ Счет.Код = ""91.03"",
	|			,
	|			Организация = &Организация
	|				И Субконто1 = &Субконто1,
	|			,
	|			) КАК ХозрасчетныйОбороты
	|ГДЕ
	|	ХозрасчетныйОбороты.Регистратор = &Регистратор";
	Запрос.УстановитьПараметр("ДатаНачала",	НачалоМинуты(Проводка.Период));	 
	Запрос.УстановитьПараметр("ДатаОкончания",Новый Граница(КонецМинуты(Проводка.Период),ВидГраницы.Включая));	 
	Запрос.УстановитьПараметр("Организация",Проводка.Организация);	 //Организация
	Запрос.УстановитьПараметр("Регистратор",ас_Регистратор);	 
	Запрос.УстановитьПараметр("Субконто1",ЗначениеСубконтоПрочиеДоходыИРасходы);	 
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();	
	
	Возврат ?(не РезультатЗапроса.Субконто = NULL, РезультатЗапроса.Субконто, Справочники.ас_ПериодыОтражения.ПустаяСсылка());
	
КонецФункции	
//\\АБС ВСТАВКА №38491 КОНЕЦ   