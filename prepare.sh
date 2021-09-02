pacman -S sudo --noconfirm
mv configs/pacman.conf  /etc/pacman.conf
pacman -Syu
sed 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers > /etc/sudoers.new
export EDITOR="cp /etc/sudoers.new"
visudo
rm /etc/sudoers.new
mv dotfiles /home/xllauca/
chown -R xllauca /home/xllauca/dotfiles

