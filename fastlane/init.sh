#!/bin/bash

echo "welcome initailization"

echo "Checkout ios-project"

ios_project_configuration=""
ios_project=""

cd ~/publish

git config user.name:"daniel.chang"
git clone $PROJECT_GIT_PATH

echo "Checkout ios-project-configuration"

git config user.name:"daniel.chang"
git clone $PROJECT_CONFIGURATION_GIT_PATH


echo "Install Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Install CocoaPods"
brew install cocoapods

echo "Install rbenv"
brew install rbenv
bash_profile=~/.bash_profile

if [ ! -e "$bash_profile" ]; then
        touch "$bash_profile"
fi

echo "eval \"\$(rbenv init -)\"\nexport PATH=\"\$HOME/.rbenv/shims:\$PATH\"" >> $bash_profile

source $bash_profile

echo "Install Ruby"
rbenv install 2.5.1
rbenv rehash

cd ~/publish/${ios_project}
ruby -v

echo "Install Bundler"
gem install bundler
bundle install
rbenv rehash

echo "Install Carthage"
brew install carthage

echo "Code Signing and Provisioning Profiles"
cd ~/publish/${ios_project_configuration}

if [ ! -d ~/Library/MobileDevice ]; then
	mkdir ~/Library/MobileDevice
	cd ~/Library/MobileDevice
	mkdir Provisioning\ Profiles
	cd ~/publish/${ios_project_configuration}
fi

cp ${PROFILES_FOLDER}/* ~/Library/MobileDevice/Provisioning\ Profiles/

cd ~/Library/Keychains
security create-keychain -p ${keychain_password} ${ios_project}.keychain
security list-keychains -d user -s login.keychain-db ${ios_project}.keychain-db
security unlock-keychain -p ${keychain_password} ${ios_project}.keychain-db
security import ${distribution_p12} -k ${ios_project}.keychain-db -P ${keychain_password} -T /usr/bin/codesign -T /usr/bin/security

echo "Build Dependencies"
cd ~/publish/${ios_project}
# Build and install frameworks by CocoaPods
pod install --repo-update
# Checkout, build frameworks by Carthage
carthage bootstrap --platform ios --no-use-binaries


echo "Build Workspace"
bundle exec fastlane build_project --env config,sit
