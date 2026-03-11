#!/bin/bash

#Script Name	: MCServerInstaller                                                                                          
#Description	: A powerful bash script for easy installation of a Minecraft server (Vanilla, Forge, Spigot & Paper)                                                                                                                                                                   
#Author       	: officialrealTM aka. realTM                                              
#Email         	: support@realtm.de
#GitHub         : https://github.com/officialrealTM/mcserver_installer                                           

## START OF COUNTING FUNCTIONS
path=$(pwd)
CONFIG_FILE="$path/.mcserver_installer_config"
API_BASE_URL="https://api.realtm.de"


OS_INFO_STRING="unknown" # Default value
ubuntu=false # Resets the flags for Java logic
deb12=false # Resets the flags for Java logic
## END OF OS CHECK

## Script Version
scriptversion="20.2"

## Latest Version
latestver=$(curl -s https://version.realtm.de)



############################################
## API & TELEMETRY
############################################


validate_api_key() {
    local api_key=$1
    # Call the new, non-saving endpoint
    response=$(curl -s -X POST "$API_BASE_URL/validate-key" \
         -H "X-API-Key: $api_key")

    if echo "$response" | grep -q "Invalid API key"; then
        return 1
    fi
    return 0
}


get_api_key() {
    if [[ -e .disable_telemetry ]]; then
        return 1
    fi
    local api_key=""
    if [ -f "$CONFIG_FILE" ]; then
        api_key=$(cat "$CONFIG_FILE")
        if validate_api_key "$api_key"; then
            echo "$api_key"
            return 0
        fi
    fi
    
    # Generate new API key if validation failed or file doesn't exist
    response=$(curl -s -X POST "$API_BASE_URL/generate-key")
    api_key=$(echo "$response" | grep -o '"apiKey":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$api_key" ]; then
        echo "$api_key" > "$CONFIG_FILE"
        chmod 600 "$CONFIG_FILE"
        echo "$api_key"
        return 0
    fi
    return 1
}


# Replace the function in mcserver_installer_v2.sh (from line 42)

increment_counter() {
    if [[ -e .disable_telemetry ]]; then
        return 0
    fi
    local api_key=$(get_api_key)
    if [ -n "$api_key" ]; then
        
        # 1. Get OS Info (set by distro_check())
        local os_info="$OS_INFO_STRING"

        # 2. Script Version (global variable)
        local version="$scriptversion"

        # 3. Extract Minecraft info from $dirname (global variable)
        local mc_type=$(echo "$dirname" | cut -d'-' -f1)
        
        # --- CORRECTION HERE ---
        # Extracts everything after the first '-' (e.g. "1.21.10-1" or "1.21.3_Build-42")
        local mc_version_raw=$(echo "$dirname" | cut -d'-' -f2-)
        # Step 1: Remove Build info (e.g. _Build-42)
        local mc_version_no_build=$(echo "$mc_version_raw" | cut -d'_' -f1)
        # Step 2: Remove Suffixes (e.g. -1)
        local mc_version=$(echo "$mc_version_no_build" | cut -d'-' -f1)
        # --- END CORRECTION ---

        # 4. Build JSON Payload
        local json_payload
        json_payload=$(printf '{"version": "%s", "os": "%s", "mc_type": "%s", "mc_version": "%s"}' \
                        "$version" \
                        "$os_info" \
                        "$mc_type" \
                        "$mc_version")

        # 5. Send the new curl command to the v2 API
        curl -s -X POST "$API_BASE_URL/increment" \
             -H "X-API-Key: $api_key" \
             -H "Content-Type: application/json" \
             -d "$json_payload"
    fi
}

############################################
## SYSTEM CHECKS & UPDATES
############################################




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
    if [[ $deb12 == "true" ]] || [[ $ubuntuver == *"24.04" ]]
    then
        apt install python3-packaging -y
    else
    pip3 install packaging
    fi
    
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
        # Check if lsb_release exists at all
        if command -v lsb_release >/dev/null 2>&1; then
            
            # 1. Get Distro name and Release number
            local distro=$(lsb_release -i -s)
            local release=$(lsb_release -r -s)
            
            # 2. Set the main info variable for the API
            OS_INFO_STRING="$distro $release"
            
            # 3. Set the old flags for compatibility with the Java installers
            if [[ "$distro" == "Ubuntu" ]]; then
                ubuntu=true
            elif [[ "$distro" == "Debian" ]]; then
                if [[ "$release" == "12"* ]] || [[ "$release" == "13"* ]]; then
                    deb12=true
                fi
            else
                # If lsb_release returns something unexpected (e.g. LinuxMint),
                # check if it is a supported Debian.
                if [[ -f /etc/debian_version ]]; then
                    current_version=$(</etc/debian_version)
                    if [[ $current_version == "12"* ]] || [[ $current_version == "13"* ]]; then
                        deb12=true
                        OS_INFO_STRING="Debian 12" # Override OS_INFO_STRING with what we know for sure
                    elif [[ $current_version == "11"* ]]; then
                        OS_INFO_STRING="Debian 11"
                    elif [[ $current_version == "10"* ]]; then
                        OS_INFO_STRING="Debian 10"
                    else
                        echo "Your Linux Distribution ($OS_INFO_STRING) is not supported."
                        exit
                    fi
                else
                    echo "Your Linux Distribution ($OS_INFO_STRING) is not supported."
                    exit
                fi
            fi
        else
            # Fallback for very old systems without lsb_release
            echo "lsb_release not found. Falling back to /etc/debian_version check..."
            current_version=$(</etc/debian_version)
            if [[ $current_version == "10"* ]]; then
                OS_INFO_STRING="Debian 10"
            elif [[ $current_version == "11"* ]]; then
                OS_INFO_STRING="Debian 11"
            elif [[ $current_version == "12"* ]]; then
                deb12=true
                OS_INFO_STRING="Debian 12"
            else
                echo "Your Linux Distribution is not supported."
                exit
            fi
        fi
    fi
}

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

############################################
## BASE HELPERS
############################################




check_current_java() {
    if [[ ! $javaversion -eq $1 ]]; then
        dialog --title 'MC-Server Installer by realTM' \
            --msgbox "You currently have Java $javaversion selected, but Java $1 is required.\nChange it to Java $1 in the following menu" 10 60
        clear
        sudo update-alternatives --config java
        clear
    fi
}

check_current8()  { check_current_java 8;  }

check_current16() { check_current_java 16; }

check_current17() { check_current_java 17; }

check_current21() { check_current_java 21; }


script_creator() {
    local req=$1
    local launch=$2
    cat > start.sh << 'EOF'
#!/bin/bash
function compare {
    if [[ $java_version = "21"* ]]; then javaversion=21
    elif [[ $java_version = "17."* ]]; then javaversion=17
    elif [[ $java_version = "16."* ]]; then javaversion=16
    elif [[ $java_version = "1.8"* ]]; then javaversion=8
    fi
}
function version_grab {
    java_version=$(java -version 2>&1 | awk -F[\"_] 'NR==1{print $2}')
    compare
}
EOF
    cat >> start.sh << EOF
function check_current {
    if [[ ! \$javaversion -eq $req ]]; then
        dialog --title 'MC-Server Installer by realTM' \\
            --msgbox "You currently have Java \$javaversion selected, but Java $req is required.\\nChange it to Java $req in the following menu" 10 60
        sudo update-alternatives --config java
    fi
}
version_grab
check_current
$launch
EOF
}


script_creator_8()  { script_creator 8  "screen -S Minecraft java -Xmx${ram_third}G -Xms512M -jar server.jar"; }

script_creator_16() { script_creator 16 "screen -S Minecraft java -Xmx${ram_third}G -Xms512M -jar server.jar"; }

script_creator_17() { script_creator 17 "screen -S Minecraft java -Xmx${ram_third}G -Xms512M -jar server.jar"; }

script_creator_21() { script_creator 21 "screen -S Minecraft java -Xmx${ram_third}G -Xms512M -jar server.jar"; }

forge_script_creator_17() {
    rm -f run.bat run.sh
    touch user_jvm_args.txt
    script_creator 17 "screen -S Minecraft java @user_jvm_args.txt @libraries/net/minecraftforge/forge/$ver-$forge_ex_version_number/unix_args.txt \"\$@\""
    chmod +x start.sh
    echo "" >> user_jvm_args.txt
    echo "-Xmx${ram_third}G" >> user_jvm_args.txt
}


select_ram() {
    local creator=$1
    local CHOICE
    CHOICE=$(dialog --clear \
        --backtitle "MC-Server Installer by realTM" --title "Allocate RAM" \
        --menu "How much RAM do you want to allocate to your Minecraft Server?" \
        20 50 10 \
        1 "1GB" 2 "2GB" 3 "3GB" 4 "4GB" \
        5 "5GB" 6 "6GB" 7 "7GB" 8 "8GB" 9 "Custom Amount" \
        2>&1 >/dev/tty)
    clear
    case $CHOICE in
        [1-8]) ram_third=$CHOICE; $creator; chmod +x start.sh; finalize ;;
        9)     custom_ram "$creator" ;;
    esac
}


custom_ram() {
    local creator=$1
    local ram
    ram=$(dialog --title "Define RAM" --backtitle "MC-Server Installer by realTM" \
        --inputbox "Enter the amount of RAM you want to allocate" 8 60 2>&1 >/dev/tty)
    case $? in
        0)
            ram_third=$(echo "${ram//B}")
            ram_third=$(echo "${ram_third//G}")
            ram_third=$(echo "${ram_third// /}")
            $creator; chmod +x start.sh; finalize ;;
        *) clear ;;
    esac
}


