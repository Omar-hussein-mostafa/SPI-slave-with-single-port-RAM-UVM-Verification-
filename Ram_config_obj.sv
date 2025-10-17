///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Configuration Object
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class Ram_config_obj extends uvm_object;
        `uvm_object_utils(Ram_config_obj)

        virtual Ram_if Ram_config_vif;
        uvm_active_passive_enum is_active; 
        function new(string name="Ram_config_obj");
            super.new(name);
        endfunction
        
    endclass
endpackage