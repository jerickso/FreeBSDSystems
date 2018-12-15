# $FreeBSD: stable/12/bin/csh/csh.login 337849 2018-08-15 14:41:24Z brd $
#
# System-wide .login file for csh(1).
# Uncomment this to give you the default 4.2 behavior, where disk
# information is shown in K-Blocks
# setenv BLOCKSIZE	K
#
# For the setting of languages and character sets please see
# login.conf(5) and in particular the charset and lang options.
# For full locales list check /usr/share/locale/*
#
# Check system messages
# msgs -q
# Allow terminal messages
# mesg y

set TMUX_EXEC = /usr/local/bin/tmux

# Run tmux if not on console, and tmux exists
if ( `/usr/bin/tty` =~ "/dev/pts/*" ) then
  if ( $?prompt ) then    # If interactive shell
    if ( $?loginsh ) then # If login shell
      if ( -x $TMUX_EXEC ) then   # If tmux exists
        if ( $TERM !~ "screen*") then   # If not arleady in a TMUX session
          if ( ! $?TMUX ) then
            set WHOAMI=`/usr/bin/whoami`
            if ! { $TMUX_EXEC has-session -t $WHOAMI >& /dev/null } then
              # Resize terminal window width to be 82 columns
              printf '[8;;82t'
              # In tmux, the string is 'Ptmux;[8;;82t\'
              exec $TMUX_EXEC new -s $WHOAMI
            else
              # Resize terminal window based upon existing window
              set OTHERDIM=`tmux ls | cut -f 2 -d'[' | cut -f 1 -d']'`
              set OTHERWIDTH=`echo $OTHERDIM | cut -f 2 -d'x'`
              set OTHERHEIGHT=`echo $OTHERDIM | cut -f 1 -d'x'`
              printf '[8;%s;%st' `echo $OTHERWIDTH+1 | bc` `echo $OTHERHEIGHT`
              unset OTHERDIM
              unset OTHERWIDTH
              unset OTHERHEIGHT
              exec $TMUX_EXEC attach -t $WHOAMI
            endif
          endif
        endif
      endif
    endif
  endif
endif

# vim: set ft=csh:
