#!/usr/bin/bash

DEBUG=1
SHORT_OPTS=cp:
LONG_OPTS=clean,install-prefix:

clean=1
install_prefix=$HOME/.local
install_list=()

function debug() {
    if [[ ${DEBUG} -eq 1 ]]; then echo "$@"; fi
    return 0
}

function install_rg() {
    local install_dir="${install_prefix}/bin"
    local target_file="${install_dir}/rg"
    if [[ -e "${target_file}" && ${clean} -eq 0 ]]; then
        echo "Target exists: ${target_file}"
        echo "Skip rg installation"
        return 0
    fi

    echo "Installing rg..."
    local base_url="https://github.com/BurntSushi/ripgrep/releases"
    local latest_tag=$(basename $(curl -sLI -o /dev/null -w %{url_effective} "${base_url}/latest"))
    local artifact="ripgrep-${latest_tag}-$(uname -m)-unknown-linux-musl.tar.gz"
    local latest_url="${base_url}/download/${latest_tag}/${artifact}"

    # Clean existing installation
    if [[ ${clean} -eq 1 && -e "${target_file}" ]]; then
        echo "Clean existing installation: ${target_file}"
        rm "${target_file}"
    fi

    echo "Latest rg: ${latest_url}"
    if [[ ! -d "${install_dir}" ]]; then mkdir -p "${install_dir}"; fi
    curl -sL "${latest_url}" | tar -xvz -C "${install_dir}" --strip-component=1 --wildcards */rg > /dev/null
    echo "Successfully installed rg"

    return 0
}

function install_stow() {
    local base_url="https://ftp.gnu.org/gnu/stow"
    local latest_stow="stow-latest.tar.gz"
    local latest_url="${base_url}/${latest_stow}"
    echo "Installing stow..."
    curl -sL -o "/tmp/${latest_stow}" "${latest_url}"
    local extract_dir="/tmp/$(tar -xvf /tmp/${latest_stow} -C /tmp | cut -f1 -d'/' | sort | uniq)"
    debug "Extract location: ${extract_dir}"
    cd "${extract_dir}" && {
        ./configure --prefix="${install_prefix}" > /dev/null
        make > /dev/null && make install prefix="${install_prefix}" > /dev/null
        cd -;
    }
    echo "Successfully installed stow"
    return 0
}

function install_nvim() {
    local base_url="https://github.com/neovim/neovim/releases/latest/download"
    local latest_nvim="nvim-linux-x86_64.tar.gz"
    local latest_url="${base_url}/${latest_nvim}"
    echo "Installing nvim..."
    curl -sL -o "/tmp/${latest_nvim}" "${latest_url}"
    rm -rf "${install_prefix}/${latest_nvim}"
    if [[ -L "${install_prefix}/bin/nvim" ]]; then
        unlink "${install_prefix}/bin/nvim"
    fi
    tar -C "${install_prefix}" -xzf "/tmp/${latest_nvim}"
    cd "${install_prefix}/bin" && {
        ln -s "../${latest_nvim%%.*}/bin/nvim" nvim
        cd -
    }
}

function install() {
    for app in "${install_list[@]}"; do
        case "$app" in
            rg)
                install_rg
                ;;
            stow)
                install_stow
                ;;
            nvim)
                install_nvim
                ;;
            *)
                echo "Unrecognized app: ${app}"
                break
                ;;
        esac
    done

    return 0
}

# errexit - exit shell on error
# pipefail - set retuen value to the last command with non-zero status
# noclobber - prevent overwriting existing file when redirecting output
# nounset - treat unset variable as errors
set -o errexit -o pipefail -o noclobber -o nounset

# prevent shell exit on err
# shell does not exit if error happens in && chained command except the last
getopt --test > /dev/null && true

if [[ $? -ne 4 ]]; then
    echo "'getopt --test' failed, aborting..."
    exit 1
fi

debug "Original arguments: $*"

PARSED=$(getopt --name=$0 --longoption=$LONG_OPTS --options=$SHORT_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
    echo "getopt error code: $?"
    exit 2
fi

eval set -- "${PARSED}"

debug "getopt parsed arguments: ${PARSED}"
debug "Effective arguments: $*"
debug "Num args: $#"

while [[ ( $# -gt 0 ) ]]; do
    case "$1" in
        -c|--clean)
            clean=1
            ;;
        -p|--install-prefix)
            shift
            install_prefix="$1"
            ;;
        --)
            shift
            install_list=("${install_list[@]}" "$@")
            break
            ;;
        *)
            echo "Unrecognized option: $1"
            exit 1
            ;;
    esac
done

debug "Apps to be installed: ${install_list[@]}"

install

