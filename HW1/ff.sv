
module ff(input d, input clk, output q);

	wire md, mq, sd;
	notif1 #1 tri_1(md, d, ~clk), tri_2(sd, mq, clk);
	
	not master_s(mq, md), slave_s(q, sd);
	not (weak0, weak1) master_w(md, mq), slave_w(sd, q);
endmodule