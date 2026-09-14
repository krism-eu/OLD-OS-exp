- type: files
  files:
    # Copia ble.sh nel template utente
    - source: ble.sh/out/ble.sh
      destination: /etc/skel/.local/share/blesh/ble.sh

    # Eventuale doc/lib se ti servono
    #- source: ble.sh/doc
    #  destination: /etc/skel/.local/share/doc/blesh