select_ram_8()   { select_ram script_creator_8;  }

select_ram_16()  { select_ram script_creator_16; }

select_ram_17()  { select_ram script_creator_17; }

select_ram_21()  { select_ram script_creator_21; }

new_select_ram_17() { select_ram decide_script_version; }

new_select_ram_21() { select_ram decide_script_version; }

forge_custom_ram_17() { custom_ram decide_script_version; }


folder_creator() {
    cd "$path/Servers"
    local base="$1" dir="$1" i=1
    while [[ -d "$dir" ]]; do dir="${base}-${i}"; ((i++)); done
    mkdir "$dir"
    dirname="$dir"
}


folder_creator_vanilla()     { folder_creator "Minecraft-$ver"; }

folder_creator_forge()       { folder_creator "Forge-$ver"; }

folder_creator_spigot()      { folder_creator "Spigot-$ver"; }

folder_creator_paper()       { folder_creator "Paper-${version}_Build-$build"; }

folder_creator_leaf_direct() { folder_creator "Leaf-$version"; }

folder_creator_leaf_api()    { folder_creator "Leaf-${version}_Build-$build"; }


version_picker() {
    local varname=$1; shift
    local callback=$1; shift
    local versions=("$@")
    local opts=() i=1
    for v in "${versions[@]}"; do opts+=("$i" "$v"); ((i++)); done
    local CHOICE
    CHOICE=$(dialog --clear \
        --backtitle "MC-Server Installer by realTM" --title "Versions" \
        --menu "Select the exact Version you want to install:" \
        40 80 12 "${opts[@]}" 2>&1 >/dev/tty)
    clear
    [[ -z "$CHOICE" ]] && return
    printf -v "$varname" '%s' "${versions[$((CHOICE-1))]}"
    $callback
}


