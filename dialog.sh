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
HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
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
         12 "1.18")

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
            vp_1.7
            ;;
        2)
            check_java8
            vp_1.8
            ;;
        3)
            check_java8
            vp_1.9
            ;;
        4)
            check_java8
            vp_1.10
            ;;
        5)
            check_java8
            vp_1.11
            ;;
        6)
            check_java8
            vp_1.12
            ;;
        7)
            check_java8
            vp_1.13
            ;;
        8)
            check_java8
            vp_1.14
            ;;
        9)
            check_java8
            vp_1.15
            ;;
        10)
            check_java8
            vp_1.16
            ;;
        11)
            check_java16
            vp_1.17
            ;;
        12)
            check_java17
            vp_1.18
            ;;
esac    

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


function vp_1.7 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.7"
         2 "1.7.1"
         3 "1.7.2"
         4 "1.7.3"
         5 "1.7.4"
         6 "1.7.5"
         7 "1.7.6"
         8 "1.7.7"
         9 "1.7.8"
         10 "1.7.9"
         11 "1.7.10")

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
            #1.7
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3f031ab8b9cafedeb822febe89d271b72565712c/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.7.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/d26d79675147253b7a35dd32dc5dbba0af1be7e2/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.7.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3716cac82982e7c2eb09f83028b555e9ea606002/server.jar
            sleep 1
            select_ram
            ;;
        4)
            #1.7.3
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/707857a7bc7bf54fe60d557cca71004c34aa07bb/server.jar
            sleep 1
            select_ram
            ;;
        5)
            #1.7.4
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/61220311cef80aecc4cd8afecd5f18ca6b9461ff/server.jar
            sleep 1
            select_ram
            ;;
        6)
            #1.7.5
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/e1d557b2e31ea881404e41b05ec15c810415e060/server.jar
            sleep 1
            select_ram
            ;;
        7)
            #1.7.6
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/41ea7757d4d7f74b95fc1ac20f919a8e521e910c/server.jar
            sleep 1
            select_ram
            ;;
        8)
            #1.7.7
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a6ffc1624da980986c6cc12a1ddc79ab1b025c62/server.jar
            sleep 1
            select_ram
            ;;
        9)
            #1.7.8
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/c69ebfb84c2577661770371c4accdd5f87b8b21d/server.jar
            sleep 1
            select_ram
            ;;
        10)
            #1.7.9
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/4cec86a928ec171fdc0c6b40de2de102f21601b5/server.jar
            sleep 1
            select_ram
            ;;
        11)
            #1.7.10
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/952438ac4e01b4d115c5fc38f891710c4941df29/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.8 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.8"
         2 "1.8.1"
         3 "1.8.2"
         4 "1.8.3"
         5 "1.8.4"
         6 "1.8.5"
         7 "1.8.6"
         8 "1.8.7"
         9 "1.8.8"
         10 "1.8.9")

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a028f00e678ee5c6aef0e29656dca091b5df11c7/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.8.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/68bfb524888f7c0ab939025e07e5de08843dac0f/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.8.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a37bdd5210137354ed1bfe3dac0a5b77fe08fe2e/server.jar
            sleep 1
            select_ram
            ;;
        4)
            #1.8.3
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/163ba351cb86f6390450bb2a67fafeb92b6c0f2f/server.jar
            sleep 1
            select_ram
            ;;
        5)
            #1.8.4
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/dd4b5eba1c79500390e0b0f45162fa70d38f8a3d/server.jar
            sleep 1
            select_ram
            ;;
        6)
            #1.8.5
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/ea6dd23658b167dbc0877015d1072cac21ab6eee/server.jar
            sleep 1
            select_ram
            ;;
        7)
            #1.8.6
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/2bd44b53198f143fb278f8bec3a505dad0beacd2/server.jar
            sleep 1
            select_ram
            ;;
        8)
            #1.8.7
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/35c59e16d1f3b751cd20b76b9b8a19045de363a9/server.jar
            sleep 1
            select_ram
            ;;
        9)
            #1.8.8
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/5fafba3f58c40dc51b5c3ca72a98f62dfdae1db7/server.jar
            sleep 1
            select_ram
            ;;
        10)
            #1.8.9
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar
            sleep 1
            select_ram
            ;;
esac

}

