![My (outdated) terminal image](https://i.imgur.com/lnIUIQv.png)

# qbibubi's dotfiles

My minimalist i3-wm Arch Linux configuration that utilizes bare git repository to manage the dotfiles. Installation script takes care of installing and cloning config files from the git repository to `$HOME/.config` and `$HOME` accordingly.

## Installation

**WARNING:** This repository is in unfinished state and scripts might not work properly. In case you want to give these dotfiles a try you should fork the repository, review the code and tailor it to your needs. Blindly copying my settings can result in undefined behavior. Use at your own risk!

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/qbibubi/.doftiles/main/install.sh)"
```

## Credits
- [Wiktor Fałek](https://github.com/wiktor-falek) for creation of the yay package manager install function
