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

function download() {
    local -n tmp_file="$1"
    local url="$2"
    tmp_file=$(mktemp)

    debug "Downloading: ${url}..."
    curl -L "${url}" -o "${tmp_file}";
}

function extract() {
    local -n dst="$1"
    local src="$2"
    dst="${3:-$(mktemp -d)}"

    debug "Extracting to: ${dst}..."
    if file --mime-type "${src}" 2>/dev/null | grep -q "application/zip"; then
        unzip -q "${src}" -d "${dst}"
    else
        # Handles .tar.gz, .tar.xz, .tar.bz2, or plain .tar automatically
        tar -xf "${src}" -C "${dst}"
    fi
}

function install_rg() {
    local install_dst="${install_prefix}/bin/rg"

    echo "==> Installing rg..."
    if [[ ${clean} -eq 0 && -e "${install_dst}" ]]; then
        echo "Error: destination ${install_dst} exists, use --clean to overwrite"
    fi

    local base_url="https://github.com/BurntSushi/ripgrep/releases/latest"
    local latest_tag=$(basename $(curl -sLI -o /dev/null -w %{url_effective} "${base_url}"))
    local artifact="ripgrep-${latest_tag}-$(uname -m)-unknown-linux-musl.tar.gz"
    local url="${base_url}/download/${artifact}"

    local out_file=""
    local out_dir=""
    download out_file "${url}"
    extract out_dir "${out_file}"
    find "${out_dir}" -name rg -type f -print -quit | xargs -I {} cp {} "${install_dst}"
    rm -rf "${out_file}" "${out_dir}"
    echo "Successfully installed rg"
}

function install_stow() {
    local url="https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz"
    local install_dst="${install_prefix}/bin/stow"

    echo "==> Installing stow..."
    if [[ ${clean} -eq 0 && -e "${install_dst}" ]]; then
        echo "Error: destination ${install_dst} exists, use --clean to overwrite"
    fi

    local out_file=""
    local out_dir=""
    download out_file "${url}"
    extract out_dir "${out_file}"
    cd "$(find ${out_dir} -maxdepth 1 -mindepth 1 -type d | head -1)" && {
        ./configure --prefix="${install_prefix}" > /dev/null
        make > /dev/null && make install prefix="${install_prefix}" > /dev/null
        cd -;
    }
    rm -rf "${out_file}" "${out_dir}"
    echo "Successfully installed stow"
}

function install_nvim() {
    local nvim_file="nvim-linux-x86_64.tar.gz"
    local url="https://github.com/neovim/neovim/releases/latest/download/${nvim_file}"
    local nvim_install_dir="${install_prefix}/${nvim_file%%.*}"

    echo "==> Installing nvim..."
    if [[ ${clean} -eq 0 && ( -e "${install_prefix}/bin/nvim" || -e "${nvim_install_dir}" ) ]]; then
        echo "Error: existing installation found, use --clean to overwrite"
        return 1
    fi

    local out_file=""
    local out_dir=""
    download out_file "${url}"
    rm -rf "${nvim_install_dir}"
    extract out_dir "${out_file}" "${install_prefix}"
    cd "${install_prefix}/bin" && {
        ln -sf "../${nvim_file%%.*}/bin/nvim" nvim
        cd -
    }
    rm -rf "${out_file}"
    echo "Successfully installed nvim"
}

function install_treesitter_cli() {
    local url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-cli-linux-x64.zip"
    local install_dst="${install_prefix}/bin/tree-sitter"
    echo "==> Installing treesitter-cli..."
    if [[ ${clean} -eq 0 && -e ${install_dst} ]]; then
        echo "Error: destination ${install_dst} exists, use --clean to overwrite"
        return 1
    fi


    local out_file=""
    local out_dir=""
    download out_file "${url}"
    extract out_dir "${out_file}"
    cp -f "${out_dir}/tree-sitter" "${install_dst}"
    rm -rf "${out_file}" "${out_dir}"
    echo "Successfully installed treesitter-cli"
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
            treesitter-cli)
                install_treesitter_cli
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
# pipefail - set return value to the last command with non-zero status
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

