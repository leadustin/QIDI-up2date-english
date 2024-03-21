# **Github-Backup**
This guide is based on the work of <a href="https://github.com/EricZimmerman">Eric Zimmerman</a> and describes how to upload configs, macros etc. manually or automatically to your own Github repository and, if necessary, restore them as a backup on your 3D printer.
To make it easier to follow the guide, all console commands are prepared for copy&paste. Images have also been added to this guide to make individual steps easier to understand.
> [!IMPORTANT]
> The access token shown in this guide and the repository were only created for this guide. Both have already been deleted. Just in case someone tries to gain access with this data. 😄

## **WWhat is needed?**
+ a 3D printer
+ Putty for an SSH connection
+ an account at Github (which we create in this guide)

## **Where do you need something like this?**
If you optimize your printer and install additional software, you will inevitably change your configurations. Something can go wrong, old values can be forgotten or completely deleted.
With this guide you have the possibility to easily backup your data via Github and to track which changes you have made where and to change them if necessary.
The following image shows a change to a comment in printer.cfg. 
+ Red is the original value and green shows the current value.

![Backup](/../main/images/backup1.png)

## **Create your own Github repository**
> [!NOTE]
> If you don't have a Github account yet, you can create one <a href="https://github.com/signup">here</a>.
+ Log in to the created Github account.
+ Create a new Github repository by clicking on NEW.

![Neues Repository](/../main/images/backup2.png)

The next steps are naming, access authorization and various other settings.
1. name the repository
   + Choose a meaningful name. If you are planning to add several printers, the name of the respective printer would be useful here.

2. description repository
   + The description of the repository is optional. The printer could be described in more detail here.

3. public or private
   + If the repository is to be accessible to all, "public" must be selected, otherwise select "private".

4. initialization of the repository
   + This part defines which basic files are contained in the repository. Select as shown in the following image.
     + Add a README file - **Checkbox empty**
     + Add .gitignore - **NONE**
     + Choose a license - **NONE** - This point is optional. If you like, you can select the license of your choice.
   
5. create repository
   + Click on "create repository" to create your own repository.
    
![Initialisierung](/../main/images/backup3.png)

Nach Erstellung des Repository erfolgt eine Weiterleitung zum derzeitigen "Root-Verzeichnis". 
Kopiert die HTTPS-URL eurers Repository und fügt diese in einen Texteditor eurer Wahl ein. 

![HTTPS-URL](/../main/images/backup4.png)

## **Zugriffs-Token erstellen**
Um Zugriff auf das Repository über den Drucker zu erhalten, benötigen wir ein "access token" welches wir <a href="https://github.com/settings/tokens">hier</a> erstellen.
+ Auf "Generate new  token" klicken.
+ "Generate new token (classic) wählen.

![Token-Auswahl](/../main/images/backup5.png)

Im nächsten Schritt wird das Token mit entsprechenden Zugriffsrechten konfiguriert.
1. Namen des Tokens
   + Unter "Note" wählt ihr einen passenden Namen, welcher mit eurem Drucker in Verbindung gebracht werden kann.
2. Gültigkeitsdauer
   + Unter Expiration "No expiration" auswählen.
> [!TIP]
> Wer mag kann hier auch einen Zeitraum wählen nach dem das Zugriffs-Token seine Gültigkeit verliert. Nach Ablauf dieser Zeitspanne ist kein Zugriff auf das Repository durch den Drucker möglich und das Token muss erneuert werden.
3. Zugriffsbereiche wählen
   + Für die Definierung der Zugriffsbereiche nur "workflow" und "read:org" wählen.
4. Abschluss Konfiguration
   + Ganz nach unten scrollen und auf "Generate token" klicken.

![Token-Auswahl](/../main/images/backup7.png)

5. Sicherung des Tokens
   + Nach dem das Token erstellt wurde, befinden wir uns in der Verwaltungsübersicht aller bisher erstellten Tokens.
> [!CAUTION]
> Dies ist der einzige Moment in dem ihr eurer Token auf Github sehen werden! Es ist wichtig, dass das Token entsprechend gesichert wird, da es nicht von Github wiederhergestellt werden kann! Sollte der Zugriff auf dieses Token verloren gehen, muss ein neues erstellt werden. Fall jemand auf die Idee kommen sollte, das Token in Github hochzuladen - vergesst diese Idee. Github erkennt das Token und wird es löschen!

![Token-Auswahl](/../main/images/backup8.png)

Kopiert das Token in die Text-Datei in die ihr die HTTPS-URL euers Repository kopiert habt.

![Token in Notepad](/../main/images/backup9.png)

