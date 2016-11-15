MODID=AppSystemizer
AUTOMOUNT=true
POSTFSDATA=true
LATESTARTSERVICE=false

print_modname() {
  ui_print "*******************************"
  ui_print "         App Systemizer        "
  ui_print "*******************************"
}

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}
