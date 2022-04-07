FreeBSDSystems
==============

*FreeBSDSystems* is my basic set of files I change/add when building a new FreeBSD installation.  It includes kernel configurations, system changes, shell modifications, and program defaults.

The files in this project are kept pretty close up to date with the latest stable branch (currently 13.0-stable).

The files are laid out in a filesystem layout and for the most part will be copied over as they existing in this layout.

Preconfigured Kernel Configs
----------------------------
*FreeBSDSystems* uses my predefined kernel configs from my FreeBSDKernelConfigs github repository.  These are amd64 versions that can be placed in the normal location, /usr/src/sys/amd64/conf.  The files are:

* BASE - All other configs import this.  BASE imports the GENERIC Config and removes most items/drivers that are not necessary for a BASE kernel.  By importing GENERIC, any additions to GENERIC will show up in BASE without having to modify it.
* VMWARE - For use as guests on VMWare Servers
* AZURE - For use on MS Azure (or Hyper-V)
* GOOGLE - For use on Google Cloud, not tested so may not work
* AWS - For use on Amazon's Web Services, not tested

TMUX
----
I have found [TMUX](https://tmux.github.io/) to be a useful utility with its ability to detach and attach up sessions from different terminals and span multiple shells.

Upon login to a virtual terminal, the user will attach to an existing TMUX session if it exists, otherwise a TMUX session will be created that is unique to that user.  If you usually logout via the command `exit`, the command is aliased to detach from the session instead.

I use the included csh shell in FreeBSD.  The login scripts can be adapted to work with other shells.

compare.sh
----------
Since I seem to be constantly tweaking files and configs, I needed a way to keep running systems, as well as new systems, somewhat consistent.  This script aids in coping over new files, as well as merging changes into existing files.  It borrows some functionality from mergemaster.

It runs by issuing:
`./compare.sh`

Do note, that all the files listed in the file `Merging/overwrite` will be overwritten without prompting


File Descriptions
=================
Below are most of the files and what/why changes

/etc
----
* crontab - Disable atrun from running
* csh.cshrc - Some additional aliases for csh
* csh.login - Will spawn TMUX if virtual terminal and login shell
* make.conf - Basic make.conf file with default kernel and port settings
* mergemaster.rc - Configuration for mergemaster to make upgrading easier
* profile - Add color to sh
* rc.conf - Default rc.conf which is to start SSHD
* src.conf - List of all options when building the world, with unneeded functionality disabled.
* sysctl.conf - Some simple tuning of system settings
* ttys - Disable all virtual terminals since not needed on virtual machines

/usr/local/etc
--------------
* portmaster.rc - Default configuration for portmaster to ease port upgrades
* tmux.conf - Default tmux configuration.  Changes prefix to Ctrl-a plus many other changes

/usr/local/share/vim
--------------------
* vimrc - Default vimrc configuration

/usr/local/share/etc
--------------------
* tmux.conf - TMUX configuration

/boot
-----
* loader.conf - Default boot loader config for VMs, minimal boot delay, redirect output to comm port, and some kernel tuning for PostgreSQL

/Merging
--------
This directory is only used for the compare script.
* functions.sh - Helper functions for the merge script
* overwrite - A List of file to ALWAYS overwrite 


License
=======
All files are in the public domain within the United States, with copyright and related rights in the work worldwide waived through the [Creative Commons CC0 1.0 Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0 dedication.  By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

