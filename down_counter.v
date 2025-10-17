module down_counter#(parameter MOD=8,parameter COUNTER_BITS=3)(clk,rstn,enable,count);

input clk,rstn,enable;
output reg [COUNTER_BITS-1:0] count;

always @(posedge clk ) begin
    if(~rstn) begin
        count<=MOD-1;
    end
    else if(enable) begin
        if(count==0)begin
            count<=MOD-1;
        end
        if(count>0) begin
           count<=count-1; 
        end
    end
end
endmodule