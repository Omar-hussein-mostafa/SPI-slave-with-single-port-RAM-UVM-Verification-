module SPI_slave_op(MOSI,MISO,clk,rstn,rx_data,tx_data,rx_valid,tx_valid,SS_n);

//our state encoding;
localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;


//SPI slave ports
input MOSI,clk,rstn,tx_valid,SS_n;
input [7:0]tx_data;
output reg MISO,rx_valid;
output reg [9:0]rx_data;

(*fsm_encoding="sequential"*)
reg [2:0]ns,cs;                 //next and current state

//internal signals 
wire [3:0]count;
wire [3:0]count_10;
reg flag,Read_add_data_inx,counter_enable,counter_8_enable;

//counters 
down_counter #(11,4) down_counter_10(clk,rstn && cs!=CHK_CMD ,counter_enable,count_10); //counter counts from 10 to 0 ,11 states
down_counter #(10,4)tx_to_MISO(clk,rstn&& (cs!=CHK_CMD),counter_8_enable,count);        //counter counts from 9 to 0, 10 states

//next state logic
always @(*) begin
    case (cs)
        IDLE:begin
            if(SS_n) ns=IDLE;
            else begin
                ns=CHK_CMD;
            end
        end
        CHK_CMD:begin
            if(SS_n) ns=IDLE;
            else begin
                if(MOSI) begin
                    if(!Read_add_data_inx) begin//read addr
                        ns=READ_ADD;
                    end
                    else if (Read_add_data_inx) begin
                        ns=READ_DATA;
                    end
                end
                else begin
                    ns=WRITE;
                end
            end
        end
        WRITE:begin
            if(SS_n) ns=IDLE;
            else begin
                ns=WRITE;
            end
        end
        READ_ADD:begin
            if(SS_n) ns=IDLE;
            else begin
                ns=READ_ADD;
            end 
        end
        READ_DATA: begin
            if(SS_n) ns=IDLE;
            else begin
                ns=READ_DATA;
            end
        end
    endcase
end

//memory logic
always @(posedge clk) begin
    if (!rstn) begin
        cs<=3'b000;
    end
    else begin
        cs<=ns;
    end
end

//output logic 
always @(posedge clk) begin
    if(!rstn) begin
        rx_data<=8'b0;
        rx_valid<=0;
        MISO<=0;
        Read_add_data_inx<=0;
        flag<=0;
        counter_enable<=0;
        counter_8_enable<=0;
    end
    else begin
        case(cs)
            WRITE: begin
                if(count_10>4'b0) begin
                    rx_data[count_10-1]<=MOSI;
                    MISO<=0;
                    if(count_10==1) counter_enable<=0;
                end
                else if (count_10==4'b0) begin
                   rx_valid<=1; 
                end
            end
            READ_ADD: begin
                if(count_10>4'b0) begin
                    rx_data[count_10-1]<=MOSI;
                    MISO<=0;
                    if(count_10==1) counter_enable<=0;
                end
                else if (count_10==4'b0) begin
                   rx_valid<=1;
                    Read_add_data_inx<=1;
                end
            end
            READ_DATA: begin
                if(!tx_valid) begin
                    MISO<=0;
                    if(count_10>4'b0) begin
                        if(flag) begin
                            rx_data[count_10-2]<=MOSI; 
                            MISO<=0;
                        end
                        else begin
                            rx_data[count_10-1]<=MOSI; 
                            MISO<=0;
                        end
                    end
                    else if (count_10==4'b0) begin
                       rx_valid<=1; 
                       flag<=1;
                       counter_8_enable<=1;
                    end
                end
                else begin 
                    rx_valid<=0;
                    if(count>0) begin
                        MISO<=tx_data[count-1]; // getting the data out of the SPI through the MISO
                        if(count==1) counter_8_enable<=0;
                    end
                    else begin
                        Read_add_data_inx<=0;
                        flag<=0;
                        MISO<=0;
                    end
                end
            end
            CHK_CMD :begin
                rx_valid<=0;
                flag<=0;
                counter_8_enable<=0;
            end
            IDLE: begin
                rx_valid<=0; // reset all values to start communication again
                MISO<=0; 
                rx_data<=0;
                counter_enable<=1;
            end
            default :begin
                rx_valid<=0;
                MISO<=0;
            end
        endcase
    end
end
endmodule
