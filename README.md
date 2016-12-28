Dvorak international keyboard layout for xkb
============================================


Description
-----------

This is a Dvorak international keyboard layout for use with PC
keyboards and the xkb keyboard mapper for the X Window System (or more
specifically, the X.Org Server).

The layout features dead keys to make accents, plus various useful
symbols, including the euro sign.  It is suitable for writing in
English, German, French, Icelandic, Hungarian, and possibly other
languages.


Installation
------------

Append the contents of the file `dvorak_intl.txt` to your X11
installation's `us` symbol file.  This is normally located at
`/usr/share/X11/xkb/symbols/us`.  For example:

```
# sudo cat dvorak_intl.txt >>/usr/share/X11/xkb/symbols/us
```

Recent versions of the X.Org Server already provide a keyboard mapping
named `dvorak-intl` which may clash with this one.  If you have such a
server installed, make sure to first remove or rename the existing
`dvorak-intl` section from `us`.


Usage
-----

From a terminal emulator:

```
$ setxkbmap us dvorak-intl
```

Alternatively, if you are using a desktop environment such as KDE or
GNOME, you can select the `dvorak-intl` layout using the keyboard
settings of the control panel.


License
-------

This project is in the public domain.  Anyone may distribute and/or
modify it without restriction.  Those who improve this layout are
encouraged to send their contributions to the original author.
