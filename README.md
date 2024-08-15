Local
=====
Sys admin tools and scripts I use on my local boxes.

This project is built from the ["sub" concept](https://github.com/qrush/sub) developed at 37Signals.

## Installation
The `bin/` and `completions/` directories are internal to the sub program.

Your custom sub programs go in `libexec/` where they will be discovered automagically.

Static data like configs go in the `share/` directory.

After installing this repo, run `./bin/ksys init` and then add a line to invoke it from your bash profile:

```bash
# Initialize my local ksys library for autocompletions
eval "$(/Users/kris/Projects/local/bin/ksys init -)"
```

## Commands
Some useful tools contained within.

### Encrypt / Decrypt Files
The `ksys genkey`, `ksys encrypt-files`, and `ksys decrypt-files` commands all worl together, allowing you to encrypt a directory of files into a zip archive, send it off somewhere, and unzip and decrypt it on the other side.

The key must be sent using a different channel of communication.

### Git Repos
Use `ksys git-repos` to recursively search a directory tree, and print out the git URL for any git repositories which are found.

### Install Dotfiles
Install the dotfiles with the command `ksys dotfiles`. See the [Dotfiles](#dotfiles) section below.

## Dotfiles
This project also contains my dot files like `.bashrc` and `.gitconfig`. Run `ksys dot-files` to deplay them. Check the .bashrc PATH export for required manual updates depending on your situation.

## Scripts
Useful scripts and tools are found in the `scripts/` folder.

## Docs
Documentation for useful tools, tricks, and tips I've picked up over the years can be found in the `docs/` directory.

## Writing New Scripts
Just create a new executable, in any language, in the `libexec/` directory and prefix the name with "ksys-".

*Tip:* You can reference the root directory for this project with the exported env var `$_KSYS_ROOT`.

Copyright and License
---------------------
Copyright (c) 2015 - 2024 Kris Walker (https://www.kriswalker.me).

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
