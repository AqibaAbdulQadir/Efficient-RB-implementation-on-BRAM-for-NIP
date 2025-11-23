iverilog -o sim/out src/*.v sim/tb_top.v
./sim/out            
gtkwave sim/wave.vcd 