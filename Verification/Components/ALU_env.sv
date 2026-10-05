// include import
import uvm_pkg::*;
`include "uvm_macros.svh"


// class header
class ALU_env #(
	parameter width = 8
) extends uvm_env;


// constructor and factory registration
`uvm_component_param_utils(ALU_env #(width))

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

		ALU_agent #(width) agent;
		ALU_scoreboard #(width) scoreboard;
		ALU_coverage #(width) coverage;

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		agent = ALU_agent #(width)::type_id::create("agent", this);
		scoreboard = ALU_scoreboard #(width)::type_id::create("scoreboard", this);
		coverage = ALU_coverage #(width)::type_id::create("coverage", this);
	endfunction

// function connect phase
	// connect agent, scoreboard, and coverage subscriber

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.monitor.mon_analysis_port.connect(scoreboard.ap_imp);
		agent.monitor.mon_analysis_port.connect(coverage.analysis_export);
	endfunction

endclass

