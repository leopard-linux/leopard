all: make_dirs generate_rootfs generate_iso

make_dirs:
	mkdir -p build
	mkdir -p build/boot
	mkdir -p build/rootfs

generate_initrd: make_dirs
	$(MAKE) -C initramfs

# TODO: compile kernel
generate_rootfs: make_dirs generate_initrd
	cp -r ./isolinux ./build/rootfs/
	cp -r ./build/boot/ ./build/rootfs/boot/
	cp -r /usr/lib/syslinux/modules/bios/*.c32 ./build/rootfs/isolinux

	# cp -r ../../sources/linux-5.7/arch/

generate_iso: make_dirs generate_rootfs
	cd ./build && \
		mkisofs -o linux.iso \
			-b isolinux/isolinux.bin -c isolinux/boot.cat \
			-no-emul-boot -boot-load-size 4 -boot-info-table \
			rootfs

clean:
	rm -rf ./build
	rm -rf ./initramfs/root
