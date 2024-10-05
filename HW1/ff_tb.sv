module ff_tb();

    logic d, clk, q;
    ff DUT(.d(d), .clk(clk), .q(q));

    always 
        #5 clk = ~clk;
    initial 
        clk = 0;
    
    initial begin
        d = 0;

        #10 d = 1;
        #10 d = 0;
        #20 d = 1;
        #20 d = 0;

        $stop;

    end

endmodule