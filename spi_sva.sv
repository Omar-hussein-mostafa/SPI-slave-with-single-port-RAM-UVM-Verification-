module spi_sva(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
input MOSI,MISO,SS_n,clk,rst_n,rx_valid,tx_valid;
input [9:0]rx_data;
input [7:0]tx_data;

    sequence valid_comb_000;
    ($fell(SS_n) ##1 !MOSI ##1 !MOSI ##1 !MOSI);
    endsequence
    sequence valid_comb_001;
    ($fell(SS_n) ##1  !MOSI ##1 !MOSI ##1 MOSI);
    endsequence
    sequence valid_comb_110;
    ($fell(SS_n) ##1 MOSI ##1 MOSI ##1 !MOSI);
    endsequence
    sequence valid_comb_111;
    ($fell(SS_n) ##1 MOSI ##1 MOSI ##1 MOSI);
    endsequence
    assert property(@(posedge clk) disable iff(!rst_n) valid_comb_000 |-> ##10 (rx_valid ##1 SS_n[->1]));
    assert property(@(posedge clk) disable iff(!rst_n) valid_comb_001 |-> ##10 (rx_valid ##1 SS_n[->1]));
    assert property(@(posedge clk) disable iff(!rst_n) valid_comb_110 |-> ##10 (rx_valid ##1 SS_n[->1]));
    assert property(@(posedge clk) disable iff(!rst_n) valid_comb_111 |-> ##10 (rx_valid ##1 SS_n[->1]));
    assert property(@(posedge clk) !rst_n |=> !MISO && !rx_valid && rx_data==0);
    cover  property(@(posedge clk) disable iff(!rst_n) valid_comb_000 |-> ##10 (rx_valid  ##1 SS_n[->1]));
    cover  property(@(posedge clk) disable iff(!rst_n) valid_comb_001 |-> ##10 (rx_valid  ##1 SS_n[->1]));
    cover  property(@(posedge clk) disable iff(!rst_n) valid_comb_110 |-> ##10 (rx_valid  ##1 SS_n[->1]));
    cover  property(@(posedge clk) disable iff(!rst_n) valid_comb_111 |-> ##10 (rx_valid  ##1 SS_n[->1]));
    cover  property(@(posedge clk) !rst_n |=> !MISO && !rx_valid && rx_data==0);
endmodule