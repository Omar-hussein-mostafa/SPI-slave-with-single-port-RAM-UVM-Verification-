import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_test_pkg::*;

module top();
  // Clock generation
  bit clk;
  initial begin
    clk=0;
    forever begin
      #10 clk=~clk;
    end
  end
  initial begin
    $readmemh("mem.dat",Golden.RAM.MEM);
    $readmemh("mem.dat",DUT.RAM_instance.MEM);
  end 
  // Instantiate the interface ,Golden Model and DUT
  Ram_if r_if(clk);
  spi_if s_if(clk);
  wrapper_if w_if(clk);

  WRAPPER DUT(w_if.MOSI,w_if.MISO,w_if.SS_n,w_if.clk,w_if.rst_n);
  SPI_WITH_SPR #(256,8)Golden(w_if.clk,w_if.rst_n,w_if.MISO_exp,w_if.MOSI,w_if.SS_n);

  assign s_if.rx_data= DUT.rx_data_din;
  assign s_if.clk= DUT.clk;
  assign s_if.rst_n= DUT.rst_n;
  assign s_if.rx_valid= DUT.rx_valid;
  assign s_if.tx_data= DUT.tx_data_dout;
  assign s_if.tx_valid= DUT.tx_valid;
  assign s_if.rx_data_exp = Golden.rx_data;
  assign s_if.rx_valid_exp= Golden.rx_valid;
  assign s_if.MISO_exp= Golden.MISO;
  assign s_if.MISO= DUT.MISO;
  assign s_if.SS_n= DUT.SS_n;
  assign s_if.MOSI= DUT.MOSI;

  assign r_if.din= DUT.rx_data_din;
  assign r_if.clk= DUT.clk;
  assign r_if.rst_n= DUT.rst_n;
  assign r_if.rx_valid= DUT.rx_valid;
  assign r_if.dout= DUT.tx_data_dout;
  assign r_if.dout_exp= Golden.tx_data;
  assign r_if.tx_valid= DUT.tx_valid;
  assign r_if.tx_valid_exp= Golden.tx_valid;

  bind DUT.RAM_instance Ram_sva Ram_assertion (r_if.din,r_if.clk,r_if.rst_n,r_if.rx_valid,r_if.dout,r_if.tx_valid);
  bind DUT.SLAVE_instance spi_sva SPI_assertion (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
  
  // run test using run_test task
  initial begin
    uvm_config_db #(virtual Ram_if)::set(null,"uvm_test_top","RAM",r_if);
    uvm_config_db #(virtual spi_if)::set(null,"uvm_test_top","SPI",s_if);
    uvm_config_db #(virtual wrapper_if)::set(null,"uvm_test_top","WRAPPER",w_if);
    run_test("wrapper_test");
  end
endmodule