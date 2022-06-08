#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"

fi

function vanilla {
clear
    read -p "Which Version of Minecraft should your server be? `echo $'\n> '`" VERSION
    #printf "1: 1.7.10 - 1.16.5 \n2: 1.17 - 1.17.1 \n3: 1.18+"
    if [ $VERSION == "1.7.10" ]
    then
        java8
    elif [ $VERSION == "1.8" ]
    then
        java8
    elif [ $VERSION == "1.8.0" ]
    then
        java8
    elif [ $VERSION == "1.8.8" ]
    then
        java8
    elif [ $VERSION == "1.8.9" ]
    then
        java8
    elif [ $VERSION == "1.9" ]
    then
        java8
    elif [ $VERSION == "1.9.4" ]
    then
        java8
    elif [ $VERSION == "1.10" ]
    then
        java8
    elif [ $VERSION == "1.10.2" ]
    then
        java8
    elif [ $VERSION == "1.11" ]
    then
        java8
    elif [ $VERSION == "1.11.2" ]
    then
        java8
    elif [ $VERSION == "1.12" ]
    then
        java8
    elif [ $VERSION == "1.12.1" ]
    then
        java8
    elif [ $VERSION == "1.12.2" ]
    then
        java8
    elif [ $VERSION == "1.13.2" ]
    then
        java8
    elif [ $VERSION == "1.14.2" ]
    then
        java8
    elif [ $VERSION == "1.14.3" ]
    then
        java8
    elif [ $VERSION == "1.14.4" ]
    then
        java8
    elif [ $VERSION == "1.15" ]
    then
        java8
    elif [ $VERSION == "1.15.1" ]
    then
        java8
    elif [ $VERSION == "1.15.2" ]
    then
        java8
    elif [ $VERSION == "1.16" ]
    then
        java8
    elif [ $VERSION == "1.16.2" ]
    then
        java8
    elif [ $VERSION == "1.16.3" ]
    then
        java8
    elif [ $VERSION == "1.16.4" ]
    then
        java8
    elif [ $VERSION == "1.16.5" ]
    then
        java8

    elif [ $VERSION == "2" ]
    then
        echo "You want to install 1.17 - 1.17.1"
    elif [ $VERSION == "3" ]
    then
        echo "You want to install 1.18+"
    else
        echo "This version is not supported!"

    fi

}

function modded {

    echo "You want to install a modded Server" 

}

function java8 {
    clear
    echo "Java 8 is required to run a Minecraft Server of that version."
    echo ""
    read -p "Do you want to install it? Y/n `echo $'\n> '`" installrequest_java8 
    case "$installrequest_java8" in 
       [yY] | [yY][eE][sS])
        install_java8
        ;;
        [nN] | [nN][oO])
        clear
        echo "Java8 is required to run a Minecraft Server!"
        sleep 2
        java8
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
    clear
    echo "Java 8 has been installed now!"
    sleep 2
    install_mc
}


function install_mc {
        clear
        cd /home/Minecraft
        wget https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/minecraft_server.$VERSION.jar
        mv minecraft_server*.jar server.jar
        screen -dmS Install java -jar server.jar --installServer
        sleep 10
        if [ -f "server.properties" ]
        then
        screen -XS Install quit
        echo "Install complete"
        fi
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
mkdir /home/Minecraft
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
