#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2019-02-15 21:31:10 +0000 (Fri, 15 Feb 2019)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Install RPM packages in a forgiving way - useful for install Perl CPAN and Python PyPI modules that may or may not be available (will retry cpanm / pip later if they are not found)

set -eu
[ -n "${DEBUG:-}" ] && set -x

echo "Installing RPM Packages"

rpm_packages="$(cat "$@" | sed 's/#.*//; /^[[:space:]]*$/d' | sort -u)"

[ -z "$rpm_packages" ] && exit 0

SUDO=""
[ "${EUID:-$(id -u)}" != 0 ] && SUDO=sudo

if [ -n "${NO_FAIL:-}" ]; then
    $SUDO yum install -y $rpm_packages
else
    # must install separately to check install succeeded because yum install returns 0 when some packages installed and others didn't
    for package in $rpm_packages; do
        rpm -q "$package" || $SUDO yum install -y "$package"
    done
fi
