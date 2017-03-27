`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:41 06/29/2013 
// Design Name: 
// Module Name:    sound 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sound(clk100,clk,hit,fault,lose,squareWave);
input clk100,clk,hit,fault,lose;
output squareWave;
reg [1:0] play;
reg [6:0]notelength;
reg [4:0]note;

doRaMi U(note,clk,squareWave);
initial
	begin
	play<=0;
	notelength<=0;
	note<=0;
	end 
always @(posedge clk100)
begin
	if(hit)
	begin
		notelength<=0;
		play<=1;
	end
	if(fault)
	begin
		notelength<=0;
		play<=2;
	end
	if(lose)
	begin
		notelength<=0;
		play<=3;
	end
	if(play==1)
	begin
		if(notelength<9) note<=18;
//		else if(notelength<9) note<=19;
		else if(notelength<49) note<=19;
		else
		begin
			note<=0;
			play<=0;
		end
		notelength<=notelength+1;
	end
	if(play==2)
	begin
		if(notelength<19) note<=1;
		else
		begin
			note<=0;
			play<=0;
		end
		notelength<=notelength+1;
	end
	if(play==3)
	begin
		if(notelength<15) note<=12;
		else if(notelength==15) note<=0;
		else if(notelength<31) note<=17;
		else if(notelength<47) note<=0;
		else if(notelength<63) note<=17;
		else if(notelength==63) note<=0;
		else if(notelength<79) note<=17;
		else if(notelength==79) note<=0;
		else if(notelength<95) note<=16;
		else if(notelength==95) note<=0;
		else if(notelength<111) note<=15;
		else if(notelength==111) note<=0;
		else if(notelength<127) note<=13;
		else
		begin
			note<=0;
			play<=0;
		end
		notelength<=notelength+1;
	end
end
endmodule