forge_version_select() {
    ver=$1; "check_java$2"; version_grab; "check_current$2"; "$3"
}


spigot_version_select() {
    ver=$1; "check_java$2"; version_grab; "check_current$2"; "$3"
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

############################################
## JAVA LOGIC / AUTO-INSTALLER
############################################


decline_java() {
    clear
    dialog --title "Error" --backtitle "MC-Server Installer by realTM" \
        --yesno "Java $1 is required to run a Minecraft Server!\nDo you want to install it?" 10 60
    case $? in
        0) $2 ;; 1) clear && exit ;;
    esac
}


java_prompt() {
    clear
    dialog --title "Java Installer" --backtitle "MC-Server Installer by realTM" \
        --yesno "Java $1 is required! Do you want to install it?" 7 60
    case $? in
        0) $2 ;; 1) decline_java $1 $2 ;;
    esac
}


java8()  { java_prompt 8  install_java8;  }

java16() { java_prompt 16 install_java16;  }

java17() { java_prompt 17 install_java17;  }

java21() { java_prompt 21 install_java21;  }

function check_java8 {

    if [[ $ubuntu = true ]]
    then
        check_java8_ubuntu
    elif [[ $deb12 = true ]]
    then
        check_java8_debian1
    else
        check_java8_debian2
    fi
}


function check_java8_debian1 {
    for dir in /usr/lib/jvm/temurin-8*; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    	java8
    return 1
}


function check_java8_debian2 {
    for dir in /usr/lib/jvm/adoptopenjdk-8*; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    	java8
    return 1
}


function check_java8_ubuntu {
    for dir in /usr/lib/jvm/java-8*; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    	java8
    return 1
}


function check_java16 {
    for dir in /usr/java/jdk-16*; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    java16
    return 1
}


