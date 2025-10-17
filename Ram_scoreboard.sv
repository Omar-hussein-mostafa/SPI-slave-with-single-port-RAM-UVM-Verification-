////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name: Omar Mohamed Hussein
//UVM_Component: Agent 
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

package Ram_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_scoreboard extends uvm_scoreboard ;
        `uvm_component_utils(Ram_scoreboard)

        //Creating sequence item to get the data from fifo
        Ram_seq_item seq_item;
        //Creating analysis export to take values from the fifo 
        uvm_analysis_export #(Ram_seq_item) sb_export;
        //Creating analysis fifo to take values from the agt port
        uvm_tlm_analysis_fifo #(Ram_seq_item) sb_fifo;

        int correct_count,error_count;

        //Constructor
        function new(string name="Ram_scoreboard",uvm_component parent =null);
            super.new(name,parent);
        endfunction

        //Build phase : create the export analysis
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export=new("sb_export",this);
            sb_fifo=new("sb_fifo",this);
        endfunction

        //Connect phase : connect the eb export with the fifo export 
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        //run Task : Compare the output with the Golden model
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if(seq_item.dout!=seq_item.dout_exp || seq_item.tx_valid!=seq_item.tx_valid_exp) begin
                    `uvm_error("scoreboard run phase",$sformatf("Design doesn't match the Golden model => %s",seq_item.convert2string))
                    error_count++;
                end
                else begin
                    correct_count++;
                end
            end
        endtask

        //Report Phase: report the testbench with how many failed and correct trials
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("Scoreboard Report Phase",$sformatf("Testbench Completed , Correct count=%0d, error count=%0d",correct_count,error_count),UVM_LOW)
        endfunction
    endclass
endpackage