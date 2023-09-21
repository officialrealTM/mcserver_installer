#!/bin/bash

###################################################################
#Script Name	: MCServerInstaller                                                                                          
#Description	: A powerful bash script for easy installation of a Minecraft server (Vanilla, Forge, Spigot & Paper)                                                                                                                                                                   
#Author       	: officialrealTM aka. realTM                                              
#Email         	: support@realtm.de
#GitHub         : https://github.com/officialrealTM/mcserver_installer                                           
###################################################################

## START OF FUNCTIONS

function choose_type {

HEIGHT=12
WIDTH=61
CHOICE_HEIGHT=4
BACKTITLE="MC-Server Installer by realTM"
TITLE="Minecraft Server Type"
MENU="Select the type of Minecraft Server you want to install:"

OPTIONS=(1 "Minecraft Vanilla"
         2 "Minecraft Forge"
         3 "Minecraft Spigot"
         4 "Minecraft Paper")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
         1)
             vanilla
             ;;
         2)
             forge
             ;;
         3)
            spigot=true
            spigot
            ;;
        4)
            paper
            ;;
 esac

}


function vanilla {

ver=$(dialog --title "Choose Version" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the version number you want to install (e.g 1.8.9)" 10 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        version_checker
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
        echo "[ESC] key pressed."
        ;;
esac
        
}

function version_checker {

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$ver"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$ver"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$ver"; }
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$ver"; }

minVer=1.7
maxVer=1.20.2

if version_lt $ver $minVer; then
    not_supported
elif version_gt $ver $maxVer; then
    not_supported
else
    check_valid
fi

}

function not_supported {

    if [[ $ver == "" ]]
    then
        exit
    else
    dialog --title 'MC-Server Installer by realTM' --msgbox ' \nThe version number entered is not supported by this script!\nSupported Versions: 1.7.X - 1.20.X ' 10 60
    clear
    vanilla
    fi
}

function folder_creator_vanilla {
cd Servers
basename="Minecraft-$ver"
dirname=$basename
i=1
while [ -d $dirname ]
do
  dirname=$basename-$i
  ((i++))
done
mkdir $dirname

}

function java_selector {

    if [[ $ver = "1.17"* ]]
    then
        check_java16
        version_grab
        check_current16
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd Servers
        cd $dirname
        wget $dl
        sleep 1
        select_ram_16
    elif [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
    then
        check_java17
        version_grab
        check_current17
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd Servers
        cd $dirname
        wget $dl
        sleep 1
        select_ram_17
    else
        check_java8
        version_grab
        check_current8
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd Servers
        cd $dirname
        wget $dl
        sleep 1
        select_ram_8
    fi

}

function check_valid {
    python3 mcurlgrabber.py server-url $ver
    if [[ $? -eq 1 ]]
    then
        dialog --title 'MC-Server Installer by realTM' --msgbox ' \nThe version number entered does not exist or was entered in the wrong format!\nHint: Snapshot versions are not supported! ' 10 60
        clear
        vanilla
    else
        java_selector
    fi
}


function version_grab {
    java=$"java -version"
    $java &> javaversion.txt
    compare
}

function compare {

    if grep -q 1.8.* javaversion.txt
    then
        javaversion=8
    fi

    
    if grep -q 16.* javaversion.txt
    then
        javaversion=16
    fi
    
    
    if grep -q 17.* javaversion.txt
    then
        javaversion=17 
    fi

    rm javaversion.txt
}

function check_current8 {

    if [[ ! $javaversion -eq 8 ]]
    then
        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '$javaversion' selected, but Java 8 is required.\nChange it to Java 8 in the following menu' 10 60
        sudo update-alternatives --config java
    fi
}

function check_current16 {

    if [[ ! $javaversion -eq 16 ]]
    then
        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '$javaversion' selected, but Java 16 is required.\nChange it to Java 16 in the following menu' 10 60
        sudo update-alternatives --config java
    fi
}

function check_current17 {

    if [[ ! $javaversion -eq 17 ]]
    then
        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '$javaversion' selected, but Java 17 is required.\nChange it to Java 17 in the following menu' 10 60
        sudo update-alternatives --config java
    fi
}


function java8 {
clear
dialog --title "Java Installer" \
--backtitle "MC-Server Installer by realTM" \
--yesno "Java 8 is required! Do you want to install it?" 7 60

response2=$?
case $response2 in
   0) install_java8;;
   1) decline_java8;;
   255) echo "[ESC] key pressed.";;
esac

}

function decline_java8 {

    clear
    dialog --title "Error" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Java8 is required to run a Minecraft Server!! \nDo you want to install it?" 10 60

    response=$?
    case $response in
        0) install_java8;;
        1) clear && exit;;
        255) echo "[ESC] key pressed.";;
    esac
}


function check_java8 {

    if [[ $ubuntu = true ]]
    then
        DIR="/usr/lib/jvm/java-8-openjdk-amd64"
    else
        DIR="/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64/"
    fi

    if [[ ! -d $DIR ]]
    then
        java8
    fi
}

function check_java16 {

DIR="/usr/java/jdk-16*"
    if [ ! -d $DIR ]
    then
        java16
    fi

}

function check_java17 {

    DIR="/usr/java/jdk-17/"
    if [ ! -d $DIR ]
    then
        java17
    fi
}

function install_java8 {

    dialog --infobox "Java 8 will be installed now" 10 30 && sleep 3
    clear
    if [[ $ubuntu == "true" ]]
    then
        sudo apt-get install openjdk-8-jdk -y
    else
    apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
    apt update
    apt install adoptopenjdk-8-hotspot -y
    sudo update-alternatives --config java
    sleep 5
    clear
    fi
    dialog --infobox "Java 8 has been installed now!" 10 30 
}


