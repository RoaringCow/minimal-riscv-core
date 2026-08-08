
module top (

);





// -------------------------------------------------
//   __ _| |_   _
//  / _` | | | | |
// | (_| | | |_| |
//  \__,_|_|\__,_|
// -------------------------------------------------


wire [31:0] alu_result;

alu alu_i ( // isim bulamadım
    .rs1_i(rs1_o),
    .rs2_i(rs2_o),
    .funct3_i(func3),
    .funct7_i(funct7),
    .alu_result_o(alu_result)
);

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
//wire [4:0]	rs1; just connected these to rs1_select
//wire [4:0]	rs2;
wire [4:0]	rd;
wire [31:0]	inst;
wire [2:0]	funct3;
wire [6:0]	funct7;
wire [31:0]	immediate;
wire [2:0]  instr_type;




// zaten hepsinde var
instr_decode decoder (
    .instr_i(instruction_register),
    .opcode_o(opcode),
    .rs1_o(rs1_select_i),
    .rs2_o(rs2_select_i),
    .rd_o(rd),
    .funct3_o(funct3),
    .funct7_o(funct7),
    .imm_o(immediate),
    .instr_type_o(instr_type)
);

endmodule
