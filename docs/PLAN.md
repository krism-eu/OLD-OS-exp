# myrakuOS Slim KDE — piano di sviluppo

## Obiettivo
Creare una variante KDE più leggera derivata dalla catena RakuOS, mantenendo atomicità, bootc, aggiornamenti/rollback e overlay persistente.

## Principi
- Conservare invariato il core RakuOS responsabile di overlay, sync, update, remove, reset e protezione della base.
- Usare `pacchetti_base.txt` solo come inventario comparativo.
- Separare KDE core, KDE opzionale e rimozioni.
- Rigenerare le protezioni in base ai pacchetti realmente presenti.
- Procedere per checkpoint e modifiche reversibili.

## Fasi
1. Confrontare la bozza con `rakuos-base` e `rakuos-kde`.
2. Stabilizzare base RakuOS + KDE selezionato senza rimozioni aggressive.
3. Rimuovere applicazioni e optional chiaramente non necessari.
4. Validare boot, login KDE, rete, audio, reboot e overlay persistente.
5. Solo dopo, ridurre ulteriormente la base Fedora.

## Componenti da non modificare nella prima iterazione
- servizi e script `rakuos-overlay-*`;
- `rakuos-base-protect`;
- install/update/remove/reset/migrate;
- wrapper DNF e generazione del manifest;
- kernel, initramfs, bootc e componenti di recovery.

## Criteri di accettazione
- Immagine avviabile e aggiornabile.
- KDE funzionante.
- RPM installato nell'overlay persistente dopo reboot.
- Overlay coerente dopo aggiornamento e rollback.
- Nessun pacchetto rimosso presente nel manifest protetto.

## Stato
Questo branch contiene inizialmente solo documentazione e liste placeholder. Il Containerfile e gli script esistenti restano invariati fino al completamento del confronto tecnico.
