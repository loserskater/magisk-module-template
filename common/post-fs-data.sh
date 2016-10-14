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

travel() {
  cd $1/$2
  if [ -f ".replace" ]; then
    rm -rf $TMPDIR/$2
    mktouch $TMPDIR/$2 $1
  else
    for ITEM in * ; do
      if [ ! -e "/$2/$ITEM" ]; then
        # New item found
        if [ $2 = "system" ]; then
          # We cannot add new items to /system root, delete it
          rm -rf $ITEM
        else
          if [ -d "$TMPDIR/dummy/$2" ]; then
            # We are in a higher level, delete the lower levels
            rm -rf $TMPDIR/dummy/$2
          fi
          # Mount the dummy parent
          mktouch $TMPDIR/dummy/$2

          mkdir -p $DUMMDIR/$2 2>/dev/null
          if [ -d "$ITEM" ]; then
            # Create new dummy directory
            mkdir -p $DUMMDIR/$2/$ITEM
          elif [ -L "$ITEM" ]; then
            # Symlinks are small, copy them
            cp -afc $ITEM $DUMMDIR/$2/$ITEM
          else
            # Create new dummy file
            mktouch $DUMMDIR/$2/$ITEM
          fi

          # Clone the original /system structure (depth 1)
          if [ -e "/$2" ]; then
            for DUMMY in /$2/* ; do
              if [ -d "$DUMMY" ]; then
                # Create dummy directory
                mkdir -p $DUMMDIR$DUMMY
              elif [ -L "$DUMMY" ]; then
                # Symlinks are small, copy them
                cp -afc $DUMMY $DUMMDIR$DUMMY
              else
                # Create dummy file
                mktouch $DUMMDIR$DUMMY
              fi
            done
          fi
        fi
      fi

      if [ -d "$ITEM" ]; then
        # It's an directory, travel deeper
        (travel $1 $2/$ITEM)
      elif [ ! -L "$ITEM" ]; then
        # Mount this file
        mktouch $TMPDIR/$2/$ITEM $1
      fi
    done
  fi
}

for line in "${apps[@]}"; do 
	IFS=' ' read name canonical path <<< $line
	if [ ! -d /system/${path}/${name} -a ! -d ${MODPATH}/system/${path}/${name} -a -d /data/app/${canonical}* ]; then 
		mkdir -p ${MODPATH}/system/${path}/${name}
		for i in /data/app/${canonical}*/base.apk; do
			cp $i ${MODPATH}/system/${path}/${name}/${name}.apk
		done
		permreset=1
	fi
done

if [ ! -z "$permreset"]; then
	set_perm_recursive ${MODPATH}/system 0 0 0755 0644
	travel $MODPATH system
fi