function check_java17 {
    for dir in /usr/java/jdk-17; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    java17
    return 1
}


function check_java21 {
    for dir in /usr/lib/jvm/jdk-21*; do
        if [[ -d "$dir" ]]; then
            return 0
        fi
    done
    java21
    return 1
}


function install_java8 {

    dialog --infobox "Java 8 will be installed now" 10 30 && sleep 3
    clear
    if [[ $ubuntu == "true" ]]
    then
        sudo apt-get install openjdk-8-jdk -y
    elif [[ $deb12 == "true" ]]
    then
        mkdir -p /etc/apt/keyrings
        wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
        echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
        apt update
        apt install temurin-8-jdk -y
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




function install_java21 {
    dialog --infobox "Java 21 will be installed now" 10 30 && sleep 3
    clear
    cd /tmp/
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
    sudo dpkg -i jdk-21_linux-x64_bin.deb
    rm jdk-21_linux-x64_bin.deb
    sudo update-alternatives --config java
    cd $path
    sleep 5
    clear
    dialog --infobox "Java 21 has been installed now!" 10 30 
}



function version_grab {
    java_version=$(java -version 2>&1 | awk -F[\"_] 'NR==1{print $2}')
    compare
}


function compare {
    if [[ $java_version = "21"* ]]
    then
        javaversion=21
    elif [[ $java_version = "17."* ]]
    then
        javaversion=17
    elif [[ $java_version = "16."* ]]
    then
        javaversion=16
    elif [[ $java_version = "1.8"* ]]
    then
        javaversion=8
    fi
}

############################################
## VANILLA LOGIC
############################################

function vanilla {

ver=$(dialog --title "Choose Version" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the version number you want to install (e.g 1.8.9)" 10 60 2>&1 >/dev/tty)
respose=$?

case $respose in
  0)
        clear
        version_checker
        ;;
  1)
        echo "Cancel pressed."
        clear
        ;;
  255)
        echo "[ESC] key pressed."
        clear
        ;;
esac
        
}


function version_checker {

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$ver"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$ver"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$ver"; }
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$ver"; }

minVer=1.7
maxVer=1.21.11

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
    dialog --title 'MC-Server Installer by realTM' --msgbox ' \nThe version number entered is not supported by this script!\nSupported Versions: 1.7.X - 1.21.X ' 10 60
    clear
    vanilla
    fi
}



function java_selector {

    if [[ $ver = "1.17"* ]]
    then
        clear
        check_java16
        version_grab
        check_current16
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd $dirname
        wget $dl
        sleep 1
        select_ram_16
    elif [[ $ver = "1.20.5" ]] || [[ $ver = "1.20.6" ]] || [[ $ver = "1.21"* ]]
    then
        clear
        check_java21
        version_grab
        check_current21
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd $dirname
        wget $dl
        sleep 1
        select_ram_21
    elif [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
    then
        clear
        check_java17
        version_grab
        check_current17
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
        cd $dirname
        wget $dl
        sleep 1
        select_ram_17
    else
        clear
        check_java8
        version_grab
        check_current8
        dl=$(python3 mcurlgrabber.py server-url $ver)
        folder_creator_vanilla
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

function finalize {
    increment_counter
    echo "eula=true" > eula.txt
    dialog --msgbox "Your server has been installed to\nServers --> $dirname\n\nTo start it go to the folder with this command:\ncd Servers/$dirname \n\nand execute\n./start.sh" 15 60 
    clear
}

############################################
## FORGE HELPER FUNCTIONS
############################################


## Start of Function Blocks regarding Minecraft Forge:


function forge_installer_routine {
        forge_installer
        rm *installer.jar
        rm *.log
        mv *universal.jar server.jar
        mv forge*.jar server.jar
        ram_version_checker
}


function forge_new_init {

    mv forge*.jar server.jar
    rm run.bat
    rm run.sh
    rm user_jvm_args.txt

}


function forge_new_installer_routine {
        forge_installer
        rm *installer.jar
        rm *.log
        if [[ $ver = "1.17"* ]]
        then
            ram_version_checker
        elif [[ $ver = "1.20.3" ]] || [[ $ver = "1.20.4" ]]
        then
            forge_new_init
            new_select_ram_17
        elif [[ $ver = "1.20.6" ]] || [[ $ver = "1.21"* ]]
        then
            forge_new_init
            new_select_ram_21
        else
            new_select_ram_17
        fi
}


function decide_script_version {

    if [[ $ver = "1.20.3" ]] || [[ $ver = "1.20.4" ]]
    then
        script_creator_17
    elif [[ $ver = "1.20.6" ]] || [[ $ver = "1.21"* ]]
    then
        script_creator_21
    else
        forge_script_creator_17
    fi

}

function ram_version_checker {


    if [[ $ver = "1.17"* ]]
    then
        select_ram_16
    elif [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
    then
        select_ram_17
    else
        select_ram_8
    fi

}

function forge_installer {

    java -jar *.jar --installServer
}


function forge_new_version_check {

    if [[ $ver = "1.20.6" ]] || [[ $ver = "1.21"* ]]
    then
        clear
        check_java21
        version_grab
        check_current21
        folder_creator_forge
        cd $dirname
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/$ver-$forge_ex_version_number/forge-$ver-$forge_ex_version_number-installer.jar
        forge_new_installer_routine
    elif [[ $ver = "1.17"* ]] || [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]] 
    then
        clear
        check_java17
        version_grab
        check_current17
        folder_creator_forge
        cd $dirname
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/$ver-$forge_ex_version_number/forge-$ver-$forge_ex_version_number-installer.jar
        forge_new_installer_routine
    else
        normal_forge
    fi

}

function normal_forge {
        clear
        folder_creator_forge
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
        clear
        ;;
  1)
        echo "Cancel pressed."
        clear
        ;;
  255)
   echo "[ESC] key pressed."
   clear
esac

}

############################################
## FORGE VERSION CALLBACKS
############################################


forge_vp_1.7()  { version_picker ver forge_custom_version 1.7.10; }

forge_vp_1.8()  { version_picker ver forge_custom_version 1.8 1.8.8 1.8.9; }

forge_vp_1.9()  { version_picker ver forge_custom_version 1.9 1.9.4; }

forge_vp_1.10() { version_picker ver forge_custom_version 1.10 1.10.2; }

forge_vp_1.11() { version_picker ver forge_custom_version 1.11 1.11.2; }

forge_vp_1.12() { version_picker ver forge_custom_version 1.12 1.12.1 1.12.2; }

forge_vp_1.13() { version_picker ver forge_custom_version 1.13.2; }

forge_vp_1.14() { version_picker ver forge_custom_version 1.14.2 1.14.3 1.14.4; }

forge_vp_1.15() { version_picker ver forge_custom_version 1.15 1.15.1 1.15.2; }

forge_vp_1.16() { version_picker ver forge_custom_version 1.16.1 1.16.2 1.16.3 1.16.4 1.16.5; }

forge_vp_1.17() { version_picker ver forge_custom_version 1.17.1; }

forge_vp_1.18() { version_picker ver forge_custom_version 1.18 1.18.1 1.18.2; }

forge_vp_1.19() { version_picker ver forge_custom_version 1.19 1.19.1 1.19.2 1.19.3 1.19.4; }

forge_vp_1.20() { version_picker ver forge_custom_version 1.20 1.20.1 1.20.2 1.20.3 1.20.4 1.20.6; }

forge_vp_1.21() { version_picker ver forge_custom_version 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10; }

############################################
## SPIGOT HELPER FUNCTIONS
############################################



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

        if [[ $ver = "1.20.6" ]] || [[ $ver = "1.21"* ]]
        then
            select_ram_21
        elif [[ $ver = "1.18"* ]] || [[ $ver = "1.19"* ]] || [[ $ver = "1.20"* ]]
        then
            select_ram_17
        elif [[ $ver = "1.17" ]] || [[ $ver = "1.17.1" ]]
        then
            select_ram_16
        else
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

############################################
## SPIGOT VERSION CALLBACKS
############################################


svp_1_11_callback() {
    [[ $ver == "1.11" ]] && latest_111=1
    spigot_installer_routine
}

spigot_vp_1.8()  { version_picker ver spigot_installer_routine 1.8 1.8.3 1.8.8; }

spigot_vp_1.9()  { version_picker ver spigot_installer_routine 1.9 1.9.2 1.9.4; }

spigot_vp_1.10() { version_picker ver spigot_installer_routine 1.10.2; }

spigot_vp_1.11() { version_picker ver svp_1_11_callback 1.11 1.11.1 1.11.2; }

spigot_vp_1.12() { version_picker ver spigot_installer_routine 1.12 1.12.1 1.12.2; }

spigot_vp_1.13() { version_picker ver spigot_installer_routine 1.13 1.13.1 1.13.2; }

spigot_vp_1.14() { version_picker ver spigot_installer_routine 1.14 1.14.1 1.14.2 1.14.3 1.14.4; }

spigot_vp_1.15() { version_picker ver spigot_installer_routine 1.15 1.15.1 1.15.2; }

spigot_vp_1.16() { version_picker ver spigot_installer_routine 1.16.1 1.16.2 1.16.3 1.16.4 1.16.5; }

spigot_vp_1.17() { version_picker ver spigot_installer_routine 1.17 1.17.1; }

spigot_vp_1.18() { version_picker ver spigot_installer_routine 1.18 1.18.1 1.18.2; }

spigot_vp_1.19() { version_picker ver spigot_installer_routine 1.19 1.19.1 1.19.2 1.19.3 1.19.4; }


svp_1_20_callback() {
    if [[ $ver == "1.20.6" ]]; then
        check_java21; version_grab; check_current21; spigot_installer_routine
    else
        check_java17; version_grab; check_current17; spigot_installer_routine
    fi
}

spigot_vp_1.20() { version_picker ver svp_1_20_callback 1.20.1 1.20.2 1.20.4 1.20.6; }


svp_1_21_callback() { check_java21; version_grab; check_current21; spigot_installer_routine; }

spigot_vp_1.21() { version_picker ver svp_1_21_callback 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10; }

############################################
## PAPER HELPER FUNCTIONS
############################################

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
        clear
        ;;
  255)
        echo "[ESC] key pressed."
        clear
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
    elif [[ $version = "1.20.5" ]] || [[ $version = "1.20.6" ]] || [[ $version = "1.21"* ]]
    then
        select_ram_21
    elif [[ $version = "1.18"* ]] || [[ $version = "1.19"* ]] || [[ $version = "1.20"* ]]
    then
        select_ram_17
    else
        select_ram_8
    fi



}

