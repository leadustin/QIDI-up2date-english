# **Update Qidi Series 3**
This guide describes how to update the Qidi X-Plus 3 or the Qidi X-Max 3 to the latest software including some useful and optional tools.
This guide is compatible with the **Qidi X-Max 3 and the X-Plus 3.**

This tutorial is based on the work of coco.33 and was published in its original version on <a href="https://github.com/Phil1988/FreeQIDI">FreeQIDI</a>
and refers to the Qidi X-3 series.
# **Disclaimer**
> [!CAUTION]
>Please note that neither I nor any other third party will be responsible for any damage to your printer if you follow this tutorial.
>You will completely rebuild the system. This includes flashing all MCUs such as the print head or the STM chip of the mainboard.
>All your Gcodes and your current printer.cfg should therefore be backed up.
>If you agree to this and changes are made, any warranty claim against Qidi will also expire.

## Why should you update your Qidi?


The hardware of the printer itself is solid and has the potential for very good print results.
However, the bottleneck of the Series 3 is the outdated software. A comparison shows why this alone is a reason to upgrade the system.

| Qidi original  | Updated Build |
| ------------- | ------------- |
| Armbian Buster  | Armbian Bookworm  |
| Klipper 0.10.x  | Klipper 0.12.x  |
| Moonraker 0.7.x  | Moonraker 0.8.x  |
| Fluidd 1.19.x  | Fluidd 1.28.x |
| Mainsail?  | Mainsail 2.10  |
| Python 2.7 und 3.7  | Python 3.12 |

Updating the entire system gives you the option of using all the latest software and adding some useful tools to the printer. The storage space required on the EMMC is reduced from the current 6.5GB to around 3GB. If you want to continue using the original memory card, this is a factor that should not be underestimated.

Personally, however, I would recommend the 32 GB card from Qidi, as with some additional tools the memory consumption quickly exceeds 8 GB. Put simply, you get a printer that is superior to the original when configured correctly and comes as close as possible to the idea of open source.

Unfortunately, where there is light, there is also shadow. In this case, it concerns the printer's original display. This can no longer be used after the update. In principle, the display is a separate system on which the printer's print interface runs and is connected serially to the mainboard. Due to various modifications to Klipper and Moonraker by Qidi, an interface has been created between the display and the system. This is also the reason why an update of Moonraker or Klipper on an existing system generates this error message.

![Fehlermeldung](/../main/images/display_error.png)

I will present an alternative for the display later in the tutorial.

**Still interested? Then let's get started now.**


What is needed?


### **Hardware Update OS**

+ <a href="https://eu.qidi3d.com/de/collections/x-plus-3-accessories/products/x-max-3-x-plus-3-x-smart-3-emmc-32g" target="_blank" rel="noopener noreferrer">EMMC-Reader</a> – I would buy the 32GB EMMC from Qidi, as the reader is included.
+ <a href="https://www.amazon.com/s?k=sd+card+adapter+usb&crid=15YOTDZUGFJQ2&sprefix=sd+card+a%2Caps%2C113&ref=nb_sb_ss_ts-doa-p_2_9" target="_blank" rel="noopener noreferrer">SD card adapter to MicroSD or USB adapter to MicroSD</a>
+ <a href="https://www.amazon.com/s?k=micro+sd+karte&crid=3IBXHOHP33HS4&sprefix=micro%2Caps%2C111&ref=nb_sb_ss_ts-doa-p_1_5" target="_blank" rel="noopener noreferrer">MicroSD-card - max 32GB</a>
+ Optional 5+ inch touch display and a Raspberry version 3 or higher


### **Software Update OS**


+ <a href="https://etcher.balena.io/" target="_blank" rel="noopener noreferrer">balenaEtcher</a> - to flash the operating system onto the EMMC
+ <a href="https://github.com/redrathnure/armbian-mkspi" target="_blank" rel="noopener noreferrer">Armbian Image</a> - Image of the operating system to be flashed -  Armbian 24.2.0-trunk Bookworm
+ <a href="https://www.raspberrypi.com/software/" target="_blank" rel="noopener noreferrer">Raspberry Imager</a> - required for the installation of the display
+ <a rel="noopener noreferrer" href="https://www.chiark.greenend.org.uk/~sgtatham/putty/" target="_blank">Putty</a> - Tool to access the printer via SSH
+ <a href="https://winscp.net/eng/download.php" target="_blank" rel="noopener noreferrer">WinSCP</a> - Tool for accessing the printer via FTP

