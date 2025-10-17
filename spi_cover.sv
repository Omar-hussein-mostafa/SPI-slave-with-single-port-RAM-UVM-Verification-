///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Cover
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_cover_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_seq_item::*;
    import shared_pkg::*;

    class spi_cover extends uvm_component;
        `uvm_component_utils(spi_cover)
        uvm_analysis_export #(spi_seq_item) cover_ap;
        uvm_tlm_analysis_fifo #(spi_seq_item) cover_fifo;
        spi_seq_item seq_item;

        
    //Cover Groups
        covergroup Cov_gp(ref spi_seq_item seq_item);
        //Normal Coverpoints
        rx_cp: coverpoint seq_item.rx_data[9:8]{
            bins all_values[] = {[0:3]};
            bins WRITE_ADD =(2'b00=>2'b00=>2'b00) ;
            bins WRITE_DATA=(2'b00=>2'b00=>2'b01) ;
            bins READ_ADD  =(2'b00=>2'b10=>2'b10) ;
            bins READ_DATA =(2'b00=>2'b10=>2'b11) ;
        }
        SS_n_cp: coverpoint seq_item.SS_n{
            bins read_data_transition=(1=> 0[*23] =>1);
            bins not_read_data_transition=(1=> 0[*13] =>1);
        }
        MOSI_cp:coverpoint seq_item.MOSI{
            bins b000=(0=>0=>0);
            bins b001=(0=>0=>1);
            bins b111=(1=>1=>1);
            bins b110=(1=>1=>0);
        }
        cross_cv:cross MOSI_cp,SS_n_cp{
            ignore_bins write_cv_000 =binsof(MOSI_cp.b000) && binsof(SS_n_cp.read_data_transition);
            ignore_bins write_cv_001 =binsof(MOSI_cp.b001) && binsof(SS_n_cp.read_data_transition);
            ignore_bins read_cv_111 =binsof(MOSI_cp.b111) && binsof(SS_n_cp.not_read_data_transition);
            ignore_bins read_cv_110 =binsof(MOSI_cp.b110) && binsof(SS_n_cp.read_data_transition);
        }
        //Cross coverage 
        endgroup

        function new(string name="spi_cover",uvm_component parent=null);
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
                seq_item=spi_seq_item::type_id::create("seq_item");
                cover_fifo.get(seq_item);
                Cov_gp.sample();    
            end            
        endtask

    endclass
endpackage