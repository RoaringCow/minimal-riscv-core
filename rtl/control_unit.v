

module control_unit (
    input wire 		clk,
    input wire 		rst,    // TODO: bunu negatif yapsana. isimlendirme olarak

    input wire [31:0]	instr_i,


    input mem_valid,
    output reg mem_req,



    output wire [1:0]	ls_ctr_o,
    output wire 		pc_o
);



/*
case (instr_type)
R_type: begin
rf_wire = 1; // ??
end
I_type: begin
case (opcode[3:2])
2'b00: begin end    // load
2'b01: begin end    // imm arithmetic
2'b10: begin end    // jump and link register
2'b11: begin end    // ebreak, ecall
endcase

end

S_type: begin end
B_type: begin end
U_type: begin end
J_type: begin end
endcase
*/







localparam [2:0] R_TYPE = 3'h0;
localparam [2:0] I_TYPE = 3'h1;
localparam [2:0] S_TYPE = 3'h2;
localparam [2:0] B_TYPE = 3'h3;
localparam [2:0] U_TYPE = 3'h4;
localparam [2:0] J_TYPE = 3'h5;

reg instruction_register; // büyük adam olduğu için adı uzun

wire alu_enable;
// alu için direkt funct3 gönderecem (ve funct7)
wire alu_is_immediate; // rs2 mi yoksa immediate mı
wire rf_write; // x0'ı unutma
// rs1 ve rs2'yi sürekli kontrol eden bir şey bağla. branch olduğunda ona göre.
//


reg     [31:0]  rs1_data;
reg     [31:0]  rs2_data;


// keyfim öyle istediği için bu bir multicycle core AMA pipeline yok D:

localparam [2:0] IF     = 3'h0;
localparam [2:0] ID     = 3'h1;
localparam [2:0] EX     = 3'h2;
localparam [2:0] MEM    = 3'h3;
localparam [2:0] WB     = 3'h4;

reg     [2:0]   instr_state;
// IF, ID, EX, MEM, WB
//
// sıradaki iş bu durumlara göre alt tarafı ayarlamak

// reg megli clocklu şeyler
always @(posedge clk or negedge rst) begin

    if (!rst) begin
        instr_state <= IF;


    end
    else begin
        case (instr_state)
        IF: begin
            if (mem_valid) begin
                instruction_register <= instr_i;
                instr_state <= ID;
            end
        end
        ID: begin
            // ya instruction decode kısmını kaldırsam mı diye düşündüm de tutmaya karar verdim.
            // bari yazmaca falan bassın veriyi öylesine.
            //

            rs1_data <=  rs1_o;
            rs2_data <= rs2_o;

            instr_state <= EX;
        end
        endcase
    end

end



// kombinasyonel şeyler
always @(*) begin

    mem_req = 1'b0;
    ls_fetch = 1'b0;

    case (instr_state)
    IF: begin
        mem_req = 1'b1;
        ls_fetch = 1'b1;
    end
    EX: begin

    end
    endcase



end



/*
case (instr_state)
IF: begin
ls_fetch <= 1; //get pc
mem_req <= 1;
if (mem_valid) begin
mem_req <= 0;
instruction_register <= instr_i;
instr_state <= ID;       // only skip to the next step  if mem is available
end
end
ID: begin
// ya instruction decode kısmını kaldırsam mı diye düşündüm de tutmaya karar verdim.
// bari yazmaca falan bassın veriyi öylesine.
//

rs1_data <=  rs1_o;
rs2_data <= rs2_o;



instr_state <= EX;
end
EX: begin




//instr_state = ?????;
end
MEM: begin

instr_state <= WB;
end
WB: begin

instr_state <= IF;
end
endcase

// kontrol unit  hangilerin ereye gidecek?
//



end

end

*/


// -------------------------------------------------------
//                 _     _             __ _ _
//  _ __ ___  __ _(_)___| |_ ___ _ __ / _(_| | ___
//  | '__/ _ \/ _` | / __| __/ _ | '__| |_| | |/ _ \
//  | | |  __| (_| | \__ | ||  __| |  |  _| | |  __/
//  |_|  \___|\__, |_|___/\__\___|_|  |_| |_|_|\___|
//            |___/
// -------------------------------------------------------


wire    [4:0]   rs1_select_i;
wire    [4:0]   rs2_select_i;
wire    [4:0]   rd_select_i;
wire            write_enable_i;
wire    [31:0]  rd_i;
wire    [31:0]  rs1_o;
wire    [31:0]  rs2_o;


register_file reg_file(
    .rs1_select_i(rs1_select_i),
    .rs2_select_i(rs2_select_i),
    .rd_select_i(rd_select_i),
    .write_enable_i(write_enable_i),
    .rd_i(rd_i),

    .rs1_o(rs1_o),
    .rs2_o(rs2_o)
);





// -------------------------------------------------------------------------------
//       ____  _____ ____ ___  ____  _____ ____  _   _ _   _ ___ _____
//      |  _ \| ____/ ___/ _ \|  _ \| ____|  _ \| | | | \ | |_ _|_   _|
//      | | | |  _|| |  | | | | | | |  _| | |_) | | | |  \| || |  | |
//      | |_| | |__| |__| |_| | |_| | |___|  _ <| |_| | |\  || |  | |
//      |____/|_____\____\___/|____/|_____|_| \_ \___/|_| \_|___| |_|
// -------------------------------------------------------------------------------


// decode wires
wire [4:0] 	opcode; // THIS IS STRIPPED TO 5 bits
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
