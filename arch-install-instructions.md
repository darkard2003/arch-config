# Arch Install Instructions

## Make a boot device, and boot into arch install medium

While at the boot manager, make a note of wether there is UEFI or BIOS written beside the arch option. This guide will only cover UEFI devices. BIOS is also easy, but out of this scope.

## Connect to the internet

### Ethernet

If you have ethernet cable, connect it. and use this command.

```bash
ip link
```

### Wifi

If you have wifi, use ```iwctl``` comand to connect to the wifi.

### Test the internet

```bash
ping archlinux.org -c10
```

Check if your computer can ping the arch servers

## Sync the time

Run ```timedatectl``` to ensure the clocks are syncronised.

## Partition the disk

### Locate your disk

Run ```lsblk``` and look for the disk. it can be sda, nvme0n1, vda etc. The disk with the most volume is most likely it.

### Partition your disk

we need four pattion

Partition |Type |Size
--------- |---- |----
Efi   |fat 32 |1G
Boot   |ext4 |1G
Swap   |swap |Double your ram
LVM   |LUKS |Rest of the disk space

Use ```fdisk``` or ```cfdisk``` to make the partitons.

### Formatting the partition

- For fat-32 use ```mkfs.fat -F32 <your partition>```
- For ext4 use ```mkfs.ext4 <your partition>```
- for swap use ```mkswap <your swap partition>```
- LUKS will be setup in next section

## Setting up LUKS and LVM

### Encrypt the disk with luks

```bash
cryptsetup luksFormat <your luks partition>
```

Enter a valid password when prompted to, and remember it.

### Open the encrypted disk

```bash
cryptsetup open <your luks partition> --type=luks <volume name>
```

Enter the password when prompted
Now your parition should be accessable at /dev/mapper/volume_name

### Create a physical volume at /dev/mapper/name

```bash
pvcreate /dev/mapper/volume_name
```

### Create a virtual group

```bash
vgcreate <your group name> /dev/mapper/volume_name
```

### Create logical volume

```bash
lvcreate -l100%FREE -n <logical volume name> <group name>
```

This volume will be your root partition

### Load dm_mod module

```bash
modprobe dm_mod
```

### Activate all volume groups

```bash
vgscan
vgchange -ay
```

### Format root partition

```bash
mkfs.btrfs /dev/<your volume group>/<root volume>
```

### Mount all the partitions and install linux

Mount all the partitions

```bash
mount /dev/<volume group>/<root volume> /mnt
mkdir /mnt/boot
mount /dev/<Boot partition> /mnt/boot
mkdir /mnt/boot/EFI
mount /dev/<efi patition> /mnt/boot/EFI
swapon /dev/<swap partition>
```

Now install linux with all nessesory packages

```bash
pacstrap -K /mnt base linux linux-headers linux-firmware base-devel networkmanager grub efibootmgr lvm2 mtools vim dosfstools
```

## Generate FSTAB and chroot into your system

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

```bash
arch-chroot /mnt
```

## Post-Install Setup

### Set your locale

- Open /etc/locale.gen
- Uncomment your locale. For me it's en_US.UTF-8
- run ```locale-gen```
- Create a file /etc/locale.conf
- write ```LANG=en_US.UTF-8``` or your locale

### Sync your clock

```bash
hwclock --systohc
```

### Create root password and local user

1. Create root password using ```passwd```
2. Create a local user using ```useradd -mg users -G wheel <username>```
3. Create local user password using ```passwd <username>```

### Install optional dependencys

```bash
pacman -S sof-firmware mesa 
```

- Intel specific packages

```bash
pacman -S intel-media-drivers intel-ucode
```

- AMD specific packages

``` bash
pacman -S libva-mesa-driver amd-ucode
```

### Edit mkinitcpio

- Open the file ```/etc/mkinitcpio.conf```
- Inside the HOOKS array we need to insert ```encrypt lvm2``` between block and filesystem
- Run mkinitcpio for every linux kernal you have ```mkinitcpio -p linux```

### Configure grub

- Open ```/etc/default/grub``` 
- locate ```GRUB_CMDLINE_LINUX_DEFAULT```
- Add ```cryptdevice=/dev/<lvm partition>:<volume group>``` just before quiet
- Copy the grub locale ```cp /usr/share/locale/en\@quot/LC_MESSAGE/grub.mo /boot/grub/locale/en.mo```
- Install grub using ```grub-install```
- Generate grub config ```grub-mkconfig -o /boot/grub/grub.cfg```

### Enable systemctl services

- ```Systemctl enable NetworkManager```

Now exit out from chroot usint ```exit``` and reboot.
