///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Reset Sequence
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_reset_seq extends uvm_sequence #(Ram_seq_item);
    `uvm_object_utils(Ram_reset_seq)

    Ram_seq_item seq_item;

    function new(string name ="Ram_reset_seq");
        super.new(name);
    endfunction
    
    task body;
        seq_item=Ram_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n=0;
        finish_item(seq_item);
    endtask
    
    endclass
endpackage