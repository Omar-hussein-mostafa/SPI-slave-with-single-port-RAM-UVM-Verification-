package wrapper_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item::*;
    import shared_pkg::*;
    class wrapper_monitor extends uvm_monitor ;
        `uvm_component_utils(wrapper_monitor)
        
        //Creating Virtual interface to get the data from the interface
        virtual wrapper_if w_if;
        //Creating monitor sequence item to pass the interface to it to be then sent to the analysis components
        wrapper_seq_item mon_seq_item;
        //Creating monitor analysis port to broadcast the values to the analysis components
        uvm_analysis_port #(wrapper_seq_item) mon_ap;

        //Constructor
        function new(string name="wrapper_monitor",uvm_component parent=null);
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
                mon_seq_item=wrapper_seq_item::type_id::create("mon_seq_item");
                @(negedge w_if.clk);
                mon_seq_item.rst_n=w_if.rst_n;
                mon_seq_item.SS_n=w_if.SS_n;
                mon_seq_item.MOSI=w_if.MOSI;
                mon_seq_item.MISO=w_if.MISO;
                mon_seq_item.MISO_exp=w_if.MISO_exp;
                //Drive the monitor sequence item with the interface
                
                //Broadcast the monitor sequence (interfance) to the analysis port 
                mon_ap.write(mon_seq_item);
                `uvm_info("Monitor run phase",mon_seq_item.convert2string(),UVM_HIGH)
            end
        endtask
    endclass
endpackage