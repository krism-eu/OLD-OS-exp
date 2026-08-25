# Liste pacchetti myrakuOS

La variante usa una composizione KDE esplicita, senza i gruppi generici `@fonts` e `@hardware-support`.

Il build installa il set KDE mirato in `build_files/build.sh`. Il file `post-build-overlay.sh` aggiunge al manifest effettivo solo i componenti KDE core protetti.

Il core RakuOS — overlay, bootc, wrapper DNF, manifest base, update, remove, reset e migrazione — deve provenire dalla logica upstream di `rakuos-base` e non viene reinventato nella variante.
