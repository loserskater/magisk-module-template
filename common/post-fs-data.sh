#!/system/bin/sh
MODDIR=${0%/*}

STOREDLIST=${MODDIR}/extras/appslist.conf
#STOREDLIST=/data/data/net.loserskater.appsystemizer/appslist.conf

apps=(
"com.google.android.apps.nexuslauncher,NexusLauncherPrebuilt,priv-app,1"
"com.google.android.apps.wallpaper,WallpaperPickerGooglePrebuilt,app,1"
"com.google.android.apps.tycho,Tycho,app,1"
)

LOGFILE=/cache/magisk.log
log_print() {
  echo $1
  echo "App Systemizer: $1" >> $LOGFILE
  log -p i -t AppSystemizer "$1"
}

[ -s "$STOREDLIST" ] && eval apps="($(<${STOREDLIST}))" && log_print "Loaded apps list from ${STOREDLIST#${MODDIR}/}."  || log_print "Failed to load apps list from ${STOREDLIST#${MODDIR}/}."

for line in "${apps[@]}"; do 
  IFS=',' read canonical name path status <<< $line
  [ -z "$canonical" ] && continue
  path="${path:=priv-app}"
  [ -n "$name" ] && newname="${name}/${name}" || newname="${canonical}"
  if [ "$status" = "1" -a "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
# App is active in appslist.conf, canonical APK exists in data
  	if [[ ( -z "$name" || ! -d "/system/${path}/${name}" ) && ( ! -f "/system/${path}/${canonical}.apk" ) && \
  	      ( -z "$name" || ! -d "${MODDIR}/system/${path}/${name}" ) && ( ! -f "${MODDIR}/system/${path}/${canonical}.apk" ) ]]; then
# App is not currently a system app and has not been systemied by the module
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
  	fi
  fi
  if [ "$status" = "1" -a "$(echo /data/app/${canonical}-*)" == "/data/app/${canonical}-*" -a  ]; then
# App is active in appslist.conf, but canonical APK no longer exists in data
  	[ -n "$name" -a -d "${MODDIR}/system/${path}/${name}" ] && rm -rf "${MODDIR}/system/${path}/${name}" && log_print "Unsystemizing uninstalled $name."
  	[ -f "${MODDIR}/system/${path}/${canonical}.apk" ] && rm -rf "${MODDIR}/system/${path}/${canonical}.apk" && log_print "Unsystemizing uninstalled $canonical.apk."
  fi
  if [ "$status" != "1" -a "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
# App is inactive in appslist.conf, canonical APK exists in data
  	[ -n "$name" -a -d "${MODDIR}/system/${path}/${name}" ] && rm -rf "${MODDIR}/system/${path}/${name}" && log_print "Unsystemizing inactive $name."
   	[ -f "${MODDIR}/system/${path}/${canonical}.apk" ] && rm -rf "${MODDIR}/system/${path}/${canonical}.apk" && log_print "Unsystemizing inactive $canonical.apk."
  fi
done
