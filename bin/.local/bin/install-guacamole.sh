#!/usr/bin/env bash

echo "--- Installing guacamole dependencies"
sudo yum install guacamole guacd
echo "--- Installing guacamole packages for SSH, RDP, and VNC"
yum install libguac-client-vnc libguac-client-ssh libguac-client-rdp
echo "--- Setting user options"
PS3="Enter a number: "
select opt in "on boot" "create alias"; do
    case $character in
        "on boot")
            echo "Setting to start on boot"
            ln -s "/usr/lib/systemd/system/tomcat6.service" "/etc/systemd/system/multi-user.target.wants/tomcat6.service"
            exit 0
            ;;
        *)
            echo "--- Use 'service tomcat start' to  start guacamole"
            exit 0
            ;;
    esac
done
