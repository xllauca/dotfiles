source "/home/xllauca/functions.sh"
RAND=$RANDOM
#PORT=$(($RAND+3000))
hide_guake
alacritty --working-directory ~/projects/ -e zsh -c 'source ~/projects/pwncat-env/bin/activate && python pwncat-env/bin/pwncat -l -p $RANDOM'
sleep 1.5
alt_tab
