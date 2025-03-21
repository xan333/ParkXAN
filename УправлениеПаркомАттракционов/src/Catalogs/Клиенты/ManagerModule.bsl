#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
	Процедура ПеренестиТелефонВКонтактнуюИнформацию(ПараметрыОбработки) Экспорт
		
		ПараметрыОбработки.ОбработкаЗавершена=ложь;	
		
		ВидКИ=УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("ТелефонКлиента");
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 50
			|	Клиенты.Ссылка
			|ИЗ
			|	Справочник.Клиенты КАК Клиенты
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Клиенты.КонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
			|		ПО КлиентыКонтактнаяИнформация.Ссылка = Клиенты.Ссылка
			|		И КлиентыКонтактнаяИнформация.Вид = &ВидКИ
			|ГДЕ
			|	Клиенты.НормализованныйТелефон <> """"
			|	И КлиентыКонтактнаяИнформация.Ссылка ЕСТЬ NULL";
		
		Запрос.УстановитьПараметр("ВидКИ",ВидКИ);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			ПараметрыОбработки.ОбработкаЗавершена=истина;
			Возврат;
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СпрОбъект=ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			
			НовКонтИнф=УправлениеКонтактнойИнформацией.НоваяКонтактнаяИнформация();
			СтрокаКИ=НовКонтИнф.Добавить();
			СтрокаКИ.Вид=ВидКИ;
			СтрокаКИ.Представление=СпрОбъект.НормализованныйТелефон;
			СтрокаКИ.Объект=СпрОбъект;
			
			УправлениеКонтактнойИнформацией.УстановитьКонтактнуюИнформациюОбъекта(СпрОбъект,НовКонтИнф,ложь);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СпрОбъект);
			
//			НачатьТранзакцию();
//			Попытка
//				СпрОбъект=ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
//				ДанныеФото=СпрОбъект.УдалитьФото.Получить();
//				Если ДанныеФото<>Неопределено Тогда
//					ПеренестиФотоВПрисоединенныйФайл(СпрОбъект,ДанныеФото);					
//				КонецЕсли;
//				СпрОбъект.ФотоПеренесено=истина;
//				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СпрОбъект);
//				ЗафиксироватьТранзакцию();	
//			Исключение
//				ОтменитьТранзакцию();
//				ВызватьИсключение;
//			КонецПопытки;
		КонецЦикла;
				
	КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#КонецЕсли