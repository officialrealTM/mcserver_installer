#!/bin/bash

## START OF FUNCTIONS

function only_wget {
    echo "Only wget"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nwget" 7 60

    response=$?
    case $response in
        0) clear && apt install wget -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}

function only_screen {
    echo "Only Screen"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nscreen" 7 60

    response=$?
    case $response in
        0) clear && apt install screen -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}

function only_sudo {
    echo "Only screen"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nsudo" 9 60

    response=$?
    case $response in
        0) clear && apt install sudo -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}

function wget_screen {
    echo "wget screen"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nwget\nscreen" 9 60

    response=$?
    case $response in
        0) clear && apt install wget screen -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}

function wget_sudo {
    echo "wget sudo"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nwget\nsudo" 9 60

    response=$?
    case $response in
        0) clear && apt install wget sudo -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}


function screen_sudo {
    echo "screen sudo"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nscreen\nsudo" 9 60

    response=$?
    case $response in
        0) clear && apt install screen sudo -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}


function wget_screen_sudo {
    echo "wget screen sudo"
    clear
    dialog --title "Install required programs" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "Do you want the following programs to be installed:\n \nwget\nscreen\nsudo" 10 60

    response=$?
    case $response in
        0) clear && apt install wget screen sudo -y && success;;
        1) decline;;
        255) echo "[ESC] key pressed.";;
    esac
}


function success {

    dialog --infobox "All required programs have been installed!" 3 60
    sleep 3
    choose_type
}


function fine {

    dialog --infobox "All required programs are already installed!" 3 60
    sleep 3
    choose_type
}

function decline {

    clear
    dialog --title "Error" \
    --backtitle "MC-Server Installer by realTM" \
    --yesno "These programs are required for the script to work! \nDo you want to install them?" 10 60

    response=$?
    case $response in
        0) not_installed;;
        1) clear && exit;;
        255) echo "[ESC] key pressed.";;
    esac
}


function not_installed {
echo "func not installed"
## first run
    if [ $wget = 1 ] && [ $screen = 0 ] && [ $sudo = 0 ] 
    then
        only_wget
    fi

    if [ $wget = 0 ] && [ $screen = 1 ] && [ $sudo = 0 ]
    then
        only_screen
    fi

    if [ $wget = 0 ] && [ $screen = 0 ] && [ $sudo = 1 ]
    then
        only_sudo
    fi

## second run
    if [ $wget = 1 ] && [ $screen = 1 ] && [ $sudo = 0 ]
    then
        wget_screen
    fi

    if [ $wget = 1 ] && [ $screen = 0 ] && [ $sudo = 1 ]
    then
        wget_sudo
    fi
## third run
    if [ $wget = 1 ] && [ $screen = 1 ] && [ $sudo = 1 ]
    then
        wget_screen_sudo
    fi 

## forth run
    if [ $wget = 0 ] && [ $screen = 1 ] && [ $sudo = 1 ]
    then
        screen_sudo
    fi

## all installed
    if [ $wget = 0 ] && [ $screen = 0 ] && [ $sudo = 0 ]
    then
        fine
    fi    
}


function checker {
    wget=0
    screen=0
    sudo=0
    if grep -q none wget.txt
    then
        wget=1   
        rm wget.txt
    else
        rm wget.txt    
    fi

    if grep -q none screen.txt
    then
        echo "Screen not found"
        screen=1
        rm screen.txt
    else
        rm screen.txt
    fi

    if grep -q none sudo.txt
    then
        sudo=1
        rm sudo.txt
    else
        rm sudo.txt
    fi
    echo "not installed"
    not_installed
}



function startup {

## check

apt-cache policy wget > wget.txt
apt-cache policy screen > screen.txt
apt-cache policy sudo > sudo.txt
dialog --infobox "Checking if required programs are installed..." 3 60
sleep 3
checker
}


function choose_type {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=4
BACKTITLE="MC-Server Installer by realTM"
TITLE="Minecraft Server Type"
MENU="Select the type of Minecraft Server you want to install:"

OPTIONS=(1 "Minecraft Vanilla"
         2 "Minecraft Forge")

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
 esac

}


function vanilla {

dialog --title "Choose Version" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the version number you want to install (e.g 1.8.9) " 8 60 2>mcversions.txt
version=0
version=$(<mcversions.txt)
ver=$(<mcversions.txt)
version=$(echo $version | sed -e 's/\.//g')
rm mcversions.txt
# get respose
respose=$?

# get data stored in $ram using input redirection

# make a decsion
case $respose in
  0)
        compare_exit
        ;;
  1)
        echo "Cancel pressed."
        exit
        ;;
  255)
        echo "[ESC] key pressed."
        exit
        ;;
esac
        
    
}

