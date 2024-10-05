
module ff_w_rst(input d, input clk, input rst_h, output q);

	wire md, mq, sd;
	notif1 #1 tri_1(md, d, ~clk), tri_2(sd, mq, clk);
	
	nor master_s(mq, md, rst_h), slave_s(q, sd, rst_h);
	not (weak0, weak1) master_w(md, mq), slave_w(sd, q);
endmodule