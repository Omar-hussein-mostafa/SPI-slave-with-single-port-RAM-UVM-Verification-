///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Driver
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package wrapper_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import wrapper_config_pkg::*;
    import wrapper_seq_item::*;

    class wrapper_driver extends uvm_driver #(wrapper_seq_item);
        `uvm_component_utils(wrapper_driver)

        //Virtual interface & sequence item object
        virtual wrapper_if wrapper_driver_vif;
        wrapper_seq_item drv_seq_item;

        //Constructor
        function new(string name="wrapper_driver",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        //Build_Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        //Run Phase :: Create seq_item => seq_item_port.get_next_item => drive the interface from the sequenc item => wait negative edge => seq_item_port.item_done
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                //Create seq_item
                drv_seq_item=wrapper_seq_item::type_id::create("drv_seq_item");
                //seq_item_port.get_next_item : get the values from the driver port connected with the sequencer to the driver seq item
                seq_item_port.get_next_item(drv_seq_item);

                //Drive the interface with the driver sequence item
                wrapper_driver_vif.rst_n= drv_seq_item.rst_n;
                wrapper_driver_vif.SS_n= drv_seq_item.SS_n;
                wrapper_driver_vif.MOSI= drv_seq_item.MOSI;
                
                @(negedge wrapper_driver_vif.clk);
                //Transaction Done , now get next item and so on ...
                seq_item_port.item_done();
                `uvm_info("Driver run phase",drv_seq_item.convert2string_stimulus(),UVM_HIGH)
            end
        endtask
    endclass
endpackage