function proof {

    if [ $new_version -ge 170 ]
    then
        check_valid
    else
        not_supported
    fi
}

function second_check {

    if [[ $new_version -le 164 ]]
    then
        not_supported
    else
        check_valid
    fi
}

function third_check {

    if [[ $version -ge 171 ]]
    then
        check_valid
    else
        not_supported
    fi
}

function multiply {

    if [[ $version -le 119 ]]
    then
        new_version=$(( $version*10 ))
        echo $new_version
        second_check
    else
        third_check
       
    fi
}

function tester {

if [[ $version -lt 17 ]]
then    
    not_supported
    
else
    multiply
fi
}

function compare_exit {

    if [[ $version -eq 0 ]]
    then
        clear
    else
        tester
    fi
}

function not_supported {
    dialog --title 'MC-Server Installer by realTM' --msgbox ' \nThe version number entered is not supported by this script!\nSupported Versions: 1.7 and above ' 10 60
    clear
    vanilla

}

function java_selector {

    if [ $ver = "1.17" ] || [ $ver = "1.17.1" ]
    then
        check_java16
        version_grab
        check_current16
        dl=$(python3 mcurlgrabber.py server-url $ver)
        cd Minecraft
        wget $dl
        sleep 1
        select_ram
    elif [ $ver = "1.18" ] ||  [ $ver = "1.18.1" ] ||  [ $ver = "1.18.2" ] || [ $ver = "1.19" ]
    then
        check_java17
        version_grab
        check_current17
        dl=$(python3 mcurlgrabber.py server-url $ver)
        cd Minecraft
        wget $dl
        sleep 1
        select_ram
    else
        check_java8
        version_grab
        check_current8
        dl=$(python3 mcurlgrabber.py server-url $ver)
        cd Minecraft
        wget $dl
        sleep 1
        select_ram
    fi

}

function check_valid {
    python3 mcurlgrabber.py server-url $ver
    if [ $? -eq 1 ]
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

    if [ $javaversion -eq 8 ]
    then
        echo ""
    else
        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '$javaversion' selected, but Java 8 is required.\nChange it to Java 8 in the following menu' 10 60
        sudo update-alternatives --config java
    fi
}

function check_current16 {

    if [ $javaversion -eq 16 ]
    then
        echo ""
    else
        dialog --title 'MC-Server Installer by realTM' --msgbox 'You currently have Java '$javaversion' selected, but Java 16 is required.\nChange it to Java 16 in the following menu' 10 60
        sudo update-alternatives --config java
    fi
}

function check_current17 {

    if [ $javaversion -eq 17 ]
    then
        echo ""
    else
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

    DIR="/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64/"
    if [ -d $DIR ]
    then
        echo ""
    else
        java8
    fi
}

function check_java16 {

DIR="/usr/java/jdk-16*"
    if [ -d $DIR ]
    then
        echo ""
    else
        java16
    fi

}

function check_java17 {

    DIR="/usr/java/jdk-17/"
    if [ -d $DIR ]
    then
        echo ""
    else
        java17
    fi
}

function install_java8 {
    dialog --infobox "Java 8 will be installed now" 10 30 && sleep 3
    clear
    apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
    apt update
    apt install adoptopenjdk-8-hotspot -y
    sudo update-alternatives --config java
    sleep 5
    clear
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


function select_ram {

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
             echo "screen -S Minecraft java -Xmx1G -Xms512M -jar server.jar" > start.sh
             chmod +x start.sh
             finalize
             ;;
        2)
             echo "screen -S Minecraft java -Xmx2G -Xms512M -jar server.jar" > start.sh
             chmod +x start.sh
             finalize
             ;;
        3)
            echo "screen -S Minecraft java -Xmx3G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
            ;;
        4)
            echo "screen -S Minecraft java -Xmx4G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
             ;;
        5)
            echo "screen -S Minecraft java -Xmx5G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
             ;;
        6)
            echo "screen -S Minecraft java -Xmx6G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
            ;;
        7)
            echo "screen -S Minecraft java -Xmx7G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
            ;;
        8)
            echo "screen -S Minecraft java -Xmx8G -Xms512M -jar server.jar" > start.sh
            chmod +x start.sh
            finalize
            ;;
        9)
            custom_ram
            ;;
 esac

}


function custom_ram {

dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter Amount\n(Use this format: 1GB = 1G) " 8 60 2>ram.txt
ram=$(<ram.txt)
rm ram.txt
# get respose
respose=$?

# get data stored in $ram using input redirection

# make a decsion
case $respose in
  0)
        echo "screen -S Minecraft java -Xmx$ram -Xms512M -jar server.jar" > start.sh
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
    echo "To start your server execute ./start.sh"
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

