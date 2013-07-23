

DIR=$(shell pwd)

KERNEL=$(DIR)/bzImage
INITRD=$(DIR)/initrd.cpio.gz
QEMU_CONF=-kernel $(KERNEL) \
	  -initrd $(INITRD) \
	  -serial tcp::2345,server \
	  -append \"console=ttyS0 earlyprintk=ttyS0,115200 kgdboc=ttyS0,115200 kgdbwait\" \
	  -nographic

all: build

report:
	@echo "Base directory: $(DIR)"
	@echo "Current kernel: $(KERNEL)"
	@echo "Current initrd: $(INITRD)"

.PHONY: run
run: build
	@echo "Booting BusyBox based x86_64 QEmu/KVM machine..."
	gnome-terminal \
		--hide-menubar \
		--geometry=157x57+-5+-8 \
		--title="QEmu/KVM Machine" \
	-e "qemu-system-x86_64 $(QEMU_CONF)"

.PHONY: build
build: initrd.cpio.gz
initrd.cpio.gz: Makefile init initramfs_list
	@echo "Update initrd image..."
	./gen_initramfs_list.sh -o initrd.cpio.gz  initramfs_list
