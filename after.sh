#!/bin/sh

# libffi-dev is required for later versions of Ruby
echo "Installing libffi-dev"
apt-get install -y libffi-dev

echo "Installing ZSH"
apt-get install -y zsh

echo "Setting ZSH as default shell"
sudo chsh -s $(which zsh) vagrant

echo "Installing Gitflow"
apt-get install -y git-flow

echo "Installing wp-cli"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

su vagrant <<'EOF'

    echo "Changing sudoedit command to Vim"
    echo "3" | sudo update-alternatives --config editor --quiet

    echo "Installing Oh My ZSH"
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

    echo "Installing Psysh"
    composer g require psy/psysh:@stable

    echo "Installing Drush 6.x (stable)"
    composer global require drush/drush:6.*

    # Install Ruby and friends
    echo "Installing rbenv"
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

    echo "Add shims and composer to ZSH Path"
    echo 'export PATH="$PATH:$HOME/.rbenv/bin:$HOME/.composer/vendor/bin"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc

    echo "Installing ruby-build"
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

    echo "Installing Gem Rehash"
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

    source ~/.zshrc

    echo "Installing latest stable version of Ruby"
    ~/.rbenv/bin/rbenv install 2.2.1

    echo "Setting global Ruby version to 2.2.1"
    ~/.rbenv/bin/rbenv global 2.2.1

    echo "Installing bundler gem"
    ~/.rbenv/shims/gem install bundler

    echo "Installing awesome print gem"
    ~/.rbenv/shims/gem install awesome_print

EOF