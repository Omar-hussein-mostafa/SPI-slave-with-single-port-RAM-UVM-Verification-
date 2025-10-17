///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Sequencer 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_sqr_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_sqr extends uvm_sequencer #(Ram_seq_item);
        `uvm_component_utils(Ram_sqr)

        function new(string name="Ram_sqr",uvm_component parent=null);
            super.new(name,parent);
        endfunction
    endclass
endpackage