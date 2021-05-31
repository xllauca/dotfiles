#!/bin/bash
/usr/sbin/ifconfig ens33 2>/dev/null| grep "inet " | awk '{print $2}'
