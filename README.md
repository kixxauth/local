Local
=====
Sys admin tools and scripts I use on my local boxes.

This project is built from the ["sub" concept](https://github.com/qrush/sub) developed at 37Signals.

## Installation
The `bin/` and `completions/` directories are internal to the sub program.

Your custom sub programs go in `libexec/` where they will be discovered automagically.

Static data like configs go in the `share/` directory.

*Tip:* You can reference the root directory for this project with the exported env var `$_KSYS_ROOT`.

After installing this repo, run `./bin/ksys init` and then add a line to invoke it from your bash profile:

```bash
# Initialize my local ksys library for autocompletions
eval "$(/Users/kris/Projects/local/bin/ksys init -)"
```

## Dotfiles
This project also contains my dot files like `.bashrc` and `.gitconfig`. Run `ksys dot-files` to deplay them. Check the .bashrc PATH export for required manual updates depending on your situation.

## Scripts
Useful scripts and tools are found in the `scripts/` folder.

## Docs
Documentation for useful tools, tricks, and tips I've picked up over the years can be found in the `docs/` directory.

Copyright and License
---------------------
Copyright (c) 2015 - 2024 Kris Walker (https://www.kriswalker.me).

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
