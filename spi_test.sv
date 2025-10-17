///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Test
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_env_pkg::*;
import spi_config_pkg::*;
import spi_reset_seq_pkg::*;
import spi_main_seq_pkg::*;
    class spi_test extends uvm_test;
        `uvm_component_utils(spi_test)

        spi_env env;
        spi_config_obj spi_config_obj_test;
        spi_reset_seq reset_seq;
        spi_main_seq main_seq;
        function new(string name ="spi_test",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=spi_env::type_id::create("env",this);
            spi_config_obj_test=spi_config_obj::type_id::create("spi_config_obj_test");
            reset_seq=spi_reset_seq::type_id::create("reset_seq");
            main_seq=spi_main_seq::type_id::create("main_seq");

            if(!uvm_config_db #(virtual spi_if)::get(this,"","spi_if",spi_config_obj_test.spi_config_vif))
                `uvm_fatal("build phase in test","unable to get interface from the database into the configuration object")
            uvm_config_db#(spi_config_obj)::set(this,"*","CFG",spi_config_obj_test);
        endfunction

        task  run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("Test run phase","Reset Asserted",UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Reset Finished",UVM_LOW)

            `uvm_info("Test run phase","Main sequence Asserted",UVM_LOW)
            main_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Main sequence Finished",UVM_LOW)
            phase.drop_objection(this);
        endtask
    endclass
endpackage