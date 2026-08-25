# Liste pacchetti myrakuOS

Queste liste descrivono la composizione mirata della variante e sono mantenute separate dagli script upstream.

- `kde-core.txt`: componenti necessari alla sessione Plasma e all'integrazione desktop.
- `kde-optional.txt`: componenti desktop espliciti ma rinviabili se la prima build evidenzia problemi o peso eccessivo.
- `remove.txt`: candidati alla rimozione; resta vuoto fino alla validazione della baseline.
- `protected-packages.txt`: riferimento per la protezione KDE; il manifest effettivo continua a essere generato dalla logica RakuOS.

Non vengono usati gruppi generici come `@fonts` o `@hardware-support`. La compatibilità overlay, bootc e il lifecycle RakuOS restano responsabilità dei file upstream.
