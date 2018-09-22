To ensure AppArmor is enabled upon reboot, add the following to your
GRUB CMDLINE:

    apparmor=1 security=apparmor

Rebuild your GRUB config with:

    grub-mkconfig -o /boot/grub/grub.cfg

You'll also need to configure APPARMOR in /etc/default/apparmor.
