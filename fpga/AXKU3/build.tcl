source mkproj_AXKU3_Periodic-AESKeyFinder.tcl
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 20
wait_on_run synth_1
source /home/sawa/ACSAC2025_artifact/fpga/AXKU3/add_iodelay.tcl
launch_runs impl_1 -jobs 20
wait_on_run impl_1

