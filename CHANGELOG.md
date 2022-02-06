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
