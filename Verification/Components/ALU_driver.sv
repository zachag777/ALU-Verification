import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_driver #(
	parameter width = 8
) extends uvm_driver #(ALU_transaction #(width));
	// constructor + factory registration
	`uvm_component_param_utils(ALU_driver #(width))

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	// get interface handle

	virtual ALU_interface #(width) aluif;

	// function build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		void'(uvm_config_db #(virtual ALU_interface #(width))::get(this, "", "aluif", aluif));// put interface from top level tb into local interface
	endfunction

	// task run phase

	virtual task run_phase(uvm_phase phase);

	// get transaction handle
	ALU_transaction #(width) trans;

	// forever begin
	forever begin
	// get transaction from sequencer
	// seq item port get next item
		seq_item_port.get_next_item(trans);

	// drive interface with input signals of transaction
		aluif.alu_inp_a <= trans.alu_inp_a;
		aluif.alu_inp_b <= trans.alu_inp_b;
		aluif.alu_function_select <= trans.alu_function_select;

		#2;
		

	// seq item done
		seq_item_port.item_done();

//end
	end
//endtask
	endtask

endclass
