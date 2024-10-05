module Shifter (
    input [15:0] src,
    input arith,
    input [3:0] amt,
    output logic signed [15:0] res
);

  logic signed [15:0] shift_stg1;
  logic signed [15:0] shift_stg2;
  logic signed [15:0] shift_stg3;

  // Stage 1: Shift by 1 bit
  assign shift_stg1 = (amt[0] == 1) ? (arith ? {{src[15]}, src[15:1]} : {1'b0, src[15:1]}) : src;

  // Stage 2: Shift by 2 bits
  assign shift_stg2 = (amt[1] == 1) ? (arith ? {{2{shift_stg1[15]}}, shift_stg1[15:2]} : {2'b00, shift_stg1[15:2]}) : shift_stg1;

  // Stage 3: Shift by 4 bits
  assign shift_stg3 = (amt[2] == 1) ? (arith ? {{4{shift_stg2[15]}}, shift_stg2[15:4]} : {4'b0000, shift_stg2[15:4]}) : shift_stg2;

  // Final Stage: Shift by 8 bits
  assign res = (amt[3] == 1) ? (arith ? {{8{shift_stg3[15]}}, shift_stg3[15:8]} : {8'b00000000, shift_stg3[15:8]}) : shift_stg3;

endmodule
