#!/bin/bash


# 使用vagrant跑虛擬機時必須改使用以下兩行指令
#security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k vagrant login.keychain-db
#security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k 1qaz2wsx proto.keychain-db

security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k 1qaz2wsx ${KEYCHAIN}

exit 0
