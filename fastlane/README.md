fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios build_dependencies
```
fastlane ios build_dependencies
```
Build dependencies
### ios update_version_and_build_number
```
fastlane ios update_version_and_build_number
```
Update version
### ios build_project
```
fastlane ios build_project
```
Build project
### ios renew_certs
```
fastlane ios renew_certs
```
Renew certificates
### ios download_certs
```
fastlane ios download_certs
```
Download certificates

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
