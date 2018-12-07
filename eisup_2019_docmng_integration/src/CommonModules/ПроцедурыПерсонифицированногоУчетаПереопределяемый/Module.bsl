

Функция СЗВ4_ПолучитьДополнительныеУсловияДляСотрудников(СинонимТаблицы="") Экспорт
	
	Возврат "";
	
КонецФункции //СЗВ4_ПолучитьДополнительныеУсловияДляСотрудников()

// По описанию периода времени с точки зрения учета времени и учета для ФСС
// определяем порядок включения периода в страховой стаж для назначения трудовой пенсии
//
// Параметры
//  ВидПособияСоциальногоСтрахования		- ПеречислениеСсылка.ВидыПособийСоциальногоСтрахования
//									порядок учета периода и начисленных сумм для ФСС
//  ВидВремени								- ПеречислениеСсылка.ВидыВремени
// 									характеристика периода времени
//  ОбозначениеВТабелеУчетаРабочегоВремени	- СправочникСсылка.КлассификаторИспользованияРабочегоВремени
//									код отображения периода в Табеле Т-13
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыСтажаСЗВ4 - характеристика периода в терминах перс.учета ПФР
//
Функция ПолучитьПорядокВключенияПериодаВСтраховойСтаж(ВидПособияСоциальногоСтрахования = Неопределено, ВидВремени = Неопределено, ОбозначениеВТабелеУчетаРабочегоВремени = Неопределено) Экспорт 
	
	ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ПустаяСсылка();
	
	Если ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.БеременностьРоды Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.Декрет;
	ИначеЕсли ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.ПоУходуЗаРебенкомДоПолутораЛет Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.Дети;
	ИначеЕсли ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.Нетрудоспособность
		ИЛИ ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай
		ИЛИ ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ВременнаяНетрудоспособность;
	ИначеЕсли ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.ДополнительныеВыходныеДниПоУходуЗаДетьмиИнвалидами
		ИЛИ ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ВключаетсяВСтраховойСтаж;
	ИначеЕсли ВидВремени = Перечисления.ВидыВремени.ОтработанноеВПределахНормы Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ВключаетсяВСтажДляДосрочногоНазначенияПенсии;
	ИначеЕсли ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ДополнительныйОтпуск
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ДополнительныеВыходныеДниОплачиваемые
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ОсновнойОтпуск Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ВключаетсяВСтажДляДосрочногоНазначенияПенсии;
	ИначеЕсли ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.Простой
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ПростойПоВинеРаботодателя
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ОтпускНаОбучение
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.Командировка Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ВключаетсяВСтраховойСтаж;
	ИначеЕсли ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.НеоплачиваемыйОтпускПоЗаконодательству
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.НеоплачиваемыйОтпускПоРазрешениюРаботодателя 
		ИЛИ ОбозначениеВТабелеУчетаРабочегоВремени = Справочники.КлассификаторИспользованияРабочегоВремени.ОтпускНаОбучениеНеоплачиваемый Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ОтпускБезСохраненияЗарплаты;
	ИначеЕсли ВидВремени = Перечисления.ВидыВремени.ЦелодневноеНеотработанное Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.НеВключаетсяВСтраховойСтаж;
	ИначеЕсли ВидВремени = Перечисления.ВидыВремени.ЧасовоеНеотработанное 
		ИЛИ ВидВремени = Перечисления.ВидыВремени.ОтработанноеСверхНормы 
		ИЛИ ВидВремени = Перечисления.ВидыВремени.ЧасовоеОтработанноеВПределахНормы 
		ИЛИ ВидВремени = Перечисления.ВидыВремени.ДополнительноОплачиваемоеВПределахНормы Тогда
		ВидСтажаСЗВ4 = Перечисления.ВидыСтажаСЗВ4.ПустаяСсылка();
	КонецЕсли;
	
    Возврат ВидСтажаСЗВ4
	
КонецФункции // ПолучитьПорядокВключенияПериодаВСтраховойСтаж()

// Функция проверяет наличие доступа у пользователя к результатам начислений
//
// Возвращаемое значение:
//   Булево   - Истина, когда есть доступ
//
Функция ПроверитьНаличиеДоступаКНачислениям() Экспорт

	Возврат НастройкаПравДоступаПереопределяемый.ДоступнаРольРасчетчикаРегл();	

КонецФункции // ПроверитьНаличиеДоступаКНачислениям()

// Функция проверяет наличие доступа у пользователя к данным о стаже
//
// Возвращаемое значение:
//   Булево   - Истина, когда есть доступ
//
Функция ПроверитьНаличиеДоступаКДаннымОСтаже() Экспорт

	Возврат НастройкаПравДоступаПереопределяемый.ДоступнаРольКадровикаРегл();

КонецФункции // ПроверитьНаличиеДоступаКДаннымОСтаже()


