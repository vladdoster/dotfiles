#!/usr/bin/env bash

trap 'catch' ERR
catch() {
  echo "--- ERROR: An error has occurred while running $0"
  exit 1
}

echo "--- Installing guacamole dependencies"
sudo yum install guacamole guacd
echo "--- Installing guacamole packages for SSH, RDP, and VNC"
yum install libguac-client-vnc libguac-client-ssh libguac-client-rdp
echo "--- Setting user options"
PS3="Enter a number: "
select opt in "on boot" "create alias"; do
    case $REPLY in
        1)
            echo "Setting to start on boot"
            ln -s "/usr/lib/systemd/system/tomcat6.service" "/etc/systemd/system/multi-user.target.wants/tomcat6.service"
            break
            ;;
        2)
            echo "--- Use 'start-guacamole' to start guacamole"
            break
            ;;
          *)
            echo "--- Use 'service tomcat start' to  start guacamole"
            break
            ;;
    esac
done
echo "--- Successfully installed guacamole."

