#!/bin/sh
# Chiede all'utente di inserire il nome della jail
echo -n "Inserisci il nome della jail da cancellare: "
read name
# Controlla che l'utente abbia inserito un nome
if [ -z "$name" ]; then
  echo "Errore: nessun nome della jail inserito."
  exit 1
fi
# Spegni la jail
echo "Spegnimento della jail $name..."
service jail stop $name
# Controlla se il comando di spegnimento ha avuto successo
if [ $? -ne 0 ]; then
  echo "Errore: impossibile spegnere la jail $name. Verifica che la jail esista e sia in esecuzione."
  exit 1
fi
# Rimuovi flag di protezione dai file
echo "Rimuovendo flag di protezione per /usr/jails/$name..."
chflags -R 0 /usr/jails/$name
# Smonta il dataset ZFS
echo "Smontando zroot/usr/jails/$name..."
zfs unmount -f zroot/usr/jails/$name
# Distruggi il dataset ZFS
echo "Distruggendo zroot/usr/jails/$name..."
zfs destroy zroot/usr/jails/$name
echo "La jail $name è stata cancellata con successo."



