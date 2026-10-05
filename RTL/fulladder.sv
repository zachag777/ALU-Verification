module full_adder(
	input logic a,
	input logic b,
	input logic cin,
	output logic s,
	output logic cout
);

	assign cout = (a&b) | (cin&(a|b));

	assign s = a ^ b ^ cin;

endmodule : full_adder
