onerror {quit -f}
vlib work
vlog -work work SingleCyceProcessor.vo
vlog -work work SingleCyceProcessor.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.singleCycleProc_vlg_vec_tst
vcd file -direction SingleCyceProcessor.msim.vcd
vcd add -internal singleCycleProc_vlg_vec_tst/*
vcd add -internal singleCycleProc_vlg_vec_tst/i1/*
add wave /*
run -all
