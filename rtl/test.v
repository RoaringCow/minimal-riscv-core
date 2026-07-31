`timescale 1ns/1ps

module test;

reg  [31:0] rs1;
reg  [31:0] rs2;
reg  [2:0]  funct3;
reg  [6:0]  funct7;
wire [31:0] result;

alu dut (
    .rs1_i        (rs1),
    .rs2_i        (rs2),
    .funct3_i     (funct3),
    .funct7_i     (funct7),
    .alu_result_o (result)
);

integer pass_count = 0;
integer fail_count = 0;

task check_result;
    input [31:0] expected;
    input [8*40-1:0] test_name;
    begin
        if (result === expected) begin
            $display("PASS: %0s = 0x%08X", test_name, result);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: %0s = 0x%08X (beklenen 0x%08X)", test_name, result, expected);
            fail_count = fail_count + 1;
        end
    end
endtask

initial begin
    funct3 = 3'b101; // funct3=101 -> sağa kaydırma

    $display("=== SRL (>>) testleri: funct7[5]=0, sifirla doldur ===");

    // --- SRL: Shift Right Logical (>>) ---
    // funct7[5]=0 -> mode_flag=0 -> SRL
    funct7 = 7'b0000000;

    rs1 = 32'h80000000; rs2 = 32'd1;  #1;
    check_result(32'h40000000, "SRL 0x80000000 >> 1 ");

    rs1 = 32'hFF000000; rs2 = 32'd8;  #1;
    check_result(32'h00FF0000, "SRL 0xFF000000 >> 8 ");

    rs1 = 32'hFFFFFFFF; rs2 = 32'd4;  #1;
    check_result(32'h0FFFFFFF, "SRL 0xFFFFFFFF >> 4 ");

    rs1 = 32'h80000000; rs2 = 32'd31; #1;
    check_result(32'h00000001, "SRL 0x80000000 >> 31");

    $display("");
    $display("=== SRA (>>>) testleri: funct7[5]=1, isaretli bit ile doldur ===");

    // --- SRA: Shift Right Arithmetic (>>>) ---
    // funct7[5]=1 -> mode_flag=1 -> SRA
    funct7 = 7'b0100000;

    rs1 = 32'h80000000; rs2 = 32'd1;  #1;
    check_result(32'hC0000000, "SRA 0x80000000 >>> 1 ");

    rs1 = 32'h7FFFFFFF; rs2 = 32'd1;  #1;
    check_result(32'h3FFFFFFF, "SRA 0x7FFFFFFF >>> 1 ");

    rs1 = 32'hFFFFFFFF; rs2 = 32'd4;  #1;
    check_result(32'hFFFFFFFF, "SRA 0xFFFFFFFF >>> 4 ");

    rs1 = 32'h80000000; rs2 = 32'd31; #1;
    check_result(32'hFFFFFFFF, "SRA 0x80000000 >>> 31");

    $display("");
    $display("=== Sonuc: %0d PASS, %0d FAIL ===", pass_count, fail_count);
    $finish;
end

endmodule
