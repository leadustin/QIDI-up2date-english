# **Filament drying per print bed**

This macro makes it possible to dry moist filament via the heating bed of the Qidi Max-3, Plus-3 and similar printers.
The PIN assignments of the fans may have to be adjusted accordingly for non-QIDI printers. 
If the printer does not have an active chamber heater, this must also be commented out accordingly.

For the actual drying process, it is advisable to use an appropriately sized aluminium can in which to place the filament roll. The base of the tin should lie flat on the heating bed.
This creates a build-up of heat inside the tin.
To allow moist air to escape, the tin must be provided with holes through which the air can escape. By skilfully positioning the holes, air circulation can be ensured in conjunction with the fans.

# **Disclaimer**
> [!CAUTION]
> Please note that neither I nor any other third party will be responsible for any damage to your printer if you follow this tutorial.
> Do not leave your printer unattended during the drying process. Take fire safety measures such as installing a fire alarm!

## Installation

Once the printer has been customised according to my <a href="https://github.com/leadustin/QIDI-up2date-english/blob/main/Klipper-Update/update%2Bupgrade.md">guide</a>, the drying.cfg file can be copied to the macros folder.
Then include the file in the printer.cfg via include.
```bash
[include Macros/drying.cfg]
```
As soon as Mainsail has loaded the web interface, there are 3 new macros in the macro overview.
+ START_DRYING
+ STOP_DRYING
+ STATUS_DRYING

STATUS_DRYING is automatically executed by START_DRYING and can therefore be hidden in the macro configuration menu.

### Configuration and function of the START_DRYING macro
The small arrow to the right of the macro button opens the configuration menu. The following menu items can be configured:
+ Z-displacement of the print bed - value in mm
+ Chamber - value in degrees Celsius
+ Bed - value in degrees Celsius
+ Drying_DURATION - value in minutes
+ Circulation - value in % 
+ Circulation run time - value in minutes
+ Circulation wait time - value in minutes
+ Exhaust - value in % 
+ Exhaust run time - value in minutes
+ Exhaust wait time - value in minutes

### Z-displacement of the print bed

When the macro is executed, the system checks whether the printer is already homed. After checking, the print bed moves down by the value set in the macro.
This is necessary because the filament roll must fit between the print head and the heating bed.

###  Active chamber heater

The active chamber heating can be configured here. Values are given in degrees Celsius.

### Print bed

The print bed item is responsible for the temperature of the print bed. Care must be taken here to define a temperature suitable for the filament. 
PLA with a print bed temperature of 80 degrees Celsius is a bad idea! The maximum value is 100 degrees Celsius.

### Drying time

The drying time defines how long the drying process takes. Values are given in minutes. The maximum drying time is currently configured to 720 minutes (12 hours).

### Air circulation

The side fan is configured under Recirculation. Speed values are entered in per cent.

### Running time_recirculation

The Runtime_recirculation menu item defines how long the side fan runs. The value is entered in minutes.

### Exhaust air

The Exhaust air item defines the fan on the rear wall of the printer. The value is also entered here in minutes.

### Running time_exhaust air

The runtime of the exhaust air fan is defined here in a similar way to runtime_recirculation. Values are entered in minutes.

### Waiting time_exhaust air

The waiting time of the exhaust air fan is defined here in minutes.


## Functionality of fan control

The fan control works as follows. The speed of both fans is defined via recirculation and exhaust air. Whether you use both fans, just one or none is up to you.
The value "0" switches off the respective fan.

The running times define how long the fan remains active. Intervals can be defined in combination with the waiting time.

### Example fan configuration

Exhaust air fan is defined with 50% power. Running time is 10 minutes and waiting time is 30 minutes. 
This means that the fan is activated after 30 minutes for a runtime of 10 minutes with a power of 50%. After the 10 minutes have elapsed, a waiting time of 30 minutes begins again.
This is repeated until the set drying time has elapsed or the drying process has been stopped manually.
If a "0" is entered for running time and waiting time, the respective fans run permanently until the end of the drying process.

This means that moist air can be extracted at a set time or additional air circulation can take place.

### Configuration and function of the STOP_DRY macro

The STOP_DRYING macro stops the fans and switches off the tree room heating and the heating bed after the drying time has elapsed or after manual activation.

### Status displays

The macro outputs various information via M117 (console) and M118 (display).
If you have installed the Moonraker Telegram extension, you can comment out the following line to receive a notification to your Telegram bot.

+ ;RESPOND PREFIX=tgnotify MSG="Filament drying has ended. Please remove filament."

### Maximum values

As previously mentioned, a few maximum values are defined in the script. These are as follows:

+ drying time = 720 minutes = 12 hours
+ maximum print bed temperature = 100 degrees Celsius
+ maximum build chamber temperature = 60 degrees Celsius

If you want to adjust these values, you can do so with these constants

+ {% set drying_duration_minutes = 720 %}
+ {% set max_chamber_temp = 60.0 %}
+ {% set max_bed_temp = 100.0 %}


[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G7VMD0W)

