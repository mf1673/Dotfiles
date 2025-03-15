#!/bin/zsh
echo "Inserisci un numero:"
read val

swww query || swww-daemon

swww img $HOME/.config/wallpapers/$val.jpg --transition-fps 60 --transition-type outer  --transition-duration 3

