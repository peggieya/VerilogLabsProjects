# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in partThree.v to working dir
# could also have multiple verilog files
vlog lab4p3.v

#load simulation using mux as the top level simulation module
vsim lab4p3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# test case 1, rest=0, clock=0
force {SW[9]} 0
force {KEY[0]} 0 
force {KEY[3]} 1 
force {KEY[2]} 1
force {KEY[1]} 1

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
#run simulation for a few ns
run 10ns

# test case 2, rest=0,clock=0 out is 0, a=1, pass in 00010001
force {SW[9]} 0
force {KEY[0]} 0 #clk=0
force {KEY[3]} 0 # asright=0
force {KEY[2]} 1 #rright=1
force {KEY[1]} 0 #pload 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
#run simulation for a few ns
run 10ns

#test case 3, rest=0,clock=1, shift right pass 00010001
force {SW[9]} 0
force {KEY[0]} 1
force {KEY[3]} 0 # asright=0
force {KEY[2]} 1 #rright=1
force {KEY[1]} 0 #pload 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
run 10ns

#test case 4, rest=0,clock=0 shift left 00100010
force {SW[9]} 0
force {KEY[0]} 0
force {KEY[3]} 0 # asright=0
force {KEY[2]} 0 #rright=1
force {KEY[1]} 1 #pload 1
run 10ns

#test case 5, rest=0,clock=1 shift left 00100010
force {SW[9]} 0
force {KEY[0]} 1
force {KEY[3]} 0 # asright=0
force {KEY[2]} 0 #rright=1
force {KEY[1]} 1 #pload 1
run 10ns

# test case 6, rest=0,clock=0 out is 0, a=1, pass in 00010001
force {SW[9]} 0
force {KEY[0]} 0 #clk=0
force {KEY[3]} 0 # asright=0
force {KEY[2]} 0 #rright=1
force {KEY[1]} 0 #pload 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
#run simulation for a few ns
run 10ns

#test case 7, rest=0,clock=1, shift left 00100010
force {SW[9]} 0
force {KEY[0]} 1
force {KEY[3]} 0 # asright=0
force {KEY[2]} 0 #rright
force {KEY[1]} 0 #pload 0

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
run 10ns

# test case 8, rest=0,clock=0 out is 0, a=1, pass in 11010000
force {SW[9]} 0
force {KEY[0]} 0 #clk=0
force {KEY[3]} 1 # asright=0
force {KEY[2]} 1 #rright
force {KEY[1]} 0 #pload 0

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
#run simulation for a few ns
run 10ns

#test case 9, rest=0,clock=1, shift right 11101000
force {SW[9]} 0
force {KEY[0]} 1
force {KEY[3]} 1 # asright
force {KEY[2]} 1 #rright
force {KEY[1]} 0 #pload 0

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns