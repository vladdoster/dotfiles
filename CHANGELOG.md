## [1.4.1](https://github.com/vladdoster/dotfiles/compare/v1.4.0...v1.4.1) (2022-02-12)

# [1.4.0](https://github.com/vladdoster/dotfiles/compare/v1.3.5...v1.4.0) (2022-02-12)


### Features

* add get-gh-release.sh to download and install programs hosted on GitHub ([30576b2](https://github.com/vladdoster/dotfiles/commit/30576b277bddb6ef8350622046221b34b460fb74))

## [1.3.5](https://github.com/vladdoster/dotfiles/compare/v1.3.4...v1.3.5) (2022-02-11)

## [1.3.4](https://github.com/vladdoster/dotfiles/compare/v1.3.3...v1.3.4) (2022-02-09)

## [1.3.3](https://github.com/vladdoster/dotfiles/compare/v1.3.2...v1.3.3) (2022-02-08)

## [1.3.2](https://github.com/vladdoster/dotfiles/compare/v1.3.1...v1.3.2) (2022-02-07)


### Bug Fixes

* nvim binary selection more precise ([4f29f6e](https://github.com/vladdoster/dotfiles/commit/4f29f6e0d18b886787e20f71f36a1974198dffff))

## [1.3.1](https://github.com/vladdoster/dotfiles/compare/v1.3.0...v1.3.1) (2022-02-06)


### Bug Fixes

* consistent order of files in replacement and change verification due to impl ([4ae6fac](https://github.com/vladdoster/dotfiles/commit/4ae6fac870255f8a0a736e42617ef131388ae296))
* update version in .cz.toml when version changes ([c4bb776](https://github.com/vladdoster/dotfiles/commit/c4bb776bbeb3025f395ca6f52bfb2d67887fd49d))

# [1.3.0](https://github.com/vladdoster/dotfiles/compare/v1.2.0...v1.3.0) (2022-02-06)


### Bug Fixes

* correct version regex in semantic-release configuration ([81f5d93](https://github.com/vladdoster/dotfiles/commit/81f5d9327a02c8d86fb86dbf199105f23f84c95b))


### Features

* add bash script to remove ALL local and remote tags from the current git dir ([ebecc00](https://github.com/vladdoster/dotfiles/commit/ebecc0067680abc58395330b235767ebb4c26b0a))

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
