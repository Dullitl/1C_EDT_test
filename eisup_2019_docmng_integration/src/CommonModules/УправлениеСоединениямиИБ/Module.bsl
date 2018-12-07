////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ БЛОКИРОВКИ И ЗАВЕРШЕНИЯ СОЕДИНЕНИЙ С ИБ

// Устанавливает блокировку соединений ИБ.
//
// Параметры
//  ТекстСообщения  – Строка – текст, который будет частью сообщения об ошибке 
//                             при попытке установки соединения с заблокированной
//                             информационной базой.  
// 
//  КодРазрешения - Строка -   строка, которая должна быть добавлена к параметру 
//                             командной строки "/uc" или к параметру строки 
//                             соединения "uc", чтобы установить соединение с 
//                             информационной базой несмотря на блокировку. 
//
// Возвращаемое значение:
//   Булево   – результат завершения работы пользователей.
//
Процедура УстановитьБлокировкуСоединений(Знач ТекстСообщения = "", 
	Знач КодРазрешения = "КодРазрешения") Экспорт
	
	Блокировка = Новый БлокировкаУстановкиСоединений;
	Блокировка.Установлена = Истина;
	Блокировка.Начало = ТекущаяДата();
	Блокировка.КодРазрешения = КодРазрешения; 
	Блокировка.Сообщение = СфомироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
	УстановитьБлокировкуУстановкиСоединений(Блокировка);
	
КонецПроцедуры

// Определяет, установлена ли блокировка соединений при пакетном 
// обновлении конфигурации информационной базы
//
Функция УстановленаБлокировкаСоединений() Экспорт

	ТекущийРежим = ПолучитьБлокировкуУстановкиСоединений();
	Возврат ТекущийРежим.Установлена;

КонецФункции 
        
// Снять блокировку информационной базы
// после выполнения обновления
//
Процедура РазрешитьРаботуПользователей() Экспорт
	
	ТекущийРежим = ПолучитьБлокировкуУстановкиСоединений();
	Если ТекущийРежим.Установлена Тогда
		НовыйРежим = Новый БлокировкаУстановкиСоединений;
		НовыйРежим.Установлена = Ложь;
		УстановитьБлокировкуУстановкиСоединений(НовыйРежим);
	КонецЕсли;		
	
КонецПроцедуры	

// Устанавливает блокировку соединений при пакетном 
// обновлении конфигурации информационной базы
// Может вызываться из внешнего соединения.
Процедура УстановитьБлокировкуСоединенийПриОбновлении() Экспорт
	
	УстановитьБлокировкуСоединений("в связи с необходимостью обновления конфигурации.", 
	                               "ПакетноеОбновлениеКонфигурацииИБ");
	
КонецПроцедуры

// Отключить все активные соединения ИБ (кроме текущего сеанса).
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ.  
//
// Возвращаемое значение:
//   Булево   – результат отключения сединений.
//
Функция ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ) Экспорт

	Если ПолучитьСоединенияИнформационнойБазы().Количество() <= 1 Тогда
		Возврат Истина;	// Отключены все пользователи, кроме текущего сеанса
	КонецЕсли; 
	
	Если ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Сообщение = ПолучитьНазванияСоединенийИБ("Не удалось завершить работу пользователей:");
		ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Предупреждение, , , Сообщение);
#Если Клиент Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке(Сообщение);
#КонецЕсли
		Возврат Ложь;	// Невозможно принудительно отсоединить подключения в файловом режиме работы
	КонецЕсли;	
	
	Попытка
		
		Соединения = ПолучитьАктивныеСоединенияИБ(ПараметрыАдминистрированияИБ);
		Для Каждого Соединение Из Соединения.Соединения Цикл
			// Разрываем Connections с ИБ
			СтрСообщения = "Разрывается соединение: Пользователь " + Соединение.UserName + ", компьютер " + 
				Соединение.HostName + ", установлено " + Соединение.ConnectedAt + ", режим " + Соединение.AppID;
			ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Информация, , , СтрСообщения);
			Соединения.СоединениеСРабочимПроцессом.Disconnect(Соединение);
		КонецЦикла;
		
		Возврат ПолучитьСоединенияИнформационнойБазы().Количество() <= 1;
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
#Если Клиент Тогда
		ttk_ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки);
#КонецЕсли
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции 

#Если Клиент Тогда
	
// Процедура подключает обработчик ожижания КонтрольРежимаЗавершенияРаботыПользователей
// 
Процедура УстановитьКонтрольРежимаЗавершенияРаботыПользователей()  Экспорт
		
	РежимБлокировки = ПолучитьБлокировкуУстановкиСоединений();
	ТекущееВремя = ТекущаяДата();
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);	
	
КонецПроцедуры  

