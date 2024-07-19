# **Github-Backup**
This guide is based on the work of <a href="https://github.com/EricZimmerman">Eric Zimmerman</a> and describes how to upload configs, macros etc. manually or automatically to your own Github repository and, if necessary, restore them as a backup on your 3D printer.
To make it easier to follow the guide, all console commands are prepared for copy&paste. Images have also been added to this guide to make individual steps easier to understand.
> [!IMPORTANT]
> The access token shown in this guide and the repository were only created for this guide. Both have already been deleted. Just in case someone tries to gain access with this data. 😄

## **What is needed?**
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
    
![Initialization](/../main/images/backup3.png)

After creating the repository, you will be redirected to the current "root directory". 
Copy the HTTPS URL of your repository and paste it into a text editor of your choice. 

![HTTPS-URL](/../main/images/backup4.png)

## **Create access token**
To gain access to the repository via the printer, we need an "access token" which we create <a href="https://github.com/settings/tokens">here</a>.
+ Click on "Generate new token".
+ Select "Generate new token (classic).

![Token selection](/../main/images/backup5.png)

In the next step, the token is configured with the corresponding access rights.
1. name of the token
   + Under "Note", select a suitable name that can be associated with your printer.
2. validity period
   + Select "No expiration" under Expiration.
> [!TIP]
> If you like, you can also select a period of time after which the access token loses its validity. After this period, the printer cannot access the repository and the token must be renewed.
3. select access areas
   + Select only "workflow" and "read:org" to define the access areas.
4. finalize configuration
   + Scroll all the way down and click on "Generate token".

![Token-Selection](/../main/images/backup7.png)

5. Securing the token
   + After the token has been created, we find ourselves in the administration overview of all tokens created so far.
> [!CAUTION]
> This is the only time you will see your token on Github! It is important that the token is backed up accordingly, as it cannot be restored from Github! If access to this token is lost, a new one must be created. If someone has the idea of uploading the token to Github - forget this idea. Github recognizes the token and will delete it!

![Token-Selection](/../main/images/backup8.png)

Copy the token into the text file into which you have copied the HTTPS URL of your repository.

![Token in Notepad](/../main/images/backup9.png)

## **Combining the HTTPS URL with the token**
The next step is to combine the token and URL.
+ Insert a **@** after the two **//** in the URL.
+ Copy your token to the clipboard and insert the token between **//** and **@**. The following image shows how the URL should look.
> [!NOTE]
>  Just a reminder. The repository and token created for this guide were deleted after the guide was created!

![Token+URL](/../main/images/backup_eng_10.png)

## **Connect to the printer via SSH**
Connect to the printer via SSH using the tool of your choice. I use "Putty" in this guide
+ Change the directory with the following command:

  ```bash
  cd ~/printer_data/config
  ```
  
+ We need a "Scripts" folder that is created with the following command:

  ```bash
  mkdir Scripts
  ```

+ The autocommit script is downloaded with the following command:

  ```bash
  wget -O ~/printer_data/config/Scripts/autocommit.sh https://raw.githubusercontent.com/EricZimmerman/VoronTools/main/autocommit.sh
  ```

+ The next step is to select the preferred web interface. If you use Mainsail, remove the # in the Mainsail line. If you use Fluidd, select Fluidd accordingly. To do this, we open autocommit.sh with the following command

  ```bash
  nano ~/printer_data/config/Scripts/autocommit.sh
  ```
+ The following image shows the configuration for Mainsail. Fluidd is commented out accordingly.

![MainsailoderFluidd](/../main/images/backup_eng_11.png)

+ Save the autocommit.sh with CTRL+O and then Enter
+ CTRL+X closes the editor and we are back in the path "printer_data/config/"
+ With the following command we change the directory

  ```bash
  cd Scripts
  ```

+ With the following command we give ourselves and all other users of the system the authorization to execute the autocommit.sh

  ```bash
  chmod +x autocommit.sh
  ```
+ Use the following command to check whether the authorizations are set correctly, as shown in the following image.
  ```bash
  ls -la autocommit.sh
  ```
![Authorizations](/../main/images/backup_eng_12.png)

+ For the export and backup of the data.mdb we need another tool, which is installed with the following command.

  ```bash
  sudo apt install lmdb-utils
  ```
> [!IMPORTANT]
> In the default settings, ALL data.mbd tables are saved in the repository. If you work with API keys and other user data, you can prevent this by setting the "history_only" section in "autocommit.sh" to "true".

## **Prepare backup on Github**
To prepare Github for the backup of our data, we need to add the following command to the console:

```bash
git init -b main
```
![Github initialisieren](/../main/images/backup13.png)

Now we need to tell Git which URL to use to access our repository.
+ Copy the following text to the clipboard and paste it into the text file before the token URL:
  ```bash
  git remote add origin
  ```
