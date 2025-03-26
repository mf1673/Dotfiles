#!/bin/sh


#delimitatore
delim="|"


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--|BATTERY|--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#


batteria() {
    livello=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep "percentage" | cut -d ":" -f2 | xargs | tr -d '%')
    stato=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep "state" | cut -d ":" -f2 | xargs)
    
    if [ "$stato" = "charging" ]; then
        if [ "$livello" -le 10 ]; then simbolo="$livello% 󰢜"
        elif [ "$livello" -le 20 ]; then simbolo="$livello% 󰂆 "
        elif [ "$livello" -le 30 ]; then simbolo="$livello% 󰂇 "
        elif [ "$livello" -le 40 ]; then simbolo="$livello% 󰂈 "
        elif [ "$livello" -le 50 ]; then simbolo="$livello% 󰢝 "
        elif [ "$livello" -le 60 ]; then simbolo="$livello% 󰂉 "
        elif [ "$livello" -le 70 ]; then simbolo="$livello% 󰢞 "
        elif [ "$livello" -le 80 ]; then simbolo="$livello% 󰂊 "
        elif [ "$livello" -le 90 ]; then simbolo="$livello% 󰂋 "
        else simbolo="󰂄"; fi
    else
        if [ "$livello" -le 10 ]; then simbolo="$livello% 󰁺"
        elif [ "$livello" -le 20 ]; then simbolo="$livello% 󰁻"
        elif [ "$livello" -le 30 ]; then simbolo="$livello% 󰁽"
        elif [ "$livello" -le 40 ]; then simbolo="$livello% 󰁽"
        elif [ "$livello" -le 50 ]; then simbolo="$livello% 󰁾"
        elif [ "$livello" -le 60 ]; then simbolo="$livello% 󰁿"
        elif [ "$livello" -le 70 ]; then simbolo="$livello% 󰂀"
        elif [ "$livello" -le 80 ]; then simbolo="$livello% 󰂁"
        elif [ "$livello" -le 90 ]; then simbolo="$livello% 󰂂"
        else simbolo="󰁹"; fi
    fi
    
    echo "$simbolo"
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

volume() {
    livello=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' | cut -d '.' -f1)
    
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
        simbolo=" "
    elif [ "$livello" -eq 0 ]; then
        simbolo=" "
    elif [ "$livello" -le 40 ]; then
        simbolo=" "
    else
        simbolo=" "
    fi
    echo "$simbolo $livello%"
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

cpu_usage() {
  PREV_TOTAL=0
  PREV_IDLE=0

  # Legge i dati da /proc/stat
  read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))

  # Calcola la differenza rispetto alla lettura precedente
  DIFF_IDLE=$((idle - PREV_IDLE))
  DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
  
  # Se è la prima esecuzione, saltiamo il calcolo
  if [ "$DIFF_TOTAL" -eq 0 ]; then
    echo "0.0%"
    return
  fi

  # Calcola l'utilizzo della CPU con decimali
  DIFF_USAGE=$(awk "BEGIN {printf \"%.2f\", (100 * ($DIFF_TOTAL - $DIFF_IDLE) / $DIFF_TOTAL)}")
  echo "$DIFF_USAGE%"

  PREV_TOTAL=$TOTAL
  PREV_IDLE=$idle
}


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

check_bluetooth() {
    BLUETOOTH_ICON=""
    NOT_CONNECTED_ICON="󰂲"
    NO_BLUETOOTH_ICON="❌"

    # Controlla se il Bluetooth è attivo
    if ! systemctl is-active --quiet bluetooth; then
        echo "$NO_BLUETOOTH_ICON"
        return
    fi

    # Controlla i dispositivi connessi
    DEVICE_NAME=$(bluetoothctl devices Connected | awk '{$1=$2=""; print $0}' | sed 's/^ *//')

    if [ -n "$DEVICE_NAME" ]; then
        echo "$BLUETOOTH_ICON  $DEVICE_NAME"
    else
        echo "$NOT_CONNECTED_ICON"
    fi
}


# rfkill block bluetooth rfkill unblock bluetooth  pair + connect 70:AE:D5:CE:E6:6A


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

check_internet() {
    WIFI_ICON=" "
    ETHERNET_ICON="󰈀 "
    VPN_ICON="󰒄 "
    NO_CONNECTION_ICON=" "
    DISABLED_ICON="❌"  

    # Controlla se l'interfaccia di rete è attiva
    if ! ip link show | grep -q "UP"; then
        echo "$DISABLED_ICON Internet disabilitato"
        return
    fi
    # Controlla se abbiamo accesso a Internet
    if ! ping -c 1 1.1.1.1 &> /dev/null; then
        echo "$NO_CONNECTION_ICON "
        return
    fi



    # Controlla il Wi-Fi
    if nmcli con show | sed -n '2p'| grep -q "wifi"; then
        WIFI_NAME=$(nmcli con show | sed -n '2p'| cut -d " " -f1)
        echo "$WIFI_ICON ($WIFI_NAME)"
        return
    fi

    # Controlla Ethernet
    if nmcli con show | sed -n '2p' | grep -q "ethernet"; then
        IP_ETH=$(ip -4 addr show enp7s0 | awk '/inet / {print $2}' | cut -d/ -f1)
        echo "$ETHERNET_ICON ($IP_ETH)"
        return
    fi


    # Controlla VPN
    #if ip a | grep -q "wg0"; then
    #    echo "$VPN_ICON VPN attiva"
    #    return
    #fi

    # Se nessuna connessione viene trovata
    echo "N/A"
}





#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#--------------------------------------------------------------------------------#
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#


status(){

  echo "$delim"
  cpu_usage | awk '{printf ("  %2.2f%\n", $1)}'
  
  echo "$delim"
  free --mebi | sed -n '2{p;q}' | awk '{printf (" %2.2fGiB\n", ( $3 / 1024), ($2 / 1024))}'
  
  echo "$delim"
  df -h / | grep /dev/nvme0n1p7 | xargs | cut -d " " -f3 | awk '{printf (" %3.0fGB\n", $1)}'
  
  echo "$delim"
  check_internet 
  
  echo "$delim"
  check_bluetooth
   
  echo "$delim"
  volume 
 
  echo "$delim"
  batteria

  echo "$delim"
  date '+%a %d %b %H:%M' | sed -E 's/^(.)/\U\1/' 

} 


while :; do

  xsetroot -name "$(status | tr '\n' ' ')"
  
  sleep 1
done
