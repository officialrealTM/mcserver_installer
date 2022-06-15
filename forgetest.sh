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

# get data stored in $ram using input redirection

# make a decsion
case $respose in
  0)
        cd Minecraft
        wget https://maven.minecraftforge.net/net/minecraftforge/forge/$forge_version_number-$forge_ex_version_number-$version_tag/forge-$forge_version_number-$forge_ex_version_number-$version_tag-installer.jar
        forge_installer
        rm *installer.jar
        rm *.log
        mv *universal.jar server.jar
        echo "Fertig"
        ;;
  1)
        echo "Cancel pressed."
        ;;
  255)
   echo "[ESC] key pressed."
esac
}
forge_version_number="1.7.2"
version_tag=mc172
forge_custom_version