############################################
## PAPER VERSION CALLBACKS
############################################


pvp_start() { check_java$1; version_grab; check_current$1; create_json; }

paper_vp_1_8()  { version_picker version "pvp_start 8"  1.8.8; }

paper_vp_1_9()  { version_picker version "pvp_start 8"  1.9.4; }

paper_vp_1_10() { version_picker version "pvp_start 8"  1.10.2; }

paper_vp_1_11() { version_picker version "pvp_start 8"  1.11.2; }

paper_vp_1_12() { version_picker version "pvp_start 8"  1.12.2; }

paper_vp_1_13() { version_picker version "pvp_start 8"  1.13.2; }

paper_vp_1_14() { version_picker version "pvp_start 8"  1.14.4; }

paper_vp_1_15() { version_picker version "pvp_start 8"  1.15.2; }

paper_vp_1_16() { version_picker version "pvp_start 8"  1.16.5; }

paper_vp_1_17() { version_picker version "pvp_start 16" 1.17.1; }

paper_vp_1_18() { version_picker version "pvp_start 17" 1.18.2; }

paper_vp_1_19() { version_picker version "pvp_start 17" 1.19.3 1.19.4; }

paper_vp_1_20_callback() {
    if [[ $version == "1.20.5" ]] || [[ $version == "1.20.6" ]]; then
        pvp_start 21
    else
        pvp_start 17
    fi
}

