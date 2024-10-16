# [4.50.0](https://github.com/vladdoster/dotfiles/compare/v4.49.0...v4.50.0) (2024-10-13)


### Features

* **zsh:** save zsh xtrace output to file ([9c98570](https://github.com/vladdoster/dotfiles/commit/9c98570d87d7d32273e42d55eb448d10b0a76578))

# [4.49.0](https://github.com/vladdoster/dotfiles/compare/v4.48.0...v4.49.0) (2024-09-14)


### Bug Fixes

* **zsh:** remove {n,}vim aliases ([a6558e2](https://github.com/vladdoster/dotfiles/commit/a6558e28c076cb434768fb7d18d48fe2f2bbed51))


### Features

* **zsh:** `v` func redirects to available editor ([a493781](https://github.com/vladdoster/dotfiles/commit/a4937816c2bb7b1ff77eca011ba92112a0818f1a))

# [4.48.0](https://github.com/vladdoster/dotfiles/compare/v4.47.1...v4.48.0) (2024-08-01)


### Features

* pass keg to +brew-link-keg ([#47](https://github.com/vladdoster/dotfiles/issues/47)) ([19c73ac](https://github.com/vladdoster/dotfiles/commit/19c73ace367e1c7b06f75246aa04388b9a6ef7b2))

## [4.47.1](https://github.com/vladdoster/dotfiles/compare/v4.47.0...v4.47.1) (2024-07-15)


### Bug Fixes

* c function logic improved ([6335111](https://github.com/vladdoster/dotfiles/commit/633511186724cf8d1b420a0aae29613a6416d7ff))

# [4.47.0](https://github.com/vladdoster/dotfiles/compare/v4.46.0...v4.47.0) (2024-04-22)


### Bug Fixes

* **zsh:** delete .zlogin ([62a5c4d](https://github.com/vladdoster/dotfiles/commit/62a5c4ddb083c9c04592edd609ee9f092314394c))
* **zsh:** functions vim modeline ([bc069fc](https://github.com/vladdoster/dotfiles/commit/bc069fc213514d67376c3f30a48ccb60227f5039))
* **zsh:** rename .zshenv to .zprofile ([0e1317d](https://github.com/vladdoster/dotfiles/commit/0e1317d013e4878c37c511433230ad23d305f8c4))
* **zsh:** zsh{env,rc} vim modelines ([778733a](https://github.com/vladdoster/dotfiles/commit/778733ad773f08b8972c2deda0238a64ad596b79))


### Features

* remove pure in favor of rc/07-prompt.zsh ([8486ff0](https://github.com/vladdoster/dotfiles/commit/8486ff0d99247f94e97e9dc2c355a4b5a344fd11))
* **wezterm:** mouse/link cfg + format via stylua ([762c302](https://github.com/vladdoster/dotfiles/commit/762c30218f6619c814fa96e761f7777515ddc6d3))
* **zsh:** print alias when ran via widget ([3f7f058](https://github.com/vladdoster/dotfiles/commit/3f7f058413996f2e88922a8f00c6d7afed572550))

# [4.46.0](https://github.com/vladdoster/dotfiles/compare/v4.45.0...v4.46.0) (2024-03-20)


### Bug Fixes

* **completions:** remove _op & _e:func ([376d450](https://github.com/vladdoster/dotfiles/commit/376d450de1397544e45cb5b012bd521e91b90853))


### Features

* **brewfile:** bump node version & add python3 ([f8284ab](https://github.com/vladdoster/dotfiles/commit/f8284aba47997fb57360b099075e1b0c86707ece))
* **F:** improved functions function & completion ([4d5e3bc](https://github.com/vladdoster/dotfiles/commit/4d5e3bcbb0100ad209dc46cc987561b55a0ca744))


### Performance Improvements

* **zsh:** remove airflow completion ([6833483](https://github.com/vladdoster/dotfiles/commit/68334834e171d3dd48f83c400826cdfbf4dd1500))

# [4.45.0](https://github.com/vladdoster/dotfiles/compare/v4.44.2...v4.45.0) (2024-03-15)


### Bug Fixes

* **zfd:** multiple arguments & flag to edit completion ([#45](https://github.com/vladdoster/dotfiles/issues/45)) ([947e9d0](https://github.com/vladdoster/dotfiles/commit/947e9d0f07ddeba33a12445864edb8ca27759059))
* **zfd:** option state leak & pushd options ([397042e](https://github.com/vladdoster/dotfiles/commit/397042e8b4c308cb792117dd9f5e19d8ec2c5d6d))


### Features

* **F:** improved functions function & completion ([f3c414e](https://github.com/vladdoster/dotfiles/commit/f3c414e9af45302babe39a30f577240f94c67916))

## [4.44.2](https://github.com/vladdoster/dotfiles/compare/v4.44.1...v4.44.2) (2024-03-03)


### Bug Fixes

* **zinit:** misc. ices and neovim ([35d0cfa](https://github.com/vladdoster/dotfiles/commit/35d0cfad84f96843b5da38ec515e45f54486a2a4))
* **zinit:** use custom built eza ([f8e6334](https://github.com/vladdoster/dotfiles/commit/f8e633458e4e7ebc815cc53018bf6b3d77aba7e1))
* **zinit:** zinit xtrace prompt ([fcc4965](https://github.com/vladdoster/dotfiles/commit/fcc496559d27d49108b344830f6cb7a265875e89))
* **zshenv:** do not sutoload *.zwc && cruft cleanup ([56e25ca](https://github.com/vladdoster/dotfiles/commit/56e25ca86b921cf65aa13644120b909e4821d25e))
* **zshenv:** homebrew init for x86_64 macOS and Linuxbrew ([48b8cbf](https://github.com/vladdoster/dotfiles/commit/48b8cbff6620b3c0f5f98f2541cecae47754a860))
* **zshenv:** remove explicit sourcing of ~ZDOTDIR/.zshenv ([b45b98d](https://github.com/vladdoster/dotfiles/commit/b45b98dd1a2ca84772d66a5a57f481c5170c90ec))
* **zshrc:** history options ([18a0055](https://github.com/vladdoster/dotfiles/commit/18a005527162e53a02e35a8cc5396eb4f92e5077))

## [4.44.1](https://github.com/vladdoster/dotfiles/compare/v4.44.0...v4.44.1) (2024-02-11)


### Bug Fixes

* **zinit:** use upstream and plugin ices ([12e7ef9](https://github.com/vladdoster/dotfiles/commit/12e7ef92a481f94d084903cec24b20d4cc1e481f))

# [4.44.0](https://github.com/vladdoster/dotfiles/compare/v4.43.3...v4.44.0) (2024-02-05)


### Bug Fixes

* git, pip, zinit, zsh, and tmux configs ([6c88b81](https://github.com/vladdoster/dotfiles/commit/6c88b81c9afeb0883dd13cdeddbeecbc020b2ed5))


### Features

* **makefile:** clean targets for python, docker, brew ([c8142f2](https://github.com/vladdoster/dotfiles/commit/c8142f23d2671832de702b90c67a2561e2887131))

## [4.43.3](https://github.com/vladdoster/dotfiles/compare/v4.43.2...v4.43.3) (2024-01-20)


### Bug Fixes

* **git-config:** set vim modeline filetype to `gitconfig` ([#43](https://github.com/vladdoster/dotfiles/issues/43)) ([54a1732](https://github.com/vladdoster/dotfiles/commit/54a1732fc5306e89a310a53723a75953212f2248))
* **stow:** ignore `.local/` dirs other than `bin/` ([c3c23c3](https://github.com/vladdoster/dotfiles/commit/c3c23c3b841dce92616a5698e8c2668ad057ef24))

## [4.43.2](https://github.com/vladdoster/dotfiles/compare/v4.43.1...v4.43.2) (2024-01-14)


### Bug Fixes

* **stow:** correct stow ignore lists & files ([1f5cac9](https://github.com/vladdoster/dotfiles/commit/1f5cac90e3c35be0b611b6a3c846fbef531475e6))

## [4.43.1](https://github.com/vladdoster/dotfiles/compare/v4.43.0...v4.43.1) (2024-01-13)


### Bug Fixes

* **dkr:** rm invalid alpine pkgs & format file ([#41](https://github.com/vladdoster/dotfiles/issues/41)) ([7ae2eba](https://github.com/vladdoster/dotfiles/commit/7ae2eba23a6c773b6e5161bd0fcb6a497e3a5e67))
* **mkfn:** improve func boilerplate & format file ([#42](https://github.com/vladdoster/dotfiles/issues/42)) ([cd6ecf8](https://github.com/vladdoster/dotfiles/commit/cd6ecf8ba11ab6ad4247cf4245862931393e74ba))

# [4.43.0](https://github.com/vladdoster/dotfiles/compare/v4.42.0...v4.43.0) (2024-01-13)


### Bug Fixes

* **gli:** silence git output ([6f51ee0](https://github.com/vladdoster/dotfiles/commit/6f51ee0588b766301dab9e3e1248bf8a2535cf8e))
* options & hash dirs in .zshrc ([7ed82de](https://github.com/vladdoster/dotfiles/commit/7ed82def8d1f1c628823ded52328d33faded2fad))


### Features

* **mkfn:** add debug flag & print args ([d4886a1](https://github.com/vladdoster/dotfiles/commit/d4886a1b1d61408a92f5bb5d68f2558aaf7b068b))

# [4.42.0](https://github.com/vladdoster/dotfiles/compare/v4.41.0...v4.42.0) (2024-01-02)


### Bug Fixes

* bashrc rm cargo init & editorconfig config ([83800ce](https://github.com/vladdoster/dotfiles/commit/83800ced0ea0d2f1a4f17f7ca430b2e0e360c9a9))
* increase wezterm fps to macbook promotion limit ([5998db2](https://github.com/vladdoster/dotfiles/commit/5998db223b3131db78d3dd0a2fbde0135e15b9f5))
* make py pkgs & py-pip-install target ([21696d1](https://github.com/vladdoster/dotfiles/commit/21696d1bedf3ce3cc8333cb89abfc61f86f327ba))
* remove aliases ([2ddbef4](https://github.com/vladdoster/dotfiles/commit/2ddbef4e59ca5d12e3db9e861eb24fe9b9bcaf8d))
* remove branch in git clone zsh widget ([3932c48](https://github.com/vladdoster/dotfiles/commit/3932c48a9d7efb787f9e5c543deea1061dc4ae0f))
* rm duplicate aliases & zinit config ([9d2ff27](https://github.com/vladdoster/dotfiles/commit/9d2ff276bf3c5873d784b8ac10533982fc97f2a0))
* rm duplicate zdotdir vars & cleanup zsh files ([fb5d42f](https://github.com/vladdoster/dotfiles/commit/fb5d42fabe8b90806651d9adf3242543af0693ef))
* setopts interactive_comments & auto_cd ([5c447c8](https://github.com/vladdoster/dotfiles/commit/5c447c8f8ac213ce0fc348e91a219b4c4747ad06))
* stow ignores ~/.local/{share,state}/* ([27ef884](https://github.com/vladdoster/dotfiles/commit/27ef88473535d1d8694a8cb8e4a32346b1b425b6))
* used hashed dir in zinit cfg ([2385231](https://github.com/vladdoster/dotfiles/commit/23852314cf226e34b158d7769ee0bdf2e64d0720))
* zfd function login and completion options ([77a9758](https://github.com/vladdoster/dotfiles/commit/77a97580b4bab9c561a4edc6590551178b896fe2))
* zinit & zsh alias plugins ([e93459d](https://github.com/vladdoster/dotfiles/commit/e93459de820cf75796ef1ce09ecc9a6c342b4f61))
* zsh history ignore dupes ([cc246b4](https://github.com/vladdoster/dotfiles/commit/cc246b44cde729af3cf34b0bfea4ef4ee0d9a521))
* zshenv fpath paths and opt cleanup ([8a88ffb](https://github.com/vladdoster/dotfiles/commit/8a88ffb83c2a0c27e2be4f9d28e15d00ea19bb0c))


### Features

* add minimal zinit env to dkr sandbox function ([c8a6956](https://github.com/vladdoster/dotfiles/commit/c8a6956f2363e5370e6b7735880a17e1e4176067))
* extract function ([7d857a2](https://github.com/vladdoster/dotfiles/commit/7d857a29fc1ae0ab2b529abcd140deceb6ee719d))
* git alias nuke to clean -fxd & reset --hard ([a3a055b](https://github.com/vladdoster/dotfiles/commit/a3a055b48431f090a1ce618b6d8727b8b9c83e17))
* wezterm theme & keybind for launcher ([bc8dcd0](https://github.com/vladdoster/dotfiles/commit/bc8dcd08fc335404db20c285909721640b7d5a4c))


### Performance Improvements

* zinit configuration ([0b436c6](https://github.com/vladdoster/dotfiles/commit/0b436c64439284fd05067153d1f1ee5c54ea1bee))

# [4.41.0](https://github.com/vladdoster/dotfiles/compare/v4.40.1...v4.41.0) (2023-11-16)


### Bug Fixes

* add-to-path option parsing & logging ([d6b904e](https://github.com/vladdoster/dotfiles/commit/d6b904ee0baec681654d8c07f11f5d8566edf3c6))
* expression check for NO_RC in zshrc ([dcb44d5](https://github.com/vladdoster/dotfiles/commit/dcb44d55a6877a857f0d581d482a79c4ed211a7d))
* rename zsh::clean to zsh-clean ([2c87112](https://github.com/vladdoster/dotfiles/commit/2c87112cb01f831c10f78f44ec74115919d018fd))
* set function permissions to 644 ([a214716](https://github.com/vladdoster/dotfiles/commit/a214716909fca06c371248395735e02269c9626c))
* zdd completion descriptions ([c35bed8](https://github.com/vladdoster/dotfiles/commit/c35bed88e3af3eaf68777318705daf63a8614a7e))


### Features

* git-repo-website opens git repository URL in browser ([1527943](https://github.com/vladdoster/dotfiles/commit/1527943b377e35dc870a654f7c36cae13c63187d))
* set NO_RC to skip loading zsh files in rc.d ([4478f57](https://github.com/vladdoster/dotfiles/commit/4478f575ebe0457d07d25886dd16bc26608a77d6))
* zdd is now a function w/ tab completion ([e2a65ba](https://github.com/vladdoster/dotfiles/commit/e2a65bac057fc2f594b358c0fcbd23b49005d9b4))
* zsh::clean function removes zsh generated files ([f4843ef](https://github.com/vladdoster/dotfiles/commit/f4843efe93bc3c3ac1a7c66ba0eb2bb68ea42c98))

## [4.40.1](https://github.com/vladdoster/dotfiles/compare/v4.40.0...v4.40.1) (2023-11-01)


### Bug Fixes

* ensure $ZDOTDIR is set ([548fc1d](https://github.com/vladdoster/dotfiles/commit/548fc1d9ac0af7900dea0ba23df8629d40db17d2))
* git ignores regex zsh[-_]history ([f6ba5dc](https://github.com/vladdoster/dotfiles/commit/f6ba5dc96683728709a9a9daff0e91f92ee74c9e))
* zinit configuration parameters  ([8dbc946](https://github.com/vladdoster/dotfiles/commit/8dbc946b48642d1f80f6178a6f65fc76a391af67))
* zinit repo variable name ([ee27b15](https://github.com/vladdoster/dotfiles/commit/ee27b15d366e6092771c385ef5122e0d73b5cab9))

# [4.40.0](https://github.com/vladdoster/dotfiles/compare/v4.39.0...v4.40.0) (2023-10-21)


### Bug Fixes

* remove duplicate zic alias ([8b56bf6](https://github.com/vladdoster/dotfiles/commit/8b56bf65cec7e90a83a5f9135aa2c101ed325960))
* xcoh & emoji::shrug func ([8fceac1](https://github.com/vladdoster/dotfiles/commit/8fceac1a3c3c5806074ca81040fadbbe59e2bcbe))


### Features

* enable cloning zinit fork ([77a3c35](https://github.com/vladdoster/dotfiles/commit/77a3c358e3539ba87200bfcdb7347ef4ed7f9672))

# [4.39.0](https://github.com/vladdoster/dotfiles/compare/v4.38.0...v4.39.0) (2023-10-07)


### Bug Fixes

* dotfile dockerfile neovim install prefix ([d984ac5](https://github.com/vladdoster/dotfiles/commit/d984ac5b3249211a0fcefdf7e41835b6ea554117))
* editor alias & cleanup zsh config cruft ([20d1839](https://github.com/vladdoster/dotfiles/commit/20d183930edc4dfb40d9ece9bb8a67b478ab703f))
* misc. zinit config tweaks ([4a62ccb](https://github.com/vladdoster/dotfiles/commit/4a62ccb158d59b2bf9f7644ef62085499bd85879))
* set arch in makefile docker targets ([365bfec](https://github.com/vladdoster/dotfiles/commit/365bfec2df82dbbade8e88c5af72de9eef310bec))
* topgrade configuration ([fd7db00](https://github.com/vladdoster/dotfiles/commit/fd7db00b968675b31cc18f4d042319b10508f0fc))
* zi system check for neovim gh-r ([a210a51](https://github.com/vladdoster/dotfiles/commit/a210a513c368f310b228596462cad4c18c129a1a))


### Features

* build neovim & stow make targets ([f7aca99](https://github.com/vladdoster/dotfiles/commit/f7aca992e1dd8f6744def82a400906186f6ef907))

# [4.38.0](https://github.com/vladdoster/dotfiles/compare/v4.37.0...v4.38.0) (2023-10-01)


### Bug Fixes

* sort, mkcd, and zmv aliases ([989b803](https://github.com/vladdoster/dotfiles/commit/989b8039f4847c5f6f1d03fabcdad77ef9ef626e))


### Features

* configure less & lessopen env variables ([a6b8223](https://github.com/vladdoster/dotfiles/commit/a6b8223f071481991c8a72809ccc7008fa401571))

# [4.37.0](https://github.com/vladdoster/dotfiles/compare/v4.36.0...v4.37.0) (2023-10-01)


### Bug Fixes

* zi checks arch for neovim gh-r ([ff271c9](https://github.com/vladdoster/dotfiles/commit/ff271c9822dec787a5f26296de07f9a2d94dbc43))


### Features

* expand aliases via tab ([7ef4e02](https://github.com/vladdoster/dotfiles/commit/7ef4e02ad4f4e7f6a5542ec4a8fd1dd9ef61cee0))

# [4.36.0](https://github.com/vladdoster/dotfiles/compare/v4.35.0...v4.36.0) (2023-09-28)


### Bug Fixes

* gli func checks if in git dir ([b5c7d15](https://github.com/vladdoster/dotfiles/commit/b5c7d15d7b9697731a71f7f112e5a9916639d2d9))
* improve python make targets ([8cceaee](https://github.com/vladdoster/dotfiles/commit/8cceaee7453d47a16c65adb59d5e4125ffaca796))
* migrate exa -> eza & rdarwish -> topgrade-rs ([31841bb](https://github.com/vladdoster/dotfiles/commit/31841bb3cc4484063f81b9f372fd941764aa5594))
* use eza or exa depending on os ([0f1c95c](https://github.com/vladdoster/dotfiles/commit/0f1c95c1a2fc5fba6a720462f80339f44058541d))


### Features

* global aliases for less, grep, cat & sort ([3ffb5be](https://github.com/vladdoster/dotfiles/commit/3ffb5be77b29f057c79cd61d6ebeca24f65df892))

# [4.35.0](https://github.com/vladdoster/dotfiles/compare/v4.34.0...v4.35.0) (2023-09-21)


### Bug Fixes

* add python binary dir to path ([c5dabf4](https://github.com/vladdoster/dotfiles/commit/c5dabf4b69d00c1306a908d994a9dcacc3986aac))
* conflicting wezterm keybinds with tmux ([806a9c2](https://github.com/vladdoster/dotfiles/commit/806a9c2b0c7205f71fa5356a99e9b01ee0856d7a))
* correct zinit key to compinit_opts ([6816e42](https://github.com/vladdoster/dotfiles/commit/6816e42c6c313e21cdbca1350c1107849a3b2bd0))
* increase wezterm font size ([32e8c47](https://github.com/vladdoster/dotfiles/commit/32e8c47ff8837772f084aad5b0acdf7c72e2031d))
* python package install targets ([d147fea](https://github.com/vladdoster/dotfiles/commit/d147feabb727f532a33af43027593995b888efba))
* remove misc. programs in Brewfile ([0d62533](https://github.com/vladdoster/dotfiles/commit/0d625337351099023cc98e9a197031dc01186eb4))
* remove pinned branch for zunit ([1d6503d](https://github.com/vladdoster/dotfiles/commit/1d6503d2377a8e80ae2bf18186d66a54c2d3d785))
* remove resource intensive options in kitty config ([6e09a33](https://github.com/vladdoster/dotfiles/commit/6e09a33550aafcb361b97a0fa16519f82d2a8d46))
* wezterm open url mouse binding ([399cfda](https://github.com/vladdoster/dotfiles/commit/399cfda79ff9e4a382c1fc31e599c57372699044))


### Features

* set python version in makefile ([66c1fee](https://github.com/vladdoster/dotfiles/commit/66c1fee18d3005259f5b4b17e4e88f645a314847))

# [4.34.0](https://github.com/vladdoster/dotfiles/compare/v4.33.0...v4.34.0) (2023-09-04)


### Bug Fixes

* correct blex mono font name ([b787cf6](https://github.com/vladdoster/dotfiles/commit/b787cf67d6780212b9eccbd68a378f4ada7961d8))
* tweak zinit ices to improve load proces ([547b82a](https://github.com/vladdoster/dotfiles/commit/547b82a7271ec032a50458d17e33f9beffee051d))


### Features

* l, la, & ls aliases for ls +- opts ([53a3afa](https://github.com/vladdoster/dotfiles/commit/53a3afa0c2ec251862dc2ea98181eb72c13bf776))

# [4.33.0](https://github.com/vladdoster/dotfiles/compare/v4.32.1...v4.33.0) (2023-09-04)


### Bug Fixes

* set history path only one and early ([98dc477](https://github.com/vladdoster/dotfiles/commit/98dc4778688831ffc8814098056f7f092f2a7481))
* tweak zinit ices to improve load proces ([c337be8](https://github.com/vladdoster/dotfiles/commit/c337be8aaa5e89bc7bcbf58fb607345d2af224db))


### Features

* track exa, nvim & zi aliases via aliases ice ([9f15693](https://github.com/vladdoster/dotfiles/commit/9f15693f42656e42303462df4c42d688670012b3))

## [4.32.1](https://github.com/vladdoster/dotfiles/compare/v4.32.0...v4.32.1) (2023-09-03)


### Bug Fixes

* call -init-homebrew for arm64 macOS & linux ([67beb86](https://github.com/vladdoster/dotfiles/commit/67beb8616491b6cbbf631e6a13ae6e4a2fca46ff))
* do not set zdotdir env var in zsh rc.d config ([c946819](https://github.com/vladdoster/dotfiles/commit/c946819a4c9c0ec0208a8872dea2ff68ca06c093))
* move {f,}path setup to zshenv & rm zwc cruft ([7d623cb](https://github.com/vladdoster/dotfiles/commit/7d623cbfe62cbedf068257122caeaefa294d8ae0))
* re-add zinit & zsh config aliases ([5948f21](https://github.com/vladdoster/dotfiles/commit/5948f217be22d6468999417af1e18e83122d8a0b))
* remove cruft in zshrc ([33e0ec9](https://github.com/vladdoster/dotfiles/commit/33e0ec946bf7f6b61d9289f69d2d28f7b37a1e65))
* remove setting options in rc.d zsh config ([b63327e](https://github.com/vladdoster/dotfiles/commit/b63327ef6be20221e2d3b3f6759bf7bafeddc354))

# [4.32.0](https://github.com/vladdoster/dotfiles/compare/v4.31.0...v4.32.0) (2023-08-28)


### Bug Fixes

* reduce zinit load time for new prompt ([857d4fa](https://github.com/vladdoster/dotfiles/commit/857d4fad86fd0f1d5fcbcb88f68e65fa2d2bd2a5))
* set $pythonpath env var & add it to $path ([fc37847](https://github.com/vladdoster/dotfiles/commit/fc3784763a3e0401873ee2ae62bdd8a8af892627))
* update python pkg dir for $PATH ([0e1e513](https://github.com/vladdoster/dotfiles/commit/0e1e5131b59bc18cd292ebb733d9325498ba2879))
* use submods annex for misc. plugins ([9344fe0](https://github.com/vladdoster/dotfiles/commit/9344fe00e53a84609b444b441f0aff0c6a2119b0))
* zinit plugin load order  ([5731033](https://github.com/vladdoster/dotfiles/commit/5731033b3a2725621ec27fee957cc27f93bf2d99))


### Features

* maximize wezterm window when launched ([40d1585](https://github.com/vladdoster/dotfiles/commit/40d1585b294a5b3e06bcdb9c64b500c1e8175398))
* search files with perl regex via zpgrep ([4cbc338](https://github.com/vladdoster/dotfiles/commit/4cbc338817b1298515557372d10a17bf854cd3c3))

# [4.31.0](https://github.com/vladdoster/dotfiles/compare/v4.30.0...v4.31.0) (2023-08-23)


### Bug Fixes

* pip install target dir path ([5fb5b0a](https://github.com/vladdoster/dotfiles/commit/5fb5b0a36c095938eb454c303860a8f6084a5e6e))


### Features

* --distro & --platform flags for dkr command ([600aa8c](https://github.com/vladdoster/dotfiles/commit/600aa8c2fbcae45bbf9e6b91b56c8bafc3b07f37))
* add error handling to c function ([284c650](https://github.com/vladdoster/dotfiles/commit/284c650404522dd29e172e55db814138893ead83))
* add new options to dkr sandbox completion ([bd606c2](https://github.com/vladdoster/dotfiles/commit/bd606c2f22cd589488423d61b46d469b860bd1c6))
* dkr flag --platform to select amd64/arm64 ([1a66d2a](https://github.com/vladdoster/dotfiles/commit/1a66d2ad8cbab5bb5c321edd011fc9f50660876c))

# [4.30.0](https://github.com/vladdoster/dotfiles/compare/v4.29.0...v4.30.0) (2023-06-06)


### Bug Fixes

* check if zsh scripts exist in fzf config ([b044803](https://github.com/vladdoster/dotfiles/commit/b044803346bbf70ff7445c4aee9372ac8b894c09))
* logic checks in zinit config  ([a47d2ed](https://github.com/vladdoster/dotfiles/commit/a47d2ed18fd785b809b503220329476bcd073740))
* macos:rm-ds-store find command options ([21ad07d](https://github.com/vladdoster/dotfiles/commit/21ad07dca230aa3bf89eaa6bd805d07915727279))
* rm invalid formula ssh from brewfile ([d83a558](https://github.com/vladdoster/dotfiles/commit/d83a55831e70dc58662de278f5736254324f6ef4))
* zshrc indentation ([921475c](https://github.com/vladdoster/dotfiles/commit/921475c9360c1d40b8fa56d7021dead72a44b7e8))


### Features

* check for git repositories with new upstream commits ([0cd1eea](https://github.com/vladdoster/dotfiles/commit/0cd1eea4d810f570fa938c01010601cb85c6fec7))
* rm all compiled zsh zwc files via zsh:rm-zwc ([dcf2f20](https://github.com/vladdoster/dotfiles/commit/dcf2f2001c129a9d7e73e27108f9a58c6a7d89ba))

# [4.29.0](https://github.com/vladdoster/dotfiles/compare/v4.28.0...v4.29.0) (2023-06-02)


### Bug Fixes

* change zsh completion files to 644 ([ead2824](https://github.com/vladdoster/dotfiles/commit/ead28240281696c146e5b1d8a6c8ad1a1bf16354))
* mkfn autoload shebang & options ([60d2d7b](https://github.com/vladdoster/dotfiles/commit/60d2d7bde350fc4a7130a02f0da3346ebfd950bf))
* remove cruft from zfd ([91d8775](https://github.com/vladdoster/dotfiles/commit/91d8775fc1565d8e51e9e6e4af89a96926c0633a))
* remove ssh signing from git config  ([81f2b03](https://github.com/vladdoster/dotfiles/commit/81f2b034df79c4d39e4c75419c6c7b97095def8e))
* run `cleanup-runs.yml` workflow every sunday ([7dce754](https://github.com/vladdoster/dotfiles/commit/7dce75451a458ab2f2130dc239f4f1afd59635ce))
* smooth execute-and-wait.zsh spinner animation ([8a8f2f4](https://github.com/vladdoster/dotfiles/commit/8a8f2f40f117d2bc5a7489658dfea5a10ab809eb))
* zfd argument logic & zsh completion ([4d654c6](https://github.com/vladdoster/dotfiles/commit/4d654c6c6a9392838c4cd9293087586f99273f4c))
* zfd function zsh completion ([dbaf538](https://github.com/vladdoster/dotfiles/commit/dbaf53808f3e831185259784c9cd5a6bc98406e3))


### Features

* edit zsh completions via zcmp ([279b0e0](https://github.com/vladdoster/dotfiles/commit/279b0e0b9dec2969968d432029795e4a8d677293))
* interactively view git log via fzshow ([6ba463a](https://github.com/vladdoster/dotfiles/commit/6ba463ad7aae22c3ba1315986b85b242e478db4d))

# [4.28.0](https://github.com/vladdoster/dotfiles/compare/v4.27.0...v4.28.0) (2023-06-01)


### Bug Fixes

* +brew-link-keg logging & check multiple paths ([beceb4c](https://github.com/vladdoster/dotfiles/commit/beceb4c33d61d5c4dbc05441d9b067b5d8b3aede))
* dkr conflicting function name ([4c51d20](https://github.com/vladdoster/dotfiles/commit/4c51d209e68a8f46d9f5ae06cda3565dd63860be))
* dkr sandbox run builds image if not present ([2c6ffed](https://github.com/vladdoster/dotfiles/commit/2c6ffed766382c64ea5d0aefd58f37297f744667))
* dkr sub-command zsh completion ([5b4d611](https://github.com/vladdoster/dotfiles/commit/5b4d611fd91d1ab4dff949371a30faf160a3916b))
* fzf config logic checks ([690835b](https://github.com/vladdoster/dotfiles/commit/690835b4d5d932d304ae01f2dee6a8ded70a2747))


### Features

* alias 'get-localnet-hosts' lists hosts on LAN via arp-scan ([52ad514](https://github.com/vladdoster/dotfiles/commit/52ad514594d74e464792f23b8b2f90dca565b6b3))
* conditionally load zsh plugins if MININMAL set ([cb77198](https://github.com/vladdoster/dotfiles/commit/cb77198bb35db573d67326c9bb376a95855ca104))
* dkr zsh completion ([1517b18](https://github.com/vladdoster/dotfiles/commit/1517b1856ecd71d02ba0b3404a898b0a5b167e23))
* ls-containers shows containers indefinitely ([94a52b9](https://github.com/vladdoster/dotfiles/commit/94a52b9949dbd47c1cfd09f8ccfeee8cb9e85788))
* misc scripts colors-demo.zsh & execute-and-wait.zsh ([d58ae4c](https://github.com/vladdoster/dotfiles/commit/d58ae4c4f7feda9514538330d9a103346c6a17ed))
* set rehash to true for zsh completion ([6471328](https://github.com/vladdoster/dotfiles/commit/6471328aee455d5d81c6cad9d825c01c8a1774c1))

# [4.27.0](https://github.com/vladdoster/dotfiles/compare/v4.26.1...v4.27.0) (2023-05-17)


### Bug Fixes

* add null ice to zshelldoc cfg ([cfee6be](https://github.com/vladdoster/dotfiles/commit/cfee6be4086e1f83bbefd25cd3db713022bd88ea))
* dkr sandbox & nuke subcommands ([e4fd949](https://github.com/vladdoster/dotfiles/commit/e4fd949769875741eae6815096093f1dd96eb0ae))
* mkfile fn fixes ([fb5dc55](https://github.com/vladdoster/dotfiles/commit/fb5dc55aeb4c753f4b70cd833da92934e9183ca5))
* OMZ plugin load order ([f576eac](https://github.com/vladdoster/dotfiles/commit/f576eac227746503910e8d621dc3a1704e1454f4))
* set brew prefix in +brew-link-keg ([2d80caf](https://github.com/vladdoster/dotfiles/commit/2d80cafa6bfe5704349a72e0af49bd37ee2cc4ae))
* set path for zinit zcompdump ([27fe004](https://github.com/vladdoster/dotfiles/commit/27fe0045a47ece90923e122fdd2d1dcdea3d093c))
* zinit cfg updates ([217d80b](https://github.com/vladdoster/dotfiles/commit/217d80b265abee5efd0a111ca54df511a1bf638c))
* zinit config ([540b474](https://github.com/vladdoster/dotfiles/commit/540b4745feb0185b136d81b5deaadb5504399dbc))
* zinit plugin ices ([b5c60d9](https://github.com/vladdoster/dotfiles/commit/b5c60d9a36a5479daea5dfb690863e0ae6769381))


### Features

* add alias "mk" for "make" ([b2de4c0](https://github.com/vladdoster/dotfiles/commit/b2de4c072cd49fff9ec56dd4c2490252b55e628c))
* add gnu programs to PATH via +brew-link-kegs ([a2c3773](https://github.com/vladdoster/dotfiles/commit/a2c3773dc7d7027069bfef1ce3221d50f9a88e09))
* dkr command for common docker related tasks ([3931f02](https://github.com/vladdoster/dotfiles/commit/3931f02061809fbc30f919ba4a262e2a943c765e))
* help-zshglob lists common zsh globs ([0f1ccd4](https://github.com/vladdoster/dotfiles/commit/0f1ccd4b482761de2ee292d08ed8bbb79e3e8a7c))
* moved docker::nuke to be a dkr subcommand ([dde0fa0](https://github.com/vladdoster/dotfiles/commit/dde0fa0d9d7f2b5ca0131d556a77a0000ee7b505))

## [4.26.1](https://github.com/vladdoster/dotfiles/compare/v4.26.0...v4.26.1) (2023-05-01)


### Bug Fixes

* quoting in zinit config ([#39](https://github.com/vladdoster/dotfiles/issues/39)) ([dc97ad1](https://github.com/vladdoster/dotfiles/commit/dc97ad15d4123f632aff1669c7ef8c9750eb63d5))
* remove trailing `;` in zinit config ([1c06934](https://github.com/vladdoster/dotfiles/commit/1c06934dbe8f24107ffb8f1b4b36730c914b256a))
* zinit config quoting  ([8cfab51](https://github.com/vladdoster/dotfiles/commit/8cfab51fc0708583575546794608083c11d02a67))

# [4.26.0](https://github.com/vladdoster/dotfiles/compare/v4.25.1...v4.26.0) (2023-05-01)


### Bug Fixes

* +brew-link-keg logic ([aa6ad1e](https://github.com/vladdoster/dotfiles/commit/aa6ad1e9e649829756e14dcf6717d88d0d5f29de))
* fn function usage message ([62d6bee](https://github.com/vladdoster/dotfiles/commit/62d6beefca38db012f2a0e6eddd4eceb6f24cad6))
* kill zsh processes on exit ([bedbc33](https://github.com/vladdoster/dotfiles/commit/bedbc33e91a2acdb544662f684926c1be81dfe53))
* show function count in list::functions ([afc55f5](https://github.com/vladdoster/dotfiles/commit/afc55f5854cef1195dd11d5a73a4a24803bf31fe))


### Features

* generate function boilerplate via mkfn ([82bc383](https://github.com/vladdoster/dotfiles/commit/82bc383e828f2a3f7c3ad5707ef76bac5781dbdd))
* view or copy function(s) via fn ([c1d6c64](https://github.com/vladdoster/dotfiles/commit/c1d6c64f1237b08b05da68a6a7feccacb86d70a5))

## [4.25.1](https://github.com/vladdoster/dotfiles/compare/v4.25.0...v4.25.1) (2023-04-30)


### Bug Fixes

* fzf config conditional checks ([42fe9f3](https://github.com/vladdoster/dotfiles/commit/42fe9f31439e8940bbddaefcc7cb8953c19466d1))
* limit file handles a process can have open ([37c183c](https://github.com/vladdoster/dotfiles/commit/37c183c2eef5b7d86a99dd266a8d73f1b36545c1))
* zinit load times ([871eed4](https://github.com/vladdoster/dotfiles/commit/871eed458888b55bfeedc70f681660e83047edc8))

# [4.25.0](https://github.com/vladdoster/dotfiles/compare/v4.24.0...v4.25.0) (2023-04-17)


### Bug Fixes

* clean up .zshrc logic ([1c80e74](https://github.com/vladdoster/dotfiles/commit/1c80e74820a56af4bf66b58c018bb7fcbd124ff8))
* mkfile logic and logging ([baeb62f](https://github.com/vladdoster/dotfiles/commit/baeb62f8059562286044ddd2efeff438c7d49e96))


### Features

* check for updates from upstream repo ([22c35b7](https://github.com/vladdoster/dotfiles/commit/22c35b71d75f2cc04373a69615cd6b525e1e1ea5))
* easily backup file/dir via mkbak command ([018638c](https://github.com/vladdoster/dotfiles/commit/018638cb9637f14c60618145fbc8db924d69870a))
* ton of misc. changes to zsh related files ([2783806](https://github.com/vladdoster/dotfiles/commit/27838061940d31f006c31437a995327b59bf9377))

# [4.24.0](https://github.com/vladdoster/dotfiles/compare/v4.23.1...v4.24.0) (2023-04-10)


### Bug Fixes

* add /usr/local/bin to $PATH ([8a5a7b7](https://github.com/vladdoster/dotfiles/commit/8a5a7b7d1fee1c41f8cb67da97934bba3534b099))
* add exa to brewfile ([9b54e35](https://github.com/vladdoster/dotfiles/commit/9b54e35f6d283e1f45112cf6926f8c86e3aa1fbe))
* add jq to brewfile ([6c32e48](https://github.com/vladdoster/dotfiles/commit/6c32e4815b2a51343878caf30a710466b284558e))
* aliases for zsh rc.d and $ZDOTDIR ([82cf830](https://github.com/vladdoster/dotfiles/commit/82cf830f65832bbe40909682c4508083c734bc22))
* completion matching list ([f08433f](https://github.com/vladdoster/dotfiles/commit/f08433fc7530db5746e5c383e165fa551e1f0269))
* docker shell edge cases and completion ([2e7a587](https://github.com/vladdoster/dotfiles/commit/2e7a5874ff5d5805dea4954bd6869d026e54086f))
* format curl-progress ([a7e525e](https://github.com/vladdoster/dotfiles/commit/a7e525e90aea6ff32603dc8d033f0b6270084b3b))
* format zsh autoloaded functions ([e63b5be](https://github.com/vladdoster/dotfiles/commit/e63b5be8d3655101cdb2ee8157270d2ba3dc8e16))
* initializing homebrew ([e0ceff0](https://github.com/vladdoster/dotfiles/commit/e0ceff0fa2f56338119f277f25ff2d874a1fb65b))
* log statments and container tag ([0d23e32](https://github.com/vladdoster/dotfiles/commit/0d23e32d745d7c88b2521ef77d1cd30dbcbe79e5))
* remove default-ice annex usage ([cdb79c1](https://github.com/vladdoster/dotfiles/commit/cdb79c1ed7063c5bf7841b6d5cc7899fa59a67db))
* remove git-fzf.zsh cruft ([016cf9e](https://github.com/vladdoster/dotfiles/commit/016cf9e517d1eabe29f3964718c6b39d1e7fba4d))
* remove symlinks for misc. zsh login files ([1d8b152](https://github.com/vladdoster/dotfiles/commit/1d8b152fdcc04216cfa9827098fbbb495a5fd82b))
* remove unused python aliases ([9dc4738](https://github.com/vladdoster/dotfiles/commit/9dc4738362a8628bde252b5e3c017e96fb5a5e06))
* remove, add, update misc. aliases ([4ce5cdd](https://github.com/vladdoster/dotfiles/commit/4ce5cdd39d684da07168a7b2ba49653372adb964))
* rename brew.link-all-keg to +brew-link-keg ([4378866](https://github.com/vladdoster/dotfiles/commit/43788661a0c5a1ae24d037c3249a9e13cfaca20b))
* typos in zinit config ([1b588a7](https://github.com/vladdoster/dotfiles/commit/1b588a7267312117ca331bb1c085b9f8809338be))
* update brewfile programs ([88afdf1](https://github.com/vladdoster/dotfiles/commit/88afdf15c6c1a714e5c73513c3b37b82d006299b))
* zinit configuration ([c8be61d](https://github.com/vladdoster/dotfiles/commit/c8be61db3abaffa59be8ff2f019834ccf2660c5f))
* zsh config file aliases ([67f9f93](https://github.com/vladdoster/dotfiles/commit/67f9f934f7d0e31805c89b0e5053b445c4bf183e))


### Features

* link all brew kegs via brew.link-all-keg ([ba489c2](https://github.com/vladdoster/dotfiles/commit/ba489c22a7a9dccb09c01995704b0aca19089aec))
* new flags and completion for docker::sanbox & arch dockerfile ([24d4d34](https://github.com/vladdoster/dotfiles/commit/24d4d34e7b60e1858cb6796a10d15269d550a67c))

## [4.23.1](https://github.com/vladdoster/dotfiles/compare/v4.23.0...v4.23.1) (2023-03-27)


### Bug Fixes

* add --verbose & --tag opts to docker::shell ([47e1b16](https://github.com/vladdoster/dotfiles/commit/47e1b16bef2faffaf4a685defe5ed9f9b0a02b6f))
* add file & unzip pkgs to base docker container ([c8bb512](https://github.com/vladdoster/dotfiles/commit/c8bb512ce584bf7620488a3aa0479867ee9b9879))
* attempt to set locale in zlogin ([737591b](https://github.com/vladdoster/dotfiles/commit/737591b14a65acb8f3d48e3d62640c327d481e38))
* remove extraneous characters ([0382ab7](https://github.com/vladdoster/dotfiles/commit/0382ab785476f21338046f5edf20f71d4fd43318))
* set docker shell volume to container name ([a95ad02](https://github.com/vladdoster/dotfiles/commit/a95ad025d1b402c14c487d2d0429d31d6f9b0b05))
* set explicit width of zsh prompt characters ([88a993f](https://github.com/vladdoster/dotfiles/commit/88a993ff665df412ad1d4a8762fbd344a9ca2f27))
* source alias first in case of errors ([a4271eb](https://github.com/vladdoster/dotfiles/commit/a4271ebe606cba9dac1aa1e15eba6da6e739b2f3))
* zinit config compinit calls ([ce055e4](https://github.com/vladdoster/dotfiles/commit/ce055e407566405360e484db1537115255b4d5fa))
* zsh compinit calls ([b64a479](https://github.com/vladdoster/dotfiles/commit/b64a47955b1d9aab69fcc26433122ff0fc4c37ca))

# [4.23.0](https://github.com/vladdoster/dotfiles/compare/v4.22.0...v4.23.0) (2023-03-26)


### Bug Fixes

* Brewfile taps, cask args, and casks ([555bb09](https://github.com/vladdoster/dotfiles/commit/555bb094d9aab8c863ae60b33d17ab5da90d8681))
* misc. updates to zsh env, opts, and completion ([8c90a04](https://github.com/vladdoster/dotfiles/commit/8c90a047fd37f00055542ace9f6710d83aaa7253))
* misc. updates to zsh functions ([815572c](https://github.com/vladdoster/dotfiles/commit/815572c4bb97f8b813066e17538207754a83d28f))
* misc. wezterm keybinds and colorscheme ([5509eb2](https://github.com/vladdoster/dotfiles/commit/5509eb23ad845a6e32c77ed3a44882d35c639dff))
* wezterm configuration ([696e79d](https://github.com/vladdoster/dotfiles/commit/696e79d84ac2eedb699a86edd1d7b7d6730371fe))
* wezterm splitpane key map ([16577fb](https://github.com/vladdoster/dotfiles/commit/16577fb450c8bccd5b3742145dfdbf2d4fc8268a))
* zsh alias to rc/06-alias.zsh ([21dfb60](https://github.com/vladdoster/dotfiles/commit/21dfb60da430dcd928679a418687d48fd926903e))


### Features

* print colorized figlet messages via banner ([eafcdff](https://github.com/vladdoster/dotfiles/commit/eafcdff3f2474635068e26e63ce61836f02703ac))
* progress bar for curl via curl-progress ([19311aa](https://github.com/vladdoster/dotfiles/commit/19311aa399923f6af18e2780e5a3e111807082c5))
* quick sandbox env via docker::shell function ([bd75b4e](https://github.com/vladdoster/dotfiles/commit/bd75b4e37197f132330e91293d29991a5a2e5327))

# [4.22.0](https://github.com/vladdoster/dotfiles/compare/v4.21.2...v4.22.0) (2023-03-22)


### Bug Fixes

* docker nuke function cleanup ([3f47d17](https://github.com/vladdoster/dotfiles/commit/3f47d175b39ccd40b38b5dc41f108d5a87751207))
* enable wezterm scrollbar and tab bar ([74e17f7](https://github.com/vladdoster/dotfiles/commit/74e17f738109958ca3eb3c62e90ae563928345ff))
* remove zfd alias ([176dfd2](https://github.com/vladdoster/dotfiles/commit/176dfd22c6b5787e8bad361380fba516e8de0338))
* zdd zcompcache & zcompdump to global gitignore ([6586ebd](https://github.com/vladdoster/dotfiles/commit/6586ebd9a6e3d2eb899f917e48c725bdbe23b1ae))


### Features

* add dockerfile with arch linux base image ([9c0ea2a](https://github.com/vladdoster/dotfiles/commit/9c0ea2ac54aaf581e8ac6c5b80038fda4db4b2a5))
* add-to-path func for easy path manipulation ([03f8754](https://github.com/vladdoster/dotfiles/commit/03f875460b5972d4e5c98d0a54778940e637385f))
* mkfile func to easily create file(s) ([076c9c2](https://github.com/vladdoster/dotfiles/commit/076c9c2baaf2bc6c2cc72f1e5c5b0eec6e13cbe1))
* zfd func to easily edit zsh functions ([81ba4be](https://github.com/vladdoster/dotfiles/commit/81ba4be9933e08804230ae3aab5e93d66f496652))

## [4.21.2](https://github.com/vladdoster/dotfiles/compare/v4.21.1...v4.21.2) (2023-03-20)


### Bug Fixes

* .zshenv conditionally sources .zprofile ([7db7025](https://github.com/vladdoster/dotfiles/commit/7db70256a27a7228a877e4ae5dc5656538ed3b3b))
* compile completions in .zlogin ([543681f](https://github.com/vladdoster/dotfiles/commit/543681fc490cc0a1ed7ea392f785dd75d2af65b5))
* misc. zsh rc.d changes ([4ef9c81](https://github.com/vladdoster/dotfiles/commit/4ef9c81b95c4c7ce4563aaea5400769d15831ee8))
* personal zsh completions ([2756af2](https://github.com/vladdoster/dotfiles/commit/2756af2c169b38711153f3268f23180a0b73c4e7))

## [4.21.1](https://github.com/vladdoster/dotfiles/compare/v4.21.0...v4.21.1) (2023-03-20)


### Bug Fixes

* remove docker hub token parameter ([65f6dcc](https://github.com/vladdoster/dotfiles/commit/65f6dccd010d70aca413f3ed93a087582e8bd1b2))

# [4.21.0](https://github.com/vladdoster/dotfiles/compare/v4.20.0...v4.21.0) (2023-03-13)


### Bug Fixes

* add zsh_history to repo .gitignore ([e9c3d91](https://github.com/vladdoster/dotfiles/commit/e9c3d91d601e6e2c7c0ba6604a269feb06889ad5))
* c zsh function logic ([2091d38](https://github.com/vladdoster/dotfiles/commit/2091d38b8b54c09f1bfa58ca25aca23c4444f7f1))
* makefile pip opts uses cache and --target-dir ([a6517d9](https://github.com/vladdoster/dotfiles/commit/a6517d9f38836176ec14336003a3b782302a6b2a))
* remove cruft in global git ignore ([cadd984](https://github.com/vladdoster/dotfiles/commit/cadd98445e039a652a3b34db51ee21c8e82cdbc0))
* rm code and comments in .zshrc and .zprofile ([f76895e](https://github.com/vladdoster/dotfiles/commit/f76895ee9e346651c602582d94f62b4fbf9928a2))
* vd command and _vd completion ([d27ca7b](https://github.com/vladdoster/dotfiles/commit/d27ca7b775780d586ede89fa13eca0a73f343725))
* zsh rc files load order and logic ([7b1b525](https://github.com/vladdoster/dotfiles/commit/7b1b52516f7d9cb497c2dc06a1ff904064ddb144))


### Features

* wezterm configuration ([0866d18](https://github.com/vladdoster/dotfiles/commit/0866d1818d7269054c15e283ae74578d1887bbd8))
* xdg dir navigation functions and completions ([ffa91e9](https://github.com/vladdoster/dotfiles/commit/ffa91e92bdbeecadd74223197eb0430d01afc0d8))

# [4.20.0](https://github.com/vladdoster/dotfiles/compare/v4.19.0...v4.20.0) (2023-03-03)


### Bug Fixes

* python venv and remove unused aliases ([594fb76](https://github.com/vladdoster/dotfiles/commit/594fb76f0bc2e9439504bca91a2ed134a3136f17))
* remove .zshrc cruft ([99e093d](https://github.com/vladdoster/dotfiles/commit/99e093da52ddf5106b7435da0e27aa44a88911e2))
* remove zsh completions dir ([5820595](https://github.com/vladdoster/dotfiles/commit/58205955ffe4cd2f43961f3ec3f682d8ee9cb083))


### Features

* async compile zsh files in .zlogin ([b68ce96](https://github.com/vladdoster/dotfiles/commit/b68ce967bd0106a279aa539df874efab700727c9))
* function & completion for c, df, h, vd, zgd ([c714382](https://github.com/vladdoster/dotfiles/commit/c7143821e193c0dcc807f35eba3f84336a112d6f))

# [4.19.0](https://github.com/vladdoster/dotfiles/compare/v4.18.2...v4.19.0) (2023-02-27)


### Bug Fixes

* add homebrew to path in zprofile ([e8f89da](https://github.com/vladdoster/dotfiles/commit/e8f89daedd283bf4a2ba9b29df134108a52a40e5))
* autoload personal completions in zshrc ([4b541a8](https://github.com/vladdoster/dotfiles/commit/4b541a830b29760d1172c49dd1af011429db81d6))
* autoloading  & completion in zshrc ([9968449](https://github.com/vladdoster/dotfiles/commit/996844942c72c87ccd3a97a1c4cc84031a8c04a5))
* cleanup zshrc ([add34c7](https://github.com/vladdoster/dotfiles/commit/add34c7da9d99812fd553e8b9e108f805fd92444))
* history configuration in .zshrc ([9e45615](https://github.com/vladdoster/dotfiles/commit/9e45615ef3a72f132442011d4d6fd4a142a71825))
* move update-path logic from zprofile to zshrc ([88938e5](https://github.com/vladdoster/dotfiles/commit/88938e58eb80d59213266d07f3ec39bd39ec16a2))
* optimize plugin ices in zinit.zsh ([9ca2a91](https://github.com/vladdoster/dotfiles/commit/9ca2a917758c9f4af6566847da8d6cb2062e6f53))
* remove python, c, h, and df aliases ([0b0fc16](https://github.com/vladdoster/dotfiles/commit/0b0fc163bbbb3771654e4f9511f5f65b89e816cf))
* remove zinit aliases ([ee62042](https://github.com/vladdoster/dotfiles/commit/ee62042442ffff9c5863960ede977c3e647ab4da))
* simplify spaghetti logic in aliases.zsh ([affb3bb](https://github.com/vladdoster/dotfiles/commit/affb3bb7c955d2309fc4aa0ce7ab6fb8e5298f81))
* style & rm update path func in zprofile ([b2ce5e5](https://github.com/vladdoster/dotfiles/commit/b2ce5e5ad4d91707fb8eba82235953218d14c3db))
* update files in gnu stow ignore files ([cc99063](https://github.com/vladdoster/dotfiles/commit/cc99063bcc7b2b4ebba3237c978aef10ee74a60d))
* zunit install recipe in zinit ([258cccb](https://github.com/vladdoster/dotfiles/commit/258cccb9c964ce7a933093f5a6a5191d9cc932a3))


### Features

* add diagrams to py-pkgs in makefile ([e643851](https://github.com/vladdoster/dotfiles/commit/e6438516c7e11d6469e20e0734d7a8c5e688109d))
* add h,c,df functions & completions ([33321eb](https://github.com/vladdoster/dotfiles/commit/33321ebe5ea463ba73436b52df90bd75ef74cc04))
* add symlinks to zshrc, zshenv, and zprofile ([55e4819](https://github.com/vladdoster/dotfiles/commit/55e48198144f4724ed699c231c3954b9a84adc73))
* compile zsh functions via zsh::compile cmd ([25a16ff](https://github.com/vladdoster/dotfiles/commit/25a16ffcb0097900f8e4be0fdca0921e4b8051b5))
* completion loading func zsh::load-completion ([86dd924](https://github.com/vladdoster/dotfiles/commit/86dd92497a9f5026a27ec5b4895ab07e5b392b47))

## [4.18.2](https://github.com/vladdoster/dotfiles/compare/v4.18.1...v4.18.2) (2023-02-19)


### Bug Fixes

* add local python bin to path in zprofile ([05f12bc](https://github.com/vladdoster/dotfiles/commit/05f12bcc9494d01339d8d56e198dad4aa934feef))
* cmd & rm zsh plugins install in dockerfile ([d0b4cbd](https://github.com/vladdoster/dotfiles/commit/d0b4cbdf034c623754d17c662813e96f203dfbc7))
* docker tag in docker-shell make target ([c8e36fe](https://github.com/vladdoster/dotfiles/commit/c8e36fe95108413d8cbbe90a7bca14f8be0d0381))
* hide title bar in kitty config ([ee10675](https://github.com/vladdoster/dotfiles/commit/ee10675ae5206712fbfbf32cb9e430dae015acca))
* misc. plugins & snippets in zinit config ([637d2a9](https://github.com/vladdoster/dotfiles/commit/637d2a9c0ae01ee198ab041895c7998a7be6368c))
* rm cruft & simplify prompt logic ([78439e9](https://github.com/vladdoster/dotfiles/commit/78439e9f9300c910b853d23413a0a312be24f084))
* zsh history & cache paths in zshrc ([fcd190b](https://github.com/vladdoster/dotfiles/commit/fcd190b44476c4af03d410b425276cb798fb9df9))

## [4.18.1](https://github.com/vladdoster/dotfiles/compare/v4.18.0...v4.18.1) (2023-02-18)


### Bug Fixes

* pure prompt and syntax highlighting repo var ([4fa91f8](https://github.com/vladdoster/dotfiles/commit/4fa91f8b27d74e94051dbb3ab6379fd375201ce0))

# [4.18.0](https://github.com/vladdoster/dotfiles/compare/v4.17.0...v4.18.0) (2023-02-13)


### Bug Fixes

* brew-install make target ([27a9acd](https://github.com/vladdoster/dotfiles/commit/27a9acd6d0ad700d695537a7bbfd2eac49d772b5))
* load all zsh modules & add completion option ([88c288b](https://github.com/vladdoster/dotfiles/commit/88c288b58ac573361fdd833b40387f67a89ccc12))
* logic to set homebrew and path ([f0f67f0](https://github.com/vladdoster/dotfiles/commit/f0f67f03f5a0ace98a990ccfa0898cdca703378e))
* remove duplicate aliases ([bd16e38](https://github.com/vladdoster/dotfiles/commit/bd16e380a68e35e2aa5152a8b3dc0d518f66c64d))
* remove loading all zsh modules ([53ae248](https://github.com/vladdoster/dotfiles/commit/53ae248411fa478d941fb1ef5fd562d69d2d41d5))
* rm cruft & simplify $path values ([7483b17](https://github.com/vladdoster/dotfiles/commit/7483b17a6cbc6a45ea8af2e79d2f68213964a349))
* rm unused _export helper function ([d729483](https://github.com/vladdoster/dotfiles/commit/d729483c0e92502696f8196c5a6448062dc3835e))
* zinit recipes & use personal fork ([7c40e50](https://github.com/vladdoster/dotfiles/commit/7c40e5090ed1668ea118b0a2d84a89d6bd7e61db))


### Features

* add & optimize zsh autoload functions ([81c36a7](https://github.com/vladdoster/dotfiles/commit/81c36a7657a9a4d41da6b8d36edf1d01db80474d))
* run make target anywhere via dotfiles::make ([155d9a9](https://github.com/vladdoster/dotfiles/commit/155d9a9161113cc7a0a95895ae1c9733349b68cb))

# [4.17.0](https://github.com/vladdoster/dotfiles/compare/v4.16.0...v4.17.0) (2023-02-04)


### Bug Fixes

* bootstrap macos options & dockutil logic ([1bb5d56](https://github.com/vladdoster/dotfiles/commit/1bb5d562b3eeba0c7dce3022679000e7e002a215))
* condense .zprofile $PATH & env var logic ([35be3cb](https://github.com/vladdoster/dotfiles/commit/35be3cb88daf170f5419665bc5797ff16623c40c))
* makefile logging & misc. target logic ([aa154fd](https://github.com/vladdoster/dotfiles/commit/aa154fd02f13851e4f8872e5ea7614ddb8f7b731))
* mv emoji functions to be autoloaded via zsh ([23e758f](https://github.com/vladdoster/dotfiles/commit/23e758f11126b707bcdf7ff48f2ef10332ca02f7))
* use default-ice in zinit ([74ada21](https://github.com/vladdoster/dotfiles/commit/74ada21b225a2f637cc9b9df0072a88fa8c67196))
* zinit make ice prefix & formatting ([0c6e402](https://github.com/vladdoster/dotfiles/commit/0c6e402690bd373238f4c1c0d6d557cb088a7de0))
* zprofile & zshenv logic ([8b2e880](https://github.com/vladdoster/dotfiles/commit/8b2e880f2863e44f827100de10a1258c80133db3))


### Features

* add safari::tab command to new safari tab ([3399f46](https://github.com/vladdoster/dotfiles/commit/3399f46989624d4160eb41098339f991267798cc))
* alias ? to "which" command ([f65dea6](https://github.com/vladdoster/dotfiles/commit/f65dea65e181b0cb2f959f41b9daefd2380bd92d))
* watch::file-count cmd prints # files in dir ([fcf2d28](https://github.com/vladdoster/dotfiles/commit/fcf2d2886049fc820741e761e7375f4c201518b5))

# [4.16.0](https://github.com/vladdoster/dotfiles/compare/v4.15.0...v4.16.0) (2023-02-01)


### Bug Fixes

* disable homebrew env hints & auto cleanup ([09876af](https://github.com/vladdoster/dotfiles/commit/09876afccf2ea4fbb62c812f8fbf13007a3df33d))
* set executable bit on rld::file zsh function ([1717a35](https://github.com/vladdoster/dotfiles/commit/1717a35fbecce4ff48248b1ca6674244cb9bbe73))


### Features

* add docker::nuke func via zsh autoloading ([82a451c](https://github.com/vladdoster/dotfiles/commit/82a451c28251651cdec52cb0b5aaa297da84e17d))

# [4.15.0](https://github.com/vladdoster/dotfiles/compare/v4.14.0...v4.15.0) (2023-01-17)


### Bug Fixes

* simplify git & zinit aliases ([48e5ff8](https://github.com/vladdoster/dotfiles/commit/48e5ff855cd1b1e66ffd923642c50dcd64e373b6))


### Features

* `rld::file` function to source a file  ([0d89fc4](https://github.com/vladdoster/dotfiles/commit/0d89fc42bce9327c738a8baeb5f9dd2676489415))

# [4.14.0](https://github.com/vladdoster/dotfiles/compare/v4.13.9...v4.14.0) (2023-01-16)


### Bug Fixes

* .zshrc logging ([d348eb6](https://github.com/vladdoster/dotfiles/commit/d348eb663f99798657edf2a7b6d8196070c7740e))
* add .DS_Store to .dockerignore ([2c4fa6c](https://github.com/vladdoster/dotfiles/commit/2c4fa6c378212156029d170e32485f90e63b1555))
* add dockutil to bootstrap-macos ([96ba56e](https://github.com/vladdoster/dotfiles/commit/96ba56ef9c882d97f08c2363642f64da374bf4b2))
* consolidate zshenv logic into zprofile ([0306f77](https://github.com/vladdoster/dotfiles/commit/0306f7744a757db128e79df2b32e308d32148248))
* docker, brew-install, & python make targets ([289f19f](https://github.com/vladdoster/dotfiles/commit/289f19fbfd314da143741929623ad1c8789095df))
* dockerfile & docker related make target logic ([5275136](https://github.com/vladdoster/dotfiles/commit/5275136f70e33fcd4d9f70436cc83dd049681065))
* dockerfile build time & copy dotfile repo ([35f823a](https://github.com/vladdoster/dotfiles/commit/35f823ab9f23b11d781116edd133ff17796f1774))
* dockerfile neovim installation ([19a753a](https://github.com/vladdoster/dotfiles/commit/19a753aa5ffc0f65fa76578e4a44386f544b50a8))
* logging in aliases.zsh ([d26de89](https://github.com/vladdoster/dotfiles/commit/d26de89b7255b75ada86dd878473409abfb0fff5))
* path modification logic & logging ([ba4bd35](https://github.com/vladdoster/dotfiles/commit/ba4bd35667f7f58ef82791d5a8b0902c53abcdec))
* remove git config cruft ([8ba4909](https://github.com/vladdoster/dotfiles/commit/8ba49097b434114fda0efc09ed02de42196808e3))
* remove sourcing rust cargo env ([7f27112](https://github.com/vladdoster/dotfiles/commit/7f271123d36807c613add78272ecface11145cc8))
* rm docker-ssh & update py-pkgs Makefile target ([55422e2](https://github.com/vladdoster/dotfiles/commit/55422e212d8f04c32a0de1ccaee3e65579514a00))
* styling & gadd zsh func to aliases ([48340e4](https://github.com/vladdoster/dotfiles/commit/48340e470c6bd4ac734d12bc82cd9e603abd6bff))
* use autoload logging & test zinit styling ([36eaf8e](https://github.com/vladdoster/dotfiles/commit/36eaf8e669e8972654269399e8dd3d5ddd42c7c1))
* zinit.zsh logging & update misc. plugins ([fd2662f](https://github.com/vladdoster/dotfiles/commit/fd2662ff5ddd76c422c5ca917607b71c2bf8c398))


### Features

* run docker image workflow after release ([2cef205](https://github.com/vladdoster/dotfiles/commit/2cef20594f75dc4f7337ce36b024d37945ce7a50))

## [4.13.9](https://github.com/vladdoster/dotfiles/compare/v4.13.8...v4.13.9) (2023-01-08)


### Bug Fixes

* add qemu step to docker workflow ([31495d6](https://github.com/vladdoster/dotfiles/commit/31495d6067dc535774a33f391b5c4e7569bacf1e))
* dockerfile labels ([82bc81c](https://github.com/vladdoster/dotfiles/commit/82bc81c4a473315cf7400617f2e7d6a1050aed58))
* format dockerfile labels ([61cb5ef](https://github.com/vladdoster/dotfiles/commit/61cb5ef3a31e942d383b0ff1fc2f2bb1f747cef2))
* install apt prerequisites for neovim ppa ([47efe57](https://github.com/vladdoster/dotfiles/commit/47efe57c132d10ade986567c8c591beb9cc5620e))
* install apt recommended ([3a341f2](https://github.com/vladdoster/dotfiles/commit/3a341f2002c0d576b6d4832dd651716c09184bad))
* remove ncurses-bin package ([44a7ad9](https://github.com/vladdoster/dotfiles/commit/44a7ad9b3f2350b0ef59ae943f50e67ab4f17b36))
* remove neovim src with sudo ([f6c4cdc](https://github.com/vladdoster/dotfiles/commit/f6c4cdc8b9d0253d87d492e439e22661818a02ce))
* use nightly apt repo instead of compiling nvim ([8161f71](https://github.com/vladdoster/dotfiles/commit/8161f71ae7bf5f66431426ce4099ecdb532fa56f))

## [4.13.8](https://github.com/vladdoster/dotfiles/compare/v4.13.7...v4.13.8) (2023-01-01)


### Bug Fixes

* add zinit gh-r progs & hostname to prompt ([a81cbf0](https://github.com/vladdoster/dotfiles/commit/a81cbf0d5020a3c11487ecad4426da638328964b))

## [4.13.7](https://github.com/vladdoster/dotfiles/compare/v4.13.6...v4.13.7) (2022-12-31)


### Bug Fixes

* add system info to "me" alias ([8874a93](https://github.com/vladdoster/dotfiles/commit/8874a93ecb7f30429b2fd419c239b2f59c8c8546))

## [4.13.6](https://github.com/vladdoster/dotfiles/compare/v4.13.5...v4.13.6) (2022-12-22)


### Bug Fixes

* add exa & delta to Dockerfile ([9dc5d65](https://github.com/vladdoster/dotfiles/commit/9dc5d652deb65b04495e2d2aba33c7a3b63d8d60))

## [4.13.5](https://github.com/vladdoster/dotfiles/compare/v4.13.4...v4.13.5) (2022-12-22)


### Bug Fixes

* disable zinit config cruft ([7c79be5](https://github.com/vladdoster/dotfiles/commit/7c79be54153c44b7ccd40d89a342131e40232617))
* docker-build & docker-shell Make targets ([e89b7c0](https://github.com/vladdoster/dotfiles/commit/e89b7c0ebae8868bd8f6ead514058e736b19c478))
* Dockerfile base image & CMD ([715f322](https://github.com/vladdoster/dotfiles/commit/715f3229a94a8ecb846b68364a3500af154dcee2))
* PATH and env variables ([443ba60](https://github.com/vladdoster/dotfiles/commit/443ba60b088113fa626113e74c65cf9341037412))
* zinit plugin repository ([fe158d9](https://github.com/vladdoster/dotfiles/commit/fe158d90fae4dba388b1e783e811c55f1ba50d90))

## [4.13.4](https://github.com/vladdoster/dotfiles/compare/v4.13.3...v4.13.4) (2022-12-20)


### Bug Fixes

* use minideb:bullseye base docker image ([2243776](https://github.com/vladdoster/dotfiles/commit/2243776ea3724bbc9f41eee74e039be74731f8cc))

## [4.13.3](https://github.com/vladdoster/dotfiles/compare/v4.13.2...v4.13.3) (2022-12-20)


### Bug Fixes

* remove docker-clean in docker-push make target ([85a4276](https://github.com/vladdoster/dotfiles/commit/85a427657d60ad9ec505b34e8c85602e3ee24b5e))
* remove ssh -> docker from dockerfile ([6aba856](https://github.com/vladdoster/dotfiles/commit/6aba85633cf488e0445ea4d170846672fb55977e))

## [4.13.2](https://github.com/vladdoster/dotfiles/compare/v4.13.1...v4.13.2) (2022-12-19)


### Bug Fixes

* add docker-ssh make target to README.md ([50c7be3](https://github.com/vladdoster/dotfiles/commit/50c7be3e1125ea04fa5cf90216a8d04edcf4ccd0))
* dockerfile log msg  &  pkg python3-bdist-nsi ([4d10eba](https://github.com/vladdoster/dotfiles/commit/4d10eba3775d048552ede20e3ca9a47c55ba1492))

## [4.13.1](https://github.com/vladdoster/dotfiles/compare/v4.13.0...v4.13.1) (2022-12-19)


### Bug Fixes

* silence all make targets ([f8cb924](https://github.com/vladdoster/dotfiles/commit/f8cb92472a76094af49a450c826168d6eaa0d538))

# [4.13.0](https://github.com/vladdoster/dotfiles/compare/v4.12.0...v4.13.0) (2022-12-19)


### Features

* connect to docker container via ssh ([6ce3810](https://github.com/vladdoster/dotfiles/commit/6ce3810dd7ba5120acd4f8e442515daa615f78d3))

# [4.12.0](https://github.com/vladdoster/dotfiles/compare/v4.11.0...v4.12.0) (2022-12-19)


### Features

* update-readme make target ([6947273](https://github.com/vladdoster/dotfiles/commit/69472734bb0a54e709a4ab6bc1ea3c6cb312e1df))

# [4.11.0](https://github.com/vladdoster/dotfiles/compare/v4.10.3...v4.11.0) (2022-12-18)


### Bug Fixes

* dockerfile structure & logic ([7eb02b7](https://github.com/vladdoster/dotfiles/commit/7eb02b7c7a8c8efc617f9114382205bca96938f1))


### Features

* run container images workflow after release ([1633f97](https://github.com/vladdoster/dotfiles/commit/1633f97815f3b995360d3a264c0cea6be0b0f93c))

## [4.10.3](https://github.com/vladdoster/dotfiles/compare/v4.10.2...v4.10.3) (2022-12-17)


### Bug Fixes

* add hadolint & rm id-as ice ([397043b](https://github.com/vladdoster/dotfiles/commit/397043b77d908712695aa47ff69f36b62a07c8c7))
* add meson & rm apt cleanup in Dockerfile ([42d35e1](https://github.com/vladdoster/dotfiles/commit/42d35e1aec6e4cdd30c471b46895133defd8a9e6))
* add platform flag in docker-build Make target ([fdbf5f0](https://github.com/vladdoster/dotfiles/commit/fdbf5f0065644f08e74e55212e098b56bc521a9f))

## [4.10.2](https://github.com/vladdoster/dotfiles/compare/v4.10.1...v4.10.2) (2022-12-16)


### Bug Fixes

* add bdfr default config to .gitignore ([9af434a](https://github.com/vladdoster/dotfiles/commit/9af434a59c5cab81bca752e6cdddd91748a0cfff))

## [4.10.1](https://github.com/vladdoster/dotfiles/compare/v4.10.0...v4.10.1) (2022-12-16)


### Bug Fixes

* rm --user pip option in py-* make targets ([ae27e6a](https://github.com/vladdoster/dotfiles/commit/ae27e6a0e04dc8eb04da620fafc92dcb2a3f7932))

# [4.10.0](https://github.com/vladdoster/dotfiles/compare/v4.9.1...v4.10.0) (2022-12-16)


### Bug Fixes

* flags in docker-build make target ([9fc4982](https://github.com/vladdoster/dotfiles/commit/9fc4982c9947ca10a2c92a283e3bc07c4af30909))


### Features

* add watch to Brewfile ([0f3b403](https://github.com/vladdoster/dotfiles/commit/0f3b40346b765d10939a04d4f168d71ecba078e4))

## [4.9.1](https://github.com/vladdoster/dotfiles/compare/v4.9.0...v4.9.1) (2022-12-16)


### Bug Fixes

* [@zi](https://github.com/zi)::scheduler call in Dockerfile RUN cmd ([04e64da](https://github.com/vladdoster/dotfiles/commit/04e64dabe0b751085e84b2c31f514573123bb9c7))
* insert-last-command-output vicmd keybind ([56d388b](https://github.com/vladdoster/dotfiles/commit/56d388be6cc630647d39bab05806f0da15fc79c8))

# [4.9.0](https://github.com/vladdoster/dotfiles/compare/v4.8.1...v4.9.0) (2022-12-16)


### Bug Fixes

* apply id-as ice to all zi commands ([84dbfbf](https://github.com/vladdoster/dotfiles/commit/84dbfbfcc1ea92b836d11ab48f3f3b995ce267ed))


### Features

* insert-last-command-output & prepend-sudo keybinds ([5f2a3c1](https://github.com/vladdoster/dotfiles/commit/5f2a3c1e1b26f2aa345b757669598ede1ecc2774))

## [4.8.1](https://github.com/vladdoster/dotfiles/compare/v4.8.0...v4.8.1) (2022-12-16)


### Bug Fixes

* comment out broken git zle widgets ([5c64310](https://github.com/vladdoster/dotfiles/commit/5c643105c60257d52fa12eb583486251bc1f131a))
* zinit ver'' & lbin'' ices ([3bf7040](https://github.com/vladdoster/dotfiles/commit/3bf70400ef3afe01106c76d3ade0944b45a2e5db))

# [4.8.0](https://github.com/vladdoster/dotfiles/compare/v4.7.1...v4.8.0) (2022-12-16)


### Bug Fixes

* use updated sbin logic ([b82bc4d](https://github.com/vladdoster/dotfiles/commit/b82bc4dbd7bec5cc4d34f1bee7f6d3e3d406d1ba))


### Features

* print functions in file via list-functions ([c241661](https://github.com/vladdoster/dotfiles/commit/c24166164fabde35f2be4a3e0f18e12fdf8f85ef))

## [4.7.1](https://github.com/vladdoster/dotfiles/compare/v4.7.0...v4.7.1) (2022-12-09)


### Bug Fixes

* change to personal fork ([465029d](https://github.com/vladdoster/dotfiles/commit/465029d502185762c092271523a9ab5304eaee32))

# [4.7.0](https://github.com/vladdoster/dotfiles/compare/v4.6.24...v4.7.0) (2022-12-09)


### Bug Fixes

* clean up zinit configuration ([8ac3fd0](https://github.com/vladdoster/dotfiles/commit/8ac3fd029902b19b3098fc5dbf65fb883e5fd979))
* set vim to git editor ([6f08401](https://github.com/vladdoster/dotfiles/commit/6f08401905fae2817c53aea495e1cd83a4b3a8a7))
* specify base image architecture in dockerfile ([4d12264](https://github.com/vladdoster/dotfiles/commit/4d12264f9ba7ff5fbc11c1974f7c4500a5acf2d7))
* vim modeline & trailing backslashes in .zprofile ([a30e8ae](https://github.com/vladdoster/dotfiles/commit/a30e8ae89492d51ca947dad7906bb14fb6ed1b03))


### Features

* docker-load & docker-save Make targets ([9858c48](https://github.com/vladdoster/dotfiles/commit/9858c48da1786b51ec774817dcb5f3571c6a554d))
* git status (alt-s) & diff (alt-d) zle widgets ([31c9b6c](https://github.com/vladdoster/dotfiles/commit/31c9b6c3177f039dac825d38238c1c7b952a2e2e))
* load prog completion via load_completion cmd ([77338f6](https://github.com/vladdoster/dotfiles/commit/77338f663ccc7719c57d4a2957e538054490d5c7))
* vim buffer navigation keymap & add/rm plugin ([16fa469](https://github.com/vladdoster/dotfiles/commit/16fa4695a17c7e60b8339d8921ceae0bd6a0325d))

## [4.6.24](https://github.com/vladdoster/dotfiles/compare/v4.6.23...v4.6.24) (2022-12-06)


### Bug Fixes

* add default-jre pkg to Dockerfile ([ee8d9ef](https://github.com/vladdoster/dotfiles/commit/ee8d9ef6061afcc78dbd40ab73c512a887fe8311))

## [4.6.23](https://github.com/vladdoster/dotfiles/compare/v4.6.22...v4.6.23) (2022-12-06)


### Bug Fixes

* rm gem & add ruby pkg to Dockerfile ([0bb8e97](https://github.com/vladdoster/dotfiles/commit/0bb8e9738b5441cce95ed9ad250b12a7f13d1298))

## [4.6.22](https://github.com/vladdoster/dotfiles/compare/v4.6.21...v4.6.22) (2022-12-06)


### Bug Fixes

* add gem pkg to Dockerfile ([4b972f3](https://github.com/vladdoster/dotfiles/commit/4b972f3358e78f3c6f568b02959ba393877bb26c))

## [4.6.21](https://github.com/vladdoster/dotfiles/compare/v4.6.20...v4.6.21) (2022-12-06)


### Bug Fixes

* use latest tag in docker-shell Make target ([325bd3b](https://github.com/vladdoster/dotfiles/commit/325bd3b2ca2026ea0c7bc7d07387e9955a3cd21a))

## [4.6.20](https://github.com/vladdoster/dotfiles/compare/v4.6.19...v4.6.20) (2022-12-06)


### Bug Fixes

* create paths brace expansion in zprofile ([9407a85](https://github.com/vladdoster/dotfiles/commit/9407a85e38e208d224a5b7bbb518b2757c7b9454))

## [4.6.19](https://github.com/vladdoster/dotfiles/compare/v4.6.18...v4.6.19) (2022-12-05)


### Bug Fixes

* add init-buildx artifact to .gitignore ([0ba0d88](https://github.com/vladdoster/dotfiles/commit/0ba0d88796586b6a3bc6905649d3301a220c17de))
* rm docker buildx flag for Dockerfile backward compatability ([51c31c1](https://github.com/vladdoster/dotfiles/commit/51c31c14e7bfe2905c3552d2c1a9841ed4322341))

## [4.6.18](https://github.com/vladdoster/dotfiles/compare/v4.6.17...v4.6.18) (2022-12-05)


### Bug Fixes

* add ripgrep & fzf to Dockerfile ([c22008b](https://github.com/vladdoster/dotfiles/commit/c22008bb9605c046053ecdb8226164bbadddfbf7))
* install stable neovim version in zinit ([a8a8571](https://github.com/vladdoster/dotfiles/commit/a8a8571b77dfb21c7d9c58e4cae7a8372ca369aa))

## [4.6.17](https://github.com/vladdoster/dotfiles/compare/v4.6.16...v4.6.17) (2022-12-05)


### Bug Fixes

* chown $USER home dir as root ([23bbdf5](https://github.com/vladdoster/dotfiles/commit/23bbdf564ef45b51cc088da3f94f9b2989f0f6c2))

## [4.6.16](https://github.com/vladdoster/dotfiles/compare/v4.6.15...v4.6.16) (2022-12-05)


### Bug Fixes

* add apt pkgs to Dockerfile ([b96d148](https://github.com/vladdoster/dotfiles/commit/b96d148eac985b35ce50b5ff51b70c42247427f5))

## [4.6.15](https://github.com/vladdoster/dotfiles/compare/v4.6.14...v4.6.15) (2022-12-05)


### Bug Fixes

* rm buildx flags in Docker Make targets ([c64a928](https://github.com/vladdoster/dotfiles/commit/c64a928bbaf920d1702dd35be893f72a2dbc72b4))

## [4.6.14](https://github.com/vladdoster/dotfiles/compare/v4.6.13...v4.6.14) (2022-12-05)


### Bug Fixes

* install deps via apt instead of Brew ([1c6b6af](https://github.com/vladdoster/dotfiles/commit/1c6b6af539921a7eed623f1dcc1690fa603d5d3c))
* only build linux/amd64 docker image ([def74f8](https://github.com/vladdoster/dotfiles/commit/def74f862121a60f95b1d453949f56f73cafda9e))

## [4.6.13](https://github.com/vladdoster/dotfiles/compare/v4.6.12...v4.6.13) (2022-12-05)


### Bug Fixes

* remove HOMEBREW_INSTALL_FROM_API env var ([7f7e718](https://github.com/vladdoster/dotfiles/commit/7f7e71820fc9af093b757920dbf0f44d0153fb89))

## [4.6.12](https://github.com/vladdoster/dotfiles/compare/v4.6.11...v4.6.12) (2022-12-05)


### Bug Fixes

* base image ubuntu 22.04 to debian:stabe-slim ([83d7872](https://github.com/vladdoster/dotfiles/commit/83d7872b1578122845feb0f26b321e10198e69cc))

## [4.6.11](https://github.com/vladdoster/dotfiles/compare/v4.6.10...v4.6.11) (2022-12-05)


### Bug Fixes

* change base image ubuntu 22.04 to 20.04 ([e2b6a35](https://github.com/vladdoster/dotfiles/commit/e2b6a35e50057a57c2919de8ea991db6eca1d989))

## [4.6.10](https://github.com/vladdoster/dotfiles/compare/v4.6.9...v4.6.10) (2022-12-05)


### Bug Fixes

* run chown as sudo in Dockerfile ([ad2299c](https://github.com/vladdoster/dotfiles/commit/ad2299c64739feaf4a29ec19e0067a8900291893))

## [4.6.9](https://github.com/vladdoster/dotfiles/compare/v4.6.8...v4.6.9) (2022-12-05)


### Bug Fixes

* move homebrew env vars to avoid breaking cache ([43e83c6](https://github.com/vladdoster/dotfiles/commit/43e83c6e816dccfd4aa83e40b473d8eba63b7a84))

## [4.6.8](https://github.com/vladdoster/dotfiles/compare/v4.6.7...v4.6.8) (2022-12-05)


### Bug Fixes

* set BREW_PREFIX ~/.linuxbrew in dockerfile ([da3651d](https://github.com/vladdoster/dotfiles/commit/da3651d9b2cd18f689097a82209ecd451e3043ca))

## [4.6.7](https://github.com/vladdoster/dotfiles/compare/v4.6.6...v4.6.7) (2022-12-05)


### Bug Fixes

* set HOMEBREW_INSTALL_FROM_API in dockerfile ([cf74b19](https://github.com/vladdoster/dotfiles/commit/cf74b19a536ba030058f32bf0f8175534ffe6790))

## [4.6.6](https://github.com/vladdoster/dotfiles/compare/v4.6.5...v4.6.6) (2022-12-05)


### Bug Fixes

* homebrew install in dockerfile ([6cffe46](https://github.com/vladdoster/dotfiles/commit/6cffe46d754b072775615cebd4f7a5557f64589a))

## [4.6.5](https://github.com/vladdoster/dotfiles/compare/v4.6.4...v4.6.5) (2022-12-05)


### Bug Fixes

* homebrew install in dockerfile ([717c7d4](https://github.com/vladdoster/dotfiles/commit/717c7d4416071b6e4d55e64f8212ee3db3080063))

## [4.6.4](https://github.com/vladdoster/dotfiles/compare/v4.6.3...v4.6.4) (2022-12-05)


### Bug Fixes

* homebrew/core tap install in dockerfile ([6c46a15](https://github.com/vladdoster/dotfiles/commit/6c46a151c96c8162208acc7763b47228bcded67c))

## [4.6.3](https://github.com/vladdoster/dotfiles/compare/v4.6.2...v4.6.3) (2022-12-05)


### Bug Fixes

* docker related Make targets & README.md ([834809f](https://github.com/vladdoster/dotfiles/commit/834809f747d6dc602ea0aba8670384cc607c715e))

## [4.6.2](https://github.com/vladdoster/dotfiles/compare/v4.6.1...v4.6.2) (2022-12-05)


### Bug Fixes

* zsh-completions & history-substring-search ([9879695](https://github.com/vladdoster/dotfiles/commit/9879695183c1f4a8f532135c3a4c71ddc1b87712))

## [4.6.1](https://github.com/vladdoster/dotfiles/compare/v4.6.0...v4.6.1) (2022-12-05)


### Bug Fixes

* append homebrew to $PATH & condense env var ([d10c002](https://github.com/vladdoster/dotfiles/commit/d10c002a6a8687cd3bb699d59865835279a76194))

# [4.6.0](https://github.com/vladdoster/dotfiles/compare/v4.5.0...v4.6.0) (2022-12-04)


### Features

* add tree-sitter binary gh-r ([07f4e07](https://github.com/vladdoster/dotfiles/commit/07f4e0787d062c178fb977cf6305f15529a9374d))
* set CORRECT IGNORE to [_|.]* ([c18aacc](https://github.com/vladdoster/dotfiles/commit/c18aaccb14ebc623dca0b130be6caa0a96b3cf4f))

# [4.5.0](https://github.com/vladdoster/dotfiles/compare/v4.4.7...v4.5.0) (2022-12-04)


### Bug Fixes

* add ~/.local/include to .gitignore ([82c4328](https://github.com/vladdoster/dotfiles/commit/82c43285ae815c63cb9d45220e1e2c2050ee25f7))
* add npm & rm dupes in Brewfile ([b8f2f3e](https://github.com/vladdoster/dotfiles/commit/b8f2f3ea339d38a0feb0115716d56455c360682f))


### Features

* script to easily update license headers ([26d5d72](https://github.com/vladdoster/dotfiles/commit/26d5d7224e9cb7041a4cf2004ea6210eaed42535))

## [4.4.7](https://github.com/vladdoster/dotfiles/compare/v4.4.6...v4.4.7) (2022-12-04)


### Bug Fixes

* add missing backslash in zinit.zsh ([f61191a](https://github.com/vladdoster/dotfiles/commit/f61191a4793389a4e0d5b93d7f6e0615b7984d8b))
* specify amd64 platform in shell Make target ([e93152e](https://github.com/vladdoster/dotfiles/commit/e93152efd24fb0c1c26112076b95428317fec833))


### Reverts

* disable neovim install via zinit ([c3f437e](https://github.com/vladdoster/dotfiles/commit/c3f437ef9b95aa25abef4d4d8af84fdcc2a757cd))

## [4.4.6](https://github.com/vladdoster/dotfiles/compare/v4.4.5...v4.4.6) (2022-12-03)


### Bug Fixes

* zinit install error msg & plugin install order ([2debe31](https://github.com/vladdoster/dotfiles/commit/2debe31bca498eea6a6888aaef99e9f71cdedd0b))

## [4.4.5](https://github.com/vladdoster/dotfiles/compare/v4.4.4...v4.4.5) (2022-12-02)


### Bug Fixes

* find-replace handles sed/gsed and hidden dirs ([ec38075](https://github.com/vladdoster/dotfiles/commit/ec380751681743abbd2c6794e060efddceba4bc9))
* find-replace() checks if gsed is installed ([513148c](https://github.com/vladdoster/dotfiles/commit/513148c7958f2294d887e19b123e2097bf230c2c))

## [4.4.4](https://github.com/vladdoster/dotfiles/compare/v4.4.3...v4.4.4) (2022-12-02)


### Bug Fixes

* install lua5.3 & luarocks in Dockerfile ([f438d23](https://github.com/vladdoster/dotfiles/commit/f438d23c432aee7c8be7c36fbd064cbc32c0f7c8))


### Performance Improvements

* compress docker build & add clean Make target ([c678cac](https://github.com/vladdoster/dotfiles/commit/c678cac1fdeabc500e427e4b8f82ca7d887edc45))
* remove cruft programs in Brewfile ([c6e7c14](https://github.com/vladdoster/dotfiles/commit/c6e7c144b5c8401d32e3ebd2444ca650c1d549ed))
* rm cruft && reorder steps order in Dockerfile ([3bcb2af](https://github.com/vladdoster/dotfiles/commit/3bcb2af0190ffd0ff74b9a0451486963113cefdf))

## [4.4.3](https://github.com/vladdoster/dotfiles/compare/v4.4.2...v4.4.3) (2022-12-01)


### Bug Fixes

* mv global .editorconfig to "$HOME" ([6ea10ae](https://github.com/vladdoster/dotfiles/commit/6ea10ae40f93a7ac94c8df177a8514ad772d5049))

## [4.4.2](https://github.com/vladdoster/dotfiles/compare/v4.4.1...v4.4.2) (2022-12-01)


### Bug Fixes

* set TERM env var & zi install cmd ([b3bb239](https://github.com/vladdoster/dotfiles/commit/b3bb2391d7f267fa818a9e65191365d16e368874))
* zinit alias syntax & rm duplicate aliases ([770db09](https://github.com/vladdoster/dotfiles/commit/770db095ba1fe5ce91c57d6bb150b188eaa986ed))


### Performance Improvements

* faster zinit install for zsh-completions ([dfba7cd](https://github.com/vladdoster/dotfiles/commit/dfba7cd2c19a9e6bbc2782d7bb8c2f46c449d1c8))

## [4.4.1](https://github.com/vladdoster/dotfiles/compare/v4.4.0...v4.4.1) (2022-12-01)


### Performance Improvements

* disable global compinit call on Ubuntu ([d4e9443](https://github.com/vladdoster/dotfiles/commit/d4e9443d947f9893190fbd24083780ef7a50a802))

# [4.4.0](https://github.com/vladdoster/dotfiles/compare/v4.3.0...v4.4.0) (2022-12-01)


### Bug Fixes

* install neovim config and rm brew gen-man-comp ([dad3760](https://github.com/vladdoster/dotfiles/commit/dad3760ddcb5d7528f52bb4729ae359e04df1194))


### Features

* alias pretty-path to print paths in $PATH ([1b6e0e7](https://github.com/vladdoster/dotfiles/commit/1b6e0e75afa906a348ed61b1df6f2af7c27f9ea3))


### Performance Improvements

* remove unused scripts in ~/.local/bin/ ([e640122](https://github.com/vladdoster/dotfiles/commit/e64012266422eb85c55ddb855db7c5438b5b1c37))

# [4.3.0](https://github.com/vladdoster/dotfiles/compare/v4.2.0...v4.3.0) (2022-12-01)


### Bug Fixes

* install brew as non-root user in docker env ([d9a27e5](https://github.com/vladdoster/dotfiles/commit/d9a27e5ffd29e08205532624eacef32576874bb1))


### Features

* install Homebrew in docker env ([fccea7f](https://github.com/vladdoster/dotfiles/commit/fccea7fbe9f0b7bc0c3091c7903fe66d3fc07538))


### Performance Improvements

* increase http.postBuffer size in git config ([d27aeea](https://github.com/vladdoster/dotfiles/commit/d27aeeac54dd14367a5ff157df318a0a23b9e5a1))
* set HOMEBREW_INSTALL_FROM_API in Dockerfile ([659a252](https://github.com/vladdoster/dotfiles/commit/659a252ca3e6d6fefcae5d3db09758c0335e2f35))

# [4.2.0](https://github.com/vladdoster/dotfiles/compare/v4.1.4...v4.2.0) (2022-12-01)


### Bug Fixes

* docker container username ([ee902da](https://github.com/vladdoster/dotfiles/commit/ee902da6cde6041b18dc3fd329985516b1caa56f))


### Features

* alias rm-docker to docker system prune --all ([b0fa9a7](https://github.com/vladdoster/dotfiles/commit/b0fa9a760943e1a48d443f0e8150bdd06ccaf179))


### Performance Improvements

* alias "me" to "whoami" command ([617cd92](https://github.com/vladdoster/dotfiles/commit/617cd92c830a677824c3d0da4e38ef0f012ef8d5))

## [4.1.4](https://github.com/vladdoster/dotfiles/compare/v4.1.3...v4.1.4) (2022-11-30)


### Bug Fixes

* docker container volume preserves linuxbrew install ([e58a543](https://github.com/vladdoster/dotfiles/commit/e58a543edd5b35133fdbfc62d707a1568812baae))

## [4.1.3](https://github.com/vladdoster/dotfiles/compare/v4.1.2...v4.1.3) (2022-11-30)


### Bug Fixes

* aliases use single quotes to avoid expansion ([8ee0806](https://github.com/vladdoster/dotfiles/commit/8ee0806245476dda0a5feb79187211d712634e61))


### Performance Improvements

* remove cruft from zinit configuration ([0ae6e6b](https://github.com/vladdoster/dotfiles/commit/0ae6e6bc84ce4daf7fb2c2984dd09c228411f84c))

## [4.1.2](https://github.com/vladdoster/dotfiles/compare/v4.1.1...v4.1.2) (2022-11-22)


### Bug Fixes

* remove bitrot in docker Makefile ([85fd289](https://github.com/vladdoster/dotfiles/commit/85fd28936da2add9caeacb0d0e98a333d0f6f356))
* remove bitrot in zinit config ([5723ad0](https://github.com/vladdoster/dotfiles/commit/5723ad0b42a87977599edc678b56dfc91fb301db))
* remove bitrot in zinit config ([7de426f](https://github.com/vladdoster/dotfiles/commit/7de426f1bdee3ff0516c2254e267a021c904494d))


### Performance Improvements

* improve zinit setup/install speed ([02a26ed](https://github.com/vladdoster/dotfiles/commit/02a26ed0d7da32c0d85cf520adfb2a622f1794f3))

## [4.1.1](https://github.com/vladdoster/dotfiles/compare/v4.1.0...v4.1.1) (2022-11-20)


### Bug Fixes

* branch names for lint workflow triggers ([207278d](https://github.com/vladdoster/dotfiles/commit/207278d243b156607362e60fa76703d6af732526))
* json syntax in release config ([b29cd22](https://github.com/vladdoster/dotfiles/commit/b29cd22e100969fe3bba677cf99795f1416ca832))
* single quote zinit aliases ([b27443e](https://github.com/vladdoster/dotfiles/commit/b27443ebf4984cea92f8a9a6f7d338e013296d72))
* stow ignores .zcompdump ([fc57655](https://github.com/vladdoster/dotfiles/commit/fc576553fdeac3111c7c4ed5a4aaf4b814ad5d9b))

# [4.1.0](https://github.com/vladdoster/dotfiles/compare/v4.0.1...v4.1.0) (2022-11-07)


### ci

* add weekly-digest report ([e403916](https://github.com/vladdoster/dotfiles/commit/e403916e5f0e192d97593d69355f41b408c61ee6))

### feat

* release will publish new docker image to ghcr ([3c7079b](https://github.com/vladdoster/dotfiles/commit/3c7079b0ef89fbfbf1069a60661ece12e85ec436))

### maint

* pause building new docker image per release ([08398bd](https://github.com/vladdoster/dotfiles/commit/08398bdac42ee36cb470b48cb66df346aa587d15))

### release

* v4.0.1 → v4.1.0 ([20692d7](https://github.com/vladdoster/dotfiles/commit/20692d7b077049e23dc6ea7873e0f4ec52666e24))

### revert

* "release: v4.0.1 → v4.1.0" ([f6f55ed](https://github.com/vladdoster/dotfiles/commit/f6f55ed43c4c24e7a79acb65d51fa51365c7276a))

## [4.0.1](https://github.com/vladdoster/dotfiles/compare/v4.0.0...v4.0.1) (2022-11-06)


### fix

* specify python3 in py-install Make target ([1d6e906](https://github.com/vladdoster/dotfiles/commit/1d6e906f23c86d620acbf7f92120b4011c23b3d0))

# [4.0.0](https://github.com/vladdoster/dotfiles/compare/v3.0.3...v4.0.0) (2022-11-06)


### feat

* Build mult-arch Docker images ([eefdd2c](https://github.com/vladdoster/dotfiles/commit/eefdd2c58f89a7dd656eaee2535fd7d2bd3d0c01))

### fix

* kitty fonts and misc. options ([83d3873](https://github.com/vladdoster/dotfiles/commit/83d3873145f7485319b2ec345ae4ae707edfee6d))

### refactor

* Makefile improvements ([ed1d40d](https://github.com/vladdoster/dotfiles/commit/ed1d40d2248f5f531aa8612b1ae2516b6458d6f8))

## [3.0.3](https://github.com/vladdoster/dotfiles/compare/v3.0.2...v3.0.3) (2022-11-02)


### fix

* logger colors and logic ([5e8c1ef](https://github.com/vladdoster/dotfiles/commit/5e8c1effcbf9a24a918c9285ede07fbc0b456f21))

### maint

* add .zprofile & fix zr{ld,eset} aliases ([1c218ed](https://github.com/vladdoster/dotfiles/commit/1c218ed576db41d1c7d1bd5dd48785737d049ffb))
* cleanup .gitignore cruft ([f2ebc36](https://github.com/vladdoster/dotfiles/commit/f2ebc36f6ad99377e8413065f7d719ab0ae32f29))
* do not expire git credentials ([dbffeab](https://github.com/vladdoster/dotfiles/commit/dbffeab150ee2ec0a6b494bbeb089b36599aef15))
* improve logic for setting locale ([5358acf](https://github.com/vladdoster/dotfiles/commit/5358acfe96e536b1f0f1a37ac653d3c70ac76ca3))

## [3.0.2](https://github.com/vladdoster/dotfiles/compare/v3.0.1...v3.0.2) (2022-11-02)


### fix

* zinit installation logic ([532a34a](https://github.com/vladdoster/dotfiles/commit/532a34a1b0180fa647584078341e1751695de6d5))

## [3.0.1](https://github.com/vladdoster/dotfiles/compare/v3.0.0...v3.0.1) (2022-11-02)


### fix

* add --noplugin flag when checking nvim binary ([8e519b5](https://github.com/vladdoster/dotfiles/commit/8e519b5444f28089cbcda1e3f3e511e2f49763ab))
* new window flags for kitty keymap ([105e9de](https://github.com/vladdoster/dotfiles/commit/105e9deb21e51e195fc5921a8ea1715e115bacc9))
* zinit cloning logic ([c47045f](https://github.com/vladdoster/dotfiles/commit/c47045f385b163fe95c5a1ecfd187c00232dd42c))

### maint

* path helper functions ([89e5cfe](https://github.com/vladdoster/dotfiles/commit/89e5cfefc6ad622700b079646c4ad403bdb27515))

# [3.0.0](https://github.com/vladdoster/dotfiles/compare/v2.3.1...v3.0.0) (2022-11-01)


### fix

* add dotfiles deps to install via apt ([42a066b](https://github.com/vladdoster/dotfiles/commit/42a066bc1ceb99cf9d310bf2d24ee2860ce799d7))
* correct Make target names ([57c3d55](https://github.com/vladdoster/dotfiles/commit/57c3d55156a92e5884bc52863dedcf8bb150164b))
* indentation && quoting of zsh variable ([fa03799](https://github.com/vladdoster/dotfiles/commit/fa03799bf2360234c84a80dcf2588f7be7128e73))

### maint

* +x alias for chmod +x ([ce84f2f](https://github.com/vladdoster/dotfiles/commit/ce84f2f55270aec451d2854afc89b59c61a0362a))
* install automake via apt ([3b9f025](https://github.com/vladdoster/dotfiles/commit/3b9f02538a7bb1bbfca94893be697a612ce4fb6d))
* make Make target stow PHONY ([0244a75](https://github.com/vladdoster/dotfiles/commit/0244a75633dcafb4a961442dbf590004deb7f885))
* remove zenv plugin && specify neovim nightly ([36f9df9](https://github.com/vladdoster/dotfiles/commit/36f9df92bd753ffad6625287ac8d357f21ed435a))
* resolve zinit.zsh conflicts ([f04c079](https://github.com/vladdoster/dotfiles/commit/f04c0798f16b977f3c2ce11a7a03f8223ed9d55e))
* tweak yabai window border width ([5d8a651](https://github.com/vladdoster/dotfiles/commit/5d8a651e6b6c9126e649c36ebc7d48121dc0da4a))

### refactor

* reduce duplicate code for easy grokking ([ed9911e](https://github.com/vladdoster/dotfiles/commit/ed9911ee185ce078eccb86f08e154974eb2e5e79))

### style

* tweak kitty colorscheme values ([cc98c71](https://github.com/vladdoster/dotfiles/commit/cc98c71380d89588ee1554dd8125ff778367db10))

## [2.3.1](https://github.com/vladdoster/dotfiles/compare/v2.3.0...v2.3.1) (2022-10-15)


### fix

* kitty utilizes built-in macOS fullscreen ([bf43d0d](https://github.com/vladdoster/dotfiles/commit/bf43d0d70ff717dab271459e80f3e0545c5a2953))
* Makefile target names && GNU stow install target ([e72e9ff](https://github.com/vladdoster/dotfiles/commit/e72e9ff2bdf987ddb0eee56c41b6e8f7be19143f))

# [2.3.0](https://github.com/vladdoster/dotfiles/compare/v2.2.2...v2.3.0) (2022-10-14)


### feat

* redo zinit zsh completion ([0ba4601](https://github.com/vladdoster/dotfiles/commit/0ba4601e504d656379313254f4d1fb1364b8c84e))

### maint

* clean up vimrc ([856b1f1](https://github.com/vladdoster/dotfiles/commit/856b1f170694a0213b363e6bb713f29bab91b0bf))
* re-add function notation to widgets ([4dcbe4a](https://github.com/vladdoster/dotfiles/commit/4dcbe4ab112f2ff1ef6134a071f207c4d22d3da8))

## [2.2.2](https://github.com/vladdoster/dotfiles/compare/v2.2.1...v2.2.2) (2022-10-07)


### fix

* open new kitty window in current working dir ([ab823e2](https://github.com/vladdoster/dotfiles/commit/ab823e27534981c26ad722b4623145d4a2dd2dc1))

### maint

* aliases use EDITOR instead of hardcoded vari ([65682b7](https://github.com/vladdoster/dotfiles/commit/65682b72c0ec96fdeed71ee7259eeb58821880cc))
* set EDITOR based on if neovim is available ([5875f8b](https://github.com/vladdoster/dotfiles/commit/5875f8bc6265aec940cc61a018d8c202d5a1133f))
* tweak kitty window border style ([4ba7bee](https://github.com/vladdoster/dotfiles/commit/4ba7bee6232b63e4151bf15993a63f82c3e69434))

## [2.2.1](https://github.com/vladdoster/dotfiles/compare/v2.2.0...v2.2.1) (2022-10-07)


### fix

* check correct path to zprofile check ([0f143f6](https://github.com/vladdoster/dotfiles/commit/0f143f617c0bf220371d1c201d45f45dc5f5fabc))

### maint

* delete nord.conf kitty colorscheme ([89356b4](https://github.com/vladdoster/dotfiles/commit/89356b4387be8eb8e0175ef284c3d68c02a29dbd))
* fix kitty shortcuts ([b4ba260](https://github.com/vladdoster/dotfiles/commit/b4ba2609fd797a7fdd8ebc045baa92fdb5fdb4b7))
* remove duplicate OMZ plugins ([6cabf88](https://github.com/vladdoster/dotfiles/commit/6cabf88d89865b129bda7b1dea83d61f87b47346))

# [2.2.0](https://github.com/vladdoster/dotfiles/compare/v2.1.0...v2.2.0) (2022-10-07)


### feat

* add zsh precmd to fix broken term output ([dbc9614](https://github.com/vladdoster/dotfiles/commit/dbc9614bc44b60ab8afdf9fa5f356330ed35cb82))
* use new yabai 5.0.0 options ([735f54b](https://github.com/vladdoster/dotfiles/commit/735f54b206c37b6871173996eacb6a763a623d18))

### fix

* set rehash completion zstyle ([75f93ab](https://github.com/vladdoster/dotfiles/commit/75f93ab12f612ed2d53e4867dfcf53c9280590f5))

### maint

* add bdfr and best-of to py-prog Make target ([8a5787f](https://github.com/vladdoster/dotfiles/commit/8a5787f6251acce505bf90d4318a809db973ee69))
* update htop configuration ([8feea84](https://github.com/vladdoster/dotfiles/commit/8feea842e1f974df51678ca68b792d4ebd341c75))

# [2.1.0](https://github.com/vladdoster/dotfiles/compare/v2.0.1...v2.1.0) (2022-10-05)


### feat

* add zprofile to ensure the env is defined ([7dc0007](https://github.com/vladdoster/dotfiles/commit/7dc000794644127b8ecc51bbaa48f9ff78d97268))

### maint

* add vim mode lines, rm cruft, misc. fixes ([f362222](https://github.com/vladdoster/dotfiles/commit/f362222a6bf070703ba93447b8f7cb57bee312a6))
* adjust tab fade for kitty ([d393ad6](https://github.com/vladdoster/dotfiles/commit/d393ad6f607b2cf67b3c5a2c6e17930323c35acb))

## [2.0.1](https://github.com/vladdoster/dotfiles/compare/v2.0.0...v2.0.1) (2022-10-04)


### fix

* open URLs on click and text selection in Kitty ([524efc0](https://github.com/vladdoster/dotfiles/commit/524efc06c75ef48c1b67436b5ba608b4886980dd))

### maint

* add FireCode and Victor fonts to Brewwfile ([35a67f7](https://github.com/vladdoster/dotfiles/commit/35a67f746e8f7206eb55f25e6349405cbbed322e))

# [2.0.0](https://github.com/vladdoster/dotfiles/compare/v1.47.4...v2.0.0) (2022-10-04)


### refactor

* kitty config overhaul ([c7d9625](https://github.com/vladdoster/dotfiles/commit/c7d9625cf2cb02c184e9edadc05bf15eaa0c3f55))

## [1.47.4](https://github.com/vladdoster/dotfiles/compare/v1.47.3...v1.47.4) (2022-10-04)


### fix

* prepend BREW path to $PATH & update log msg ([4ef1bf0](https://github.com/vladdoster/dotfiles/commit/4ef1bf0a825aae3bf51d80cfe497193cff49416d))

## [1.47.3](https://github.com/vladdoster/dotfiles/compare/v1.47.2...v1.47.3) (2022-10-04)


### fix

* prepend paths to $PATH ([e40efc5](https://github.com/vladdoster/dotfiles/commit/e40efc59783347425cb9b4d2b93f3fc2e26f6081))

### maint

* add homebrew sbin to $PATH ([75ffe75](https://github.com/vladdoster/dotfiles/commit/75ffe7560a068ac8e71e3157131cc4f5ad9df8eb))

## [1.47.2](https://github.com/vladdoster/dotfiles/compare/v1.47.1...v1.47.2) (2022-10-04)


### maint

* add --autostash to git pull alias and sort aliases ([e5e3e9a](https://github.com/vladdoster/dotfiles/commit/e5e3e9af9c31803c5a2d9cfe992ca4e564ad6ca3))

## [1.47.1](https://github.com/vladdoster/dotfiles/compare/v1.47.0...v1.47.1) (2022-10-04)


### maint

* improve cohesion of logging function ([7e40322](https://github.com/vladdoster/dotfiles/commit/7e40322a5fa74c4b27745314b236ef20eab5c489))

# [1.47.0](https://github.com/vladdoster/dotfiles/compare/v1.46.1...v1.47.0) (2022-10-04)


### feat

* add edit-function & find-replace functions ([0a38e6f](https://github.com/vladdoster/dotfiles/commit/0a38e6f8f09e2c14dc72f4faeb11a50288f9630d))
* add pritty-env function ([62b6012](https://github.com/vladdoster/dotfiles/commit/62b60128785ba0bebf01e0a98e3310b67cb6415c))

### maint

* clean up zshrc cruft ([f2d1e71](https://github.com/vladdoster/dotfiles/commit/f2d1e7121150d13f7a7f7b57174f1c7169e0cc84))
* condense exports and update log colors ([f741312](https://github.com/vladdoster/dotfiles/commit/f741312bdd7557801ba249745708272fac18f46a))
* update log colors ([f7e28f7](https://github.com/vladdoster/dotfiles/commit/f7e28f7193be439702aad787b6f80aaa65e79a92))

## [1.46.1](https://github.com/vladdoster/dotfiles/compare/v1.46.0...v1.46.1) (2022-10-03)


### maint

* fix script addition loading order in yabai ([cbd5e9d](https://github.com/vladdoster/dotfiles/commit/cbd5e9dfbc88eaa463c4beaf8ed87e3ff556d269))

# [1.46.0](https://github.com/vladdoster/dotfiles/compare/v1.45.0...v1.46.0) (2022-10-01)


### feat

* Make target to install safari ext via mas-cli ([974e100](https://github.com/vladdoster/dotfiles/commit/974e100923d7ed33a214f09ddf4fa3d9cdeb1422))

### fix

* quoting for possible Homebrew location ([5b567c8](https://github.com/vladdoster/dotfiles/commit/5b567c8106085ccbb5e3eccf3ead6df032f40936))

### maint

* add mkcmd & mk* cmds opens file in editor ([40d0008](https://github.com/vladdoster/dotfiles/commit/40d00088e63fa11292871ca2850ef3f414a60973))
* add nvim state dir to gitignore ([3df58d7](https://github.com/vladdoster/dotfiles/commit/3df58d7c6bb4685211b5924a390dcfc2f3816a8e))
* chmod 775 & add vim modeline to zsh files ([a8f47e2](https://github.com/vladdoster/dotfiles/commit/a8f47e267c6f92cbb0c2bf24d4a61fe1fe30b6f2))
* rm sys.sh & rename osx setup script ([862a567](https://github.com/vladdoster/dotfiles/commit/862a567b41c7b329e01066b9388d12e9b72acb84))
* un-comment neovim nightly zinit install cmd ([d72c9d4](https://github.com/vladdoster/dotfiles/commit/d72c9d4df9a34f562ea10d04148518be31feddff))
* update Dockerfile logic ([225d454](https://github.com/vladdoster/dotfiles/commit/225d454e6772186a0f4499ecd6abdb93370f25f0))
* update Makefile logic ([a9ab655](https://github.com/vladdoster/dotfiles/commit/a9ab655c9d9c53898ee1b9f26cea0ebd55efe0b4))
* update permissions and zsh files ([e2f2838](https://github.com/vladdoster/dotfiles/commit/e2f28380219709008c27e363851f5d3bc8b3bbed))
* update stow to ignore ~/.local/s{hare,tate} ([1b6b7ad](https://github.com/vladdoster/dotfiles/commit/1b6b7ad750df496a39126630d9f18fa073156337))

# [1.45.0](https://github.com/vladdoster/dotfiles/compare/v1.44.2...v1.45.0) (2022-09-11)


### feat

* add dependabot configuration ([59a1186](https://github.com/vladdoster/dotfiles/commit/59a1186484c8ed7e5e92986669e4acbaa4e7f003))

## [1.44.2](https://github.com/vladdoster/dotfiles/compare/v1.44.1...v1.44.2) (2022-09-09)


### fix

* only delete plugins/packer_compiled.lua ([10b0ef7](https://github.com/vladdoster/dotfiles/commit/10b0ef7a7d56257b4bc79bbdeccf10b52832722c))
* vimrc works without warnings ([8373091](https://github.com/vladdoster/dotfiles/commit/83730914e0634e6a99898d60380dbdf2dd4ea551))

### maint

* remove vim alias to neovim ([4a24afd](https://github.com/vladdoster/dotfiles/commit/4a24afd8879b13da5df9ab7c980d71b4c7d608d4))
* update docker related Make targets ([7df62e8](https://github.com/vladdoster/dotfiles/commit/7df62e8516ee56dde434a6faa2c8c0292c14cd5a))
* update Dockerfile ([5b5cb92](https://github.com/vladdoster/dotfiles/commit/5b5cb922f424dcf7d31e6c936507a2972305c1d2))
* vimrc yak shaving ([ada0982](https://github.com/vladdoster/dotfiles/commit/ada09826e72e95ea2ca9f52dad72a8b79f8a8911))

## [1.44.1](https://github.com/vladdoster/dotfiles/compare/v1.44.0...v1.44.1) (2022-09-06)


### fix

* `_accept-line-with-url` widget ([06466e2](https://github.com/vladdoster/dotfiles/commit/06466e23f64fbefe56f56e45210c2c51b4ec8e8a))
* OMZL config for history searching ([4cca437](https://github.com/vladdoster/dotfiles/commit/4cca437d705ad928ef9e1f8ccced9266c11d619a))

### maint

* remove executable bit from zsh config files ([93580c1](https://github.com/vladdoster/dotfiles/commit/93580c1211f9f4b48eb04d80c82bdf781e888ddd))
* update `htop` config ([1dd2550](https://github.com/vladdoster/dotfiles/commit/1dd255066344421ecf971f208980cfb1d576b72d))
* update git zsh completion ([1bcbed6](https://github.com/vladdoster/dotfiles/commit/1bcbed6476652fa63fb738554a306fc8649bf6d9))

# [1.44.0](https://github.com/vladdoster/dotfiles/compare/v1.43.2...v1.44.0) (2022-09-06)


### feat

* automatically clone if git URL zsh widget ([2dc68b7](https://github.com/vladdoster/dotfiles/commit/2dc68b7a3a2b7c51a5d45c78d4d43233913c1d4e))

### fix

* font settings in kitty.conf ([18d0162](https://github.com/vladdoster/dotfiles/commit/18d01621a8492d9524e9168818eba7d773ebe1e4))

### maint

* add widget.zsh to files for sourcing ([37a231c](https://github.com/vladdoster/dotfiles/commit/37a231c7b41103bfa6801f50dc164a989a5cc850))

## [1.43.2](https://github.com/vladdoster/dotfiles/compare/v1.43.1...v1.43.2) (2022-09-06)


### fix

* zsh reload script ([89a01b5](https://github.com/vladdoster/dotfiles/commit/89a01b5cbaca8d968bd11ae3263b93adadb4457c))

## [1.43.1](https://github.com/vladdoster/dotfiles/compare/v1.43.0...v1.43.1) (2022-09-06)


### maint

* change release type prefixes ([52a2619](https://github.com/vladdoster/dotfiles/commit/52a261927d25c208ff6ed7af93abc3ef11f78c7e))

# [1.43.0](https://github.com/vladdoster/dotfiles/compare/v1.42.0...v1.43.0) (2022-09-06)


### feat

* add shell reload script ([481c3f0](https://github.com/vladdoster/dotfiles/commit/481c3f09822c30d39e52979702007ad8bf20b1fc))

### maint

* zsh configuration ([67fdd4a](https://github.com/vladdoster/dotfiles/commit/67fdd4a593f8d075a9e7bb0344581df89249bba4))

# [1.42.0](https://github.com/vladdoster/dotfiles/compare/v1.41.0...v1.42.0) (2022-08-31)


### feat

* add global luaformatter configuration ([0a0d077](https://github.com/vladdoster/dotfiles/commit/0a0d077e8b6005b4e7b4af71c9b545eda36fa80c))

### maint

* add release triggers `style` & `maint` ([defe9ec](https://github.com/vladdoster/dotfiles/commit/defe9ecb93123b925f53ac77a8a49844e312a01a))
* misc. zsh, kitty, git config updates ([26a861b](https://github.com/vladdoster/dotfiles/commit/26a861b10f4ffe5ba249190be51fa89736749bdb))
* remove ssh config ([0c88678](https://github.com/vladdoster/dotfiles/commit/0c8867819a049f3a2b2a8e87f5ebff2372a82129))
* update xdg dir aliases & zshenv ([d71de04](https://github.com/vladdoster/dotfiles/commit/d71de0453738e7e3cc026da4f0355cd93f3b10ee))

# [1.41.0](https://github.com/vladdoster/dotfiles/compare/v1.40.0...v1.41.0) (2022-08-14)


### feat

* add ranger configuration ([ee03064](https://github.com/vladdoster/dotfiles/commit/ee03064cc1e4ce4cff16b6d82150e217aaaf083b))

# [1.40.0](https://github.com/vladdoster/dotfiles/compare/v1.39.0...v1.40.0) (2022-08-06)


### fix

* remove alacritty configuration ([5574e51](https://github.com/vladdoster/dotfiles/commit/5574e510e554742af2fd98febd5b5b80f051c3d7))

### maint

* global git ignores zhistory file ([b7b8193](https://github.com/vladdoster/dotfiles/commit/b7b81932ebde4ffc96b21ddbdb4579fc3c2ec09f))

# [1.39.0](https://github.com/vladdoster/dotfiles/compare/v1.38.0...v1.39.0) (2022-08-05)


### fix

* zsh related configurations ([69cb863](https://github.com/vladdoster/dotfiles/commit/69cb863f851bb609c694529fc2183b53af19bb1d))

### maint

* cleaned up nuke-docker logic and printing ([8f2fa83](https://github.com/vladdoster/dotfiles/commit/8f2fa83665c90daac0b6f4ea26469b33c23f68d2))

# [1.38.0](https://github.com/vladdoster/dotfiles/compare/v1.37.0...v1.38.0) (2022-07-30)


### feat

* add Docker dev environment support ([49a17c6](https://github.com/vladdoster/dotfiles/commit/49a17c625d69254087d518ab43ca3721aee047e8))

### fix

* aliases & zinit config bugs ([66e987a](https://github.com/vladdoster/dotfiles/commit/66e987a012d961dc008f3f0af23cc34c2fb732c5))
* improve multiple targets ([fcce534](https://github.com/vladdoster/dotfiles/commit/fcce53493e5a6b56408a03cc20667422cc2ef6ea))
* misc. zsh & zinit config bugs ([8904554](https://github.com/vladdoster/dotfiles/commit/8904554c223bbd0ab47122db5960488d2d57f2df))

# [1.37.0](https://github.com/vladdoster/dotfiles/compare/v1.36.0...v1.37.0) (2022-07-27)


### fix

* various zsh config fixes ([528810e](https://github.com/vladdoster/dotfiles/commit/528810eced3b6ac79e238209b3173817f3983a8e))
* zinit loading logic ([7548de7](https://github.com/vladdoster/dotfiles/commit/7548de7e2baec0f98c59953ef3f46a588c93fd56))

### maint

* add prezto environment and LESS env vars ([b1b9375](https://github.com/vladdoster/dotfiles/commit/b1b9375d175673d65dae2f2509da803a6a933216))
* use prezto completion via submod annex ([795e1a6](https://github.com/vladdoster/dotfiles/commit/795e1a61e7ab1d0692287791ccc841e9eb37a917))

# [1.36.0](https://github.com/vladdoster/dotfiles/compare/v1.35.0...v1.36.0) (2022-07-25)


### fix

* configure ice ([cb24ded](https://github.com/vladdoster/dotfiles/commit/cb24ded5dcdd03409ad1188909a300b7aa186c57))
* nuke-docker output and retry logic ([8db576a](https://github.com/vladdoster/dotfiles/commit/8db576af86f57685e786c19bca706b84f9c2d922))
* remove perl eval ([c89ca8e](https://github.com/vladdoster/dotfiles/commit/c89ca8e1a61f1cf0b84b8da149fed231800d679c))
* retry logic for nuke-docker ([3dbd641](https://github.com/vladdoster/dotfiles/commit/3dbd6410d9efbc3362a817aeecc70c14d143dc7c))
* window border padding fix for vivaldi ([2a5c1cc](https://github.com/vladdoster/dotfiles/commit/2a5c1cc69c65dd8632936269a24281be0f75c339))

### maint

* add rust annex, fix readurl annex branch, and waits ([b184e48](https://github.com/vladdoster/dotfiles/commit/b184e48449d12924fb0208e9ccc521bb240561fe))
* make ice ([4f01bfc](https://github.com/vladdoster/dotfiles/commit/4f01bfc940c748bdef81c11762b7cf1e2e99f9c5))

# [1.35.0](https://github.com/vladdoster/dotfiles/compare/v1.34.0...v1.35.0) (2022-07-22)


### feat

* add system info script ([7494b7d](https://github.com/vladdoster/dotfiles/commit/7494b7dd4a765e463aa54429a391d8ed221a0d35))

### fix

* ssh configuration ([4d9bcee](https://github.com/vladdoster/dotfiles/commit/4d9bcee3f9871114e2eb8edaec3d0f572e98eea0))

# [1.34.0](https://github.com/vladdoster/dotfiles/compare/v1.33.0...v1.34.0) (2022-07-19)


### feat

* add ssh config to improve the ssh experience ([e7973b8](https://github.com/vladdoster/dotfiles/commit/e7973b80b5ef1e17b3383e5bc20e87d59a2c2a05))

### fix

* zinit config issues ([97011ed](https://github.com/vladdoster/dotfiles/commit/97011ed4a2b74a7fc3a645dc6efe9337402106ff))
* zrld and zicln aliases ([d670720](https://github.com/vladdoster/dotfiles/commit/d670720ced0916afd2a1bf9bd4e5543c444e1c4a))
* zsh zstyles ([c7f7288](https://github.com/vladdoster/dotfiles/commit/c7f7288e999b38671d0691111f5489a8bf464cf7))

### style

* formatting ([b04b4ea](https://github.com/vladdoster/dotfiles/commit/b04b4ea7d9b6fef90eabbb8a0d214b2f1ec3f3ca))

# [1.33.0](https://github.com/vladdoster/dotfiles/compare/v1.32.0...v1.33.0) (2022-07-17)


### feat

* add utility functions file util.sh ([7178465](https://github.com/vladdoster/dotfiles/commit/71784657857ba3d18c3b48e2359b32dad8c825bf))

# [1.32.0](https://github.com/vladdoster/dotfiles/compare/v1.31.0...v1.32.0) (2022-07-17)


### feat

* add 'needs-triage' to new issues ([2f3af5e](https://github.com/vladdoster/dotfiles/commit/2f3af5ef2046449d285d2c059300108a568e5920))
* add pull request automation workflow ([964ddb6](https://github.com/vladdoster/dotfiles/commit/964ddb636b2a5d15f26e21387a9124a045b440e5))
* use kitty split layout && format zinit config ([6324464](https://github.com/vladdoster/dotfiles/commit/63244648e8d329fd9b4300b0110d2e3af806ddda))

### fix

* correct label name for issue automation ([a8e9b1b](https://github.com/vladdoster/dotfiles/commit/a8e9b1bfb727bf485f37e554b0d31d27b97eda97))

### maint

* clean up zinit config ([fa31657](https://github.com/vladdoster/dotfiles/commit/fa31657f167e71c7bec973350d6570d0e2f2543b))

# [1.31.0](https://github.com/vladdoster/dotfiles/compare/v1.30.0...v1.31.0) (2022-07-15)


### docs

* update installation guide ([7c44084](https://github.com/vladdoster/dotfiles/commit/7c4408497ab5ebaf78f87ed6f21eeb6b36ebc3e7))
* update Makefile targets & setup steps ([4a8d2cf](https://github.com/vladdoster/dotfiles/commit/4a8d2cf0b8e7471318e604b90bb5f101f01a646c))

### feat

* add history multi word search plugin ([915c89a](https://github.com/vladdoster/dotfiles/commit/915c89aeaa77c10ea69bb92e03d87a19274b9835))
* add zicln and cldf aliases ([8f97fb6](https://github.com/vladdoster/dotfiles/commit/8f97fb69ad8f4b2da7aecd44e231953e4d0b3df4))

### fix

* brew target for install/uninstall ([e60b969](https://github.com/vladdoster/dotfiles/commit/e60b969aa9bb1cc9f5b793f0d0261ed4decf4a12))
* build grep w/ --enable-perl-regexp (i.e., -P) ([d9a92bc](https://github.com/vladdoster/dotfiles/commit/d9a92bc294fdcc475e014ae3937c174bd62ae23f))
* Dockerfile Makefile target calls ([fd06d4d](https://github.com/vladdoster/dotfiles/commit/fd06d4d7f79ee02589629abd24d05eaf2344b538))
* locale variables for Zsh ([d625b16](https://github.com/vladdoster/dotfiles/commit/d625b168ab3281de25b35f0652b35ee896145290))
* remove extra \ at EoL ([75030dc](https://github.com/vladdoster/dotfiles/commit/75030dc010baa7f6d9aee553954cff8279a59dae))
* use grep instead of ggrep to parse versions ([1d63344](https://github.com/vladdoster/dotfiles/commit/1d633440444d672ee9cb1a8fa080dadeb48438be))

### maint

* add mdformat-toc pkg to python/prog target ([798af42](https://github.com/vladdoster/dotfiles/commit/798af426b5369e0b1b859788b3331589dc94515e))
* clean up zsh{rc,env} & add tmux recipe ([3ed7942](https://github.com/vladdoster/dotfiles/commit/3ed7942013883d087953df518b8f96fd8f85bbdd))
* comment out various broken zinit config bits ([3203851](https://github.com/vladdoster/dotfiles/commit/3203851bc184048272033183b20d0bb764dd1d58))
* refactor GNU target to automagically get latest version ([7b4c022](https://github.com/vladdoster/dotfiles/commit/7b4c022d7338e2da06f98cfdc9c901f0bf128737))
* remove shell extenstion from nuke-docker cmd ([b8a51e7](https://github.com/vladdoster/dotfiles/commit/b8a51e790369927c20d841fd630600b3e643c4bf))
* update `stow` make target ([11b95b8](https://github.com/vladdoster/dotfiles/commit/11b95b8a7ce0ce393f8a66565c0b966b18bac5d2))
* update dotfiles Dockerfile && make targets ([410557e](https://github.com/vladdoster/dotfiles/commit/410557e3b83be53a50746478ad0e146fb394b194))

### style

* consistent formatting of bin scripts ([d0f455e](https://github.com/vladdoster/dotfiles/commit/d0f455ee54e80f0247ec2536c959909a6dd7aa01))
* consistent formatting of zinit config ([357a191](https://github.com/vladdoster/dotfiles/commit/357a19155926a9e9cc3e43e82223fca62caa6692))
* consistent formatting of zsh files ([02164a2](https://github.com/vladdoster/dotfiles/commit/02164a2e9e9160fe52ee50e7faa87b957ad58d5d))

# [1.30.0](https://github.com/vladdoster/dotfiles/compare/v1.29.0...v1.30.0) (2022-06-16)


### fix

* revert `v1.3.0` release (#24) ([b823fc3](https://github.com/vladdoster/dotfiles/commit/b823fc3d371f70bf2352cd7b469c8ae3e7a53b41)), closes [#24](https://github.com/vladdoster/dotfiles/issues/24)

### maint

* add checkmake to zinit gh-r to install ([c814311](https://github.com/vladdoster/dotfiles/commit/c814311d7fe269e4c6f1f3d09b915b319b288cd9))
* clean up zsh configuration files ([4bbf3c2](https://github.com/vladdoster/dotfiles/commit/4bbf3c2e805451b4107a5dbe46b6b740ba2d4e1e))
* Make targets consistent name scheme ([9009ca5](https://github.com/vladdoster/dotfiles/commit/9009ca500bc25f8d6acfeaf25ec9071bd9680fc3))
* utlize muli-platform images via buildx ([4745b76](https://github.com/vladdoster/dotfiles/commit/4745b76357eae6de51aeb01629ddf8bedd886828))

### release

* v1.29.0 → v1.30.0 ([f7f04d1](https://github.com/vladdoster/dotfiles/commit/f7f04d181f941703ebfeb2108b1b3a36e52407e3))

# [1.29.0](https://github.com/vladdoster/dotfiles/compare/v1.28.1...v1.29.0) (2022-06-08)


### maint

* fix jq naming and add docker to path ([af80e9b](https://github.com/vladdoster/dotfiles/commit/af80e9bd50cdc2a1cb7bf38a45b7b39f4fd2d488))
* update df Dockerfile, docker Make targets, and nuke-docker.sh ([825c730](https://github.com/vladdoster/dotfiles/commit/825c730295e26d74097fe642e238326a11d74b21))

## [1.28.1](https://github.com/vladdoster/dotfiles/compare/v1.28.0...v1.28.1) (2022-06-04)


### fix

* "zinstall" alias ([4471132](https://github.com/vladdoster/dotfiles/commit/44711321dae9be6d8a3fb69f67cce7af7ee5b09b))
* zshelldoc binary selection and add gh cli binary ([bff906f](https://github.com/vladdoster/dotfiles/commit/bff906f3412da60defdadcb236c8b10120ad067e))

# [1.28.0](https://github.com/vladdoster/dotfiles/compare/v1.27.0...v1.28.0) (2022-06-04)


### feat

* add alacritty terminal configuration ([7a513b4](https://github.com/vladdoster/dotfiles/commit/7a513b47cf04b2fd9ebebcce64908a9b917f9486))

### fix

* bin installer Makefile and dotfiles Makefile ([5ce1e1e](https://github.com/vladdoster/dotfiles/commit/5ce1e1eec136fa550bcfd266068d2f8aecc6bb1b))
* zshelldoc & tree gh-r recipes & "v" alias ([9e783f6](https://github.com/vladdoster/dotfiles/commit/9e783f6fb8a9a6bbeb845db1745b1919ab2fa0cd))

### maint

* add comment boxes to aliases.zsh ([0c0fac6](https://github.com/vladdoster/dotfiles/commit/0c0fac686db53c484ceac0e7a0f78fe28dfd46ed))
* add docker buildx binary ([a17c411](https://github.com/vladdoster/dotfiles/commit/a17c411c8adff744be484f32b3d9c9012ada5422))
* add more zsh options ([3278a3a](https://github.com/vladdoster/dotfiles/commit/3278a3a0704f87252dd685e5f1caaaeb29d9ee60))
* add semver program and format gh-r programs ([e3adde2](https://github.com/vladdoster/dotfiles/commit/e3adde2c54aa8a35b559d6313117bd7ee3eb168f))
* display hostname in tmux statusbar ([29c501c](https://github.com/vladdoster/dotfiles/commit/29c501ce3e7cff24b0a7890f980827433e19690f))
* update bin Makefile install target and installer configure logic ([3dde004](https://github.com/vladdoster/dotfiles/commit/3dde00446d27c33897e585e72fea455a2a33b869))
* update stow install and dotfiles {un,i}nstall targets ([3a89e40](https://github.com/vladdoster/dotfiles/commit/3a89e40d7841af703c88e3e2ad0003cae20f3210))
* update Zsh options to get preferred behavior ([9b087d0](https://github.com/vladdoster/dotfiles/commit/9b087d0675d067b7de5d7486d0fe6eb7ce380df8))

### style

* change section headers to boxes ([15ff0fc](https://github.com/vladdoster/dotfiles/commit/15ff0fc4b9c677e99290a7a1c5e5864ca3f776ed))
* remove trailing whitespace ([6a7aecc](https://github.com/vladdoster/dotfiles/commit/6a7aecc1de136112488eab51d6acef86220ae801))
* switch to patched font BlexMono Nerd Font ([4a6202a](https://github.com/vladdoster/dotfiles/commit/4a6202a94425530145ddc8449a1d8ebbe4e7c0dd))

# [1.27.0](https://github.com/vladdoster/dotfiles/compare/v1.26.0...v1.27.0) (2022-05-29)


### fix

* conflicting ctrl skhd commands ([d765913](https://github.com/vladdoster/dotfiles/commit/d7659135796e6407a735573a8306ec22de7185b5))

### maint

* run pip with --no-compile option ([44ebf99](https://github.com/vladdoster/dotfiles/commit/44ebf99496fd0ddef4068d77cf78d6ce12b6b46b))
* update aliases ([b4796bb](https://github.com/vladdoster/dotfiles/commit/b4796bb5d2658e63a4d51f460c62b261a77d6388))

# [1.26.0](https://github.com/vladdoster/dotfiles/compare/v1.25.0...v1.26.0) (2022-05-24)


### feat

* add `update` Make target ([6c9ac99](https://github.com/vladdoster/dotfiles/commit/6c9ac99298de2b254f3790d1bf186bbc864f7e73))
* add hyper gh-r recipe ([d5f2743](https://github.com/vladdoster/dotfiles/commit/d5f274358b52fb2212ff67c8ce6846a54f482f43))
* clean up skhd configuration ([87de048](https://github.com/vladdoster/dotfiles/commit/87de048b15c97eadf42b9bbbc25b2a57d36d0e0c))
* clean up zinit cfg for lbin updates ([9b85aa7](https://github.com/vladdoster/dotfiles/commit/9b85aa7698136a2bfb7441fe4b074b0cef8082d7))
* test out CodeQL ([651a724](https://github.com/vladdoster/dotfiles/commit/651a724736409ccbe966be7f75e6c88a27050638))
* use 1password-beta to Brewfile ([6ffd3d7](https://github.com/vladdoster/dotfiles/commit/6ffd3d74258efe2a3ccb21016cef07ad3de67bfa))

### fix

* {zshelldoc,tree} lbin & add luarocks completion ([1d8f66f](https://github.com/vladdoster/dotfiles/commit/1d8f66f4a30c1960ea1a2b59acfdd74ad225e152))
* aliases and zinit config ([d94710e](https://github.com/vladdoster/dotfiles/commit/d94710e13dbe484de2fa94dc4343a21385bcf6a8))
* aliases incorrectly quoted ([b625381](https://github.com/vladdoster/dotfiles/commit/b62538183bdb015b73f80625c01ddd49798b9fbd))
* only show targets for make tab completion ([655716b](https://github.com/vladdoster/dotfiles/commit/655716b8197906667c844ce6aca980ba29c434b3))
* semantic-release config path ([be8d1ef](https://github.com/vladdoster/dotfiles/commit/be8d1ef5de80caeadae31d3532efe3f7654c5766))
* swap OS filter logic to generic first and specific last ([368b1c2](https://github.com/vladdoster/dotfiles/commit/368b1c26fdd5d2aa1600c5fbf72f247aa1b33a64))

### maint

* add back semantic-release config ([bfdc7d3](https://github.com/vladdoster/dotfiles/commit/bfdc7d364942d771ed8598a689c095d40dafe1c9))
* add checkmake gh-r, python38 to path, and sort PHONY targets ([af2e170](https://github.com/vladdoster/dotfiles/commit/af2e170cab48f577ce1e82911c7ce55cc64d062d))
* add stylua gh-r ([4994fd0](https://github.com/vladdoster/dotfiles/commit/4994fd0047d374612b7bfda78ac32ce6d6554fb7))
* condense brew (u)install logic into single target ([b5d7a1b](https://github.com/vladdoster/dotfiles/commit/b5d7a1b39ac17430eb3f4ec9644a2af33ea42884))
* delete .gitmodules due to hammerspoon config now seperate repository ([f13696b](https://github.com/vladdoster/dotfiles/commit/f13696beb5a4208c41bbe788d96fb3b8693ed7e9))
* delete unused .chglog config and template ([942585b](https://github.com/vladdoster/dotfiles/commit/942585b2c1a0e5e73a44c2a619d89a788a350cfc))
* install luarocks from source ([e8e5571](https://github.com/vladdoster/dotfiles/commit/e8e5571db52c479e362986966edfcd61af510e11))
* move .releaserc to .github dir to clean up $HOME ([518e521](https://github.com/vladdoster/dotfiles/commit/518e521eb5a84bfbbaf76c74244471304a67fe22))
* remove CodeQL scan ([99493e6](https://github.com/vladdoster/dotfiles/commit/99493e647095097722e4a18c7bba5e1a3b2f7ec0))
* remove help target and clean up bin Makefile ([a37432e](https://github.com/vladdoster/dotfiles/commit/a37432eea54c8618facf1c66346f42da837adbeb))

### refactor

* goto alias logic condensed ([2a870e4](https://github.com/vladdoster/dotfiles/commit/2a870e46a37b9ffb09a39afd72e3c7fbae5123e3))

### style

* clean up zinit configuration ([79a17eb](https://github.com/vladdoster/dotfiles/commit/79a17eb7d2d00e990143d37438cf8b1fef9e3c9e))
* fmt README.md ([38422a8](https://github.com/vladdoster/dotfiles/commit/38422a82b86fbf6b65988d8e45f984cab0500a6c))
* format gh-r recipes ([814759b](https://github.com/vladdoster/dotfiles/commit/814759bfc0afdf17469aecc5b74d547992f31265))
* format zinit.zsh ([cc44c8b](https://github.com/vladdoster/dotfiles/commit/cc44c8b76c240f7e1fc980f676f03f1ceda5e042))
* format zshrc and fzf.zsh utility functions ([5c9b313](https://github.com/vladdoster/dotfiles/commit/5c9b3139bd7c14946ad13d9f1c57aa9c77de37ce))

# [1.25.0](https://github.com/vladdoster/dotfiles/compare/v1.24.0...v1.25.0) (2022-05-13)


### feat

* add Docker buildx and docker-credential-helpers gh-r recipes ([5d87509](https://github.com/vladdoster/dotfiles/commit/5d87509dcf5704070bd9ef0a94acc75ffc4b4e22))

### fix

* add pkg-config to dotfiles Dockerfile ([6deaae7](https://github.com/vladdoster/dotfiles/commit/6deaae7aff6b7594173563a34c3b82efc2f6e7ed))
* remove git-fzf in favor of fzf helpful functions ([9be6505](https://github.com/vladdoster/dotfiles/commit/9be6505652292432de6724e2c347efdfc52c17a9))

### maint

* clean up skhd configuration ([bfe9972](https://github.com/vladdoster/dotfiles/commit/bfe9972e4e5fd75aa98047eda7f019cd54206d9e))
* delete .deepsource.toml ([ed85bf5](https://github.com/vladdoster/dotfiles/commit/ed85bf567c6f57a044c4a508a1607a6f87c973d7))
* update Docker dotfiles Dockerfile and build/run make targets ([19ddf30](https://github.com/vladdoster/dotfiles/commit/19ddf30121752b9896604c05db811c3a4b8bab4d))

### style

* format aliases.zsh ([01cac60](https://github.com/vladdoster/dotfiles/commit/01cac60a06cdc971ea442ef6fccbf952a1417f46))

# [1.24.0](https://github.com/vladdoster/dotfiles/compare/v1.23.0...v1.24.0) (2022-05-12)


### fix

* correct volume prune cmd from nuke-docker.sh ([c714126](https://github.com/vladdoster/dotfiles/commit/c71412694fb4ed5e43a20318b02b06e1089af388))
* dotfiles Makefile config cloning logic ([0d75f95](https://github.com/vladdoster/dotfiles/commit/0d75f95ff8327e9d93b5b13500466bd42576ff4c))
* exa lbin glob ([312fe63](https://github.com/vladdoster/dotfiles/commit/312fe6354c5d5c502734ae76c8badf7655ac76a8))

### maint

* add xz, file and rm bat from Dockerfile ([d8c94a4](https://github.com/vladdoster/dotfiles/commit/d8c94a46c496d9afeac16dc7697bf305c0c01f8c))
* clean up dotfiles Dockerfile ([5a04813](https://github.com/vladdoster/dotfiles/commit/5a048135568382c51e1fcb92aa9bad5d942644d4))
* delete docker-compose.yml ([85d8ebb](https://github.com/vladdoster/dotfiles/commit/85d8ebbef86b98fe1de078e20df63c893fcc2e89))
* delete tarball-installer.py ([beef34c](https://github.com/vladdoster/dotfiles/commit/beef34c228d428992e5c139f7cd55f184fc33553))
* downgrade docker-compse version from 3.9 -> 3 ([edaef35](https://github.com/vladdoster/dotfiles/commit/edaef35abc1da95a8b34ab55b9eead7a43fb16f5))
* locales and misc. cleanup in Dockerfile ([da72471](https://github.com/vladdoster/dotfiles/commit/da7247191c3970233d71d6a644be448d017a4914))
* silence Skittped CherryPicks warning in git config ([146fa0f](https://github.com/vladdoster/dotfiles/commit/146fa0f095508e7538df0ceeaad8523a76ab28ca))
* update locales configuration in Dockerfile ([8ae8e6b](https://github.com/vladdoster/dotfiles/commit/8ae8e6b2580d8aeab31b51f74a65bb46c084c2fd))
* update volume configuration in Dockerfile and Makefile ([c35cf22](https://github.com/vladdoster/dotfiles/commit/c35cf22dcdd703311c424a8231a5798bcc719157))

### style

* fmt zinit gh-r configuration ([b73e4e9](https://github.com/vladdoster/dotfiles/commit/b73e4e93b4183c164a819d9299d391a293d038fc))

# [1.23.0](https://github.com/vladdoster/dotfiles/compare/v1.22.0...v1.23.0) (2022-05-12)


### docs

* add release CI workflow status badge ([f0dc7c6](https://github.com/vladdoster/dotfiles/commit/f0dc7c6d6e4e6bd6f9fd4536d863ce620754154e))
* update status badge alt names ([067ad88](https://github.com/vladdoster/dotfiles/commit/067ad881255d83e9450b95bb2e9224125fb56376))

### maint

* decrease # of workflows to retain in workflows cleanup job ([5cdb5bb](https://github.com/vladdoster/dotfiles/commit/5cdb5bb6400667fcb1dc359ef32b2ac8a917c817))

# [1.22.0](https://github.com/vladdoster/dotfiles/compare/v1.21.0...v1.22.0) (2022-05-12)


### fix

* break after successful configure command to avoid errors ([2f0e56f](https://github.com/vladdoster/dotfiles/commit/2f0e56f96c7986414c83e7a1c54526b1ce8f583e))
* check if tty via $- and print accordingly ([5895445](https://github.com/vladdoster/dotfiles/commit/58954454f93a39f9ac3b453b481c64a38b90e5c3))
* check if tty via $- and print accordingly ([0b9f09d](https://github.com/vladdoster/dotfiles/commit/0b9f09d06709f7c40884d6898a3893724b4548d3))
* conditional logic for sourcing brew shellenv ([6805d77](https://github.com/vladdoster/dotfiles/commit/6805d77e1cddec42bf89c0041332bbe0b556bbf3))
* stopgap for delta binary until fixed in zinit upstream ([f3cdc97](https://github.com/vladdoster/dotfiles/commit/f3cdc97cbae507dc0ea30d159dd1bd815fef3b58))
* tarball installer cmake conditional logic ([b8310b6](https://github.com/vladdoster/dotfiles/commit/b8310b6a3138ef50735af716742bd2c644c0e8d0))

### maint

* add gpt cli and format zinit.zsh ([9fc3105](https://github.com/vladdoster/dotfiles/commit/9fc31054c3c64f41e2962440498935b59d5e4503))
* change edit-commandline bind-key from ^e to ^v ([981217b](https://github.com/vladdoster/dotfiles/commit/981217b66983c626d08ff13f71fef9eb233d4056))
* create helper function to create aliases and remove redundant code ([879e5f8](https://github.com/vladdoster/dotfiles/commit/879e5f84d13f543c829fc7b7ff5b0c0adce1bad7))
* fix indentation of dotfiles Makefile ([4892374](https://github.com/vladdoster/dotfiles/commit/4892374948d898b9f57e9f4ef74d3278748bba94))
* fix lua URL, remove modeline, format to fix missing seperator ([9d8325e](https://github.com/vladdoster/dotfiles/commit/9d8325e49fa4eef2d14270f2082ab544fce07001))
* update bin Makefile and zinit.zsh ([eeec9fe](https://github.com/vladdoster/dotfiles/commit/eeec9fe6a744ffdfc25f7b0be094fa5123d5f8c3))
* use zsh to call tarball install script ([1c11649](https://github.com/vladdoster/dotfiles/commit/1c11649e40b6b60c0fcc67b5569aa6adcb8d21d6))

# [1.21.0](https://github.com/vladdoster/dotfiles/compare/v1.20.0...v1.21.0) (2022-05-06)


### feat

* check if config exists, update Brewfile, and rm compile from zshrc ([e959623](https://github.com/vladdoster/dotfiles/commit/e95962326f61ca0bb197b1f7064deff8b141b6cf))

### maint

* change gh binaries to use lbin ice ([02ebd81](https://github.com/vladdoster/dotfiles/commit/02ebd8116cb089b676d4e396e2e94442e7746403))
* cleanup zinit.zsh binary and plugin installations ([ad06ed6](https://github.com/vladdoster/dotfiles/commit/ad06ed66d02d10dd2c82f3cdf8878c84bd17fc6a))
* update zunit and revolver recipes ([f074838](https://github.com/vladdoster/dotfiles/commit/f07483828c6ebe9d1c61ee58f7a3fbba1c037f84))

# [1.20.0](https://github.com/vladdoster/dotfiles/compare/v1.19.0...v1.20.0) (2022-05-05)


### maint

* clean up and format zinit.zsh ([3791f42](https://github.com/vladdoster/dotfiles/commit/3791f429cc41d6c03051a415ed5add1c10e2d248))
* new gh workflow && zinit logic ([90b5c3c](https://github.com/vladdoster/dotfiles/commit/90b5c3c01de043c4fb6190d051f62fc4221d68c3))

### refactor

* homebrew activation logic in zshenv ([c3fe834](https://github.com/vladdoster/dotfiles/commit/c3fe834c85ba5a900ed414633d2580486747c682))

# [1.19.0](https://github.com/vladdoster/dotfiles/compare/v1.18.0...v1.19.0) (2022-05-03)


### fix

* remove git artifacts from merge ([c47e7d0](https://github.com/vladdoster/dotfiles/commit/c47e7d0d732d46fe70b601a4717c558df6e098c6))
* which zsh to use ([f9178ae](https://github.com/vladdoster/dotfiles/commit/f9178ae1b094c537a855c63c7063ec21a578a81e))
* zinit initialization ([1b99639](https://github.com/vladdoster/dotfiles/commit/1b9963981e5dde8093b43c03eb76856cbad7f167))

### maint

* add alias to output detailed system info ([4c40a2f](https://github.com/vladdoster/dotfiles/commit/4c40a2f5b9bc1384153fc5327932cb4fffd9aacc))
* add back git-fzf.zsh ([0b6fc01](https://github.com/vladdoster/dotfiles/commit/0b6fc01b22f73f0da5b6c5f2775a7e35238cbc11))
* add back neovim gh-r recipe to zinit.zsh ([57ae185](https://github.com/vladdoster/dotfiles/commit/57ae185c79aa88aec6381f2a1466344b09f74fff))
* add logic to handle 2 cases for linuxbrew ([a363eee](https://github.com/vladdoster/dotfiles/commit/a363eee92cd76d9e7e39e6748003a497077464ed))
* convert all gh-r recipes to use lbin ice ([6c3267d](https://github.com/vladdoster/dotfiles/commit/6c3267d0b29eebdb2a31142912b4d52dc8ec6883))
* remove 1password-{cli,beta} from Brewfile ([9e7c52b](https://github.com/vladdoster/dotfiles/commit/9e7c52b08b6b0817deb3e870abdc38667eb56e1a))
* remove vim fold markers from git config ([8cc350e](https://github.com/vladdoster/dotfiles/commit/8cc350e716586e02a2c61420a66f8b2d52d06d4f))
* stop homebrew autoupdate, fix linuxbrew init, add gh-r recipes, remove git and fzf from zsh init ([364c602](https://github.com/vladdoster/dotfiles/commit/364c6027e78a00cfcd66a3ec5a3d0d6e72ea1807))
* update lbin syntax for testing ([1458249](https://github.com/vladdoster/dotfiles/commit/1458249ff926eddad25773dce6518ef3c8a1918f))
* update tar Makefile, Dockerfile, and zinit configs ([061e13d](https://github.com/vladdoster/dotfiles/commit/061e13da4a226728a0268d7955a4cc01ca49ae86))
* update various zinit.zsh sections ([5add278](https://github.com/vladdoster/dotfiles/commit/5add278e374450d3538e1ab26bc47620ac07b753))

# [1.18.0](https://github.com/vladdoster/dotfiles/compare/v1.17.0...v1.18.0) (2022-04-28)


### feat

* add skhd (keymap daemon) configuration ([ff02fef](https://github.com/vladdoster/dotfiles/commit/ff02feff867942ef957bb6171fad3e81c34d783c))
* zinit, zsh, yabai, and skhd updates ([4fde072](https://github.com/vladdoster/dotfiles/commit/4fde072e6f357d2ef235a52cba4c8edee4628c54))

### fix

* correct misspelled variable ([8e2a1f7](https://github.com/vladdoster/dotfiles/commit/8e2a1f72c7939a14a970f2805ae48dc5d8fe31be))
* git config ([5ba3815](https://github.com/vladdoster/dotfiles/commit/5ba3815ad535f2a288fce2c7c9410592408d8152))
* Makefile formatting ([7525fb1](https://github.com/vladdoster/dotfiles/commit/7525fb1ffc419ef058d7f60646a00cc2aedfe025))
* omz_urlencode not error when using Terminal.app ([363363f](https://github.com/vladdoster/dotfiles/commit/363363fe0b314d0a1007438ccad58b5fe508c2ac))
* remove '.' prefix from skhd config filename ([3edc8ab](https://github.com/vladdoster/dotfiles/commit/3edc8abc6d9c1a3ea91aa9b22997a64491c22950))
* zreset alias crashing terminal ([f24a663](https://github.com/vladdoster/dotfiles/commit/f24a66359868f3cd84023517ff8631356f8edac5))
* zsh install from src and zshenv ([f33a193](https://github.com/vladdoster/dotfiles/commit/f33a1936a44b383789cf5f338311a1628f26056a))

### maint

* change zinit branch ([3de6202](https://github.com/vladdoster/dotfiles/commit/3de62021dc1da8567b44849c96d08c9356e7a85a))
* change zinit branch back to main ([e783a4f](https://github.com/vladdoster/dotfiles/commit/e783a4f3386e5c39f884f817e25b771cef3a7d28))
* clean up Brewfile ([1054bef](https://github.com/vladdoster/dotfiles/commit/1054befac8d4b1d40269c55032635a413faf04ab))
* clean up Makefile ([0507ff8](https://github.com/vladdoster/dotfiles/commit/0507ff84e645ac2e5b914c3a37b4fa85a482c9be))
* clean up unused parts of vimrc ([2633bdf](https://github.com/vladdoster/dotfiles/commit/2633bdf06b7a3b1b7ee648963640c2507f2a4ddf))
* compilation function and clean up zinit sections ([c7bc310](https://github.com/vladdoster/dotfiles/commit/c7bc31000f8e0c92f51836f59dd40977bdf6325c))
* fix misc issues in zsh related configs ([82173ea](https://github.com/vladdoster/dotfiles/commit/82173ea6cad788fc38f4b7efa246c1e7b57fa865))
* fix printing in bin Makefile ([9798dc1](https://github.com/vladdoster/dotfiles/commit/9798dc1e9a604b71d6c38b74b7112dc7d4499640))
* make yabai active window border color to bright red ([ea3ff5a](https://github.com/vladdoster/dotfiles/commit/ea3ff5a99224efec6b44d6366c6f85f8aa547687))
* remove pip ice install ([57eda71](https://github.com/vladdoster/dotfiles/commit/57eda7185cfa7a0fabc4a9d4fbf2c2cfc97c887c))

### style

* add color to logging functions ([abf0a50](https://github.com/vladdoster/dotfiles/commit/abf0a50b01f99525df1ee7820074e9b4d46f4a81))
* condense compiling zsh from source formatting ([2f6e8e3](https://github.com/vladdoster/dotfiles/commit/2f6e8e3feada214bc8781e838af7b6e80f946e21))
* fix folds and pip completion function ([1ee0a82](https://github.com/vladdoster/dotfiles/commit/1ee0a821d97a251247e3136433888350a4f8ae46))
* fmt aliases ([faa323c](https://github.com/vladdoster/dotfiles/commit/faa323c9a2034ea47f507dcfaefbc5be768610cb))
* remove vim folds ([2129887](https://github.com/vladdoster/dotfiles/commit/212988765ea29fecce772ba55403b7b7ddb4d59c))

# [1.17.0](https://github.com/vladdoster/dotfiles/compare/v1.16.0...v1.17.0) (2022-04-19)


### feat

* clone personal repos via `https://vdoster/${REPO_NAME}` ([d62dfc6](https://github.com/vladdoster/dotfiles/commit/d62dfc6acfddcda51ac2207052e98311b9f357d4))

### style

* add vim modeline and fold markers ([ba26119](https://github.com/vladdoster/dotfiles/commit/ba2611992d4539232e9142f134b651753c7c67e3))

# [1.16.0](https://github.com/vladdoster/dotfiles/compare/v1.15.0...v1.16.0) (2022-04-17)


### feat

* add vim script (vim 8) configuration ([ec9b676](https://github.com/vladdoster/dotfiles/commit/ec9b6761f96e69f4fad62edb29b3311a8d04c629))
* add vimrc ([24e95c5](https://github.com/vladdoster/dotfiles/commit/24e95c50d2d3abde79d42e456f25d6692b5b7e58))
* fix zsh related config ([447cac3](https://github.com/vladdoster/dotfiles/commit/447cac37d7d1b9b82f5a0fa5eb97b15c6dc7f008))
* fix zshenv ([505a66f](https://github.com/vladdoster/dotfiles/commit/505a66f2a46d459d9fb2266be117d40fa196dd70))

### fix

* Docker volume permissions && use docker compose ([329631d](https://github.com/vladdoster/dotfiles/commit/329631d23835f3a218ac672bb79de98bfe16a9cf))
* remove zsh cruft ([7b50aef](https://github.com/vladdoster/dotfiles/commit/7b50aef1f3454022a44d1170ba6971a4e0132cea))
* rm duplicate vimrc and clean up zinit.zsh ([2c275d5](https://github.com/vladdoster/dotfiles/commit/2c275d51bd81acf3e9faf874181f5cf6b77df17b))
* use zunit test branch ([3a8732a](https://github.com/vladdoster/dotfiles/commit/3a8732a10c68053945fbb69a65f90b94ca466bc2))

### maint

* add ruby 2.6.8 and fix URL spacing ([087a9df](https://github.com/vladdoster/dotfiles/commit/087a9dfb6480bfdca9600062aaf4f02fd5e8eee3))
* fix ices for zi-programs.zsh ([e474164](https://github.com/vladdoster/dotfiles/commit/e474164e1bdb17b97ba1c93a8514c9eba1382a86))
* make zsh target phony && shfmt source URL ([3c06d46](https://github.com/vladdoster/dotfiles/commit/3c06d46057533c34c8d8f7773b2bf72853d2948c))

### style

* add vim fold markers ([608ca15](https://github.com/vladdoster/dotfiles/commit/608ca156275a511b3d9e05ded4b21d508dd34974))

### update

* add vim fold markers to bin Makefile ([d483436](https://github.com/vladdoster/dotfiles/commit/d48343659a38fd4aaa8fcd13b2fb4c7382092252))
* yabai config fleshed out ([36569b6](https://github.com/vladdoster/dotfiles/commit/36569b62c41b67e9a51b07c5daa0513f0a7962d0))

# [1.15.0](https://github.com/vladdoster/dotfiles/compare/v1.14.0...v1.15.0) (2022-04-04)


### chore

* condense formtting of extract alias ([317f8ce](https://github.com/vladdoster/dotfiles/commit/317f8ce6e0af4f701535c1ac5f597e8e3fe9baf8))
* correct Makefile targets for configurations ([aa2d8df](https://github.com/vladdoster/dotfiles/commit/aa2d8df868e5cc42d15c681a240543c2e4546f18))
* rm hammerspoon config; it has own repo now ([fa36fa2](https://github.com/vladdoster/dotfiles/commit/fa36fa2dac1875b9727bb58d66eb262ab6f26ca1))

### feat

* refactor Makefile to install hs || nvim cfg ([ef5e598](https://github.com/vladdoster/dotfiles/commit/ef5e59856feb122ef90d9c8d5456dba92b15a391))

### fix

* add missing backslash in zinit.zsh ([b884c5c](https://github.com/vladdoster/dotfiles/commit/b884c5c70bc9420104ab4c1e45fc0885e26d9545))
* fix Makefile config targets ([9829b7d](https://github.com/vladdoster/dotfiles/commit/9829b7d9f820ae83b8887b9aedd575b9b80f96da))
* remove you-the-champ.zsh cruft ([e154883](https://github.com/vladdoster/dotfiles/commit/e154883f4f3ad58c89a960a698081ad61663d8a3))

### maint

* add completion for zunit & revolver ([bd75644](https://github.com/vladdoster/dotfiles/commit/bd7564431b85c6dcaac9ff06121926d32c826459))
* add debug section for zsh & add zenith binary ([2889bc2](https://github.com/vladdoster/dotfiles/commit/2889bc2c1f20107f31c0f7374cb90e2f32e5320c))
* add volta-cli to test programs ([153130b](https://github.com/vladdoster/dotfiles/commit/153130b097034ec249b6b5e52683c11b294ad456))
* added revolver artifact dir to gitignore ([12e7722](https://github.com/vladdoster/dotfiles/commit/12e77224241e00276e03fa0b546e33bd0cbd37da))
* change dockerfile base image to ubuntu ([b17c5a0](https://github.com/vladdoster/dotfiles/commit/b17c5a044aa335c1e4726cbfdd058e6bdef186d9))
* clean up zinit.zsh whitespace ([2e140b9](https://github.com/vladdoster/dotfiles/commit/2e140b93524b0da0319cb6468f9c8215ae479d0a))
* increase kitty scrollback speed ([ee877f5](https://github.com/vladdoster/dotfiles/commit/ee877f5bd91ac588198d99bd15a2c304e81656e7))
* minor value tweaks & formatting kitty config ([20f395b](https://github.com/vladdoster/dotfiles/commit/20f395b0780916f3b196efffc211dcb77369395b))
* put zsh-bin ices on newlines ([bc17ff0](https://github.com/vladdoster/dotfiles/commit/bc17ff0ae549a2d73960e1d37d194a5b0c831c89))
* remove logging ([feffde4](https://github.com/vladdoster/dotfiles/commit/feffde4a2a92e0b1d35183fdead3e16bf752371f))
* remove zinit.zsh config cruft ([772fe6d](https://github.com/vladdoster/dotfiles/commit/772fe6d2639cfbf045a1321446d32f74dbce7f80))
* rm git config husky hooks & submodule cruft ([3589d53](https://github.com/vladdoster/dotfiles/commit/3589d539054dc95a3d6b0782bc046307186cadf0))
* use correct branch for zunit tests ([5e55c18](https://github.com/vladdoster/dotfiles/commit/5e55c18a85c90cbd6ad8434207a52bf8215deb60))
* use correct branch for zunit tests ([09efaac](https://github.com/vladdoster/dotfiles/commit/09efaacfb673f1be7abc2d9025418cf66147bb66))
* zsh prompt shows user and host ([dcc9b35](https://github.com/vladdoster/dotfiles/commit/dcc9b3581b9c3091a23cd0d42a1d3fcd6a9491cc))

### refactor

* dotfiles dockerfile ([e2cfca0](https://github.com/vladdoster/dotfiles/commit/e2cfca08f47252d83b43cbc3e91a53127efb3c28))

### style

* clean up misc. fmt Makefile issues ([3dbeead](https://github.com/vladdoster/dotfiles/commit/3dbeead9238c6cb40def9b79554bba5b5e5620c2))
* reorder zinit plugins ([25b5ebf](https://github.com/vladdoster/dotfiles/commit/25b5ebf93288a85f8e53898e6502062b3092dff5))

# [1.14.0](https://github.com/vladdoster/dotfiles/compare/v1.13.1...v1.14.0) (2022-03-24)


### build

* add `feat` & `maint` release rules ([d782ce1](https://github.com/vladdoster/dotfiles/commit/d782ce15262f0d67d2b9eab46c9d2d9703fcf39c))

### feat

* hs modules battery, sys stats, new spoons ([8bf1de4](https://github.com/vladdoster/dotfiles/commit/8bf1de4d1c62b50f47b9989a533c95c833da0cdd))

## [1.13.1](https://github.com/vladdoster/dotfiles/compare/v1.13.0...v1.13.1) (2022-03-21)


### chore

* remove git config cruft ([bd2629a](https://github.com/vladdoster/dotfiles/commit/bd2629a426caee5f7d3e270c2fbd4dd747193b68))
* remove homebrew env variables from zshenv ([9ab5939](https://github.com/vladdoster/dotfiles/commit/9ab593910bed005be07905111145f22ca2bb8243))

### style

* format Makefile ([e622580](https://github.com/vladdoster/dotfiles/commit/e6225803dddb9ac789983196c9708845d6f8d6ee))

# [1.13.0](https://github.com/vladdoster/dotfiles/compare/v1.12.1...v1.13.0) (2022-03-21)


### chore

* clean up zi config and add tmux stats ([87f32e8](https://github.com/vladdoster/dotfiles/commit/87f32e87e046e7daa47cf3eb5f7c6c71ae1a8f1b))
* clean up zinit config cruft ([050fbad](https://github.com/vladdoster/dotfiles/commit/050fbad2bc39ac35d2df6ffa4bb7e4f03191fa2d))
* move unused config bits to different file for easy reference ([9cff804](https://github.com/vladdoster/dotfiles/commit/9cff804fa6fa6a1df31e439bcd7f90170372ec33))
* re-enable window decorations, use IBM plex font, and fmt config ([26bf6eb](https://github.com/vladdoster/dotfiles/commit/26bf6ebe681320d337d1b0f2c3ab35575ff81d44))
* reduce cruft in zinit config ([458e4b9](https://github.com/vladdoster/dotfiles/commit/458e4b947fdde9d944f02bac507f19eee7777332))
* set docker platform to linux/amd64 to work on apple M1 processors ([3ec0936](https://github.com/vladdoster/dotfiles/commit/3ec09369323f1aab22748d4d37e6c9d38861fc78))

### feat

* tmux mem-cpu-load status bar stats ([e2539ef](https://github.com/vladdoster/dotfiles/commit/e2539ef5fef24ab952d037e89396929baa6f4408))

### fix

* improved hs window border logic when a window is destroyed ([c59c27b](https://github.com/vladdoster/dotfiles/commit/c59c27b823ebb8fc0b9b0b58445eee76b81b06e6))
* rm OMZP directories breaking \`la\` & misc. zinit config cruft ([ab53129](https://github.com/vladdoster/dotfiles/commit/ab531291f6475d80c4427dc9038ebf4075d17096))
* zinit env variables & remove starship example ([6be9428](https://github.com/vladdoster/dotfiles/commit/6be94288ec751a5ef35a4547a46c914f7c0f13d2))

### maint

* only show tabs when appropriate ([92024e3](https://github.com/vladdoster/dotfiles/commit/92024e3e17fec43afab65d7ffd92600268c04d0e))
* update z{'init.zsh','shenv'} & aliases ([3a6c7e7](https://github.com/vladdoster/dotfiles/commit/3a6c7e7dea400a7bc734b7d529a4ae0df73a404d))
* use alpine base image in Dockerfile for M1 compat ([610af16](https://github.com/vladdoster/dotfiles/commit/610af163110cbb2e24a7c8558472f2647c78c95e))

### new

* add devdash binary & fzf-tab ([33b8ef6](https://github.com/vladdoster/dotfiles/commit/33b8ef65014b9b3fe1b5dfc0fa0998b81cc9e402))
* run dotfiles container Make target and zi programs fixes ([d404275](https://github.com/vladdoster/dotfiles/commit/d40427540c04d7950d014e27d8580ebc09010c89))

### release

* v1.12.1 → v1.13.0 ([f52ee0a](https://github.com/vladdoster/dotfiles/commit/f52ee0abd06b181454050788ed6eeb2d45c7734a))

## [1.12.1](https://github.com/vladdoster/dotfiles/compare/v1.12.0...v1.12.1) (2022-03-11)


### chore

* fix history substring search and add all zi recipes ([f1f809a](https://github.com/vladdoster/dotfiles/commit/f1f809afe6e50adc915c6c1b9e02a5f106b02308))
* test misc. changes ([ca80d33](https://github.com/vladdoster/dotfiles/commit/ca80d33301c316ffe249cf65a5d1e8963779552a))
* update kitty, hammerspoon, git config, and zsh cfgs ([84a9070](https://github.com/vladdoster/dotfiles/commit/84a9070bb6ee6d01a2f8183e342f57b05f88e866))

### refactor

* re-work of hs modules ([4be25e0](https://github.com/vladdoster/dotfiles/commit/4be25e046eb81db9213f9847c69a312f6745c157))

# [1.12.0](https://github.com/vladdoster/dotfiles/compare/v1.11.2...v1.12.0) (2022-03-07)


### new

* add global rust & cargo install ([40a27ae](https://github.com/vladdoster/dotfiles/commit/40a27ae6ca2e007a9b32edb3acc1e62d1f29bd7a))

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
