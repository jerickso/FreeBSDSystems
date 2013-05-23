# $FreeBSD: stable/9/etc/root/dot.login 242539 2012-11-04 00:30:42Z eadler $
#
# .login - csh login script, read by login shell, after `.cshrc' at login.
#
# see also csh(1), environ(7).
#

# Uncomment to display a random cookie each login:
# if ( -x /usr/games/fortune ) /usr/games/fortune -s


# Run tmux if not on console, and tmux exists
if ( `/usr/bin/tty` =~ "/dev/pts/*" ) then
  if ( -x /usr/local/bin/tmux ) /usr/local/bin/tmux
endif
