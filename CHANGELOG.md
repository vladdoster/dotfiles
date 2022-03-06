## [1.11.2](https://github.com/vladdoster/dotfiles/compare/v1.11.1...v1.11.2) (2022-03-06)


### docs

* README.md reflects current feature set ([7b38045](https://github.com/vladdoster/dotfiles/commit/7b380452e3e6bb33808e1a7f8b39ffa49a8710cf))

## [1.11.1](https://github.com/vladdoster/dotfiles/compare/v1.11.0...v1.11.1) (2022-03-06)


### build

* update release user details ([5a04988](https://github.com/vladdoster/dotfiles/commit/5a04988860e1acace493df02ce6adfaefbabfb06))

### chore

* remove unused rust-annex configurations ([7785e16](https://github.com/vladdoster/dotfiles/commit/7785e169570306d5a16bcf16c4dace6c59378bb6))

### refactor

* re-work of hs modules ([4d3ca6e](https://github.com/vladdoster/dotfiles/commit/4d3ca6e778a4df0e80639118087c32aafc01b0aa))

# [1.11.0](https://github.com/vladdoster/dotfiles/compare/v1.10.0...v1.11.0) (2022-03-03)


### chore

* add zsh alias for python3 pip ([841152d](https://github.com/vladdoster/dotfiles/commit/841152db6b8959d8c7bc117f31c6e2a9c19235e4))

### new

* git alias for restoring and amending a commit ([721fa97](https://github.com/vladdoster/dotfiles/commit/721fa9762a844e6ac5ab5ebe10a0b84618fe700b))

### refactor

* integrating hhtwm and custom wm-related module ([016e568](https://github.com/vladdoster/dotfiles/commit/016e568bd650d6e39da4ce47fefba80ba291d78f))

# [1.10.0](https://github.com/vladdoster/dotfiles/compare/v1.9.3...v1.10.0) (2022-03-01)


### chore

* remove releaserc cruft ([307eaa9](https://github.com/vladdoster/dotfiles/commit/307eaa95b0558c3c51cfe738ca23c916b8e53430))
* use zi gh-r to fetch program binaries ([15282dc](https://github.com/vladdoster/dotfiles/commit/15282dcfd4b267a2e30607aad27a03439d536873))

### fix

* update nvcln alias to delete packer_compiled.lua ([70d1556](https://github.com/vladdoster/dotfiles/commit/70d1556460332dd763b905703813d6b70cddfeee))

### new

* re-do hammerspoonconfig ([a6889ca](https://github.com/vladdoster/dotfiles/commit/a6889caf4689d4db45cb19d3c1f9a666cbfdcc16))

## [1.9.3](https://github.com/vladdoster/dotfiles/compare/v1.9.2...v1.9.3) (2022-02-28)


### chore

* set release-notes preset to eslint ([c950cc6](https://github.com/vladdoster/dotfiles/commit/c950cc6ceba7aa776e44c7d04f9a6b9efe2d8f38))

## [1.9.2](https://github.com/vladdoster/dotfiles/compare/v1.9.1...v1.9.2) (2022-02-28)


### Bug Fixes

* lowercase release tags in releaserc ([34ba7ae](https://github.com/vladdoster/dotfiles/commit/34ba7ae546590d13c94a8ae350dba104c6d1301e))
* lowercase release type in releaserc ([6e76b2e](https://github.com/vladdoster/dotfiles/commit/6e76b2e51073d63ae861a7d737293430b0646076))
* remove conflicting commit parser dependency ([ac14bba](https://github.com/vladdoster/dotfiles/commit/ac14bba5bf1fb9bba808716cad2aea0878a7e2e7))

## [1.9.1](https://github.com/vladdoster/dotfiles/compare/v1.9.0...v1.9.1) (2022-02-28)


### Bug Fixes

* remove extra backslash breaking npm installs ([a1411b3](https://github.com/vladdoster/dotfiles/commit/a1411b31874448267ca5afa592b99af8807cb4d0))

# [1.9.0](https://github.com/vladdoster/dotfiles/compare/v1.8.0...v1.9.0) (2022-02-28)


### Features

* remove trunk and associated formatter config files ([acc3e96](https://github.com/vladdoster/dotfiles/commit/acc3e96de94d3cd32bb60452ddfbe73755e9a41a))

# [1.8.0](https://github.com/vladdoster/dotfiles/compare/v1.7.1...v1.8.0) (2022-02-28)


### Bug Fixes

* add zcompcache dir ([6d9f28b](https://github.com/vladdoster/dotfiles/commit/6d9f28b90aa97ab20e8577c7810740758bf82fd5))
* zsh aliases, env, and zinit configs ([7984b68](https://github.com/vladdoster/dotfiles/commit/7984b68cb675c0bb5ac126ea56fc2d92b6634212))


### Features

* bump num of concurrent workers to update git repositories ([2dc8f76](https://github.com/vladdoster/dotfiles/commit/2dc8f766955b7d28fc7af1e1d04be4dfa58547c1))
* update Brewfile with misc. programs ([de04d7f](https://github.com/vladdoster/dotfiles/commit/de04d7fbb45bacf7f9e6b6138fc03acb04767ac0))
* update trunk version v0.7.0 -> v0.8.0 ([6160535](https://github.com/vladdoster/dotfiles/commit/6160535ae6866670f6b4655052bc1b84e9154e78))

## [1.7.1](https://github.com/vladdoster/dotfiles/compare/v1.7.0...v1.7.1) (2022-02-21)

# [1.7.0](https://github.com/vladdoster/dotfiles/compare/v1.6.0...v1.7.0) (2022-02-21)


### Features

* add script to display 255 color codes ([4a98b80](https://github.com/vladdoster/dotfiles/commit/4a98b8053b3d1adc91c5b71171c67ee65fe069ad))
* compile zsh configs for faster load times (~100%) ([a0242c8](https://github.com/vladdoster/dotfiles/commit/a0242c8197e5246090d8228783e4b330928467b4))
* ignore compiled zsh files (e.g., *.zwc*) ([48dfef7](https://github.com/vladdoster/dotfiles/commit/48dfef7e91612e1f8b75a53bc8d043617bec850b))
* new aliases to easily access zsh related configs ([4395050](https://github.com/vladdoster/dotfiles/commit/43950506b958d36909e612bcfa765f494aa6bfd0))
* testing rustup plugin for certain binaries (e.g., exa, delta) ([f442e85](https://github.com/vladdoster/dotfiles/commit/f442e85077d83a57e4790e225e37d340f0be062a))

# [1.6.0](https://github.com/vladdoster/dotfiles/compare/v1.5.0...v1.6.0) (2022-02-21)

### Features

- use trunk mega {formatt,lint}er ([c9f45dd](https://github.com/vladdoster/dotfiles/commit/c9f45dd8cdd52dbd00f7663400561fcd3f4f8491))

# [1.5.0](https://github.com/vladdoster/dotfiles/compare/v1.4.2...v1.5.0) (2022-02-15)

### Bug Fixes

- clean up history env vars & try pip completion ([03fc305](https://github.com/vladdoster/dotfiles/commit/03fc3051bdd463660b3193004aea6b021501ebf9))
- clean up tmux config annoyances and visuals ([024b246](https://github.com/vladdoster/dotfiles/commit/024b24659530803e62aebbef69790f68a6268485))

### Features

- add easy way to clone github repositories ([f03980e](https://github.com/vladdoster/dotfiles/commit/f03980ed4a3effe531902c1f4fc0bd4171d3c903))
- add graphviz and yasm ([c7b0644](https://github.com/vladdoster/dotfiles/commit/c7b0644f914228012ff0f1a07921ce983d0575fd))

## [1.4.2](https://github.com/vladdoster/dotfiles/compare/v1.4.1...v1.4.2) (2022-02-12)

### Bug Fixes

- hammerspoon tiling & docker completions ([570b274](https://github.com/vladdoster/dotfiles/commit/570b274cc82795e71d56656e9b1a6bf2967868f7))

## [1.4.1](https://github.com/vladdoster/dotfiles/compare/v1.4.0...v1.4.1) (2022-02-12)

# [1.4.0](https://github.com/vladdoster/dotfiles/compare/v1.3.5...v1.4.0) (2022-02-12)

### Features

- add get-gh-release.sh to download and install programs hosted on GitHub ([30576b2](https://github.com/vladdoster/dotfiles/commit/30576b277bddb6ef8350622046221b34b460fb74))

## [1.3.5](https://github.com/vladdoster/dotfiles/compare/v1.3.4...v1.3.5) (2022-02-11)

## [1.3.4](https://github.com/vladdoster/dotfiles/compare/v1.3.3...v1.3.4) (2022-02-09)

## [1.3.3](https://github.com/vladdoster/dotfiles/compare/v1.3.2...v1.3.3) (2022-02-08)

## [1.3.2](https://github.com/vladdoster/dotfiles/compare/v1.3.1...v1.3.2) (2022-02-07)

### Bug Fixes

- nvim binary selection more precise ([4f29f6e](https://github.com/vladdoster/dotfiles/commit/4f29f6e0d18b886787e20f71f36a1974198dffff))

## [1.3.1](https://github.com/vladdoster/dotfiles/compare/v1.3.0...v1.3.1) (2022-02-06)

### Bug Fixes

- consistent order of files in replacement and change verification due to impl ([4ae6fac](https://github.com/vladdoster/dotfiles/commit/4ae6fac870255f8a0a736e42617ef131388ae296))
- update version in .cz.toml when version changes ([c4bb776](https://github.com/vladdoster/dotfiles/commit/c4bb776bbeb3025f395ca6f52bfb2d67887fd49d))

# [1.3.0](https://github.com/vladdoster/dotfiles/compare/v1.2.0...v1.3.0) (2022-02-06)

### Bug Fixes

- correct version regex in semantic-release configuration ([81f5d93](https://github.com/vladdoster/dotfiles/commit/81f5d9327a02c8d86fb86dbf199105f23f84c95b))

### Features

- add bash script to remove ALL local and remote tags from the current git dir ([ebecc00](https://github.com/vladdoster/dotfiles/commit/ebecc0067680abc58395330b235767ebb4c26b0a))

## v1.2.0 (2022-02-06)

### Fix

- remove the unnecessary npm package tag `@juliuscc`
- correct author to `juliuscc` for semantic-release slackbot plugin
- add missing `semantic-release` to npm package

### Feat

- **.release.yml**: use semantic-release for releasing future versions

## v1.1.0 (2022-02-06)

## v1.0.0 (2022-02-06)

### Refactor

- **.cz.toml**: change commitizen configuration from yaml to toml
- remove git-changelog and bumpversion configuration files

### Fix

- **.cz.yaml**: Add VERSION file which will be bumped each release
- add release-tool.phar binary recipe

### Feat

- add commitizen and pre-commit configurations
