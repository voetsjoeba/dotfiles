# .bashrc_common
# vim: ai noet sw=4 ts=4 sts=4:
#
# To test if a shell is interactive: if [[ -n "$PS1" && $- == *i* ]]
# To test if a shell is login: if shopt -q login_shell

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Work around /etc/profile setting TMOUT > 0 and making it a read-only variable (causes the shell to
# auto-close after X seconds of inactivity). Because the setting is made read-only, we have to bump
# down into a non-login subshell and override the value there, but we need to be careful not to end
# up in an infinite loop of spawning subshells if for whatever reason the TMOUT override fails.
#
# This is normally only needed for (interactive) login shells and would therefore normally go in
# ~/.bash_profile. However, remember that we have to bump down into a non-login subshell which will
# not get ~/.bash_profile executed, so we have to this bit in both kinds of shells.
if [[ -n "$PS1" && "$-" == *i* ]]
then
    # Have to make stderr go to /dev/null, because this will fail the first time we try it
    export TMOUT=0 >/dev/null 2>&1
    if [[ "$TMOUT" != "0" && "$TMOUT_WORKAROUND" != "1" ]]
    then
        export TMOUT_WORKAROUND=1
        bash
        #exit # close nested shell. This works, but I don't like be exposed to the possibility of locking myself out of a shell in case the workaround ever breaks; I'll just double-exit manually.
    fi
fi

export PATH="$HOME/local/bin:$PATH"
export PYTHONPATH="$HOME/local/lib64/python2.6/site-packages:$PYTHONPATH"
export MANPATH="$HOME/local/share/man:$MANPATH"

# User specific aliases and functions
alias ls="ls --color=auto"
alias lf="ls -lFh --time-style='+%b %e %Y %H:%M'"       # e.g. Oct  5 2012 17:57
alias ll="lf -a"
alias vi="vim"
alias tmux="tmux -2" # force TMUX to assume 256-color support
alias less="less -FRX" # R: maintain colors, X: prevent using the alternate screen (keeps output on screen after exiting), F: exit if output fits on one screen, S: no word wrap

alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

shopt -s extglob        # extended shell globbing
eval $(dircolors -b)    # fixes some missing ls output color (e.g. broken symlinks)

# Set our terminal to xterm-256color, and then edit (i.e. export, sed and recompile) its capabilities to drop 'rmcup' and 'smcup'.
# The modified terminal info gets written to the ~/.terminfo directory.
# This exorcises the Evil Alternate Screen, i.e. keeps the output of applications like vim, less, more, etc on the screen after exiting
# (rather than clearing the screen so you can no longer see what the content/output was).
export TERM="xterm-256color"
export TERMINFO="$HOME/.terminfo"
mkdir -p "$TERMINFO"

# Interactive shell options
if [[ -n "$PS1" && "$-" == *i* ]]
then
    [[ -t 0 ]] && stty -ixon -ixoff -echoctl    # ixon/ixoff: stop Ctrl+S/Ctrl+Q from stopping/resuming the display (frees Ctrl+S for backwards cycling in Ctrl+R)
fi
