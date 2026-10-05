module bitwise_or #(
	parameter width = 8
)(
	input logic [width-1:0] a,
	input logic [width-1:0] b,
	output logic [width-1:0] out
);

	assign out = a | b;

endmodule : bitwise_or