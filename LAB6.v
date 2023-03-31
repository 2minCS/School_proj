
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module LAB6(

	//////////// SEG7 //////////
	output		reg     [6:0]		HEX0,
	output		reg     [6:0]		HEX1,
	output		reg     [6:0]		HEX2,
	output		reg     [6:0]		HEX3,

	//////////// KEY //////////
	input async_reset, //KEY 1
	input keyclk, //KEY 0


	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [7:0]		SW,
	
	output reg [3:0] ones,
	output reg [3:0] tens,
	output reg [3:0] hundreds,
	output reg [7:0] fsw
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
	 
	
	integer i;
//=======================================================
//  Structural coding
//=======================================================

	assign LEDR[9:0] = 1'b0;
	always @(SW)
	begin
	if(async_reset==1'b1 && keyclk==1'b0) begin
	
		hundreds = 4'd0;
		tens = 4'd0;
		ones = 4'd0;
		if (SW[7] == 1'b1)begin
				HEX3 = 7'b0111111;
				fsw <= -SW;
				
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
				if (SW == 8'b10000000)begin
					HEX3 = 7'b0011100;
				end
		end else if (SW[7] == 1'b0)begin
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
			ones [0] = SW[i];
			
			
			end
			
		end
			
		end else if (async_reset==1'b0 && keyclk==1'b1)begin 
				hundreds = 4'd0;
				tens = 4'd0;
				ones = 4'd0;	
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
				
				
				
			endcase
			
		//posedge keyclk or posedge async_reset
	
	end

endmodule
