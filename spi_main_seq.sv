///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Reset Sequence
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_main_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_seq_item::*;

    class spi_main_seq extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_main_seq)

    spi_seq_item seq_item;

    function new(string name ="spi_main_seq");
        super.new();
    endfunction
    
    virtual task body();
        seq_item=spi_seq_item::type_id::create("seq_item");
        repeat(10000) begin
            start_item(seq_item);
                assert(seq_item.randomize()); 
            finish_item(seq_item);
        end
    endtask
    endclass
endpackage