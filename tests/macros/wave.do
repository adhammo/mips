add wave -noupdate -label clk -radix binary /cpu_tb/clk
add wave -noupdate -label rst -radix binary /cpu_tb/rst
add wave -noupdate -group Ports -label input -radix hexadecimal /cpu_tb/in
add wave -noupdate -group Ports -label output -radix hexadecimal /cpu_tb/out
add wave -noupdate -group Pipeline -label flush -radix binary /cpu_tb/cpu/pipe_unit/flush
add wave -noupdate -group Pipeline -label stall -radix binary /cpu_tb/cpu/pipe_unit/stall
add wave -noupdate -group Pipeline -label extend -radix binary /cpu_tb/cpu/pipe_unit/extend
add wave -noupdate -group Pipeline -label dirty -radix binary /cpu_tb/cpu/pipe_unit/dirty
add wave -noupdate -group Pipeline -label keep -radix binary /cpu_tb/cpu/pipe_unit/keep
add wave -noupdate -group Fetch -label jump -radix binary /cpu_tb/cpu/jump
add wave -noupdate -group Fetch -label jumpM -radix binary /cpu_tb/cpu/jumpM
add wave -noupdate -group Fetch -label memTarget -radix hexadecimal /cpu_tb/cpu/memTarget
add wave -noupdate -group Fetch -label target -radix hexadecimal /cpu_tb/cpu/target
add wave -noupdate -group Fetch -label instrAddr -radix hexadecimal /cpu_tb/cpu/instrAddr
add wave -noupdate -group Fetch -label fetch -radix binary /cpu_tb/cpu/fetch
add wave -noupdate -group Fetch -label fetchSrc -radix binary /cpu_tb/cpu/fetchSrc
add wave -noupdate -group Fetch -label pc_in -radix hexadecimal /cpu_tb/cpu/pc_in
add wave -noupdate -group Fetch -label pc_in -radix hexadecimal /cpu_tb/cpu/pc_src
add wave -noupdate -group Fetch -label pc -radix hexadecimal /cpu_tb/cpu/pc
add wave -noupdate -group Fetch -label instr -radix hexadecimal /cpu_tb/cpu/instr
add wave -noupdate -group Decode -label pc -radix hexadecimal /cpu_tb/cpu/id_pc
add wave -noupdate -group Decode -label instr -radix hexadecimal /cpu_tb/cpu/id_instr
add wave -noupdate -group Decode -label opcode /cpu_tb/cpu/opcode
add wave -noupdate -group Decode -label rdst -radix unsigned /cpu_tb/cpu/rdst
add wave -noupdate -group Decode -label rsrc1 -radix unsigned /cpu_tb/cpu/rsrc1
add wave -noupdate -group Decode -label rsrc2 -radix unsigned /cpu_tb/cpu/rsrc2
add wave -noupdate -group Decode -label imm -radix hexadecimal /cpu_tb/cpu/imm
add wave -noupdate -group Decode -label rd1 -radix hexadecimal /cpu_tb/cpu/rd1
add wave -noupdate -group Decode -label rd2 -radix hexadecimal /cpu_tb/cpu/rd2
add wave -noupdate -group Decode -group control -label hlt -radix binary /cpu_tb/cpu/hlt
add wave -noupdate -group Decode -group control -label branch -radix binary /cpu_tb/cpu/branch
add wave -noupdate -group Decode -group control -label setC -radix binary /cpu_tb/cpu/setC
add wave -noupdate -group Decode -group control -label load -radix binary /cpu_tb/cpu/load
add wave -noupdate -group Decode -group control -label in -radix binary /cpu_tb/cpu/in
add wave -noupdate -group Decode -group control -label out -radix binary /cpu_tb/cpu/out
add wave -noupdate -group Decode -group control -label imm1 -radix binary /cpu_tb/cpu/imm1
add wave -noupdate -group Decode -group control -label imm2 -radix binary /cpu_tb/cpu/imm2
add wave -noupdate -group Decode -group control -label skipE -radix binary /cpu_tb/cpu/skipE
add wave -noupdate -group Decode -group control -label func -radix binary /cpu_tb/cpu/func
add wave -noupdate -group Decode -group control -label skipM -radix binary /cpu_tb/cpu/skipM
add wave -noupdate -group Decode -group control -label int -radix binary /cpu_tb/cpu/int
add wave -noupdate -group Decode -group control -label call -radix binary /cpu_tb/cpu/call
add wave -noupdate -group Decode -group control -label ret -radix binary /cpu_tb/cpu/ret
add wave -noupdate -group Decode -group control -label push -radix binary /cpu_tb/cpu/push
add wave -noupdate -group Decode -group control -label pop -radix binary /cpu_tb/cpu/pop
add wave -noupdate -group Decode -group control -label wr -radix binary /cpu_tb/cpu/wr
add wave -noupdate -group Decode -group control -label skipW -radix binary /cpu_tb/cpu/skipW
add wave -noupdate -group Decode -label stallD -radix binary /cpu_tb/cpu/stallD
add wave -noupdate -group Execute -label pc -radix hexadecimal /cpu_tb/cpu/ex_pc
add wave -noupdate -group Execute -label rdst -radix unsigned /cpu_tb/cpu/ex_rdst
add wave -noupdate -group Execute -label rsrc1 -radix unsigned /cpu_tb/cpu/ex_rsrc1
add wave -noupdate -group Execute -label rsrc2 -radix unsigned /cpu_tb/cpu/ex_rsrc2
add wave -noupdate -group Execute -label imm -radix hexadecimal /cpu_tb/cpu/ex_imm
add wave -noupdate -group Execute -label input -radix hexadecimal /cpu_tb/cpu/ex_input
add wave -noupdate -group Execute -label rd1 -radix hexadecimal /cpu_tb/cpu/ex_rd1
add wave -noupdate -group Execute -label rd2 -radix hexadecimal /cpu_tb/cpu/ex_rd2
add wave -noupdate -group Execute -group control -label branch -radix binary /cpu_tb/cpu/ex_branch
add wave -noupdate -group Execute -group control -label setC -radix binary /cpu_tb/cpu/ex_setC
add wave -noupdate -group Execute -group control -label load -radix binary /cpu_tb/cpu/ex_load
add wave -noupdate -group Execute -group control -label in -radix binary /cpu_tb/cpu/ex_in
add wave -noupdate -group Execute -group control -label out -radix binary /cpu_tb/cpu/ex_out
add wave -noupdate -group Execute -group control -label imm1 -radix binary /cpu_tb/cpu/ex_imm1
add wave -noupdate -group Execute -group control -label imm2 -radix binary /cpu_tb/cpu/ex_imm2
add wave -noupdate -group Execute -group control -label skipE -radix binary /cpu_tb/cpu/ex_skipE
add wave -noupdate -group Execute -group control -label func -radix binary /cpu_tb/cpu/ex_func
add wave -noupdate -group Execute -group control -label skipM -radix binary /cpu_tb/cpu/ex_skipM
add wave -noupdate -group Execute -group control -label int -radix binary /cpu_tb/cpu/ex_int
add wave -noupdate -group Execute -group control -label call -radix binary /cpu_tb/cpu/ex_call
add wave -noupdate -group Execute -group control -label ret -radix binary /cpu_tb/cpu/ex_ret
add wave -noupdate -group Execute -group control -label push -radix binary /cpu_tb/cpu/ex_push
add wave -noupdate -group Execute -group control -label pop -radix binary /cpu_tb/cpu/ex_pop
add wave -noupdate -group Execute -group control -label wr -radix binary /cpu_tb/cpu/ex_wr
add wave -noupdate -group Execute -group control -label skipW -radix binary /cpu_tb/cpu/ex_skipW
add wave -noupdate -group Execute -label fwd1 -radix binary /cpu_tb/cpu/fwd1
add wave -noupdate -group Execute -label fwd2 -radix binary /cpu_tb/cpu/fwd2
add wave -noupdate -group Execute -label s1 -radix hexadecimal /cpu_tb/cpu/s1
add wave -noupdate -group Execute -label s2 -radix hexadecimal /cpu_tb/cpu/s2
add wave -noupdate -group Execute -label r -radix hexadecimal /cpu_tb/cpu/r
add wave -noupdate -group Execute -group {New Flags} -label zo -radix binary /cpu_tb/cpu/exec_unit/zo
add wave -noupdate -group Execute -group {New Flags} -label no -radix binary /cpu_tb/cpu/exec_unit/no
add wave -noupdate -group Execute -group {New Flags} -label co -radix binary /cpu_tb/cpu/exec_unit/co
add wave -noupdate -group Execute -group Flags -label z -radix binary /cpu_tb/cpu/z
add wave -noupdate -group Execute -group Flags -label n -radix binary /cpu_tb/cpu/n
add wave -noupdate -group Execute -group Flags -label c -radix binary /cpu_tb/cpu/c
add wave -noupdate -group Execute -label jump -radix binary /cpu_tb/cpu/jump
add wave -noupdate -group Execute -label target -radix hexadecimal /cpu_tb/cpu/target
add wave -noupdate -group Memory -label pc -radix hexadecimal /cpu_tb/cpu/me_pc
add wave -noupdate -group Memory -label rdst -radix unsigned /cpu_tb/cpu/me_rdst
add wave -noupdate -group Memory -label s1 -radix hexadecimal /cpu_tb/cpu/me_s1
add wave -noupdate -group Memory -label r -radix hexadecimal /cpu_tb/cpu/me_r
add wave -noupdate -group Memory -label s2 -radix hexadecimal /cpu_tb/cpu/me_s2
add wave -noupdate -group Memory -label me_target -radix hexadecimal /cpu_tb/cpu/me_target
add wave -noupdate -group Memory -group control -label out -radix binary /cpu_tb/cpu/me_out
add wave -noupdate -group Memory -group control -label skipE -radix binary /cpu_tb/cpu/me_skipE
add wave -noupdate -group Memory -group control -label skipM -radix binary /cpu_tb/cpu/me_skipM
add wave -noupdate -group Memory -group control -label int -radix binary /cpu_tb/cpu/me_int
add wave -noupdate -group Memory -group control -label call -radix binary /cpu_tb/cpu/me_call
add wave -noupdate -group Memory -group control -label ret -radix binary /cpu_tb/cpu/me_ret
add wave -noupdate -group Memory -group control -label push -radix binary /cpu_tb/cpu/me_push
add wave -noupdate -group Memory -group control -label pop -radix binary /cpu_tb/cpu/me_pop
add wave -noupdate -group Memory -group control -label wr -radix binary /cpu_tb/cpu/me_wr
add wave -noupdate -group Memory -group control -label skipW -radix binary /cpu_tb/cpu/me_skipW
add wave -noupdate -group Memory -label sp -radix hexadecimal /cpu_tb/cpu/sp
add wave -noupdate -group Memory -label r_s1 -radix hexadecimal /cpu_tb/cpu/r_s1
add wave -noupdate -group Memory -label do -radix hexadecimal /cpu_tb/cpu/do
add wave -noupdate -group Memory -label memInput -radix hexadecimal /cpu_tb/cpu/memInput
add wave -noupdate -group Memory -label state -radix hexadecimal /cpu_tb/cpu/mem_control/state
add wave -noupdate -group Memory -label count -radix hexadecimal /cpu_tb/cpu/mem_control/count
add wave -noupdate -group Write -label pc -radix hexadecimal /cpu_tb/cpu/wb_pc
add wave -noupdate -group Write -label rdst -radix unsigned /cpu_tb/cpu/wb_rdst
add wave -noupdate -group Write -label r_s1 -radix hexadecimal /cpu_tb/cpu/wb_r_s1
add wave -noupdate -group Write -label do -radix hexadecimal /cpu_tb/cpu/wb_do
add wave -noupdate -group Write -group control -label out -radix binary /cpu_tb/cpu/wb_out
add wave -noupdate -group Write -group control -label skipM -radix binary /cpu_tb/cpu/wb_skipM
add wave -noupdate -group Write -group control -label skipW -radix binary /cpu_tb/cpu/wb_skipW
add wave -noupdate -group Write -label wd -radix hexadecimal /cpu_tb/cpu/wd
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 119
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
WaveRestoreZoom {0 ns} {1200 ns}
