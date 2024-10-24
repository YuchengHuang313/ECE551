module SPI_mnrch (
    input snd, MISO, clk, rst_n,
    input [15:0] cmd,
    output done, SS_n, SCLK, MOSI,
    output [15:0] resp
);

typedef enum [1:0] logic { IDLE, SHIFT, DONE } state_t;
state_t state, nxt_state;

logic shift, init, ld_SCLK, full, done16, set_done;
logic [4:0] SCLK_cnt, bit_cnt;

// shifter
always_ff @(posedge clk, negedge rst_n) 
    if (!rst_n)
        resp <= 16'h0000;
    else if (init)
        resp <= cmd;
    else if (shift)
        resp <= {resp[14:0], MISO};

// SCLK counter
always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
        SCLK_cnt <= 5'h00;
    else if (ld_SCLK)
        /* SCLK starts a quarter cycle after SS_n, and 
        a full system cycle is 32 clk cycle. */
        SCLK_cnt <= 5'b10111; 
    else if (~ld_SCLK)
        SCLK_cnt <= SCLK_cnt + 1;

// we want to shift only 2 SCLK after the rise of SCLK
assign shift = (SCLK_cnt == 5'b10001) ? 1'b1 : 1'b0;
assign full = (SCLK_cnt == 5'b11111) ? 1'b1 : 1'b0;
assign SCLK = SCLK_cnt[4];

// Done logic
always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
        bit_cnt <= 5'h00;
    else if (init)
        bit_cnt <= 5'b00000;
    else if (shift)
        bit_cnt <= bit_cnt + 1;

assign done16 = &bit_cnt;

// RS flop for done
always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
        done <= 1'b0;
    else if (init)
        done <= 1'b0;
    else if (set_done)
        done <= 1'b1;

// FSM flop
always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
        nxt_state <= IDLE;
    else 
        nxt_state <= state;

// FSM
always_comb begin
    init = 1'b0;
    ld_SCLK = 1'b0;
    set_done = 1'b0;

    case (state)
        default: // IDLE
            if (snd) begin
                init = 1'b1;
                nxt_state = SHIFT;
            end

        SHIFT: 
            if (done16) begin
                ld_SCLK = 1'b1;
                nxt_state = DONEl
            end

        DONE:
            if (full) begin
                set_done = 1'b1;
                nxt_state = IDLE;
            end
    endcase
end

endmodule