#!/system/bin/sh

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

set_perm() {
  chown $2:$3 $1 || exit 1
  chmod $4 $1 || exit 1
  if [ "$5" ]; then
    chcon $5 $1 2>/dev/null
  else
    chcon 'u:object_r:system_file:s0' $1 2>/dev/null
  fi
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}

SPRIV=/system/priv-app
MPRIV=/magisk/AppSystemizer/system/priv-app
SAPP=/system/app
MAPP=/magisk/AppSystemizer/system/app
permreset=

if [ ! -d ${SPRIV}/NexusLauncherPrebuilt -a ! -d ${MPRIV}/NexusLauncherPrebuilt -a -d /data/app/com.google.android.apps.nexuslauncher* ]; then 
	mkdir -p ${MPRIV}/NexusLauncherPrebuilt
	for i in /data/app/com.google.android.apps.nexuslauncher*/base.apk; do
		cp $i ${MPRIV}/NexusLauncherPrebuilt/NexusLauncherPrebuilt.apk
	done
	permreset=1
fi

if [ ! -d ${SAPP}/WallpaperPickerGooglePrebuilt -a ! -d ${MAPP}/WallpaperPickerGooglePrebuilt -a -d /data/app/com.google.android.apps.wallpaper* ]; then
	mkdir -p ${MAPP}/WallpaperPickerGooglePrebuilt
	for i in /data/app/com.google.android.apps.wallpaper*/base.apk; do
		cp $i ${MAPP}/WallpaperPickerGooglePrebuilt/WallpaperPickerGooglePrebuilt.apk
	done
	permreset=1
fi

if [ ! -d ${SAPP}/Tycho -a ! -d ${MAPP}/Tycho -a -d /data/app/com.google.android.apps.tycho* ]; then
	mkdir -p ${MAPP}/Tycho
	for i in /data/app/com.google.android.apps.tycho*/base.apk; do
		cp $i ${MAPP}/Tycho/Tycho.apk
	done
	permreset=1
fi

if [ ! -d ${SPRIV}/ActionLauncher -a ! -d ${MPRIV}/ActionLauncher -a -d /data/app/com.actionlauncher.playstore* ]; then
	mkdir -p ${MPRIV}/ActionLauncher
	for i in /data/app/com.actionlauncher.playstore*/base.apk; do
		cp $i ${MPRIV}/ActionLauncher/ActionLauncher.apk
	done
	permreset=1
fi

[ ! -z "$permreset" ] && set_perm_recursive /magisk/AppSystemizer/system 0 0 0755 0644