// Обработать параметры запуска, связанные с завершение и разрешениие соединений ИБ.
//
// Параметры
//  ЗначениеПараметраЗапуска  – Строка – главный параметр запуска
//  ПараметрыЗапуска          – Массив – дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   – Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска) Экспорт

	// Обработка параметров запуска программы - 
	// ЗапретитьРаботуПользователей и РазрешитьРаботуПользователей
	Если ЗначениеПараметраЗапуска = Врег("РазрешитьРаботуПользователей") Тогда
		
		Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
			Сообщить("Параметр запуска РазрешитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.", 
			         СтатусСообщения.Внимание);
			Возврат Ложь;
		КонецЕсли;   
		
		РазрешитьРаботуПользователей();
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Истина;

	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ЗавершитьРаботуПользователей") Тогда
		// Параметр может содержать две дополнительные части, разделенные символом ";" - 
		// имя и пароль администратора ИБ, от имени которого происходит подключение к кластеру серверов
		// в клиент-серверном варианте развертывания системы. Их необходимо передавать в случае, 
		// если текущий пользователь не является администратором ИБ.
		// См. использование в процедуре ЗавершитьРаботуПользователей().
		
		Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
			Сообщить("Параметр запуска ЗавершитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.", 
			         СтатусСообщения.Внимание);
			Возврат Ложь;
		КонецЕсли; 
		
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчки ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.   
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		УстановитьБлокировкуСоединений();
		ЗавершитьРаботуПользователей();
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 180);
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

#КонецЕсли

// Осуществляет попытку подключиться к кластеру серверов и получить список 
// активных соединений к ИБ и использованием указанных параметров администрирования.
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  ВыдаватьСообщения             – Булево    – разрешить вывод интерактивных сообщений.
//
// Возвращаемое значение:
//   Булево   – Истина, если проверка завершена успешно.
//
Функция ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ, Знач ВыдаватьСообщения = Истина) Экспорт

  Результат = Ложь;
	Попытка
		Соединения = ПолучитьАктивныеСоединенияИБ(ПараметрыАдминистрированияИБ);
		Результат = Истина;
	Исключение
		Сообщение = "Не удалось подключиться к кластеру серверов.";
		ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Ошибка,,, 
			Сообщение + Символы.ПС + ОписаниеОшибки());
#Если Клиент Тогда
		Если ВыдаватьСообщения Тогда
			Предупреждение(Сообщение + Символы.ПС + ИнформацияОбОшибке().Описание);
		КонецЕсли; 
#Иначе
		ВызватьИсключение Сообщение;
#КонецЕсли
		Результат = Ложь;
	КонецПопытки;
	Возврат Результат;
	
КонецФункции 

//////////////////////////////////////////////////////////////////////////////// 
// СЕРВИСНЫЕ ФУНКЦИИ 
//  

// Возвращает текст сообщения блокировки сеансов.
//
Функция СфомироватьСообщениеБлокировки(Знач Сообщение, Знач КодРазрешения) Экспорт

	ПараметрыАдминистрированияИБ = ПолучитьПараметрыАдминистрированияИБ();
	ПризнакФайловогоРежима = Ложь;
	ПутьКИБ = ПутьКИнформационнойБазе(ПризнакФайловогоРежима, ПараметрыАдминистрированияИБ.ПортКластераСерверов);
	СтрокаПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима = Истина, "/F", "/S") + ПутьКИБ; 
	ТекстСообщения = "";
	Если НЕ ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = Сообщение + Символы.ПС + Символы.ПС;
	КонецЕсли; 
	ТекстСообщения = ТекстСообщения +
		"Для администратора:" + Символы.ПС +
		"Чтобы принудительно разблокировать информационную базу, воспользуйтесь консолью кластера серверов или запустите ""1С:Предприятие"" с параметрами:" + Символы.ПС +
        "ENTERPRISE " + СтрокаПутиКИнформационнойБазе + " /CРазрешитьРаботуПользователей /UC" + КодРазрешения;
	Возврат ТекстСообщения;

КонецФункции 

// Возвращает пользовательский текст сообщения блокировки сеансов.
//
Функция ИзвлечьСообщениеБлокировки(Знач Сообщение) Экспорт

	ИндексМаркера = Найти(Сообщение, "Для администратора:");
	Возврат ?(ИндексМаркера > 0, Сред(Сообщение, 1, ИндексМаркера - 3), Сообщение);

КонецФункции 

