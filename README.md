`dvorak(en_de_fr_hu_is)` keyboard layout
========================================

This is a Dvorak international keyboard layout for use with PC
keyboards.  It can be used with the xkb keyboard mapper for the X
Window System (X11, or more specifically, the X.Org Server) or with
the [xkbcommon](https://github.com/xkbcommon/libxkbcommon) keymap
handling library for Wayland.

The layout features dead keys to make accents, plus various useful
symbols, including the euro sign.  It is suitable for writing in
English, German, French, Icelandic, and Hungarian.  It also contains
most of the International Phonetic Alphabet symbols used to write
these languages.


Automatic installation on Wayland or X11
----------------------------------------

Invoke `install.sh` with the option `--system-x11` to install for X11
system-wide, `--system-wayland` to install for Wayland system-wide, or
`--user-wayland` to install for Wayland for the current user only.

The script requires the usual POSIX tools as well as the
[XMLStarlet](https://github.com/xmlstarlet/xmlstarlet) toolkit.
Running the script through `sudo` may be necessary for system-wide
installation.


Manual installation on Wayland
------------------------------

Copy the files `symbols/dvorak` and `rules/evdev.xml` to the
corresponding subdirectories of xkbcommon's system configuration
directory (typically `$XKB_CONFIG_EXTRA_PATH` or `/etc/xkb`) or of
xkbcommon's user configuration directory (typically
`$XDG_CONFIG_HOME/xkb` or `$HOME/.config/xkb`).  If the files already
exist in the destination directories, you will need to merge in the
relevant parts of the source files.


Manual installation on X11
--------------------------

To install system-wide, copy the file `symbols/dvorak` to
`/usr/share/X11/xkb/symbols/dvorak`.  If the destination file already
exists, you will need to merge in the relevant parts of the source
file.

You can alternatively install the keyboard mapping on a per-user basis
by following the instructions in Peter Hutterer's blog post on
[user-specific XKB
configuration](https://who-t.blogspot.com/2020/09/user-specific-xkb-configuration-putting.html).


Usage
-----

If you are using a desktop environment such as KDE or GNOME, you can
select the `dvorak(en_de_fr_hu_is)` layout using the keyboard settings
of the control panel.  (If you have only just installed the new
layout, you may need to restart your session first.)

Alternatively, if you are running X11, you can run the following from
a terminal emulator:

```
$ setxkbmap dvorak en_de_fr_hu_is
```


License
-------

This project is in the public domain.  Anyone may distribute and/or
modify it without restriction.  Those who improve this layout are
encouraged to send their contributions to the original author.
