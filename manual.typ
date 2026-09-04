#import "min-manual/src/lib.typ": *
#import "tuni-style.typ": *

#let (pkg-name, pkg-version) = (
  "des-swtools",
  version({
    let now = datetime.today()
    (now.year(), now.month(), now.day())
  }),
)

#show: manual.with(
  title: text(tuni-purple)[COMP.CE.340 Software Tools],
  description: [Normative instructions on _how to install the software tools required to complete the project work_.],
  authors: "Henri Lunnikivi (Heksa) <@hegza>",
  package: pkg-name + ":" + array(pkg-version).map(str).join("."),
  license: "MIT",
  logo: none,
  fonts: tuni-font,
)

// Styles
#show link: set text(blue)
#show raw: set text(font: "Fira Code")
#show raw.where(block: true): set text(size: tuni-font-size-code)
#set heading(numbering: "A)")
// Re-size headings
#show heading.where(level: 1): it => {
  show raw: it => {
    set text(tuni-font-size * 1.5)
    it
  }
  set text(size: tuni-font-size * 1.8)
  it
}
#show heading.where(level: 2): set text(size: tuni-font-size * 1.45)
#show heading.where(level: 3): set text(size: tuni-font-size * 1.25)
#show heading.where(level: 4): set text(size: tuni-font-size * 1.15)
#show heading.where(level: 5): set text(size: tuni-font-size * 1.05)
#show heading.where(level: 6): set text(size: tuni-font-size)
// Typography
#show "RISC-V": "RISC\u{2011}V"

#v(1fr)
#outline()
#v(1.2fr)
//#pagebreak()

#heading(numbering: none)[Supported platforms]<platform-support>

#include "platforms-table.typ"


#pagebreak()

/*
#heading(numbering: none)[Targeted tools]

#table( columns: 3, align: (horizon + center, horizon + center, horizon + left),
  [*Tool*], [*Version*], [*Description*], [`git`], [$>=$], [Free and open source
  distributed version control system.], [`rustup`], [$>=$], [The official
  installer and version manager for the Rust programming language.],

  [`cargo`], [$>=$], [Rust's build system and package manager.], //[... binary
  install utility, probing and debugging tool], [], [],
)
*/

= Prerequisites

1. Install required system packages...

#grid(
  columns: (1fr, 1fr),
  [
    ... using APT (Ubuntu, Debian)
    ```term
    $ sudo apt update
    $ sudo apt install libssl-dev libudev-dev pkg-config build-essential git curl
    ```
  ],
  [
    ... using Zypper (openSUSE)
    ```term
    $ sudo zypper refresh
    $ sudo zypper install libopenssl-devel libudev-devel pkg-config git curl
    ```
  ],
)

= Install _Rust_ (`rustup`)

2. Install _Rust_ via~#pkg("https://rustup.rs/")#h(-0.35em), the official installer for the Rust programming language. This will do on most platforms:
  ```term
  $ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```
  After the installation is complete, restart your terminal before proceeding with the next steps.

  #callout(title: "PW0 requirements met")[
    You now have Rust installed. This will be enough for PW0~(`rustlings`). The rest of this guide is necessary only when getting started with PW1.
  ]

= Install target programming tools
3. Install the appropriate cross-compiler for _ESP32-C3_. It supports a 32-bit RISC-V Instruction Set Architecture (ISA) with #box[the +I, +M, and +C extensions]:
  ```term
  $ rustup target add riscv32imc-unknown-none-elf
  ```
+ Install the flashing tools:
  ```term
  $ cargo install espflash espmonitor ldproxy
  ```
+ Allow `probe-rs` to program the flash memory of the device through the serial port by creating the appropriate udev rule at '/etc/udev/rules.d':
  ```term
  $ echo -e "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"303a\", ATTRS{idProduct}==\"1001\", MODE=\"0660\", GROUP=\"plugdev\"" | sudo tee /etc/udev/rules.d/99-esp-rust-board.rules > /dev/null
  (there should be no output from the above command)
  $ sudo udevadm control --reload-rules && sudo udevadm trigger
  ```
+ Follow the instructions at~#url("https://probe.rs/docs/getting-started/probe-setup/#linux%3A-udev-rules")[Linux udev rules] to set the proper permissions for the FTDI serial ports.

#callout(title: [Flashing the device])[
  You now have all the tools required to flash a runnable program on the _ESP32-C3_ microcontroller.

  Let's try it out next.
]

#heading(level: 2, numbering: none)[Testing the Espressif toolchain
]

1. Let's create a test project using~#url("https://github.com/esp-rs/esp-generate/")#h(-0.25em):
```term
$ cargo install esp-generate --locked
...
$ esp-generate -o esp32 -o embassy -o unstable-hal -o alloc -o wifi your-project --chip esp32c3

(esp-generate opens a GUI. Press 's' to save the default configuration and continue)

Do you want to run `cargo install esp-config --features=tui --locked` now? [y/N] -> y

user@host:~$ cd your-project/
```

#[
  2. Build and flash the project. Correct output looks as follows:
  ```term
  user@host:~/your-project$ cargo run
      Finished `dev` profile [optimized + debuginfo] target(s) in 0.09s
  [2026-08-22T15:50:32Z INFO ] Serial port: '/dev/ttyACM0'
  [2026-08-22T15:50:32Z INFO ] Connecting...
  [2026-08-22T15:50:32Z INFO ] Using flash stub
  Chip type:         esp32c3 (revision v0.4)
  Crystal frequency: 40 MHz
  Flash size:        4MB
  Features:          WiFi, BLE
  ...
  17      0x10000  Verifying... OK!
  [2026-08-22T15:50:37Z INFO ] Flashing has completed!
  Commands:
      CTRL+R    Reset chip
      CTRL+C    Exit

  ESP-ROM:esp32c3-api1-20210207
  Build:Feb  7 2021
  rst:0x15 (USB_UART_CHIP_RESET),boot:0xc (SPI_FAST_FLASH_BOOT)
  Saved PC:0x40380862
  SPIWP:0xee
  mode:DIO, clock div:2
  load:0x3fcd5820,len:0x15c4
  load:0x403cbf10,len:0xc84
  load:0x403ce710,len:0x2fd0
  entry 0x403cbf1a
  I (24) boot: ESP-IDF v5.5.1-838-gd66ebb86d2e 2nd stage bootloader
  I (25) boot: compile time Nov 26 2025 12:25:17
  I (25) boot: chip revision: v0.4
  I (26) boot: efuse block revision: v1.3
  I (30) boot.esp32c3: SPI Speed      : 40MHz
  I (34) boot.esp32c3: SPI Mode       : DIO
  I (37) boot.esp32c3: SPI Flash Size : 4MB
  I (41) boot: Enabling RNG early entropy source...
  I (46) boot: Partition Table:
  ...
  I (74) boot: End of partition table
  ...
  I (195) boot: Loaded app from partition at offset 0x10000
  I (195) boot: Disabling RNG early entropy source...
  ```
]

#box[
  #heading(level: 2, numbering: none)[Troubleshooting]

  Common problems are covered below.

  #callout(title: [espflash did not see the serial port])[
    ```term
    user@host:~/your-project$ cargo run
    Error: espflash::no_serial

      × No serial ports could be detected
      help: Make sure you have connected a device to the host system. If the device is connected but not listed, try using the `--list-all-ports` flag.
    ```

    `espflash` did not see the serial port exposed by the programmer. Perhaps the USB cable is disconnected or faulty?
  ]
]

#pagebreak()
#box[
  #heading(numbering: none)[Acknowledgements]

  Guide based on original by Andreas Stergiopoulos~(#gh("andstepan")#h(-0.35em)).

  This manual uses~#univ("min-manual") by Maycon~F.~Melo.

  // More icon names in https://heroicons.com/
  #callout(title: "Contributing", icon: "arrow-right-circle")[
    If you find any issue with the guide or get this working on a new platform, you're welcome to submit a pull request at~#gh("hegza/des-swtools"). Make sure to...
    + add the appropriate row on @platform-support,
    + acknowledge yourself above this notice, and
    + auto-format `manual.typ`.
  ]
]
