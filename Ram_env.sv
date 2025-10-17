///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Cover Collector
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package Ram_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Ram_driver_pkg::*;
import Ram_scoreboard_pkg::*;
import Ram_agent_pkg::*;
import Ram_cover_pkg::*;
    class Ram_env extends uvm_env;
        `uvm_component_utils(Ram_env)
        Ram_scoreboard sb;
        Ram_agent agt;
        Ram_cover cv;

        function new(string name="Ram_env",uvm_component parent=null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb=Ram_scoreboard::type_id::create("sb",this);
            agt=Ram_agent::type_id::create("agt",this);
            cv=Ram_cover::type_id::create("cv",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cv.cover_ap);
        endfunction
    endclass
endpackage