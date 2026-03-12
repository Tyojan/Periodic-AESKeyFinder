#
# flash-kernel: bootscr.zynqmp.kria
#

# This is a boot script for U-Boot
# Generate boot.scr:
# mkimage -c none -A arm -T script -d boot.cmd boot.scr
# For initrd, when using a file override:
# mkimage -A arm -O linux -T ramdisk -d initrd.img rootfs.cpio.gz.u-boot
# Kernel "Image" file must be of EFI type:
# - Get vmlinuz from Ubuntu rootfs and uncompress
# system.dtb is a normal dtb file
#
#
# Here is the Kria board support list:
#
# Kria board                     | DTB Name                      |
# :----------------------------- | :---------------------------- |
# Revision A   KR Carrier Card   | smk-k26-revA-sck-kr-g-revA    |
# Revision B/1 KR Carrier Card   | smk-k26-revA-sck-kr-g-revB    |
# Revision A/Z KV Carrier Card   | smk-k26-revA-sck-kv-g-revA    |
# Revision B/1 KV Carrier Card   | smk-k26-revA-sck-kv-g-revB    |
# Revision A   KD Carrier Card   | smk-k24-revA-sck-kd-g-revA    |
#
#
# Variables expected to be in the environment:
#
# Variable       | Description                                                                           |
# :------------- | :------------------------------------------------------------------------------------ |
# card1_name     | Holds the information about the carrier card configuration (utilized for Kria family) |
# boot_targets   | Includes the list of devices that can be used to look for image boot                  |
#
#
# Local Variables:
#
# Variable        | Description                                                                           |
# :-------------- | :------------------------------------------------------------------------------------ |
# kria            | Holds the information about the type of the board in Kria family.                     | \
#                 | Possible values when it is initialized: "KD", "KR", "KV"                              |
################



# Legacy KV260 U-Boot was not eliminating a space at the end of the card1_name variable
# e.g. card1_name is "SCK-KV-G ", not "SCK-KV-G"
# Force drop of the extra space character by setenv for backward compatibility
setenv card1_name $card1_name

for boot_target in ${boot_targets};
do
  if test "${boot_target}" = "jtag" ; then
    booti 0x00200000 0x04000000 0x00100000
    exit;
  fi
  if test "${boot_target}" = "mmc0" || test "${boot_target}" = "mmc1" || test "${boot_target}" = "usb0" || test "${boot_target}" = "usb1"; then
    # Load alternative bitstream if present
#    if test -e ${devtype} ${devnum}:${distro_bootpart} /system.bit; then
    if test -e ${devtype} ${devnum}:${distro_bootpart} /system.bit; then
      echo "set PL0 333MHz"
      mw 0xFF5E00c0 0x01010300
#      echo "set PL1 200MHz"
#      mw 0xFF5E00c4 0x01010500

      echo "Loading alternative bitstream"
      load ${devtype} ${devnum}:${distro_bootpart} 0x10000000 system.bit
#      load ${devtype} ${devnum}:${distro_bootpart} 0x10000000 AESKeyFinder300.bit
      fpga load 0 0x10000000 $filesize
      sleep 1
      mw 0xa00c0010 0x100000
      echo "AESKeyFinder Start!"
      sleep 5
    fi

    # Check for KR/KV260 board and choose the proper device tree
    if test "${card1_name}" = "SCK-KV-G" || test "${card1_name}" = "SCK-KR-G" || test "${card1_name}" = "SCK-KD-G"; then
      echo "Selecting DT for Kria boards"
      if test "${card1_name}" = "SCK-KV-G"; then
        setenv kria "KV"
        if test "${card1_rev}" = "Z" || test "${card1_rev}" = "A"; then
          # revA dtb also supports revZ boards
          boot_conf=#conf-smk-k26-revA-sck-kv-g-revA
        elif test "${card1_rev}" = "B" || test "${card1_rev}" = "1" || test "${card1_rev}" = "2"; then
          # revB dtb also supports rev1 and rev2 boards
          boot_conf=#conf-smk-k26-revA-sck-kv-g-revB
        else
          # fallback to the latest dtb
          boot_conf=#conf-smk-k26-revA-sck-kv-g-revB
        fi
      elif test "${card1_name}" = "SCK-KR-G"; then
        setenv kria "KR"
        if test "${card1_rev}" = "B" || test "${card1_rev}" = "1"; then
          # revB dtb also supports rev1 dtb
          boot_conf=#conf-smk-k26-revA-sck-kr-g-revB
        elif test "${card1_rev}" = "A"; then
          boot_conf=#conf-smk-k26-revA-sck-kr-g-revA
        else
          # fallback to the latest dtb
          boot_conf=#conf-smk-k26-revA-sck-kr-g-revB
        fi
      elif test "${card1_name}" = "SCK-KD-G"; then
        boot_conf=#conf-zynqmp-smk-kd-g-revA
        setenv kria "KD"
      else
        # fallback dtb
        boot_conf=#conf-zynqmp-smk-k26-revA
        echo "The detected Kria board is not in the supported list"
      fi
      echo "Kria DT: ${boot_conf}"
    fi

    setenv bootargs "root=LABEL=writable rootwait cpuidle.off=1"
    if test "${card1_name}" = "SCK-KR-G" || test "${card1_name}" = "SCK-KV-G" || test "${card1_name}" = "SCK-KD-G"; then
      setenv bootargs "${bootargs} earlycon console=ttyPS1,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio xilinx_tsn_ep.st_pcp=4"
    else
      setenv bootargs "${bootargs} earlycon console=ttyPS0,115200 uio_pdrv_genirq.of_id=generic-uio"
    fi

    echo "Configuring the cma value based on the board type"

    fdt addr $fdtcontroladdr
    # For Kria: ZynqMP K26 Rev*
    # For Kria: ZynqMP K24 Rev*
    fdt get value model_test / model
    if test $kria = "KD"; then
      cma="512M"
    elif  test -n $kria; then
      cma="1000M"
    fi

    if test -n $cma; then
      echo "cma=${cma}"
      setenv bootargs "${bootargs} cma=${cma}"
    fi

    # Get custom values from /etc/default/flash-kernel
