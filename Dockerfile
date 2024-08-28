FROM ubuntu:latest
WORKDIR /usr/src/phantomsdr

RUN apt update && apt install -y build-essential git cmake pkg-config meson libfftw3-dev libwebsocketpp-dev libflac++-dev zlib1g-dev libzstd-dev libboost-all-dev libopus-dev libliquid-dev
RUN mkdir -p /etc/udev/rules.d
RUN echo SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE="0666", GROUP="plugdev", SYMLINK+="rtl_sdr" > /etc/udev/rules.d/99-rtl_sdr.rules
COPY . .
RUN meson build --prefer-static
RUN meson compile -C build
EXPOSE 9002

CMD [ "rtl_sdr -f 145000000 -s 3200000 - | ./build/spectrumserver --config config.toml" ]