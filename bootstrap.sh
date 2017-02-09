#!/usr/bin/env bash

sudo echo OK

###############################################################################
# Xcode                                                                       #
###############################################################################

mkdir -p ${BD_DEVELOPER_DIR}/src
cd ${BD_DEVELOPER_DIR}/src
echo "Installing Xcode CLI"
[ -e "/Applications/Xcode.app" ] && xcode-select --install || echo OK
[ -e "/Applications/Xcode.app" ] && sudo xcodebuild -license || echo OK
open https://developer.apple.com/download/more/
read -n1 -r -p "Download the latest version of Xcode and install.  When complete press any key to continue..." key
git clone https://github.com/hdoria/xcode-themes.git
cd xcode-themes
./install.sh

###############################################################################
# Oh-My-Zsh                                                                   #
###############################################################################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

###############################################################################
# Homebrew                                                                    #
###############################################################################

[ -d "$HOME/Library/Caches/Homebrew/" ] && sudo chown -R $(whoami) "$HOME/Library/Caches/Homebrew/"
[ -d "/usr/local/Caskroom" ] && sudo chown -R $(whoami) /usr/local/Caskroom
[ -d "/usr/local/sbin" ] && sudo chown -R $(whoami) /usr/local/sbin
[ -d "/usr/local/lib" ] && sudo chown -R $(whoami) /usr/local/lib
[ -d "/usr/local/share" ] && sudo chown -R $(whoami) /usr/local/share
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install android java vim nvm pyenv rbenv tree
source $(brew --prefix nvm)/nvm.sh
nvm install 4
CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install -v 2.7
pyenv global 2.7
rbenv install 2.3.0
rbenv global 2.3.0

###############################################################################
# Caskroom                                                                    #
###############################################################################

brew tap caskroom/cask
brew tap caskroom/versions
brew cask install android-studio charles colorpicker dropbox google-chrome intellij-idea iterm2 java kaleidoscope macdown pycharm sizeup sublime-text skype sourcetree webstorm
brew cask cleanup

###############################################################################
# Arcanist                                                                    #
###############################################################################

arc set-config editor "/usr/local/bin/vim"

###############################################################################
# iTerm2                                                                      #
###############################################################################

echo "Installing iTerm2 color schemes - In iTerm2 press cmd + i and import Lavanda theme."
cd ${BD_DEVELOPER_DIR}/src
git clone git@github.com:mbadolato/iTerm2-Color-Schemes.git

###############################################################################
# Sublime                                                                     #
###############################################################################

mkdir -p ${HOME_DIR}/System/Fonts
cd ${HOME_DIR}/System/Fonts
git clone https://github.com/vjpr/monaco-bold.git
cd monaco-bold
open MonacoB2/*.otf
cd ${HOME_DIR}
read -n1 -r -p "Install fonts and press any key to continue..." key

###############################################################################
# vim                                                                         #
###############################################################################

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle && \
  git clone https://github.com/wincent/command-t.git && \
  git clone https://github.com/tmhedberg/matchit.git && \
  git clone https://github.com/scrooloose/nerdtree.git && \
  git clone https://github.com/vim-syntastic/syntastic.git && \
  git clone https://github.com/pangloss/vim-javascript.git && \
  git clone https://github.com/mxw/vim-jsx.git && \
  git clone https://github.com/tpope/vim-unimpaired.git && \
  git clone https://github.com/garbas/vim-snipmate.git && \
  git clone https://github.com/isRuslan/vim-es6.git && \
  git clone https://github.com/tomtom/tlib_vim.git && \
  git clone https://github.com/MarcWeber/vim-addon-mw-utils.git && \
  git clone https://github.com/honza/vim-snippets.git && \
  ./install.py --clang-completer

###############################################################################
# Important Files                                                             #
###############################################################################

cp ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/zsh/zshrc ~/.zshrc

cp ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/git/gitconfig ~/.gitconfig
cp ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/git/gitignore ~/.gitignore

cp ${BD_DEVELOPER_DIR}/system/vim/vimrc ~/.vimrc

rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
cp -r ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/Application\ Support/Sublime\ Text\ 3/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/

cd ${HOME}/Library/Preferences
BD_INTELLIJ_DIR=($(find . -type d -name "IntelliJ*"))
BD_PYCHARM_DIR=($(find . -type d -name "PyCharm*"))
BD_WEBSTORM_DIR=($(find . -type d -name "WebStorm*"))
ln -s ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/jetbrains/Ayu\ Dark.icls ${BD_INTELLIJ_DIR}/colors/Ayu\ Dark.icls
ln -s ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/jetbrains/Ayu\ Dark.icls ${BD_PYCHARM_DIR}/colors/Ayu\ Dark.icls
ln -s ${BD_DEVELOPER_DIR}/src/mac-os-bootstrap/system/jetbrains/Ayu\ Dark.icls ${BD_WEBSTORM_DIR}/colors/Ayu\ Dark.icls

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Disable “natural” scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Secondary click:
# Possible values: OneButton, TwoButton, TwoButtonSwapped
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton

# Smart zoom enabled, double-tap with one finger (set to 0 to disable)
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture -int 0

# Two finger horizontal swipe
# 0 = Swipe between pages with one finger
# 1 = Swipe between pages
# 2 = Swipe between full screen apps with two fingers, swipe between pages with one finger (Default Mode)
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture -int 0

defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseVerticalScroll -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseMomentumScroll -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseHorizontalScroll -bool true

# Set a fast mouse/trackpad tracking
defaults write -g com.apple.mouse.scaling -float 3.0
defaults write -g com.apple.trackpad.scaling -float 3.0

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Enable magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 15
defaults write com.apple.dock largesize -int 111

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 25

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Apps
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others

defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/Mail.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/Google%20Chrome.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/iTunes.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/Sublime%20Text.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/Messages.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/SourceTree.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/Xcode.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/WebStorm.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/IntelliJ%20IDEA.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/PyCharm.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/iTerm.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/App%20Store.app/_CFURLStringType0 ";
defaults write com.apple.dock persistent-apps -array-add "< dict>tile-data file-data_CFURLString /Applications/System%20Preferences.app/_CFURLStringType0 ";

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add iOS & Watch Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Sublime.app" "/Applications/Simulator.app"