### **Backup**

+ Since the complete system will be deleted, please create a backup of your G-codes and the printer.cfg
+ In addition, a LAN connection is required to set up the system. WLAN does NOT work!


**The following is a detailed guide to the update process.**


As we are working on an open device, the power supply must first be disconnected.
Turn your printer so that you can easily remove the screws on the back of the cover. Use this <a href="https://drive.google.com/drive/folders/1EPYKbYz4ecUIf17z5wtP-jDAOPeDkXJP" target="_blank" rel="noopener noreferrer">guide</a> to remove the EMMC. Before you remove the EMMC, ground yourself once and don't forget to back up your Gcodes.
Better safe than sorry.

## **Installation Armbian "Bookworm"**

+ Connect the EMMC to the PC using the EMMC reader.
+ Start balenaEtcher and flash the previously downloaded <a href="https://github.com/redrathnure/armbian-mkspi" target="_blank">Armbian image</a> onto the EMMC.

![Balena](/../main/images/balena.png)

+ Plug the EMMC back into the mainboard according to the instructions.
+ Connect the LAN cable and power supply.
+ Switch on the printer - The system now boots up and the printer is assigned its IP by the router.
+ Open the router and find the current IP of the printer and assign it to the printer. Below is a picture of the settings on the Fritz!Box. If you have a different router, you will have to search for it yourself.

![Fritz!Box](/../main/images/fritzbox_ip.png)


+ Start Putty and configure accordingly. Connect to the printer via SSH. User is "root" and password "1234". This is followed by the initial setup of the Armbian OS. Among other things, you have to give the user "root" a new password, select the time zone and your favorite shell. I use bash.

![Putty](/../main/images/putty.png)


+ You will be asked to create a new user. Enter "mks" as the name and "makerbase" as the password. You can ignore prompts to enter a real name and confirm with Enter.
+ Restart the connection to the printer and log in with the previously created user mks.
+ Update the operating system with the following commands:

```bash
sudo apt update
sudo apt upgrade
```

With some tools it can happen that there is no visible progress in the console. This is normal, so no need to panic.  Inserting commands in Putty is done by right-clicking. If you want to copy something from Putty, simply select the text with the left mouse button pressed. The text is automatically copied to the Windows clipboard.

### **Installation KIAUH** (Klipper Installation And Update Helper)

This useful tool automatically installs, updates and uninstalls tools selected by us. Copy the commands as usual to start the installation.

```bash
sudo apt-get update && sudo apt-get install git -y
cd ~ && git clone https://github.com/dw-0/kiauh.git
./kiauh/kiauh.sh
```

After successful installation, you should be in the main menu of KIAUH.

Install this software in this order via menu item 1. Klipper->Moonraker->Mainsail. 
Klipper asks for the Python version during installation, always select version 3! Select 1 for the number of instances. 
During the installation of Mainsail you will be asked whether macros should be installed. Answer YES here. 

The installation will take some time, so be patient even if nothing happens in the console. This is what it should look like in KIAUH at the end.

![KIAUH](/../main/images/kiuah_tools.png)


Enter the IP of the printer in the browser and connect to the web interface.
An error message is displayed because outdated Klipper firmware is installed on various MCUs. No need to panic. Now the fun begins.

![MCU-Error](/../main/images/klipper_mcu_error.png)

## **Flashing the printhead - Introduction**

To flash the print head, we need to put it into "DFU mode". This requires physically pressing 2 buttons. This step will be explained in more detail later.

### **Installation of katapult**

We connect to our printer with Putty via SSH and log in with mks/makerbase. After logging in, enter the following commands in the console:

```bash
git clone https://github.com/Arksine/katapult
cd ~/katapult
make menuconfig
```

We are now in the catapult configuration menu.

![Katapult](/../main/images/katapult1.png)

First we change the section "Micro-controller Architecture" to RP2040.

