# $FreeBSD: stable/10/etc/csh.cshrc 50472 1999-08-27 23:37:10Z peter $
#
# System-wide .cshrc file for csh(1).
setenv CLICOLOR yes

# Some completions taken from around the web with some of the more interesting
# ones taken from:
#                   http://www.wonkity.com/~wblock/csh/completions

complete cd             'p/1/d/'
complete chown          'p/1/u/'
complete dd             'c/if=/f/' 'c/of=/f/' \
                        'c/conv=*,/(ascii block ebcdic lcase pareven noerror \
                                  notrunc osync sparse swab sync unblock)/,' \
                        'c/conv=/(ascii block ebcdic lcase pareven noerror \
                                  notrunc osync sparse swab sync unblock)/,' \
                        'p/*/(bs cbs count files fillcahr ibs if iseek obs of \
                                  oseek seek skip conv)/='
complete fg             'c/%/j/'

complete find           'n/-fstype/"(nfs 4.2)"/' 'n/-name/f/' \
                        'n/-type/(c b d f p l s)/' \
                        'n/-user/u/ n/-group/g/' \
                        'n/-exec/c/' 'n/-ok/c/' \
                        'n/-cpio/f/' \
                        'n/-ncpio/f/' \
                        'n/-newer/f/' \
                        'c/-/(fstype name perm prune type user nouser group \
                              nogroup size inum atime mtime ctime exec ok \
                              print ls cpio ncpio newer xdev depth daystart \
                              follow maxdepth mindepth noleaf version anewer \
                              cnewer amin cmin mmin true false uid gid ilname \
                              iname ipath iregex links lname empty path regex \
                              used xtype fprint fprint0 fprintf print0 printf \
                              not a and o or)/' \
                        'n/*/d/'

complete grep           'c/-*A/x:<#_lines_after>/' \
                        'c/-*B/x:<#_lines_before>/' \
                        'c/--/(extended-regexp fixed-regexp basic-regexp \
                              regexp file ignore-case word-regexp line-regexp \
                              no-messages revert-match version help \
                              byte-offset line-number with-filename \
                              no-filename quiet silent text directories \                                     recursive files-without-match files-with-matches \                              count before-context after-context context \                                    binary unix-byte-offsets)/' \
                        'c/-/(A a B b C c d E e F f G H h i L l n q r s U u V \
                              v w x)/' \
                        'p/1/x:<limited_regular_expression>/ N/-*e/f/' \
                        'n/-*e/x:<limited_regular_expression>/' \
                        'n/-*f/f/' \
                        'n/*/f/'

complete hg 'p/1/(add addremove annotate archive backout bisect bookmarks \
        branch branches bundle cat clone commit copy diff export forget graft \
        grep heads help identify import incoming init locate log manifest \
        merge outgoing parents paths phase pull push recover remove rename \
        resolve revert rollback root serve showconfig status summary tag tags \
        tip unbundle update verify version)/'

complete ifconfig       'p@1@`ifconfig -l`@' \
                        'n/*/(range phase link netmask mtu vlandev vlan \
                             metric mediaopt down delete broadcast arp debug)/'

complete kldload       'n@*@`ls -1 /boot/modules/ /boot/kernel/ | awk -F/ \$NF\ \~\ \".ko\"\ \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\}`@'
complete kldunload    'n@*@`kldstat | awk \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\} | grep -v Name`@'
complete kldreload    'n@*@`kldstat | awk \{sub\(\/\.ko\/,\"\",\$NF\)\;print\ \$NF\} | grep -v Name`@'

complete kill           'c/-/S/' \
                        'c/%/j/' \
                        'n/*/`ps -ax | awk '"'"'{print $1}'"'"'`/'
complete killall        'c/-/S/' \
                        'c/%/j/' \
                        'n/*/`ps -axc | awk '"'"'{print $5}'"'"'`/'

complete man            'C/*/c/'

#complete make 'n@*@`sh -c "make -dg1 -n 2>&1 | grep ,\ flags\ \[0-9\]\*,\ type\ \[0-9\]\* | cut -wf2 | tr -d , | sed /^\[^a-z\]/d | sort -u"`@'
complete make           'n/*/`make -V .ALLTARGETS`/'

complete netstat        'n@-I@`ifconfig -l`@'


