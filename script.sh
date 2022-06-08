#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"

fi

function vanilla {
clear
    echo "Which Version of Minecraft should your server be?"
    printf "1: 1.7.10 - 1.16.5 \n2: 1.17 - 1.17.1 \n3: 1.18+"
    echo ""
    read -p "Select the Minecraft Version: " VERSION
    if [ $VERSION == "1" ]
    then
        java8
    elif [ $VERSION == "2" ]
    then
        echo "You want to install 1.17 - 1.17.1"
    elif [ $VERSION == "3" ]
    then
        echo "You want to install 1.18+"

    fi

}

function modded {

    echo "You want to install a modded Server" 

}

function java8 {

    echo "Java 8 is required to run a Minecraft Server of that version."
    echo ""
    read -p "Do you want to install it? Y/n `echo $'\n> '`" installrequest_java8 
    case "$installrequest_java8" in 
       [yY] | [yY][eE][sS])
        install_java8
        ;;
        [nN] | [nN][oO])
        echo "dann nicht"
        ;;
        *)
        echo "Invalid input"
        ;;

    esac

    
}

function install_java8 {
    echo "Java 8 will be installed now..."
    clear
    apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
    apt update
    apt install adoptopenjdk-8-hotspot -y
    sudo update-alternatives --config java
    sleep 5
    echo "Java 8 has been installed now!"
    sleep 2
    choose_version_1
}

function choose_version_1 {
    mkdir /home/Minecraft
    read -p "Enter the exact Minecraft version that should be installed (e.g. 1.8.9): `echo $'\n> '` " mc_version
    case "$mc_version" in 
    1.7.10)
        install_mc_1710
    ;;
    esac
}

function install_mc_1710 {
        cd /home/Minecraft
        wget https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/minecraft_server.1.7.10.jar
        mv minecraft_server.1.7.10.jar server.jar
        java -jar server.jar --installServer
        clear
        sleep 1
        read -p "How much RAM do you want to allocate to your Minecraft server? (e.g. 4GB ->4G): `echo $'\n> '` " max_ram
        echo "screen -S Minecraft java -Xmx$max_ram -Xms512M -jar server.jar" > start.sh
        chmod +x start.sh
        echo "eula=true" > eula.txt
        echo "To start your server execute ./start.sh"
        cd /home/Minecraft

}


echo "Required programs will be installed now"
apt install screen wget nano sudo -y
clear
echo "Do you want to install a Minecraft Vanilla Server or a Modded Minecraft Server?"
printf "1: Minecraft Vanilla \n2: Modded Minecraft"
echo ""
read -p "Enter a number: " TYPE
if [ $TYPE == "1" ]
then
    vanilla 
elif [ $TYPE == "2" ]
then
    modded
else
    echo "Please enter a valid number!"
fi
