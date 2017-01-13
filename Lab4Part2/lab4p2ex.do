# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog mux.v

#load simulation using mux as the top level simulation module
vsim mux
# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in partThree.v to working dir
# could also have multiple verilog files
vlog lab4Part2.v

#load simulation using mux as the top level simulation module
vsim lab4Part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# test case 1, sw9,rest=0,clock=0 out is 0, a=1
force {SW[9]} 0
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
force {KEY[3]} 0
force {KEY[2]} 0
force {KEY[1]} 0
#run simulation for a few ns
run 10ns

# test case 2, rest=0,clock=1 out is 0, a=1
force {SW[9]} 0
force {KEY[0]} 1

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
force {KEY[3]} 0
force {KEY[2]} 0
force {KEY[1]} 0
#run simulation for a few ns
run 10ns

#test case 3, reset=1, clk=0, a=2, func=0, b=0, out=0
force {SW[9]} 1
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[3]} 0
force {KEY[2]} 0
force {KEY[1]} 1
run 10ns

#test case 4, reset=1, clk=1, a=2, func=0, b=0, out=2
force {SW[9]} 1
force {KEY[0]} 1

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#test case 5, reset=1,clk=0, a=4, func=0, b=2, out=2
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#test case 6, reset=1,clk=1, a=4, func=0, b=2, out=6[0000 0110]
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#test case 7, reset=1, clk=0,a=4, func=0, b=6, out=6[0000 0110]same
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 1
run 10ns

#test case 8, reset=1, clk=1,a=4, func=0, b=6, out=6[0000 0110]same
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 1
run 10ns

#test case 9, reset=1, clk=0,a=0010, func=010, b=0110, out=[0000 0110]last
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 0
run 10ns

#test case 10, reset=1, clk=1,a=0010, func=010, b=0110, out=[0100 0110]
force {SW[9]} 1
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 0
run 10ns

#test case 11,  reset=1, clk=0,a=0000 sw, func=011 key, b=0110, out=[0100 0110]last
force {SW[9]} 1
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#test case 12,  reset=1, clk=1,a=0000 sw, func=011 key, b=0110, out=[1000 0001]
force {SW[9]} 1 
force {KEY[0]} 1

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#test case 13, reset=1, clk=0,a=0000 sw, func=100 key, b=0001, out=[1000 0001]last
force {SW[9]} 1 
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 0
run 10ns

#test case 14, reset=1, clk=1,a=0000 sw, func=100 key, b=0001, out=[1000 0001]
force {SW[9]} 1
force {KEY[0]} 1

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 0
run 10ns

#test case 15, reset=1, clk=0,a=0010 sw, func=101 key, b=0001, out=[1000 0001]last
force {SW[9]} 1
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 1
run 10ns

#test case 16, reset=1, clk=1,a=0010 sw, func=101 key, b=0100, out=[0000 0100]
force {SW[9]} 1 
force {KEY[0]} 1

force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 0
force {KEY[1]} 1
run 10ns

#test case 17, reset=1, clk=0,a=0100[4] sw, func=110 key, b=0100[4], out=[0000 0100]last
force {SW[9]} 1 
force {KEY[0]} 0

force {SW[3]} 0
force {SW[2]} 1
force {SW[1]} 0
force {SW[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 0
run 10ns