paper_vp_1_20() { version_picker version paper_vp_1_20_callback 1.20 1.20.1 1.20.2 1.20.4 1.20.5 1.20.6; }

paper_vp_1_21() { version_picker version "pvp_start 21" 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10; }

############################################
## LEAF HELPER FUNCTIONS
############################################
## Start of Leaf Functions

# Routine for direct downloads from GitHub
function leaf_direct_download_routine {
    check_java17
    version_grab
    check_current17
    folder_creator_leaf_direct
    cd $path/Servers/$dirname
    wget https://github.com/Winds-Studio/Leaf/releases/download/ver-$version/leaf-$version.jar
    mv leaf*.jar server.jar
    leaf_ram_selector
}

# Routine for API-based installation with build selection
function leaf_api_installer_routine {
    if [[ $version == "1.20."* ]]
    then
        check_java17
        version_grab
        check_current17
    elif [[ $version == "1.20.6" ]] || [[ $version == "1.21"* ]]
    then
        check_java21
        version_grab
        check_current21
    fi
    create_leaf_json
}


create_leaf_json () {
  curl -X 'GET' \
  'https://api.leafmc.one/v2/projects/leaf/versions/'$version'/builds' -s \
  -H 'accept: application/json' > builds.json
  set_leaf_build
}


set_leaf_build () {
HEIGHT=40
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="MC-Server Installer by realTM"
TITLE="Select Build Number"
MENU="Which Build of Leaf do you want to install?"

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
            leaf_build_input
            ;;
        2)
            show_leaf_builds
            ;;            
