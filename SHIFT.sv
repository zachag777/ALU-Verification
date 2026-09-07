module logic_shift #(
	parameter width = 8
)(
	input logic [width-1:0] in,
	input logic select, // shift right is select is 0, shift left on 1
	output logic [width-1:0] out
);
	genvar i;
	generate
		for (i=0; i<width; i++) begin : GEN_MUX
			mux #(
				.width(1)
			)
			mux_inst (
				.a(i == width-1 ? 1'b0 : in[i+1]),
				.b(i == 0 ? 1'b0 : in[i-1]),
				.sel(select),
				.out(out[i])
			);
		end
	endgenerate
	
endmodule : logic_shift