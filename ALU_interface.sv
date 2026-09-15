import uvm_pkg::*;
`include "uvm_macros.svh"

interface ALU_interface #(
	parameter width = 8
)();

	// logic signals the driver and monitor need
	
	logic [width-1:0] alu_inp_a, alu_inp_b;
	logic [2:0] alu_function_select;
	logic [width-1:0] alu_out;
	logic negative_flag, zero_flag, carry_flag, overflow_flag;

	// no cb because our alu is combinational
	
endinterface