function java16 {
clear
dialog --title "Java Installer" \
--backtitle "MC-Server Installer by realTM" \
--yesno "Java 16 is required! Do you want to install it?" 7 60

response2=$?
case $response2 in
   0) install_java16;;
   1) decline_java16;;
   255) echo "[ESC] key pressed.";;
esac

}


function decline_java16 {

    clear
    dialog --title "Error" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Java16 is required to run a Minecraft Server! \nDo you want to install it?" 10 60

    response=$?
    case $response in
        0) install_java16;;
        1) clear && exit;;
        255) echo "[ESC] key pressed.";;
    esac
}


function install_java16 {
    dialog --infobox "Java 16 will be installed now" 10 30 && sleep 3
    clear
    mkdir /usr/java
    cd /usr/java
    wget https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz
    tar xzvf openjdk-16.0.2_linux-x64_bin.tar.gz
    rm openjdk-16*.tar.gz
    sudo update-alternatives --install /usr/bin/java java /usr/java/jdk-16.0.2/bin/java 20000
    sudo update-alternatives --install /usr/bin/javac javac /usr/java/jdk-16.0.2/bin/javac 20000
    sudo update-alternatives --config java
    sleep 5
    cd $path
    clear
    dialog --infobox "Java 16 has been installed now!" 10 30 
}


function java17 {
clear
dialog --title "Java Installer" \
--backtitle "MC-Server Installer by realTM" \
--yesno "Java 17 is required! Do you want to install it?" 7 60

response2=$?
case $response2 in
   0) install_java17;;
   1) decline_java17;;
   255) echo "[ESC] key pressed.";;
esac

}

function decline_java17 {

    clear
    dialog --title "Error" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Java17 is required to run a Minecraft Server! \nDo you want to install it?" 10 60

    response=$?
    case $response in
        0) install_java17;;
        1) clear && exit;;
        255) echo "[ESC] key pressed.";;
    esac
}

function install_java17 {
    dialog --infobox "Java 17 will be installed now" 10 30 && sleep 3
    clear
    mkdir /usr/java
    cd /usr/java
    wget https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz
    tar xvf openjdk-17.0.1_linux-x64_bin.tar.gz
    rm openjdk-17*.tar.gz
    mv jdk-17*/ /usr/java
    mv jdk-17* jdk-17
    sudo update-alternatives --install /usr/bin/java java /usr/java/jdk-17/bin/java 20000
    sudo update-alternatives --config java
    cd $path
    sleep 5
    clear
    dialog --infobox "Java 17 has been installed now!" 10 30 
}

function script_creator_8 {
echo "function compare {" >> start.sh
echo "" >> start.sh
echo "    if grep -q 1.8.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=8" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
    
echo "    if grep -q 16.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=16" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh    
    
echo "    if grep -q 17.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=17 " >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
echo "    rm javaversion.txt" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh 
echo "" >> start.sh 
echo "function version_grab {" >> start.sh
echo "    java=$\"java -version"\" >> start.sh
echo "    \$java &> javaversion.txt" >> start.sh
echo "    compare" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "function check_current8 {" >> start.sh
echo "" >> start.sh
echo "    if [[ ! \$javaversion -eq "8" ]]" >> start.sh
echo "    then" >> start.sh
echo "        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '\$javaversion' selected, but Java 8 is required.\nChange it to Java 8 in the following menu' 10 60" >> start.sh
echo "        sudo update-alternatives --config java" >> start.sh
echo "    fi" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "version_grab" >> start.sh
echo "check_current8" >> start.sh
echo "" >> start.sh
echo "screen -S Minecraft java -Xmx$ram_third"G" -Xms512M -jar server.jar" >> start.sh
}


function select_ram_8 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=10
BACKTITLE="MC-Server Installer by realTM"
TITLE="Allocate RAM"
MENU="How much RAM do you want to allocate to your Minecraft Server?"

OPTIONS=(1 "1GB"
         2 "2GB"
         3 "3GB"
         4 "4GB"
         5 "5GB"
         6 "6GB"
         7 "7GB"
         8 "8GB"
         9 "Custom Amount")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
        1)
             ram_third=1
             script_creator_8
             chmod +x start.sh
             finalize
             ;;
        2)
             ram_third=2
             script_creator_8
             chmod +x start.sh
             finalize
             ;;
        3)
            ram_third=3
            script_creator_8
            chmod +x start.sh
            finalize
            ;;
        4)
            ram_third=4
            script_creator_8
            chmod +x start.sh
            finalize
             ;;
        5)
            ram_third=5
            script_creator_8
            chmod +x start.sh
            finalize
             ;;
        6)
            ram_third=6
            script_creator_8
            chmod +x start.sh
            finalize
            ;;
        7)
            ram_third=7
            script_creator_8
            chmod +x start.sh
            finalize
            ;;
        8)
            ram_third=8
            script_creator_8
            chmod +x start.sh
            finalize
            ;;
        9)
            custom_ram_8
            ;;
 esac

}


