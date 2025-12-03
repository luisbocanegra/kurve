<div align="center">

# Kurve

[![AUR version](https://img.shields.io/aur/version/plasma6-applets-kurve?logo=archlinux&label=AUR&color=1f425f&labelColor=2d333b)](https://aur.archlinux.org/packages/plasma6-applets-kurve)
[![Store version](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opendesktop.org%2Focs%2Fv1%2Fcontent%2Fdata%2F2299506&query=%2Focs%2Fdata%2Fcontent%2Fversion%2Ftext()&color=1f425f&labelColor=2d333b&logo=kde&label=KDE%20Store)](https://store.kde.org/p/2299506)
[![OBS Fedora 43](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opensuse.org%2Fpublic%2Fbuild%2Fhome%3Aluisbocanegra%2FFedora_43%2Fx86_64%2Fkurve%2F_buildinfo&query=%2Fbuildinfo%2Fversrel%2Ftext()&logo=fedora&label=Fedora%2043&color=1f425f&labelColor=2d333b)](https://software.opensuse.org//download.html?project=home%3Aluisbocanegra&package=kurve)
[![OBS Fedora Rawhide](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opensuse.org%2Fpublic%2Fbuild%2Fhome%3Aluisbocanegra%2FFedora_Rawhide%2Fx86_64%2Fkurve%2F_buildinfo&query=%2Fbuildinfo%2Fversrel%2Ftext()&logo=fedora&label=Fedora%20Rawhide&color=1f425f&labelColor=2d333b)](https://software.opensuse.org//download.html?project=home%3Aluisbocanegra&package=kurve)
[![OBS openSUSE Tumbleweed](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opensuse.org%2Fpublic%2Fbuild%2Fhome%3Aluisbocanegra%2FopenSUSE_Tumbleweed%2Fx86_64%2Fkurve%2F_buildinfo&query=%2Fbuildinfo%2Fversrel%2Ftext()&logo=opensuse&label=openSUSE%20Tumbleweed&color=1f425f&labelColor=2d333b)](https://software.opensuse.org//download.html?project=home%3Aluisbocanegra&package=kurve)
[![OBS openSUSE Slowroll](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opensuse.org%2Fpublic%2Fbuild%2Fhome%3Aluisbocanegra%2FopenSUSE_Slowroll%2Fx86_64%2Fkurve%2F_buildinfo&query=%2Fbuildinfo%2Fversrel%2Ftext()&logo=opensuse&label=openSUSE%20Slowroll&color=1f425f&labelColor=2d333b)](https://software.opensuse.org//download.html?project=home%3Aluisbocanegra&package=kurve)

Audio visualizer widget powered by [CAVA](https://github.com/karlstav/cava) for the KDE Plasma Desktop

![screenshot](screenshots/screenshot.png)

</div>

## Installation

## Distribution packages

### Arch Linux (AUR)

```sh
yay -S plasma6-applets-kurve
```

### openSUSE Build Service packages (Fedora, openSUSE)

Maintained with @pallaswept and me at <https://build.opensuse.org/package/show/home:luisbocanegra/kurve>

Install instructions: <https://software.opensuse.org//download.html?project=home%3Aluisbocanegra&package=kurve>

### KDE Store

1. Install the following (runtime) dependencies from your distribution packages:

    ```sh
    # Arch Linux
    sudo pacman -Syu cava qt6-websockets python-websockets
    # Fedora
    sudo dnf install cava qt6-qtwebsockets-devel python-websockets
    # Kubuntu
    sudo apt install cava qt6-websockets-dev python3-websockets
    # openSUSE
    sudo zypper install cava qt6-websockets-imports python3-websockets
   ```

   *NOTE: Qt/Python websockets are used to communicate with CAVA if the C++ plugin is not installed manually or can't be loaded*

2. Install the widget from the KDE Store

    **Method 1: Directly from Plasma**

   1. **Right click on the Panel or Desktop** > **Add or manage widgets** > **Get new** > **Download new...**
   2. **Search** for "**Kurve**", install and add it to your Panel or Desktop.

    **Method 2: From local plasmoid file**

   1. Go to the Kurve product page in the KDE Store: <https://store.kde.org/p/2299506>
   2. Download the *.plasmoid file
   3. Install with the following command:

    `kpackagetool6 -t Plasma/Applet -i package /path/to/downloaded/file.plasmoid`

    *NOTE: Replace -i with -u to update instead*

### Build from source (With C++ Plugin)

1. Install these dependencies or the equivalents for your distribution

    ```sh
    # Arch Linux
    sudo pacman -S git gcc cmake extra-cmake-modules libplasma cava qt6-websockets python-websockets
    # Fedora
    sudo dnf install git gcc-c++ cmake extra-cmake-modules libplasma-devel cava qt6-qtwebsockets python3-websockets
    # Kubuntu
    sudo apt install git build-essential cmake extra-cmake-modules libplasma-dev cava qt6-websockets-dev python3-websockets
    # openSUSE
    sudo zypper install git cmake extra-cmake-modules libplasma6-devel cava qt6-websockets-imports python3-websockets
    ```

    *NOTE: Packages `libplasma` `cava` `qt6-websockets` and `python3-websockets` are runtime dependencies*

    *NOTE: Qt/Python websockets are used to communicate with CAVA if the C++ plugin can't be loaded*

2. Clone and install

    ```sh
    git clone https://github.com/luisbocanegra/kurve.git
    cd kurve
    ./install.sh
    ```

#### Manual install for immutable distributions

1. Use the `-immutable` variants of the install script
2. Add `QML_IMPORT_PATH` environment variable for the C++ plugin to work:

    Create the file `~/.config/plasma-workspace/env/path.sh` (and folders if they don't exist) with the following:

    ```sh
    export QML_IMPORT_PATH="$HOME/.local/lib64/qml:$HOME/.local/lib/qml:$QML_IMPORT_PATH"
    ```

3. Log-out or reboot to apply the change*

## Support the development

If you like what I do consider donating/sponsoring this and [my other open source work](https://github.com/luisbocanegra?tab=repositories&q=&type=source)

[![GitHub Sponsors](https://img.shields.io/badge/GitHub_Sponsors-supporter?logo=githubsponsors&color=%2329313C)](https://github.com/sponsors/luisbocanegra) [![Ko-fi](https://img.shields.io/badge/Ko--fi-supporter?logo=ko-fi&logoColor=%23ffffff&color=%23467BEB)](https://ko-fi.com/luisbocanegra) [!["Buy Me A Coffee"](https://img.shields.io/badge/Buy%20Me%20a%20Coffe-supporter?logo=buymeacoffee&logoColor=%23282828&color=%23FF803F)](https://www.buymeacoffee.com/luisbocanegra) [![Liberapay](https://img.shields.io/badge/Liberapay-supporter?logo=liberapay&logoColor=%23282828&color=%23F6C814)](https://liberapay.com/luisbocanegra/) [![PayPal](https://img.shields.io/badge/PayPal-supporter?logo=paypal&logoColor=%23ffffff&color=%23003087)](https://www.paypal.com/donate/?hosted_button_id=Y5TMH3Z4YZRDA)
