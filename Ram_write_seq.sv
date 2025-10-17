///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Write Sequence
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_write_seq extends uvm_sequence #(Ram_seq_item);
    `uvm_object_utils(Ram_write_seq)

    Ram_seq_item seq_item;

    function new(string name ="Ram_write_seq");
        super.new();
    endfunction
    
    virtual task body();
        seq_item=Ram_seq_item::type_id::create("seq_item");
        repeat(1000) begin
            seq_item.write_only_seq_constrains.constraint_mode(1);
            seq_item.read_only_seq_constrains.constraint_mode(0);
            seq_item.read_write_constrains.constraint_mode(0);
            start_item(seq_item); 
            assert(seq_item.randomize());    
            finish_item(seq_item);           
        end
    endtask
    endclass
endpackage