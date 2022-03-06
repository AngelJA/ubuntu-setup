# sudo without entering password
echo Sudo without entering password...
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/aavila
sudo chmod 440 /etc/sudoers.d/aavila
echo

# git config
git config --global user.email "angel.j.avila@gmail.com"
git config --global user.name "Angel Avila"

# copy config files
cp .vimrc ~
cp .tmux.conf ~
cp .fzf_completion_commands ~
cp .bashrc ~/.angel_bashrc
sudo cp gitdifflines /usr/local/bin
echo "source ~/.angel_bashrc" >> ~/.bashrc
source ~/.angel_bashrc

# install apps
url=https://github.com/sharkdp/bat/releases/download/v0.20.0/bat_0.20.0_amd64.deb
wget $url --output-document=/tmp/bat.deb
sudo dpkg -i /tmp/bat.deb
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install -y \
    silversearcher-ag \
    fzf \
    tmux \
    universal-ctags \
    vifm \
    vim-gtk3 \
    xclip

# generate ssh key
echo
ssh-keygen -t ed25519 -C "angel.j.avila@gmail.com" -f ~/.ssh/id_rsa -N ""
xclip ~/.ssh/id_rsa.pub
echo -e ssh key copied to clipboard'\n'
