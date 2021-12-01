#!/usr/bin/env python
import os
import sys
import shutil
from pathlib import Path


def install_alacritty():
    print("Installing Alacritty")
    alacritty_yml = None

    if "linux" in sys.platform:
        alacritty_yml = Path.home().joinpath(".config/alacritty/alacritty.yml")

    elif sys.platform == "win32":
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
