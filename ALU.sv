module ALU #(
	parameter width = 8 // paramterize bit width
)(
	input logic [width-1:0] alu_inp_a, alu_inp_b, // two inputs of the alu 
	input logic [2:0]alu_function_select, // bit selects function
	output logic [width-1:0] alu_out, // output of the alu
	output logic negative_flag, zero_flag, carry_flag, overflow_flag // flags
);

logic adder_cout; // dummy value needed for ripple adder instantiation
logic [width-1:0] adder_result; //hold add function result


ripple_adder #(
	.width(width)
) u_ripple_adder (
	.A(alu_inp_a),
	.B(alu_inp_b),
	.CIN(1'b0),
	.S(adder_result),
	.COUT(adder_cout)
);

logic sub_carry_out;
logic [width-1:0] sub_result; // hold result of subtracter to assign to alu output

subtracter #(
	.width(width)
) u_subtracter (
	.sub_a(alu_inp_a),
	.sub_b(alu_inp_b),
	.sub_sum(sub_result),
	.sub_cout(sub_carry_out)
);

logic [width-1:0] and_result;

bitwise_and #(
	.width(width)
) u_and (
	.a(alu_inp_a),
	.b(alu_inp_b),
	.out(and_result)
);

logic [width-1:0] or_result;

bitwise_or #(
	.width(width)
) u_bitwise_or (
	.a(alu_inp_a),
	.b(alu_inp_b),
	.out(or_result)
);

logic [width-1:0] not_result;

bitwise_not #(
	.width(width)
) u_bitwise_not (
	.a(alu_inp_a),
	.out(not_result)
);

logic[width-1:0] xor_result;

bitwise_xor #(
	.width(width)
) u_xor (
	.a(alu_inp_a),
	.b(alu_inp_b),
	.out(xor_result)

); 

logic[width-1:0] left_shift;

logic_shift #(
	.width(width)
) u_logic_shift_left (
	.in(alu_inp_a),
	.select(1'b1),
	.out(left_shift)
);

logic[width-1:0] right_shift;

logic_shift #(
	.width(width)
) u_logic_shift_right (
	.in(alu_inp_a),
	.select(1'b0),
	.out(right_shift)
);

always_comb begin// always comb block then do case statement of diff valeus of sel, instantiating diff functions
	carry_flag = 1'b0;
	overflow_flag = 1'b0;

	unique case(alu_function_select)

		3'b000: begin
			// add function
			alu_out = adder_result;
			carry_flag = adder_cout;
			overflow_flag = (alu_inp_a[width-1] == alu_inp_b[width-1]) &&
			(adder_result[width-1] != alu_inp_a[width-1]);
		end
		
		
		3'b001: begin
			// subtract function
			alu_out = sub_result;
			carry_flag = sub_carry_out;
			overflow_flag = (alu_inp_a[width-1] != alu_inp_b[width-1])
			&& (sub_result[width-1] != alu_inp_a[width-1]);

		end

		3'b010: begin
			// and function
			// instantiate above always_comb block
			alu_out = and_result;
			
		end
		
		3'b011: begin
			alu_out = or_result;
		end

		3'b100: begin
			alu_out = not_result;
		end
	
		3'b101: begin
			alu_out = xor_result;
		end

		3'b110: begin
			alu_out = left_shift;
			carry_flag = alu_inp_a[width-1];
		end
		
		3'b111: begin
			alu_out = right_shift;
			carry_flag = alu_inp_a[0];
		end
		
		default: begin
			alu_out = 0;
			carry_flag = 0;
			overflow_flag = 0;
		end
	endcase
	
	negative_flag = alu_out[width-1];
	zero_flag = (alu_out == 0) ? 1'b1 : 1'b0;
end

endmodule: ALU

