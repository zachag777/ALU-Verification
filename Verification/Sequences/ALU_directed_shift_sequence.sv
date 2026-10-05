class ALU_directed_shift_sequence #(
	parameter width = 8
) extends uvm_sequence #(ALU_transaction #(width));

	// parameterized boundary bit patterns
	localparam logic [width-1:0] A = {width{1'b1}};
	localparam logic [width-1:0] B = {width{1'b0}};
	localparam logic [width-1:0] C = {1'b1, {(width-1){1'b0}}}; // 1 at msb
	localparam logic [width-1:0] D = {{(width-1){1'b0}}, 1'b1}; // 1 at lsb

	`uvm_object_param_utils(ALU_directed_shift_sequence #(width))

	function new(string name = "dir_shift_seq");
		super.new(name);
	endfunction

	task body();
		ALU_transaction #(width) trans;

		for(int i = 6; i < 8 ; i++) begin // shift sequences are alu_function_select = 6,7
			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = A;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = B;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = C;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = D;
			finish_item(trans);
		end

	endtask
endclass