![Katapult](/../main/images/katapult2.png)

Next, make sure that the bootloader is set to "16KiB bootloader" under "Build Catapult deployment application".

![Putty](/../main/images/katapult3.png)

End with "Q" and save with "Y".

![Putty](/../main/images/katapult4.png)


Now we create our first firmware by entering the following command:

```bash
make clean
make -j4
```

You should see the following output in the console:


![Putty](/../main/images/katapult5.png)



Enter the following command in the console for the following output. You can see that Klipper is installed on the print head. Note that the ID on the picture is **MY** printer!

```bash
ls /dev/serial/by-id/*
```
![Putty](/../main/images/katapult6.png)


Set the print head to DFU mode. To do this, proceed as follows:

+ Remove the rear cover of the print head
+ Press and hold the boot button
+ Press and release the reset button
+ Release the boot button

![Druckkopf](/../main/images/druckkopf1.png)

Enter the following commands in the console to prepare for flashing the print head:

```bash
sudo mount /dev/sda1 /mnt
systemctl daemon-reload
```

![Flash Toolhead](/../main/images/flash_1.png)


You will be asked for the password of the user mks. Enter makerbase here.


![Flash Toolhead](/../main/images/flash_2.png)

The following commands flash Katapult onto the print head:

```bash
sudo cp out/katapult.uf2 /mnt
sudo umount /mnt
```

When the following command is entered, confirmation should be displayed that  Katapult is running on the print head.

```bash
ls /dev/serial/by-id
```

![Putty](/../main/images/flash_3.png)

Now that Katapult has been installed on the print head, the next step will be to flash Klipper. Since we no longer need to touch the print head, the rear cover of the print head can be installed.

Enter the following commands in the console:

```bash
cd ~/klipper
make menuconfig
```

In principle, the procedure here is similar to the Config menu of Katapult. Configure the menu as shown in the following image.

![Putty](/../main/images/klipper1.png)

End with "Q" and save with "Y".

![Putty](/../main/images/klipper2.png)

The firmware is created with the following commands

```bash
make clean
make -j4
```
This should appear in the console after compiling the firmware. The warning can be ignored.

![Putty](/../main/images/klipper3.png)

> [!WARNING]
> Use the following command to call up the ID and copy everything to "usb-katapult_rp2040_" in the temporary memory and then to a .txt file. This is **YOUR** serial ID of the print head. All IDs on these images are **MY** printer and must not be flashed to **YOUR** printer.

```bash
ls /dev/serial/by-id/*
```

This must be in your console - “/dev/serial/by-id/usb-katapult_rp2040_YOUR-ID”

Install python3-serial with the following command. This enables us to flash the print head.

```bash
sudo apt install python3-serial
```

> [!WARNING]
> ### **Flashing the print head with Klipper**
> Make sure that you also use **YOUR ID**. Enter the following command complete with **YOUR ID** in the console. You have cached **YOUR ID** in a text file.
>
> ```bash
> python3 ~/katapult/scripts/flashtool.py -f ~/klipper/out/klipper.bin -d /dev/serial/by-id/usb-katapult_rp2040_YOUR_ID
> ```

This is how it should look in the console:

![Putty](/../main/images/klipper4.png)



Done! The print head is flashed to Klipper 0.12.


## **Flashing STM32F402.** 

Procedure similar to the flash process of the rp2040. Enter the following commands in the console:

```bash
cd ~/klipper
make menuconfig
```


Set everything as shown in the picture and finish again with "Q" and save "Y".

![Putty](/../main/images/klipper5.png)




Now the last firmware is compiled with the following command:

```bash
make clean
make -j4
```


This process creates a "klipper.bin" in the folder /home/mks/klipper/out/. The warning during compilation can be ignored.

![Putty](/../main/images/klipper6.png)


Create a new connection destination in WinSCP, enter the IP of the printer. Leave the user name and password empty and click on "Save". Next, click on "log in" and enter the login data of the user mks in the next window and download the klipper.bin from /home/mks/klipper/out/ as shown in the picture.

![Putty](/../main/images/klipper7.png)

