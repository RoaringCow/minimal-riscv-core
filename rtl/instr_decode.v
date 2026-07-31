`timescale 1ns / 1ps

module instr_decode (

	input [31:0]	instr_i,

	output reg [4:0]	opcode_o, // bazı instructionlar arasındaki farklı bu belirliyor.
	output reg [4:0]	rs1_o,
	output reg [4:0]	rs2_o,
	output reg [4:0]	rd_o,
	output reg [2:0]	funct3_o,
	output reg [6:0]	funct7_o,
	output reg [31:0]	imm_o, // not the actual immediate value but rather kind of extended and vb version
	output reg [2:0]    instr_type_o

);


// zaten hepsinde var
assign opcode_o = instr_i[6:2];

// because verilog does not support enums
// ------ instr_type value equivalents --------
// R type ->  0x0
// I type ->  0x1
// S type ->  0x2
// B type ->  0x3
// U type ->  0x4
// J type ->  0x5
localparam [2:0] R_TYPE = 3'h0;
localparam [2:0] I_TYPE = 3'h1;
localparam [2:0] S_TYPE = 3'h2;
localparam [2:0] B_TYPE = 3'h3;
localparam [2:0] U_TYPE = 3'h4;
localparam [2:0] J_TYPE = 3'h5;


always @(*) begin
	case (instr_i[6:2]) // sonlar hep 11 zaten. 32 bit olduğundan (uzunluğu belirtiyor)
		5'b01100: begin	// R type

    		instr_type_o = R_TYPE;

    		rd_o = instr_i[11:7];
    		rs1_o = instr_i[19:15];
    		rs2_o = instr_i[24:20];
    		funct3_o = instr_i[14:12];
    		funct7_o = instr_i[31:25];


		 // func 3 ve func 7 işini halledecem sonra

		end
		5'b00100, 5'b00000: begin	// I type aritmetik ve load

		    instr_type_o = I_TYPE;

			rd_o = instr_i[11:7];
			rs1_o = instr_i[19:15];
			funct3_o = instr_i[14:12];


			imm_o[31:11] = {21{instr_i[31]}}; // bu hepsini ondan yapmalı da kontrol edersin.
			imm_o[10:5] = instr_i[30:25];
			imm_o[4:1] = instr_i[24:21];
			imm_o[0] = instr_i[20];

		end
		5'b01000: begin // S type store

            instr_type_o = S_TYPE;

			rs1_o = instr_i[19:15];
			rs2_o = instr_i[24:20];
			funct3_o = instr_i[14:12];

			imm_o[31:11] = {21{instr_i[31]}}; // bu hepsini ondan yapmalı da kontrol edersin.
			imm_o[10:5] = instr_i[30:25];
			imm_o[4:1] = instr_i[11:8];
			imm_o[0] = instr_i[7];

		end
		5'b11000: begin // B type branch

		    instr_type_o = B_TYPE;

		    rs1_o = instr_i[19:15];
			rs2_o = instr_i[24:20];
			funct3_o = instr_i[14:12];

			imm_o[31:12] = {20{instr_i[31]}}; // bu hepsini ondan yapmalı da kontrol edersin.
			imm_o[11] = instr_i[7];
			imm_o[10:5] = instr_i[30:25];
			imm_o[4:1] = instr_i[11:8];
			imm_o[0] = 1'b0;    // 16 bit alignment için herhalde.


		end
		5'b01101, 5'b00101: begin // U type (lui) & (auipc)

		    instr_type_o = U_TYPE;

		    rd_o = instr_i[11:7];

			imm_o[31] = instr_i[31];
			imm_o[30:12] = instr_i[30:12];
			imm_o[11:0] = 12'b0;		//bu hepsini ondan yapmalı da kontrol edersin.

		end
		5'b11011: begin // zıplaa jal

		    instr_type_o = J_TYPE;


			imm_o[31:20] = {12{instr_i[31]}};
			imm_o[19:12] = instr_i[19:12];
			imm_o[11] = instr_i[20];
			imm_o[10:1] = instr_i[30:21];
			imm_o[0] = 1'b0;

		end
		5'b11001: begin // zıplaa jalr
		    // aslında tepedekiyle birleştirilebilir ama bu şekilde daha belli nerede olduğu

		    instr_type_o = I_TYPE;

			imm_o[31:11] = {21{instr_i[31]}};
			imm_o[10:5] = instr_i[30:25];
			imm_o[4:1] = instr_i[24:21];
			imm_o[0] = instr_i[20];

		end

		// -------- weird ops --------
		5'b00011: begin // Fence, Fence.TSO, PAUSE
			// diğer bitlerden fark ettiriyor

		end
		5'b11100: begin // ECall EBREAk

			// diğer bitlerden fark ettiriyor
		end

	endcase
end


endmodule
