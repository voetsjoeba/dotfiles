# .bash_profile
# Run for login shells (i.e. shells that ask for authentication), regardless of whether they are interactive or not
#
#            |    Interactive   | Non-interactive |
# -----------+------------------+-----------------+
#      Login |  ~/.bash_profile | ~/.bash_profile |
# -----------+------------------+-----------------+
#  Non-login |  ~/.bashrc       |                 |
# -----------+------------------+-----------------+

# Some shell type debugging utilities
#echo -n ".bash_profile: "
#if [[ $- == *i* ]]; then echo -n "interactive "; else echo -n "non-interactive "; fi;
#if shopt -q login_shell; then echo -n "login "; else echo -n "non-login "; fi;
#echo "shell (BASH=$BASH, BASH_EXECUTION_STRING=$BASH_EXECUTION_STRING, TMOUT=$TMOUT, \$-=$-)"

# Source ~/.bashrc
[[ -r ~/.bashrc ]] && . ~/.bashrc
