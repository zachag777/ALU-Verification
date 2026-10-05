module bitwise_not #(
	parameter width = 8
)(
	input logic [width-1:0] a,
	output logic [width-1:0] out
	
);

	assign out = ~a;

endmodule : bitwise_not