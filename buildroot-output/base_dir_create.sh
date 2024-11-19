#create by sjw
#!/bin/bash

# Create the necessary directory structure
mkdir -p "$PRJROOT/images/rootfs"
cd "$PRJROOT/images/rootfs" || exit && mkdir -p etc usr/{bin,lib,lib64,sbin} # Exit the script if cd fails

# Check and create symbolic links
check_and_symlink() {
  local target="$1"
  local linkname="$2"

  cd "$PRJROOT/images/rootfs"

  if [ ! -d "$target" ]; then
    echo "Target directory $target does not exist, creating it now..."
    mkdir -p "$target"
  fi

  if [ -L "$linkname" ]; then
    echo "Symbolic link $linkname already exists."
  else
    ln -s "$target" "$linkname"
    echo "Creating symbolic link $linkname -> $target"
  fi
}

# Create each symbolic link
check_and_symlink "usr/bin/" "./bin"
check_and_symlink "usr/lib/" "./lib"
check_and_symlink "usr/lib64/" "./lib64"
check_and_symlink "usr/sbin/" "./sbin"

#############################################################################################
#############################################################################################
# Define the startup script path
startup_script="$PRJROOT/images/rootfs/usr/sbin/startup"

# Check if the startup script file already exists
if [ ! -f "$startup_script" ]; then
  # File does not exist, so we create it and write the content
  cat > "$startup_script" << 'EOF'
#!/bin/sh

###############################################################################
# Description : Generic process and kernel module (ko) management script
#
# Authors     :
#
# Version     : 1.0.0
#
# Notes       : Provided by base_sys
###############################################################################

. /etc/profile

help_info() {
    echo "Usage: startup {start|stop|reload|restart|status} <prog_name> [param] ..."
    echo ""
    echo "Description:"
    echo "   startup is a common process daemon manager."
    echo ""
    echo "Parameters:"
    echo "   {start|stop|reload|restart|status}"
    echo "       start -- start service <prog_name>"
    echo "       stop -- stop service <prog_name>"
    echo "       reload -- reload service <prog_name>"
    echo "       restart -- restart service <prog_name>, same as restart"
    echo "       status -- show the status of service <prog_name>"
    echo ""
    echo "   <prog_name> -- the process name with absolute path"
    echo "   [param] ... -- optional args, startup will pass args [param] ... to service <prog_name>"
    echo ""
    echo "Example:"
    echo "1. start a daemon named tftpd with args '--root /var/run/tftp':"
    echo "# startup start /sbin/tftpd --root /var/run/tftp"
    echo "2. stop the daemon tftpd, must use the absolute path:"
    echo "# startup stop /sbin/tftpd"
    echo "3. check the status of tftpd:"
    echo "# startup status /sbin/tftpd"
    echo "or"
    echo "# startup status tftpd"
}

# Script execution actions: start, stop, restart
action=$1
if [ -z "${action}" ]; then
    help_info >&2
    exit 1
fi

shift 1

# Check if it's a kernel module
is_ko='n'
if [ "$1" == "-k" ]; then
    is_ko='y'
    shift 1
fi

# Executable or kernel module path to start
PROG=$1
if [ -z "${PROG}" ]; then
    echo "empty startup target!" >&2
    exit 1
elif [ "${is_ko}" == 'n' -a "${action}" != 'status' -a "${PROG:0:1}" != '/' ]; then
    # Stopping a regular process must provide the full pathname to prevent accidental process killing
    echo "error: '${PROG}' must be an absolute path!" >&2
    exit 1
fi
shift 1

# Startup arguments
ARGS=$@

