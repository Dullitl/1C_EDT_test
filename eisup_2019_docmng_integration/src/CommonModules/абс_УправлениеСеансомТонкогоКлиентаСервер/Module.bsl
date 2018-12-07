
Функция ПолучитьИнтервалПроверкиНаСервере() экспорт
	
	возврат Константы.абс_ИнтервалПроверкиСообщений.Получить();	
	
КонецФункции

Функция ПолучитьИнтервалПроверкиОповещения() экспорт
	
	возврат Константы.абс_ПроверкаОзнакомлений.Получить();	
	
КонецФункции

Функция ПолучитьИнтервалПроверкиСообщенийНаСервере() экспорт
	
	возврат Константы.абс_ПроверятьСообщенияНаСервере.Получить();	
	
КонецФункции

Процедура ВывестиСообщениеПользователю() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	абс_СообщенияПользователю.Пользователь,
	|	абс_СообщенияПользователю.Объект,
	|	абс_СообщенияПользователю.ДатаСообщения,
	|	абс_СообщенияПользователю.Отправлено,
	|	абс_СообщенияПользователю.Отправитель,
	|	абс_СообщенияПользователю.ТекстСообщения
	|ИЗ
	|	РегистрСведений.абс_СообщенияПользователю КАК абс_СообщенияПользователю
	|ГДЕ
	|	абс_СообщенияПользователю.Отправлено = ЛОЖЬ
	|	И абс_СообщенияПользователю.Пользователь = &ТекПользователь";
	
	Запрос.УстановитьПараметр("ТекПользователь",глЗначениеПеременной("глТекущийПользователь")); 	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДатаСтрокой = ?(НачалоДня(Выборка.ДатаСообщения)=НачалоДня(ТекущаяДата()),""+Час(Выборка.ДатаСообщения)+":"+Минута(Выборка.ДатаСообщения),Формат(Выборка.ДатаСообщения,"ДЛФ=D"));
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.Текст = ""+Выборка.Отправитель+"("+ДатаСтрокой+")
		|"+ Выборка.ТекстСообщения;
		Сообщение.КлючДанных = Выборка.Объект;
		Сообщение.Сообщить();
		
		КлючЗаписи = РегистрыСведений.абс_СообщенияПользователю.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(КлючЗаписи,Выборка);
		КлючЗаписи.Прочитать();
		КлючЗаписи.Отправлено=Истина;
		КлючЗаписи.Записать(истина);
	КонецЦикла;
		
КонецПроцедуры

Функция  ПроверкаСеансаПользователя() Экспорт
	Если Константы.абс_ОграничениеСеансовWeb.Получить() Тогда
		ТекущийНомерСоединения = НомерСеансаИнформационнойБазы();
		УникальныйИдентификаторПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
		
		МассивСоединений = ПолучитьСеансыИнформационнойБазы();
		Для Каждого ТекСоединение Из МассивСоединений Цикл
			
			Если (ТекСоединение.ИмяПриложения = "WebClient" ИЛИ ТекСоединение.ИмяПриложения = "1CV8C") 
				И (НЕ ТекСоединение.НомерСеанса = ТекущийНомерСоединения)
				И (НЕ ТекСоединение.Пользователь = неопределено)
				И (ТекСоединение.Пользователь.УникальныйИдентификатор = УникальныйИдентификаторПользователя) Тогда
				
				//Предупреждение("Пользователем с таким именем уже выполнен вход в систему");
				
				
				Возврат Ложь;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Истина;	
КонецФункции

Функция ПолучитьФайлССервера(СсылкаНаФайл, НаименованиеФайла)  Экспорт
	
	ДвоичныеДанные = абс_РаботаСФайлами.ПолучитьФайлИзВнешнегоХранилища(СсылкаНаФайл);
	
	Если ДвоичныеДанные = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка 
		АдресХранилища = "";	
		АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		
		НаименованиеФайла = СсылкаНаФайл.Наименование;

	Исключение
		ttk_ОбщегоНазначения.СообщитьОбОшибке("Ошибка при получении файла из хранилища.");
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат АдресХранилища;
			
КонецФункции

Функция ПолучитьФайлHTML() Экспорт
Возврат Справочники.ХранилищеДополнительнойИнформации.НайтиПоНаименованию("Soobshenie.htm",Истина);	
КонецФункции

