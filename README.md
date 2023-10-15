# qbibubi's .dotfiles

![My terminal image](https://i.imgur.com/lnIUIQv.png)

## Installation

**WARNING:** This repository is in unfinished state and scripts might not work properly. In case you want to give these dotfiles a try you should fork the repository, review the code and tailor it to your needs. Blindly copying my settings can result in undefined behavior. Use at your own risk!

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/qbibubi/.doftiles/main/install.sh)"
```

To enable OhMyZsh installation add `--ohmyzsh` flag at the end of the command
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/qbibubi/.doftiles/main/install.sh)" --ohmyzsh
```

# TODO

- [x] Add and update screenshots of the dotfiles to the README
- [ ] Install script 
    - [x] i3-wm and .xinitrc
    - [x] Management of bare repository
    - [x] yay package manager
    - [x] Changing shell to zsh after install
    - [x] Rebooting to work-ready environment after running install script (No need for reebot anymore)
    - [ ] Fonts (Caskaydia Cove Nerd Font)
    - [ ] OhMyZsh optional install
- [ ] Nvim submodule
    - [ ] Add custom nvim config to repo
- [x] License
