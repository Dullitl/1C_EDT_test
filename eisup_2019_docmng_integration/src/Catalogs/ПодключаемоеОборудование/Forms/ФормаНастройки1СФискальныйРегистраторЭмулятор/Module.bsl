
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ФР'") + " """ + Строка(Идентификатор) + """";

	времНомерСекции = Неопределено;
	времКодСимволаЧастичногоОтреза = Неопределено;
	времМодель      = Неопределено;

	Параметры.Свойство("НомерСекции"               , времНомерСекции);
	Параметры.Свойство("КодСимволаЧастичногоОтреза", времКодСимволаЧастичногоОтреза);
	Параметры.Свойство("Модель"                    , времМодель);

	НомерСекции                = ?(времНомерСекции                = Неопределено, 0, времНомерСекции);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза = Неопределено, 22, времКодСимволаЧастичногоОтреза);
	Модель                     = ?(времМодель                     = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	Параметры.ПараметрыНастройки.Добавить(НомерСекции, "НомерСекции");
	Параметры.ПараметрыНастройки.Добавить(КодСимволаЧастичногоОтреза, "КодСимволаЧастичногоОтреза");
	Параметры.ПараметрыНастройки.Добавить(Модель     , "Модель");

	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	Драйвер = НСтр("ru='Не требуется'");
	Версия  = НСтр("ru='Не определена'");

КонецПроцедуры

