///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Driver
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import spi_config_pkg::*;
    import spi_seq_item::*;

    class spi_driver extends uvm_driver #(spi_seq_item);
        `uvm_component_utils(spi_driver)

        //Virtual interface & sequence item object
        virtual spi_if spi_driver_vif;
        spi_seq_item drv_seq_item;

        //Constructor
        function new(string name="spi_driver",uvm_component parent=null);
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
                drv_seq_item=spi_seq_item::type_id::create("drv_seq_item");
                //seq_item_port.get_next_item : get the values from the driver port connected with the sequencer to the driver seq item
                seq_item_port.get_next_item(drv_seq_item);

                //Drive the interface with the driver sequence item
                spi_driver_vif.rst_n= drv_seq_item.rst_n;
                spi_driver_vif.MOSI = drv_seq_item.MOSI;
                spi_driver_vif.tx_data= drv_seq_item.tx_data;
                spi_driver_vif.SS_n= drv_seq_item.SS_n;
                spi_driver_vif.tx_valid= drv_seq_item.tx_valid;
                
                @(negedge spi_driver_vif.clk);
                //Transaction Done , now get next item and so on ...
                seq_item_port.item_done();
                `uvm_info("Driver run phase",drv_seq_item.convert2string_stimulus(),UVM_HIGH)
            end

        endtask

    endclass
endpackage