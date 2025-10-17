///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Test
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Ram_env_pkg::*;
import Ram_config_pkg::*;
import Ram_reset_seq_pkg::*;
import Ram_write_seq_pkg::*;
import Ram_read_write_seq_pkg::*;
import Ram_read_seq_pkg::*;
    class Ram_test extends uvm_test;
        `uvm_component_utils(Ram_test)

        Ram_env env;
        Ram_config_obj Ram_config_obj_test;
        Ram_reset_seq reset_seq;
        Ram_write_seq write_seq;
        Ram_read_seq read_seq;
        Ram_read_write_seq write_read_seq;
        function new(string name ="Ram_test",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=Ram_env::type_id::create("env",this);
            Ram_config_obj_test=Ram_config_obj::type_id::create("Ram_config_obj_test");
            reset_seq=Ram_reset_seq::type_id::create("reset_seq");
            write_seq=Ram_write_seq::type_id::create("write_seq");
            read_seq=Ram_read_seq::type_id::create("read_seq");
            write_read_seq=Ram_read_write_seq::type_id::create("write_read_seq");

            if(!uvm_config_db #(virtual Ram_if)::get(this,"","RAM",Ram_config_obj_test.Ram_config_vif))
                `uvm_fatal("build phase in test","unable to get interface from the database into the configuration object")
            uvm_config_db#(Ram_config_obj)::set(this,"*","CFG",Ram_config_obj_test);
        endfunction

        task  run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("Test run phase","Reset Asserted",UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Reset Finished",UVM_LOW)

            `uvm_info("Test run phase","Write sequence Asserted",UVM_LOW)
            write_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Write sequence Finished",UVM_LOW)

            `uvm_info("Test run phase","Read sequence Asserted",UVM_LOW)
            read_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Read sequence Finished",UVM_LOW)

            `uvm_info("Test run phase","Write Read sequence Asserted",UVM_LOW)
            write_read_seq.start(env.agt.sqr);
            `uvm_info("Test run phase","Write Read sequence Finished",UVM_LOW)
            phase.drop_objection(this);
        endtask
    endclass
endpackage