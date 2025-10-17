///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Sequence Item
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class Ram_seq_item extends uvm_sequence_item;
    `uvm_object_utils(Ram_seq_item)
    //Constructor function
    function new(string name="Ram_seq_item");
        super.new(name);
    endfunction

    typedef enum  {WRITE_ADD,WRITE_DATA,READ_ADD,READ_DATA} operations;

    //Interface signals
    operations  old_op; 
    rand logic     [9:0] din;
    rand logic           rst_n, rx_valid;
    logic  [7:0] dout,dout_exp;
    logic        tx_valid,tx_valid_exp;
    //rand type signal;

    constraint rst_constrains {rst_n dist{1:/90 , 0:/5};}
    constraint rx_valid_constrains {rx_valid dist{1:/85 , 0:/15};}
    constraint write_only_seq_constrains{
        if(!rst_n) operations'(din[9:8]) inside {WRITE_ADD,WRITE_DATA};
        else if(old_op==WRITE_ADD) operations'(din[9:8]) inside {WRITE_ADD,WRITE_DATA};
        else if (old_op==WRITE_DATA) operations'(din[9:8]) inside {WRITE_ADD};}
    constraint read_only_seq_constrains {
        if(!rst_n) operations'(din[9:8]) inside {READ_ADD,READ_DATA};
        else if(old_op==READ_ADD ) operations'(din[9:8]) inside {READ_ADD, READ_DATA};
        else if (old_op==READ_DATA) operations'(din[9:8]) inside {READ_ADD};}
    constraint read_write_constrains {
        if(old_op==WRITE_ADD ) operations'(din[9:8]) inside {WRITE_ADD,WRITE_DATA};
        if(old_op==WRITE_DATA) operations'(din[9:8]) dist   {READ_ADD:/60 , WRITE_ADD:/40};
        if(old_op==READ_ADD  ) operations'(din[9:8]) inside {READ_ADD,READ_DATA};
        if(old_op==READ_DATA ) operations'(din[9:8]) dist   {WRITE_ADD:/60 , READ_ADD:/40};
    }

    function void post_randomize();
        // if(!rst_n) old_op=READ_DATA;
        old_op =operations'(din[9:8]);
    endfunction
    //Constrain Blocks 
    
    function string convert2string_stimulus();
        return $sformatf("Error in the Ram : reset=%0d,din=%0d,rx_valid=%0d",rst_n,din,rx_valid);
    endfunction
    function string convert2string();
        return $sformatf("Error in the Ram : reset=%0d,din=%0d,rx_valid=%0d,dout=%0d,tx_valid=%0d,dout_exp=%0d,tx_valid_exp=%0d"
        ,rst_n,din,rx_valid,dout,tx_valid,dout_exp,tx_valid_exp);
    endfunction
    endclass
endpackage