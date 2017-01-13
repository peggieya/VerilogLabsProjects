# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Lab5Part2.v

#load simulation using mux as the top level simulation module
vsim Lab5Part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets


#test cases 01,4

force {SW[0]} 1 

force {SW[1]} 0 
force {CLOCK_50} 0
#run simulation for a few ns

run 1000000000ns

#test cases 01,5

force {SW[0]} 1 

force {SW[1]} 0 
force {CLOCK_50} 0
#run simulation for a few ns

run 1000000000ns

#test cases 01,6

force {SW[0]} 1 

force {SW[1]} 0 
force {CLOCK_50} 0
#run simulation for a few ns

run 1000000000ns

#test cases 01,7

force {SW[0]} 1 

force {SW[1]} 0 
force {CLOCK_50} 0
#run simulation for a few ns

run 1000000000ns




#test cases 10,8

force {SW[0]} 0 

force {SW[1]} 1 

#run simulation for a few ns

run 2000000000ns

#test cases 10,9

force {SW[0]} 0 

force {SW[1]} 1 

#run simulation for a few ns

run 2000000000ns

#test cases 10,A

force {SW[0]} 0 

force {SW[1]} 1 

#run simulation for a few ns

run 2000000000ns

#test cases 10,b

force {SW[0]} 0 

force {SW[1]} 1 

#run simulation for a few ns

run 2000000000ns