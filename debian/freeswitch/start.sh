#!/bin/bash
set -e

if [ "$1" = 'freeswitch' ]; then
	chown -R freeswitch:freeswitch /etc/freeswitch
	chown -R freeswitch:freeswitch /var/{run,lib}/freeswitch
	# chown -R freeswitch:freeswitch /{db,certs,scripts,recordings,tmp}

	if [ -d /docker-entrypoint.d ]; then
		for f in /docker-entrypoint.d/*.sh; do
			[ -f "$f" ] && . "$f"
		done
	fi

        ulimit -c unlimited # The maximum size of core files created.
        ulimit -d unlimited # The maximum size of a process's data segment.
        ulimit -f unlimited # The maximum size of files created by the shell (default option)
        ulimit -n 999999    # The maximum number of open file descriptors.
        ulimit -v unlimited # The maximum amount of virtual memory available to the process.
        ulimit -x unlimited # ???
        ulimit -s 240         # The maximum stack size
        ulimit -a           # All current limits are reported.
        # Docker doesn't like those:
        # ulimit -i unlimited # The maximum number of pending signals
        # ulimit -q unlimited # The maximum POSIX message queue size
        # ulimit -u unlimited # The maximum number of processes available to a single user.
        # ulimit -l unlimited # The maximum size that may be locked into memory.

	exec gosu freeswitch freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
