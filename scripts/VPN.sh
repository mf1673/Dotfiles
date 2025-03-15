#!/bin/zsh

# Controlla se wg0 è attiva
if sudo wg show wg0 > /dev/null 2>&1; then
    echo "La VPN è attiva, la disattivo..."
    sudo wg-quick down wg0
else
    echo "La VPN non è attiva, la attivo..."
    sudo wg-quick up wg0
fi
