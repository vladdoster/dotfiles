
curl -L https://api.github.com/repos/zsh-users/zsh/tarball/$ref | tar xz --strip=1

./Util/preconfig
build_platform=x86_64; \
    case "$(dpkg --print-architecture)" in \
      arm64) \
        build_platform="aarch64" \
        ;; \
    esac; \
    ./configure --build=${build_platform}-unknown-linux-gnu \
                --prefix /usr \
                --enable-pcre \
                --enable-cap \
                --enable-multibyte \
                --with-term-lib='ncursesw tinfo' \
                --with-tcsetpgrp
