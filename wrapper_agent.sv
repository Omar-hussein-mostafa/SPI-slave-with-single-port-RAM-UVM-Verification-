////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name: Omar Mohamed Hussein
//UVM_Component:Agent Package
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
package wrapper_agent_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import wrapper_seq_item::*;
    import wrapper_sqr_pkg::*;
    import wrapper_driver_pkg::*;
    import wrapper_monitor_pkg::*;
    import wrapper_config_pkg::*;

    class wrapper_agent extends uvm_agent;
        `uvm_component_utils(wrapper_agent) 

        //creating the sequencer,driver,monitor, configuration object to connect the interface,agent port
        wrapper_sqr sqr;
        wrapper_driver drv;
        wrapper_monitor mon;
        wrapper_config_obj config_obj;
        uvm_analysis_port #(wrapper_seq_item) agt_ap;

        //Constructor
        function  new(string name="wrapper_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        //Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Connect the agent configuration object with the configuration object in the uvm config data base
            if(!uvm_config_db #(wrapper_config_obj)::get(this,"","CFG_WRAPPER",config_obj)) begin
                `uvm_fatal("agent build phase","unable to get the configuration object to the agent")
            end
            
            //Creating the sequencer,driver,monitor with the create() and the agt port with new()
            sqr=wrapper_sqr    ::type_id::create("sqr",this);
            drv=wrapper_driver ::type_id::create("drv",this);
            mon=wrapper_monitor::type_id::create("mon",this);
            agt_ap=new("agt_ap",this);
        endfunction

        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //Conncet the configuration object with the driver and the monitor ports
            drv.wrapper_driver_vif=config_obj.wrapper_config_vif;
            mon.w_if=config_obj.wrapper_config_vif;
            //Connect the driver port with the sequencer export
            drv.seq_item_port.connect(sqr.seq_item_export);
            //Connect the monitor analysis port with the agt port
            mon.mon_ap.connect(agt_ap);
        endfunction  
    endclass
endpackage