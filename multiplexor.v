module multiplexor #( parameter WIDTH = 5 )
(
    input [WIDTH-1:0]in0, in1,
    input sel,
    output [WIDTH-1:0] mux_out
);
    assign mux_out = (sel==1) ? in1 : in0;

endmodule