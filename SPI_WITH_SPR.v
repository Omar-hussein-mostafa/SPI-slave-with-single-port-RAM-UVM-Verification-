module SPI_WITH_SPR#(parameter MEM_DEPTH=256,parameter ADDR_SIZE=8)(clk,rstn,MISO,MOSI,SS_n);

input clk,rstn,SS_n,MOSI;
output MISO;

wire tx_valid,rx_valid;
wire [7:0] tx_data;
wire[9:0] rx_data;

SPI_slave_op SPI(MOSI,MISO,clk,rstn,rx_data,tx_data,rx_valid,tx_valid,SS_n);
SPR #(MEM_DEPTH,ADDR_SIZE)RAM(rx_data,clk,rstn,rx_valid,tx_valid,tx_data);

endmodule