function vp_1.9 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.9"
         2 "1.9.1"
         3 "1.9.2"
         4 "1.9.3"
         5 "1.9.4")

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/b4d449cf2918e0f3bd8aa18954b916a4d1880f0d/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.9.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/bf95d9118d9b4b827f524c878efd275125b56181/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.9.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/2b95cc7b136017e064c46d04a5825fe4cfa1be30/server.jar
            sleep 1
            select_ram
            ;;
        4)
            #1.9.3
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/8e897b6b6d784f745332644f4d104f7a6e737ccf/server.jar
            sleep 1
            select_ram
            ;;
        5)
            #1.9.4
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/edbb7b1758af33d365bf835eb9d13de005b1e274/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.10 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.10"
         2 "1.10.1"
         3 "1.10.2")

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a96617ffdf5dabbb718ab11a9a68e50545fc5bee/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.10.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/cb4c6f9f51a845b09a8861cdbe0eea3ff6996dee/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.10.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3d501b23df53c548254f5e3f66492d178a48db63/server.jar
            sleep 1
            select_ram
            ;;
esac

}

function vp_1.11 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/48820c84cb1ed502cb5b2fe23b8153d5e4fa61c0/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.11.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/1f97bd101e508d7b52b3d6a7879223b000b5eba0/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.11.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/f00c294a1576e03fddcac777c3cf4c7d404c4ba4/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.12 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/8494e844e911ea0d63878f64da9dcc21f53a3463/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.12.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/561c7b2d54bae80cc06b05d950633a9ac95da816/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.12.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.13 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/d0caafb8438ebd206f99930cfaecfa6c9a13dca0/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.13.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/fe123682e9cb30031eae351764f653500b7396c9/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.13.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.14 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/f1a0073671057f01aa843443fef34330281333ce/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.14.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/ed76d597a44c5266be2a7fcd77a8270f1f0bc118/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.14.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/808be3869e2ca6b62378f9f4b33c946621620019/server.jar
            sleep 1
            select_ram
            ;;
        4)
            #1.14.3
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
            sleep 1
            select_ram
            ;;
        5)
            #1.14.4
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.15 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/e9f105b3c5c7e85c7b445249a93362a22f62442d/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.15.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/4d1826eebac84847c71a77f9349cc22afd0cf0a1/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.15.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.16 {

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Versions"
MENU="Select the exact Version you want to install:"

OPTIONS=(1 "1.16"
         2 "1.16.1"
         3 "1.16.2"
         4 "1.16.3"
         5 "1.16.4"
         6 "1.16.5")

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
            #1.16
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a0d03225615ba897619220e256a266cb33a44b6b/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.16.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.16.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar
            sleep 1
            select_ram
            ;;
        4)
            #1.16.3
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar
            sleep 1
            select_ram
            ;;
        5)
            #1.16.4
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
            sleep 1
            select_ram
            ;;
        6)
            #1.16.5
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.17 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.17.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e/server.jar
            sleep 1
            select_ram
            ;;
esac

}


function vp_1.18 {

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
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar
            sleep 1
            select_ram
            ;;
        2)
            #1.18.1
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar
            sleep 1
            select_ram
            ;;
        3)
            #1.18.2
            clear
            cd Minecraft
            wget https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
            sleep 1
            select_ram
            ;;
esac

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

HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
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
         12 "1.18")

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
            forge_vp_1.7
            ;;
        2)
            check_java8
            forge_vp_1.8
            ;;
        3)
            check_java8
            forge_vp_1.9
            ;;
        4)
            check_java8
            forge_vp_1.10
            ;;
        5)
            check_java8
            forge_vp_1.11
            ;;
        6)
            check_java8
            forge_vp_1.12
            ;;
        7)
            check_java8
            forge_vp_1.13
            ;;
        8)
            check_java8
            forge_vp_1.14
            ;;
        9)
            check_java8
            forge_vp_1.15
            ;;
        10)
            check_java8
            forge_vp_1.16
            ;;
        11)
            check_java16
            forge_vp_1.17
            ;;
        12)
            check_java17
            forge_vp_1.18
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

if [ $forge_ex_version_number = "10.12.2.1154" ] || [ $forge_ex_version_number = "10.12.2.1155" ] || [ $forge_ex_version_number = "10.12.2.1161" ]
then
    forge_custom_bug_version
else

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
fi
}

function forge_custom_bug_version {

    clear
    echo "Hallo"

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