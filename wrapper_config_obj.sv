package wrapper_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class wrapper_config_obj extends uvm_object;
        `uvm_object_utils(wrapper_config_obj)

        virtual wrapper_if wrapper_config_vif;
        uvm_active_passive_enum is_active; 
        function new(string name="alsu_config_obj");
            super.new(name);
        endfunction
        
    endclass
endpackage