# Powerlevel10k instant prompt preamble
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment
export PATH=$PATH:/usr/local/bin
export EDITOR=code

# Aliases
alias ll='ls -lah'

# Load Antidote and plugins from cache
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
if [[ ! -f $HOME/.zsh_plugins.zsh ]]; then
  antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
fi
source ~/.zsh_plugins.zsh

# Customize prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Audio Processor Aliases (added Wed Jul 23 10:20:24 CDT 2025)
alias audio-extract='/Users/jeffg/scripts/audio_processor.sh extract'
alias audio-combine='/Users/jeffg/scripts/audio_processor.sh combine'
alias audio-help='/Users/jeffg/scripts/audio_processor.sh help'
alias audio-install='/Users/jeffg/scripts/audio_processor.sh install'

# Workflow shortcuts
alias audio-extract-here='/Users/jeffg/scripts/audio_processor.sh extract .'
alias audio-combine-here='/Users/jeffg/scripts/audio_processor.sh combine .'
alias audio-extract-open='/Users/jeffg/scripts/audio_processor.sh extract . && open .'
alias audio-combine-open='/Users/jeffg/scripts/audio_processor.sh combine . && open .'

# Check ffmpeg
alias check-ffmpeg='if command -v ffmpeg &> /dev/null; then echo "✓ ffmpeg: $(which ffmpeg)"; ffmpeg -version | head -1; else echo "✗ ffmpeg not found"; fi'

# Get all registered apps (for debugging)
alias lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'

# Reload .zshrc
alias sourcez='exec zsh' export PATH="$HOME/.dotnet:$PATH"

cleanxx() {
  local threshold=${1:-50}
  find /Volumes/Media/XXX/whisparr/scenes -maxdepth 1 -type d ! -name 'scenes' | while read dir; do
    size=$(du -sm "$dir" | cut -f1)
    if [ "$size" -lt "$threshold" ]; then
      rm -rf "$dir"
      echo "Deleted: $dir (${size}MB)"
    fi
  done
}