source mkproj_KR260_Periodic-AESKeyFinder.tcl
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 16
wait_on_run synth_1
launch_runs impl_1 -jobs 16
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1


