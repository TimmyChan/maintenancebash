# Acer Spin SP314 Specific
# https://www.gnu.org/software/sed/manual/sed.html
# https://ubuntuforums.org/showthread.php?t=2450981
# https://sciactive.com/2020/12/04/how-to-install-ubuntu-on-acer-spin-5-sp513-54n-for-the-perfect-linux-2-in-1/
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i8042.nopnp=1 pci=nocrs"/' /etc/default/grub
update-grub