OPENHAB_CFG_PATH=`dirname ${BASH_SOURCE[0]}`
OPENHAB_CFG_PATH=`realpath $OPENHAB_CFG_PATH/..`

__openhab_items() {
    local cur=${COMP_WORDS[COMP_CWORD]};
    local tmp=$(find "$OPENHAB_CFG_PATH/src" -type f -printf "%P\n" | grep -v classic | grep -v parts)
    tmp="$tmp icons"
    COMPREPLY=( $( compgen -W "${tmp}" -- $cur ) )
}

alias build=$OPENHAB_CFG_PATH/tools/build.sh
alias blog=$OPENHAB_CFG_PATH/tools/blog.sh
alias deploy=$OPENHAB_CFG_PATH/tools/deploy.sh
alias buildview=$OPENHAB_CFG_PATH/tools/view.sh
alias deploy_all=$OPENHAB_CFG_PATH/tools/deploy_all.sh
alias dev_env="screen -c $OPENHAB_CFG_PATH/tools/screenrc"

complete -F __openhab_items build
complete -F __openhab_items blog
complete -F __openhab_items deploy 
complete -F __openhab_items buildview 
