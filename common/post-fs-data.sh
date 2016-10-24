#!/system/bin/sh

MODPATH=/magisk/AppSystemizer
STOREDLIST=${MODPATH}/extras/appslist.conf
#STOREDLIST=/data/data/net.melmac.appsystemizer/files/appslist.conf

apps=(
"com.google.android.apps.nexuslauncher,NexusLauncherPrebuilt,priv-app,1"
"com.google.android.apps.wallpaper,WallpaperPickerGooglePrebuilt,app,1"
"com.google.android.apps.tycho,Tycho,app,1"
)
permreset=
debug=1

LOGFILE=/cache/magisk.log
log_print() {
  echo $1
  echo "AppSys: $1" >> $LOGFILE
  log -p i -t AppSys "$1"
}

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

[ -s $STOREDLIST ] && eval apps="($(<${STOREDLIST}))" && log_print "Loaded apps list from $STOREDLIST."

for line in "${apps[@]}"; do 
  IFS=',' read canonical name path status <<< $line
  [ -z "$path" ] && path='priv-app'
  if [ status -eq 1 -a "$(echo /data/app/${canonical}-*)" != "/data/app/${canonical}-*" ]; then
  	if [[ ( ! -z "$name" && ! -d /system/${path}/${name} ) || ( -z "$name" && ! -f /system/${path}/${canonical}.apk ) && \
  	( ! -z "$name" && ! -d ${MODPATH}/system/${path}/${name} ) || ( -z "$name" && ! -f ${MODPATH}/system/${path}/${canonical}.apk ) ]]; then
	    mkdir -p ${MODPATH}/system/${path}/${name} 2>/dev/null
    	for i in /data/app/${canonical}-*/base.apk; do
	      [ -z "$name" ] && newname="${canonical}" || newname="${name}/${name}"
    	  log_print "Copying $i to ${MODPATH}/system/${path}/${newname}.apk"
	      cp -f $i ${MODPATH}/system/${path}/${newname}.apk
    	done
	    permreset=1
  	fi
  fi
done

if [ ! -z "$permreset" ]; then
  set_perm_recursive ${MODPATH}/system 0 0 0755 0644
fi