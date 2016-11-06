#!/system/bin/sh

MODPATH=/magisk/AppSystemizer
STOREDLIST=${MODPATH}/extras/appslist.conf
#STOREDLIST=/data/data/net.loserskater.appsystemizer/appslist.conf

apps=(
"com.google.android.apps.nexuslauncher,NexusLauncherPrebuilt,priv-app,1"
"com.google.android.apps.wallpaper,WallpaperPickerGooglePrebuilt,app,1"
"com.google.android.apps.tycho,Tycho,app,1"
)

LOGFILE=/cache/magisk.log
log_print() {
  echo $1
  echo "AppSys: $1" >> $LOGFILE
  log -p i -t AppSys "$1"
}

bind_mount() {
    mount -o bind $1 $2
    if [ "$?" -eq "0" ]; then log_print "Mount $1";
    else log_print "Mount Fail $1 $2"; fi
}

[ -s $STOREDLIST ] && eval apps="($(<${STOREDLIST}))" && log_print "Loaded apps list from $STOREDLIST."

for line in "${apps[@]}"; do 
  IFS=',' read canonical name path status <<< $line
  [ -z "$canonical" ] && continue
  [ -z "$path" ] && path='priv-app'
  if [ "$status" = "1" -a "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
  	if [[ ( ( -n "$name" && ! -d /system/${path}/${name} ) || ( -z "$name" && ! -f /system/${path}/${canonical}.apk ) ) && \
  	( ( -n "$name" && ! -d ${MODPATH}/system/${path}/${name} ) || ( -z "$name" && ! -f ${MODPATH}/system/${path}/${canonical}.apk ) ) ]]; then
    	for i in /data/app/${canonical}-*/base.apk; do
	      if [ "$i" != "/data/app/${canonical}-*/base.apk" ]; then
	      	[ -n "$name" ] && newname="${name}/${name}" || newname="${canonical}"
	      	mkdir -p ${MODPATH}/system/${path}/${name} 2>/dev/null
	      	cp -f $i ${MODPATH}/system/${path}/${newname}.apk && log_print "Copy ./${path}/${newname}.apk" || log_print "Copy Fail: $i ${MODPATH}/system/${path}/${newname}.apk"
	      	chown 0:0 ${MODPATH}/system/${path}/${name}
	      	chmod 0755 ${MODPATH}/system/${path}/${name}
	      	chown 0:0 ${MODPATH}/system/${path}/${newname}.apk
	      	chmod 0644 ${MODPATH}/system/${path}/${newname}.apk
	      fi
    	done
  	fi
  fi
  if [ "$status" != "1" -a "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
  	[ -n "$name" -a -d ${MODPATH}/system/${path}/${name} ] && rm -rf ${MODPATH}/system/${path}/${name} && log_print "Unsystemizing $name."
  	[ -z "$name" -a -f ${MODPATH}/system/${path}/${canonical}.apk ] && rm -rf ${MODPATH}/system/${path}/${name} && log_print "Unsystemizing $canonical.apk."
  fi
done

#find $MODPATH/system -type f 2>/dev/null | while read f; do
#	TARGET=${f#$MODPATH}
#	bind_mount $f /magisk/.core/dummy${TARGET}
#	bind_mount $f $TARGET
#done