function custom_ram_8 {

ram=$(dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the amount of RAM you want to allocate" 8 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        ram_first=$(echo "${ram//B}")
        ram_second=$(echo "${ram_first//G}")
        ram_third=$(echo "${ram_second// /}")
        script_creator_8
        chmod +x start.sh
        finalize
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac
        
    
}

function script_creator_16 {
echo "function compare {" >> start.sh
echo "" >> start.sh
echo "    if grep -q 1.8.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=8" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
    
echo "    if grep -q 16.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=16" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh    
    
echo "    if grep -q 17.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=17 " >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
echo "    rm javaversion.txt" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh 
echo "" >> start.sh 
echo "function version_grab {" >> start.sh
echo "    java=$\"java -version"\" >> start.sh
echo "    \$java &> javaversion.txt" >> start.sh
echo "    compare" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "function check_current16 {" >> start.sh
echo "" >> start.sh
echo "    if [[ ! \$javaversion -eq "16" ]]" >> start.sh
echo "    then" >> start.sh
echo "        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '\$javaversion' selected, but Java 16 is required.\nChange it to Java 16 in the following menu' 10 60" >> start.sh
echo "        sudo update-alternatives --config java" >> start.sh
echo "    fi" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "version_grab" >> start.sh
echo "check_current16" >> start.sh
echo "" >> start.sh
echo "screen -S Minecraft java -Xmx$ram_third"G" -Xms512M -jar server.jar" >> start.sh
}

function select_ram_16 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=10
BACKTITLE="MC-Server Installer by realTM"
TITLE="Allocate RAM"
MENU="How much RAM do you want to allocate to your Minecraft Server?"

OPTIONS=(1 "1GB"
         2 "2GB"
         3 "3GB"
         4 "4GB"
         5 "5GB"
         6 "6GB"
         7 "7GB"
         8 "8GB"
         9 "Custom Amount")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
        1)
             ram_third=1
             script_creator_16
             chmod +x start.sh
             finalize
             ;;
        2)
             ram_third=2
             script_creator_16
             chmod +x start.sh
             finalize
             ;;
        3)
            ram_third=3
            script_creator_16
            chmod +x start.sh
            finalize
            ;;
        4)
            ram_third=4
            script_creator_16
            chmod +x start.sh
            finalize
             ;;
        5)
            ram_third=5
            script_creator_16
            chmod +x start.sh
            finalize
             ;;
        6)
            ram_third=6
            script_creator_16
            chmod +x start.sh
            finalize
            ;;
        7)
            ram_third=7
            script_creator_16
            chmod +x start.sh
            finalize
            ;;
        8)
            ram_third=8
            script_creator_16
            chmod +x start.sh
            finalize
            ;;
        9)
            custom_ram_16
            ;;
 esac

}


function custom_ram_16 {

ram=$(dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the amount of RAM you want to allocate" 8 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        ram_first=$(echo "${ram//B}")
        ram_second=$(echo "${ram_first//G}")
        ram_third=$(echo "${ram_second// /}")
        script_creator_16
        chmod +x start.sh
        finalize
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac
        
    
}

function script_creator_17 {
echo "function compare {" >> start.sh
echo "" >> start.sh
echo "    if grep -q 1.8.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=8" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
    
echo "    if grep -q 16.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=16" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh    
    
echo "    if grep -q 17.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=17 " >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
echo "    rm javaversion.txt" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh 
echo "" >> start.sh 
echo "function version_grab {" >> start.sh
echo "    java=$\"java -version"\" >> start.sh
echo "    \$java &> javaversion.txt" >> start.sh
echo "    compare" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "function check_current17 {" >> start.sh
echo "" >> start.sh
echo "    if [[ ! \$javaversion -eq "17" ]]" >> start.sh
echo "    then" >> start.sh
echo "        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '\$javaversion' selected, but Java 17 is required.\nChange it to Java 17 in the following menu' 10 60" >> start.sh
echo "        sudo update-alternatives --config java" >> start.sh
echo "    fi" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "version_grab" >> start.sh
echo "check_current17" >> start.sh
echo "" >> start.sh
echo "screen -S Minecraft java -Xmx$ram_third"G" -Xms512M -jar server.jar" >> start.sh
}


function select_ram_17 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=10
BACKTITLE="MC-Server Installer by realTM"
TITLE="Allocate RAM"
MENU="How much RAM do you want to allocate to your Minecraft Server?"

OPTIONS=(1 "1GB"
         2 "2GB"
         3 "3GB"
         4 "4GB"
         5 "5GB"
         6 "6GB"
         7 "7GB"
         8 "8GB"
         9 "Custom Amount")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
        1)
             ram_third=1
             script_creator_17
             chmod +x start.sh
             finalize
             ;;
        2)
             ram_third=2
             script_creator_17
             chmod +x start.sh
             finalize
             ;;
        3)
            ram_third=3
            script_creator_17
            chmod +x start.sh
            finalize
            ;;
        4)
            ram_third=4
            script_creator_17
            chmod +x start.sh
            finalize
             ;;
        5)
            ram_third=5
            script_creator_17
            chmod +x start.sh
            finalize
             ;;
        6)
            ram_third=6
            script_creator_17
            chmod +x start.sh
            finalize
            ;;
        7)
            ram_third=7
            script_creator_17
            chmod +x start.sh
            finalize
            ;;
        8)
            ram_third=8
            script_creator_17
            chmod +x start.sh
            finalize
            ;;
        9)
            custom_ram_17
            ;;
 esac

}


