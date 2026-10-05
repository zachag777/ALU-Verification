// include and import
import uvm_pkg::*;
`include "uvm_macros.svh"

// class header extends uvm_agent
class ALU_agent #(
	parameter width = 8
) extends uvm_agent;

// factory registration
	`uvm_component_param_utils(ALU_agent #(width))

// constructor
	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

// create local handle for sequencer, driver, and monitor
	ALU_sequencer #(width) sequencer;
	ALU_driver #(width) driver;
	ALU_monitor #(width) monitor;

// function void build phase
	// if active build sequencer and driver
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active()) begin
			sequencer = ALU_sequencer #(width)::type_id::create("sequencer", this);
			driver = ALU_driver #(width)::type_id::create("driver", this);
		end
	// always build monitor (active or passive)
		monitor = ALU_monitor #(width)::type_id::create("monitor", this);
	endfunction

// function void connect phase

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
	// if active connect sequencer and driver
		if(get_is_active())
			driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction

// end
endclass