![Git-URL](/../main/images/backup14.png)

+ Enter the command created in the text file from the previous screen into the console.
+ The next step is verification with the following command:
  
  ```bash
  git remote -v
  ```
![Verification](/../main/images/backup15.png)

+ Now we need to tell Git our email and your name. This is the email and the name you use at Github. The following commands are used for this, which are supplemented with your data accordingly. 

  ```bash
   git config --global user.email "your@email.com"
   git config --global user.name "your name"
  ```
So that we do not save unnecessary files, we need an exclusion list, which is created as follows:
+ We should currently still be in the "printer_data/config/" directory. If not, change there with the following command.
  
  ```bash
  cd ~/printer_data/config
  ```
+ With this command we create the .gitignore file. The dot in front of gitignore is important!
  
  ```bash
  nano .gitignore
  ```
+ Now enter the paths of the files that are NOT to be backed up in the editor. Since I have installed Klippain Shake&Tune, these would be the paths. Save the file with CTRL+O, followed by Enter and then CTRL+X
  
  ```bash
  K-ShakeTune_results/belts/*.csv
  K-ShakeTune_results/belts/*.png
  K-ShakeTune_results/inputshaper/*.csv
  K-ShakeTune_results/inputshaper/*.png
  K-ShakeTune_results/vibrations/*.tar.gz
  K-ShakeTune_results/vibrations/*.png
  ```
> [!NOTE]
  Excluding files is an optional step! If you want to save all data from the printer_data/config folder, leave the .gitignore empty.

## **The first backup**
We are ready to create the first backup.
+ Enter the following command in the console:

  ```bash
  cd ~/printer_data/config/Scripts
  sh autocommit.sh
  ```
+ If all the necessary steps have been carried out correctly beforehand, it should look something like this in the console. As I have set up my own system for this guide, the amount of data transmitted will be higher.

  ![Backup](/../main/images/backup16.png)

+ If the command sh.autocommit.sh is inserted into the console again without any changes to the system, it should look like the picture.

  ![BackupClean](/../main/images/backup17.png) 

+ The following image shows how a change to a config is displayed. A change in printer.cfg serves as an example

  ![BackupChange](/../main/images/backup18.png)

## **History on Github**
Now let's take a look at the change history on Github. Click on Commits in the root directory of the repository
 ![Commits](/../main/images/backup19.png)

All changes currently made are displayed. These are displayed sorted by date and time.

 ![Commits2](/../main/images/backup20.png)

Click on one of the commits to open the comparison view. In this case, the value of max_accel has been set from 1000 to 10000.

 ![Commits](/../main/images/backup21.png)

## **Update via macro**
To conveniently create a backup via macro, insert the following code into the file containing your macros. If you have followed my guide for the [complete update](/Klipper-Update/update+upgrade.md) of the printer, the macro should be inserted into the Macros/macro.cfg.
```bash
 [gcode_shell_command backup_cfg]
 command: ~/printer_data/config/Scripts/autocommit.sh
 timeout: 30
 verbose: True

 [gcode_macro BACKUP_CFG]
 description: Backs up config directory GitHub
 gcode:
     RUN_SHELL_COMMAND CMD=backup_cfg

 [delayed_gcode auto_backups]
 initial_duration: 10 #A backup is automatically created after 10 seconds
 gcode:
    RUN_SHELL_COMMAND CMD=backup_cfg
```
We are approaching the end, but still need the "gcode_shell_command" tool. If you have installed Klippain Shake&Tune, this step is not necessary as Klippain Shake&Tune installs the script as well. 
If Klippain Shake&Tune has not yet been installed, there are now 2 options to install it. 
+ Either via KIAUH via point 4 and then point 8.
+ Option 2 would be via the following command in the console:

```bash
 wget -O ~/klipper/klippy/extras/gcode_shell_command.py https://raw.githubusercontent.com/th33xitus/kiauh/master/resources/gcode_shell_command.py
```
## **Executing the macro**
The macro "BACKUP CFG" can now be found in the macro overview. This is the manual way to back up your data.

![MACRO](/../main/images/backup22.png)

In addition, the macro is automatically called up after 10 seconds each time Klipper is restarted

![MACRO](/../main/images/backup23.png)

## **Restore backup**
The most recent backup is restored with the following commands. Of course, your token URL must be inserted. Remember that files and paths stored in the .gitignore are not backed up and therefore cannot be restored!

```bash
cd ~/printer_data/config
 git init -b main
 git remote add origin https://<token>@github.com/leadustin/testconfig.git
 git fetch
 git reset origin/main
 git reset --hard HEAD
```

If you like this guide:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/G2G7VMD0W)


  