function custom_ram_17 {

ram=$(dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the amount of RAM you want to allocate" 8 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        ram_first=$(echo "${ram//B}")
        ram_second=$(echo "${ram_first//G}")
        ram_third=$(echo "${ram_second// /}")
        script_creator_17
        chmod +x start.sh
        finalize
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac
        
    
}

function finalize {

    echo "eula=true" > eula.txt
    dialog --msgbox "Your server has been installed to\nServers --> $dirname\n\nTo start it go to the folder with this command:\ncd Servers/$dirname \n\nand execute\n./start.sh" 15 60 
}

## Start of Function Blocks regarding Minecraft Forge:

function forge {

HEIGHT=50
WIDTH=80
CHOICE_HEIGHT=14
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the major Version you want to install:"

OPTIONS=(1 "1.7"
         2 "1.8"
         3 "1.9"
         4 "1.10"
         5 "1.11"
         6 "1.12"
         7 "1.13"
         8 "1.14"
         9 "1.15"
         10 "1.16"
         11 "1.17"
         12 "1.18"
         13 "1.19"
         14 "1.20")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            ver=1.7
            check_java8
            version_grab
            check_current8
            forge_vp_1.7
            ;;
        2)
            ver=1.8
            check_java8
            version_grab
            check_current8
            forge_vp_1.8
            ;;
        3)
            ver=1.9
            check_java8
            version_grab
            check_current8
            forge_vp_1.9
            ;;
        4)
            ver=1.10
            check_java8
            version_grab
            check_current8
            forge_vp_1.10
            ;;
        5)
            ver=1.11
            check_java8
            version_grab
            check_current8
            forge_vp_1.11
            ;;
        6)
            ver=1.12
            check_java8
            version_grab
            check_current8
            forge_vp_1.12
            ;;
        7)
            ver=1.13
            check_java8
            version_grab
            check_current8
            forge_vp_1.13
            ;;
        8)
            ver=1.14
            check_java8
            version_grab
            check_current8
            forge_vp_1.14
            ;;
        9)
            ver=1.15
            check_java8
            version_grab
            check_current8
            forge_vp_1.15
            ;;
        10)
            ver=1.16
            check_java8
            version_grab
            check_current8
            forge_vp_1.16
            ;;
        11)
            ver=1.17
            check_java16
            version_grab
            check_current16
            forge_vp_1.17
            ;;
        12)
            ver=1.18
            check_java17
            version_grab
            check_current17
            forge_vp_1.18
            ;;
        13)
            ver=1.19
            check_java17
            version_grab
            check_current17
            forge_vp_1.19
            ;;
        14)
            ver=1.20
            check_java17
            version_grab
            check_current17
            forge_vp_1.20
            ;;
esac    
    
}

function forge_vp_1.7 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.7.10")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.7.10
            ver=1.7.10
            forge_custom_version
            ;;

            
esac

}

function forge_vp_1.8 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.8"
         2 "1.8.8"
         3 "1.8.9")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.8
            ver=1.8
            forge_custom_version
            ;;
        2)
            #1.8.8
            ver=1.8.8
            forge_custom_version
            ;;
        3)
            #1.8.9
            ver=1.8.9
            forge_custom_version
            ;;

            
esac

}


function forge_vp_1.9 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.9"
         2 "1.9.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.9
            ver=1.9
            forge_custom_version
            ;;
        2)
            #1.9.4
            ver=1.9.4
            forge_custom_version
            ;;

            
esac

}

function forge_vp_1.10 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.10"
         2 "1.10.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.10
            ver=1.10
            forge_custom_version
            ;;
        2)
            #1.10.2
            ver=1.10.2
            forge_custom_version
            ;;

            
esac

}


function forge_vp_1.11 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.11"
         2 "1.11.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.11
            ver=1.11
            forge_custom_version
            ;;
        2)
            #1.11.2
            ver=1.11.2
            forge_custom_version
            ;;

            
esac

}

function forge_vp_1.12 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.12"
         2 "1.12.1"
         3 "1.12.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.12
            ver=1.12
            forge_custom_version
            ;;
        2)
            #1.12.1
            ver=1.12.1
            forge_custom_version
            ;;
        3)
            #1.12.2
            ver=1.12.2
            forge_custom_version
            ;;

            
esac

}


function forge_vp_1.13 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.13.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.13.2
            ver=1.13.2
            forge_custom_version
            ;;
esac

}


function forge_vp_1.14 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.14.2"
         2 "1.14.3"
         3 "1.14.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.14.2
            ver=1.14.2
            forge_custom_version
            ;;
        2)
            #1.14.3
            ver=1.14.3
            forge_custom_version
            ;;
        3)
            #1.14.4
            ver=1.14.4
            forge_custom_version
            ;;
esac

}


function forge_vp_1.15 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.15"
         2 "1.15.1"
         3 "1.15.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.15
            ver=1.15
            forge_custom_version
            ;;
        2)
            #1.15.1
            ver=1.15.1
            forge_custom_version
            ;;
        3)
            #1.15.2
            ver=1.15.2
            forge_custom_version
            ;;
esac

}


function forge_vp_1.16 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.16.1"
         2 "1.16.2"
         3 "1.16.3"
         4 "1.16.4"
         5 "1.16.5")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.16.1
            ver=1.16.1
            forge_custom_version
            ;;
        2)
            #1.16.2
            ver=1.16.2
            forge_custom_version
            ;;
        3)
            #1.16.3
            ver=1.16.3
            forge_custom_version
            ;;
        4)
            #1.16.4
            ver=1.16.4
            forge_custom_version
            ;;
        5)
            #1.16.5
            ver=1.16.5
            forge_custom_version
            ;;

esac

}


function forge_vp_1.17 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.17.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.17.1
            ver=1.17.1
            forge_custom_version
            ;;

esac

}

function forge_vp_1.18 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.18"
         2 "1.18.1"
         3 "1.18.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.18
            ver=1.18
            forge_custom_version
            ;;
        2)
            #1.18.1
            ver=1.18.1
            forge_custom_version
            ;;
        3)
            #1.18.2
            ver=1.18.2
            forge_custom_version
            ;;

esac

}


function forge_vp_1.19 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.19"
         2 "1.19.1"
         3 "1.19.2"
         4 "1.19.3"
         5 "1.19.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.19
            ver=1.19
            forge_custom_version
            ;;
        2)
            #1.19.1
            ver=1.19.1
            forge_custom_version
            ;;
        3)
            #1.19.2
            ver=1.19.2
            forge_custom_version
            ;;
        4)
            #1.19.3
            ver=1.19.3
            forge_custom_version
            ;;
        5)
            #1.19.4
            ver=1.19.4
            forge_custom_version
            ;;

esac

}