# Process name
PROG_NAME=${PROG/*\//}

start_process() {
    if [ "${is_ko}" == 'y' ]; then
        insmod ${PROG} ${ARGS}
    else
        exec ${PROG} ${ARGS} &
    fi
}

stop_process() {
    if [ "${is_ko}" == 'y' ]; then
        rmmod ${PROG}
    else
        pids=$(pidof ${PROG})
        if [ -z "${pids}" ]; then
            echo "${PROG} has already stopped!" >&2
            return 99
        fi
        kill -15 $(pidof ${PROG})
    fi
}

case "$action" in
start)
    echo "Starting ${PROG_NAME}..."
    start_process
    ;;
stop)
    echo "Stopping ${PROG_NAME}..."
    stop_process
    ;;
restart|reload)
    ${0} stop
    sleep 1
    ${0} start
    ;;
status)
    if [ "${is_ko}" == 'y' ]; then
        lsmod | grep -w "${PROG_NAME//-/_}"
        exit $?
    fi

    pids=$(pidof ${PROG})
    if [ -z "$pids" ]; then
        echo "${PROG} not running!"
        exit 77
    fi

    ps -ef -q $pids
    ;;
*)
    exit 1
    ;;
esac
EOF
  echo "Created and wrote to $startup_script."
  chmod +x "$startup_script"  # Make the script executable
else
  echo "$startup_script already exists. Not overwriting."
fi

#############################################################################################
#############################################################################################
rg_bspinfo_script="$PRJROOT/images/rootfs/etc/rc.d/init.d/rg-bspinfo"
if [ ! -f "$rg_bspinfo_script" ]; then
  # File does not exist, so we create it and write the content
  cat > "$rg_bspinfo_script" << 'EOF'
#!/bin/sh

########################################################################
# Begin $rc_base/init.d/
#
# Description :
#
# Authors     :
#
# Version     :
#
# Notes       :
#
########################################################################

#. /etc/sysconfig/rc
#. ${rc_functions}
. /etc/profile

PROG_NAME=rg-bspinfo
PROG=/usr/sbin/${PROG_NAME}

process_start_recovery()
{
    mkdir -p /run/.5gnr/app_data/bspinfo/
    cd /run/.5gnr/app_data/bspinfo/
    echo -n 1.00 > HardwareVersion  
    echo -n rgos.bin > MainFile
    echo -n 541651 > OUI
    echo -n 51100050 > ProductID
    echo -n MBBU-UMCCUd-02XS > ProductModel
    echo -n G1TW40P00007C > SerialNO
    echo -n ttyS0 > console
    echo -n 92:34:56:12:13:5C > ethaddr
    echo -n 00000000000b > ethaddr_scale  
    echo -n MBBU-UMCCUd-02XS > fdtname
    echo -n bbu_mc_s5000cm > projectid
    echo -n 2183 > serial0
    echo -n 0 > serial1
    echo -n 0 > serial2
    echo -n 0 > serial3
    echo -n 2024-08-01 15:03:45 > setmac_time
    echo -n 11.0 > setmac_ver
}

process_start()
{
    if [ -f /lib64/libjemalloc.so ]; then
            LD_PRELOAD="$LD_PRELOAD  /lib64/libjemalloc.so" /usr/sbin/${PROG} & 
    elif [ -f /lib/libjemalloc.so ]; then
            LD_PRELOAD="$LD_PRELOAD  /lib/libjemalloc.so" /usr/sbin/${PROG} &
    else
            exec ${PROG} &
    fi
}

case "${1}" in
        start)
            echo "Starting ${PROG_NAME}..."
            mkdir -p /run/.5gnr/log/zlog/bspinfo/
            mkdir -p /data/.5gnr/log/zlog/bspinfo/
            mkdir -p /run/.5gnr/app_data/
            # process_start
            process_start_recovery
            #loadproc ${PROG}
            ;;
       
        stop)
            echo "Stopping ${PROG_NAME}..."
            kill -15 `pidof ${PROG}`
            ;;

        restart)
                 echo "Restarting ${PROG_NAME}..."
            ${0} stop
            sleep 1
            ${0} start
            ;;

        status)
            #statusproc ${PROG}
            ;;
        *)
            echo "Usage: ${0} {start|stop|reload|restart|status}"
            exit 1
            ;;
esac
# End $rc_base/init.d/
EOF
  echo "Created and wrote to $rg_bspinfo_script."
  chmod +x "$rg_bspinfo_script"  # Make the script executable
else
  echo "$rg_bspinfo_script already exists. Not overwriting."
fi

#############################################################################################
#############################################################################################
if [ ! -f "$PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/selfslot" ]; then
	mkdir -p $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt
	echo 7 > selfslot
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot1
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot1
	echo 1 > power
	echo 1 > state
	echo MBBU-BP5Gb-04VS > type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot2
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot2
	echo 0 > power
	echo 0 > state
	touch type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot3
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot3
	echo 1 > power
	echo 1 > state
	echo MBBU-BP5Gb-04VS > type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot4
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot4
	echo 0 > power
	echo 0 > state
	touch type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot5
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot5
	echo 0 > power
	echo 0 > state
	touch type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot6
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot6
	echo 0cd  > power
	echo 0 > state
	touch type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot7
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot7
	echo 1 > power
	echo 1 > state
	echo MBBU-UMCCUb-02XS V2.0 > type
	
	mkdir $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot8
	cd $PRJROOT/images/rootfs/data/.5gnr/app_data/net_mgmt/du/slot8
	echo 0 > power
	echo 0 > state
	touch type
else
    echo "The setup has already been completed."
fi
#############################################################################################
#############################################################################################
SYSCTL_CONF="$PRJROOT/images/rootfs/etc/sysctl.conf"

CONTENT=$(cat <<EOF
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
EOF
)

if [ ! -f "$SYSCTL_CONF" ]; then
    touch "$SYSCTL_CONF"
fi

if ! grep -qF -- "$CONTENT" "$SYSCTL_CONF"; then
    echo -e "$CONTENT" | tee -a "$SYSCTL_CONF" > /dev/null
    echo "IPv6 configuration added to $SYSCTL_CONF."
else
    echo "IPv6 configuration already exists in $SYSCTL_CONF, no changes made."
fi
#############################################################################################
#############################################################################################
backup_and_remove() {
  local file_path="$1"
  local backup_suffix=".bak"

  if [ -f "$file_path" ]; then
    cp "$file_path" "${file_path}${backup_suffix}"
    echo "Backed up: ${file_path} to ${file_path}${backup_suffix}"
    rm "$file_path"
    echo "Removed: $file_path"
  else
    echo "File not found: $file_path, no action taken."
  fi
}

if [ -d "$PRJROOT/images/rootfs/usr/sbin/gnb_guard" ]; then
  cd $PRJROOT/images/rootfs/usr/sbin/gnb_guard
  backup_and_remove "gnb_guard"
else
  echo "Directory $PRJROOT/images/rootfs/usr/sbin/gnb_guard does not exist, skipping."
fi

if [ -d "$PRJROOT/images/rootfs/usr/sbin" ]; then
  cd $PRJROOT/images/rootfs/usr/sbin
  backup_and_remove "ham"
else
  echo "Directory $PRJROOT/images/rootfs/usr/sbin does not exist, skipping."
fi

if [ -d "$PRJROOT/images/rootfs/etc/rc.d/init.d" ]; then
  cd $PRJROOT/images/rootfs/etc/rc.d/init.d
  backup_and_remove "ham"
  backup_and_remove "alarm"
  backup_and_remove "monitor"
else
  echo "Directory $PRJROOT/images/rootfs/etc/rc.d/init.d does not exist, skipping."
fi
