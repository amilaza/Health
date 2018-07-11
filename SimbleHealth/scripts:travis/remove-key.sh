#!/bin/sh

#  remove-key.sh
#  SimbleHealth
#
#  Created by NBL on 7/11/18.
#  Copyright © 2018 iosBrothers. All rights reserved.


security delete-keychain ios-build.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*
