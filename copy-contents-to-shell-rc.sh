auto-conda-activate() {
   # Automatically detect and use the right shell hook
   case "$SHELL" in
       */zsh) eval "$(conda shell.zsh hook 2> /dev/null)" ;;
       */bash) eval "$(conda shell.bash hook 2> /dev/null)" ;;
       *) echo "Unsupported shell $SHELL"; return 1 ;;
   esac
   
   if [ $# -eq 0 ]; then
       if ENV_FILE=$(ls environment.y{a,}ml 2>/dev/null | head -1); then
           if [ ! -r "$ENV_FILE" ]; then
               echo "Cannot read $ENV_FILE"
               return 1
           fi
           ENV_NAME=$(awk '/^name:/ {print $2}' "$ENV_FILE")
           if [ -z "$ENV_NAME" ]; then
               echo "No environment name found in $ENV_FILE"
               return 1
           fi
           conda activate "$ENV_NAME"
       else
           conda activate
       fi
   elif [ -f "$1" ]; then
       if [ ! -r "$1" ]; then
           echo "Cannot read $1"
           return 1
       fi
       ENV_NAME=$(awk '/^name:/ {print $2}' "$1")
       if [ -z "$ENV_NAME" ]; then
           echo "No environment name found in $1"
           return 1
       fi
       conda activate "$ENV_NAME"
   else
       conda activate "$@"
   fi
}
alias 'aca'='auto-conda-activate'
