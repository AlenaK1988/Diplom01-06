#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПроведения(Отказ, РежимПроведения) 
	
	//++Диплом

	Движения.ВКМ_ОтпускаСотрудников.Записывать = Истина; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.Сотрудник КАК Сотрудник,
		|	СУММА(РАЗНОСТЬДАТ(ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаНачала, ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаОкончания, ДЕНЬ)) КАК КоличествоДней,
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаНачала КАК ДатаНачала,
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	Документ.ВКМ_ГрафикОтпусков.ОтпускаСотрудников КАК ВКМ_ГрафикОтпусковОтпускаСотрудников
		|ГДЕ
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.Сотрудник,
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаНачала,
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаОкончания";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		// регистр ВКМ_ОтпускаСотрудников
		Движение = Движения.ВКМ_ОтпускаСотрудников.Добавить();
		Движение.Период = Год;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.КоличествоДней = Выборка.КоличествоДней;
				
		Если Выборка.КоличествоДней > 28 Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("Сотрудник", Выборка.Сотрудник);
			СтрокиСотрудник = ОтпускаСотрудников.НайтиСтроки(Отбор);
			Для Каждого Строка Из СтрокиСотрудник Цикл
				Строка.Более28 = Истина;
			КонецЦикла; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	 //{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ 
	
	//конец	

КонецПроцедуры

#КонецОбласти

#КонецЕсли


