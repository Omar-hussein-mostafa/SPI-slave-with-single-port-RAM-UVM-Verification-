package wrapper_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_driver_pkg::*;
import wrapper_scoreboard_pkg::*;
import wrapper_agent_pkg::*;
import shared_pkg::*;
//import wrapper_cover_pkg::*;
    class wrapper_env extends uvm_env;
        `uvm_component_utils(wrapper_env)
        wrapper_scoreboard sb;
        wrapper_agent agt;
        // wrapper_cover cv;

        function new(string name="wrapper_env",uvm_component parent=null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb=wrapper_scoreboard::type_id::create("sb",this);
            agt=wrapper_agent::type_id::create("agt",this);
            //cv=wrapper_cover::type_id::create("wrapper_cover",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            //agt.agt_ap.connect(cv.cover_ap);
        endfunction
    endclass
endpackage