# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog lab5p2.v

#load simulation using mux as the top level simulation module
vsim lab5p2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
#4
force {HEX[0]} 0
force {HEX[1]} 1
force {HEX[2]} 1
force {HEX[3]} 0
force {HEX[4]} 0
force {HEX[5]} 1
force {HEX[6]} 1
run 10ns
#7
force {HEX0[0]} 1
force {HEX0[1]} 1
force {HEX0[2]} 1
force {HEX0[3]} 0
force {HEX0[4]} 0
force {HEX0[5]} 0
force {HEX0[6]} 0
run 10ns
#10 A
force {HEX0[0]} 1
force {HEX0[1]} 1
force {HEX0[2]} 1
force {HEX0[3]} 0
force {HEX0[4]} 1
force {HEX0[5]} 1
force {HEX0[6]} 1
run 10ns
#12 C
force {HEX0[0]} 1
force {HEX0[1]} 0
force {HEX0[2]} 0
force {HEX0[3]} 1
force {HEX0[4]} 1
force {HEX0[5]} 1
force {HEX0[6]} 0
run 10ns
#13
force {HEX0[0]} 0
force {HEX0[1]} 1
force {HEX0[2]} 1
force {HEX0[3]} 1
force {HEX0[4]} 1
force {HEX0[5]} 0
force {HEX0[6]} 1
run 10ns
#F
force {HEX0[0]} 1
force {HEX0[1]} 0
force {HEX0[2]} 0
force {HEX0[3]} 0
force {HEX0[4]} 1
force {HEX0[5]} 1
force {HEX0[6]} 1
run 10ns
#11 B
force {HEX0[0]} 0
force {HEX0[1]} 0
force {HEX0[2]} 1
force {HEX0[3]} 1
force {HEX0[4]} 1
force {HEX0[5]} 1
force {HEX0[6]} 1
run 10ns

#0
force {HEX1[0]} 1
force {HEX1[1]} 1
force {HEX1[2]} 1
force {HEX1[3]} 1
force {HEX1[4]} 1
force {HEX1[5]} 1
force {HEX1[6]} 0
run 10ns


#1
force {HEX1[0]} 0
force {HEX1[1]} 1
force {HEX1[2]} 1
force {HEX1[3]} 0
force {HEX1[4]} 0
force {HEX1[5]} 0
force {HEX1[6]} 0
run 10ns

#3
force {HEX1[0]} 1
force {HEX1[1]} 1
force {HEX1[2]} 1
force {HEX1[3]} 1
force {HEX1[4]} 0
force {HEX1[5]} 0
force {HEX1[6]} 1
run 10ns

#7
force {HEX1[0]} 1
force {HEX1[1]} 1
force {HEX1[2]} 1
force {HEX1[3]} 0
force {HEX1[4]} 0
force {HEX1[5]} 0
force {HEX1[6]} 0
run 10ns


force {HEX1[0]} 0
force {HEX1[1]} 1
force {HEX1[2]} 1
force {HEX1[3]} 0
force {HEX1[4]} 1
force {HEX1[5]} 1
force {HEX1[6]} 1
run 10ns

