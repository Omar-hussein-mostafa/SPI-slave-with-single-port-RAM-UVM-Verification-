////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name: Omar Mohamed Hussein
//UVM_Component: Agent 
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

package Ram_agent_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import Ram_seq_item_pkg::*;
    import Ram_sqr_pkg::*;
    import Ram_driver_pkg::*;
    import Ram_monitor_pkg::*;
    import Ram_config_pkg::*;

    class Ram_agent extends uvm_agent;
        `uvm_component_utils(Ram_agent) 

        //creating the sequencer,driver,monitor, configuration object to connect the interface,agent port
        Ram_sqr sqr;
        Ram_driver drv;
        Ram_monitor mon;
        Ram_config_obj config_obj;
        uvm_analysis_port #(Ram_seq_item) agt_ap;

        //Constructor
        function  new(string name="Ram_agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        //Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Connect the agent configuration object with the configuration object in the uvm config data base
            if(!uvm_config_db #(Ram_config_obj)::get(this,"","CFG",config_obj)) begin
                `uvm_fatal("agent build phase","unable to get the configuration object to the agent")
            end
            
            //Creating the sequencer,driver,monitor with the create() and the agt port with new()
            sqr=Ram_sqr    ::type_id::create("sqr",this);
            drv=Ram_driver ::type_id::create("drv",this);
            mon=Ram_monitor::type_id::create("mon",this);
            agt_ap=new("agt_ap",this);
        endfunction

        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //Conncet the configuration object with the driver and the monitor ports
            drv.Ram_driver_vif=config_obj.Ram_config_vif;
            mon.r_if=config_obj.Ram_config_vif;
            //Connect the driver port with the sequencer export
            drv.seq_item_port.connect(sqr.seq_item_export);
            //Connect the monitor analysis port with the agt port
            mon.mon_ap.connect(agt_ap);
        endfunction  
    endclass
endpackage