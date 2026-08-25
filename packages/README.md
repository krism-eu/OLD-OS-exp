# Liste pacchetti myrakuOS

Queste liste descrivono il payload della variante e sono collegate al build in modo esplicito.

- `kde-core.txt`: componenti necessari alla sessione Plasma e all'integrazione desktop.
- `kde-optional.txt`: componenti desktop aggiuntivi, mantenuti separati per facilitare la riduzione successiva.
- `remove.txt`: resta vuoto fino alla validazione della prima baseline.
- `protected-packages.txt`: riferimento per i pacchetti KDE protetti.

Il build non usa i gruppi generici `@fonts` o `@hardware-support`.

Il core RakuOS — overlay, bootc, wrapper DNF, manifest base, update, remove, reset e migrazione — resta di responsabilità della base upstream e non viene duplicato qui.
