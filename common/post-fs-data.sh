#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

set +f
STOREDLIST=/data/data/com.loserskater.appsystemizer/files/appslist.conf
ver="$(sed -n 's/version=//p' ${MODDIR}/module.prop)"; ver=${ver:+ $ver};

apps=(
"com.google.android.apps.nexuslauncher"
"com.google.android.apps.pixelclauncher"
"com.actionlauncher.playstore"
)

log_print() {
  local LOGFILE=/cache/magisk.log
  echo "AppSystemizer${ver}: $*" >> $LOGFILE
  log -p i -t "AppSystemizer${ver}" "$*"
}

[ -d /system/priv-app ] || log_print "No access to /system/priv-app!"
[ -d /data/app ] || log_print "No access to /data/app!"
[ -f "$MODDIR/files/aapt" ] || log_print "No access to $MODDIR/files/aapt!"
chown 0:0 "$MODDIR/files/aapt"
chmod 0755 "$MODDIR/files/aapt"

[ -s "$STOREDLIST" ] && eval apps="($(<${STOREDLIST}))" && log_print "Loaded apps list from ${STOREDLIST}."  || log_print "Failed to load apps list from ${STOREDLIST}."

for pkg_id in "${apps[@]}"; do
  [ -z "$pkg_id" ] && continue
  path="${path:=priv-app}"
  if [ "$(echo /data/app/${pkg_id}-*)" != "/data/app/${pkg_id}-*" ]; then
    for i in /data/app/${pkg_id}-*/base.apk; do
      if [ "$i" != "/data/app/${pkg_id}-*/base.apk" ]; then
        [ -z "$pkg_name" ] && { pkg_name=$($MODDIR/files/aapt dump badging "$i" | grep "application-label:"); pkg_name="${pkg_name##*:}"; pkg_name="${pkg_name//\'/}"; }
        [ -z "$pkg_name" ] && { pkg_name=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en:"); pkg_name="${pkg_name##*:}"; pkg_name="${pkg_name//\'/}"; }
        [ -z "$pkg_name" ] && { pkg_name=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en-US:"); pkg_name="${pkg_name##*:}"; pkg_name="${pkg_name//\'/}"; }
        [ -z "$pkg_name" ] && { pkg_name=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en-GB:"); pkg_name="${pkg_name##*:}"; pkg_name="${pkg_name//\'/}"; }
        [ -z "$pkg_name" ] && { log_print "Ignoring /data/app/${pkg_id}: couldn't obtain app label."; continue; }
        [ -e "${MODDIR}/system/${path}/${pkg_name}" ] && { log_print "Ignoring /data/app/${pkg_id}: already a systemized app."; continue; }
        [ -e "/system/${path}/${pkg_name}" ] && { log_print "Ignoring /data/app/${pkg_id}: already a system app."; continue; }

      	mkdir -p "${MODDIR}/system/${path}/${pkg_name}" 2>/dev/null
	      cp -f "$i" "${MODDIR}/system/${path}/${pkg_name}/${pkg_id}.apk" && log_print "Created ${path}/${pkg_name}/${pkg_id}.apk" || \
          log_print "Copy Failed: $i ${MODDIR}/system/${path}/${pkg_name}/${pkg_id}.apk"
	     	chown 0:0 "${MODDIR}/system/${path}/${pkg_name}"
	     	chmod 0755 "${MODDIR}/system/${path}/${pkg_name}"
	     	chown 0:0 "${MODDIR}/system/${path}/${pkg_name}/${pkg_id}.apk"
	     	chmod 0644 "${MODDIR}/system/${path}/${pkg_name}/${pkg_id}.apk"
	    fi
    done
  else
    log_print "Ignoring ${pkg_id}: app is not installed."
  fi
done
