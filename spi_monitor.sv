///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Monitor
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_seq_item::*;
    import shared_pkg::*;
    class spi_monitor extends uvm_monitor ;
        `uvm_component_utils(spi_monitor)
        
        //Creating Virtual interface to get the data from the interface
        virtual spi_if s_if;
        //Creating monitor sequence item to pass the interface to it to be then sent to the analysis components
        spi_seq_item mon_seq_item;
        //Creating monitor analysis port to broadcast the values to the analysis components
        uvm_analysis_port #(spi_seq_item) mon_ap;

        //Constructor
        function new(string name="spi_monitor",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        //Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap=new("mon_ap",this);
        endfunction

        //Run Phase: samples the data at the negative edge and writes the analysis port with the monitor sequence item
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                mon_seq_item=spi_seq_item::type_id::create("mon_seq_item");
                @(negedge s_if.clk);
                
                //Drive the monitor sequence item with the interface
                mon_seq_item.rst_n=s_if.rst_n;
                mon_seq_item.SS_n=s_if.SS_n;
                mon_seq_item.MOSI=s_if.MOSI;
                mon_seq_item.MISO=s_if.MISO;
                mon_seq_item.MISO_exp=s_if.MISO_exp;
                mon_seq_item.tx_valid=s_if.tx_valid;
                mon_seq_item.tx_data=s_if.tx_data;
                mon_seq_item.rx_valid=s_if.rx_valid;
                mon_seq_item.rx_valid_exp=s_if.rx_valid_exp;
                mon_seq_item.rx_data=s_if.rx_data;
                mon_seq_item.rx_data_exp=s_if.rx_data_exp;
                
                //Broadcast the monitor sequence (interfance) to the analysis port 
                mon_ap.write(mon_seq_item);
                `uvm_info("Monitor run phase",mon_seq_item.convert2string(),UVM_HIGH)
            end
        endtask
    endclass
endpackage