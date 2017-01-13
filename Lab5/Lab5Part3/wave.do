# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog lab5p3.v

#load simulation using mux as the top level simulation module
vsim lab5p3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}


#output morse for "A"

force {KEY[1]} 0 

force {KEY[0]} 1 

force {SW[2]} 0 

force {SW[1]} 0 

force {SW[0]} 0 

run 5500000000ns




#load "C"

force {KEY[1]} 1

force {KEY[0]} 0

force {SW[2]} 0

force {SW[1]} 1

force {SW[0]} 0

run 20ns




#output morse for "C"

force {KEY[1]} 0 

force {KEY[0]} 1 

force {SW[2]} 0 

force {SW[1]} 1 

force {SW[0]} 0 

run 5500000000ns

#




#load "F"

force {KEY[1]} 1

force {KEY[0]} 0

force {SW[2]} 1

force {SW[1]} 0

force {SW[0]} 1

run 20ns




#output morse for "f"

force {KEY[1]} 0 

force {KEY[0]} 1 

force {SW[2]} 1 

force {SW[1]} 0 

force {SW[0]} 1 

run 5500000000ns

#