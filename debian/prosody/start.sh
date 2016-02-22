#!/bin/bash
gosu prosody prosodyctl start
tail -f /var/log/prosody/prosody.log
