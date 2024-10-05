
module sqrt_tb();

logic [15:0] op;
logic [7:0] sqrt;
logic go, clk, rst_n, err, done;

sqrt iDUT(.op(op), .sqrt(sqrt), .go(go), .clk(clk), .rst_n(rst_n), .err(err), .done(done));



always begin
	clk = 0;
	rst_n = 1;
	go = 0;
	
	// Check if it can do sqrt of 144 and return 12 properly
	// sqrt should be 12, error should 0
	repeat(5) @(negedge clk);
	op = 16'h0090;
	repeat(5) @(posedge clk);
	go = 1;
	while (done !== 1) begin
		@(posedge clk);	
	end
	assert(sqrt == 8'h0c) $display("Sqrt for 144 is correct");
	else $fatal("Sqrt for 144 failed");
	assert(err == 0) $display("Sqrt for 144 is correct");
	else $fatal("Err should be 0 for sqrt 144");

	// Check if it can assert error when op is a negative number
	// err should be 1
	repeat(5) @(negedge clk);
	op = 16'hffff;
	repeat(5) @(posedge clk);
	go = 1;
	while (done !== 1) begin
		@(posedge clk);	
	end
	assert(err == 1) $display("Sqrt for -144 is not produced");
	else $fatal("Err should be 1 for sqrt -144");
	@(posedge clk);
	assert(go == 0) $display("Go for -144 is 0");
	else $fatal("Go should be 0 for sqrt -144");

	$stop();

end
	
		
always 
	#10 clk = ~clk;
endmodule