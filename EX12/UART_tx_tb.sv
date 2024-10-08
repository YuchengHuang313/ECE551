module UART_tx_tb();

logic clk, rst_n, TX, trmt, tx_done;
logic [7:0] tx_data;

UART_tx iDUT(.clk(clk), .rst_n(rst_n), .TX(TX), .trmt(trmt), .tx_data(tx_data), .tx_done(tx-done));

endmodule
