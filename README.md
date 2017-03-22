# AppSystemizer
This module converts a pre-defined list of installed apps to system apps. [More details in support thread](https://forum.xda-developers.com/showthread.php?t=3477512).

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

#### Supported Apps which no longer require to be systemized
* GSam Battery Monitor and GSam Battery Monitor Pro

## Change Log
11.0.6
  - Added support for Pseudo GPS and Mock Locations -- thanks cangurob!
  - Fix bug with Cerberus being unsystemized on start. If you've used the Cerberus APK not from the play store, but from Cerberus web-site directly, please uninstall AppSystemizer first, reboot and install the new version of AppSystemizer after reboot.
  - Print version number into magisk log.
  - Pixel C Launcher support added.
  - microG/GApps alternatives -- thanks animeme!
  - Magisk v11-compatible, use of template v2.

10.0.11
  - Tiles -- thanks grandpajiver!
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
	- Actively unsystemize GSam Battery Monitor and GSam Battery Monitor Pro -- thanks yochananmarqos!
	- Support for Brevent -- thanks simonsmh!
	- Support for Disguised Cerberus -- thanks iNFeRNuSDaRK!
	- Support for Viper4Android (just systemizes the APK, still requires a separate ViPER4Android module) -- thanks FlemishDroid!
	- Support for GSam Battery Monitor Pro -- thanks Noxious Ninja!
	- Magisk v10 compatible.

1.3.1
	- Modified module install/update logic.

1.3.0
	- Second reboot no longer required.

1.2.5
	- Support for Chrome Customizations -- thanks Link_of_Hyrule!

1.2.4
	- Support for Greenify and BetterBatteryStats XDA Edition -- thanks yochananmarqos!

1.2.3
	- Support for GSam Battery Monitor -- thanks jsaxon2!

1.2.2
	- Support for com.uzumapps.wakelockdetector.noroot removed.

1.2.1
	- Support for Proximity Services.

1.2.0
	- Fixed bug with missing appslist.conf file after migration to magisk-v9 module template.

1.1.9
    - Migration to magisk-v9 module template.

1.1.7
    - Preparation for external apps list/companion app.

1.1.6
    - Added support for Google Contacts and Google Dialer.

1.1.5
    - Added back support for BetterBatteryStats.

1.1.4
    - Removed support for BetterBatteryStats.

1.1.3
    - Support for Wakelock Detector.
    - Support for BetterBatteryStats.

1.1.2
    - Bash use bugfix.
    - Support for SuperSu.

1.1.1
    - Bugfixes.

1.1.0    
    - Support for Cerberus Anti Theft.
    - Logic rewrite allowing to add new apps quicker.

1.0.0
    - Initial release.