+ Format the MicroSD card as FAT32. Important! Do not use a card larger than 32GB!
+ Rename the klipper.bin to X_4.bin and copy it directly to the root directory of the SD card.
+ Eject the MicroSD card.
+ Switch off the printer at the power switch and wait at least 30 seconds to allow the supercapacitor to discharge.
+ Insert the MicroSD card into the card slot of the mainboard and switch the printer back on. The STM32F402 MCU is now flashed. The process should take about 10 seconds. To be on the safe side, only switch off the printer after 1 minute and remove the SD card.

![Putty](/../main/images/klipper8.png)

Unplug the display from the mainboard, as it will only display an error message. Switch on the printer and access the web interface. The following screen should now be displayed in the "Machine" tab. The error message regarding the mcu MKS_THR is ignored for now. We will deal with this later.

Install the rear cover of the printer, taking care not to screw the screws too tightly into the thread, as unfortunately you are only screwing into plastic here. If you also want to install the alternative touch display, you can leave the printer open.

![Putty](/../main/images/klipper9.png)


**Congratulations - the foundation has been laid.**

> [!IMPORTANT]
> First of all, a clarification. If you continue to follow the guide, you will get the software version that is currently on my printer.
> If you don't want this and want to configure your printer differently, then this is the time to jump off. Klipper, Moonraker and Mainsail are up to date. What was to be flashed was flashed.
>
> Only the printer.cfg must now be adapted by you. This means that the pin assignments, extruder, fan and basically the entire hardware part plus macros must be entered.
> You can cannibalize your old printer.cfg for this. If you don't want to do this, follow the guide.

## **printer.cfg**

The printer.cfg is the heart of the printer. It stores all the hardware settings such as extruder, fan, etc.
It usually contains all the required macros and references to configs of other tools. Important entries are currently missing in printer.cfg.
This is also the reason why there is an error message on the web interface.

If you know what you are doing and want to configure your printer.cfg according to your ideas and wishes, you can skip this part. For all others, continue with the text.



The original printer.cfg from Qidi is quite a mess with some pointless and dangerous macros - the keyword here would be "Force_Move".
Some print heads will have moved into the print beds or beyond the print bed.

The printer.cfg files I offer are for the X-Plus 3 and the X-Max 3.
For a better overview, these printer.cfg only contain technical settings for the hardware of the printer.
Everything concerning macros is collected in a separate macro.cfg. There are also a few separate configs.
Everything is integrated into the printer.cfg via "include".


+ Download and unzip the RAR file corresponding to the printer
+ Call up Mainsail and mark the printer.cfg in the "Machine" tab with a right-click, delete it and upload the printer.cfg from the archive via "Upload file".

![Mainsail Upload](/../main/images/mainsail_upload.png)

+ Click on printer.cfg in Mainsail - the Mainsail editor opens
+ Search for the following section and enter **YOUR ID**.

```bash
[mcu MKS_THR]
[serial:/dev/serial/by-id/usb-Klipper_rp2040_55DA4D9503AF5658-if00
```

Click on "Save and restart" in the Mainsail Editor. Klipper is restarted and loads all configs.
If the ID under mcu MKS_THR has been entered correctly, the mcu-related red error message should also be gone. Instead, we now have another red error message. 
The Adaptive_Mesh.cfg is missing. This is located in the downloaded RAR file in the "Macros" folder.
 + Creates a folder with the name "Macros" in Mainsail using the "Create directory" button

![Mainsail Folder](/../main/images/mainsail_folder.png)

+ Open this folder and upload all files from the unzipped "Macros" folder

As we are still missing a few files, we now start Putty and log in to the printer with mks/makerbase.

Enter the following command in the console:

```bash
./kiauh/kiauh.sh
```

+ KIAUH opens and switch to the installation via point 1

## **Crownsnest**
Crownsnest is responsible for the configuration and control of webcams etc. If you do not use a camera, you can skip this point.
+ Select Crownsnest for the installation and confirm everything with "Yes" during the installation. After installation, open "crownsnest.conf" in the Mainsail Editor and configure your webcam accordingly and then click "Save and restart".

## **Octoeverywhere**
Octoeverywhere is a remote tool with which you can control your printer via the Internet.
+ Select Octoeverywhere for the installation and confirm everything with "Yes" during the installation. At the end of the installation, a multi-digit code is displayed in the console. Enter this code at <a href="https://octoeverywhere.com/code">Octoeverywhere.com/code</a> and follow the instructions.
 
