source mkproj_AXKU062_Periodic-AESKeyFinder.tcl
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 16
wait_on_run synth_1
launch_runs impl_1 -jobs 16
wait_on_run impl_1

