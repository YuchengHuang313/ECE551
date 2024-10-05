/* The code is wrong. This makes the latch only sensitive to the edges
but not to the level. To fix this, we need to add d input into the sensitivity 
list to ensure that when input changes, the output can immediately reflect that
change during positive clock
*/

module DFF_sync_rstn (
    input clk,
    input d,
    input rst_n,
    output logic q
);

  always_ff @(posedge clk)
    if (!rst_n) q <= 1'b0;
    else q <= d;

endmodule

module DFF_async_rstn_en (
    input clk,
    input d,
    input rst_n,
    input en,
    output logic q
);

  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) q <= 1'b0;
    else if (en) q <= d;

endmodule

module SRFF (
    input rst_n,
    input s,
    input r,
    input clk,
    output logic q
);

  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) q <= 1'b0;
    else if (s && !r) q <= 1'b1;
    else if (!s && r) q <= 1'b0;


endmodule

/* The use of always_ff in SystemVerilog strongly suggests to synthesis tools that the 
logic is meant to infer a flip-flop, as it is designed specifically for sequential logic. 
By restricting the sensitivity list to clock edges and disallowing mixed or 
level-sensitive behavior, always_ff helps ensure that a flip-flop will be inferred. 
However, the inference of a flip-flop also depends on correctly written logic inside the block. 
If the internal logic deviates from standard flip-flop behavior, the synthesis tool may 
fail to infer a proper flip-flop despite the use of always_ff and it would produce a warning.
*/