Функция НовыеПараметрыАдминистрированияИБ(Знач ИмяАдминистратораИБ = "",
	Знач ПарольАдминистратораИБ = "", Знач ИмяАдминистратораКластера = "",
	Знач ПарольАдминистратораКластера = "", Знач ПортКластераСерверов = 0, 
	Знач ПортАгентаСервера = 0) Экспорт
	
	Возврат Новый Структура("ИмяАдминистратораИБ,
							|ПарольАдминистратораИБ,
							|ИмяАдминистратораКластера,
							|ПарольАдминистратораКластера,
							|ПортКластераСерверов,
							|ПортАгентаСервера",
							ИмяАдминистратораИБ,
							ПарольАдминистратораИБ,
							ИмяАдминистратораКластера,
							ПарольАдминистратораКластера,
							ПортКластераСерверов,
							ПортАгентаСервера);
	
КонецФункции

Функция ПолучитьНазванияСоединенийИБ(Знач Сообщение) Экспорт
	
	Результат = Сообщение;
	Для каждого Соединение Из ПолучитьСоединенияИнформационнойБазы() Цикл
		Если Соединение.НомерСоединения <> НомерСоединенияИнформационнойБазы() Тогда
			Результат = Результат + Символы.ПС + " - " + Соединение;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

// Получить интервал ожидания заверешения пользователей после установки
// блокировки информационной базы (в секундах).
// 
Функция ИнтервалОжиданияЗавершенияРаботыПользователей() Экспорт
	
	Возврат 5 * 60;	// 5 минут
	
КонецФункции

// Получить сохраненные параметры администрирования кластера серверов.
//
Функция ПолучитьПараметрыАдминистрированияИБ() Экспорт

	СтруктураНастроек = Константы.ПараметрыАдминистрированияИБ.Получить().Получить();
	Если ТипЗнч(СтруктураНастроек) <> Тип("Структура") Тогда
		Возврат НовыеПараметрыАдминистрированияИБ();
	Иначе	
		Параметры = НовыеПараметрыАдминистрированияИБ();
		ЗаполнитьЗначенияСвойств(Параметры, СтруктураНастроек);
		Возврат Параметры;
	КонецЕсли;
	
КонецФункции 

Процедура ЗаписатьПараметрыАдминистрированияИБ(Параметры) Экспорт
	
	Константы.ПараметрыАдминистрированияИБ.Установить(Новый ХранилищеЗначения(Параметры));
	
КонецПроцедуры

Функция ПолучитьАктивныеСоединенияИБ(НастройкаБлокировки, Знач ВсеКромеТекущего = Истина) 

	Результат = Новый Структура("СоединениеСРабочимПроцессом,Соединения", Неопределено, Новый Массив);
	Если ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение "Невозможно получить список активных соединения в Файловом варианте системы";
	КонецЕсли;	
	
	ПодстрокиСтрокиСоединения  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СтрокаСоединенияИнформационнойБазы(), ";");
		
	ИмяСервера = СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[0], 7));
	ИмяИБ      = СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[1], 6));
	
	ComConnector = Новый COMОбъект(ИмяCOMСоединителя());
	
	РазделительПорта = Найти(ИмяСервера, ":");
	Если РазделительПорта > 0 Тогда
		ИмяИПортСервера = ИмяСервера;
		ИмяСервера = Сред(ИмяИПортСервера, 1, РазделительПорта - 1);
		НомерПортаКластера = Число(Сред(ИмяИПортСервера, РазделительПорта + 1));
	ИначеЕсли НастройкаБлокировки.ПортКластераСерверов <> 0 Тогда
		НомерПортаКластера = НастройкаБлокировки.ПортКластераСерверов;
	Иначе		
		НомерПортаКластера = ComConnector.RMngrPortDefault;
	КонецЕсли;
	
	ИдентификаторАгентаСервера = ИмяСервера;
	Если НастройкаБлокировки.ПортАгентаСервера <> 0 Тогда
	      ИдентификаторАгентаСервера = ИдентификаторАгентаСервера + ":" + 
		  	Формат(НастройкаБлокировки.ПортАгентаСервера, "ЧГ=0");
	КонецЕсли; 
	
	// Подключение к агенту сервера
	ServerAgent = ComConnector.ConnectAgent(ИдентификаторАгентаСервера);
	
	// Найдем необходимый нам кластер
	Для Каждого Кластер Из ServerAgent.GetClusters() Цикл
		
		Если Кластер.MainPort <> НомерПортаКластера Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(НастройкаБлокировки.ИмяАдминистратораКластера) Тогда
			ServerAgent.Authenticate(Кластер, НастройкаБлокировки.ИмяАдминистратораКластера, 
				НастройкаБлокировки.ПарольАдминистратораКластера);
		КонецЕсли;
			
		// Получаем список рабочих процессов
		WorkingProcesses = ServerAgent.GetWorkingProcesses(Кластер);
		Для Каждого WorkingProcess Из WorkingProcesses Цикл
			
			Если WorkingProcess.Running <> 1 Тогда
				Продолжить;
			КонецЕсли;
			
			// Для каждого рабочего процесса создаем соединение с рабочим процессом
			ConnectToWorkProcess = ComConnector.ConnectWorkingProcess("tcp://" + WorkingProcess.HostName + 
				":" + Формат(WorkingProcess.MainPort, "ЧГ=0"));
			ConnectToWorkProcess.AddAuthentication(НастройкаБлокировки.ИмяАдминистратораИБ, 
				НастройкаБлокировки.ПарольАдминистратораИБ);
			Результат.СоединениеСРабочимПроцессом = ConnectToWorkProcess;
			// Получаем список ИБ рабочего процесса
			InfoBases = ConnectToWorkProcess.GetInfoBases();
			Для Каждого InfoBase Из InfoBases Цикл
				// Ищем нужную базу
				Если ВРег(InfoBase.Name) <> ВРег(ИмяИБ) Тогда
					Продолжить;
				КонецЕсли;
					
				// Получаем массив соединений с ИБ
				Connections = ConnectToWorkProcess.GetInfoBaseConnections(InfoBase);
				Для Каждого Connection Из Connections Цикл
					Если НЕ ВсеКромеТекущего ИЛИ (НомерСоединенияИнформационнойБазы() <> connection.ConnID) Тогда
						Результат.Соединения.Добавить(connection);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

