module VERI_RISC (
    input clk,
    input rst, 
    output halt
);
    wire [2:0] opcode, phase;
    wire [4:0] pc_addr, ir_addr, addr;
    wire [7:0] data, ac_out, alu_out; 
    wire zero, rd, wr, sel, ld_ir, inc_pc, ld_pc, data_e, ld_ac;

    counter #(.WIDTH(3)) counter_clk (
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .enab(1'b1),
        .cnt_in(3'b000),
        .cnt_out(phase)
    );
    
    counter #(.WIDTH(5)) counter_pc (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .enab(inc_pc),
        .cnt_in(ir_addr),
        .cnt_out(pc_addr)
    );

    register #(.WIDTH(8)) register_ir (
        .clk(clk),
        .rst(rst),
        .load(ld_ir),
        .data_in(data),
        .data_out({opcode, ir_addr})
    );

    alu #(.WIDTH(8)) alu_inst (
        .opcode(opcode),
        .in_a(ac_out),
        .in_b(data),
        .a_is_zero(zero),
        .alu_out(alu_out)
    );

    register #(.WIDTH(8)) register_ac (
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .data_in(alu_out),
        .data_out(ac_out)
    );

    driver #(.WIDTH(8)) driver_inst (
        .data_in(alu_out),
        .data_out(data),
        .data_en(data_e)
    );

    controller controller_inst (
        .opcode(opcode),
        .phase(phase),
        .zero(zero),
        .rd(rd),
        .wr(wr),
        .ld_pc(ld_pc),
        .ld_ac(ld_ac),
        .ld_ir(ld_ir),
        .inc_pc(inc_pc),
        .halt(halt),
        .data_e(data_e),
        .sel(sel)
    );

    multiplexor #(.WIDTH(5)) address_mux (
        .sel(sel),
        .in0(ir_addr),
        .in1(pc_addr),
        .mux_out(addr)
    );

    single_port_memory #(.AWIDTH(5), .DWIDTH(8)) memory_inst (
        .clk(clk),
        .wr(wr),
        .rd(rd),
        .addr(addr),
        .data(data)
    );

endmodule
