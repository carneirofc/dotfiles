#!/bin/bash
set -exu -o pipefail
gh_api_url=${gh_api_url:-"https://api.github.com"}
gh_web_url=${gh_web_url:-"https://github.com"}

bin_install_dir=${bin_install_dir:-"${HOME}/.local/bin"}

# https://github.com/jqlang/jq/releases
function latest_tag {
    owner=$1
    repo=$2
    latest_tag=$(curl --silent -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "${gh_api_url}/repos/${owner}/${repo}/releases?per_page=1&page=1" | grep -Po '(?<="tag_name": ")(.*?)(?=")')
    echo $latest_tag
}

function install_jq {
    # $(curl --silent -L -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' 'https://api.github.com/repos/jqlang/jq/releases?per_page=1&page=1'| grep -Po '(?<="browser_download_url": ")(.*?)(?=")') | fzf
    jq_latest_tag=$(latest_tag jqlang jq)
    mkdir --parent ~/.local/bin
    wget --quiet --output-document="${bin_install_dir}/jq" "${gh_web_url}/jqlang/jq/releases/download/${jq_latest_tag}/jq-linux-amd64"
    chmod +x ~/.local/bin/jq
}

function install_fd {
    latest_tag=$(latest_tag sharkdp fd)
    mkdir --parent ~/.local/bin
    wget "${gh_web_url}/sharkdp/fd/releases/download/${latest_tag}/fd-${latest_tag}-x86_64-unknown-linux-musl.tar.gz"
    tar -zxvf ./fd-${latest_tag}-x86_64-unknown-linux-musl.tar.gz

    echo "Installing fd version ${latest_tag}"
    mv ./fd-${latest_tag}-x86_64-unknown-linux-musl/fd ${bin_install_dir}/
    mkdir --parent ~/.local/share/man/man1

    # echo "Configuring fd man entries"
    # cp ./fd-${latest_tag}-x86_64-unknown-linux-musl/fd.1 ~/.local/share/man/man1/
    # mandb --user-db

    echo "Configuring autocomplete"
    mkdir --parent ~/.bash_completion.d
    cp fd-${latest_tag}-x86_64-unknown-linux-musl/autocomplete/fd.bash ~/.bash_completion.d/
    echo 'source ~/.bash_completion.d/fd.bash' >> ~/.bashrc
    source ~/.bashrc
    rm -rfv ./fd-${latest_tag}-x86_64-unknown-linux-musl
}

function install_rg {
    latest_tag=$(latest_tag BurntSushi ripgrep)
    mkdir --parent ~/.local/bin
    wget "${gh_web_url}/BurntSushi/ripgrep/releases/download/${latest_tag}/ripgrep-${latest_tag}-x86_64-unknown-linux-musl.tar.gz"
    tar -zxvf ./ripgrep-${latest_tag}-x86_64-unknown-linux-musl.tar.gz

    echo "Installing ripgrep version ${latest_tag}"
    mv ./ripgrep-${latest_tag}-x86_64-unknown-linux-musl/rg ${bin_install_dir}/
    mkdir --parent ~/.local/share/man/man1

    echo "Configuring autocomplete"
    mkdir --parent ~/.bash_completion.d
    cp  ./ripgrep-${latest_tag}-x86_64-unknown-linux-musl/complete/rg.bash ~/.bash_completion.d/
    echo 'source ~/.bash_completion.d/rg.bash' >> ~/.bashrc
    source ~/.bashrc

    rm -rfv ./ripgrep-${latest_tag}-x86_64-unknown-linux-musl.tar.gz
}

install_rg
install_jq
install_fd
