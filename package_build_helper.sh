#!/bin/bash
# Shell script to compile a package for all the architectures.
# This was made in order to simplify package creation within the Void Linux
# package manager (X Binary Package System)
#
# NOTE: This script builds the package for EVERY architecture.
#       If you need to package something only for specific archs then create
#       your own script or modify this one (or create the pkg by hand).
#
# Licensed under the Public Domain.
# Made by rc-05 @ https://github.com/rc-05

# Extract all the architectures from the xbps-src program.
architectures=$(./xbps-src -h | tail -c 2634 | head -c 296 \
| sed -e "s/\t/ /g" -e "s/ //g")

# An array to collect the failed builds for the architectures.
failed_builds=()
succesful_builds=()

# The supplied package name.
pkg_name=$1

# Logging enabled?
log_build=false

# Number of CPU cores: this is used to enable parallel building for a
# package.
num_cores=$(lscpu --all --parse=CORE,SOCKET | grep -Ev "^#" | sort -u | wc -l)

if [[ $pkg_name == "" ]]; then
  echo "[HELPER] Supply a package name."
  exit -1
fi

# Compile the package for every single architecture, even if it means
# waiting days and days: we need to make sure that the package can be
# effectively be available to everybody and every arch.
for i in $architectures; do
  echo "[HELPER] Compiling for $i..."

  if [[ "$log_build" = true ]]; then
    ./xbps-src $pkg_name -j $num_cores -a $i $pkg_name 2>&1 >$pkg_name-$i.log
  else
    ./xbps-src $pkg_name -j $num_cores -a $i $pkg_name
  fi

  if [[ $(echo $?) -eq 0 ]]; then
    succesful_builds+=($i)
  else
    failed_builds+=($i)
  fi
done

# Print the failed architectures if there are any, otherwise print a nice
# message and go celebrate with a delicious beer!
if [[ ${#failed_builds[*]} -eq 0 ]]; then
  echo "[HELPER] No failed builds! Congratulations :)"
else
  echo "[HELPER] Succesful builds:"
  for i in ${succesful_builds[@]}; do
    echo "         $i"
  done
  echo "[HELPER] Failed builds:"
  for i in ${failed_builds[@]}; do
    echo "         $i"
  done
fi

exit 0