//АБС ВСТАВКА 37725  17.01.2014 20:10:28  Шамов
Функция ПолучитьТекущиеЗначенияПараметрыКонтроляЗавершенияРаботы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	абс_ПользователиИсключенияПроверкиЗавершенияРаботы.Пользователь
		|ИЗ
		|	РегистрСведений.абс_ПользователиИсключенияПроверкиЗавершенияРаботы КАК абс_ПользователиИсключенияПроверкиЗавершенияРаботы
		|ГДЕ
		|	абс_ПользователиИсключенияПроверкиЗавершенияРаботы.ОтключитьПроверку
		|	И абс_ПользователиИсключенияПроверкиЗавершенияРаботы.Пользователь = &ТекущийПользователь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Константы.абс_ИспользоватьТаймаутЗавершенияРаботы,
		|	Константы.абс_ИнтервалПроверкиЗавершенияРаботы,
		|	Константы.абс_ТаймаутЗавершенияРаботы
		|ИЗ
		|	Константы КАК Константы";

	Запрос.УстановитьПараметр("ТекущийПользователь", глЗначениеПеременной("глТекущийПользователь"));
	
	Результаты = Запрос.ВыполнитьПакет();	
	
	ЭтоИсключение = НЕ Результаты[0].Пустой();	
	НаборКонстант = Результаты[1].Выгрузить()[0];
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ЭтоИсключение", ЭтоИсключение);
	СтруктураПараметров.Вставить("абс_ИспользоватьТаймаутЗавершенияРаботы", НаборКонстант.абс_ИспользоватьТаймаутЗавершенияРаботы);
	СтруктураПараметров.Вставить("абс_ИнтервалПроверкиЗавершенияРаботы", НаборКонстант.абс_ИнтервалПроверкиЗавершенияРаботы);
	СтруктураПараметров.Вставить("абс_ТаймаутЗавершенияРаботы", НаборКонстант.абс_ТаймаутЗавершенияРаботы);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция абс_ПолучитьВремяПоследнейАктивностиТекущегоПользователя() Экспорт
	
	//ВремяПоследнейАктивности = Неопределено;
	//
	////получим время последней активности сеанса
	////через сом-соединение
	//ТекстМодуля = "
	//|УстановитьПривилегированныйРежим(Истина);
	//|СерверБазДанных = ""kttk-1c-app01"";
	//|База = ""1cworkdb"";   		
	//|Connector = Новый COMОбъект(""V82.COMConnector"");	
	//|AgentConnection = Connector.ConnectAgent(СерверБазДанных);
	//|Cluster = AgentConnection.GetClusters().GetValue(0);   	
	//|AgentConnection.Authenticate(Cluster, ""АБС-А"", ""absttksoft""); 
	//|Process = AgentConnection.GetSessions(Cluster);      
	//|НомерСеанса = НомерСеансаИнформационнойБазы();				 
	//|Для Каждого WorkingProcess Из Process Цикл
	//|	Если не НомерСеанса = WorkingProcess.SessionID 
	//|		или WorkingProcess.infoBase.Name <> База Тогда
	//|		Продолжить;
	//|	КонецЕсли;			
	//|	СтруктураПараметров = WorkingProcess.LastActiveAt();	
	//|	Прервать;
	//|КонецЦикла;
	//|УстановитьПривилегированныйРежим(Ложь);";
	//
	//Попытка
	//	абс_СерверныеФункции.ВыполнитьКодНаСервере(ТекстМодуля,ВремяПоследнейАктивности);
	//Исключение
	//	//не удалось
	//КонецПопытки;
	//
	//Если НЕ ВремяПоследнейАктивности = Неопределено Тогда
	//	Возврат ВремяПоследнейАктивности;
	//КонецЕсли;
	
	//получим последнюю активность по регистру истории открываемых объектов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	абс_ИсторияОткрываемыхОбъектовСрезПоследних.Период КАК Период
		|ИЗ
		|	РегистрСведений.абс_ИсторияОткрываемыхОбъектов.СрезПоследних(, Пользователь = &Пользователь) КАК абс_ИсторияОткрываемыхОбъектовСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ";

	Запрос.УстановитьПараметр("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	
	Результат = Запрос.Выполнить();	
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Период;
	Иначе
		Возврат '00010101';
	КонецЕсли;
	
КонецФункции

Функция абс_ОбновитьПараметрыКонтроляЗавершенияРаботыСервер(СтруктураПараметров) Экспорт
	
	Возврат абс_УправлениеСеансомТонкогоКлиентаСервер.ПолучитьТекущиеЗначенияПараметрыКонтроляЗавершенияРаботы();
		
КонецФункции

Функция абс_УстановитьПараметрыКонтроляЗавершенияРаботыСервер() Экспорт
		
	Возврат абс_УправлениеСеансомТонкогоКлиентаСервер.ПолучитьТекущиеЗначенияПараметрыКонтроляЗавершенияРаботы();
	
КонецФункции

Функция абс_ЗавершениеРаботыСервер(абс_ИнтервалПроверкиЗавершенияРаботы) Экспорт
	
	ТекущаяДата = абс_СерверныеФункции.ПолучитьДатуСервера();
	ВремяПоследнейАктивности = абс_УправлениеСеансомТонкогоКлиентаСервер.абс_ПолучитьВремяПоследнейАктивностиТекущегоПользователя();
	
	Если (ТекущаяДата - абс_ИнтервалПроверкиЗавершенияРаботы) < ВремяПоследнейАктивности Тогда
	//пользователь был активен в течение последнего интервала проверки
	//вопрос не выводим
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	Возврат Истина;
		
КонецФункции
//АБС ВСТАВКА 37725  КОНЕЦ
