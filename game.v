`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:03:39 06/25/2013 
// Design Name: 
// Module Name:    game 
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
module game(clk,reset,start,pause,seg_out,seg1,seg2,seg3,seg4,btn,soundWave,BGM,mouseout,score2,score1,score0,countdownout,lifeout,mission,score_max0,score_max1,score_max2);
output [7:0] seg_out;
output seg1,seg2,seg3,seg4;
output soundWave,BGM;
input clk,reset,start,pause;
input [7:0] btn;
output [7:0]mouseout;
output [4:0]lifeout;
output [5:0]countdownout;
parameter MAX_LIFE=5,MAX_TIME=40;

reg clk100;
reg [17:0]clk100_count;
reg [7:0] old_btn;
reg old_pause;
reg hit;
reg [9:0] i,j;
reg [30:0]randNum;
reg [4:0]seed;
reg [8:0] appearCount;
reg [6:0] TimeCount;
reg [5:0] disappearCount;
reg [7:0]score;//分数上限255
reg [4:0]lifebuff;
reg [5:0]countdown;//倒计时40秒
reg [2:0]life;//五条命
reg [7:0]score_max;//最高分
reg [4:0]onebitlife;
reg [2:0]mouse[7:0];
reg [7:0]onebitmouse;
output reg [1:0]mission;//0为难度1，1为难度2，2为难度3
reg [1:0]situation;//0为游戏中，1为游戏结束，2为游戏开始前，3为暂停
reg hitSound,faultSound,loseSound;
output [3:0]score0,score1,score2;
output [3:0]score_max0,score_max1,score_max2;

//led U1(led_out,mouse[0],mouse[1],mouse[2],mouse[3],mouse[4],mouse[5],mouse[6],mouse[7],clk);
//seg U2(0,score_max2,score_max1,score_max0,seg_out,seg1,seg2,seg3,seg4,clk);
bin2dec U3(clk,score_max,score_max0,score_max1,score_max2);
sound U4(clk100,clk,hitSound,faultSound,loseSound,soundWave);
bgm U5(situation,mission,clk,clk100,BGM);
bin2dec U6(clk,score,score0,score1,score2);
initial 
	begin
		score_max<=0;
		score<=0;
		countdown<=MAX_TIME;
		life<=MAX_LIFE;
		mission<=0;
		lifebuff<=0;
		appearCount<=0;
		TimeCount<=0;
		disappearCount<=0;
		randNum<=0;
		situation<=2;
		hit<=0;
		hitSound<=0;
		faultSound<=0;
		loseSound<=0;
	end
always @(posedge clk)
begin
	if(seed>=25)
		seed<=0;
	else seed<=seed+1;
	if(clk100_count==249999)
	begin
		clk100_count<=0;
		clk100=~clk100;
	end
	else clk100_count<=clk100_count+1;
end

always @(posedge clk100)
begin
	if(score>score_max) score_max<=score;
	hitSound<=0;
	faultSound<=0;
	loseSound<=0;
	if(situation==0)
	begin
		if((appearCount>=299&&mission==0)||(appearCount>=249&&mission==1)||(appearCount>=149&&mission==2)||(hit&&appearCount==49))
			begin 
				hit<=0;
				appearCount<=0;
				if(mission==0)
					begin
						randNum=65539*randNum;
						mouse[randNum>>28]<=5;
					end
				else
					begin
						randNum=65539*randNum;
						mouse[randNum>>28]<=4;
					end                                                                                                                                                                
			end
		else appearCount<=appearCount+1'b1;
		
		if(disappearCount>=49)
			begin 
				disappearCount<=0;
				for(i=0;i<8;i=i+1)
				begin
					if(mouse[i]>0) mouse[i]<=mouse[i]-1;
				end                                                                                                                                                         
			end
		else disappearCount<=disappearCount+1'b1;
		if(TimeCount==99)
			begin 
				TimeCount<=0;
				if(countdown>0) countdown<=countdown-1;
				else situation<=1;//时间结束，游戏结束
			end
		else TimeCount<=TimeCount+1'b1;
		for(i=0;i<8;i=i+1)
		begin
			if(!old_btn[i]&&btn[i])
			begin
				if(mouse[i])
				begin
					mouse[i]<=0;
					score<=score+1;
					lifebuff<=lifebuff+1;
					hit<=1;
					appearCount<=0;
					disappearCount<=0;
					hitSound<=1;
				end
				else
				begin
					life<=life-1;
					lifebuff<=0;
					faultSound<=1;
				end
			end
		end
		if(life<MAX_LIFE&&lifebuff==10)
		begin
			life<=life+1;
			lifebuff<=0;
		end
		if((score>=20&&mission==0)||(score>=50&&mission==1))
			begin 
				mission<=mission+1;
				countdown<=MAX_TIME;
			end
		if(life==0)
		begin
			situation<=1;//life=0，游戏结束
			loseSound<=1;
		end
	end
	
	if(reset)
	begin 
		score<=0;
		lifebuff<=0;
		countdown<=MAX_TIME;
		life<=MAX_LIFE;
		mission<=0;
		appearCount<=0;
		TimeCount<=0;
		situation<=2;
		disappearCount<=0;
		for(i=0;i<8;i=i+1) mouse[i]<=0;
		hit<=0;
	end
	if(!old_pause&&pause&&situation==0)situation<=3;
	else if(!old_pause&&pause&&situation==3) situation<=0;
	if(start&&situation==3) situation<=0;
	else if(start&&situation!=0)
	begin 
		score<=0;
		countdown<=MAX_TIME;
		life<=MAX_LIFE;
		mission<=0;
		appearCount<=0;
		TimeCount<=0;
		disappearCount<=0;
		for(i=0;i<8;i=i+1) mouse[i]<=0;
		situation<=0;
		randNum=65539*seed;
		for(i=0;i<20;i=i+1) randNum=65539*randNum;
		hit<=1;
	end
	old_btn<=btn;
	old_pause<=pause;
	end


always@(posedge clk)
begin 
for(j=0;j<=7;j=j+1)
if (mouse[j]==0) onebitmouse[j]=0;
	else onebitmouse[j]=1;
case (life)
	0: onebitlife=5'b00000;
	1: onebitlife=5'b10000;
	2: onebitlife=5'b11000;
	3: onebitlife=5'b11100;
	4: onebitlife=5'b11110;
	5: onebitlife=5'b11111;
endcase
end
assign mouseout[7:0] = onebitmouse[7:0];
assign lifeout[4:0] = onebitlife[4:0];
assign countdownout[5:0] =countdown[5:0]; 


endmodule