function distro_check {
   if ! grep -q 10 /etc/debian_version
   then
        echo "This script is only working on Debian 10!"
        exit
    fi
}

## Start of Function Blocks regarding Minecraft Forge:

function forge {

HEIGHT=50
WIDTH=80
CHOICE_HEIGHT=13
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
         11 "1.17")
        #  12 "1.18"
        #  13 "1.19")

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
            check_java8
            version_grab
            check_current8
            forge_vp_1.7
            ;;
        2)
            check_java8
            version_grab
            check_current8
            forge_vp_1.8
            ;;
        3)
            check_java8
            version_grab
            check_current8
            forge_vp_1.9
            ;;
        4)
            check_java8
            version_grab
            check_current8
            forge_vp_1.10
            ;;
        5)
            check_java8
            version_grab
            check_current8
            forge_vp_1.11
            ;;
        6)
            check_java8
            version_grab
            check_current8
            forge_vp_1.12
            ;;
        7)
            check_java8
            version_grab
            check_current8
            forge_vp_1.13
            ;;
        8)
            check_java8
            version_grab
            check_current8
            forge_vp_1.14
            ;;
        9)
            check_java8
            version_grab
            check_current8
            forge_vp_1.15
            ;;
        10)
            check_java8
            version_grab
            check_current8
            forge_vp_1.16
            ;;
        11)
            check_java16
            version_grab
            check_current16
            forge_vp_1.17
            ;;
        12)
            check_java17
            version_grab
            check_current17
            forge_vp_1.18
            ;;
        13)
            check_java17
            version_grab
            check_current17
            forge_vp_1.19
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
            latest_1710=1
            forge_version_picker
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
            latest_18=1
            forge_version_picker
            ;;
        2)
            #1.8.8
            latest_188=1
            forge_version_picker
            ;;
        3)
            #1.8.9
            latest_189=1
            forge_version_picker
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
            latest_19=1
            forge_version_picker
            ;;
        2)
            #1.9.4
            latest_194=1
            forge_version_picker
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
            latest_110=1
            forge_version_picker
            ;;
        2)
            #1.10.2
            latest_1102=1
            forge_version_picker
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
            latest_111=1
            forge_version_picker
            ;;
        2)
            #1.11.2
            latest_1112=1
            forge_version_picker
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
            latest_111=1
            forge_version_picker
            ;;
        2)
            #1.12.1
            latest_1112=1
            forge_version_picker
            ;;
        3)
            #1.12.2
            latest_1122=1
            forge_version_picker
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
            latest_1132=1
            forge_version_picker
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
            latest_1142=1
            forge_version_picker
            ;;
        2)
            #1.14.3
            latest_1143=1
            forge_version_picker
            ;;
        3)
            #1.14.4
            latest_1144=1
            forge_version_picker
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
            latest_115=1
            forge_version_picker
            ;;
        2)
            #1.15.1
            latest_1151=1
            forge_version_picker
            ;;
        3)
            #1.15.2
            latest_1152=1
            forge_version_picker
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
            latest_1161=1
            forge_version_picker
            ;;
        2)
            #1.16.2
            latest_1162=1
            forge_version_picker
            ;;
        3)
            #1.16.3
            latest_1163=1
            forge_version_picker
            ;;
        4)
            #1.16.4
            latest_1164=1
            forge_version_picker
            ;;
        5)
            #1.16.5
            latest_1165=1
            forge_version_picker
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
            latest_1171=1
            forge_version_picker
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
            latest_118=1
            forge_version_picker
            ;;
        2)
            #1.18.1
            latest_1181=1
            forge_version_picker
            ;;
        3)
            #1.18.2
            latest_1182=1
            forge_version_picker
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

OPTIONS=(1 "1.19")

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
            latest_119=1
            forge_version_picker
            ;;

esac

}


function forge_version_picker {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=10
BACKTITLE="MC-Server Installer by realTM"
TITLE="Forge-Version Picket"
MENU="Which Forge Version should be installed?"

OPTIONS=(1 "Latest"
         2 "Custom")

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
             latest_forge
             ;;
        2)
            forge_custom_version
            ;;
esac
}


