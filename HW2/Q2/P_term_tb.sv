module P_term_tb ();

  logic [11:0] error;
  logic [13:0] P_term;

  P_term iDUT (
      .error (error),
      .P_term(P_term)
  );

  initial begin

    // Test 1: error at maximum positive value
    error = 12'h1ff;
    #10;
    if (P_term !== 14'h1ff0) begin
      $display("Test 1 failed: input is %h and output should be: %h, but it is: %h", error, 14'h1ff0,
               P_term);
      $stop();
    end else begin
      $display("Test 1 passed");
    end

    // Test 2: value at maximum negative value
    error = 12'he00;
    #10;
    if (P_term !== 14'h2000) begin
      $display("Test 2 failed: input is %h and output should be: %h, but it is: %h", error, 14'h2000,
               P_term);
      $stop();
    end else begin
      $display("Test 2 passed");
    end

    // Test 3: value greater than max
    error = 12'h2ff;
    #10;
    if (P_term !== 14'h1ff0) begin
      $display("Test 3 failed: input is %h and output should be: %h, but it is: %h", error, 14'h1ff0,
               P_term);
      $stop();
    end else begin
      $display("Test 3 passed");
    end

    // Test 4: value greater than max
    error = 12'hc00;
    #10;
    if (P_term !== 14'h2000) begin
      $display("Test 4 failed: input is %h and output should be: %h, but it is: %h", error, 14'h2000,
               P_term);
      $stop();
    end else begin
      $display("Test 4 passed");
    end

    // Test 5: positive value within the range
    error = 12'h0ff;
    #10;
    if (P_term !== 14'h0ff0) begin
      $display("Test 5 failed: input is %h and output should be: %h, but it is: %h", error, 14'h0ff0,
               P_term);
      $stop();
    end else begin
      $display("Test 5 passed");
    end

    
    // Test 6: negative value within the range
    error = 12'he0f;
    #10;
    if (P_term !== 14'he0f0) begin
      $display("Test 6 failed: input is %h and output should be: %h, but it is: %h", error, 14'he0f0,
               P_term);
      $stop();
    end else begin
      $display("Test 6 passed");
    end
  end

endmodule
