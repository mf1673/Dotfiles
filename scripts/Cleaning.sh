#!/bin/bash

#rimozione pacchetti orfani
sudo pacman -Qdtq | -Rns -

#pulizia cache /var/cache/pacman/pkg/
sudo pacman -Sc

#rimozione pkg vecchi di 3 versioni
sudo paccache -r

#rimozione cache ~/.cache
#sudo rm -rf ~/.cache

#rimozione duplicati, direcotory e  file vuoti, symbolic link rotti
sudo pacman -S rmlint
