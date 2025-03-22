# ~/.oh-my-zsh/themes/Mf.zsh-theme

#=-=-=--=-| Colors |-=--=-=-=#
autoload -U colors && colors


#seed=$((RANDOM)) 
#echo -n "$(whoami)@$(hostname)" | cut -d "." -f 1  | lolcat  -p 0.6 -F 0.25 -S ${seed}

#=-=-=-=-=-=| OS |=-=-=-=-=-=#
function detect_os() {
  local os_prompt=""

  case "$(uname -s)" in
    Darwin)
      os_prompt="" ;;  # macOS
    Linux)
      if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
          arch) os_prompt="" ;;  # Arch Linux
          debian) os_prompt="" ;;  # Debian
          kali) os_prompt="" ;;  # Kali Linux
        esac
      fi
      ;;
    FreeBSD)
      os_prompt="" ;;  # FreeBSD
  esac

  echo "$os_prompt"
}

os_symbol=$(detect_os)


#=-=-=-=-=-| Symbols |-=-=-=-=-=-=#
 
local branch_symbol='󰘬 ' #for APPLE NF-MD


local arrow_prompt='􀄵'   #APPL
#local arrow_prompt='󱞩'  #NF-MD


#=-=-=-=-=-=-=-=-| PROMPT |-=-=-=-=-=-=-=#
# Left:
PROMPT="(${os_symbol})  %{$(echo -n "$(whoami)@$(hostname)" | cut -d "." -f 1)%} %F{cyan}「%f%F{250}%~%f%F{cyan} 」%f "

# Right:
RPROMPT='$(branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); [ -n "$branch" ] && echo "%F{69}${branch}%f %F{9}${branch_symbol}%f")'

# \new Line:
PROMPT+=$'\n\ ${arrow_prompt} %F{green}$ %f'