## **Kombinieren der HTTPS-URL mit dem Token**
Als nächster Schritt müssen Token und URL kombiniert werden.
+ Fügt in der URL hinter den beiden **//** ein **@** ein.
+ Kopiert euer Token in die Zwischenablage und fügt das Token zwischen **//** und dem **@** ein. Das nachfolgende Bild zeigt wie die URL aussehen muss.
> [!NOTE]
>  Nur noch mal zur Erinnerung. Das für diesen Guide erstellte Repository und Token wurden nach Erstellung der Anleitung gelöscht!

![Token+URL](/../main/images/backup10.png)

## **Verbindung zum Drucker per SSH**
Mit dem Tool euer Wahl per SSH auf den Drucker verbinden. Ich benutze in diesem Guide "Putty"
+ mit folgendem Befehl das Verzeichnis wechseln

  ```bash
  cd ~/printer_data/config
  ```

+ mit nachfolgendem Befehl wird das autocommit-Script heruntergeladen

  ```bash
  wget -O ~/printer_data/config/autocommit.sh https://raw.githubusercontent.com/EricZimmerman/VoronTools/main/autocommit.sh
  ```

+ Als nächstes wird die bevorzugte Weboberfläche ausgewählt. Wer Mainsail benutzt, entfernt die # in der Mainsail-Zeile. Wer Fluidd nutzt entsprechend bei Fluidd. Dafür öffnen wir mit folgendem Befehl die autocommit.sh

  ```bash
  nano ~/printer_data/config/autocommit.sh
  ```
+ Nachfolgendes Bild zeigt die Konfiguration für Mainsail. Fluidd ist entsprechend auskommentiert.

![MainsailoderFluidd](/../main/images/backup11.png)

+ Die autocommit.sh mit STRG+O und danach Enter speichern
+ STRG+X schließt den Editor und wir befinden uns wieder im Pfad "printer_data/config/"
+ Mit nachfolgenden Befehl geben wir uns sowie allen anderen Usern des Systems die Berechtigung die autocommit.sh auszuführen

  ```bash
  chmod +x autocommit.sh
  ```
+ Mit folgenden Befehl prüfen ob die Berechtigungen, wie auf dem nachfolgenden Bild gezeigt, richtig gesetzt sind.
  ```bash
  ls -la autocommit.sh
  ```
![Berechtigungen](/../main/images/backup12.png)

+ Für den Export und Backup der data.mdb benötigen wir noch ein weiteres Tool, welches mit nachfolgenden Befehl installiert wird.

  ```bash
  sudo apt install lmdb-utils
  ```
> [!IMPORTANT]
> In den Standard-Einstellungen werden ALLE Tabellen der data.mbd im Repository gesichert. Wer mit API-Schlüsseln und anderen Benutzerdaten arbeitet kann dies verhindern, in dem in der "autocommit.sh" der Bereich "history_only" auf "true" gesetzt wird.

## **Backup auf Github vorbereiten**
Um Github auf das Backup unserer Daten vorzubereiten, müssen wir folgenden Befehl in die Konsole einfügen:

```bash
git init -b main
```
![Github initialisieren](/../main/images/backup13.png)

Nun müssen wir Git mitteilen über welche URL auf unser Repository zugegriffen werden soll.
+ nachfolgenden Text in die Zwischenablage kopieren und in die Textfile vor die Token-URL einfügen:
  ```bash
  git remote add origin
  ```
![Git-URL](/../main/images/backup14.png)

+ Den in der Textfile erstellten Befehl aus dem vorherigen Bild in die Konsole eingeben.
+ Als nächstes erfolgt eine Verifizierung mit folgendem Befehl:
  
  ```bash
  git remote -v
  ```
![Verifizierung](/../main/images/backup15.png)

+ Nun müssen wir Git noch unsere Email sowie euren Namen mitteilen. Dabei handelt es sich um die Email und den Namen, den ihr bei Github verwendet. Dafür werden folgende Befehle verwendet, die entsprechend mit euren Daten ergänzt werden. 

  ```bash
   git config --global user.email "your@email.com"
   git config --global user.name "your name"
  ```
Damit wir nicht unnötige Dateien sichern, benötigen wir eine Ausschlußliste, die wie folgt erstellt wird:
+ Wir sollten uns derzeit noch im Verzeichnis "printer_data/config/" befinden. Wenn nicht mit nachfolgendem Befehl dort hin wechseln.
  
  ```bash
  cd ~/printer_data/config
  ```
+ Mit diesem Befehl erstellen wir die Datei .gitignore. Wichtig ist der Punkt vor gitignore!
  
  ```bash
  nano .gitignore
  ```
+ Im Editor nun die Pfade der Dateien eintragen, die NICHT gesichert werden sollen. Da ich Klippain Shake&Tune installiert habe, wären das dann diese Pfade. Speichern der Datei mit STRG+O, gefolgt von Enter und dann STRG+X
  
  ```bash
  K-ShakeTune_results/belts/*.csv
  K-ShakeTune_results/belts/*.png
  K-ShakeTune_results/inputshaper/*.csv
  K-ShakeTune_results/inputshaper/*.png
  K-ShakeTune_results/vibrations/*.tar.gz
  K-ShakeTune_results/vibrations/*.png
  ```
> [!NOTE]
  Das Ausschließen von Dateien ist ein optionaler Schritt! Wer alle Daten aus dem Ordner printer_data/config sichern möchte, lässt die .gitignore leer.

## **Das erste Backup**
Wir sind soweit das erste Backup zu erstellen.
+ Nachfolgenden Befehl in die Konsole einfügen:

  ```bash
  sh autocommit.sh
  ```
+ Wenn alle notwendigen Schritte zuvor richtig ausgeführt wurden, sollte es in der Konsole in etwas so aussehen. Da ich für diesen Guide ein eigenes System aufgesetzt habe, werden bei euch die übermittelten Daten von der Anzahl her höher sein.

  ![Backup](/../main/images/backup16.png)

+ Wenn der Befehl sh.autocommit.sh erneut in die Konsole eingefügt wird, ohne das es Änderungen am System gab, sollte es so wie auf dem Bild aussehen.

  ![BackupClean](/../main/images/backup17.png) 

+ Wie eine Änderung an einer Config angezeigt wird zeigt nachfolgendes Bild. Als Beispiel dient eine Änderung in der printer.cfg

  ![BackupChange](/../main/images/backup18.png)

## **Historie auf Github**
Schauen wir uns nun den Änderungsverlauf auf Github an. Im Root-Verzeichnis des Repository auf Commits klicken
 ![Commits](/../main/images/backup19.png)

Es werden alle derzeit getätigten Änderungen angezeigt. Diese werden nach Datum und Uhrzeit sortiert angezeigt.

 ![Commits2](/../main/images/backup20.png)

Mit einem Klick auf eine der Commits öffnet sich die Vergleichsansicht. In diesem Fall wurde der Wert von max_accel avon 1000 auf 10000 gesetzt.

 ![Commits](/../main/images/backup21.png)

## **Update per Macro**
Um komfortabel ein Backup per Macro zu erstellen fügt ihr folgenden Code in die Datei ein, die eure Macros enthält. Solltet ihr meinen Guide des [Komplett-Updates](/Klipper-Update/update+upgrade.md) des Druckers durchgeführt haben, sollte das Macro in die Macros/macro.cfg eingefügt werden.
```bash
 [gcode_shell_command backup_cfg]
 command: ~/printer_data/config/autocommit.sh
 timeout: 30
 verbose: True

 [gcode_macro BACKUP_CFG]
 description: Backs up config directory GitHub
 gcode:
     RUN_SHELL_COMMAND CMD=backup_cfg

 [delayed_gcode auto_backups]
 initial_duration: 10 #Nach 10 Sekunden wird automatisch ein Backup erstellt
 gcode:
    RUN_SHELL_COMMAND CMD=backup_cfg
```
Wir nähern uns dem Ende, benötigen aber noch das Tool "gcode_shell_command". Solltet ihr Klippain Shake&Tune installiert haben, entfällt dieser Schritt, da Klippain Shake&Tune das Script mit installiert. 
Für den Fall das Klippain Shake&Tune noch nicht installiert wurde, gibt es jetzt 2 Wege für die Installation. 
+ Entweder über KIAUH über Punkt 4 und dann Punkt 8.
+ Weg 2 wäre über nachfolgenden Befehl in der Konsole:

```bash
 wget -O ~/klipper/klippy/extras/gcode_shell_command.py https://raw.githubusercontent.com/th33xitus/kiauh/master/resources/gcode_shell_command.py
```
## **Ausführen des Macros**
In der Macro-Übersicht befindet sich nun das Macro "BACKUP CFG". Dies ist der manuelle Weg seine Daten zu sichern.

![MACRO](/../main/images/backup22.png)

Zusätzlich wird bei jedem Neustart von Klipper nach 10 Sekunden das Macro automatisch aufgerufen

![MACRO](/../main/images/backup23.png)

## **Backup wiederherstellen**
Die Wiederherstellung des aktuellsten Backups erfolgt mit folgenden Befehlen. Es muss natürlich eure Token-URL eingefügt werden. Daran denken, dass in der .gitignore hinterlegte Dateien und Pfade nicht gesichert werden und dem entsprechend auch nicht wiederhergestellt werden können!

```bash
cd ~/printer_data/config
 git init -b main
 git remote add origin https://<token>@github.com/leadustin/testconfig.git
 git fetch
 git reset origin/main
 git reset --hard HEAD
```

Wenn dir dieser Guide gefallen hat:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G7VMD0W)


  



