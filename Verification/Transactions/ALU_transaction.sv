import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_transaction #(
	parameter width = 8
) extends uvm_sequence_item;

	`uvm_object_param_utils(ALU_transaction #(width))

	// inputs
	rand logic [width-1:0] alu_inp_a, alu_inp_b;
	rand logic [2:0] alu_function_select;
	

	// outputs
	logic [width-1:0] alu_out;
	logic negative_flag, zero_flag, carry_flag, overflow_flag;

	function new(string name = "trans");
		super.new(name);
	endfunction

endclass