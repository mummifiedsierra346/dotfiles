#! /bin/bash -xe

# update fish
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update -y
sudo apt install -y fish

# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes

# bootstrap nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# clone actual dotfiles
git clone https://github.com/friedenberg/dotfiles ~/.dotfiles
# git clone git@github.com:mummifiedsierra346/dotfiles-private.git ~/.dotfiles/tag-datadog_private

# build nix dotfiles stuff
pushd ~/.dotfiles
mkdir -p ~/.config/nix
cat - > ~/.config/nix/nix.conf <<-EOM
experimental-features = nix-command flakes
EOM
nix build
bin_result="$(pwd)/result/bin"
bin_fish="$(readlink "$bin_result/fish")"
export PATH="$bin_result:$PATH"

cp rcrc ~/.rcrc
rcup -f

# sudo bash -c "echo '$bin_fish' >> /etc/shells"
# sudo chsh -s "$bin_fish"

# echo "You should run \`exec fish\` to switch to the installed shell" >&2
