#!/usr/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpupower/files/init.d,v 1.1 2013/04/23 01:48:26 ssuominen Exp $

change() {
	local c ret=0 opts="$1"
	shift
	ebegin "Running cpupower -c all frequency-set ${opts}"
		cpupower -c all frequency-set ${opts} >/dev/null 2>&1
		: $(( ret += $? ))
	eend ${ret}

	if [ $# -gt 0 ] ; then
		c=1
		einfo "Setting extra options: $*"
		if cd /sys/devices/system/cpu/cpufreq ; then
			local o v
			for o in "$@" ; do
				v=${o#*=}
				o=${o%%=*}
				echo ${v} > ${o} || break
			done
			c=0
		fi
		eend ${c}
		: $(( ret += c ))
	fi

	return ${ret}
}

start() {
	change "${START_OPTS}"
}

stop() {
	change "${STOP_OPTS}"
}
