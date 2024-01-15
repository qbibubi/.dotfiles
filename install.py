# TODO:
# - [ ] Disk partitioning
# - [ ] User creation
# - [ ] Set up dotfiles directory and bare repository
# - [ ] Downloading and installing packages
# - [ ] Download yay

import os
import subprocess

def partition_disks():
    """
    Function partitions disks for the fresh Arch Linux installation
    """
    return None

def create_user():
    """
    Function creates a user on Arch Linux
    """
    return None

def install_packages(packages: list[str]) -> None:
    """
    Function installs packages present in the packages list
    """
    for package in packages:
        try:
            subprocess.call(["sudo", "pacman", "-S", "-q", "--noconfirm"], package)
            # print()
        except:
            # error handling

def download_yay():
    return None

def init_dotfiles():
    repository_url = "https://github.com/qbibubi/.dotfiles.git"
    home_path = os.path.expanduser("~")

    subprocess.call(["git", "clone", "--bare"], repository_url, home_path)
    # TODO: Finish writing dotfiles
    subprocess.call(["echo", alias, ">"], shell=True)


def main():
    packages = [
        "git",
        "archlinux-keyring",
        "tmux",
        "neovim",
        "firefox-developer-edition"
    ]

    partition_disks()
    create_user()
    install_packages(packages)
    init_dotfiles()
