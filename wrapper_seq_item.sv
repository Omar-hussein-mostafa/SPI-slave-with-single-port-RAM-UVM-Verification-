///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Object : Wrapper Sequence Item
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package wrapper_seq_item;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(wrapper_seq_item)

    //Constructor function
    function new(string name="wrapper_seq_item");
        super.new(name);
    endfunction
    
    //Type define 
    typedef enum  {IDLE,CHK_CMD,WRITE,READ_ADD_F,READ_DATA_F} my_FSM;
    typedef enum  {WRITE_ADD,WRITE_DATA,READ_ADD,READ_DATA} operations;

    //inputs rand signals 
    rand logic     [9:0] din;
    rand logic  MOSI, rst_n, SS_n;
    //output signals 
    logic MISO,MISO_exp;
    //Internal signals and sequence item counters
    rand logic [10:0] valid_comb;
    logic [10:0] old_valid_comb;
    int MOSI_count,i,read_add_data;
    my_FSM  old_cs;
    rand my_FSM  cs;
    operations  old_op;

    constraint rst_constrains {rst_n dist{1:/95 , 0:/5};}
    constraint SS_n_constrains { 
        if (old_cs != READ_DATA_F ) {
          (MOSI_count == 13) -> SS_n == 1;
          (MOSI_count != 13) -> SS_n == 0;
        } 
        else if(old_cs==READ_DATA_F) {
          (MOSI_count == 23) -> SS_n == 1;
          (MOSI_count != 23) -> SS_n == 0;
        }
    }

    //Creating a FSM Enviroment inside the Sequence item
    constraint cs_constrains{if(!rst_n || SS_n) {cs==IDLE;}   
                            else if(old_cs==IDLE && !SS_n) {cs==CHK_CMD;}
                            else if(old_cs==CHK_CMD && !SS_n && !MOSI) {cs==WRITE;}
                            else if(old_cs==CHK_CMD && !SS_n && MOSI && read_add_data==0) {cs==READ_ADD_F;}
                            else if(old_cs==CHK_CMD && !SS_n && MOSI && read_add_data==1) {cs==READ_DATA_F;}
                            else if((old_cs==WRITE || old_cs==READ_ADD_F) && MOSI_count==13 ) {cs==IDLE;}
                            else if((old_cs==WRITE) && MOSI_count!=13 ) {cs==WRITE;}
                            else if((old_cs==READ_ADD_F) && MOSI_count!=13 ) {cs==READ_ADD_F;}
                            else if((old_cs==READ_DATA_F) && MOSI_count==23 ) {cs==IDLE;}
                            else if((old_cs==READ_DATA_F) && MOSI_count!=23 ) {cs==READ_DATA_F;}
    }
    //Randomizing a 11 bit bus forcing it to start with 3 valid bits, each Randomization will be at the start of each sequence
    constraint valid_comb_constrains{
        if(!rst_n || MOSI_count==0) valid_comb[10:8] inside{3'b000,3'b001,3'b110,3'b111};
        else valid_comb==old_valid_comb;}

    //Constraining the MOSI bits to take the valid Combination of bits 
    constraint MOSI_constrains {if(!SS_n && rst_n ) MOSI == valid_comb[10-i] ;}
    
    //Write only sequence forcing the operations to Write address or data only
    constraint write_only_seq_constrains{
        if(!rst_n) (valid_comb[9:8]) inside {WRITE_ADD,WRITE_DATA};
        else if(old_op==WRITE_ADD && MOSI_count==0) (valid_comb[9:8]) inside {WRITE_ADD,WRITE_DATA};
        else if (old_op==WRITE_DATA && MOSI_count==0) (valid_comb[9:8]) inside {WRITE_ADD};}    //Only Read address allowes
    
    //Read only sequence forcing the operations to read address or data only 
    constraint read_only_seq_constrains {
        if(!rst_n) (valid_comb[9:8]) inside {READ_DATA};    //To Force the design when MOSI_count==0 to go to Read_ADDR 
        else if(old_op==READ_ADD  && MOSI_count==0 ) operations'( valid_comb[9:8]) inside {READ_DATA};  //Only Read Data allowed
        else if(old_op==READ_DATA  && MOSI_count==0) operations'( valid_comb[9:8]) inside {READ_ADD};}  //Only Read Data allowed
    constraint read_write_constrains {
        if(!rst_n) valid_comb[9:8] inside {READ_DATA};      //To Force the design when MOSI_count==0 to go to Read_ADDR
        else if(old_op==WRITE_ADD  && MOSI_count==0) operations'(valid_comb[9:8]) inside {WRITE_ADD,WRITE_DATA};
        else if(old_op==WRITE_DATA && MOSI_count==0) operations'(valid_comb[9:8]) dist   {READ_ADD:/60 , WRITE_ADD:/40};
        else if(old_op==READ_ADD   && MOSI_count==0) operations'(valid_comb[9:8]) inside {READ_DATA}; //Only Read Data allowed 
        else if(old_op==READ_DATA  && MOSI_count==0) operations'(valid_comb[9:8]) dist   {WRITE_ADD:/60 , READ_ADD:/40};
    }

    function void post_randomize();
        old_valid_comb=valid_comb;
        old_op =operations'(valid_comb[9:8]);
        if(!rst_n) begin
            old_cs=IDLE;
            MOSI_count=0;
            i=0;
            read_add_data=0;
        end
        else begin
            old_cs=cs;
            if(cs==READ_ADD_F) read_add_data=1;
            else if(cs==READ_DATA_F) read_add_data=0;
            if(cs!=READ_DATA_F) begin
                if(MOSI_count>=13) begin
                    MOSI_count=0;
                end
                else begin
                    MOSI_count++;
                end
            end
            else if(cs==READ_DATA_F)begin
                if(MOSI_count>=23) begin
                    MOSI_count=0;
                end
                else begin
                    MOSI_count++;
                end
            end
            i++;
            if(i==11 || MOSI_count==1) i=0;
        end
    endfunction
    
    function string convert2string_stimulus();
        return $sformatf("rst=%0d,SS_n=%0d,MOSI=%0d",rst_n,SS_n,MOSI);
    endfunction
    function string convert2string();
        return $sformatf("rst=%0d,SS_n=%0d,MOSI=%0d,MISO=%0d,MISO_exp=%0d",rst_n,SS_n,MOSI,MISO,MISO_exp);
    endfunction
    endclass
endpackage