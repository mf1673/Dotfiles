#!/bin/bash

# Imposta la directory di partenza (default: /)
DIR="${1:-/}"

# Mostra dimensioni umane, solo primo livello, ordina per dimensione crescente
du -h --max-depth=1 "$DIR" 2>/dev/null | sort -h
