# Скриншоты для домашнего задания GFS2

## Список скриншотов

| Файл | Описание | Команды |
|------|----------|---------|
| 01-environment.png | Подготовка окружения | `kvm-ok`, `virsh list --all`, `terraform --version`, `ansible --version` |
| 02-terraform-apply.png | Создание инфраструктуры Terraform | `terraform apply -auto-approve` (outputs с IP адресами) |
| 03-network-ssh.png | IP адреса ВМ и SSH подключение | `virsh domifaddr ... --source arp`, `ssh ubuntu@...` |
| 04-iscsi-target.png | Настройка iSCSI Target | `sudo tgtadm --lld iscsi --op show` |
| 05-iscsi-initiators.png | iSCSI диски на узлах | `lsblk` на всех трёх узлах (видно /dev/sda 5G) |
| 06-lvm.png | LVM настройка | `sudo lvdisplay`, `sudo vgs`, `sudo pvs` |
| 07-gfs2-mounted.png | GFS2 примонтирована | `df -h /mnt/gfs2` на всех трёх узлах |
| 08-final-test.png | Финальная проверка | `lsmod \| grep gfs2`, `ls -la /mnt/gfs2`, `df -h` |
