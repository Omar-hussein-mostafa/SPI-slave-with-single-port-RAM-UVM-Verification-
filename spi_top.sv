///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : TOP
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_test_pkg::*;

module top();
  // Clock generation
  bit clk;
  initial begin
    clk=0;
    forever begin
      #10 clk=~clk;
    end
  end
  // Instantiate the interface ,Golden Model and DUT
  spi_if s_if(clk);
  SLAVE slave(s_if.MOSI,s_if.MISO,s_if.SS_n,s_if.clk,s_if.rst_n,s_if.rx_data,s_if.rx_valid,s_if.tx_data,s_if.tx_valid);
  SPI_slave_op Golden_spi(s_if.MOSI,s_if.MISO_exp,s_if.clk,s_if.rst_n,s_if.rx_data_exp,s_if.tx_data,s_if.rx_valid_exp,s_if.tx_valid,s_if.SS_n);
  bind slave spi_sva binded_assertions(s_if.MOSI,s_if.MISO,s_if.SS_n,s_if.clk,s_if.rst_n,s_if.rx_data,s_if.rx_valid,s_if.tx_data,s_if.tx_valid);

  // run test using run_test task
  initial begin
    uvm_config_db #(virtual spi_if)::set(null,"uvm_test_top","spi_if",s_if);
    run_test("spi_test");
  end
endmodule