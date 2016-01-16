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
apt-get install aptitude ctags htop tmux tty-clock vim

echo "[+] Downloading vimrc files"
git clone https://github.com/didjcodt/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

echo "[+] Adding custom vimrc parameters"
cp my_configs.vim ~/.vim_runtime/

echo "[+] Adding .tmux.conf"
cp .tmux.conf ~/
