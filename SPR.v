module SPR#(parameter MEM_DEPTH=256,parameter ADDR_SIZE=8)(din,clk,rstn,rx_valid,tx_valid,dout);

input [9:0]din;
input clk,rstn,rx_valid;
output reg tx_valid;
output reg [7:0]dout;

reg [7:0] MEM[255:0];

reg [7:0]Wr_addr,Rd_addr; //internal address signal

always @(posedge clk) begin
    if(!rstn) begin
        dout<=8'b0;
        Wr_addr<=8'b0;
        Rd_addr<=8'b0;
        tx_valid<=0;
    end
    else begin
        if(rx_valid) begin
            case({din[9:8]})
                2'b00: begin
                    Wr_addr<=din[7:0];
                    tx_valid<=0;
                end
                2'b01: begin
                    MEM[Wr_addr]<=din[7:0];
                    tx_valid<=0; 
                end
                2'b10: begin
                    Rd_addr<=din[7:0];
                    tx_valid<=0;
                end
                2'b11: begin
                    dout<=MEM[Rd_addr];
                    tx_valid<=1;
                end
            endcase
        end 
    end
end
endmodule
