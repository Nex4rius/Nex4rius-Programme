<a href="#english">english</a>/<a href="#deutsch">deutsch</a>/<a href="#russian">russian</a><a name="deutsch">
# Stargate-Programm für SG-Craft und OpenComputers</a>

<img src="https://i.imgur.com/XtCzDAs.png">
<img src="https://i.imgur.com/jWwlBNI.png" width="700px">

Installationsanleitung:

Ein OpenComputer Computer mit folgenden Komponenten:
- CPU T2
- GPU T2
- 12x Screen T2
- HDD T1 (mit OpenOS)
- 2x Memory T1.5
- Internet Card - nur benötigt zur Installation und für Aktualisierungen
- Tastatur - nur benötigt zur Installation
- Redstone Card T2 - optional
- EEPROM (Lua BIOS)

<a href="https://www.youtube.com/embed/MgWY4es5oEs"><img src="https://i.imgur.com/h6VjgRe.jpg"></a>

```
pastebin run -f YVqKFnsP
```

Die Funktionen meines Programms:

- automatische Schließung der Iris beim eingehenden Wurmloch (wenn Iriskontrolle eingeschaltet ist)
- automatische Öffnung der Iris beim Erhalt des richtigen IDC (**I**ris **D**eaktivierungs**c**ode)
- automatische Schließungs des Stargates nach X-Sekunden
- zeige alle möglichen Eigenschaften des Stargates (Lokale- / Zieladresse, Status, Verbindungsrichtung, IDC, Iris Status, Energie, ...)
- mehrere Sprache: zur Zeit deutsch und englisch (weil ich nichts anderes spreche) (Ihr könnt neue Sprachen mit pull requests hinzufügen)
- zeige Energie in EU or RF
- zeige bis zu 10 Adressen auf 1 Seite (unbegrenzte Seiten)
- ermöglicht die Anwahl des Stargates mithilfe einer Adressliste
- Prüfe beim Start ob es Aktualisierungen gibt
- Ausgabe von Redstone Signalen (zurzeit für: Status nicht untätig, eingehend, Iris geschlossen, IDC akzeptiert, Wurmloch verbunden)
- automatisches hinzufügen von neuen, unbekannten Adressen bei einem aktiven Wurmloch
- zeige die benötigte Energie zum Wählen einer Adresse (oder Fehler bei ungültiger Adresse)
- funktioniert mit Computronics ColorfulLamps
- erlaubt die Schließung eines eingehenden Wurmloch wenns es in den Einstellungen ausgeschaltet ist UND ein Computer mit diesem Programm auf beiden Seiten des Stargates ist
- automatisches senden und empfangen der gesamten Adressliste bei einem offenen Wurmloch (natürlich ohne den IDC) und automatisches hinzufügen von den neuen Adressen
- mit Touchscreenfunktion !

Wichtig!
Damit das Programm ordentlich funktioniert muss der Computer entweder im gleichen Chunk wie das Stargate sein oder einen Chunkloader haben.

Verwendung: autorun [...]<br>
ja -> Aktualisierung zur stabilen Version<br>
nein -> keine Aktualisierung<br>
beta -> Aktualisierung zur Beta-Version<br>
hilfe -> zeige diese Nachricht nochmal

<a href="https://oc.cil.li/index.php?/topic/1062-sg-craft-stargate-control-program/">Forum</a>

Macht pull request (zu beta) wenn ihr wollt :)

getestet mit:<br>
OpenComputers-MC1.7.10-1.6.1.11-universal<br>
SGCraft-1.13.3-mc1.7.10

___
<a href="#english">english</a>/<a href="#deutsch">deutsch</a>/<a href="#russian">russian</a><a name="english">
# Stargate-Program for SG-Craft and OpenComputers</a>

<img src="https://i.imgur.com/E5JAcS5.png">
<img src="https://i.imgur.com/jWwlBNI.png" width="700px">

How to install:

Make an OpenComputer computer with:
- CPU T2
- GPU T2
- 12x Screen T2
- HDD T1 (with OpenOS)
- 2x Memory T1.5
- Internet Card - only required for installation and updates
- keyboard - only required for installation
- Redstone Card T2 - optional
- EEPROM (Lua BIOS)

<a href="https://www.youtube.com/embed/MgWY4es5oEs"><img src="https://i.imgur.com/h6VjgRe.jpg"></a>

```
pastebin run -f YVqKFnsP
```

