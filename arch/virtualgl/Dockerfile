FROM voobscout/base-arch:latest
MAINTAINER Voobscout <voobscout@archlinux.info>

USER dev
WORKDIR /home/dev
COPY start.sh /home/dev/start.sh

RUN yaourt -Syy --noconfirm --needed \
           inetutils \
           libxv \
           virtualgl \
           mesa-demos \
           nvidia-304xx-libgl \
           xf86-input-evdev \
           mesa-vdpau \
           libva-mesa-driver \
           libxdamage \
           libxxf86vm \
           jre8-openjdk \
           libxtst \
           turbovnc \
           openssh \
           xorg-xauth \
           xorg-server \
           xfce4 \
           xfce4-goodies \
           pulseaudio \
           vlc \
           opencl-nvidia-304xx && \

    sudo bash -c "echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config" && \
    sudo chmod 0755 $HOME/start.sh && \
    sudo chown dev:users $HOME/start.sh && \

    # Fix VirtualGL for this hardcoded directory otherwise we can not connect with SSH.
    sudo mkdir /opt/VirtualGL && \
    sudo ln -s /usr/bin /opt/VirtualGL && \

    # Force VirtualGL to be preloaded into setuid/setgid executables (do not do if security is an issue)
    # chmod u+s /usr/lib/librrfaker.so && chmod u+s /usr/lib64/librrfaker.so && \

    sudo pacman --noconfirm -Scc && \
    sudo find /var/cache/pacman/pkg -mindepth 1 -delete

EXPOSE 5901 5801
# CMD ["/bin/bash", "-l"]
CMD ["/home/dev/start.sh"]


           # lib32-mesa-libgl \
           # lib32-virtualgl \
           # lib32-mesa-demos \
#           libva-vdpau-driver \

# 1) xf86-input-evdev  2) xf86-input-libinput
#

# lib32-glibc lib32-zlib lib32-gcc-libs libxdamage libxxf86vm
# xorg-server lib32-mesa-libgl
# mesa-libgl conflicts with nvidia-304xx-libgl

# docker run --rm -ti --device /dev/dri/card0 --device /dev/nvidia0 --device /dev/nvidiactl -v /home/vod/.ssh/authorized_keys:/home/dev/.ssh/authorized_keys:ro --hostname virtualgl --name virtualgl -p 5901:5901 -p 5801:5801 virtualgl

# or -P to publish all exposed ports

# voobscout/base-arch:virtualgl

# --cap-add SYS_ADMIN
# --privileged
