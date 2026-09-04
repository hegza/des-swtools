# COMP.CE.340 Software Tools installation manual + container

## Getting started with the manual

```sh
# Fetch min-manual
git submodule update --init

# Ensure fonts are installed
apt install fonts-open-sans fonts-firacode

# Render the document in PDF
typst c manual.typ
```

## Autoformat using typstyle

```sh
# Install typstyle
cargo install typstyle --locked

# Format
typstyle -i manual.typ
```

## Building the container

Generate a test project locally:

```sh
esp-generate --headless --chip esp32c3 your-project
```

Build the Ubuntu 24.04 development container:

```sh
podman build -t des-swtools:ubuntu-24.04 .
```

Run it with the ESP32-C3 serial device and a project mounted:

```sh
podman run --rm -it \
	--privileged \
	--device=/dev/ttyACM0 \
	-v "$PWD/your-project:/workspace" \
	des-swtools:ubuntu-24.04
```

`--privileged` is needed with rootless Podman because it remaps the serial
device's ownership. With Docker Engine, `--device` is normally sufficient.

Use the device path reported by `ls /dev/ttyACM* /dev/ttyUSB*` on the host. The
host must have the documented udev rules installed before passing the device
into the container.

Flash from inside the container with:

```sh
cargo run
```
