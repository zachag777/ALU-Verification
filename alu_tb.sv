// set time scale

`timescale 1ns/1ps


module alu_tb #(
	parameter width = 8
)();

// logic signals to drive dut

logic [width-1:0] alu_inp_a;
logic [width-1:0] alu_inp_b;
logic [2:0] alu_function_select;
logic [width-1:0] alu_out;
logic negative_flag;
logic zero_flag;
logic carry_flag;
logic overflow_flag;




	
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
	$dumpfile("alu_tb.vcd");
	$dumpvars(0, alu_tb);
end

initial begin

//initialize logic signals

	alu_inp_a = '0;
	alu_inp_b = '0;
	alu_function_select = '0;

	#5; //give time for outputs to settle

	//no input test case

	assert(alu_out == 0)
		$display ("Good");
	else
		$error ("Bad");


	//max test case
	
	alu_inp_a = '1;
	alu_inp_b = '1;
	alu_function_select = '0;

	#5;
	
	assert(alu_out == 8'b11111110)
		$display ("Good");
	else $error ("Bad");

	// overflow flag?
	alu_inp_a = 8'b01000000;
	alu_inp_b = 8'b01000000;
	alu_function_select = '0;

	#5

	assert(overflow_flag == 1'b1)
		$display ("Good");
	else $error ("Bad");

	//logic functions

$stop;

end

endmodule
