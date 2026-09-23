import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_coverage #(
	parameter width = 8
) extends uvm_subscriber#(ALU_transaction #(width));

	`uvm_component_param_utils(ALU_coverage #(width))

	ALU_transaction #(width) trans;

	covergroup ALU_cg;
	// alu operation coverpoint: have we tested x function?
		coverpoint trans.alu_function_select {
			bins add = {3'b000};
			bins sub ={3'b001};
			bins and_function ={3'b010};
			bins or_function ={3'b011};
			bins not_function ={3'b100};
			bins xor_function ={3'b101};
			bins left_shift ={3'b110};
			bins right_shift ={3'b111};
		}

	// alu_inp and alu_out coverpoint: have we tried these notable input and output conditions
		coverpoint trans.alu_inp_a {
			bins min = {{width{1'b0}}};
			bins max = {{width{1'b1}}};
			bins negative = {
			[{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-1){1'b1}}}]
			};
			bins other = {
			[{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}]
			};

		}

		coverpoint trans.alu_inp_b {
			bins min = {{width{1'b0}}};
			bins max = {{width{1'b1}}};
			bins negative = {
			[{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-1){1'b1}}}]
			};
			bins other = {
			[{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}]
			};

		}

		coverpoint trans.alu_out {
			bins min = {{width{1'b0}}};
			bins max = {{width{1'b1}}};
			bins negative = {
			[{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-1){1'b1}}}]
			};
			bins other = {
			[{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}]
			};

		}

	// flag coverpoints: have we tested these flag conditions?
		coverpoint trans.zero_flag {
			bins zero = {1'b1};
			bins not_zero = {1'b0};
		}
		coverpoint trans.carry_flag {
			bins carry = {1'b1};
			bins no_carry = {1'b0};
		}
		coverpoint trans.overflow_flag {
			bins overflow = {1'b1};
			bins no_overflow = {1'b0};
		}
		coverpoint trans.negative_flag {
			bins negative = {1'b1};
			bins positive = {1'b0};
		}
	
	endgroup

	function new(string name = "coverage", uvm_component parent = null);
		super.new(name, parent);
		ALU_cg = new();
	endfunction

	function void write(ALU_transaction #(width) t);
		trans = t;
		ALU_cg.sample();
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("COVERAGE", $sformatf("Functional coverage: %0.2f%%", ALU_cg.get_coverage()), UVM_LOW)
	endfunction

endclass
