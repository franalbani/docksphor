FROM archlinux:20191205

RUN useradd builder -m && passwd -d builder
RUN mkdir /etc/sudoers.d/
RUN echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder
ENV HOME "/home/builder"

RUN pacman -Syu --noconfirm

ENV install "pacman -S --noconfirm --needed"

RUN $install base-devel
RUN $install git
RUN $install xorgproto
RUN $install python-gobject
RUN $install gnuradio-companion
RUN $install swig
RUN $install python-pyzmq

USER builder
WORKDIR $HOME

RUN gpg --recv-key 702353E0F7E48EDB # Must be run by builder user
RUN git clone https://aur.archlinux.org/ncurses5-compat-libs.git 
WORKDIR $HOME/ncurses5-compat-libs
RUN makepkg -si --noconfirm

WORKDIR $HOME
RUN git clone https://aur.archlinux.org/intel-opencl-runtime.git
WORKDIR $HOME/intel-opencl-runtime
# RUN git checkout a7db4fe8cfa872078034f7966bb2def788bf8e5d
RUN makepkg -si --noconfirm

WORKDIR $HOME
RUN git clone https://aur.archlinux.org/gr-fosphor.git
WORKDIR $HOME/gr-fosphor
# RUN git checkout 31f421b0c726165fb6b46ccb917c654be26df3b7
RUN makepkg -si --noconfirm

WORKDIR $HOME
COPY docksphor.grc .
CMD ["/usr/bin/gnuradio-companion", "docksphor.grc"]
