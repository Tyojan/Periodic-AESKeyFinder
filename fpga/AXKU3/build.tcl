source mkproj_AXKU3_Periodic-AESKeyFinder.tcl
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 20
wait_on_run synth_1
source add_iodelay.tcl
launch_runs impl_1 -jobs 20
wait_on_run impl_1

