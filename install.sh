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
	echo "[!] Warning! Non root user cannot install softwares! "
	read -p "[!] Do you want to continue? [Y/n] " -n 1 -r
	echo    # move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "[!] Installing as non root user"
	else
		echo "[!] Installation aborted"
		exit 0
	fi
else # If it's a root user, we can apt-get
	echo "[+] Installing default softwares"
	echo "[+] Please choose in the following categories"

	whiptail --nocancel --separate-output \
		--title "Post-installer" --ok-button "Install" \
		--checklist "Please pick one" \
		$(($(tput lines) * 2 / 3)) $(($(tput cols) * 2 / 3)) \
		$(($(tput lines) * 2 / 3 - 5)) \
		aptitude "better than default apt-get" on \
		ctags "needed for custom vimrc" on \
		htop "top with graphing support" on \
		i3-wm "i3 tiling window manager" on \
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
fi

# Install the vimrc if vim is installed
if [ -f /usr/bin/vim ];
then
	echo "[+] Downloading vimrc files"
	git clone https://github.com/didjcodt/vimrc.git ~/.vim_runtime
	echo "[+] Installing vimrc"
	sh ~/.vim_runtime/install_awesome_vimrc.sh

	echo "[+] Adding custom vimrc parameters"
	cp my_configs.vim ~/.vim_runtime/
fi

# Install the tmux conf if tmux is installed
if [ -f /usr/bin/tmux ];
then
	echo "[+] Adding .tmux.conf"
	cp .tmux.conf ~/
fi

# Add public key in id_rsa.pub if file exists
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

