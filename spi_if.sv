interface spi_if(clk);
    input clk;
    logic MOSI, SS_n, rst_n;
    logic MISO,MISO_exp;
    logic tx_valid,rx_valid,rx_valid_exp;
    logic [9:0] rx_data,rx_data_exp;
    logic [7:0] tx_data;

endinterface