function forge_vp_1.20 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.20"
         2 "1.20.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.20
            ver=1.20
            forge_custom_version
            ;;
        2)
            #1.20.1
            ver=1.20.1
            forge_custom_version

esac

}

function folder_creator_forge {
cd Servers
basename="Forge-$ver"
dirname=$basename
i=1
while [ -d $dirname ]
do
  dirname=$basename-$i
  ((i++))
done
mkdir $dirname

}


function forge_installer_routine {
        forge_installer
        rm *installer.jar
        rm *.log
        mv *universal.jar server.jar
        mv forge*.jar server.jar
        ram_version_checker
}

function forge_new_installer_routine {
        forge_installer
        rm *installer.jar
        rm *.log
        new_select_ram_17
}

function new_select_ram_17 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=10
BACKTITLE="MC-Server Installer by realTM"
TITLE="Allocate RAM"
MENU="How much RAM do you want to allocate to your Minecraft Server?"

OPTIONS=(1 "1GB"
         2 "2GB"
         3 "3GB"
         4 "4GB"
         5 "5GB"
         6 "6GB"
         7 "7GB"
         8 "8GB"
         9 "Custom Amount")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
        1)
             ram_third=1
             forge_script_creator_17
             chmod +x start.sh
             finalize
             ;;
        2)
             ram_third=2
             forge_script_creator_17
             chmod +x start.sh
             finalize
             ;;
        3)
            ram_third=3
            forge_script_creator_17
            chmod +x start.sh
            finalize
            ;;
        4)
            ram_third=4
            forge_script_creator_17
            chmod +x start.sh
            finalize
             ;;
        5)
            ram_third=5
            forge_script_creator_17
            chmod +x start.sh
            finalize
             ;;
        6)
            ram_third=6
            forge_script_creator_17
            chmod +x start.sh
            finalize
            ;;
        7)
            ram_third=7
            forge_script_creator_17
            chmod +x start.sh
            finalize
            ;;
        8)
            ram_third=8
            forge_script_creator_17
            chmod +x start.sh
            finalize
            ;;
        9)
            forge_custom_ram_17
            ;;
 esac

}

function forge_custom_ram_17 {

ram=$(dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the amount of RAM you want to allocate" 8 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        ram_first=$(echo "${ram//B}")
        ram_second=$(echo "${ram_first//G}")
        ram_third=$(echo "${ram_second// /}")
        forge_script_creator_17
        finalize
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac
        
    
}

function forge_script_creator_17 {

    code=$(grep -o "$ver-[^/]*" run.sh)
    rm run.bat
    rm run.sh
    touch user_jvm_args.txt
echo "function compare {" >> start.sh
echo "" >> start.sh
echo "    if grep -q 1.8.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=8" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
    
echo "    if grep -q 16.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=16" >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh    
    
echo "    if grep -q 17.* javaversion.txt" >> start.sh
echo "    then" >> start.sh
echo "        javaversion=17 " >> start.sh
echo "    fi" >> start.sh
echo "" >> start.sh
echo "    rm javaversion.txt" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh 
echo "function check_java17 {" >> start.sh
echo "" >> start.sh
echo "    DIR=\"/usr/java/jdk-17/"\" >> start.sh
echo "    if [ ! -d \$DIR ]" >> start.sh
echo "    then" >> start.sh
echo "        java17" >> start.sh
echo "    fi" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh 
echo "function version_grab {" >> start.sh
echo "    java=$\"java -version"\" >> start.sh
echo "    \$java &> javaversion.txt" >> start.sh
echo "    compare" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "function check_current17 {" >> start.sh
echo "" >> start.sh
echo "    if [[ ! \$javaversion -eq "17" ]]" >> start.sh
echo "    then" >> start.sh
echo "        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '\$javaversion' selected, but Java 17 is required.\nChange it to Java 17 in the following menu' 10 60" >> start.sh
echo "        sudo update-alternatives --config java" >> start.sh
echo "    fi" >> start.sh
echo "}" >> start.sh
echo "" >> start.sh
echo "check_java17" >> start.sh
echo "version_grab" >> start.sh
echo "check_current17" >> start.sh
echo "" >> start.sh
echo "screen -S Minecraft java @user_jvm_args.txt @libraries/net/minecraftforge/forge/$code/unix_args.txt \"\$@"\" >> start.sh
    chmod +x start.sh
    echo "" >> user_jvm_args.txt
    echo "-Xms512M" >> user_jvm_args.txt
    echo "-Xmx$ram_third"G"" >> user_jvm_args.txt
}



function ram_version_checker {


    if [[ $ver = "1.17"* ]]
    then
        select_ram_17
    elif [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
    then
        select_ram_16
    else
        select_ram_8
    fi

}


function forge_installer {

    java -jar *.jar --installServer
}

function forge_new_version_check {
    if [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
    then
            folder_creator_forge
            cd Servers
            cd $dirname
            wget https://maven.minecraftforge.net/net/minecraftforge/forge/$ver-$forge_ex_version_number/forge-$ver-$forge_ex_version_number-installer.jar
            forge_new_installer_routine
    else
        normal_forge
    fi


}

function normal_forge {
        folder_creator_forge
        cd Servers
        cd $dirname
        if [[ $forge_ex_version_number = "11.15.1.1890" ]] || [[ $forge_ex_version_number = "11.15.1.1902" ]] || [[ $forge_ex_version_number = "11.15.1.2318" ]]
        then
            wget https://maven.minecraftforge.net/net/minecraftforge/forge/$ver-$forge_ex_version_number-$ver/forge-$ver-$forge_ex_version_number-$ver-installer.jar
        else
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/$ver-$forge_ex_version_number/forge-$ver-$forge_ex_version_number-installer.jar
        fi
        forge_installer_routine


}


function forge_custom_version {

forge_ex_version_number=$(dialog --title "Custom Forge Version" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the Forge version number you want to install (e.g. 45.0.43)\n\nThe exact Forge version number can be found here: https://files.minecraftforge.net/net/minecraftforge/forge/ \n" 12 80 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        forge_new_version_check
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed." 
esac

}


## Start of Spigot Functions

spigot () {

HEIGHT=50
WIDTH=80
CHOICE_HEIGHT=13
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the major Version you want to install:"

OPTIONS=(1 "1.8"
         2 "1.9"
         3 "1.10"
         4 "1.11"
         5 "1.12"
         6 "1.13"
         7 "1.14"
         8 "1.15"
         9 "1.16"
         10 "1.17"
         11 "1.18"
         12 "1.19"
         13 "1.20")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            ver=1.8
            check_java8
            version_grab
            check_current8
            spigot_vp_1.8
            ;;
        2)
            ver=1.9
            check_java8
            version_grab
            check_current8
            spigot_vp_1.9
            ;;
        3)
            ver=1.10
            check_java8
            version_grab
            check_current8
            spigot_vp_1.10
            ;;
        4)
            ver=1.11
            check_java8
            version_grab
            check_current8
            spigot_vp_1.11
            ;;
        5)
            ver=1.12
            check_java8
            version_grab
            check_current8
            spigot_vp_1.12
            ;;
        6)
            ver=1.13
            check_java8
            version_grab
            check_current8
            spigot_vp_1.13
            ;;
        7)
            ver=1.14
            check_java8
            version_grab
            check_current8
            spigot_vp_1.14
            ;;
        8)
            ver=1.15
            check_java8
            version_grab
            check_current8
            spigot_vp_1.15
            ;;
        9)
            ver=1.16
            check_java8
            version_grab
            check_current8
            spigot_vp_1.16
            ;;
        10)
            ver=1.17
            check_java16
            version_grab
            check_current16
            spigot_vp_1.17
            ;;
        11)
            ver=1.18
            check_java17
            version_grab
            check_current17
            spigot_vp_1.18
            ;;
        12)
            ver=1.19
            check_java17
            version_grab
            check_current17
            spigot_vp_1.19
            ;;
        13)
            ver=1.20
            check_java17
            version_grab
            check_current17
            spigot_vp_1.20
