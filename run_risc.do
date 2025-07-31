vlib work
vlog alu.v controller.v counter.v driver.v memory.v multiplexor.v register.v TOP.v risc_test.v
vsim -voptargs=+acc work.risc_test
add wave *
run -all
#quit -sim