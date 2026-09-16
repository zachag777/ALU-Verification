// import include
import uvm_pkg::*;
`include "uvm_macros.svh"

// class header
class ALU_sequencer #(
	parameter width = 8
) extends uvm_sequencer #(ALU_transaction #(width));

// factory registration
	`uvm_component_param_utils(ALU_sequencer #(width));
// constructor

	function new(string name = "sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction

endclass


