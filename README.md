# (`aca`) auto-conda-activate
Because you don't have the time to be scrolling through your list of bad env names...

## Usage
```bash
aca                    # Activates env named in environment.yml of current dir
aca myenv.yml         # The above, but from the file you specify
aca myenv             # Regular conda activate behavior
```


## What?
A shell function for `bash` or `zsh` that makes conda environments activate themselves just by looking at your current folder's `environment.yml` file.

## Installation
0. If you don't have one, make `environment.yml` and include `name: <my_env_name>`
1. Copy this chunk of code:
```bash
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
```
3. Find your shell's config file (`~/.zshrc` or `~/.bashrc`)
4. Paste at bottom
5. Source your config (`source ~/.bashrc` or `source ~/.zshrc`) or start a new terminal
6. That's it.

## Features
- Auto-detects bash/zsh - no manual configuration needed
- Finds `environment.yml` or `environment.yaml` automatically
- Includes checks for file permissions and that the `.yml` file has a `name: ` entry
- Three-letter alias (`aca`) because life's too short
- Still works with regular `conda activate myenv` style commands
- Zero dependencies (except, you know, conda... and awk... and a shell...)

## Q&A
**Q: Why can't you just look in your `environment.yml` for the name and type `conda activate blahblahblah1422341bfinal`?**  
A: Nothing, if you enjoy remembering all your bad env names and typing 20+ characters instead of 3 all the time.

**Q: Why not auto-activate or deactivate when entering and leaving the directory?**  
A: Because sometimes I'm a multi-directory-single-environment agent of chaos, and also because I don't want to mess with my `cd` command.

**Q: Why not use a dedicated config file instead of defaulting to `environment.yml`?**  
A: You can absolutely maintain a dedicated config file, such as `.conda_env.yml`. Just make sure it includes a single `name: <env_name>`, then activate it with `aca .conda_env.yml`. This approach can be helpful if you have multiple environments for the project and want to comment out or switch between different environment options without cluttering your sacred `environment.yml`. For example:
```yml
# .conda_env.yml
# name: bad_name1 # Initial environment as per instructions
name: bad_name2 # Fixed a thing that the instructions didn't mention -_-
```

## Prior Art
- https://github.com/conda/conda/issues/5179
- https://github.com/vallops99/Conda-autoactivate-env
- https://github.com/hyperupcall/autoenv
- https://github.com/Tarrasch/zsh-autoenv
- https://janosh.io/blog/conda-auto-env
