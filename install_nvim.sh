mkdir ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

if [[ `uname -s` == "darwin" ]]; then
    cp consolas-powerline-vim/CONSOLA-Powerline.ttf $HOME/Library/Fonts/
fi
