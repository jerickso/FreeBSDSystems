# $FreeBSD: stable/10/etc/root/dot.login 243153 2012-11-16 14:25:13Z eadler $
#
# .login - csh login script, read by login shell, after `.cshrc' at login.
#
# see also csh(1), environ(7).
#

# Uncomment to display a random cookie each login:
# if ( -x /usr/games/fortune ) /usr/games/fortune -s

set TMUX_EXEC = /usr/local/bin/tmux

# Run tmux if not on console, and tmux exists
if ( `/usr/bin/tty` =~ "/dev/pts/*" ) then
  if ( $?prompt ) then    # If interactive shell
    if ( $?loginsh ) then # If login shell
      if ( -x $TMUX_EXEC ) then   # If tmux exists
        if ( $TERM !~ "screen*") then   # If not arleady in a TMUX session
          # Have exit just detach from TMUX if inside of it
          alias exit 'if ( ! $?TMUX ) ""exit; if ( $?TMUX != "" ) tmux detach'

          if ( ! $?TMUX ) then
            set WHOAMI=`/usr/bin/whoami`
            if ! { $TMUX_EXEC has-session -t $WHOAMI >& /dev/null } then
              exec $TMUX_EXEC new -s $WHOAMI
            else
              exec $TMUX_EXEC attach -t $WHOAMI
            endif
          endif
        endif
      endif
    endif
  endif
endif


# vim: set ft=csh:
