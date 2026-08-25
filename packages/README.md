# Liste pacchetti

Le liste separano le decisioni progettuali dal Containerfile.

- `kde-core.txt`: pacchetti KDE necessari alla sessione e all'uso desktop di base.
- `kde-optional.txt`: pacchetti KDE o desktop rinviabili, installabili eventualmente tramite overlay, Flatpak o Distrobox.
- `remove.txt`: pacchetti della base o del desktop da rimuovere dopo la composizione iniziale.
- `protected-packages.txt`: riferimento per il manifest protetto; deve rimanere coerente con base RakuOS + KDE effettivamente installato.

`pacchetti_base.txt` resta un inventario comparativo e non una lista automatica di rimozione.
