

module control_unit (
	input wire 		clk,
	input wire 		rst,

	input wire [31:0]	instr_i,




	output wire [1:0]	ls_ctr_o,
	output wire 		pc_o
	);

	always @(posedge clk or negedge rst) begin
	end


	// state ayarlanacak. diğer tarafın içi de dolabilir. anında flow
	// state taktiği




	wire [4:0] 	opcode;
	wire [4:0]	rs1;
	wire [4:0]	rs2;
	wire [4:0]	rd;
	wire [31:0]	inst;
	wire [2:0]	funct3;
	wire [6:0]	funct7;
	wire [31:0]	immediate;
	wire [2:0]  instr_type;




// zaten hepsinde var
	instr_decode decoder (
		.instr_i(instr_i),
		.opcode_o(opcode),
		.rs1_o(rs1),
		.rs2_o(rs2),
		.rd_o(rd),
		.funct3_o(funct3),
		.funct7_o(funct7),
		.imm_o(immediate),
		.instr_type_o(instr_type)
	);

endmodule
