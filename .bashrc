alias grep='grep -i' # ignore case
alias la='ls -la'
alias ll='ls -l'
find-grep () { 
  cmd=$"find . -type f -name \"$1\" -print0 | xargs -0 grep \"$2\""
  echo $cmd 
  eval $cmd 
 }
watch () {
  compass watch &
  coffee -o js -cw coffee &
}
# Colorize
export MANPAGER='less -R'
man() {
        env \
                LESS_TERMCAP_mb=$(printf "\e[1;31m") \
                LESS_TERMCAP_md=$(printf "\e[1;31m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                man "$@"
}

alias mount='grc mount'
alias tail='grc tail'
alias ifconfig='grc ifconfig'
alias dig='grc dig'
alias ldap='grc ldap'
alias netstat='grc netstat'
alias ping='grc ping'
alias ps='grc ps'
alias traceroute='grc traceroute'
alias gcc='grc gcc'
alias coffee='grc coffee'
# End Colorize

# load setting that depends on os type.
if [ -f "$HOME/.bashrc_ubuntu" ]; then
  . "$HOME/.bashrc_ubuntu"
fi
if [ -f "$HOME/.bashrc_osx" ]; then
  . "$HOME/.bashrc_osx"
fi
if [ -f "$HOME/.bashrc_centos" ]; then
  . "$HOME/.bashrc_centos"
fi
if [ -f "$HOME/.bashrc_fedora" ]; then
  . "$HOME/.bashrc_fedora"
fi

