#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбработатьДанные(Результат, ДополнительныеПараметры) Экспорт
    //++Диплом
	ОтключитьОбработчикОжидания("ОбработчикОжиданияИндикатор");
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		ЭтаФорма.СтрокаСостояния = "Ошибка";
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ЭтаФорма.Индикатор = 100;
		ЭтаФорма.СтрокаСостояния = "Выполнено";
	КонецЕсли;
	//конец
КонецПроцедуры

&НаСервере
Функция ВыполнитьФоновоеЗаданиеНаСервере(ПараметрыЗапуска, УникальныйИдентификатор)
	//++ Диплом
	НаименованиеЗадания = "Массовое создание реализаций";

	ВыполняемыйМетод = "ВКМ_МояДлительнаяОперация.МассовоеСозданиеРеализацийПоДоговорам";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ЗапуститьВФоне 	= Истина;
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", УникальныйИдентификатор); 
	
	СтруктураФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыЗапуска, ПараметрыВыполнения);
	
	Данные = ПолучитьИзВременногоХранилища(ПараметрыВыполнения.АдресРезультата); 
	
	НоваяСтрокаТЧ = Объект.ДокументыДляСоздания.Добавить();
	НоваяСтрокаТЧ.Договор = Данные.Договор;
	НоваяСтрокаТЧ.Реализация = Данные.Реализация;
		
	
	Возврат СтруктураФоновогоЗадания;
	//конец
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	//++Диплом 
	ИДЗадания = "";
	Индикатор = 0;
	СтрокаСостояния = "";
	
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("ДатаНачала", НачалоДня(Объект.Период.ДатаНачала));
	ПараметрыЗапуска.Вставить("ДатаОкончания",КонецДня(Объект.Период.ДатаОкончания));
		
	СтруктураФоновогоЗадания = ВыполнитьФоновоеЗаданиеНаСервере(ПараметрыЗапуска, УникальныйИдентификатор);
	ИДЗадания = СтруктураФоновогоЗадания.ИдентификаторЗадания;
	
	ПараметрыОжидания  = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.Интервал  = 2;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(СтруктураФоновогоЗадания, Новый ОписаниеОповещения("ОбработатьДанные", ЭтотОбъект), ПараметрыОжидания);
	//конец
КонецПроцедуры 

#КонецОбласти 