esac
}


leaf_build_input () {
  
  input=$(cat builds.json)
  builds=($(echo "$input" | jq -r '.[].build'))
  rm -f $path/builds.json

  build=$(dialog --title "Enter Build Number" \
--backtitle "MC-Server Installer by realTM" \
--inputbox "Enter the Build number you want to install " 10 60 2>&1 >/dev/tty)
  
  respose=$?
  if [ $respose -ne 0 ]; then
    clear
    return
  fi

  if [[ " ${builds[@]} " =~ " $build " ]]; then
    folder_creator_leaf_api
    download_leaf_jar
  else
    dialog --msgbox "The build number you've entered does not exist." 7 60
    clear
  fi
}


show_leaf_builds () {

    input=$(cat builds.json)
    builds=($(echo "$input" | jq -r '.[].build'))
    rm -f $path/builds.json
    
    menu_items=()
    for number in "${builds[@]}"; do
      menu_items+=("$number" "")
    done

    if [ ${#menu_items[@]} -eq 0 ]; then
        dialog --msgbox "No builds found for this Minecraft version." 7 60
        clear
        return
    fi

  build=$(dialog --clear \
                  --backtitle "MC-Server Installer by realTM" \
                  --title "Select Build Number" \
                  --menu "Select the Build number you want to install:" \
                  0 0 0 \
                  "${menu_items[@]}" \
                  2>&1 >/dev/tty)

    respose=$?
    if [ $respose -ne 0 ]; then
        clear
        return
    fi
    
    folder_creator_leaf_api
    download_leaf_jar
}




download_leaf_jar () {
    
    cd $path/Servers/$dirname
    wget https://api.leafmc.one/v2/projects/leaf/versions/$version/builds/$build/downloads/leaf-$version-$build.jar
    mv leaf*.jar server.jar
    leaf_ram_selector
}


leaf_ram_selector () {

    if [[ $version = "1.20.6" ]] || [[ $version = "1.21"* ]]
    then
        select_ram_21
    elif [[ $version = "1.19"* ]] || [[ $version = "1.20."* ]]
    then
        select_ram_17
    else
        select_ram_8
    fi

}

############################################
## LEAF VERSION CALLBACKS
############################################


lvp_1_19_callback() { leaf_direct_download_routine; }

lvp_1_20_callback() {
    if [[ $version == *"Direct Download"* ]]; then
        version=${version%% *}
        leaf_direct_download_routine
    else
        version=${version%% *}
        leaf_api_installer_routine
    fi
}

lvp_1_21_callback() { leaf_api_installer_routine; }

leaf_vp_1_19() { version_picker version lvp_1_19_callback 1.19.2 1.19.3 1.19.4; }

leaf_vp_1_20() { version_picker version lvp_1_20_callback "1.20 (Direct Download)" "1.20.1 (Direct Download)" "1.20.2 (Direct Download)" "1.20.4 (Build Selection)" "1.20.6 (Build Selection)"; }

leaf_vp_1_21() { version_picker version lvp_1_21_callback 1.21 1.21.2 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8; }

############################################
## MAIN SELECTION MENUS
############################################


function forge {
    local CHOICE=$(dialog --clear --backtitle "MC-Server Installer by realTM" --title "Versions" \
        --menu "Select the major Version you want to install:" 22 50 14 \
        1 "1.7" 2 "1.8" 3 "1.9" 4 "1.10" 5 "1.11" 6 "1.12" 7 "1.13" 8 "1.14" \
        9 "1.15" 10 "1.16" 11 "1.17" 12 "1.18" 13 "1.19" 14 "1.20" 15 "1.21" \
        2>&1 >/dev/tty)
    clear
    case $CHOICE in
        1) forge_version_select 1.7 8 forge_vp_1.7 ;;
        2) forge_version_select 1.8 8 forge_vp_1.8 ;;
        3) forge_version_select 1.9 8 forge_vp_1.9 ;;
        4) forge_version_select 1.10 8 forge_vp_1.10 ;;
        5) forge_version_select 1.11 8 forge_vp_1.11 ;;
        6) forge_version_select 1.12 8 forge_vp_1.12 ;;
        7) forge_version_select 1.13 8 forge_vp_1.13 ;;
        8) forge_version_select 1.14 8 forge_vp_1.14 ;;
        9) forge_version_select 1.15 8 forge_vp_1.15 ;;
        10) forge_version_select 1.16 8 forge_vp_1.16 ;;
        11) forge_version_select 1.17 16 forge_vp_1.17 ;;
        12) forge_version_select 1.18 17 forge_vp_1.18 ;;
        13) forge_version_select 1.19 17 forge_vp_1.19 ;;
        14) ver=1.20; forge_vp_1.20 ;;
        15) forge_version_select 1.21 21 forge_vp_1.21 ;;
    esac
}


