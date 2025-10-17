///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Monitor
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;
    class Ram_monitor extends uvm_monitor ;
        `uvm_component_utils(Ram_monitor)
        
        //Creating Virtual interface to get the data from the interface
        virtual Ram_if r_if;
        //Creating monitor sequence item to pass the interface to it to be then sent to the analysis components
        Ram_seq_item mon_seq_item;
        //Creating monitor analysis port to broadcast the values to the analysis components
        uvm_analysis_port #(Ram_seq_item) mon_ap;

        //Constructor
        function new(string name="Ram_monitor",uvm_component parent=null);
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
                mon_seq_item=Ram_seq_item::type_id::create("mon_seq_item");
                @(negedge r_if.clk);
                
                //Drive the monitor sequence item with the interface
                mon_seq_item.din         =r_if.din;
                mon_seq_item.rst_n       =r_if.rst_n;
                mon_seq_item.rx_valid    =r_if.rx_valid;
                mon_seq_item.dout        =r_if.dout;
                mon_seq_item.tx_valid    =r_if.tx_valid;
                mon_seq_item.tx_valid_exp=r_if.tx_valid_exp;
                mon_seq_item.dout_exp    =r_if.dout_exp;
                
                //Broadcast the monitor sequence (interfance) to the analysis port 
                mon_ap.write(mon_seq_item);
                `uvm_info("Monitor run phase",mon_seq_item.convert2string(),UVM_HIGH)
            end
        endtask
    endclass
endpackage