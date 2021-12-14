#!/usr/bin/env python
import os
import sys
import shutil
from pathlib import Path


def is_windows():
    return sys.platform == "win32"


def is_wsl():
    return "WSL_DISTRO_NAME" in os.environ


def is_linux():
    return "linux" in sys.platform


def install_alacritty():
    print("Installing Alacritty")
    alacritty_yml = None

    if is_linux():
        if is_wsl():
            raise Exception(
                "WSL detected, Alacritty settings should be installed on Windows"
            )
        else:
            alacritty_yml = Path.home().joinpath(".config/alacritty/alacritty.yml")

    elif is_windows():
        if os.environ.get("APPDATA"):
            alacritty_yml = Path(os.environ.get("APPDATA")).joinpath(
                "alacritty/alacritty.yml"
            )
        else:
            alacritty_yml = Path.home().joinpath(
                "AppData/Roaming/alacritty/alacritty.yml"
            )

    else:
        raise Exception("Not supported")

    print("Moving setting into '{}'".format(alacritty_yml))

    if not alacritty_yml.parent.exists():
        alacritty_yml.parent.mkdir(parents=True)

    if alacritty_yml.exists():
        print("Previous config file being removed...")
        alacritty_yml.unlink()

    shutil.copy("alacritty.yml", alacritty_yml.__str__())


if __name__ == "__main__":
    install_alacritty()
