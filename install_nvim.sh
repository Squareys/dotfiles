mkdir ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

echo source $HOME/dotfiles/vimrc > $HOME/.vimrc
if [[ `uname -s` == "darwin" ]]; then
    cp consolas-powerline-vim/CONSOLA-Powerline.ttf $HOME/Library/Fonts/
fi
