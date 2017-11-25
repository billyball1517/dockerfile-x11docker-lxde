# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/lxde
#           x11docker x11docker/lxde pcmanfm

FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive
 
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y dbus-x11 procps psmisc

# OpenGL / MESA
RUN apt-get install -y mesa-utils mesa-utils-extra libxv1

# Language/locale settings
ENV LANG=en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN apt-get install -y locales

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs \
    menu menu-xdg mime-support desktop-file-utils

# LXDE
# (gnome-polkit is an unfortuante and fat replacement for lxpolkit.
# lxpolkit shows an annoying error message on startup.)
RUN apt-get install -y --no-install-recommends policykit-1-gnome
RUN apt-get install -y --no-install-recommends lxde
# additional goodies
RUN apt-get install -y --no-install-recommends lxlauncher lxtask

# GTK 2 settings for icons and style
RUN echo '\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.gtkrc-2.0

# GTK 3 settings for icons and style
RUN mkdir -p /etc/skel/.config/gtk-3.0
RUN echo '\n\
[Settings]\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.config/gtk-3.0/settings.ini

# wallpaper
RUN mkdir -p /etc/skel/.config/pcmanfm/LXDE
RUN echo '\n\
[*]\n\
wallpaper_mode=stretch\n\
wallpaper_common=1\n\
wallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg\n\
' > /etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf

# create startscript 
RUN echo '#! /bin/sh\n\
[ -e "$HOME/.config" ] || cp -R /etc/skel/. $HOME/ \n\
exec startlxde \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start


