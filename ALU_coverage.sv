import uvm_pkg::*;

class ALU_coverage #(
	parameter width = 8
) extends uvm_subscriber#(ALU_transaction #(width));

	`uvm_component_param_utils(ALU_coverage #(width))

	ALU_transaction #(width) trans;

	covergroup ALU_cg;
	// alu operation coverpoint: have we tested x function?
		coverpoint trans.alu_operation {
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
			{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-2){1'b1}},1'b0}
			};
			bins other = {
			{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}
			};

		}

		coverpoint trans.alu_inp_b {
			bins min = {{width{1'b0}}};
			bins max = {{width{1'b1}}};
			bins negative = {
			{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-2){1'b1}},1'b0}
			};
			bins other = {
			{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}
			};

		}

		coverpoint trans.alu_out {
			bins min = {{width{1'b0}}};
			bins max = {{width{1'b1}}};
			bins negative = {
			{1'b1,{(width-1){1'b0}}} :
			{1'b1,{(width-2){1'b1}},1'b0}
			};
			bins other = {
			{{(width-1){1'b0}}, 1'b1} : 
			{1'b0, {(width-1){1'b1}}}
			};

		}

	// flag coverpoints: have we tested these flag conditions?
		coverpoint trans.zero_flag {
			bins zero = {1'b1};
			bins not_zero = {1'b0};
		}
	


	endgroup

	function new(string name = "coverage", uvm_component parent = null);
		super.new(name, parent);
		ALU_cg = new();
	endfunction

	function void write(ALU_transaction t);
		trans = t;
		ALU_cg.sample();
	endfunction

endclass
