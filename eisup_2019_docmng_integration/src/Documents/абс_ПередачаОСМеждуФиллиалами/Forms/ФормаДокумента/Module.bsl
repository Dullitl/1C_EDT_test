
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСтатус = Объект.Статус;
	мСтарыйСтатус = Объект.Статус;
	ЭтоНовый = Параметры.Ключ.Пустая();
	ЗаполнитьСписокДоступныхСтатусов();
	ЗаполнитьОСПриемник();
// {{KM WARE Лазаревский К.В. Заявка № 17.09.2015 начало
// Редактирование докуметнов на основании АВИЗО по роли
	РолиДляРедактирование = Новый Массив;
	РолиДляРедактирование.Добавить(Справочники.РолиИсполнителей.АВИЗО_РедактированиеИсточникаПолучателя);

	этаформа.ДоступноРедактирование = абс_БизнесПроцессы.ПолучитьДоступныеОрганизацииПоРоли(РолиДляРедактирование, глЗначениеПеременной("глТекущийПользователь"));
// }}KM WARE Лазаревский К.В. Заявка № 17.09.2015 окончание 		
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если мСтарыйСтатус <> Объект.Статус И  Объект.Статус = Перечисления.абс_СтатусыПередачаОСМеждуФиллиалами.Завершен Тогда 
		
		ДокуметнОбъект = Объект.ДокументСписаниеОС.ПолучитьОбъект();
		Попытка
			ДокуметнОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить("Не удалось провести документ: " + ДокуметнОбъект.Ссылка);
		КонецПопытки;

		ДокуметнОбъект = Объект.ДокументВводОстатковОС.ПолучитьОбъект();
		Попытка
			ДокуметнОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить("Не удалось провести документ: " + ДокуметнОбъект.Ссылка);
		КонецПопытки;
		
	КонецЕсли;
	
	Если мСтарыйСтатус <> Объект.Статус ИЛИ ЭтоНовый Тогда
		СтрокаПричиныИзмененияСтатуса = "";
		
		Если НЕ ЭтоНовый Тогда
			СтрокаПричиныИзмененияСтатуса = "";
		Иначе	
			СтрокаПричиныИзмененияСтатуса = "Ввод нового документа";
		КонецЕсли;
		
		
		мСтарыйСтатус = Объект.Статус;	
		ЭтоНовый = Ложь;
		
		ЗаписатьСтатусВРегистр(Объект.Ссылка, Объект.Статус, СтрокаПричиныИзмененияСтатуса);
		
	КонецЕсли;
	
	ЗаполнитьСписокДоступныхСтатусов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	УстанокаВидимости();
	
	 Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		 Если абс_БизнесПроцессыПривелегированный.ПолучитьАвизо(Новый Структура("СсылкаНаОбъект",Объект.Ссылка)) <> Неопределено И НЕ этаформа.ДоступноРедактирование Тогда
			 ЭтаФорма.ТолькоПросмотр = Истина;
			 Элементы.Статус.ТолькоПросмотр = Истина;
		 КонецЕсли; 
	 КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстанокаВидимости();
	ЗаполнитьОСПриемник();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ


