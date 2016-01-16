#!/bin/bash

clear
cat << "EOF"

 ,>   )\ `a_                                     _a' /(
(  _  )/ /{_ ~~    Post installation script   ~~ _}\ \(  -
 `(,)_,)/                                           \(,_(,\\
  ,<_ ,<_.                                          ._>, _>,``==>

EOF

if [ "$(id -u)" != "0" ]
then
	echo "[!] Sorry, you must be root to use this post installation script"
	exit 1
fi

echo "[+] Installing default softwares"
echo "[+] Please choose in the following categories"

whiptail --nocancel --separate-output \
	--title "Post-installer" --ok-button "Install" \
	--checklist "Please pick one" \
	$(($(tput lines) * 2 / 3)) $(($(tput cols) * 2 / 3)) $(($(tput lines) / 2)) \
	aptitude "better than default apt-get" on \
	ctags "needed for custom vimrc" on \
	htop "top with graphing support" on \
	tmux "screen-like terminal multiplexer" on  \
	tty-clock "ascii clock" on\
	vim "the best text editor ever" on 2>choices 

TOINSTALL=()

while read choice
do
	TOINSTALL+=($choice)
done < choices

echo "[-] selected products: ${TOINSTALL[*]}"

apt-get install ${TOINSTALL[*]} 

echo "[+] Downloading vimrc files"
git clone https://github.com/didjcodt/vimrc.git ~/.vim_runtime
echo "[+] Installing vimrc"
sh ~/.vim_runtime/install_awesome_vimrc.sh

echo "[+] Adding custom vimrc parameters"
cp my_configs.vim ~/.vim_runtime/

echo "[+] Adding .tmux.conf"
cp .tmux.conf ~/

if [ -f id_rsa.pub ];
then
	echo "[!] id_rsa.pub detected!"
	read -p "[+] Do you want to add your public key? [Y/n] " -n 1 -r
	echo    # move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "[+] Adding id_rsa.pub in ~/.ssh/"
		cat id_rsa.pub >> ~/.ssh/authorized_keys
	fi
fi

