import uvm_pkg::*;
`include "uvm_macros.svh"
import Ram_test_pkg::*;

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
  Ram_if r_if(clk);
  RAM DUT(r_if.din,r_if.clk,r_if.rst_n,r_if.rx_valid,r_if.dout,r_if.tx_valid);
  SPR #(256,8) Golden (r_if.din,r_if.clk,r_if.rst_n,r_if.rx_valid,r_if.tx_valid_exp,r_if.dout_exp);
  bind RAM Ram_sva binded_assertions (r_if.din,r_if.clk,r_if.rst_n,r_if.rx_valid,r_if.dout,r_if.tx_valid);
  // run test using run_test task
  initial begin
    uvm_config_db #(virtual Ram_if)::set(null,"uvm_test_top","RAM",r_if);
    run_test("Ram_test");
  end
endmodule