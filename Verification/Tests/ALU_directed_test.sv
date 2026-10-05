// include and import
import uvm_pkg::*;
`include "uvm_macros.svh"

// class header extends base test
class ALU_directed_test #(
	parameter width = 8
) extends ALU_base_test #(width);
	// factory reg and constructor

	`uvm_component_param_utils(ALU_directed_test #(width))

	function new(string name = "dir_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	task run_phase(uvm_phase phase);

		ALU_directed_logic_sequence #(width) logic_seq;
		ALU_directed_shift_sequence #(width) shift_seq;
		ALU_directed_add_sequence #(width) add_seq;
		ALU_directed_sub_sequence #(width) sub_seq;

		phase.raise_objection(this);
		logic_seq = ALU_directed_logic_sequence #(width)::type_id::create("logic_seq",this);
		logic_seq.start(env.agent.sequencer);

		shift_seq = ALU_directed_shift_sequence #(width)::type_id::create("shift_seq",this);
		shift_seq.start(env.agent.sequencer);

		add_seq = ALU_directed_add_sequence #(width)::type_id::create("add_seq",this);
		add_seq.start(env.agent.sequencer);
	
		sub_seq = ALU_directed_sub_sequence #(width)::type_id::create("sub_seq",this);
		sub_seq.start(env.agent.sequencer);
		phase.drop_objection(this);		

	endtask

endclass

class ALU_directed_test_8 extends ALU_directed_test #(8);
	`uvm_component_utils(ALU_directed_test_8)

	function new(string name = "dir_test_8", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass
