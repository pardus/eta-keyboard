# **eta-keyboard**

![License](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)

![Issues](https://img.shields.io/github/issues/pardus/eta-keyboard)

## Qt Virtual Keyboard

`eta-keyboard` is an advanced virtual keyboard designed for UNIX-like systems, leveraging X11 keycode relations and server-client programming.

### Major Features

* Floating interface for flexible positioning
* Fast and responsive performance
* Ability to change system-wide keyboard layout
* D-Bus interface accessible in session
* A11y support with the help of simple AT-SPI client [eta-tif](https://github.com/pardus/eta-tif)
* Full and tablet keyboard layout support
* EOE (Easy on Eyes) color themes
* Easy to configure with self-contained settings
* Support for 16 additional languages

### Screenshots

- #### Keyboard Layouts
    ![full](/screenshots/vk-full.png)
    ![tablet](/screenshots/vk-tablet.png)

- #### Theme Options
    ![blue](/screenshots/vk-blue.png)
    ![brown](/screenshots/vk-brown.png)
    ![green](/screenshots/vk-green.png)
    ![white](/screenshots/vk-white.png)

- #### Accessibility & Settings
    ![a11y](/screenshots/vk-a11y-support.png)
    ![settings](/screenshots/vk-settings.png)

### Build

1. Clone the project
```bash
git clone https://github.com/pardus/eta-keyboard
```

2. Install build dependencies
```bash
sudo apt install build-essential libc6 libgcc1 libgl1-mesa-glx libgl1 \
    libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5qml5 \
    libqt5quick5 libqt5svg5-dev libqt5widgets5 libqt5x11extras5-dev \
    libstdc++6 libx11-6 libx11-xcb-dev libxcb-xkb-dev libxcb1-dev \
    libxkbcommon-x11-0 libxkbcommon-x11-dev libxkbcommon0 libxkbcommon-dev \
    libxkbfile-dev libxtst-dev qtdeclarative5-dev
```

3. Build
```bash
cd eta-keyboard
mkdir build
cd build
qmake ../
make
```

4. Install Runtime dependencies
```bash
sudo apt install libqt5svg5 qml-module-qtquick-controls \
    qml-module-qtquick-window2 qml-module-qtquick2
```

### Usage

Run the keyboard:
```bash
./eta-keyboard show
```

Test remote calling:
```bash
sudo apt install qdbus-qt5
qdbus org.eta.virtualkeyboard /VirtualKeyboard org.eta.virtualkeyboard.toggle
```

### 📦 Debian Packaging

```bash
cd eta-keyboard
sudo apt install build-essential debmake debhelper git-buildpackage
sudo mk-build-deps -ir
gbp buildpackage --git-export-dir=/tmp/build-area -b -us -uc
cd /tmp/build-area
```