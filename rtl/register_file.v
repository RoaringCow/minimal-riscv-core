
module register_file (
    input   clk,
    input   rst_n,
    input   [4:0]   rs1_select_i,
    input   [4:0]   rs2_select_i,
    input   [4:0]   rd_select_i,
    input           write_enable_i,
    input   [31:0]  rd_i,

    output  reg [31:0]  rs1_o,
    output  reg [31:0]  rs2_o
);

// 32 tane registerı tek busa bağlayıp 32x32 bağlantılı mux
// kullanmama gerek kalmayan sistemin sorunları varmış :((((( (high impedence basmaca)
// illegal opcode kullanımı (iki enable da aynı anda açılıp ilginç şeyler)
//

// flipflop kullanmayı zorlamasını istediydim. bunu buldum
(* ram_style = "registers" *) reg [31:0] regs [0:31]; // bu ters şeyi redditte gördüm.
// ters olması niye bilmiyorum.

always @(*) begin
    rs1_o = 32'd0; // x0 işini de hallediyor böylece
    rs2_o = 32'd0;

    if(rs1_select_i != 5'd0) begin
        rs1_o = regs[rs1_select_i];
    end
    if(rs2_select_i != 5'd0) begin
        rs2_o = regs[rs2_select_i];
    end
end


always @(posedge clk) begin

    // riscv için reset sonrası sıfırlama gerekmiyormuş
    // işime gelir. çıkardım.
    if (write_enable_i && rd_select_i != 5'd0) begin
        regs[rd_select_i] <= rd_i;
    end

end

endmodule
