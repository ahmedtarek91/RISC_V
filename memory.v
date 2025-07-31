module single_port_memory #(
    parameter AWIDTH = 5,   // Address width (32 locations)
    parameter DWIDTH = 8    // Data width (8-bit words)
)
(
    input  wire                clk,   // Clock
    input  wire                wr,    // Write enable
    input  wire                rd,    // Read enable
    input  wire [AWIDTH-1:0]   addr,  // Address
    inout  wire [DWIDTH-1:0]   data   // Bidirectional data bus
);

    // memory array with 2^AWIDTH locations
    reg [DWIDTH-1:0] array [0:(2**AWIDTH)-1];

    // Synchronous write
    always @(posedge clk) begin
        if (wr)
            array[addr] <= data;
    end

    // Asynchronous read
    assign data = rd ? array[addr] : {DWIDTH{1'bz}};

endmodule