alias __pkgs 'pkg info -q'
set pkgcmds=(help add annotate audit autoremove backup check clean convert \
             create delete fetch info install lock plugins query register \
             repo rquery search set shell shlib stats unlock update updating \
             upgrade version which)

# aliases that show lists of possible completions including both package names and options
alias __pkg-check-opts  '__pkgs | xargs echo -B -d -s -r -y -v -n -a -i g x'
alias __pkg-del-opts    '__pkgs | xargs echo -a -D -f -g -i -n -q -R -x -y'
alias __pkg-info-opts   '__pkgs | xargs echo -a -A -f -R -e -D -g -i -x -d -r -k -l -b -B -s -q -O -E -o -p -F'
alias __pkg-which-opts      '__pkgs | xargs echo -q -o -g'

complete pkg            'p/1/$pkgcmds/' \
                        'n/check/`__pkg-check-opts`/' \
                        'N/check/`__pkgs`/' \
                        'n/delete/`__pkg-del-opts`/' \
                        'N/delete/`__pkgs`/' \
                        'n/help/$pkgcmds/' \
                        'n/info/`__pkg-info-opts`/' \
                        'N/info/`__pkgs`/' \
                        'n/which/`__pkg-which-opts`/' \
                        'N/which/`__pkgs`/'

complete pkill          'c/-/S/' \
                        'n@*@`ps -axc -o command="" | sort | uniq`@'

complete popd           'p/1/d/'

complete portmaster     'c/--/(always-fetch check-depends check-port-dbdir \
                clean-distfiles clean-packages delete-build-only \
                delete-packages force-config help index index-first \
                index-only list-origins local-packagedir no-confirm \
                no-index-fetch no-term-title packages packages-build \
                packages-if-newer packages-local packages-only show-work \
                update-if-newer version)/' \
               'c/-/(a b B C d D e f F g G h H i l L m n o p r R s t u v w x)/' \
               'n/*/`__pkgs`/'

complete pushd          'p/1/d/'

complete service        'c/-/(e l r v)/' 'p/1/`service -l`/' 'n/*/(start stop \
                           reload restart status rcvar onestart onestop)/'

complete sysctl 'n/*/`sysctl -Na`/'

complete tmux   'n/*/(attach detach has kill-server kill-session lsc lscm ls \                        lockc locks new refresh rename showmsgs source start \
                      suspendc switchc)/'

complete which  'C/*/c/'

complete zfs    'p/1/(clone create destroy get inherit list mount promote \
                      receive rename rollback send set share snapshot unmount \
                      unshare)/' \
                     'n/clone/x:[-p] [-o property=value] ... snapshot \
                        filesystem|volume/' \
                     'n/create/x:[-p] [-o property=value] ... filesystem \
                        [-ps] [-b blocksize] [-o property=value] ... -V size \
                        volume/' \
                     'n/destroy/x:[-fnpRrv] filesystem|volume \
                        [-dnpRrv] snapshot[%snapname][,...]/' \
                     'n/get/x:[-r|-d depth] [-Hp] [-o all | field[,...]] \
                        [-t type[,...]] [-s source[,...]] all | property[,...] \
                        filesystem|volume|snapshot/' \
                     'n/inherit/x:[-rS] property filesystem|volume|snapshot/' \
                     'n/list/x:[-r|-d depth] [-H] [-o property[,...]] \
                        [-t type[,...]] [-s property] ... [-S property] ... \
                        filesystem|volume|snapshot/' \
                     'n/mount/x:[-vO] [-o property[,...]] -a | filesystem/' \
                     'n/promote/x:clone-filesystem/' \
                     'n/receive/x:[-vnFu] filesystem|volume|snapshot \
                        [-vnFu] [-d | -e] filesystem/' \
                     'n/rename/x:-r snapshot snapshot \
                        -u [-p] filesystem filesystem/' \
                     'n/rollback/x:[-rRf] snapshot/' \
                     'n/send/x:[-DnPpRv] [-i snapshot | -I snapshot] snapshot/' \
                     'n/set/x:property=value filesystem|volume|snapshot/' \
                     'n/share/x:-a | filesystem/' \
                     'n/snapshot/x:[-r] [-o property=value] ... \
                        filesystem@snapname|volume@snapname/' \
                     'n/unmount/x:[-f] -a | filesystem|mountpoint/' \
                     'n/unshare/x:-a | filesystem|mountpoint/'




( which vim ) > /dev/null && alias vi vim && setenv EDITOR vim


# vim: set ft=csh:
