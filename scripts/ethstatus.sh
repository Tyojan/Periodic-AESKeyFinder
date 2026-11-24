#! /bin/bash
#REG
PLethernet_BASE=0xa0080000

echo "MAC status"


echo "MAC ISR"

Status_ISR="0x$(memtool md -l $((PLethernet_BASE+0xC))+4 | awk '{print $2}')"
printf "FIFO_ISR %08X\n" $Status_ISR

if test $((Status_ISR & 0x00000100)) -ne 0 ; then
	printf "PhyRstCmplt "
fi

if test $((Status_ISR & 0x00000080)) -ne 0 ; then
	printf "MgtRdy "
fi
if test $((Status_ISR & 0x00000040)) -ne 0 ; then
	printf "RxDcmLock "
fi
if test $((Status_ISR & 0x00000020)) -ne 0 ; then
	printf "TxCmplt "
fi
if test $((Status_ISR & 0x00000010)) -ne 0 ; then
	printf "RxMemOvr "
fi

if test $((Status_ISR & 0x00000008)) -ne 0 ; then
	printf "RxRject "
fi
if test $((Status_ISR & 0x00000004)) -ne 0 ; then
	printf "RxCmplt "
fi
if test $((Status_ISR & 0x00000002)) -ne 0 ; then
	printf "AutoNeg "
fi
if test $((Status_ISR & 0x00000001)) -ne 0 ; then
	printf "HardAcsCmplt "
fi

printf "\n"


echo "MAC Statistics Counter"
memtool md -l $((PLethernet_BASE+0x200))+0x100 > /dev/null


RecievedBytes="0x$(memtool md -l $((PLethernet_BASE+0x200))+4 | awk '{print $2}')"
printf "Recieved    Bytes:%d\n" $RecievedBytes



#RX Counter
RX64ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x220))+4 | awk '{print $2}')"
printf "RX       64 ByteFrames:%d\n" $RX64ByteFrames

RX65_127ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x228))+4 | awk '{print $2}')"
printf "RX   65-127 ByteFrames:%d\n" $RX65_127ByteFrames

RX128_255ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x230))+4 | awk '{print $2}')"
printf "RX  128-255 ByteFrames:%d\n" $RX128_255ByteFrames

RX256_511ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x238))+4 | awk '{print $2}')"
printf "RX  256-511 ByteFrames:%d\n" $RX256_511ByteFrames

RX512_1023ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x240))+4 | awk '{print $2}')"
printf "RX 512-1023 ByteFrames:%d\n" $RX512_1024ByteFrames

RX1024_MAXByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x248))+4 | awk '{print $2}')"
printf "RX 1024-MAX ByteFrames:%d\n" $RX1024_MAXByteFrames

RXOversizeFrames="0x$(memtool md -l $((PLethernet_BASE+0x250))+4 | awk '{print $2}')"
printf "RX Oversize Frames:%d\n" $RXOversizeFrames

RXGoodFrames="0x$(memtool md -l $((PLethernet_BASE+0x290))+4 | awk '{print $2}')"
printf "RX Good Frames:%d\n" $RXGoodFrames

RXGoodBroadcastFrames="0x$(memtool md -l $((PLethernet_BASE+0x2A0))+4 | awk '{print $2}')"
printf "RX Good Broadcast Frames:%d\n" $RXGoodBroadcastFrames






TransmittedBytes="0x$(memtool md -l $((PLethernet_BASE+0x208))+4 | awk '{print $2}')"
printf "Transmitted Bytes:%d\n" $TransmittedBytes


#TX Counter
TX64ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x258))+4 | awk '{print $2}')"
printf "TX       64 ByteFrames:%d\n" $TX64ByteFrames

TX65_127ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x260))+4 | awk '{print $2}')"
printf "TX   65-127 ByteFrames:%d\n" $TX65_127ByteFrames

TX128_255ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x268))+4 | awk '{print $2}')"
printf "TX  128-255 ByteFrames:%d\n" $TX128_255ByteFrames

TX256_511ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x270))+4 | awk '{print $2}')"
printf "TX  256-511 ByteFrames:%d\n" $TX256_511ByteFrames

TX512_1023ByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x278))+4 | awk '{print $2}')"
printf "TX 512-1023 ByteFrames:%d\n" $TX512_1024ByteFrames

TX1024_MAXByteFrames="0x$(memtool md -l $((PLethernet_BASE+0x280))+4 | awk '{print $2}')"
printf "TX 1024-MAX ByteFrames:%d\n" $TX1024_MAXByteFrames

TXOversizeFrames="0x$(memtool md -l $((PLethernet_BASE+0x288))+4 | awk '{print $2}')"
printf "TX Oversize Frames:%d\n" $TXOversizeFrames

TXGoodFrames="0x$(memtool md -l $((PLethernet_BASE+0x2D8))+4 | awk '{print $2}')"
printf "TX Good Frames:%d\n" $TXGoodFrames

TXGoodBroadcastFrames="0x$(memtool md -l $((PLethernet_BASE+0x2E0))+4 | awk '{print $2}')"
printf "TX Good Broadcast Frames:%d\n" $TXGoodBroadcastFrames

TXGoodMulticastFrames="0x$(memtool md -l $((PLethernet_BASE+0x2E8))+4 | awk '{print $2}')"
printf "TX Good Multicast Frames:%d\n" $TXGoodMulticastFrames

TXGoodUnderrunErrors="0x$(memtool md -l $((PLethernet_BASE+0x2F0))+4 | awk '{print $2}')"
printf "TX Good Underrun  Errors:%d\n" $TXGoodUnderrunErrors

TXGoodControlFrames="0x$(memtool md -l $((PLethernet_BASE+0x2F8))+4 | awk '{print $2}')"
printf "TX Good  Control  Frames:%d\n" $TXGoodControlFrames



echo "Done."
