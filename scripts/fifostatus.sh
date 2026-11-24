#! /bin/bash
#REG

#FIFO
FIFO_BASE=0xa0060000

FIFO_ISR=$((FIFO_BASE))
FIFO_IER=$((FIFO_BASE+0x4))
FIFO_TDFR=$((FIFO_BASE+0x8))
FIFO_TDFV=$((FIFO_BASE+0xC))

FIFO_TLR=$((FIFO_BASE+0x14))

FIFO_RDFR=$((FIFO_BASE+0x18))
FIFO_RDFO=$((FIFO_BASE+0x1C))

FIFO_TDR=$((FIFO_BASE+0x2C))

AXI_FIFO=0xA0060000


#sleep 1
echo "FIFO status"
memtool md -l $FIFO_BASE+128




Status_ISR="0x$(memtool md -l $FIFO_ISR+4 | awk '{print $2}')"
printf "FIFO_ISR %08X\n" $Status_ISR

if test $((Status_ISR & 0x80000000)) -ne 0 ; then
	printf "RPURE "
fi
if test $((Status_ISR & 0x40000000)) -ne 0 ; then
	printf "RPORE "
fi
if test $((Status_ISR & 0x20000000)) -ne 0 ; then
	printf "RPUE "
fi
if test $((Status_ISR & 0x10000000)) -ne 0 ; then
	printf "TPOE "
fi

if test $((Status_ISR & 0x08000000)) -ne 0 ; then
	printf "TC "
fi
if test $((Status_ISR & 0x04000000)) -ne 0 ; then
	printf "RC "
fi
if test $((Status_ISR & 0x02000000)) -ne 0 ; then
	printf "TSE "
fi
if test $((Status_ISR & 0x01000000)) -ne 0 ; then
	printf "TRC "
fi

if test $((Status_ISR & 0x00800000)) -ne 0 ; then
	printf "RRC "
fi
if test $((Status_ISR & 0x00400000)) -ne 0 ; then
	printf "TFPF "
fi
if test $((Status_ISR & 0x00200000)) -ne 0 ; then
	printf "TFPE "
fi
if test $((Status_ISR & 0x00100000)) -ne 0 ; then
	printf "RFPF "
fi

if test $((Status_ISR & 0x00080000)) -ne 0 ; then
	printf "RFPE "
fi
if test $((Status_ISR & 0x00040000)) -ne 0 ; then
	printf "TEF2BE "
fi
if test $((Status_ISR & 0x00020000)) -ne 0 ; then
	printf "TEF1BE "
fi

printf "\n"




echo "Done."