We are finished with the installation via KIAUH and close the tool in the main menu with "Q".

## **Useful tools**

There are still 3 tools missing, which we will now install. These are Klippain Shake&Tune, Mainsail Timelapse and Spoolman.

### Mainsail Timelapse
+ Mainsail Timelapse is a tool that can be used to create time-lapse videos of prints. As with Crownsnest, if you do not use a camera you can skip the installation. Execute the following commands for the installation of Mainsail Timelapse in the console:

```bash
cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
cd ~/moonraker-timelapse
make install
```
If the following message is displayed in the console at the end of the installation, please open moonraker.conf and insert the following at the end:

![Timelapse](/../main/images/timelapse1.png)

```bash
[timelapse]
output_path: ~/printer_data/timelapse/
frame_path: /tmp/timelapse/printer
```

After installing Mainsail Timelapse, you will find the file "timelapse.cfg" in the "Config" folder. Copy this into the "Macros" folder in Mainsail using drag & drop.

In order to receive update notifications later, we open moonraker.conf in Mainsail and add the following to the end of the file:

```bash
[update_manager timelapse]
type: git_repo
primary_branch: main
path: ~/moonraker-timelapse
origin: https://github.com/mainsail-crew/moonraker-timelapse.git
managed_services: klipper moonraker
```

+ Then press "Save and restart" in the Mainsail Editor.

### Klippain Shake&Tune. 
This tool can be used to carry out vibration calibrations and check the tension of the belts, among other things, and thus achieve corresponding improvements.

+ Enter the following command in the console:

```bash
wget -O - https://raw.githubusercontent.com/Frix-x/klippain-shaketune/main/install.sh | bash
```
> [!TIP]
> The macros "BELTS_SHAPER_CALIBRATION" and "AXES_SHAPER_CALIBRATION" are used to carry out various tests and finally display them in a graphic. Please "home" the printer before using the macros.

### Spoolman
Spoolman is a filament management tool that logs filament consumption.

+ Copy the following commands and paste them into the console:

```bash
sudo apt-get update && \
sudo apt-get install -y curl jq && \
mkdir -p ./Spoolman && \
source_url=$(curl -s https://api.github.com/repos/Donkie/Spoolman/releases/latest | jq -r '.assets[] | select(.name == "spoolman.zip").browser_download_url') && \
curl -sSL $source_url -o temp.zip && unzip temp.zip -d ./Spoolman && rm temp.zip && \
cd ./Spoolman && \
bash ./scripts/install_debian.sh
```
Answer the question whether Spoolman should be installed as a service with yes.
Open moonraker.conf in Mainsail and insert the following at the end. Change the IP address to the IP of your printer. Then click on "Save and restart".

```bash
[spoolman]
server: http://192.168.0.123:7912
#URL to the Spoolman instance. This parameter must be provided.
sync_rate: 5
#The interval, in seconds, between sync requests with the
#Spoolman server.  The default is 5.

[update_manager spoolman]
type: web
channel: stable
repo: Donkie/Spoolman
path: ~/Spoolman
```

After installing Spoolman, the tool can be accessed via the IP of your printer and port 7912.

![Spoolman](/../main/images/spoolman1.png)

## **client.cfg**

+ Open the client.cfg in the Macros folder in the Mainsail Editor and configure it according to your requirements. Among other things, various parking positions of the print head can be configured.

## Alternative touch display!

> [!NOTE]
> As we have discovered, the original display cannot currently be used after the system update.
> However, it is possible to restore touchscreen operation. The keyword here is "Klipperscreen".
> Klipperscreen is based on Octoscreen and offers a graphical interface for controlling one or more printers.
>
> I describe here the replacement of the original display with a 5 inch touch display in combination with a Raspberry Pi as a permanently installed display.

**What do we need for this?**


