// include and import
import uvm_pkg::*;
`include "uvm_macros.svh"

// class header extends base test
class ALU_random_test #(
	parameter width = 8
) extends ALU_base_test #(width);
	// factory reg and constructor

	`uvm_component_param_utils(ALU_random_test #(width))

	function new(string name = "rand_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	task run_phase(uvm_phase phase);
		ALU_random_sequence #(width) rand_seq;

		phase.raise_objection(this);

		rand_seq = ALU_random_sequence #(width)::type_id::create("rand_seq",this);

		rand_seq.start(env.agent.sequencer);

		phase.drop_objection(this);		

	endtask

endclass

class ALU_random_test_8 extends ALU_random_test #(8);
	`uvm_component_utils(ALU_random_test_8)

	function new(string name = "rand_test_8", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass