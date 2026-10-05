class ALU_directed_sub_sequence #(
	parameter width = 8
) extends uvm_sequence #(ALU_transaction #(width));

	// parameterized boundary bit patterns
	localparam logic [width-1:0] A = {width{1'b1}};
	localparam logic [width-1:0] B = {width{1'b0}};
	localparam logic [width-1:0] C = {1'b1, {(width-1){1'b0}}}; // negative boundary
	localparam logic [width-1:0] D = {1'b0,{(width-1){1'b1}}}; 
		
	// array
	localparam logic [width-1:0] values [4] = '{A,B,C,D};

	`uvm_object_param_utils(ALU_directed_sub_sequence #(width))

	function new(string name = "dir_sub_seq");
		super.new(name);
	endfunction

	task body();
		ALU_transaction #(width) trans;

		for (int i = 0; i < 4; i++) begin
			for (int j = 0; j < 4; j++) begin
				trans = ALU_transaction #(width)::type_id::create("trans");
				start_item(trans);
				trans.alu_function_select = 1;
				trans.alu_inp_a = values[i];
				trans.alu_inp_b = values[j];
				finish_item(trans);
			end
		end
		// positive overflow
		trans = ALU_transaction #(width)::type_id::create("trans");
		start_item(trans);
		trans.alu_function_select = 1;
		trans.alu_inp_a = 8'b01000000;
		trans.alu_inp_b = 8'b10000000;
		finish_item(trans);
		// negative overflow
		trans = ALU_transaction #(width)::type_id::create("trans");
		start_item(trans);
		trans.alu_function_select = 1;
		trans.alu_inp_a = 8'b10000000;
		trans.alu_inp_b = 8'b01000000;
		finish_item(trans);
		// carry
		trans = ALU_transaction #(width)::type_id::create("trans");
		start_item(trans);
		trans.alu_function_select = 1;
		trans.alu_inp_a = 8'b10000000;
		trans.alu_inp_b = 8'b01111111;
		finish_item(trans);
		
	endtask
endclass
