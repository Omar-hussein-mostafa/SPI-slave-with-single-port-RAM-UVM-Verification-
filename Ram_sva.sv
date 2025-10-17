module Ram_sva(din,clk,rst_n,rx_valid,dout,tx_valid);
input      [9:0] din;
input            clk, rst_n, rx_valid;

input reg [7:0] dout;
input reg       tx_valid;

sequence ops;
    (din[9:8]==2'b00 || din[9:8]==2'b01 || din[9:8]==2'b10) && rx_valid;
endsequence
assert property(@(posedge clk) !rst_n |=> dout==0 && !tx_valid);
assert property(@(posedge clk) disable iff(!rst_n) ops |=> !tx_valid );
assert property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b11 |=> $rose(tx_valid) |=> $fell(tx_valid)[->1]);
assert property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b00 |=>  (rx_valid && din[9:8]== 2'b01)[->1]);
assert property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b10 |=>  (rx_valid && din[9:8]== 2'b11)[->1]);

cover  property(@(posedge clk) !rst_n |=> dout==0 && !tx_valid);
cover  property(@(posedge clk) disable iff(!rst_n) ops |=> !tx_valid && dout==0);
cover  property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b11 |=> $rose(tx_valid) |=> $fell(tx_valid)[->1]);
cover  property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b00 |=>  (rx_valid && din[9:8]== 2'b01)[->1]);
cover  property(@(posedge clk) disable iff(!rst_n) rx_valid && din[9:8]==2'b10 |=>  (rx_valid && din[9:8]== 2'b11)[->1]);

endmodule