#    setenv bootargs " ${bootargs} quiet splash"
    img_addr=-
    initrd_addr=-

    # Take dtb from boot image unless Kria, where we take from FIT
    if test -n $kria; then
      dtb_addr=0x10000000${boot_conf}
    else
      dtb_addr=$fdtcontroladdr
    fi

    if test -e ${devtype} ${devnum}:${distro_bootpart} /Image; then
      echo "Loading Image"
      img_addr=0x00200000
      load ${devtype} ${devnum}:${distro_bootpart} ${img_addr} Image;
    fi
    if test -e ${devtype} ${devnum}:${distro_bootpart} /user-override.dtb; then
      echo "Loading user-override.dtb"
      dtb_addr=0x70000000
      load ${devtype} ${devnum}:${distro_bootpart} ${dtb_addr} user-override.dtb;
    fi
    if test -e ${devtype} ${devnum}:${distro_bootpart} /rootfs.cpio.gz.u-boot; then
      echo "Loading rootfs.cpio.gz.u-boot"
      initrd_addr=0x04000000
      load ${devtype} ${devnum}:${distro_bootpart} ${initrd_addr} rootfs.cpio.gz.u-boot
    fi

    

    if test $img_addr = "-" || test $initrd_addr = "-"; then
      if test -e ${devtype} ${devnum}:${distro_bootpart} /image.fit; then
        echo "Loading image.fit"
        load ${devtype} ${devnum}:${distro_bootpart} 0x10000000 image.fit;
        if test $img_addr = "-"; then
          if test -n $kria; then
            img_addr=0x10000000${boot_conf}
          else
            img_addr=0x10000000
          fi
        fi
        if test $initrd_addr = "-"; then
          if test -n $kria; then
            initrd_addr=0x10000000${boot_conf}
          else
            initrd_addr=0x10000000
          fi
        fi
      fi
    fi
    if test "${img_addr}" -eq "0x10000000"; then
      bootm ${img_addr} ${initrd_addr} ${dtb_addr}
    elif test "${img_addr}" -eq "0x00200000"; then
      booti ${img_addr} ${initrd_addr} ${dtb_addr}
    fi
    echo "No kernel found in ${devtype}"
    exit;
  fi
  if test "${boot_target}" = "xspi0" || test "${boot_target}" = "qspi" || test "${boot_target}" = "qspi0"; then
    sf probe 0 0 0;
    if test "image.fit" = "image.fit"; then
      sf read 0x10000000 0xF00000 0x6400000;
      bootm 0x10000000;
      exit;
    fi
    if test "image.fit" = "Image"; then
      sf read 0x00200000 0xF00000 0x1D00000;
      sf read 0x04000000 0x4000000 0x4000000
      booti 0x00200000 0x04000000 0x00100000
      exit;
    fi
    exit;
  fi
  if test "${boot_target}" = "nand" || test "${boot_target}" = "nand0"; then
    nand info
    if test "image.fit" = "image.fit"; then
      nand read 0x10000000 0x4100000 0x6400000;
      bootm 0x10000000;
      exit;
    fi
    if test "image.fit" = "Image"; then
      nand read 0x00200000 0x4100000 0x3200000;
      nand read 0x04000000 0x7800000 0x3200000;
      booti 0x00200000 0x04000000 0x00100000
      exit;
    fi
  fi
done
