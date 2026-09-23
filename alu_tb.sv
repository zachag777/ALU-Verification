// set time scale

timeunit 1ns;
timeprecision 1ps;
import uvm_pkg::*;
import ALU_pkg::*;
`include "uvm_macros.svh"


module alu_tb #(
	parameter width = 8
)();

	ALU_interface #(width) aluif();



	
// instantiate dut
ALU #(
	.width(width)
) u_alu (
	.alu_inp_a(aluif.alu_inp_a),
	.alu_inp_b(aluif.alu_inp_b),
	.alu_function_select(aluif.alu_function_select),
	.alu_out(aluif.alu_out),
	.negative_flag(aluif.negative_flag),
	.zero_flag(aluif.zero_flag),
	.carry_flag(aluif.carry_flag),
	.overflow_flag(aluif.overflow_flag)
);

initial begin
	uvm_config_db #(virtual ALU_interface #(width))::set(
		null,
		"*",
		"aluif",
		aluif
	);
	run_test("ALU_random_test_8");

end

endmodule
