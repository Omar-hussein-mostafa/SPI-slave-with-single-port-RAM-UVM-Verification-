package wrapper_read_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item::*;

    class wrapper_read_write_seq extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_read_write_seq)

    wrapper_seq_item seq_item;

    function new(string name ="wrapper_read_write_seq");
        super.new();
    endfunction
    
    virtual task body();
        seq_item=wrapper_seq_item::type_id::create("seq_item");
        seq_item.write_only_seq_constrains.constraint_mode(0);
        seq_item.read_only_seq_constrains.constraint_mode(0);
        seq_item.read_write_constrains.constraint_mode(1);
        repeat(3000) begin
            start_item(seq_item);
            assert(seq_item.randomize());    
            finish_item(seq_item);           
        end
    endtask
    endclass
endpackage