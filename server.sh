#!/bin/bash

LOGFILE="server_performance_$(date +%F_%T).log"


check_cpu() {
  echo "### CPU Usage ###" >> "$LOGFILE"
  top -l 1 | grep "CPU usage" >> "$LOGFILE"
  echo >> "$LOGFILE"
}


check_memory() {
  echo "### Memory Usage ###" >> "$LOGFILE"
  vm_stat | awk 'BEGIN {FS=":"} {total += $2} END {print "Total Memory: " total * 4096 / (1024^3) " GB"}' >> "$LOGFILE"
  echo >> "$LOGFILE"
  echo "Free and Used Memory:" >> "$LOGFILE"
  vm_stat >> "$LOGFILE"
  echo >> "$LOGFILE"
}

check_disk_usage() {
  echo "### Disk Usage ###" >> "$LOGFILE"
  df -h / >> "$LOGFILE"
  echo >> "$LOGFILE"
}

check_network() {
  echo "### Network Usage ###" >> "$LOGFILE"
  netstat -ib | grep -e "Name" -e "en0" >> "$LOGFILE"
  echo >> "$LOGFILE"
}


check_load_average() {
  echo "### Load Average ###" >> "$LOGFILE"
  sysctl -n vm.loadavg >> "$LOGFILE"
  echo >> "$LOGFILE"
}


echo "Server Performance Report - $(date)" > "$LOGFILE"
echo "====================================" >> "$LOGFILE"
check_cpu
check_memory
check_disk_usage
check_network
check_load_average

echo "Report saved to $LOGFILE"
