package wrapper_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_env_pkg::*;
import Ram_env_pkg::*;
import spi_env_pkg::*;
import wrapper_config_pkg::*;
import spi_config_pkg::*;
import Ram_config_pkg::*;
import wrapper_reset_seq_pkg::*;
import wrapper_write_seq_pkg::*;
import wrapper_read_write_seq_pkg::*;
import wrapper_read_seq_pkg::*;
    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test)

        wrapper_env w_env;
        spi_env s_env;
        Ram_env r_env;
        wrapper_config_obj wrapper_config_obj_test;
        spi_config_obj spi_config_obj_test;
        Ram_config_obj Ram_config_obj_test;
        wrapper_reset_seq reset_seq;
        wrapper_write_seq write_seq;
        wrapper_read_seq read_seq;
        wrapper_read_write_seq write_read_seq;

        function new(string name ="wrapper_test",uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            w_env=wrapper_env::type_id::create("w_env",this);
            r_env=Ram_env::type_id::create("r_env",this);
            s_env=spi_env::type_id::create("s_env",this);
            wrapper_config_obj_test=wrapper_config_obj::type_id::create("wrapper_config_obj_test");
            Ram_config_obj_test=Ram_config_obj::type_id::create("Ram_config_obj_test");
            spi_config_obj_test=spi_config_obj::type_id::create("spi_config_obj_test");
            reset_seq=wrapper_reset_seq::type_id::create("reset_seq");
            write_seq=wrapper_write_seq::type_id::create("write_seq");
            read_seq=wrapper_read_seq::type_id::create("read_seq");
            write_read_seq=wrapper_read_write_seq::type_id::create("write_read_seq");

            if(!uvm_config_db #(virtual wrapper_if)::get(this,"","WRAPPER",wrapper_config_obj_test.wrapper_config_vif))
                `uvm_fatal("build phase in test","unable to get interface from the database into the configuration object")
            uvm_config_db#(wrapper_config_obj)::set(this,"*","CFG_WRAPPER",wrapper_config_obj_test);

            if(!uvm_config_db #(virtual spi_if)::get(this,"","SPI",spi_config_obj_test.spi_config_vif))
                `uvm_fatal("build phase in test","unable to get interface from the database into the configuration object")
            uvm_config_db#(spi_config_obj)::set(this,"*","CFG_SPI",spi_config_obj_test);

            if(!uvm_config_db #(virtual Ram_if)::get(this,"","RAM",Ram_config_obj_test.Ram_config_vif))
                `uvm_fatal("build phase in test","unable to get interface from the database into the configuration object")
            uvm_config_db#(Ram_config_obj)::set(this,"*","CFG_RAM",Ram_config_obj_test);

            wrapper_config_obj_test.is_active=UVM_ACTIVE;
            spi_config_obj_test.is_active=UVM_PASSIVE;
            Ram_config_obj_test.is_active=UVM_PASSIVE;
        endfunction

        task  run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("Test run phase","Reset Asserted",UVM_LOW)
            reset_seq.start(w_env.agt.sqr);
            `uvm_info("Test run phase","Reset Finished",UVM_LOW)

            `uvm_info("Test run phase","Write sequence Asserted",UVM_LOW)
            write_seq.start(w_env.agt.sqr);
            `uvm_info("Test run phase","Write sequence Finished",UVM_LOW)

            `uvm_info("Test run phase","Read sequence Asserted",UVM_LOW)
            read_seq.start(w_env.agt.sqr);
            `uvm_info("Test run phase","Read sequence Finished",UVM_LOW)

            `uvm_info("Test run phase","Write Read sequence Asserted",UVM_LOW)
            write_read_seq.start(w_env.agt.sqr);
            `uvm_info("Test run phase","Write Read sequence Finished",UVM_LOW)
            phase.drop_objection(this);
        endtask
    endclass
endpackage