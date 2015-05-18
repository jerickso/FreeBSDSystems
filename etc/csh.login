# $FreeBSD: stable/10/etc/csh.login 208116 2010-05-15 17:49:56Z jilles $
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
