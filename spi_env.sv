///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name: Omar Mohamed Hussein
// UVM_Component : Environment
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package spi_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_driver_pkg::*;
import spi_scoreboard_pkg::*;
import spi_agent_pkg::*;
import shared_pkg::*;
import spi_cover_pkg::*;
    class spi_env extends uvm_env;
        `uvm_component_utils(spi_env)
        spi_scoreboard sb;
        spi_agent agt;
        spi_cover cv;

        function new(string name="spi_env",uvm_component parent=null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb=spi_scoreboard::type_id::create("sb",this);
            agt=spi_agent::type_id::create("agt",this);
            cv=spi_cover::type_id::create("spi_cover",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cv.cover_ap);
        endfunction
    endclass
endpackage