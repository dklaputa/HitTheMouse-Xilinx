`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:55 06/29/2013 
// Design Name: 
// Module Name:    doRaMi 
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
module doRaMi(note,clk,wave);
input [4:0] note;
input clk;
output reg wave;
reg [15:0]count;
always @(posedge clk)
begin
	case (note)
		0:wave<=0;
		1://1
		begin
			if(count>=47800)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		2://1.5
		begin
			if(count>=45125)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		3://2
		begin
			if(count>=42588)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		4://2.5
		begin
			if(count>=40191)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		5://3
		begin
			if(count>=37935)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		6://4
		begin
			if(count>=35815)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		7://4.5
		begin
			if(count>=33828)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		8://5
		begin
			if(count>=31886)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		9://5.5
		begin
			if(count>=30119)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		10://6
		begin
			if(count>=28408)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		11://6.5
		begin
			if(count>=26823)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		12://7
		begin
			if(count>=25328)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		13://1+
		begin
			if(count>=23899)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		14://1.5+
		begin
			if(count>=22562)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		15://2+
		begin
			if(count>=21294)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		16://3+
		begin
			if(count>=18967)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		17://4+
		begin
			if(count>=17908)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		18://7+
		begin
			if(count>=12664)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		19://3++
		begin
			if(count>=9484)
			begin
				count<=0;
				wave<=~wave;
			end
			else count<=count+1;
		end
		default:wave<=0;
	endcase
end
endmodule
