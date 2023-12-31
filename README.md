<h1>
<img src=HostsX/Assets.xcassets/AppIcon.appiconset/icon_512x512.png width=80>
<p>HostsX</p>
<a href="https://github.com/ZzzM/HostsX/releases/latest"><img src="https://img.shields.io/github/v/release/ZzzM/HostsX"></a>
<a href="https://github.com/ZzzM/HostsX/releases/latest"><img src="https://img.shields.io/github/release-date/ZzzM/HostsX"></a>
<a href="https://raw.githubusercontent.com/ZzzM/HostsX/master/LICENSE"><img src="https://img.shields.io/github/license/ZzzM/HostsX"></a>
<a href="https://zzzm.github.io/2020/02/24/hostsx/">
<img src="https://img.shields.io/badge/docs-%E4%B8%AD%E6%96%87-red">
</a>
</h1>

A lightweight macOS app for updating local hosts

## Features
- [x] Localization (简体中文、English)
- [x] Dark mode

## Compatibility
- **2.9.0** requires **macOS 10.13** or later
- **<= 2.8.2** requires **macOS 10.12** or later

## Changelogs
- [简体中文](changelogs/CHANGELOG_SC.md)
- [English](changelogs/CHANGELOG.md)

## Snapshots

### 2.9.0

- Menubar

    <img src="assets/m1.png" height=120> 

 
    `Local`: Import a hosts to replace local hosts

    `Reset`: Reset local hosts to default
   
  
- Remote

    <img src="assets/r1.png" height=200>


    `Sync Button`: Download default remote hosts and overwrite local hosts

    `Add Button`: Add a remote source


### 2.8.2

- Menubar

    <img src="assets/m2o.png" height=120> 
    <img src="assets/m3o.png" height=120> 

    `Local`: Import a hosts to replace local hosts

    `Remote - Download`: Download default remote hosts and overwrite local hosts

- Remote

    <img src="assets/r1o.png" height=200>

    `Orign`: It indicates that this is a default source

    <img src="assets/r2o.png" height=200>

    `Orign Button (Top right corner)`: Set a remote source as default source 
   
    <img src="assets/r3o.png" height=100>
    
    `More Menu`:  Right click to show
    
    `Open Button (1st Menu item)`: Open a remote source with your browser

    `Add Button (2nd Menu item)`: Add a remote source

    `Remove Button (3rd Menu item)`: Remove a remote source
    

## FAQ

1. **"HostsX" is damaged and can't be opened.**

    <img src="assets/101.png" width=300>

    Or open `Terminal` and run  

    ```shell
    sudo xattr -r -d com.apple.quarantine /Applications/HostsX.app
    ```
2. **How to synchronize remote hosts**

    2.9.0
    1. Set a remote source as default source
    2. Click `Sync Button`

    2.8.2
    1. Click `Orign Button` to set a remote source as default source
    2. Open app menubar menu
    3. Click `Remote - Download`

3. **How to avoid overwriting your local hosts (Only Remote)**

    Put the content that you don't want to be overwritten between `# My Hosts Start` and `# My Hosts End`, like below
    ```
    # My Hosts Start

    the content that you don't want to be overwritten

    # My Hosts End

    the content from a remote source
    ```
4. **What's the `hosts_old`**
    
    When completing a local or remote operation, it will create a `hosts_old` to record the contents before the changes


## Dependencies
- [Sparkle](https://github.com/sparkle-project/Sparkle)
