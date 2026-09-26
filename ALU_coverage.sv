import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_coverage #(
	parameter width = 8
) extends uvm_subscriber#(ALU_transaction #(width));

	`uvm_component_param_utils(ALU_coverage #(width))

	ALU_transaction #(width) trans;

	covergroup ALU_cg;
	// alu operation coverpoint: have we tested x function?
		operation_cp: coverpoint trans.alu_function_select {
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
		inp_a_cp: coverpoint trans.alu_inp_a {
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

		inp_b_cp: coverpoint trans.alu_inp_b {
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

		out_cp: coverpoint trans.alu_out {
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
		zero_cp: coverpoint trans.zero_flag {
			bins zero = {1'b1};
			bins not_zero = {1'b0};
		}
		carry_cp: coverpoint trans.carry_flag {
			bins carry = {1'b1};
			bins no_carry = {1'b0};
		}
		overflow_cp: coverpoint trans.overflow_flag {
			bins overflow = {1'b1};
			bins no_overflow = {1'b0};
		}
		negative_cp: coverpoint trans.negative_flag {
			bins negative = {1'b1};
			bins positive = {1'b0};
		}

		cross operation_cp, carry_cp {
			bins add_carry = 
				binsof(operation_cp.add) &&
				binsof(carry_cp.carry);

			bins add_no_carry = 
				binsof(operation_cp.add) &&
				binsof(carry_cp.no_carry);
			bins sub_carry =
				binsof(operation_cp.sub) &&
				binsof(carry_cp.carry);
			bins sub_no_carry =
				binsof(operation_cp.sub) &&
				binsof(carry_cp.no_carry);
			bins lshift_carry =
				binsof(operation_cp.left_shift) &&
				binsof(carry_cp.carry);
			bins lshift_no_carry =
				binsof(operation_cp.left_shift) &&
				binsof(carry_cp.no_carry);
			bins rshift_carry =
				binsof(operation_cp.right_shift) &&
				binsof(carry_cp.carry);
			bins rshift_no_carry =
				binsof(operation_cp.right_shift) &&
				binsof(carry_cp.no_carry);
		};

		cross operation_cp, overflow_cp {
			bins add_overflow = 
				binsof(operation_cp.add) &&
				binsof(overflow_cp.overflow);

			bins add_no_overflow = 
				binsof(operation_cp.add) &&
				binsof(overflow_cp.no_overflow);
			bins sub_overflow =
				binsof(operation_cp.sub) &&
				binsof(overflow_cp.overflow);
			bins sub_no_overflow =
				binsof(operation_cp.sub) &&
				binsof(overflow_cp.no_overflow);
		};
		
		cross operation_cp, negative_cp;
		cross operation_cp, zero_cp;
	
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
