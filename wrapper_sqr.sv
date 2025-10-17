package wrapper_sqr_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item::*;
    import shared_pkg::*;
    class wrapper_sqr extends uvm_sequencer #(wrapper_seq_item);
        `uvm_component_utils(wrapper_sqr)

        function new(string name="wrapper_sqr",uvm_component parent=null);
            super.new(name,parent);
        endfunction
    endclass
endpackage