import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_random_sequence #(
	parameter width = 8
) extends uvm_sequence #(ALU_transaction #(width));
	
	`uvm_object_param_utils(ALU_random_sequence #(width))
	function new(string name = "rand_seq");
		super.new(name);
	endfunction

	task body();
		ALU_transaction #(width) trans;

		repeat (1000) begin
			trans = ALU_transaction #(width)::type_id::create("trans");
			
			start_item(trans);
			assert(trans.randomize());
			finish_item(trans);
		end

	endtask
	
endclass
