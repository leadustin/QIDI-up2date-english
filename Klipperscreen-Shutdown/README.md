# **Shutdown Klipperscreen**
> [!NOTE]
> This macro is only useful if you have followed the procedure described in [Total conversion](Klipper-Update/update+upgrade.md) regarding the display replacement! The "gcode_shell_command" tool must be installed for the script to work. If Klippain Shake&Tune from the Klipper Update Tutorial is already installed, the following step is not necessary as the tool has already been installed. If Klippain Shake&Tune has not been installed, the following steps must be carried out.
+ KIAUH via point 4 and then point 8.
+ Option 2 would be via the following command in the console:

```bash
 wget -O ~/klipper/klippy/extras/gcode_shell_command.py https://raw.githubusercontent.com/th33xitus/kiauh/master/resources/gcode_shell_command.py
```
## **Installation of a macro to shut down the Raspberry running Klipperscreen via macro.**

With this macro, the Raspberry Pi can be shut down conveniently from Mainsail. This is useful if the printer is set up away from the PC.
The power supply runs via a smart plug from Ikea and is integrated via Alexa. The printer is in the basement and is therefore conveniently switched off via app or voice command. Other smart plugs also work.
Since abrupt power interruptions are not recommended for the Pi's SD card, the macro can be used to safely shut down the Raspberry and the printer host in Mainsail.

![Klipperscreenshutdown](/../main/images/klippershutdown1.png)

## **Installation ssh pass**
To enable the printer to establish a connection to the Raspberry Pi, we need ssh pass. The installation is started with the following command:

```bash
sudo apt install sshpass
```

The actual installation is simple. Copy the klipperscreen_shutdown.cfg and the klipperscreen_shutdown.sh and load them onto your printer.
If you have followed the tutorial for the automatic Github backup, there is a folder called "Scripts" on the printer. The script kipperscreen_shutdown.sh is copied into this folder.
If you have followed the guide for the total update, there is also a folder on the printer called "Macros". Copy the klipperscreen_shutdown.cfg into this folder. Basically, both folders are required and must be created if they do not exist.

## **Configuration klipperscreen_shutdown.sh**
+ Now open the klipperscreen_shutdown.sh in Mainsail and adjust the IP of the printer and if you are using a different user/password, adjust this section to your data accordingly.
+ Next, the script must be given the authorization to run. Execute the following command in Putty. Alternatively, the authorization can also be set in WinSCP. See the following picture.
  
  ```bash
  chmod 0755 ~/printer_data/config/Scripts/klipperscreen_shutdown.sh
  ```
+ right-click on the file klipperscreen_shutdown.sh, select Properties and then check the boxes as shown in the picture.

![CHMOD](/../main/images/chmod1.png) 

If you make changes to this file in Mainsail, you must reassign the authorizations. If you make changes via WinSCP, these remain in place.

## **Configuration klipperscreen_shutdown.cfg**
+ You must define the path to klipperscreen_shutdown.sh according to the location of the file. If you have followed my other guides, nothing needs to be changed here.

## **Configuration printer.cfg**
+ The last point is to include the klipperscreen_shutdown.cfg in the printer.cfg
+ Copies the following text at the beginning of printer.cfg under all other includes

```bash
[include Macros/klipperscreen_shutdown.cfg]
```
+ Save the printer.cfg and restart Klipper.
+ The macro section now contains the following macro:

![Macro](/../main/images/klippershutdown2.png) 

+ Clicking on the macro establishes an SSH connection to the Raspberry Pi and shuts it down. Below is a screen of the console in Mainsail.

![Konsole](/../main/images/klippershutdown3.png) 

If you liked this guide:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G7VMD0W)