esac    
    
}

function spigot_vp_1.8 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.8"
         2 "1.8.3"
         3 "1.8.8")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.8
            ver=1.8
            spigot_installer_routine
            ;;
        2)
            #1.8.3
            ver=1.8.3
            spigot_installer_routine
            ;;
        3)
            #1.8.8
            ver=1.8.8
            spigot_installer_routine
            ;;

            
esac

}

function spigot_vp_1.9 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.9"
         2 "1.9.2"
		 3 "1.9.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.9
            ver=1.9
            spigot_installer_routine
            ;;
        2)
            #1.9.2
            ver=1.9.2
            spigot_installer_routine
            ;;
		3)
			#1.9.4
			ver=1.9.4
			spigot_installer_routine
			;;

            
esac

}

function spigot_vp_1.10 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.10.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.10.2
            ver=1.10.2
            spigot_installer_routine
            ;;

            
esac

}

function spigot_vp_1.11 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.11"
         2 "1.11.1"
		 3 "1.11.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.11
            ver=1.11
            latest_111=1
            spigot_installer_routine
            ;;
        2)
            #1.11.1
            ver=1.11.1
            spigot_installer_routine
            ;;
		3)
			#1.11.2
			ver=1.11.2
			spigot_installer_routine
			;;

            
esac

}

function spigot_vp_1.12 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.12"
         2 "1.12.1"
         3 "1.12.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.12
            ver=1.12
            spigot_installer_routine
            ;;
        2)
            #1.12.1
            ver=1.12.1
            spigot_installer_routine
            ;;
        3)
            #1.12.2
            ver=1.12.2
            spigot_installer_routine
            ;;

            
esac

}

function spigot_vp_1.13 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.13"
		 2 "1.13.1"
		 3 "1.13.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.13
            ver=1.13
            spigot_installer_routine
            ;;
		2)
			#1.13.1
			ver=1.13.1
			spigot_installer_routine
			;;
		3)
			#1.13.2
			ver=1.13.2
			spigot_installer_routine
			;;
esac

}

function spigot_vp_1.14 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.14"
         2 "1.14.1"
         3 "1.14.2"
		 4 "1.14.3"
		 5 "1.14.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.14
            ver=1.14
            spigot_installer_routine
            ;;
        2)
            #1.14.1
            ver=1.14.1
            spigot_installer_routine
            ;;
        3)
            #1.14.2
            ver=1.14.2
            spigot_installer_routine
            ;;
		4)
			#1.14.3
			ver=1.14.3
			spigot_installer_routine
			;;
		5)
			#1.14.4
			ver=1.14.4
			spigot_installer_routine
			;;
esac

}

function spigot_vp_1.15 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.15"
         2 "1.15.1"
         3 "1.15.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.15
            ver=1.15
            spigot_installer_routine
            ;;
        2)
            #1.15.1
            ver=1.15.1
            spigot_installer_routine
            ;;
        3)
            #1.15.2
            ver=1.15.2
            spigot_installer_routine
            ;;
esac

}

function spigot_vp_1.16 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.16.1"
         2 "1.16.2"
         3 "1.16.3"
         4 "1.16.4"
         5 "1.16.5")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.16.1
            ver=1.16.1
            spigot_installer_routine
            ;;
        2)
            #1.16.2
            ver=1.16.2
            spigot_installer_routine
            ;;
        3)
            #1.16.3
            ver=1.16.3
            spigot_installer_routine
            ;;
        4)
            #1.16.4
            ver=1.16.4
            spigot_installer_routine
            ;;
        5)
            #1.16.5
            ver=1.16.5
            spigot_installer_routine
            ;;

