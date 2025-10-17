///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Cover Collector
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_cover_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_cover extends uvm_component;
        `uvm_component_utils(Ram_cover)
        uvm_analysis_export #(Ram_seq_item) cover_ap;
        uvm_tlm_analysis_fifo #(Ram_seq_item) cover_fifo;
        Ram_seq_item seq_item;

        
    //Cover Groups
        covergroup Cov_gp(ref Ram_seq_item seq_item);
        //Normal Coverpoints
        operations_cp: coverpoint seq_item.din[9:8] {
            bins all_vals[]={[0:3]};
            bins Write_address_data=(2'b00=>2'b01);
            bins Read_address_data =(2'b10=>2'b11);
            bins all_operations =(2'b00=>2'b01=>2'b10=>2'b11);
        }
        rx_valid_cp:coverpoint seq_item.rx_valid{
            bins high={1};
            bins low={0};
        }
        //Cross coverage 
        rx_valid_ops:cross operations_cp,rx_valid_cp {
            bins allvals_rx_valid = binsof(operations_cp.all_vals) && binsof(rx_valid_cp.high);
            bins read_data_tx_valid = binsof(operations_cp.all_vals) intersect {2'b11} && binsof(rx_valid_cp.high); 
        } 
        endgroup
        function new(string name="Ram_cover",uvm_component parent=null);
            super.new(name,parent);
            Cov_gp=new(seq_item);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cover_ap=new("cover_ap",this);
            cover_fifo=new("cover_fifo",this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cover_ap.connect(cover_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item=Ram_seq_item::type_id::create("seq_item");
                cover_fifo.get(seq_item);
                Cov_gp.sample();    
            end            
        endtask

    endclass
endpackage