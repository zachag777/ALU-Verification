module ripple_adder #(
	parameter width = 8
)(
	input logic [width-1:0] A,
	input logic [width-1:0] B,
	input logic CIN,
	output logic [width-1:0] S,
	output logic COUT
);

	logic [width:0] internal_carry;
	assign internal_carry[0] = CIN;

	genvar i;
	generate
		for(i = 0; i < width; i++) begin : GEN_FA
			full_adder u_inst (
				.a(A[i]),
				.b(B[i]),
				.cin(internal_carry[i]),
				.s(S[i]),
				.cout(internal_carry[i+1])
			);
		end
			
	endgenerate

	assign COUT = internal_carry[width];

endmodule : ripple_adder