### Hardware for Display:
+ 1x <a href="https://www.amazon.de/s?k=touchdisplay+hdmin+5+zoll&__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=1BD4FHA7R3L3Q&sprefix=touchdisplay+hdmin+5+zoll%2Caps%2C109&ref=nb_sb_noss" target="_blank" rel="noopener noreferrer">5 inch touchdisplay with HDMI</a>
+ 1x <a href="https://www.amazon.de/s?k=raspberry+pi&crid=12N8W4YG4U65U&sprefix=rasp%2Caps%2C109&ref=nb_sb_ss_ts-doa-p_3_4" target="_blank" rel="noopener noreferrer">Rapberry Pi version 3 or higher</a>
+ 1x <a href="https://www.amazon.de/s?k=netzteil+raspberry&crid=VIPUZVRDEGV1&sprefix=Netzteil+Ra%2Caps%2C113&ref=nb_sb_ss_ts-doa-p_6_11" target="_blank" rel="noopener noreferrer">Power supply f&uuml;r Raspberry with min. 3A</a>
+ 1x <a href="https://www.amazon.de/s?k=hdmi+winkel+kabel&__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2GQAXFYRU6MAA&sprefix=hdmi+winkel+kabel+%2Caps%2C139&tag=drucktipps3d-21&ref=nb_sb_noss_2" target="_blank" rel="noopener noreferrer">HDMI-Cable</a> - As flexible as possible and with small plugs or angled plugs - measure out your path for the cable and use a sufficiently long cable.
+ 1x <a href="https://www.amazon.de/s?k=usb+kabel&crid=KCV1Z6W6QX2H&sprefix=USB+K%2Caps%2C116&ref=nb_sb_ss_ts-doa-p_1_5" target="_blank" rel="noopener noreferrer">USB-Cable</a> - depending on the type of USB connection of the display - also measure the installation length here.
+ 1x <a href="https://www.amazon.de/s?k=micro+sd+karte&crid=2700GPKRVNBPD&sprefix=Micro+Sd%2Caps%2C128&ref=nb_sb_ss_ts-doa-p_1_8" target="_blank" rel="noopener noreferrer">MicroSD-Card</a>
+ 1x <a href="https://www.amazon.de/s?k=Inbus&__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=14CFHDZSQ958R&sprefix=inbus%2Caps%2C107&ref=nb_sb_noss_1" target="_blank" rel="noopener noreferrer">Inbus-Set</a>


### Software für Display:

+ <a href="https://www.raspberrypi.com/software/" target="_blank" rel="noopener noreferrer">Raspberry Imager</a>

## **Installation Raspberry OS**

Open Raspberry Pi Imager and select your Pi
Under "Select OS" click on Raspberry Pi OS (other) and select Raspberry Pi OS Lite (64bit)

![Raspberry OS](/../main/images/raspberry1.png)

Click on Edit settings when asked whether OS settings should be adjusted. Enter your data in the window that opens.
In my case, I used the same user as on the printer - mks/makerbase
In the "Services" tab, select "Activate SSH" and "Use password for authentication".

![Raspberry OS](/../main/images/raspberry2.png)

Back in the menu, press "Yes" to confirm the acceptance of the parameters and confirm that all data on the SD card will now be deleted.
The SD card is now written with the OS. Once the flashing process is complete, a confirmation message should appear.

![Raspberry OS](/../main/images/raspberry3.png)

## Setup Display 
Depending on the display used, it may be necessary to add a few lines to the config.txt of the OS.
Open the SD card with the OS you have just flashed, search for the config.txt and open it in an editor such as Notepad etc.

I have entered the following code under [all] for the <a href="https://www.elecrow.com/5-inch-qled-quantum-dot-display-800-x-480-capacitive-touch-screen-support-various-systems.html" target="_blank" rel="noopener noreferrer">display</a> I am using. If you are using a different display - please check the manufacturer's website.

```bash
added by elecrow-pitft-setup
hdmi_force_hotplug=1
max_usb_current=1
hdmi_drive=1
hdmi_group=2
hdmi_mode=1
hdmi_mode=87
hdmi_cvt 800 480 60 6 0 0 0
dtoverlay=ads7846,cs=1,penirq=25,penirq_pull=2,speed=50000,keep_vref_on=0,swapxy=0,pmax=255,xohms=150,xmin=200,xmax=3900,ymin=200,ymax=3900 display_rotate=0
end elecrow-pitft-setup
```

