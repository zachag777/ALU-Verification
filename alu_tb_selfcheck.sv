`timescale 1ns/1ps

module alu_tb_selfcheck #(
	parameter width = 8
)();

logic [width-1:0] alu_inp_a;
logic [width-1:0] alu_inp_b;
logic [2:0] alu_function_select;
logic [width-1:0] alu_out;
logic negative_flag;
logic zero_flag;
logic carry_flag;
logic overflow_flag;

integer loop_count;
logic exp_neg_flag;
logic exp_zero_flag;
logic exp_carry_flag;
logic exp_overflow_flag;
logic [width-1:0] exp_out;
logic [width:0] extended_sum;

// instantiate dut
ALU #(
	.width(width)
) u_alu (
	.alu_inp_a(alu_inp_a),
	.alu_inp_b(alu_inp_b),
	.alu_function_select(alu_function_select),
	.alu_out(alu_out),
	.negative_flag(negative_flag),
	.zero_flag(zero_flag),
	.carry_flag(carry_flag),
	.overflow_flag(overflow_flag)
);

initial begin

	alu_inp_a = '0;
	alu_inp_b = '0;
	alu_function_select = '0;
	#5;

	for(loop_count = 0; loop_count < 1000; loop_count++) begin
		alu_inp_a = $urandom;
		alu_inp_b = $urandom;

		#5;
		
		// use reference models to get expected flags
		// do-while loop to iterate thru alu functions
		do begin
			case(alu_function_select)
				// add
				3'b000: begin
					exp_out = alu_inp_a + alu_inp_b;
					// expected carry is the last bit of the sum extended by 1
					extended_sum = {1'b0, alu_inp_a} + {1'b0, alu_inp_b};
					exp_carry_flag = extended_sum[width];
					exp_overflow_flag = (alu_inp_a[width-1] ^ exp_out[width-1]) & (alu_inp_b[width-1] ^ exp_out[width-1]);


				end

				// sub
				3'b001: begin
					exp_out = alu_inp_a - alu_inp_b;
					exp_carry_flag = (alu_inp_a >= alu_inp_b);
					exp_overflow_flag = (alu_inp_a[width-1] ^ alu_inp_b[width-1]) & (alu_inp_b[width-1] == exp_out[width-1]);
	
				end

				// and
				3'b010: begin
					exp_out = alu_inp_a & alu_inp_b;
					exp_carry_flag = 0;
					exp_overflow_flag = 0;

				end

				// or
				3'b011: begin
					exp_out = alu_inp_a | alu_inp_b;
					exp_carry_flag = 0;
					exp_overflow_flag = 0;

				end

				// not
				3'b100: begin
					exp_out = ~alu_inp_a;
					exp_carry_flag = 0;
					exp_overflow_flag = 0;
					
				end
				
				// xor
				3'b101: begin
					exp_out	= alu_inp_a ^ alu_inp_b;	
					exp_carry_flag = 0;
					exp_overflow_flag = 0;

				end

				// left shift
				3'b110: begin
					exp_out = alu_inp_a << 1;
					exp_carry_flag = alu_inp_a[width-1];
					exp_overflow_flag = 0;
	
				end

				// right shift
				3'b111: begin
					exp_out = alu_inp_a >> 1;
					exp_carry_flag = alu_inp_a[0];
					exp_overflow_flag = 0;

				end

			endcase

		exp_neg_flag = exp_out[width-1];
		exp_zero_flag = (exp_out == 0);

		//assertions
		assert(alu_out == exp_out)
			else $error("ALU output mismatch. A=%0h B=%0h Sel=%0b, Expected=%0h, Got=%0h", alu_inp_a, alu_inp_b, alu_function_select, exp_out, alu_out);
		assert(negative_flag == exp_neg_flag)
			else $error("N flag mismatch. A=%0h B=%0h Sel=%0b, Expected=%0b, Got=%0b", alu_inp_a, alu_inp_b, alu_function_select, exp_neg_flag, negative_flag);
		assert(zero_flag == exp_zero_flag)
			else $error("Z flag mismatch. A=%0h B=%0h Sel=%0b, Expected=%0b, Got=%0b", alu_inp_a, alu_inp_b, alu_function_select, exp_zero_flag, zero_flag);
		assert(carry_flag == exp_carry_flag)
			else $error("C flag mismatch. A=%0h B=%0h Sel=%0b, Expected=%0b, Got=%0b", alu_inp_a, alu_inp_b, alu_function_select, exp_carry_flag, carry_flag);
		assert(overflow_flag == exp_overflow_flag)
			else $error("V flag mismatch. A=%0h B=%0h Sel=%0b, Expected=%0b, Got=%0b", alu_inp_a, alu_inp_b, alu_function_select, exp_overflow_flag, overflow_flag);

		// increment function
		alu_function_select++;

		end while (alu_function_select != 0);

	end
end

endmodule