the features of my program:

- autoclose iris on incoming wormhole (when iriscontrol is turned on)
- autoopen iris if correct IDC is received (**i**ris **d**eactivation **c**ode)
- autoclose stargate after X seconds
- show all kinds of stats (local / remote address, state, direction, idc, iris state, energy, ...)
- multiple languages: right now german and english (because I don't speak anything else) (You can add new languages with pull requests)
- displays energy in EU or RF
- displays up to 10 addresses on 1 page (unlimited pages)
- allows dialing from the address list
- check for updates on start
- emit redstone signals (right now for: state not idle, incoming, iris closed, idc accepted, wormhole connected)
- automatically adds new, unkown addresses when there is an open wormhole
- shows the required energy to dial an address (or error if invalid address)
- works with Computronics ColorfulLamps
- allows closing of incoming wormholes if its disabled in config AND there is a computer at either end
- automatically sends and receives entire address list on an open wormhole (without the IDC of course) and automatically adds the new addresses
- with touchscreen functionalities

important!
This program either needs to be in the same chunk as the Stargate or there has to be a chunkloader nearby to function properly.

Usage: autorun [...]<br>
yes   -> update to stable version<br>
no    -> no update<br>
beta  -> update to beta version<br>
help  -> show this message again

<a href="https://oc.cil.li/index.php?/topic/1062-sg-craft-stargate-control-program/">Forum</a>

Make pull requests (to beta) if you want :)

tested with:<br>
OpenComputers-MC1.7.10-1.6.1.11-universal<br>
SGCraft-1.13.3-mc1.7.10

___
<a href="#english">english</a>/<a href="#deutsch">deutsch</a>/<a href="#russian">russian</a><a name="russian">
# Stargate-Program для SG-Craft и OpenComputers</a>

<img src="https://i.imgur.com/XtCzDAs.png">
<img src="https://i.imgur.com/jWwlBNI.png" width="700px">

Установка:

Собрать компьютер со следующими компонентами:
- ЦПУ (Уровень 2)
- Видеокарта (Уровень 2)
- Монитор 4x3 блока (Уровень 2)
- Жесткий диск (с установленной OpenOS)
- 2 модуля памяти (Уровень 1.5)
- Интернет карта - требуется только для установки и обновления программы
- Клавиатура - требуется только при установке
- Редстоун-карта (Уровень 2) - опционально
- EEPROM (Lua BIOS)

<a href="https://www.youtube.com/embed/MgWY4es5oEs"><img src="https://i.imgur.com/h6VjgRe.jpg"></a>

```
pastebin run -f YVqKFnsP
```

особенности моей программы:

- автозакрытие диафрагмы при входящем соединении (если включено управление диафрагмой)
- автооткрытие диафрагмы при получении правильного IDC (кода деактивации диафрагмы)
- автозакрытие врат через X секунд
- вывод подробной информации (локальный/удаленный адрес, состояние, направление, код деактивации, состояние диафрагмы, энергия...)
- несколько языков: пока только немецкий, английский и русский (Вы можете добавить новые языки, послав pull request)
- отображение доступной энергии в EU или RF
- отображение до 10 адресов на 1 странице (бесконечное количество страниц)
- возможность набора адреса из списка
- проверка наличия обновлений при запуске
- статусные редстоун-сигналы (не в режиме ожидания, входящий туннель, диафрагма закрыта, IDC принят, активный туннель)
- автоматическое добавление новых неизвестных адресов, при открытом туннеле
- отображение энергии, необходимой для создания туннеля (или ошибки, при неправильном адресе)
- работа с цветной лампой из Computronics
- возможность закрывать входящие туннели, если отключено в конфиге на обоих концах
- автоматическая передача (разумеется, без IDC) и прием списка адресов, по открытому туннелю
- визуальный сенсорный интерфейс

Важно! Компьютер с этой программой должен быть размещен в том же чанке, что и врата, либо иметь рядом активный чанклоадер.

Использование: autorun [...]<br>
yes -> обновить до стабильной версии<br>
no -> не обновлять<br>
beta -> обновить до беты<br>
help -> показать это сообщение

<a href="https://oc.cil.li/index.php?/topic/1062-sg-craft-stargate-control-program/">Форум</a>

Предлагайте свои идеи.

проверено с:<br>
OpenComputers-MC1.7.10-1.6.1.11-universal<br>
SGCraft-1.13.3-mc1.7.10