esac

}

function spigot_vp_1.17 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.17"
         2 "1.17.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.17
            ver=1.17
            spigot_installer_routine
            ;;
		2)
			#1.17.1
			ver=1.17.1
			spigot_installer_routine
			;;

esac

}

function spigot_vp_1.18 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.18"
         2 "1.18.1"
         3 "1.18.2")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.18
            ver=1.18
            spigot_installer_routine
            ;;
        2)
            #1.18.1
            ver=1.18.1
            spigot_installer_routine
            ;;
        3)
            #1.18.2
            ver=1.18.2
            spigot_installer_routine
            ;;

esac

}

function spigot_vp_1.19 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.19"
         2 "1.19.1"
         3 "1.19.2"
         4 "1.19.3"
         5 "1.19.4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.19
            ver=1.19
            spigot_installer_routine
            ;;
        2)
            #1.19.1
            ver=1.19.1
            spigot_installer_routine
            ;;
        3)
            #1.19.2
            ver=1.19.2
            spigot_installer_routine
            ;;
        4)
            #1.19.3
            ver=1.19.3
            spigot_installer_routine
            ;;
        5)
            #1.19.4
            ver=1.19.4
            spigot_installer_routine
            ;;

esac

}

function spigot_vp_1.20 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.20.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            #1.20.1
            ver=1.20.1
            spigot_installer_routine
            ;;

esac

}

compiled_folder () {
    
    if [[ ! $disable = true ]]
    then
        if [[ ! -d $path/.compiled ]]
        then
            mkdir .compiled
        fi
    fi

}

function folder_creator_spigot {
cd Servers
basename="Spigot-$ver"
dirname=$basename
i=1
while [ -d $dirname ]
do
  dirname=$basename-$i
  ((i++))
done
mkdir $dirname

}

download_buildtools () {

    cd $dirname
    mkdir BuildTools
    cd BuildTools
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
    git config --global --unset core.autocrlf

}

install_spigot () {
    dialog --title 'MC-Server Installer by realTM' --msgbox ' \nYour Spigot.jar will now be compiled. \nThis process can take several minutes! ' 10 60
    clear
    java -jar BuildTools.jar --rev $ver
    if [[ $disable = true ]]
    then
        cd $path/Servers/$dirname
        rm -R BuildTools
    else
        mv spigot-$ver.jar $path/.compiled
        cd $path/Servers/$dirname
        rm -R BuildTools
    fi
}

setup_spigot_server () {

        if [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
        then
            required_java=17
            select_ram_17
        elif [[ $ver = "1.17" ]] || [[ $ver = "1.17.1" ]]
        then
            required_java=16
            select_ram_16
        else
            required_java=8
            select_ram_8
        fi


}

move_files () {

    if [[ $disable = true ]]
    then
        cd $path/Servers/$dirname
        mv spigot-$ver.jar server.jar
    else
        cp $path/.compiled/spigot-$ver.jar $path/Servers/$dirname
        cd $path/Servers/$dirname
        mv spigot-$ver.jar server.jar
    fi
}

test_existence () {
    
    if [[ -e $path/.disable_spigot_archive ]]
    then
        download_buildtools
        install_spigot
        move_files
        setup_spigot_server
    else
        if [[ ! -e $path/.compiled/spigot-$ver.jar ]]
        then
            download_buildtools
            install_spigot
            move_files
            setup_spigot_server
        else
            move_files
            setup_spigot_server
        fi
    fi


}

spigot_installer_routine () {
    ## Main Spigot function ##
    cd $path
    if [[ -e $path/.disable_spigot_archive ]]
    then
        disable=true
    fi
    compiled_folder
    folder_creator_spigot
    test_existence
}

## End of Spigot Functions

## Start of Paper Functions

paper () {

HEIGHT=22
WIDTH=80
CHOICE_HEIGHT=15
BACKTITLE="MC-Server Installer by realTM"
TITLE="Select Version"
MENU="For which Minecraft Version do you want to install Paper?"

OPTIONS=(1 "1.8.8"
         2 "1.9.4"
         3 "1.10.2"
         4 "1.11.2"
         5 "1.12.2"
         6 "1.13.2"
         7 "1.14.4"
         8 "1.15.2"
         9 "1.16.5"
         10 "1.17.1"
         11 "1.18.2"
         12 "1.19.3"
         13 "1.19.4"
         14 "1.20"
         15 "1.20.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
 case $CHOICE in
        1)
             version=1.8.8
             check_java8
             version_grab
             check_current8
             create_json
             ;;
        2)
             version=1.9.4
             check_java8
             version_grab
             check_current8
             create_json
             ;;
        3)
            version=1.10.2
            check_java8
            version_grab
            check_current8
             create_json
            ;;
        4)
            version=1.11.2
            check_java8
            version_grab
            check_current8
             create_json
             ;;
        5)
            version=1.12.2
            check_java8
            version_grab
            check_current8
             create_json
             ;;
        6)
            version=1.13.2
            check_java8
            version_grab
            check_current8
             create_json
            ;;
        7)
            version=1.14.4
            check_java8
            version_grab
            check_current8
             create_json
            ;;
        8)
            version=1.15.2
            check_java8
            version_grab
            check_current8
             create_json
            ;;
        9)
            version=1.16.5
            check_java8
            version_grab
            check_current8
             create_json
            ;;
        10)
            version=1.17.1
            version_grab
            check_java16
            check_current16
            create_json
            ;;
        11)
            version=1.18.2
            version_grab
            check_java17
            check_current17
            create_json
            ;;
        12)
            version=1.19.3
            version_grab
            check_java17
            check_current17
            create_json
            ;;
        13)
            version=1.19.4
            version_grab
            check_java17
            check_current17
            create_json
            ;;
        14)
            version=1.20
            version_grab
            check_java17
            check_current17
            create_json
            ;;
        15)
            version=1.20.1
            version_grab
            check_java17
            check_current17
            create_json
            ;;
 esac


}