&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
			
	Если ЗначениеЗаполнено(мСтатус) Тогда 
		Объект.Статус = мСтатус;
	КонецЕсли;
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура Файлы(Команда)
	
	//Если Параметры.Ключ.Пустая() Тогда
	//	Ответ = Вопрос("Для выполнения данной операции необходимо записать документ. Записать?", РежимДиалогаВопрос.ДаНет);
	//	Если Ответ = КодВозвратаДиалога.Да Тогда
	//		Записать();
	//	Иначе
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//СтруктураДляСпискаИзображдений = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	//СтруктураДляСпискаДополнительныхФайлов = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	//ОбязательныеОтборы = Новый Структура("Объект", Объект.Ссылка);
	//
	//РаботаСФайлами.ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображдений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИсторияСтатусов(Команда)
		
	ЗначениеОтбора = Новый Структура("Документ", Объект.Ссылка);
	ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
	ОткрытьФорму("РегистрСведений.абс_ИсторияСтатусовПередачаОСМеждуФиллиалами.ФормаСписка", ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиБух(Команда)
	
	Форма = ПолучитьФорму("РегистрБухгалтерии.Хозрасчетный.ФормаСписка");
	Форма.Отбор.Регистратор.ВидСравнения = ВидСравнения.ВСписке;
	Форма.Отбор.Регистратор.Значение.Добавить(Объект.ДокументВводОстатковОС);
	Форма.Отбор.Регистратор.Значение.Добавить(Объект.ДокументСписаниеОС);
	Форма.Отбор.Регистратор.Использование = Истина;
	Форма.Открыть();
	
КонецПроцедуры


 ////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ КЛИЕНТСКИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ВвестиСтрокуНаКлиенте()
	
	СтрокаВвода = "";
	ВвестиСтроку(СтрокаВвода,"Введите причину изменения статуса",,Истина);
	Возврат СтрокаВвода;
	
КонецФункции

 ////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ДоступнаРольИсполнителя(Роль, Организация)
  
  	РольДоступнаПользователю = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РолиИИсполнители.Роль
		|ИЗ
		|	РегистрСведений.РолиИИсполнители КАК РолиИИсполнители
		|ГДЕ
		|	РолиИИсполнители.Исполнитель = &Исполнитель
		|	И РолиИИсполнители.Роль = &Роль
		|	И ВЫБОР
		|			КОГДА &ДЗО
		|				ТОГДА РолиИИсполнители.Организация = &Организация
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ";

	Запрос.УстановитьПараметр("Исполнитель", глЗначениеПеременной("глТекущийПользователь"));
	
	//Если Организация. Тогда
	//
	//	
	//
	//КонецЕсли;
	
	//Если Роль = Справочники.РолиИсполнителей.ОтветственныйОСДЗО и ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("ДЗО",Истина);
	//Иначе
	//	Запрос.УстановитьПараметр("ДЗО",Ложь);
	//КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Роль",Роль);

	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	//ВыборкаДетальныеЗаписи = Результат.Выбрать();

	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	РольДоступнаПользователю = Истина;
	//КонецЦикла;
	//
	//Возврат РольДоступнаПользователю;
	 
КонецФункции 

&НаСервере
Процедура ЗаполнитьСписокДоступныхСтатусов()
	
	Статус = Объект.Статус;
	Статусы = Перечисления.абс_СтатусыПередачаОСМеждуФиллиалами;
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Статус);
	РольСогласованиеБухгалетромППД = ДоступнаРольИсполнителя(Справочники.РолиИсполнителей.СогласованиеБухгалтеромППД, Объект.ОрганизацияИсточник); 
	РольСогласованиеБухгалетром = ДоступнаРольИсполнителя(Справочники.РолиИсполнителей.СогласованиеБухгалтером, Объект.ОрганизацияИсточник); 
	
	Если НЕ Параметры.Ключ.Пустая() Тогда	
		
		Если Статус = Статусы.Подготовка Тогда
			МассивСтатусов.Добавить(Статусы.ОбработкаБухгалтером);
		КонецЕсли;
		
		Если (Статус = Статусы.ОбработкаБухгалтером) И (РольСогласованиеБухгалетром ИЛИ РольСогласованиеБухгалетромППД) Тогда
			МассивСтатусов.Добавить(Статусы.ОбработкаФилиалом);
			МассивСтатусов.Добавить(Статусы.Отказ);
		КонецЕсли;
		
		Если (Статус = Статусы.ОбработкаФилиалом) Тогда
			МассивСтатусов.Добавить(Статусы.Завершен);
			МассивСтатусов.Добавить(Статусы.Отказ);
		КонецЕсли;
		
		Если (Статус = Статусы.Корректировка) И (РольСогласованиеБухгалетром ИЛИ РольСогласованиеБухгалетромППД) Тогда
			МассивСтатусов.Добавить(Статусы.Завершен);
			МассивСтатусов.Добавить(Статусы.Отказ);
		КонецЕсли;
		
		Если Статус = Статусы.Завершен Тогда
			МассивСтатусов.Добавить(Статусы.Корректировка);
		КонецЕсли;

	КонецЕсли;
	
	Элементы.Статус.СписокВыбора.ЗагрузитьЗначения(МассивСтатусов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьСтатусВРегистр(Ссылка, Статус, СтрокаПричиныИзмененияСтатуса)
		
	НаборЗаписей = РегистрыСведений.абс_ИсторияСтатусовПередачаОСМеждуФиллиалами.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период               = абс_СерверныеФункции.ПолучитьДатуСервера();
	
	Запись.Документ				= Ссылка;
	Запись.Пользователь	 		= глЗначениеПеременной("глТекущийПользователь");	
	Запись.Статус 		   		= Статус;	
	Запись.Комментарий 			= СтрокаПричиныИзмененияСтатуса;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОС(Команда)
	
	Если Объект.Проведен Тогда
		Предупреждение("Заполнение возможно только в непроведенном документе.");
		Возврат;
	КонецЕсли;

	Если Вопрос("При заполнении существующие данные будут пересчитаны! Продолжить?", 
		        РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОСНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОСНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация",     Объект.ОрганизацияИсточник);
	Запрос.УстановитьПараметр("ВнешнийИсточник", Объект.ОС.Выгрузить());
	Запрос.УстановитьПараметр("Период",          Объект.Дата);
	
	ОтражатьВУправленческомУчете = Истина;
	ОтражатьВБухгалтерскомУчете = Истина;
	ОтражатьВНалоговомУчете = Истина;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	ОсновноеСредство
	|ПОМЕСТИТЬ ОсновныеСредства
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеСредства.ОсновноеСредство                                     КАК ОсновноеСредство,
	|	АмортизацияБухгалтерскийУчетОстатки.Организация                       КАК Организация,
	|	АмортизацияОстатки.ОсновноеСредство                                   КАК ОС_УУ,
	|	АмортизацияБухгалтерскийУчетОстатки.ОсновноеСредство                  КАК ОС_БУ,
	|	АмортизацияНалоговыйУчетОстатки.ОсновноеСредство                      КАК ОС_НУ,
	|	АмортизацияОстатки.СтоимостьОстаток                                   КАК Стоимость,
	|	АмортизацияБухгалтерскийУчетОстатки.СтоимостьОстаток                  КАК СтоимостьБУ,
	|	АмортизацияНалоговыйУчетОстатки.СтоимостьОстаток                      КАК СтоимостьНУ,
	|	АмортизацияОстатки.АмортизацияОстаток                                 КАК Амортизация,
	|	АмортизацияБухгалтерскийУчетОстатки.АмортизацияОстаток                КАК АмортизацияБУ,
	|	АмортизацияНалоговыйУчетОстатки.АмортизацияОстаток                    КАК АмортизацияНУ,
	|	ОсновныеСредстваСписанныеНаЗатратыОстатки.ОсновноеСредство            КАК ОС_НаЗатратыУУ,
	|	ОсновныеСредстваСписанныеНаЗатратыОрганизацииОстатки.ОсновноеСредство КАК ОС_НаЗатратыБУ,
	|	ОсновныеСредстваСписанныеНаЗатратыОстатки.СтоимостьОстаток            КАК СтоимостьНаЗатраты,
	|	ОсновныеСредстваСписанныеНаЗатратыОрганизацииОстатки.СтоимостьОстаток КАК СтоимостьНаЗатратыБУ
	|ИЗ
	|	ОсновныеСредства
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОСБухгалтерскийУчет.Остатки(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства) И Организация = &Организация) КАК АмортизацияБухгалтерскийУчетОстатки
	|	ПО ОсновныеСредства.ОсновноеСредство = АмортизацияБухгалтерскийУчетОстатки.ОсновноеСредство
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОС.Остатки(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства)) КАК АмортизацияОстатки
	|	ПО ОсновныеСредства.ОсновноеСредство = АмортизацияОстатки.ОсновноеСредство
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОССписанныеНаЗатраты.Остатки(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства)) КАК ОсновныеСредстваСписанныеНаЗатратыОстатки
	|	ПО ОсновныеСредства.ОсновноеСредство = ОсновныеСредстваСписанныеНаЗатратыОстатки.ОсновноеСредство
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОССписанныеНаЗатратыОрганизаций.Остатки(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства) И Организация = &Организация) КАК ОсновныеСредстваСписанныеНаЗатратыОрганизацииОстатки
	|	ПО ОсновныеСредства.ОсновноеСредство = ОсновныеСредстваСписанныеНаЗатратыОрганизацииОстатки.ОсновноеСредство
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОСНалоговыйУчет.Остатки(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства) И Организация = &Организация) КАК АмортизацияНалоговыйУчетОстатки
	|	ПО ОсновныеСредства.ОсновноеСредство = АмортизацияНалоговыйУчетОстатки.ОсновноеСредство
	|";
	ТЗ = Запрос.Выполнить().Выгрузить();

	ТаблицаАмортизацииУпр = Новый ТаблицаЗначений();
	ТаблицаАмортизацииБух = Новый ТаблицаЗначений();

	Если ТЗ.Количество()>0 Тогда

		СписокОС = ТЗ.ВыгрузитьКолонку("ОсновноеСредство");
		
		Если ОтражатьВУправленческомУчете Тогда
			ТаблицаАмортизацииУпр = УправлениеВнеоборотнымиАктивами.РасчетАмортизацииУпр(Объект.Дата, СписокОС);
		КонецЕсли;

		Если ОтражатьВБухгалтерскомУчете Тогда
			ТаблицаАмортизацииБух = УправлениеВнеоборотнымиАктивами.РасчетАмортизацииБухРегл(Объект.Дата, Объект.ОрганизацияИсточник, СписокОС);
		КонецЕсли;

		Если ОтражатьВНалоговомУчете Тогда
			ТаблицаАмортизацииНал = УправлениеВнеоборотнымиАктивами.РасчетАмортизацииНалогРегл(Объект, Объект.Дата, Объект.ОрганизацияИсточник, СписокОС);
		КонецЕсли;

		Для каждого Строка Из Объект.ОС Цикл

			СтрокаТЗ = ТЗ.Найти(Строка.ОсновноеСредство,"ОС_БУ,ОС_УУ, ОС_НУ, ОС_НаЗатратыУУ,ОС_НаЗатратыБУ");

			Если СтрокаТЗ = Неопределено Тогда

				Если ОтражатьВУправленческомУчете Тогда

					Строка.Стоимость          = 0;
					Строка.Амортизация        = 0;
					Строка.АмортизацияЗаМесяц = 0;
					Строка.СписаноНаЗатраты   = Ложь;

				КонецЕсли;

				Если ОтражатьВБухгалтерскомУчете Тогда

					Строка.СтоимостьБУ          = 0;
					Строка.АмортизацияБУ        = 0;
					Строка.АмортизацияЗаМесяцБУ = 0;
					Строка.СписаноНаЗатратыБУ   = Ложь;

				КонецЕсли;

				Если ОтражатьВНалоговомУчете Тогда

					Строка.СтоимостьНУ                                  = 0;
					Строка.АмортизацияНУ                                = 0;
					Строка.АмортизацияЗаМесяцНУ                         = 0;
					Строка.СуммаКапитальныхВложенийВключаемыхВРасходыНУ = 0;

				КонецЕсли;

			Иначе

				// В соответствующие поля строки запишем данные из запроса
				Если ОтражатьВУправленческомУчете Тогда

					Если СтрокаТЗ.СтоимостьНаЗатраты = NULL Тогда

						Строка.Стоимость            = СтрокаТЗ.Стоимость;
						Строка.Амортизация          = СтрокаТЗ.Амортизация;
						СтрокаТаблицаАмортизацииУпр = ТаблицаАмортизацииУпр.Найти(Строка.ОсновноеСредство,"ОС");
						Строка.АмортизацияЗаМесяц   = ?(СтрокаТаблицаАмортизацииУпр = Неопределено,0,СтрокаТаблицаАмортизацииУпр.Упр);
						Строка.СписаноНаЗатраты     = Ложь;

						
						Если Строка.ТекущаяСтоимость = 0 Тогда
							Строка.ТекущаяСтоимость = Строка.Стоимость;
						КонецЕсли;
						
					Иначе

						Строка.Стоимость          = СтрокаТЗ.СтоимостьНаЗатраты;
						Строка.Амортизация        = 0;
						Строка.АмортизацияЗаМесяц = 0;
						Строка.СписаноНаЗатраты   = Истина;

					КонецЕсли;

				КонецЕсли;

				Если ОтражатьВБухгалтерскомУчете Тогда

					Если СтрокаТЗ.СтоимостьНаЗатратыБУ = NULL Тогда

						Строка.СтоимостьБУ          = СтрокаТЗ.СтоимостьБУ;
						Строка.АмортизацияБУ        = СтрокаТЗ.АмортизацияБУ;
						СтрокаТаблицаАмортизацииБух = ТаблицаАмортизацииБух.Найти(Строка.ОсновноеСредство,"ОС");
						Строка.АмортизацияЗаМесяцБУ = ?(СтрокаТаблицаАмортизацииБух = Неопределено,0,СтрокаТаблицаАмортизацииБух.Бух);
						Строка.СписаноНаЗатратыБУ   = Ложь;

						Если Строка.ТекущаяСтоимостьБУ = 0 Тогда
							Строка.ТекущаяСтоимостьБУ = Строка.СтоимостьБУ;
						КонецЕсли;
						
					Иначе

						Строка.СтоимостьБУ = СтрокаТЗ.СтоимостьНаЗатратыБУ;
						Строка.АмортизацияБУ        = 0;
						Строка.АмортизацияЗаМесяцБУ = 0;
						Строка.СписаноНаЗатратыБУ   = Истина;

					КонецЕсли;

				КонецЕсли;

				Если ОтражатьВНалоговомУчете Тогда

					Строка.СтоимостьНУ                                  = СтрокаТЗ.СтоимостьНУ;
					Строка.АмортизацияНУ                                = СтрокаТЗ.АмортизацияНУ;
					СтрокаТаблицаАмортизацииНал                         = ТаблицаАмортизацииНал.Найти(Строка.ОсновноеСредство,"ОС");
					Строка.АмортизацияЗаМесяцНУ                         = ?(СтрокаТаблицаАмортизацииНал = Неопределено,0,СтрокаТаблицаАмортизацииНал.Налог);
					Строка.СуммаКапитальныхВложенийВключаемыхВРасходыНУ = ?(СтрокаТаблицаАмортизацииНал = Неопределено,0,СтрокаТаблицаАмортизацииНал.СуммаКапитальныхВложенийВключаемыхВРасходы);
					
						Если Строка.ТекущаяСтоимостьНУ = 0 Тогда
							Строка.ТекущаяСтоимостьНУ = Строка.СтоимостьНУ;
						КонецЕсли;
					
				КонецЕсли;

			КонецЕсли;

		КонецЦикла;

	Иначе

		Сообщить("Данные для заполнения отсутствуют.");

	КонецЕсли;
	
	//Для каждого строка из Объект.ОС Цикл 
	//		строка.ТекущаяСтоимость  = строка.Стоимость - строка.Амортизация - строка.АмортизацияЗаМесяц;
	//		строка.ТекущаяСтоимостьБУ = строка.СтоимостьБУ - строка.АмортизацияБУ - строка.АмортизацияЗаМесяцБУ;
	//		строка.ТекущаяСтоимостьНУ = строка.СтоимостьНУ - строка.АмортизацияНУ - строка.АмортизацияЗаМесяцНУ;
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстанокаВидимости()
	
	ТолькоПросмотр = (Объект.Статус <> Перечисления.абс_СтатусыПередачаОСМеждуФиллиалами.Подготовка);	
	Для Каждого элемент Из Элементы Цикл 
		
		Если НЕ (элемент.Имя = "ГруппаШапка" 
			ИЛИ элемент.Имя = "ГруппаШапкаПравая" 
			ИЛИ  элемент.Имя = "Статус"
			ИЛИ  элемент.Имя = "ФормаКоманднаяПанель"
			ИЛИ  элемент.Имя = "ФормаЗаписатьИЗакрыть"   
			ИЛИ  элемент.Имя = "ФормаЗаписать"
			ИЛИ ТипЗнч(элемент) = тип("КнопкаКоманднойПанели") 
			ИЛИ ТипЗнч(элемент) = тип("КнопкаФормы")
			ИЛИ ТипЗнч(элемент) = тип("УправляемаяФорма")) Тогда
			    // Start КТТК Ермолов Е.Л.  30.05.2016 
				Попытка
			   
			   	
				   элемент.ТолькоПросмотр = ТолькоПросмотр;
			   
			   Исключение
			   
			   КонецПопытки;
			   // Stop КТТК Ермолов Е.Л.  30.05.2016
		КонецЕсли;
		
	КонецЦикла;
	
	Если Объект.Статус <> Перечисления.абс_СтатусыПередачаОСМеждуФиллиалами.ОбработкаФилиалом
// {{KM WARE Лазаревский К.В. Заявка № 23.09.2015 начало
		Или этаформа.ДоступноРедактирование 
// }}KM WARE Лазаревский К.В. Заявка № 23.09.2015 окончание 		
		Тогда
		Элементы.абс_ОбособленноеПодразделение.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	ЭтаФорма.ТолькоПросмотр = Ложь;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОСПриемник()
	
	Для Каждого Строка из Объект.ОС Цикл 
		Строка.ОсновноеСредствоПриемник = Документы.абс_ПередачаОСМеждуФиллиалами.НайтиОСПриемник(Строка.ОсновноеСредство, Строка.ОсновноеСредствоПриемник);	
	КонецЦикла;
	
КонецПроцедуры



