module subtracter #(
	parameter width = 8 // parameters for bit width and relevant quantities
)(
	input logic [width-1:0]sub_a, // input and output declaration, logic supersedes reg and wire from traditional verilog
	input logic [width-1:0]sub_b,
	output logic [width-1:0]sub_sum,
	output logic sub_cout
);

	logic [width:0] internal_carry; // internal wire between adders in subtracter circuit
	assign internal_carry[0] = 1'b1; // the first carry in for subtracter is 1

	genvar i;
	generate
		for(i = 0; i < width; i++) begin : GEN_SUB // generate subtracter circuit based on bit width
			full_adder sub_inst (
				.a(sub_a[i]),
				.b(~sub_b[i]),
				.cin(internal_carry[i]),
				.s(sub_sum[i]),
				.cout(internal_carry[i+1])
			);
		end
		
	endgenerate
	
	assign sub_cout = internal_carry[width];
endmodule : subtracter