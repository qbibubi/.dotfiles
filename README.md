![My terminal](https://i.imgur.com/fVKBg9M.png)

<div align="center">
    <img alt="GitHub License" src="https://img.shields.io/github/license/qbibubi/.dotfiles">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/qbibubi/.dotfiles">
<!--
    <img alt="tests?" src="https://img.shields.io/github/license/qbibubi/.dotfiles">
    <img alt="version" src="https://img.shields.io/github/license/qbibubi/.dotfiles">
-->
</div>

# qbibubi's dotfiles

My minimalist i3-wm Arch Linux configuration that utilizes bare git repository to manage the dotfiles. Installation script takes care of installing and cloning config files from the git repository to `$HOME/.config` and `$HOME` accordingly.

## Installation

**WARNING:** In case you want to give these dotfiles a try you should fork the repository, review the code and tailor it to your needs. Blindly copying my settings can result in undefined behavior. Use at your own risk!

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/qbibubi/.doftiles/main/install.sh)"
```

## Features
- [x] Installation of package managers 
- [x] yay package manager
- [x] Fetching config files from github 
- [x] Zsh setup with plugins
- [ ] Unit tests
- [ ] Disk partitioning
- [ ] User creation
 
## Credits
- [Wiktor Fałek](https://github.com/wiktor-falek) for creating the yay package manager install function
