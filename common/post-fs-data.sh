#!/system/bin/sh

MODPATH=/magisk/AppSystemizer
apps=(
"NexusLauncherPrebuilt com.google.android.apps.nexuslauncher priv-app" 
"WallpaperPickerGooglePrebuilt com.google.android.apps.wallpaper app"
"Tycho com.google.android.apps.tycho app"
"ActionLauncher com.actionlauncher.playstore priv-app" 
"CerberusAntiTheft com.lsdroid.cerberus priv-app" 
)
permreset=

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

for line in "${apps[@]}"; do 
  IFS=' ' read name canonical path <<< $line
  if [ ! -z "$LOGFILE" ]; then
#    [ -d /system/${path}/${name} ] && log_print "/system/${path}/${name}: yes" || log_print "/system/${path}/${name}: no" 
#    [ -d ${MODPATH}/system/${path}/${name} ] && log_print "${MODPATH}/system/${path}/${name}: yes" || log_print "${MODPATH}/system/${path}/${name}: no" 
#    [ -d /data/app/${canonical}* ] && log_print "/data/app/${canonical}*: yes" || log_print "/data/app/${canonical}*: no" 
  fi
  if [ ! -d /system/${path}/${name} -a ! -d ${MODPATH}/system/${path}/${name} -a -d "/data/app/${canonical}"?? ]; then 
    log_print "Found /data/app/${canonical}"
    mkdir -p ${MODPATH}/system/${path}/${name} 2>/dev/null
    for i in /data/app/${canonical}*/*.apk; do
      log_print "Copying $i to ${MODPATH}/system/${path}/${name}/${name}.apk"
      cp -f $i ${MODPATH}/system/${path}/${name}/${name}.apk
    done
    permreset=1
  fi
done

if [ ! -z "$permreset" ]; then
  set_perm_recursive ${MODPATH}/system 0 0 0755 0644
fi