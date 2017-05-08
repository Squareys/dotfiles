# Install script for windows
# Assumes working dir is dotfiles/ and dotfiles resides in %USERPROFILE%
echo source $HOME/dotfiles/vimrc > $HOME/.vimrc
if [[ `uname -s` == "darwin" ]]; then
    cp consolas-powerline-vim/CONSOLA-Powerline.ttf $HOME/Library/Fonts/
fi
