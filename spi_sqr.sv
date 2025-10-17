///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Sequencer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_seq_item::*;
    import shared_pkg::*;
    class spi_sqr extends uvm_sequencer #(spi_seq_item);
        `uvm_component_utils(spi_sqr)

        function new(string name="spi_sqr",uvm_component parent=null);
            super.new(name,parent);
        endfunction
    endclass
endpackage