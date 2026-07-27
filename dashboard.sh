#!/bin/bash
# Dashboard PRO - vista en tablas alineadas, refresco cada 5s
# Uso: ./dashboard.sh
# Para salir: Ctrl+C

while true; do
  clear
  echo -e "\033[1;37;44m 🖥️  DASHBOARD PRO │ $(date +%H:%M:%S) \033[0m"
  echo ""

  echo -e "\033[1;33m══════════════════════ TOP 5 CPU ══════════════════════\033[0m"
  printf "\033[1;37m%-7s %-10s %7s %7s %-25s\033[0m\n" "PID" "USER" "%CPU" "%MEM" "COMANDO"
  ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu --no-headers | head -5 | awk '{
    if($3>70) color="\033[1;31m";
    else if($3>30) color="\033[1;33m";
    else color="\033[0m";
    printf "%s%-7s %-10s %6s%% %6s%% %-25s\033[0m\n", color, $1, $2, $3, $4, $5
  }'
  echo ""

  echo -e "\033[1;33m══════════════════════ TOP 5 MEM ══════════════════════\033[0m"
  printf "\033[1;37m%-7s %-10s %7s %7s %-25s\033[0m\n" "PID" "USER" "%CPU" "%MEM" "COMANDO"
  ps -eo pid,user,%cpu,%mem,comm --sort=-%mem --no-headers | head -5 | awk '{
    if($4>70) color="\033[1;31m";
    else if($4>30) color="\033[1;33m";
    else color="\033[0m";
    printf "%s%-7s %-10s %6s%% %6s%% %-25s\033[0m\n", color, $1, $2, $3, $4, $5
  }'
  echo ""

  echo -e "\033[1;33m══════════════════════════ DISCO ══════════════════════════\033[0m"
  printf "\033[1;37m%-15s %-8s %6s %6s %6s %6s %s\033[0m\n" "FILESYSTEM" "TIPO" "SIZE" "USED" "AVAIL" "USE%" "MONTAJE"
  df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs | tail -n +2 | awk '{
    pct=substr($6,1,length($6)-1)+0;
    if(pct>90) color="\033[1;31m";
    else if(pct>80) color="\033[1;33m";
    else color="\033[0m";
    printf "%s%-15s %-8s %6s %6s %6s %6s %s\033[0m\n", color, $1, $2, $3, $4, $5, $6, $7
  }'
  echo ""

  echo -e "\033[1;33m══════════════════════════ RAM (MB) ══════════════════════════\033[0m"
  printf "\033[1;37m%-7s %6s %6s %6s %6s %9s %9s\033[0m\n" "" "TOTAL" "USED" "FREE" "SHARED" "BUFF/CACHE" "AVAILABLE"
  free -m | awk 'NR==2{
    total=$2; used=$3; free=$4; shared=$5; buffcache=$6; avail=$7;
    pct=(used/total)*100;
    if(pct>90) color="\033[1;31m";
    else if(pct>70) color="\033[1;33m";
    else color="\033[1;32m";
    printf "%s%-7s %6d %6d %6d %6d %9d %9d\033[0m\n", color, "Mem:", total, used, free, shared, buffcache, avail
  }'
  echo ""

  echo -e "\033[1;33m══════════════════════════ PUERTOS ══════════════════════════\033[0m"
  printf "\033[1;37m%-6s %-10s %-40s %s\033[0m\n" "PROTO" "ESTADO" "DIRECCION:PUERTO" "PROCESO"
  ss -tulnp 2>/dev/null | grep LISTEN | awk '{printf "%-6s %-10s %-40s %s\n", $1, $2, $5, $7}'

  sleep 5
done