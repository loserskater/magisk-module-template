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

for pkg_name in "${apps[@]}"; do
  [ -z "$pkg_name" ] && continue
  path="${path:=priv-app}"
  if [ "$(echo /data/app/${pkg_name}-*)" != "/data/app/${pkg_name}-*" ]; then
    for i in /data/app/${pkg_name}-*/base.apk; do
      if [ "$i" != "/data/app/${pkg_name}-*/base.apk" ]; then
        [ -z "$pkg_label" ] && { pkg_label=$($MODDIR/files/aapt dump badging "$i" | grep "application-label:"); pkg_label="${pkg_label##*:}"; pkg_label="${pkg_label//\'/}"; }
        [ -z "$pkg_label" ] && { pkg_label=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en:"); pkg_label="${pkg_label##*:}"; pkg_label="${pkg_label//\'/}"; }
        [ -z "$pkg_label" ] && { pkg_label=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en-US:"); pkg_label="${pkg_label##*:}"; pkg_label="${pkg_label//\'/}"; }
        [ -z "$pkg_label" ] && { pkg_label=$($MODDIR/files/aapt dump badging "$i" | grep "application-label-en-GB:"); pkg_label="${pkg_label##*:}"; pkg_label="${pkg_label//\'/}"; }
        [ -z "$pkg_label" ] && { log_print "Ignoring /data/app/${pkg_name}: couldn't obtain app label."; continue; }
        [ -e "${MODDIR}/system/${path}/${pkg_label}" ] && { log_print "Ignoring /data/app/${pkg_name}: already a systemized app."; continue; }
        [ -e "/system/${path}/${pkg_label}" ] && { log_print "Ignoring /data/app/${pkg_name}: already a system app."; continue; }

      	mkdir -p "${MODDIR}/system/${path}/${pkg_label}" 2>/dev/null
	      cp -f "$i" "${MODDIR}/system/${path}/${pkg_label}/${pkg_name}.apk" && log_print "Created ${path}/${pkg_label}/${pkg_name}.apk" || \
          log_print "Copy Failed: $i ${MODDIR}/system/${path}/${pkg_label}/${pkg_name}.apk"
	     	chown 0:0 "${MODDIR}/system/${path}/${pkg_label}"
	     	chmod 0755 "${MODDIR}/system/${path}/${pkg_label}"
	     	chown 0:0 "${MODDIR}/system/${path}/${pkg_label}/${pkg_name}.apk"
	     	chmod 0644 "${MODDIR}/system/${path}/${pkg_label}/${pkg_name}.apk"
	    fi
    done
  else
    log_print "Ignoring ${pkg_name}: app is not installed."
  fi
done
