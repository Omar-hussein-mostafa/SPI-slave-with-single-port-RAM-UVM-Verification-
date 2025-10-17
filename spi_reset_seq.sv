///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Reset Sequence
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_seq_item::*;

    class spi_reset_seq extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_reset_seq)

    spi_seq_item seq_item;

    function new(string name ="spi_reset_seq");
        super.new(name);
    endfunction
    
    task body;
        seq_item=spi_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n=0;
        seq_item.MOSI=$random;
        finish_item(seq_item);
    endtask
    endclass
endpackage