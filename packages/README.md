# Liste pacchetti myrakuOS

La variante usa una composizione KDE esplicita e mirata.

Sono esclusi i gruppi generici `@fonts` e `@hardware-support`, il gaming, i pacchetti i686 e i componenti CachyKernel.

Il supporto minimo alla virtualizzazione host viene mantenuto per eseguire VM classiche sul PC: QEMU/KVM, libvirt e virt-manager. I guest tools VirtualBox/VMware/SPICE/Hyper-V e QEMU guest agent non fanno parte dell'immagine.

Il core RakuOS — overlay, bootc, wrapper DNF, manifest base, update, remove, reset e migrazione — deve rimanere quello upstream.
