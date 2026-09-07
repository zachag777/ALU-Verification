module mux #(
	parameter width = 8
)(
	input logic [width-1:0] a,
	input logic [width-1:0] b,
	input logic sel,
	output logic [width-1:0] out
);
	always_comb begin

		case(sel)
	
		1'b0 : out = b;
		1'b1 : out = a;
		default : out = '0;


		endcase
	end
endmodule
	