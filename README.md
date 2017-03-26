# AppSystemizer
This module converts a pre-defined list of installed apps to system apps (systemlessly, as in without modifying your /system partition, thru magisk). Now comes with companion app, which lets you pick any of the user-installed apps to be converted to a system app (you'll need to reboot twice to "systemize" apps you select). If you want full control over which apps do/do not get systemized, you'll need to edit the ```/magisk/AppSystemizer/extras/appslist.conf``` text file. [Support thread](https://forum.xda-developers.com/showthread.php?t=3477512).

## Supported Apps
* Action Launcher (for Google Now integration)
* Nexus/Pixel C Launcher (and their Wallpaper Picker)
* Project Fi (for Project Fi-compatible phones running third-party ROMs)
* Cerberus Anti Theft
* Disguised Cerberus Anti Theft
* Wakelock Detector (2 apps)
* BetterBatteryStats (Play Store and XDA Edition)
* Google Contacts and Google Dialer (for devices shipping with custom Contacts and Dialer, like HTC devices)
* Unicon Icon Themer
* ProximityService
* Greenify (free and Donation Package editions)
* Chrome Customizations
* Viper4Android (just systemizes the APK, still requires a separate ViPER4Android module)
* Brevent
* Added FakeGPS (3 apps)
* GPS JoyStick - Fake Fly GPS GO
* Fake GPS JoyStick
* F-Droid
* Tiles
* microG/GApps alternatives
* Pseudo GPS
* Mock Locations
* Lockito – Fake GPS itinerary

#### Supported Apps which no longer require to be systemized
* GSam Battery Monitor and GSam Battery Monitor Pro

## Change Log
11.1.0
  - Now includes companion app written by [@loserskater](https://github.com/loserskater).

11.0.7
  - Added support for Lockito – Fake GPS itinerary, Pseudo GPS and Mock Locations -- thanks @cangurob!
  - Fix bug with Cerberus being unsystemized on start. If you've used the Cerberus APK not from the play store, but from Cerberus web-site directly, please uninstall AppSystemizer first, reboot and install the new version of AppSystemizer after reboot.
  - Print version number into magisk log.
  - Pixel C Launcher support added.
  - microG/GApps alternatives -- thanks @animeme!
  - Magisk v11-compatible, use of template v3.

10.0.11
  - Tiles -- thanks @grandpajiver!
  - F-Droid support added.
  - Fake GPS JoyStick support added.
  - GPS JoyStick - Fake Fly GPS GO support added.
  - Added FakeGPS (3 apps) support added.
	- Reworked binary logic for determining if the app is already system or has been systemized.
	- Added more Magisk Log output during the module update.
	- Error-proofed some file manipulation code.
	- Actively unsystemize GSam Battery Monitor and GSam Battery Monitor Pro again.
	- Actively unsystemize uninstalled apps listed in appslist.conf.
	- Support for Greenify (Donation Package) added.
	- Emergency release hopefully fixing issue with 10.0.4 installs (dropped GSam Battery Monitor and GSam Battery Monitor Pro from appslist.conf).
	- Actively unsystemize GSam Battery Monitor and GSam Battery Monitor Pro -- thanks @yochananmarqos!
	- Support for Brevent -- thanks @simonsmh!
	- Support for Disguised Cerberus -- thanks @iNFeRNuSDaRK!
	- Support for Viper4Android (just systemizes the APK, still requires a separate ViPER4Android module) -- thanks @FlemishDroid!
	- Support for GSam Battery Monitor Pro -- thanks @Noxious Ninja!
	- Magisk v10 compatible.

1.3.1
	- Modified module install/update logic.
	- Second reboot no longer required.

1.2.5
	- Support for Chrome Customizations -- thanks @Link_of_Hyrule!
	- Support for Greenify and BetterBatteryStats XDA Edition -- thanks @yochananmarqos!
	- Support for GSam Battery Monitor -- thanks jsaxon2!
	- Support for com.uzumapps.wakelockdetector.noroot removed.
	- Support for Proximity Services.
	- Fixed bug with missing appslist.conf file after migration to magisk-v9 module template.

1.1.9
    - Migration to magisk-v9 module template.
    - Preparation for external apps list/companion app.
    - Added support for Google Contacts and Google Dialer.
    - Added back support for BetterBatteryStats.
    - Removed support for BetterBatteryStats.
    - Support for Wakelock Detector.
    - Support for BetterBatteryStats.
    - Bash use bugfix.
    - Support for SuperSu.
    - Bugfixes.
    - Support for Cerberus Anti Theft.
    - Logic rewrite allowing to add new apps quicker.

1.0.0
    - Initial release.
