`timescale 1ns / 1ps

module instr_decode (

	input [31:0]	instr_i,
	
	output reg [4:0]	opcode, // bazı instructionlar arasındaki farklı bu belirliyor.
	output reg [4:0]	rs1,
	output reg [4:0]	rs2,
	output reg [4:0]	rd,
	output reg [31:0]	inst, // full hepsini çıkar belki bölerim sonra
);


// zaten hepsinde var
assign opcode = instr_i[6:2];


always @(*) begin
	case (instr_i[6:2]) // sonlar hep 11 zaten. 32 bit olduğundan (uzunluğu belirtiyor)
		5'b01100: begin	// R type

		rd = instr_i[11:7];

		end
		5'b00100: begin	// I type aritmetik

		rd = instr_i[11:7];
		
		end
		5'b00000: begin // I type load

		end
		5'b01000: begin // S type store

		end
		5'b11000: begin // B type branch

		end
		5'b01101: begin // U type (lui)

		end
		5'b00101: begin // U type (auipc)

		end
		5'b11011: begin // zıplaa jal

		end
		5'b11001: begin // zıplaa jalr

		end
	endcase
end


endmodule

