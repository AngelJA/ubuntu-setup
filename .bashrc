export DISPLAY=localhost:0.0

# setup fzf
source /usr/share/doc/fzf/examples/completion.bash
source /usr/share/doc/fzf/examples/key-bindings.bash
_fzf_setup_completion 'path' xclip
export FZF_DEFAULT_COMMAND='ag --hidden -l --ignore-dir .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_COMPLETION_TRIGGER="**"
export FZF_DEFAULT_OPTS='--bind=ctrl-d:half-page-down,ctrl-u:half-page-up'
source ~/.fzf_completion_commands

vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}
