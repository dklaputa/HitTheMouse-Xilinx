`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:56 06/29/2013 
// Design Name: 
// Module Name:    bgm 
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
module bgm(situation,mission,clk,clk100,wave);
input [1:0] situation;
input [2:0] mission;
input clk,clk100;
output wave;

reg [2:0] count;
//reg noteclk;
reg [3:0] note;
reg [6:0] i;
reg [3:0] j;

doRaMi U(note,clk,wave);

initial
	begin
	note<=0;
	i=0;
	j=0;
	end
	
always @(posedge clk100)
begin
	if((count>=3&&mission==0)||(count>=2&&mission==1)||(count>=1&&mission==2))
	begin
		count<=0;
	//	noteclk<=~noteclk;
		if(situation==0)
		begin 
			if(i<85)
			begin
				j=j+1;
				if(j>getLength(i))
				begin
					j=0;
					i=i+1;
					note<=0;
				end
				else note<=getNote(i);
			end
			else i=0;
		end
		else if(situation==3) note<=0;
		else
		begin
			i=0;
			j=0;
			note<=0;
		end
	end
	else count<=count+1;
end

function [3:0] getNote;
	input [6:0]i;
	case(i)
		0:getNote=7;
		1:getNote=2;
		2:getNote=7;
		3:getNote=7;
		4:getNote=9;
		5:getNote=10;
		6:getNote=10;
		7:getNote=7;
		8:getNote=7;
		9:getNote=7;
		10:getNote=10;
		11:getNote=9;
		12:getNote=5;
		13:getNote=5;
		14:getNote=5;
		15:getNote=9;
		16:getNote=9;
		17:getNote=7;
		18:getNote=7;
		19:getNote=7;
		20:getNote=2;
		21:getNote=7;
		22:getNote=7;
		23:getNote=9;
		24:getNote=10;
		25:getNote=10;
		26:getNote=7;
		27:getNote=7;
		28:getNote=7;
		29:getNote=10;
		30:getNote=14;
		31:getNote=14;
		32:getNote=14;
		33:getNote=12;
		34:getNote=10;
		35:getNote=10;
		36:getNote=9;
		37:getNote=9;
		38:getNote=10;
		39:getNote=7;
		40:getNote=7;
		41:getNote=7;
		42:getNote=7;
		43:getNote=10;
		44:getNote=14;
		45:getNote=14;
		46:getNote=12;
		47:getNote=10;
		48:getNote=9;
		49:getNote=5;
		50:getNote=5;
		51:getNote=5;
		52:getNote=9;
		53:getNote=12;
		54:getNote=12;
		55:getNote=12;
		56:getNote=12;
		57:getNote=10;
		58:getNote=9;
		59:getNote=10;
		60:getNote=7;
		61:getNote=7;
		62:getNote=7;
		63:getNote=0;
		64:getNote=7;
		65:getNote=14;
		66:getNote=14;
		67:getNote=12;
		68:getNote=10;
		69:getNote=9;
		70:getNote=5;
		71:getNote=5;
		72:getNote=5;
		73:getNote=9;
		74:getNote=12;
		75:getNote=12;
		76:getNote=12;
		77:getNote=12;
		78:getNote=10;
		79:getNote=9;
		80:getNote=10;
		81:getNote=7;
		82:getNote=7;
		83:getNote=7;
		84:getNote=0;
		default:getNote=0;
	endcase
endfunction
function [3:0] getLength;
	input [6:0]i;
	case(i)
		0:getLength=4;
		1:getLength=9;
		2:getLength=9;
		3:getLength=14;
		4:getLength=4;
		5:getLength=4;
		6:getLength=4;
		7:getLength=9;
		8:getLength=9;
		9:getLength=4;
		10:getLength=4;
		11:getLength=9;
		12:getLength=9;
		13:getLength=9;
		14:getLength=9;
		15:getLength=4;
		16:getLength=4;
		17:getLength=9;
		18:getLength=14;
		19:getLength=4;
		20:getLength=9;
		21:getLength=9;
		22:getLength=14;
		23:getLength=4;
		24:getLength=4;
		25:getLength=4;
		26:getLength=9;
		27:getLength=9;
		28:getLength=4;
		29:getLength=4;
		30:getLength=4;
		31:getLength=4;
		32:getLength=4;
		33:getLength=4;
		34:getLength=4;
		35:getLength=4;
		36:getLength=4;
		37:getLength=4;
		38:getLength=9;
		39:getLength=4;
		40:getLength=4;
		41:getLength=9;
		42:getLength=4;
		43:getLength=4;
		44:getLength=9;
		45:getLength=9;
		46:getLength=9;
		47:getLength=9;
		48:getLength=9;
		49:getLength=9;
		50:getLength=9;
		51:getLength=4;
		52:getLength=4;
		53:getLength=4;
		54:getLength=4;
		55:getLength=4;
		56:getLength=4;
		57:getLength=9;
		58:getLength=9;
		59:getLength=9;
		60:getLength=4;
		61:getLength=4;
		62:getLength=9;
		63:getLength=4;
		64:getLength=4;
		65:getLength=9;
		66:getLength=9;
		67:getLength=9;
		68:getLength=9;
		69:getLength=9;
		70:getLength=9;
		71:getLength=9;
		72:getLength=4;
		73:getLength=4;
		74:getLength=4;
		75:getLength=4;
		76:getLength=4;
		77:getLength=4;
		78:getLength=9;
		79:getLength=9;
		80:getLength=9;
		81:getLength=4;
		82:getLength=4;
		83:getLength=9;
		84:getLength=9;
		default:getLength=0;
	endcase
endfunction
endmodule
