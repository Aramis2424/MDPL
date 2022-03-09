# MDPL
Лабораторные работы по МЗЯП-у

***Все ЛР сдавал Кузнецову***

### ЛР-1
Вопросы по устройству памяти компьютера *(внутренняя, внешня, биос, ...)*, что такое ОС, потоки ввода-вывода + команды cmd *(очень любит dir, more, type, как записать в файл)*

### ЛР-2
В начале открываете .com файл hex-editor`ом (скачиваете его на notepad++), и Кузнецов по нему задает вопросы *(что в колонке adress - смешение относительно начала файла; какое смещение каждого бита - сумма значения adress и столбца, в котором показан байт)* + вопросы по AFDPro *(где какое окно, что такое регисты, ...)* и обязательно **как установить точку останова**

### ЛР-3
Вопросы в основном по коду *(Секции, сегменты, выделение памяти, метки, ...)*

### ЛР-4
*Задание: написать программу из двух модулей. В первом модуле ввести цифру от 5 до 9, затем передать управление во второй с помощью дальнего перехода, где вывести через пробел значение этой цифры, уменьшенное на 5*

Кузнецов требует очень подробный разбор примеров, но я сдал магистру)

Вот ответ на то, что у меня спрашивал Кузнецов (и на чем собственно завалил):

(В первом примере 0b800h сегментный адрес, физический адрес = 0b800h*F=0b8000h - адрес видеопамяти текстового режима)