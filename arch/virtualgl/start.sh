#!/bin/bash
sudo mknod -m 0666 /dev/tty0 c 4 0
sudo mknod -m 0666 /dev/tty1 c 4 1


# !!! XTEST must be enabled for x11vnc to work!
sudo /opt/VirtualGL/bin/vglserver_config -config +s +f +t
X -novtswitch -sharevts &

mkdir -p ~/.vnc
echo "vglrun startxfce4" > ~/.vnc/xstartup
chmod 0755 ~/.vnc/xstartup
vncserver -noauth -novncauth -fg -xstartup ~/.vnc/xstartup

# Is the host using Nvidia drivers?
if [ -f /proc/driver/nvidia/version ];
then
  # Might be cleaner to remove the mesa libraries once
  # But doing it this way allows the user to still use mesa
  # If all else fails.

  # Get the string that has the version info from the host
  NVIDIA=$(cat /proc/driver/nvidia/version | grep NVRM)

  # Is this the 304 series?
  if [[ $NVIDIA == *" 304."* ]]
  then
    cd /root/nvidia/304/
    pacman --noconfirm -Rdd mesa-libgl lib32-mesa-libgl
    pacman -U --noconfirm *.xz
  fi

  # Is this the 340 series?
  if [[ $NVIDIA == *" 340."* ]]
  then
    cd /root/nvidia/340/
    pacman --noconfirm -Rdd mesa-libgl lib32-mesa-libgl
    pacman -U --noconfirm *.xz
  fi

  # Is this the 346 series?
  if [[ $NVIDIA == *" 346."* ]]
  then
    cd /root/nvidia/346/
    pacman --noconfirm -Rdd mesa-libgl lib32-mesa-libgl
    pacman -U --noconfirm *.xz
  fi

  # Is it version 349 (BETA) ?
  if [[ $NVIDIA == *" 349."* ]]
  then
    cd /root/nvidia/349/
    pacman --noconfirm -Rdd mesa-libgl lib32-mesa-libgl
    pacman -U --noconfirm *.xz
  fi

  # Configure for headless operation for all GPUs on the system.
  nvidia-xconfig --query-gpu-info | grep BusID | cut -d ' ' -f6 | xargs -I{} sudo nvidia-xconfig --use-display-device=none --busid={}

fi
##############################


# bash -l

#

# sudo chvt 1
# sudo deallocvt

# TurboVNC
# vncviewer <host>::<port> --DesktopSize Auto --Encoding Tight --Quality 95 --CompressLevel 6


# Xvnc :1 -desktop TurboVNC: virtualgl:1 () -httpd /usr/bin//../java -auth /home/dev/.Xauthority -dontdisconnect -geometry 1240x900 -depth 24 -rfbwait 120000 -rfbport 5901 -fp /usr/share/fonts/misc,/usr/share/fonts/TTF,/usr/share/fonts/OTF -deferupdate 1


# --CompressLevel 6 (Interframe comparison maintains a copy of the remote
# framebuffer for each connected viewer and compares each framebuffer update
# with the copy to ensure that redundant updates are not sent to the viewer.)