create_json () {
  curl -X 'GET' \
  'https://api.papermc.io/v2/projects/paper/versions/'$version'' -s \
  -H 'accept: application/json' > builds.json
  set_build
}

set_build () {
HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Select Build Number"
MENU="Which Build of Paper do you want to install?"

OPTIONS=(1 "I already know the exact build number"
         2 "Show me the available builds")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            build_input
            ;;
        2)
            show_builds
            ;;            
esac
}

build_input () {

  build=$(dialog --title "Enter Build Number" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the Build number you want to install " 10 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        create_array
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
        echo "[ESC] key pressed."
        ;;
esac

}

show_builds () {

    input=$(cat builds.json)
    rm $path/builds.json
    builds=($(echo "$input" | jq -r '.builds[]'))
    menu_items=()
    for number in "${builds[@]}"; do
      menu_items+=("$number" "$number")
    done

  build=$(dialog --clear \
                  --no-tags \
                  --backtitle "MC-Server Installer by realTM" \
                  --title "Select Build Number" \
                  --menu "Select the Build number you want to install:" \
                  0 0 0 \
                  "${menu_items[@]}" \
                  2>&1 >/dev/tty)
  check_existing
}


create_array () {
    input=$(cat builds.json)
    rm $path/builds.json
    builds=($(echo "$input" | jq -r '.builds[]'))
    check_existing
}

check_existing () {
  if [[ " ${builds[@]} " =~ " $build " ]]; then
  folder_creator_paper
  download_jar
  else
  dialog --msgbox "The build number you've entered does not exist." 7 60
  build_input
  fi
  exit
}

function folder_creator_paper {
cd Servers
basename="Paper-"$version"_Build-$build"
dirname=$basename
i=1
while [ -d $dirname ]
do
  dirname=$basename-"($i)"
  ((i++))
done
mkdir $dirname

}

download_jar () {
    
    cd $path/Servers/$dirname
    wget https://api.papermc.io/v2/projects/paper/versions/$version/builds/$build/downloads/paper-$version-$build.jar
    mv paper*.jar server.jar
    paper_ram_selector
}

paper_ram_selector () {

    if [[ $version = "1.17"* ]]
    then
        select_ram_16
    elif [[ $version = "1.18"* ]] || [[ $version = "1.19"* ]] || [[ $version = "1.20"* ]]
    then
        select_ram_17
    else
        select_ram_8
    fi



}

## End of Paper Funcitons

## END OF FUNCTIONS

## Startup Function

function installer_box {

    clear
    dialog --title "Required Programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "The following programs will be installed (or upgraded if they are already installed)\n \n- dialog\n- python3\n- python3-pip\n- pip3 packaging\n- wget\n- screen\n- sudo\n- jq " 15 60

    response=$?
    case $response in
        0) installer_routine;;
        1) exit_routine;;
        255) echo "[ESC] key pressed.";;
    esac
}

function exit_routine {
    exit
    clear
}

function installer_routine {
    touch .installed
    clear
    apt install dialog python3 python3-pip wget screen sudo jq -y
    pip3 install packaging
    
}


function installed_check {
    if [[ ! -e .installed ]]
    then
        installer_box
    fi
}


update_dialog () {

    dialog --title 'Update' --msgbox '        To update execute: \n\n            git pull' 9 40
    exit

}

update_needed () {

dialog --title "Outdated Script detected!" \
--backtitle "MC-Server Installer by realTM" \
--yesno "There is an update available \n\nInstalled Version: $scriptversion \nLatest Version: $latestver\n\nDo you want to update the script?" 10 60

response2=$?
case $response2 in
   0) update_dialog ;;
   1) ;;
   255) echo "[ESC] key pressed.";;
esac

}

function pathfinder {

    path=$(pwd)
}

function dialog_check {  
        apt-cache policy dialog > dialog.txt
        if grep -q none dialog.txt
        then
            apt install dialog -y   
            rm dialog.txt
        else
            rm dialog.txt    
        fi
}


distro_check () {

    if [[ ! -e .skip_distro_check ]]
    then
        ubuntuver=$(lsb_release -r)
        if [[ $ubuntuver == *"18.04" ]] || [[ $ubuntuver == *"20.04" ]] || [[ $ubuntuver == *"22.04" ]]
        then
            ubuntu=true
        else
            current_version=$(</etc/debian_version)
            if [[ ! $current_version  == "10"* ]]
            then
                if [[ ! $current_version == "11"* ]]
                then
                    echo "Your Linux Distribution is not supported."
                    exit
                fi 
            fi
        fi
    fi

}

## Script Version
scriptversion="8.3"
##

## Latest Version
latestver=$(curl -s https://version.realtm.de)
##

compare_version () {

if [[ ! -e .skip_version_check ]]
then
    if [[ ! $latestver = $scriptversion ]]
        then
            update_needed
    fi
fi

}

function servers_folder {

    if [[ ! -d Servers ]]
    then
        cd $path
        mkdir Servers
    fi
}

function curl_check {  
        apt-cache policy curl > curl.txt
        if grep -q none curl.txt
        then
            apt install curl -y   
            rm curl.txt
        else
            rm curl.txt    
        fi
}


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
else
    clear
    distro_check
    dialog_check
    compare_version
    installed_check
    pathfinder
    servers_folder
    choose_type
fi

## End of Startup function
