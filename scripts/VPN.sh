#!/bin/zsh

# Controlla se wg0 è attiva
if sudo wg show wg0 > /dev/null 2>&1; then
    echo "La VPN è attiva, la disattivo..."
    sudo wg-quick down wg0
else
    echo "La VPN non è attiva, la attivo..."
    output=$(sudo wg-quick up wg0 2>&1)
    echo "$output"

    # Se c'è l'errore di resolvconf
    if echo "$output" | grep -q "resolvconf: signature mismatch"; then
        echo "⚠️ Errore resolvconf rilevato, eseguo 'resolvconf -u'..."
        sudo resolvconf -u

        echo "🔄 Riprovo ad attivare la VPN..."
        sudo wg-quick up wg0
    fi
fi
