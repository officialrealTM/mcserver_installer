
# Minecraft Server Installer Script (Vanilla & Forge) 1.7.X - 1.19+
## About the project

This *"simple"* Bash-Script makes installing Minecraft Servers on Linux very easy.  
Just download the script, execute it, choose if you want a Vanilla or Forge Server, select the version you want to install and your server is ready to go!  



## Requirements

 - SSH-Connection to your server (obviously^^)
 - Root Access to server (Script need to be executed as root)
 - This script works on Debian 10 ONLY! (More about Support can be found in the FAQ Section)
 - Git-Package need to be installed on the server (More information under "Installation")



# Features
### General Features:
- Graphical User Interface (GUI)
- Easy-to-Use (even for beginners!)
- Automatic installation of required programs
- Automatic installation of Java Versions for different Minecraft Versions (e.g. Minecraft 1.7.X - 1.8.9 uses Java 8)
- Creating Minecraft Server start-scripts (including a check if the correct Java Version is selcted)
- Adjustable RAM-Allocation when installing a Minecraft Server
- Installed Servers are stored in Sub-Folders, to install more than one instance

### Minecraft Vanilla Features:
- Supported Minecraft Vanilla Versions: Minecraft 1.7.X - 1.19.X

### Minecraft Forge Features:
- Supported Minecraft Forge Versions: Minecraft 1.7.10 - 1.19.X
- Installing the latest Forge Version
- Installing a specific Forge Version. (A Version Overview can be found [here](https://files.minecraftforge.net/net/minecraftforge/forge/))



## Installation

Prerequisites:

```bash
apt install git
```

Downloading the script:
```bash
git clone https://github.com/officialrealTM/mcserver_installer.git
```

Going into the downloaded folder:
```bash
cd mcserver_installer
```

Starting the Script:
```bash
./mcserver_installer.sh
```
## FAQ

#### **Can I use this Script on Debian 11, Ubuntu or other Distros?**

No. (or maybe yes?) This Script has been developed and tested on Debian 10 only.  
Try it on other Distros at your own risk!

#### **Where are my Serverfiles located?**

You Minecraft Server files will get stored in `/Servers/Minecraft-<versionnumber>`  

When installing multiple servers of the same type (e.g. two Minecraft 1.8.9 Servers) the second folder will be called `Minecraft-<versionnumber>-1` (or 2 and so on)  

#### **Can I run more than one server at once?**

##### Yes. But here you need to keep a few things in mind:
- You Linux server need to be powerfull enough
- You need to adjust the Port of the second/third/etc. Minecraft server (because Port 25565 is already in use.) This can be adjusted in the `server.properties` file  

#### **Can I change the amount of RAM allocated to my Minecraft Server after the installation?**

Yes. To do so go to your Server folder (`cd /Servers/Minecraft-<versionnumber>`) and open the `start.sh`file.  
In the last line of this file you can adjust the number after `-Xmx` to adjust more or less ram.

#### **Can I use this script to install Snapshot Versions of Minecraft?**

No. This script can only install full game versions. Snapshot Versions are not supported!

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

- Adding Support for Minecraft Spigot



## Tech Stack
These are all the packages used in this script:

**Used Packages:** dialog, sudo, wget, screen, Python3, Python3-pip, Pip3-Packaging

**Python Module:** mcurlgrabber.py (Thanks to [Christian](https://github.com/christian-thiele)!)


## Support

For support, join my [Discord](https://realtm.link/discord) and create a Ticket.  
(*Support in German and English*)
