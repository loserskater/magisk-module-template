#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

set +f
STOREDLIST=${MODDIR}/extras/appslist.conf
#STOREDLIST=/data/data/net.loserskater.appsystemizer/appslist.conf

apps=(
"com.google.android.apps.nexuslauncher,NexusLauncherPrebuilt,priv-app,1"
"com.google.android.apps.pixelclauncher,PixelCLauncherPrebuilt,priv-app,1"
"com.google.android.apps.wallpaper,WallpaperPickerGooglePrebuilt,app,1"
"com.google.android.apps.tycho,Tycho,app,1"
)

log_print() {
  local LOGFILE=/cache/magisk.log
  echo "App Systemizer: $1" >> $LOGFILE
  log -p i -t AppSystemizer "$1"
}

[ -d /system/priv-app ] || log_print "No access to /system/priv-app!"
[ -d /system/app ] || log_print "No access to /system/app!"
[ -d /data/app ] || log_print "No access to /data/app!"

[ -s "$STOREDLIST" ] && eval apps="($(<${STOREDLIST}))" && log_print "Loaded apps list from ${STOREDLIST#${MODDIR}/}."  || log_print "Failed to load apps list from ${STOREDLIST#${MODDIR}/}."

for line in "${apps[@]}"; do
  IFS=',' read canonical name path status <<< $line
  [ -z "$canonical" ] && continue
  path="${path:=priv-app}"
  [ -n "$name" ] && newname="${name}/${name}" || newname="${canonical}"
  case $status in
    1)
      if [ "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
        # App is active in appslist.conf, canonical APK exists in data
        [ -e "${MODDIR}/system/${path}/${newname}.apk" ] && { log_print "Ignoring /data/app/${canonical}-*: already a systemized app."; continue; }
        [[ -n "$name" && -e "${MODDIR}/system/${path}/${name}" ]] && { log_print "Ignoring /data/app/${canonical}-*: already a systemized app."; continue; }
        [ -e "/system/${path}/${newname}.apk" ] && { log_print "Ignoring /data/app/${canonical}-*: already a system app."; continue; }
        [[ -n "$name" && -e "/system/${path}/${name}" ]] && { log_print "Ignoring /data/app/${canonical}-*: already a system app."; continue; }
        	for i in /data/app/${canonical}-*/base.apk; do
    	      if [ "$i" != "/data/app/${canonical}-*/base.apk" ]; then
    	      	mkdir -p "${MODDIR}/system/${path}/${name}" 2>/dev/null
    	      	cp -f "$i" "${MODDIR}/system/${path}/${newname}.apk" && log_print "Created ${path}/${newname}.apk" || log_print "Copy Failed: $i ${MODDIR}/system/${path}/${newname}.apk"
    	      	chown 0:0 "${MODDIR}/system/${path}/${name}"
    	      	chmod 0755 "${MODDIR}/system/${path}/${name}"
    	      	chown 0:0 "${MODDIR}/system/${path}/${newname}.apk"
    	      	chmod 0644 "${MODDIR}/system/${path}/${newname}.apk"
    	      fi
        	done
      else
        # App is active in appslist.conf, but canonical APK no longer exists in data
        [[ -n "$name" && -d "${MODDIR}/system/${path}/${name}" ]] && rm -rf "${MODDIR}/system/${path}/${name}" && log_print "Unsystemizing uninstalled $name."
        [[ -e "${MODDIR}/system/${path}/${canonical}.apk" ]] && rm -rf "${MODDIR}/system/${path}/${canonical}.apk" && log_print "Unsystemizing uninstalled $canonical.apk."
      fi
      ;;
    *)
      if [ "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
        # App is inactive in appslist.conf, canonical APK exists in data
      	[[ -n "$name" && -d "${MODDIR}/system/${path}/${name}" ]] && rm -rf "${MODDIR}/system/${path}/${name}" && log_print "Unsystemizing inactive $name."
       	[[ -e "${MODDIR}/system/${path}/${canonical}.apk" ]] && rm -rf "${MODDIR}/system/${path}/${canonical}.apk" && log_print "Unsystemizing inactive $canonical.apk."
      fi
      ;;
  esac
done
