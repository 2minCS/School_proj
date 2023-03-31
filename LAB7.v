module LAB7 (
input wire clock      , // clock
input wire reset      , // Active high, syn reset
input wire req_0      , // Request 0
input wire req_1      , // Request 1
output reg gnt_0      , // Grant 0
output reg gnt_1      
);

  //wire    clock,reset,req_0,req_1;
  //=============Internal Constants======================
 parameter SIZE = 3           ;
 parameter IDLE  = 3'b001,GNT0 = 3'b010,GNT1 = 3'b100 ;
  //=============Internal Variables======================
  reg   [SIZE-1:0]          state        ;// Seq part of the FSM
  reg   [SIZE-1:0]          next_state   ;// combo part of FSM
  //==========Code startes Here==========================
always @ (posedge clock)
 begin : FSM
  if (reset == 1'b1) begin
    state <=  #1  IDLE;
    gnt_0 <= 0;
    gnt_1 <= 0;
  end else
   case(state)
     IDLE : if (req_0 == 1'b1) begin
                  state <=  #1  GNT0;
                  gnt_0 <= 1;
                end else if (req_1 == 1'b1) begin
                  gnt_1 <= 1;
                  state <=  #1  GNT1;
                end else begin
                 state <=  #1  IDLE;
                end
     GNT0 : if (req_0 == 1'b1) begin
                  state <=  #1  GNT0;
                end else begin
                  gnt_0 <= 0;
                  state <=  #1  IDLE;
                end
     GNT1 : if (req_1 == 1'b1) begin
                  state <=  #1  GNT1;
                end else begin
                  gnt_1 <= 0;
                  state <=  #1  IDLE;
                end
     default : state <=  #1  IDLE;
  endcase
  end
  
  endmodule