// Получить строку соединения ИБ, если задан нестандартный порт кластера серверов.
//
// Параметры
//  ПортКластераСерверов  - Число - нестандартный порт кластера серверов
//
// Возвращаемое значение:
//   Строка   - строка соединения ИБ
//
Функция ПолучитьСтрокуСоединенияИнформационнойБазы(Знач ПортКластераСерверов = 0) Экспорт

	Результат = СтрокаСоединенияИнформационнойБазы();
	Если ОпределитьЭтаИнформационнаяБазаФайловая() ИЛИ (ПортКластераСерверов = 0) Тогда
		Возврат Результат;
	КонецЕсли; 
	
	ПодстрокиСтрокиСоединения  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Результат, ";");
	ИмяСервера = СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[0], 7));
	ИмяИБ      = СократитьДвойныеКавычки(Сред(ПодстрокиСтрокиСоединения[1], 6));
	Результат  = "Srvr=" + """" + ИмяСервера + ":" + 
		Формат(ПортКластераСерверов, "ЧГ=0") + """;" + 
		"Ref=" + """" + ИмяИБ + """;";
	Возврат Результат;

КонецФункции 

// Определение пути к информационной базе
//
Функция ПутьКИнформационнойБазе(ПризнакФайловогоРежима = Неопределено, Знач ПортКластераСерверов = 0) Экспорт
	
	СтрокаСоединения = ПолучитьСтрокуСоединенияИнформационнойБазы(ПортКластераСерверов);
	
	ПозицияПоиска = Найти(Врег(СтрокаСоединения), "FILE=");
	
	Если ПозицияПоиска = 1 Тогда // файловая ИБ
		
		ПутьКИБ = Сред(СтрокаСоединения, 6, СтрДлина(СтрокаСоединения) - 6);
		ПризнакФайловогоРежима = Истина;
		
	Иначе
		ПризнакФайловогоРежима = Ложь;
		
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "SRVR=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		НачальнаяПозицияКопирования = 6 + 1;
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2; 
		
		ИмяСервера = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		СтрокаСоединения = Сред(СтрокаСоединения, ПозицияТочкиСЗапятой + 1);
		
		// позиция имени сервера
		ПозицияПоиска = Найти(Врег(СтрокаСоединения), "REF=");
		
		Если НЕ (ПозицияПоиска = 1) Тогда
			Возврат Неопределено;
		КонецЕсли;
				
		НачальнаяПозицияКопирования = 6;
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединения, ";");
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2; 
		
		ИмяИБНаСервере = Сред(СтрокаСоединения, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования - НачальнаяПозицияКопирования + 1);
		
		ПутьКИБ = """" + ИмяСервера + "\" + ИмяИБНаСервере + """";				
	КонецЕсли;
	
	Возврат ПутьКИБ;
	
КонецФункции

Функция СократитьДвойныеКавычки(Знач Строка)

	Результат = Строка;
	Пока Найти(Результат, """") = 1 Цикл
		Результат = Сред(Результат, 2); 
	КонецЦикла; 
	Пока Найти(Результат, """") = СтрДлина(Результат) Цикл
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 1); 
	КонецЦикла; 
	Возврат Результат;

КонецФункции 

// Вернуть имя COM-класса для работы с 1С:Предприятием 8 через COM-соединение.
Функция ИмяCOMСоединителя() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	ПодстрокиВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СисИнфо.ВерсияПриложения, ".");
	Возврат "v" + ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + ".COMConnector";
	
КонецФункции	