function spigot {
    local CHOICE=$(dialog --clear --backtitle "MC-Server Installer by realTM" --title "Versions" \
        --menu "Select the major Version you want to install:" 50 80 13 \
        1 "1.8" 2 "1.9" 3 "1.10" 4 "1.11" 5 "1.12" 6 "1.13" 7 "1.14" \
        8 "1.15" 9 "1.16" 10 "1.17" 11 "1.18" 12 "1.19" 13 "1.20" 14 "1.21" \
        2>&1 >/dev/tty)
    clear
    case $CHOICE in
        1) spigot_version_select 1.8 8 spigot_vp_1.8 ;;
        2) spigot_version_select 1.9 8 spigot_vp_1.9 ;;
        3) spigot_version_select 1.10 8 spigot_vp_1.10 ;;
        4) spigot_version_select 1.11 8 spigot_vp_1.11 ;;
        5) spigot_version_select 1.12 8 spigot_vp_1.12 ;;
        6) spigot_version_select 1.13 8 spigot_vp_1.13 ;;
        7) spigot_version_select 1.14 8 spigot_vp_1.14 ;;
        8) spigot_version_select 1.15 8 spigot_vp_1.15 ;;
        9) spigot_version_select 1.16 8 spigot_vp_1.16 ;;
        10) spigot_version_select 1.17 16 spigot_vp_1.17 ;;
        11) spigot_version_select 1.18 17 spigot_vp_1.18 ;;
        12) spigot_version_select 1.19 17 spigot_vp_1.19 ;;
        13) ver=1.20; spigot_vp_1.20 ;;
        14) ver=1.21; spigot_vp_1.21 ;;
    esac
}


function paper {
    local CHOICE=$(dialog --clear --backtitle "MC-Server Installer by realTM" --title "Select Version" \
        --menu "For which Minecraft Version do you want to install Paper?" 30 80 15 \
        1 "1.8" 2 "1.9" 3 "1.10" 4 "1.11" 5 "1.12" 6 "1.13" 7 "1.14" \
        8 "1.15" 9 "1.16" 10 "1.17" 11 "1.18" 12 "1.19" 13 "1.20" 14 "1.21" \
        2>&1 >/dev/tty)
    clear
    case $CHOICE in
        1) paper_vp_1_8 ;; 2) paper_vp_1_9 ;; 3) paper_vp_1_10 ;; 4) paper_vp_1_11 ;;
        5) paper_vp_1_12 ;; 6) paper_vp_1_13 ;; 7) paper_vp_1_14 ;; 8) paper_vp_1_15 ;;
        9) paper_vp_1_16 ;; 10) paper_vp_1_17 ;; 11) paper_vp_1_18 ;; 12) paper_vp_1_19 ;;
        13) paper_vp_1_20 ;; 14) paper_vp_1_21 ;;
    esac
}


function leaf {
    local CHOICE=$(dialog --clear --backtitle "MC-Server Installer by realTM" --title "Versions" \
        --menu "Select the major Version you want to install:" 22 50 14 \
        1 "1.19" 2 "1.20" 3 "1.21" \
        2>&1 >/dev/tty)
    clear
    case $CHOICE in
        1) leaf_vp_1_19 ;; 2) leaf_vp_1_20 ;; 3) leaf_vp_1_21 ;;
    esac
}


## END NEW HELPER FUNCTIONS ##

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
         4 "Minecraft Paper"
         5 "Minecraft Leaf")

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
        5)
            leaf
            ;;
 esac

}

############################################
## EXECUTION ENTRY POINT
############################################

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
else
    clear
    distro_check
    dialog_check
    curl_check
    compare_version
    installed_check
    servers_folder
    choose_type
fi

