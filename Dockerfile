FROM archlinux:20200908

RUN pacman -Sy --noconfirm

ENV install "pacman -S --noconfirm --needed"

RUN $install base-devel
RUN $install git
RUN $install xorgproto
RUN $install python-gobject
RUN $install gnuradio-companion
RUN $install swig
RUN $install python-pyzmq
RUN $install intel-compute-runtime

# I don't know how to suppress the annoying xterm_executable message.
# This was my best effort:
RUN sed -i 's/xterm_executable = /xterm_executable = true/' /etc/gnuradio/conf.d/grc.conf

RUN useradd builder -m && passwd -d builder
RUN echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder
ENV HOME "/home/builder"

USER builder

WORKDIR $HOME
RUN git clone https://aur.archlinux.org/gr-fosphor.git
WORKDIR $HOME/gr-fosphor
RUN makepkg -si --noconfirm

WORKDIR $HOME
COPY --chown=builder docksphor.grc .

CMD ["/usr/bin/gnuradio-companion", "docksphor.grc"]
