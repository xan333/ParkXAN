
#Область ПрограммныйИнтерфейс

// Обработчик обновления для переноса пользователей из справочника, созданного до внедрения БСП
Процедура ПеренестиПользователейИзПредыдущейВерсии() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПА_Пользователи.Ссылка,
		|	ПА_Пользователи.Наименование,
		|	ПА_Пользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	Справочник.ПА_Пользователи КАК ПА_Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО Пользователи.ИдентификаторПользователяИБ = ПА_Пользователи.ИдентификаторПользователяИБ
		|ГДЕ
		|	Пользователи.Ссылка ЕСТЬ NULL
		|	И ПА_Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификатор";
	
	Запрос.УстановитьПараметр("ПустойИдентификатор", ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл		
		
		НачатьТранзакцию();
		
		Попытка
			
			ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
			ПользовательОбъект.Наименование = Выборка.Наименование;
			ПользовательОбъект.ИдентификаторПользователяИБ = Выборка.ИдентификаторПользователяИБ;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПользовательОбъект);
				
			НазначитьПрофилиГруппДоступа(ПользовательОбъект.Ссылка, Выборка.ИдентификаторПользователяИБ);
			
			ПользовательОбъект.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение			
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НазначитьПрофилиГруппДоступа(Пользователь, ИдентификаторПользователяИБ)
	
	ПользовательИБ = 
		ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		
	Если ПользовательИБ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоАдминистратор = Ложь;
	ЭтоКассир = Ложь;
	ЭтоОператорАттракциона = Ложь;
	
	Для Каждого Роль Из ПользовательИБ.Роли Цикл
		
		Если Роль = Метаданные.Роли.ПА_ПолныеПрава Тогда
			ЭтоАдминистратор = Истина;
		ИначеЕсли Роль = Метаданные.Роли.Кассир Тогда
			ЭтоКассир = Истина;
		ИначеЕсли Роль = Метаданные.Роли.ОператорАттракциона Тогда
			ЭтоОператорАттракциона = Истина;
		КонецЕсли;
		
	КонецЦикла;
		
	Если ЭтоАдминистратор Тогда
		УправлениеДоступом.ВключитьПрофильПользователю(Пользователь, "Администратор");
	КонецЕсли;
	
	Если ЭтоКассир Тогда
		УправлениеДоступом.ВключитьПрофильПользователю(Пользователь, "Кассир");
	КонецЕсли;
	
	Если ЭтоОператорАттракциона Тогда
		УправлениеДоступом.ВключитьПрофильПользователю(Пользователь, "ОператорАттракциона");
	КонецЕсли;		
	
КонецПроцедуры

Процедура АктуализироватьВидыКонтактнойИнформации() Экспорт
	
	ПараметрыОбновления = ОбновлениеИнформационнойБазы.ПараметрыОбновленияПредопределенныхЭлементов();
	
	//ПараметрыОбновления.Элементы.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("СправочникКлиенты"));
	//ПараметрыОбновления.Элементы.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("АдресКлиента"));
	//ПараметрыОбновления.Элементы.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("ТелефонКлиента"));
	//ПараметрыОбновления.Элементы.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("АдресЭлектроннойПочтыКлиента"));
	//ПараметрыОбновления.Элементы.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("ТелеграммКлиента"));
	
	ПараметрыОбновления.Реквизиты = "РазрешитьВводНесколькихЗначений, ВидРедактирования, ОтображатьВсегда, Используется";
	ОбновлениеИнформационнойБазы.ОбновитьПредопределенныеЭлементы(Метаданные.Справочники.ВидыКонтактнойИнформации, ПараметрыОбновления);
	
КонецПроцедуры

#КонецОбласти
