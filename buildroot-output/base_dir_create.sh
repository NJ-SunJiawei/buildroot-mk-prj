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