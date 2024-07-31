#! /bin/bash -xe

# update fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes

# bootstrap nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# clone actual dotfiles
git clone https://github.com/friedenberg/dotfiles ~/.dotfiles
git clone git@github.com:mummifiedsierra346/dotfiles-private.git ~/.dotfiles/tag-datadog_private

# build nix dotfiles stuff
pushd ~/.dotfiles
nix-build
bin_result="$(pwd)/result/bin"
bin_fish="$(readlink "$bin_result/fish")"
export PATH="$bin_result:$PATH"

cp rcrc ~/.rcrc
printf "DOTFILES_DIRS=\"%s\"" "$(pwd)" >> ~/.rcrc
"$bin_result/rcup" -f

# sudo bash -c "echo '$bin_fish' >> /etc/shells"
# sudo chsh -s "$bin_fish"

# echo "You should run \`exec fish\` to switch to the installed shell" >&2
