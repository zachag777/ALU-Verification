import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_monitor #(
	parameter width = 8
) extends uvm_monitor;

	`uvm_component_param_utils(ALU_monitor #(width))
	
	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	// create interface handle
	// create analysis port handle

	virtual ALU_interface #(width) aluif;
	uvm_analysis_port #(ALU_transaction #(width)) mon_analysis_port;

	// build phase
	// build analysis port
	// store interface from db into local interface handle
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_analysis_port = new("mon_analysis_port", this);

		void'(uvm_config_db #(virtual ALU_interface #(width))::get(this, "", "aluif", aluif));

	endfunction
	
	// task run phase

	task run_phase(uvm_phase phase);

	// transaction handle
		ALU_transaction #(width) trans;

		forever begin 
			@(aluif.alu_inp_a or aluif.alu_inp_b or aluif.alu_function_select)
			#1; // wait for dut to settle
	// create transaction
			trans = ALU_transaction #(width)::type_id::create("trans");

	// set trans.signal equal to interface.signal
			//inputs
			trans.alu_inp_a = aluif.alu_inp_a;
			trans.alu_inp_b = aluif.alu_inp_b;
			trans.alu_function_select = aluif.alu_function_select;

			//outputs
			trans.alu_out = aluif.alu_out;
			trans.negative_flag = aluif.negative_flag;
			trans.carry_flag = aluif.carry_flag;
			trans.zero_flag = aluif.zero_flag;
			trans.overflow_flag = aluif.overflow_flag;

	// write transaction to monitor analysis port
			mon_analysis_port.write(trans);
		end
	endtask
endclass
