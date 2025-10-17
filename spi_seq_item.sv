///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Sequence Item
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_seq_item;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;

    class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item)
    //Constructor function
    function new(string name="spi_seq_item");
        super.new(name);
    endfunction
    
    typedef enum  {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} my_FSM;
    //Interface signals
    //Inputs
    rand logic  MOSI, rst_n, SS_n;
    rand logic  [7:0] tx_data;
    rand logic tx_valid;
    rand logic [10:0] valid_comb;
    //Outputs 
    logic rx_valid,rx_valid_exp;
    logic [9:0] rx_data,rx_data_exp;
    logic MISO,MISO_exp;
    //Internal signals and sequence item counters
    logic [10:0] old_valid_comb;
    int MOSI_count,i,read_add_data;
    my_FSM  old_cs;
    rand my_FSM  cs;
    //Constrain Blocks 
    constraint reset_constrains{rst_n dist{1:/95 , 0:/5};}
    constraint SS_n_constrains { 
        if (old_cs != READ_DATA ) {
          (MOSI_count == 13) -> SS_n == 1;
          (MOSI_count != 13) -> SS_n == 0;
        } 
        else if(old_cs==READ_DATA) {
          (MOSI_count == 23) -> SS_n == 1;
          (MOSI_count != 23) -> SS_n == 0;
        }
    }
    constraint cs_constrains{if(!rst_n || SS_n) {cs==IDLE;}   
                            else if(old_cs==IDLE && !SS_n) {cs==CHK_CMD;}
                            else if(old_cs==CHK_CMD && !SS_n && !MOSI) {cs==WRITE;}
                            else if(old_cs==CHK_CMD && !SS_n && MOSI && read_add_data==0) {cs==READ_ADD;}
                            else if(old_cs==CHK_CMD && !SS_n && MOSI && read_add_data==1) {cs==READ_DATA;}
                            else if((old_cs==WRITE || old_cs==READ_ADD) && MOSI_count==13 ) {cs==IDLE;}
                            else if((old_cs==WRITE) && MOSI_count!=13 ) {cs==WRITE;}
                            else if((old_cs==READ_ADD) && MOSI_count!=13 ) {cs==READ_ADD;}
                            else if((old_cs==READ_DATA) && MOSI_count==23 ) {cs==IDLE;}
                            else if((old_cs==READ_DATA) && MOSI_count!=23 ) {cs==READ_DATA;}
    }
    constraint valid_comb_constrains{
        if(!rst_n || MOSI_count==0) valid_comb[10:8] inside{3'b000,3'b001,3'b110,3'b111};
        else valid_comb==old_valid_comb;}
    constraint MOSI_constrains {if(!SS_n && rst_n) MOSI==valid_comb[10-i] ;}
    constraint tx_valid_constrains{if(MOSI_count>=14 && MOSI_count<=22) {tx_valid==1;} else{tx_valid==0;}}

    function void post_randomize();
        old_valid_comb=valid_comb;
        if(!rst_n) begin
            old_cs=IDLE;
            MOSI_count=0;
            i=0;
            read_add_data=0;
        end
        else begin
            old_cs=cs;
            if(cs==READ_ADD) read_add_data=1;
            else if(cs==READ_DATA) read_add_data=0;

            if(cs!=READ_DATA) begin
                if(MOSI_count>=13) begin
                    MOSI_count=0;
                end
                else begin
                    MOSI_count++;
                end
            end
            else begin
                if(MOSI_count>=23) begin
                    MOSI_count=0;
                end
                else begin
                    MOSI_count++;
                end
            end
            i++;
            if(i==11 || MOSI_count==1) i=0; //to start sampling the valid_comb at the CHM_CMD state always
        end
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst=%0d,SS_n=%0d,MOSI=%0d,tx_valid=%0d,tx_data=%0h",rst_n,SS_n,MOSI,tx_valid,tx_data);
    endfunction
    function string convert2string();
        return $sformatf("rst=%0d,SS_n=%0d,MOSI=%0d,tx_valid=%0d,tx_data=%0h,MISO=%0d,MISO_exp=%0d,rx_valid=%0d
        rx_valid_exp=%0d,rx_data=%0d,rx_data_exp=%0d",rst_n,SS_n,MOSI,tx_valid,tx_data,MISO,MISO_exp,rx_valid,rx_valid_exp
        ,rx_data,rx_data_exp);
    endfunction
    endclass
endpackage