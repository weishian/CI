# Mobile Compiled Environment Architecture

## Create iOS VirtualBox for Vagrant

OSX 本身雖為 Unix 基底的作業系統，但相對於 Linux 在核心上有一定的差異，且操作方式的不同，這也使得虛擬化過程中無法完全依靠腳本編譯。

因此，經過諸多文件確認與實驗，採用 Docker 進行虛擬化並不可行，但若採用 VirtualBox、VMWare 是可以做到，但由於這兩套軟體並不支援腳本操作，故對於 OSX 虛擬化部分採用 Vagrant

### ◎ 安裝環境

+ [Vagrant](https://www.vagrantup.com/)
+ [VirtualBox](https://www.virtualbox.org/)

### ◎ 自建環境

#### 1、安裝 OSX 於 VirtualBox 中

由於 OSX 能獲得的版本需從網路上搜尋，因此對應不同環境需要去找尋對應的檔案；依據目前所知並無法直接從 App store 上抓取可用於虛擬機上的版本。
> 但如何從 App store 上抓取可用版本仍有研究價值。

此外，若安裝 VirtualBox 啟動 OSX 需依據 VirtualBox 版本不同需核外添加參數；但此操作請務必關閉所有啟動中的虛擬機與 VirtualBox 介面，因若無徹底關閉，指定參數用的 VBoxManage 程式將無法抓到新增的虛擬機。

---

+ [How to Install macOS High Sierra 10.13.6 on VirtualBox on Windows](https://techsviewer.com/install-macos-high-sierra-virtualbox-windows/)
+ [Download & Install macOS High Sierra 10.13 on VMware in Windows](https://www.tactig.com/download-install-macos-high-sierra-vmware/)

---

#### 2、安裝 vagrant 帳戶

在虛擬機啟動 OSX 後，需開始設定作業系統啟動資訊

+ Apple ID
> 於 [Applie ID](http://appleid.apple.com) 申請的使用者帳戶，主要用於 App Store 消費之用；需注意這帳戶與開發者帳戶不同。

+ Account "vagrant"
> 依據官方文獻建議，若無特殊需求，base box 建議皆使用 "vagrant" 為登入帳號；若不是設此值，則應於 vagrantfile 中定義 config.ssh.username。

+ Password "vagrant"
> 依據官方文獻建議，若無特殊需求，base box 建議皆使用 "vagrant" 為登入密碼；若不是設此值，則應於 vagrantfile 中定義 config.ssh.password。

+ 設定無須密碼 (Password-less) 權限

經由 SSH 遠端登入帳號，皆有使用權限問題，且使用 sudo 執行管理權限模式執行命令時，必須填入帳號密碼才可使用；而 Vagrant 因為其操作行為 VirtualBox 行為必要，需要使用者對虛擬機開放相應權限，以操控行為；但這樣的設定是具有高風險的行為，在設置前務必確認此項設定可能造成的安全問題。

```
cd /etc
sudo visudo
```
> 前往目錄 etc 下方，並透過 vi 修改 sudoers 檔案

```
vagrant ALL = (ALL) NOPASSWD: ALL
```
> 於文檔中設定會看到```root ALL = (ALL) ALL```下方填寫上述內容，若帳號不為 vagrant 則填入對應之帳號

若完成上述動作，則操作行為```sudo cat sudoers```會略過密碼填入的行為。

---

+ [Creating a Base Box - Default User Settings](https://www.vagrantup.com/docs/boxes/base.html#default-user-settings)
+ [How to Add a User to the Sudoers File in Mac OS X](http://osxdaily.com/2014/02/06/add-user-sudoers-file-mac/)

---

#### 3、設定 SSH

完成帳戶資訊後，進入虛擬機後，則需設置 SSH 連線資訊。
由於 Vagrant 在對虛擬機登入、操控皆是採用 SSH 機制，若設定失敗將導致 Vagrant up 失敗，且 Vagrant ssh 將無法登入虛擬機中。

+ OSX 啟動 SSH 機制
> System Preferences > Sharing > enable Remote Login
>
> 詳細說明參考下列連結

+ 複製 Vagrant ssh key

開啟 Terminal 後，輸入以下指定

```
cd ~/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O .ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chown -R vagrant:vagrant .ssh
```
> 注意 chown 是對 vagrant group 的 vagrant 帳號設定權限，若無 group，則使用 ```chown -R vagrant .ssh```

---

+ [How to Access Your Mac over SSH with Remote Login](https://www.booleanworld.com/access-mac-ssh-remote-login/)
+ [Insecure Keypair](https://github.com/hashicorp/vagrant/tree/master/keys)

---

#### 4、設定 Share folder (共享檔案夾)

+ 設定 Mac 共享檔案；目前研究方案 NFS、SSHFS 皆有其問題。

綜合來說，需要採用哪種方案進行檔案連接皆可，在最不理想情況下，上述方案亦可能皆失敗；屆時就得採用 rsync 直接與遠端對傳資料，是最為實際的方法。

#### 5、設定 Shut Down by SSH

若無須密碼 (Password-less) 權限失敗，在關機時會產生錯誤，可以此研究是否建立失敗

---

+ s[How to Remotely Restart or Shut Down Your Mac](https://www.lifewire.com/remotely-restart-or-shut-down-mac-2259969)

---

#### 5、封裝 Vagrant box

完成設定關閉虛擬機，並於主機執行下列命令，將 VM 封裝成 Vagrant box 供後續執行。

```
vagrant package --base "You VM name in VirtualBox" --output "path/box-name-version"
```

產出 Vagrant box 後可透過 Vagrant cli command 登記 box 或由 Vagrantfile 直接指定 box 來運作

## 參考

---

+ [vagrant-box-macos](https://github.com/bacongravy/vagrant-box-macos)
> Scripts for building Vagrant boxes for VMware Fusion that boot macOS.

+ [vagrant-box-macos](https://github.com/bacongravy/vagrant-box-macos)
> Scripts for building Vagrant boxes for VMware Fusion that boot macOS.

+ [Mac OS X Vagrant box for VirtualBox](https://app.vagrantup.com/AndrewDryga/boxes/vagrant-box-osx)
 
目前調查研究已完成，相關 Docker、Vagrant 說明請參考如下文件：
 
http://gitlab.yxunistar.com/ISSUE/Issue_Mobile_development_framework/blob/master/doc/compiled%20environment%20virtualization.md
 
Vagrantfile demo
 
http://gitlab.yxunistar.com/ISSUE/Issue_Mobile_development_framework/tree/master/code/vagrant/osx
 
Docker demo
 
http://gitlab.yxunistar.com/ISSUE/Issue_Mobile_development_framework/tree/master/code/docker

---
