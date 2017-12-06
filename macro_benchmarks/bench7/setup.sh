#!/bin/bash

#!/bin/bash

# Should be run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y build-essential gfortran openmpi-bin libopenmpi-dev tmux htop git sysstat
