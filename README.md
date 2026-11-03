Dvorak international keyboard layout for xkb
============================================


Description
-----------

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


Installation on Wayland
-----------------------

To install the keyboard mapping system-wide, append the file `us` to
the file `symbols/us` in xkbcommon's system configuration directory:

```
# mkdir -p ${XKB_CONFIG_EXTRA_PATH:-/etc/xkb}/symbols && cat us >> ${XKB_CONFIG_EXTRA_PATH:-/etc/xkb}/symbols
```

To install the keyboard mapping on a per-user basis, append the file
`us` to the file `symbols/us` in xkbcommon's user configuration
directory:

```
$ mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/xkb/symbols && cat us >> ${XDG_CONFIG_HOME:-$HOME/.config}/xkb/symbols
```

If your Wayland server already provides a `us` keyboard mapping
variant named `dvorak-intl`, then this version will take precedence.


Installation on X11
-------------------

To install the keyboard mapping system-wide, append the contents of
the file `us` to your X11 installation's `us` symbol file.  This is
normally located at `/usr/share/X11/xkb/symbols/us`.  For example:

```
# cat us >>/usr/share/X11/xkb/symbols/us
```

Recent versions of the X.Org Server already provide a `us` keyboard
mapping variant named `dvorak-intl` that may clash with this one.  If
you have such a server installed, make sure to first rename the
variant in this repository's `us` file, or else remove or rename the
existing `dvorak-intl` variant from `/usr/share/X11/xkb/symbols/us`.
For example, using GNU sed:

```
# sed -i -e '/^\/\/ Dvorak intl\., with dead keys/,/^};/d' \
  -e '$r us' /usr/share/X11/xkb/symbols/us
```

You can alternatively install the keyboard mapping on a per-user basis
by following the instructions in Peter Hutterer's blog post on
[user-specific XKB
configuration](https://who-t.blogspot.com/2020/09/user-specific-xkb-configuration-putting.html).


Usage
-----

If you are using a desktop environment such as KDE or GNOME, you can
select the `dvorak-intl` layout using the keyboard settings of the
control panel.  (If you have only just installed the new layout, you
may need to restart your session first.)

Alternatively, if you are running X11, you can run the following from
a terminal emulator:

```
$ setxkbmap us dvorak-intl
```


License
-------

This project is in the public domain.  Anyone may distribute and/or
modify it without restriction.  Those who improve this layout are
encouraged to send their contributions to the original author.
