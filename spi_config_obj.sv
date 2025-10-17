///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Configuration Object
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_config_obj extends uvm_object;
        `uvm_object_utils(spi_config_obj)

        virtual spi_if spi_config_vif;
        uvm_active_passive_enum is_active; 
        function new(string name="alsu_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage