#!/bin/sh

#  add-key.sh
#  SimbleHealth
#
#  Created by NBL on 7/11/18.
#  Copyright © 2018 iosBrothers. All rights reserved.
security create-keychain -p travis ios-build.keychain
security import ./scripts/travis/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/travis/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/travis/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/travis/profile/* ~/Library/MobileDevice/Provisioning\ Profiles/
