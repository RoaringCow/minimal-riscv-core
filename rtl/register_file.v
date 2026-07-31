
module register_file (
    input   [4:0]   rs1_select_i,
    input   [4:0]   rs2_select_i,
    input   [4:0]   rd_select_i,
    input           write_enable_i,
    input   [31:0]  rd_i,

    output  [31:0]  rs1_o,
    output  [31:0]  rs2_o
);

// 32 tane registerı tek busa bağlayıp 32x32 bağlantılı mux
// kullanmama gerek kalmayan sistemin sorunları varmış :((((( (high impedence basmaca)
// illegal opcode kullanımı (iki enable da aynı anda açılıp ilginç şeyler)
//


endmodule
