// include import
import uvm_pkg::*;
`include "uvm_macros.svh"

// class header
class ALU_scoreboard #(
	parameter width = 8
) extends uvm_scoreboard;


// constructor + factory registration
	`uvm_component_param_utils(ALU_scoreboard #(width))

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

// uvm_analysis_imp to receive transaction
	uvm_analysis_imp #(ALU_transaction #(width), ALU_scoreboard #(width)) ap_imp;

// build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap_imp = new("ap_imp", this);
	endfunction


//function void write takes arg trans
	function void write (ALU_transaction #(width) trans);

	logic [width-1:0] expected_out;
	logic expected_negative;
	logic expected_zero;
	logic expected_carry;
	logic expected_overflow;

	logic [width:0] extended_carry;
	logic [width-1:0]overflow_low;
	logic msb_cin;

	// logic based on signals from received transaction
	// default signals
	expected_overflow = 0;
	expected_carry = 0;
	msb_cin = 0;
	expected_out = '0;
	extended_carry = '0;
	overflow_low = '0;
	
	case (trans.alu_function_select)

		3'b000: begin // add
			expected_out = trans.alu_inp_a + trans.alu_inp_b;
			extended_carry = {1'b0, trans.alu_inp_a} + {1'b0, trans.alu_inp_b}; // check carry out bit
			expected_carry = extended_carry[width];
			// calculate cin of msb
			overflow_low = {1'b0, trans.alu_inp_a[width-2:0]} + {1'b0, trans.alu_inp_b[width-2:0]};
			msb_cin = overflow_low[width-1];
			// overflow = msb_cout ^ msb_cin
			expected_overflow = expected_carry ^ msb_cin;
		end

		3'b001: begin // sub
			expected_out = trans.alu_inp_a - trans.alu_inp_b;
			extended_carry = {1'b0, trans.alu_inp_a} + {1'b0, ~trans.alu_inp_b} + 1; // mathematically calculate the carry out of our a + ~b + 1 subtraction
			expected_carry = extended_carry[width];
			overflow_low = {1'b0, trans.alu_inp_a[width-2:0]} + {1'b0, ~trans.alu_inp_b[width-2:0]} + 1;
			msb_cin = overflow_low[width-1];
			expected_overflow = expected_carry ^ msb_cin;
		end

		3'b010: begin // and
			expected_out = trans.alu_inp_a & trans.alu_inp_b;

		end

		3'b011: begin // or
			expected_out = trans.alu_inp_a | trans.alu_inp_b;
		end

		3'b100: begin // not
			expected_out = ~trans.alu_inp_a;
		end

		3'b101: begin // xor
			expected_out = trans.alu_inp_a ^ trans.alu_inp_b;
		end

		3'b110: begin // left shift
			expected_out = trans.alu_inp_a << 1;
			expected_carry = trans.alu_inp_a[width-1];
		end

		3'b111: begin // right shift
			expected_out = trans.alu_inp_a >> 1;
			expected_carry = trans.alu_inp_a[0];
		end
	endcase
		
	expected_negative = ($signed(expected_out) < 0);
	expected_zero = (expected_out == 0);

	if(trans.alu_out != expected_out)begin
		`uvm_error("OUT", 
		$sformatf("Operation:%0b Expected:%0h Actual:%0h",
			trans.alu_function_select,
			expected_out,
			trans.alu_out
		))
	end

	if(trans.negative_flag != expected_negative)begin
		`uvm_error("NEGATIVE", 
		$sformatf("Operation:%0b Expected:%0b Actual:%0b",
			trans.alu_function_select,
			expected_negative,
			trans.negative_flag
		))
	end
	if(trans.carry_flag != expected_carry)begin
		`uvm_error("CARRY", 
		$sformatf("Operation:%0b Expected:%0b Actual:%0b",
			trans.alu_function_select,
			expected_carry,
			trans.carry_flag
		))
	end
	if(trans.zero_flag != expected_zero)begin
		`uvm_error("ZERO", 
		$sformatf("Operation:%0b Expected:%0b Actual:%0b",
			trans.alu_function_select,
			expected_zero,
			trans.zero_flag
		))
	end

	if(trans.overflow_flag != expected_overflow)begin
		`uvm_error("OVERFLOW", 
		$sformatf("Operation:%0b Expected:%0b Actual:%0b",
			trans.alu_function_select,
			expected_overflow,
			trans.overflow_flag
		))
	end

	

	endfunction

endclass
