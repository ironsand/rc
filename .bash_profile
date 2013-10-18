echo "loading ~/.bash_profile"
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Add $PATH
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

# rbenv init
eval "$(rbenv init -)"

# Set Prompt String color
lc='\[\e[1;' # lead-in character
RED=${lc}31m;
GREEN=${lc}32m
PURPLE=${lc}35m
RC=${lc}0m # reset character

if [ "$USER" = "root" ]
then
pc=$RED
else
pc=$GREEN
fi

PS1="${pc}\]\u@\h \W\\$ ${RC}\]"

# disalbe C-s for XON to use i-search in bash
stty -ixon

# /foo/bar^w -> /foo/
stty werase undef
bind "\C-w":unix-filename-rubout

# load setting that depends on os type.
if [ -f "$HOME/.bash_profile_ubuntu" ]; then
  . "$HOME/.bash_profile_ubuntu"
fi
if [ -f "$HOME/.bash_profile_osx" ]; then
  . "$HOME/.bash_profile_osx"
fi
if [ -f "$HOME/.bash_profile_centos" ]; then
  . "$HOME/.bash_profile_centos"
fi
if [ -f "$HOME/.bash_profile_fedora" ]; then
  . "$HOME/.bash_profile_fedora"
fi

