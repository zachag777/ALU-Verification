class ALU_directed_logic_sequence #(
	parameter width = 8
) extends uvm_sequence #(ALU_transaction #(width));

	// parameterized boundary bit patterns
	localparam logic [width-1:0] A = {width{1'b1}};
	localparam logic [width-1:0] B = {width{1'b0}};
	localparam logic [width-1:0] C = {1'b1, {(width-1){1'b0}}};
	localparam logic [width-1:0] D = {1'b0, {(width-1){1'b1}}};

	`uvm_object_param_utils(ALU_directed_logic_sequence #(width))

	function new(string name = "dir_logic_seq");
		super.new(name);
	endfunction

	task body();
		ALU_transaction #(width) trans;

		for(int i = 2; i < 6; i++) begin // logic sequences are alu_function_select = 2,3,4,5
			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = A;
			trans.alu_inp_b = B;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = A;
			trans.alu_inp_b = C;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = A;
			trans.alu_inp_b = D;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = B;
			trans.alu_inp_b = C;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = B;
			trans.alu_inp_b = D;
			finish_item(trans);

			trans = ALU_transaction #(width)::type_id::create("trans");
			start_item(trans);
			trans.alu_function_select = i;
			trans.alu_inp_a = C;
			trans.alu_inp_b = D;
			finish_item(trans);
		end

	endtask
endclass
