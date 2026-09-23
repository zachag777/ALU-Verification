import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_base_test #(
	parameter width = 8
) extends uvm_test;

	function new(string name = "test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	`uvm_component_param_utils(ALU_base_test #(width))
	// create environment
	ALU_env #(width) env;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = ALU_env #(width)::type_id::create("env", this);
	endfunction

endclass
