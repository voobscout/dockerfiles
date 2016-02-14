#!/bin/bash
if [ -d /start.sh.d ]; then
		for f in /start.sh.d/*.sh; do
			  [ -f "$f" ] && . "$f"
		done
fi

! [ $# -eq 0 ] && exec $@ || exec /bin/bash -l
