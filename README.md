
  
# Minecraft Server Installer Script (Vanilla,Forge, Spigot & Paper) 1.7.X - 1.21+
## <u>About the project</u>

With this project, my goal was to make installing Minecraft servers, no matter if they are Vanilla, Forge, Spigot or Paper, as easy and beginner-friendly as possible. 
After making some Tutorials on my [YouTube Channel](https://youtube.com/realtm_csgo) and providing a detailed [Documentation](https://docs.realtm.de) for them, there were still questions and problems on how to install a Minecraft Server on a Linux-Server.
Thats why I created this All-in-One solution for installing a Minecraft Server (Forge, Vanilla, Spigot & Paper).

## Supported Distros
 - Debian 10
 - Debian 11
 - Debian 12
 - Ubuntu 18.04
 - Ubuntu 20.04
 - Ubuntu 22.04


## Requirements

 - SSH-Connection to your server
 - Root Access to server (Script need to be executed as root)
 - Linux-based operating systems (only on [Supported Distros](https://github.com/officialrealTM/mcserver_installer#supported-distros))
 - Git needs to be installed on the server --> [Installation](https://github.com/officialrealTM/mcserver_installer#installation)



# Features
### General Features:
- Graphical User Interface (GUI)
- Easy-to-Use (even for beginners!)
- Automatic installation of required programs/packages
- Automatic installation of Java Versions for different Minecraft Versions (Including Java 8, Java 16, Java 17 and Java 21)
- Creating Minecraft Server start-scripts (including a check if the correct Java Version is selcted)
- Adjustable RAM-Allocation when installing a Minecraft Server
- Installed Servers are stored in Sub-Folders, to install more than one instance
- Support for multiple Linux Distributions (Ubuntu & Debian)

### Minecraft Vanilla Features:
- Supported Minecraft Vanilla Versions: Minecraft 1.7.X - 1.21.X

### Minecraft Forge Features:
- Supported Minecraft Forge Versions: Minecraft 1.7.10 - 1.21.X
- Installing a specific Forge Version. (A Version Overview can be found [here](https://files.minecraftforge.net/net/minecraftforge/forge/))

### Minecraft Spigot Features:
- Supported Minecraft Spigot Versions: 1.8.X - 1.21.X
- Using Spigot's offical [BuildTools](https://www.spigotmc.org/wiki/buildtools/) to compile the spigot.jar(s)
- Caching of already compiled spigot.jar(s) to avoid unneccessary re-compilation of already compiled spigot.jar(s)

### Minecraft Paper Features:
- Supported Minecraft Paper Versions: 1.8.X - 1.21.X
- Possibility to install every existing Build of Paper
- Show list of available Builds for each version to select from
- Using Paper's official [API](https://api.papermc.io/docs/swagger-ui/index.html?configUrl=/openapi/swagger-config) to obtain available Builds
- Adjusted Sub-Folder Naming (including the Build-Number)



## Installation

Prerequisites:

```bash
apt install git
```

Downloading the script:
```bash
git clone https://github.com/officialrealTM/mcserver_installer.git
```

## Run the Script

Go into the downloaded folder:
```bash
cd mcserver_installer
```

Start the Script:
```bash
./mcserver_installer.sh
```
## FAQ

#### **Can I use this Script on other Distros?**

No. At least not yet. The Script has been developed and tested on --> [Supported Distros](https://github.com/officialrealTM/mcserver_installer#supported-distros).
To disable the Distro check see: [Experimental Settings](https://github.com/officialrealTM/mcserver_installer#experimental-settings)
#### **Where are my Serverfiles located?**

You Minecraft Server files will get stored in `/Servers/Minecraft-<versionnumber>`  

When installing multiple servers of the same type (e.g. two Minecraft 1.8.9 Servers) the second folder will be called `Minecraft-<versionnumber>-1` (or 2 and so on)  

#### **Can I run more than one server at once?**

Yes. But here you need to keep a few things in mind:
- Your Linux server need to be powerfull enough
- You need to adjust the Port of the second/third/etc. Minecraft server (because Port 25565 is already in use.) This can be adjusted in the `server.properties` file  

#### **Can I change the amount of RAM allocated to my Minecraft Server after the installation?**

Yes. To do so go to your Server folder (`cd /Servers/Minecraft-<versionnumber>`) and open the `start.sh`file.  
In the last line of this file you can adjust the number after `-Xmx` to adjust more or less ram.

#### **Can I use this script to install Snapshot Versions of Minecraft?**

**No.** This script can only install full game versions. Snapshot Versions are not supported!

#### **I've accidentally closed my Minecraft console. How can I open it again?** 
Dont worry, the console will kept open in the background using *screen*.  
Use this command, to show all active screen sessions:`screen -ls`  

If only one Sessions is active you can use this command, to open it: `screen -rx`
If multiple Sessions are active use this command: `screen -rx <Name of screen session>`

#### **How to close (detach)  my console?**
To close (detach) you Minecraft Console press **[CTRL]**+**[A]** and than **[CTRL]**+**[D]**

#### **More questions?**
Feel free to ask me questions on my [Discord](https://realtm.link/discord).

## Contributing

You are very welcome to contribute to this project!

To do so, just create a Pull Request and describe your additions as accurate as possible!  
Feel free to join my [Discord](https://realtm.link/discord) to ask questions about the code's structure etc.


## Roadmap

- Commenting & cleaning the sourcecode



## Tech Stack
These are all the packages used in this script:

**Used Packages:** dialog, sudo, wget, screen, jq, Python3, Python3-pip, Pip3-Packaging

**Python Script:** mcurlgrabber.py (Thanks to [Christian](https://github.com/christian-thiele)!)

## Experimental Settings
**Important:** With these experimental settings you can **disable** certain functions of the script.
Use them at your own risk and **only** if you know what you are doing!

**How to use:**
All these commands must be executed in the homedirectory of the script, namely: `/mcserver_installer`

 Disable Distro-check:
```bash
touch .skip_distro_check
```
  Disable Script Version check:
```bash
touch .skip_version_check
```
 Disable Installed-check:
 ```bash
touch .installed
```
 Disable caching/archiving of compiled Spigot.jar(s):
 ```bash
touch .disable_spigot_archive
```

### Undo experimental settings
Enable Distro-check:
```bash
rm .skip_distro_check
```
  Enable Script Version check:
 ```bash
 rm .skip_version_check
 ```
Enable Installed-check (can also be used to re-check installed packages):
```bash
rm .installed
```
Enable caching/archiving of compiled Spigot.jar(s):
```bash
rm .disable_spigot_archive
```

## Support

For support, join my [Discord](https://realtm.link/discord) and create a Ticket.  
(*Support in German and English*)
