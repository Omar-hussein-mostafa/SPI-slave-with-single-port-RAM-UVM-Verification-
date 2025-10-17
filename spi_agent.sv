////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name: Omar Mohamed Hussein
//UVM_Component: Agent 
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
package spi_agent_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import spi_seq_item::*;
    import spi_sequencer_pkg::*;
    import spi_driver_pkg::*;
    import spi_monitor_pkg::*;
    import spi_config_pkg::*;

    class spi_agent extends uvm_agent;
        `uvm_component_utils(spi_agent) 

        //creating the sequencer,driver,monitor, configuration object to connect the interface,agent port
        spi_sqr sqr;
        spi_driver drv;
        spi_monitor mon;
        spi_config_obj config_obj;
        uvm_analysis_port #(spi_seq_item) agt_ap;

        //Constructor
        function  new(string name="spi_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        //Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Connect the agent configuration object with the configuration object in the uvm config data base
            if(!uvm_config_db #(spi_config_obj)::get(this,"","CFG",config_obj)) begin
                `uvm_fatal("agent build phase","unable to get the configuration object to the agent")
            end
            
            ///////////////// For Passive Agents ////////////////////////////////////////////////////////////////
            // if(shift_reg_cfg.is_active==UVM_ACTIVE) begin
            //     sqr=sequencer::type_id::create("sqr",this);
            //     drv=shift_reg_driver::type_id::create("drv",this);
            // end
            /////////////////////////////////////////////////////////////////////////////////////////////////////
            
            //Creating the sequencer,driver,monitor with the create() and the agt port with new()
            sqr=spi_sqr    ::type_id::create("sqr",this);
            drv=spi_driver ::type_id::create("drv",this);
            mon=spi_monitor::type_id::create("mon",this);
            agt_ap=new("agt_ap",this);
        endfunction

        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            /////////////////////////////////////For Passive Agents ///////////////////////////////////////////
            // if(spi_cfg.is_active==UVM_ACTIVE) begin
            //     drv.spi_vif=spi_cfg.spi_vif;
            //     drv.seq_item_port.connect(sqr.seq_item_export);
            // end
            ///////////////////////////////////////////////////////////////////////////////////////////////////

            //Conncet the configuration object with the driver and the monitor ports
            drv.spi_driver_vif=config_obj.spi_config_vif;
            mon.s_if=config_obj.spi_config_vif;
            //Connect the driver port with the sequencer export
            drv.seq_item_port.connect(sqr.seq_item_export);
            //Connect the monitor analysis port with the agt port
            mon.mon_ap.connect(agt_ap);
        endfunction  
    endclass
endpackage