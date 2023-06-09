`timescale 1 ps / 1 ps
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module LAB8(

	//////////// CLOCK //////////
	
	input 		    wire      		clk_100hz, //LPM_Counter input
	

	//////////// SEG7 //////////
	output		reg     [6:0]		HEX0,
	output		reg     [6:0]		HEX1,
	output		reg     [6:0]		HEX2,
	output		reg     [6:0]		HEX3,


	//////////// KEY //////////
	input Resetn, //KEY 1
	input data_ready, //KEY 0

	//////////// LED //////////
	output		     [8:0]		LEDR,
	output		reg		data_request, //LEDR9

	//////////// SW //////////
	input 	  [7:0] SW, //8-bit should total 255 when all on
	input				  funct, //Add=1 Sub=0 : SW9
	output reg [3:0] ones,
	output reg [3:0] tens,
	output reg [3:0] hundreds,
	output reg [7:0] fsw,
	output reg [7:0] reg_a,
	output reg [7:0] reg_b,
	output reg [7:0] reg_c
	
	
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
	
	reg enable_a;
	reg enable_b;
	reg enable_c;
	integer i;
	parameter SIZE = 3;
	parameter [2:0] IDLE_STATE  = 3'd0,A_STATE = 3'd1,B_STATE = 3'd2, C_STATE = 3'd3;
	reg  [1:0]  state;
//=======================================================
//  Structural coding
//=======================================================
	assign LEDR[8:0] = 1'b0;
	
	always @(posedge clk_100hz)
	
	begin : FSM
		
		
	
	if (Resetn==1'b0)begin 
				hundreds = 4'd0;
				tens = 4'd0;
				ones = 4'd0;	
				data_request = 1'b0;
				enable_a = 1'b1;
				reg_a <= 8'b00000000;
				reg_b <= 8'b00000000;
				reg_c <= 8'b00000000;
				state  <= #1 IDLE_STATE; 
				
		end else case(state)
			  IDLE_STATE : if (enable_a == 1'b1 && data_request == 1'b0 && data_ready == 1'b1) begin
											
											data_request = 1'b1;
											state <=  #1  A_STATE;
											
									end else if (enable_b == 1'b1 && data_request == 1'b0 && data_ready == 1'b1) begin
											data_request = 1'b1;
											state <=  #1  B_STATE;
									end else if (enable_c == 1'b1 && data_request == 1'b0 && data_ready == 1'b1) begin
											data_request = 1'b1;
											state <=  #1  C_STATE;
									end else begin
											state <=  #1  IDLE_STATE;
									end
			  A_STATE : if (enable_a == 1'b1 && data_request == 1'b1) begin
											if (data_ready == 1'b0) begin
											data_request = 1'b0;
											reg_a <= SW;
											enable_b = 1'b1;
											enable_a = 1'b0;				
											state <=  #1  A_STATE;
											end
									end else begin
											
											state <=  #1  IDLE_STATE;
									end
			  B_STATE : if (data_request == 1'b1 && enable_b == 1'b1) begin
											if (data_ready == 1'b0) begin
											data_request = 1'b0;
											reg_b <= SW;
											enable_c = enable_b;
											enable_b = 1'b0;
											state <=  #1  B_STATE;
											end
									end else begin
											
											state <=  #1  IDLE_STATE;
									end
				C_STATE : if (funct == 1'b1 && enable_c == 1'b1) begin
											reg_c<=reg_a + reg_b;
											enable_c = 1'b0;
											state <=  #1  C_STATE;
							 end else if (funct == 1'b0) begin
											reg_c<=reg_a - reg_b;
											enable_c = 1'b0;
											state <=  #1  C_STATE;
							 
									end else begin
								
											state <=  #1  IDLE_STATE;
									end
							default : state <=  #1  IDLE_STATE;
				endcase
   
			
		
		hundreds = 4'd0;
		tens = 4'd0;
		ones = 4'd0;
		if (reg_c[7] == 1'b1)begin
				//HEX3 = 7'b0111111;
				fsw <= reg_c;
				
				for (i=7; i>=0; i=i-1)
				begin
				if (hundreds >=5)
					hundreds = hundreds+3;
				if (tens >=5)
					tens = tens+3;
				if (ones >=5)
					ones = ones+3;
					
				hundreds = hundreds << 1;
				hundreds[0] = tens[3];
				tens = tens << 1;
				tens[0] = ones[3];
				ones = ones << 1;
				ones [0] = fsw[i];
				end
				//if (SW == 8'b10000000)begin
					//HEX3 = 7'b0011100;
				//end
		end else if (reg_c[7] == 1'b0)begin
				HEX3 = 7'b1111111;
			for (i=6; i>=0; i=i-1)
			begin
			if (hundreds >=5)
				hundreds = hundreds+3;
			if (tens >=5)
				tens = tens+3;
			if (ones >=5)
				ones = ones+3;
				
			hundreds = hundreds << 1;
			hundreds[0] = tens[3];
			tens = tens << 1;
			tens[0] = ones[3];
			ones = ones << 1;
			ones [0] = reg_c[i];
			
			
			end
			
		end
			
		
			case({ones})
	
				4'b0000: HEX0 = 7'b1000000;//0
				4'b0001:	HEX0 = 7'b1111001;//1
				4'b0010:	HEX0 = 7'b0100100;//2
				4'b0011:	HEX0 = 7'b0110000;//3
				4'b0100: HEX0 = 7'b0011001;//4		
				4'b0101: HEX0 = 7'b0010010;//5		
				4'b0110: HEX0 = 7'b0000010;//6
				4'b0111: HEX0 = 7'b1111000;//7
				4'b1000: HEX0 = 7'b0000000;//8
				4'b1001: HEX0 = 7'b0010000;//9
				
				
				
			endcase
	
			case({tens})
	
				4'b0000: HEX1 = 7'b1000000;//0
				4'b0001:	HEX1 = 7'b1111001;//1
				4'b0010:	HEX1 = 7'b0100100;//2
				4'b0011:	HEX1 = 7'b0110000;//3
				4'b0100: HEX1 = 7'b0011001;//4		
				4'b0101: HEX1 = 7'b0010010;//5		
				4'b0110: HEX1 = 7'b0000010;//6
				4'b0111: HEX1 = 7'b1111000;//7
				4'b1000: HEX1 = 7'b0000000;//8
				4'b1001: HEX1 = 7'b0010000;//9
				
				
			endcase
			
			case({hundreds})
	
				4'b0000: HEX2 = 7'b1000000;//0
				4'b0001:	HEX2 = 7'b1111001;//1
				4'b0010:	HEX2 = 7'b0100100;//2
				4'b0011:	HEX2 = 7'b0110000;//3
				4'b0100: HEX2 = 7'b0011001;//4		
				4'b0101: HEX2 = 7'b0010010;//5		
				4'b0110: HEX2 = 7'b0000010;//6
				4'b0111: HEX2 = 7'b1111000;//7
				4'b1000: HEX2 = 7'b0000000;//8
				4'b1001: HEX2 = 7'b0010000;//9
				
				
			endcase
			
		end
	
	

endmodule