function latest_forge {

    if [ $latest_1710 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.7.2-10.12.2.1161-mc172/forge-1.7.2-10.12.2.1161-mc172-installer.jar
        forge_installer_routine
    

    elif [ $latest_18 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.8-11.14.4.1577/forge-1.8-11.14.4.1577-installer.jar
        forge_installer_routine
    

    elif [ $latest_188 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.8.8-11.15.0.1655/forge-1.8.8-11.15.0.1655-installer.jar
        forge_installer_routine
  

    elif [ $latest_189 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.8.9-11.15.1.2318-1.8.9/forge-1.8.9-11.15.1.2318-1.8.9-installer.jar
        forge_installer_routine
   

    elif [ $latest_19 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.9-12.16.1.1938-1.9.0/forge-1.9-12.16.1.1938-1.9.0-installer.jar
        forge_installer_routine
    

    elif [ $latest_194 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.9.4-12.17.0.2317-1.9.4/forge-1.9.4-12.17.0.2317-1.9.4-installer.jar
        forge_installer_routine
    

    elif [ $latest_110 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.10-12.18.0.2000-1.10.0/forge-1.10-12.18.0.2000-1.10.0-installer.jar
        forge_installer_routine
    

    elif [ $latest_1102 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.10.2-12.18.3.2511/forge-1.10.2-12.18.3.2511-installer.jar
        forge_installer_routine
    

    elif [ $latest_111 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.11-13.19.1.2199/forge-1.11-13.19.1.2199-installer.jar
        forge_installer_routine
    

    elif [ $latest_1112 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.11.2-13.20.1.2588/forge-1.11.2-13.20.1.2588-installer.jar
        forge_installer_routine
    

    elif [ $latest_112 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.12-14.21.1.2443/forge-1.12-14.21.1.2443-installer.jar
        forge_installer_routine
    

    elif [ $latest_1121 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.1-14.22.1.2485/forge-1.12.1-14.22.1.2485-installer.jar
        forge_installer_routine
    

    elif [ $latest_1122 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2860/forge-1.12.2-14.23.5.2860-installer.jar
        forge_installer_routine
    

    elif [ $latest_1132 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.13.2-25.0.223/forge-1.13.2-25.0.223-installer.jar
        forge_installer_routine
    

    elif [ $latest_1142 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.14.2-26.0.63/forge-1.14.2-26.0.63-installer.jar
        forge_installer_routine
    

    elif [ $latest_1143 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.14.3-27.0.60/forge-1.14.3-27.0.60-installer.jar
        forge_installer_routine
    

    elif [ $latest_1144 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.14.4-28.2.26/forge-1.14.4-28.2.26-installer.jar
        forge_installer_routine
    

    elif [ $latest_115 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.15-29.0.4/forge-1.15-29.0.4-installer.jar
        forge_installer_routine
    

    elif [ $latest_1151 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.15.1-30.0.51/forge-1.15.1-30.0.51-installer.jar
        forge_installer_routine
    

    elif [ $latest_1152 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.15.2-31.2.57/forge-1.15.2-31.2.57-installer.jar
        forge_installer_routine
    

    elif [ $latest_1161 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.1-32.0.108/forge-1.16.1-32.0.108-installer.jar
        forge_installer_routine
    

    elif [ $latest_1162 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.2-33.0.61/forge-1.16.2-33.0.61-installer.jar
        forge_installer_routine
    

    elif [ $latest_1163 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.3-34.1.42/forge-1.16.3-34.1.42-installer.jar
        forge_installer_routine
    

    elif [ $latest_1164 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.4-35.1.37/forge-1.16.4-35.1.37-installer.jar
        forge_installer_routine
    

    elif [ $latest_1165 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.35/forge-1.16.5-36.2.35-installer.jar
        forge_installer_routine
    

    elif [ $latest_1171 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.17.1-37.1.1/forge-1.17.1-37.1.1-installer.jar
        forge_installer_routine
    

    elif [ $latest_118 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.18-38.0.17/forge-1.18-38.0.17-installer.jar
        forge_installer_routine
    

    elif [ $latest_1181 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.1-39.1.2/forge-1.18.1-39.1.2-installer.jar
        forge_installer_routine
    

    elif [ $latest_1182 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.2-40.1.51/forge-1.18.2-40.1.51-installer.jar
        forge_installer_routine
    

    elif [ $latest_119 -eq 1 ]
    then
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.19-41.0.38/forge-1.19-41.0.38-installer.jar
        forge_installer_routine
    fi
}

function forge_installer_routine {

        forge_installer
        rm *installer.jar
        rm *.log
        mv *universal.jar server.jar
        select_ram
}


function forge_installer {

    java -jar *.jar --installServer
}

function forge_custom_version {

    dialog --title "Define RAM" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the Versionnumber you want to install: " 8 60 2>forge_v_number.txt
forge_ex_version_number=$(<forge_v_number.txt)
rm forge_v_number.txt
# get respose
respose=$?

# get data stored in $forge_v_number using input redirection

# make a decsion
case $respose in
  0)
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/$forge_version_number-$forge_ex_version_number/forge-$forge_version_number-$forge_ex_version_number-installer.jar
        forge_installer_routine
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac

}

## END OF FUNCTIONS

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
else
    clear
    distro_check
    dialog_check
    mkdir Minecraft
    pathfinder
    startup
fi