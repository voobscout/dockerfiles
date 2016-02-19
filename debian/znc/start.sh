#!/bin/bash
# Make sure $DATADIR is owned by znc user. This affects ownership of the
# mounted directory on the host machine too.

# DATADIR="/znc-data"

# chown -R znc:znc "$DATADIR"
# --datadir=$DATADIR
# Start ZNC.
exec gosu znc znc --foreground "$@"