+ Next, insert the SD card into the Rapberry Pi, connect all the necessary cables to the display and the Pi and switch on the power.
+ If the WLAN data has been entered correctly, the Raspberry should appear in the network overview of your router within a short time. As with the printer, make a fixed IP assignment here too.
The typical start sequence should now run on the display.

### *Installation KIUAH and Klipperscreen.*

+ Open Putty and create a connection as with the printer.
+ Log in with mks/makerbase
+ Update the system with the following commands

```bash
sudo apt update
sudo apt upgrade
```
+ The next step is to install KIAUH - the same procedure as for the printer

```bash
sudo apt-get update && sudo apt-get install git -y
cd ~ && git clone https://github.com/dw-0/kiauh.git
./kiauh/kiauh.sh
```

+ Switch to installation mode in the main menu of KIAUH via point 1 and select point 5 - Clipper screen
+ After completing the installation and returning to the main menu, it should look like this.

![Klipperscreen](/../main/images/klipperscreen1.png)

+ Exit KIAUH with Q

In order for Klipperscreen to interact with Moonraker, we need a few more folders/files.

+ Add the following commands to the console:

```bash
ls
mkdir printer_data
cd printer_data/
mkdir config
cd config/
```

We have now created several folders and are in the /printer_data/config/ folder in the console.
+ Enter the following in the console. It is also important to note that this is case-sensitive!

```bash
sudo nano KlipperScreen.conf
```

+ The nano editor opens in which we enter the following. The IP address of your printer should be known. 😄

```bash
[main]

[printer Name_how_your_printer_should_be_displayed]
moonraker_host: printer IP
moonraker_port: 7125
```

It looks like this in my case:
> [!TIP]
> ```bash
> [main]
>
> [printer X-Plus 3]
> moonraker_host: 192.168.188.69
> moonraker_port: 7125
> ```

Once you have entered everything accordingly, we save the KlipperScreen.conf with the following keystrokes.

+ STRG+O
+ Return
+ STRG+X

After closing the editor, reboot the system with the following command:

```bash
sudo reboot
```

The system restarts and loads the KlipperScreen UI



## **Mounting the display.**

+ In Mainsail, move the print head backwards and the print bed downwards. We need space.
+ Now switch off the printer at the power switch and pull the plug out of the socket.
+ Turn the printer so that you can see behind the original display.
+ The display is fastened at each corner with a screw. You will need a 2.5mm Allen key to loosen these screws
+ Disconnect the old connection cable from the display to the mainboard

Depending on the display you are using, you will need to construct a bracket to attach the new display to the old mounting points. Also pay attention - after tight comes off. You are only screwing into plastic again. In my case, the two upper attachment points were even torn off during assembly at Qidi. 😡

If you want to use my display. The package contains the STEP of the clamps for attaching the display. For the two upper mounting points, these need to be modified in size.
As I only have the lower mounting points left, I saved myself the trouble and used some double-sided adhesive tape to hold them in place.


## **Laying cables**

The next step is to lay the HDMI cable and the USB cable from the display to the Raspberry Pi. Find a route towards the mainboard chamber that is acceptable to you. Just make sure that the cables do not collide with the print head and the print bed. Cable ties help.
I ran everything down the right-hand side next to the large fan and then towards the mainboard.

## **Mounting Raspberry**

All that remains is to mount the Raspberry in the mainboard chamber. Owners of an X-Max 3 have an advantage here due to its size. Make sure that the small fan on the back of the cover does not come into contact with the Pi. Also make sure that the Pi and other conductive components are kept away from each other. Insulating tape or the underside of the housing are helpful here.

## **Raspberry power supply**

I took the Raspberry's power supply outside and connected it to an IKEA smart plug together with the printer. How you ultimately solve this yourself is up to you. 
Close the printer cover again and carefully secure it with the screws. The screws are also screwed into plastic. If you screw too tightly, you will end up screwing forever.😜

## **Touchscreen in action**
This is what the whole thing looks like in action and permanently installed in the Qidi.

![Display](/../main/images/display1.png)

And another screen.

![Display](/../main/images/display2.png)

If you liked this guide:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G7VMD0W)
