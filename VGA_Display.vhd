----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:53:09 07/03/2013 
-- Design Name: 
-- Module Name:    VGA_Display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity VGA_Display is
  Port (ck: in std_logic;  -- 50MHz
--        Hcnt: in std_logic_vector(9 downto 0);      -- horizontal counter
--        Vcnt: in std_logic_vector(9 downto 0);      -- verical counter
        HS: out std_logic;					-- horizontal synchro signal					
        VS: out std_logic;					-- verical synchro signal 

        outRed  : out std_logic; -- final color
        outGreen: out std_logic;	 -- outputs
        outBlue : out std_logic;
--		  vgactrl : in  std_logic;
		  mouse	 : in  std_logic_vector(7 downto 0);
		  score2 : std_logic_vector (3 downto 0);
		  score1 : std_logic_vector (3 downto 0);
		  score0 : std_logic_vector (3 downto 0);
		  countdown :std_logic_vector (5 downto 0);
		  life	:std_logic_vector (4 downto 0);
		  score_max2: in std_logic_vector (3 downto 0);
				 score_max1: in std_logic_vector (3 downto 0);
				 score_max0: in std_logic_vector (3 downto 0);
				 mission	: in std_logic_vector (1 downto 0)
		  
		  );
end VGA_Display;

architecture Behavioral of VGA_Display is

-- 
--    signal x,y: integer;
	
  constant PAL:integer:=640;		--Pixels/Active Line (pixels)
  constant LAF:integer:=480;		--Lines/Active Frame (lines)
  constant PLD: integer:=800;	--Pixel/Line Divider
  constant LFD: integer:=521;	--Line/Frame Divider
  constant HPW:integer:=96;		--Horizontal synchro Pulse Width (pixels)
  constant HFP:integer:=16;		--Horizontal synchro Front Porch (pixels)
--  constant HBP:integer:=48;		--Horizontal synchro Back Porch (pixels)
  constant VPW:integer:=2;		--Verical synchro Pulse Width (lines)
  constant VFP:integer:=10;		--Verical synchro Front Porch (lines)
--  constant VBP:integer:=29;		--Verical synchro Back Porch (lines)


-- signals for VGA Demo
  signal Hcnt: std_logic_vector(9 downto 0);      -- horizontal counter
  signal Vcnt: std_logic_vector(9 downto 0);      -- verical counter
  signal intHcnt: integer range 0 to 800-1; --PLD-1 - horizontal counter
  signal intVcnt: integer range 0 to 521-1; -- LFD-1 - verical counter
 -- signal ctrl: bit;
--  signal inttime: integer range 0 to 64;
  signal ck25MHz: std_logic;		-- ck 25MHz
 -- signal rgb: std_logic_vector(7 downto 0);  
 
    

  
-- mod
	function fmod(a,b: integer) return integer is
	variable i,j:integer;
	begin
	i:=0;
	j:=0;
	for i in 0 to 16 loop
		if (a-b*i)>=b then j:=i+1;
	--	else j:=j;
		end if;
	end loop;
	
	return j;
	end fmod;
	

  
-- picture
	type matrix_a is array (0 to 15) of std_logic_vector(0 to 15);
	type matrix_b is array (0 to 12) of std_logic_vector(0 to 12);
	type matrix_c is array (0 to 5)	of std_logic_vector(0 to 4);
  signal pic_mouse : matrix_a;
  signal pic_heart : matrix_b;
  signal pic_brokenheart : matrix_b;
  signal pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9 : matrix_c;

-- draw picture

function draw_mouse(x,y,inthcnt,intvcnt,mouse_num: integer; pic_mouse: matrix_a) return std_logic_vector is
	variable result: std_logic_vector(2 downto 0);
	begin
			if mouse(mouse_num)= '0' then
				if inthcnt>=x+10 and inthcnt<x+150 and intvcnt>=y+130 and intvcnt<y+150 then
					result:="111";
					else
					result:="000";
				end if;
			else 
				if inthcnt>=x+10 and inthcnt<x+150 and intvcnt>=y+130 and intvcnt<y+150 then
					result:="111";
				elsif inthcnt>=x+70 and inthcnt<x+90 and intvcnt>=y+80 and intvcnt<y+90 then	
					result:="101";
				elsif inthcnt>=x+70 and inthcnt<x+90 and intvcnt>=y+100 and intvcnt<y+120 then
					result:="111";
				else if pic_mouse(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then
						result:="011";
						else
						result:="000";
						end if;
				 end if;
			end if;
			return result;
	end draw_mouse;
	
function draw_heart(x,y,inthcnt,intvcnt,heart_num: integer; pic_heart,pic_brokenheart: matrix_b;life: std_logic_vector) return std_logic_vector is
	variable result: std_logic_vector(2 downto 0);
	begin
			if life(4-heart_num)='0' then
				if pic_brokenheart(fmod(intvcnt-y,4))(fmod(inthcnt-x,4))='1' then result:="111";
					else result:="000";
					end if;
				else 
				if pic_heart(fmod(intvcnt-y,4))(fmod(inthcnt-x,4))='1' then result:="100";
					else result :="000";
				end if;
			end if;
			return result;
	end draw_heart;
	
function draw_num(x,y,inthcnt,intvcnt: integer;num: std_logic_vector;pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9: matrix_c) return std_logic_vector is
	variable result: std_logic_vector(2 downto 0);
	begin
			if num="0000" then 
				if pic_0(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if;
			elsif num="0001" then 
				if pic_1(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0010" then 
				if pic_2(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0011" then 
				if pic_3(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0100" then 
				if pic_4(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0101" then 
				if pic_5(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0110" then 
				if pic_6(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="0111" then 
				if pic_7(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="1000" then 
				if pic_8(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			elsif num="1001" then 
				if pic_9(fmod(intvcnt-y,10))(fmod(inthcnt-x,10))='1' then result:="111";
					else result:="000";
					end if; 
			end if;

			return result;
	end draw_num;


begin

-- picture  
  pic_mouse(0)<= "0000000000000000";
  pic_mouse(1)<= "0000011111100000";
  pic_mouse(2)<= "0000111111110000";
  pic_mouse(3)<= "0001111111111000";
  pic_mouse(4)<= "0001101111011000";
  pic_mouse(5)<= "0001101111011000";
  pic_mouse(6)<= "0001101111011000";
  pic_mouse(7)<= "0001111111111000";
  pic_mouse(8)<= "0001111001111000";
  pic_mouse(9)<= "0001111111111000";
  pic_mouse(10)<="0001100110011000";
  pic_mouse(11)<="0001100110011000";
  pic_mouse(12)<="0001110000111000";
  pic_mouse(13)<="0111111111111110";
  pic_mouse(14)<="0111111111111110";
  pic_mouse(15)<="0000000000000000";
  
  pic_heart(0) <="0001000001000";
  pic_heart(1) <="0111100011110";
  pic_heart(2) <="1111110111111";
  pic_heart(3) <="1111111111111";
  pic_heart(4) <="1111111111111";
  pic_heart(5) <="1111111111111";
  pic_heart(6) <="1111111111111";
  pic_heart(7) <="0111111111110";
  pic_heart(8) <="0011111111100";
  pic_heart(9) <="0001111111000";
  pic_heart(10)<="0000111110000";
  pic_heart(11)<="0000011100000";
  pic_heart(12)<="0000001000000";
  
  pic_brokenheart(0) <="0001000001000";
  pic_brokenheart(1) <="0111100011110";
  pic_brokenheart(2) <="1111100111111";
  pic_brokenheart(3) <="1111001111111";
  pic_brokenheart(4) <="1110000011111";
  pic_brokenheart(5) <="1111000000111";
  pic_brokenheart(6) <="1111110000111";
  pic_brokenheart(7) <="0111110001110";
  pic_brokenheart(8) <="0011110011100";
  pic_brokenheart(9) <="0001100111000";
  pic_brokenheart(10)<="0000100110000";
  pic_brokenheart(11)<="0000001100000";
  pic_brokenheart(12)<="0000001000000";
  
  pic_0(0) <="01110";
  pic_0(1) <="10001";
  pic_0(2) <="10001";
  pic_0(3) <="10001";
  pic_0(4) <="10001";
  pic_0(5) <="01110";
  
  pic_1(0) <="00100";
  pic_1(1) <="01100";
  pic_1(2) <="00100";
  pic_1(3) <="00100";
  pic_1(4) <="00100";
  pic_1(5) <="01110";
  
  pic_2(0) <="01110";
  pic_2(1) <="10001";
  pic_2(2) <="00010";
  pic_2(3) <="00100";
  pic_2(4) <="01000";
  pic_2(5) <="11111";
  
  pic_3(0) <="11111";
  pic_3(1) <="00001";
  pic_3(2) <="00110";
  pic_3(3) <="00001";
  pic_3(4) <="00001";
  pic_3(5) <="01110";
  
  pic_4(0) <="00010";
  pic_4(1) <="00110";
  pic_4(2) <="01010";
  pic_4(3) <="10010";
  pic_4(4) <="11111";
  pic_4(5) <="00010";
  
  pic_5(0) <="11111";
  pic_5(1) <="10000";
  pic_5(2) <="11110";
  pic_5(3) <="00001";
  pic_5(4) <="00001";
  pic_5(5) <="01110";
  
  pic_6(0) <="01110";
  pic_6(1) <="10000";
  pic_6(2) <="11110";
  pic_6(3) <="10001";
  pic_6(4) <="10001";
  pic_6(5) <="01110";
  
  pic_7(0) <="11111";
  pic_7(1) <="00001";
  pic_7(2) <="00010";
  pic_7(3) <="00100";
  pic_7(4) <="00100";
  pic_7(5) <="00100";
  
  pic_8(0) <="01110";
  pic_8(1) <="10001";
  pic_8(2) <="01110";
  pic_8(3) <="10001";
  pic_8(4) <="10001";
  pic_8(5) <="01110";
  
  pic_9(0) <="01110";
  pic_9(1) <="10001";
  pic_9(2) <="10001";
  pic_9(3) <="01111";
  pic_9(4) <="00001";
  pic_9(5) <="01110";
  



-- divide 50MHz clock to 25MHz
  div2: process(ck)
  begin
    if ck'event and ck = '1' then
	   ck25MHz <= not ck25MHz; 
    end if;
  end process;	 

  syncro: process (ck25MHz)
  begin
  
	
  if ck25MHz'event and ck25MHz='1' then
    if intHcnt=PLD-1 then
       intHcnt<=0;
      if intVcnt=LFD-1 then intVcnt<=0;
      else intVcnt<=intVcnt+1;
      end if;
    else intHcnt<=intHcnt+1;
    end if;
	
	-- Generates HS - active low
	if intHcnt=PAL-1+HFP then 
		HS<='0';
	elsif intHcnt=PAL-1+HFP+HPW then 
		HS<='1';
	end if;

	-- Generates VS - active low
	if intVcnt=LAF-1+VFP then 
		VS<='0';
	elsif intVcnt=LAF-1+VFP+VPW then
		VS<='1';
	end if;
end if;
end process; 

-- mapping itnernal integers to std_logic_vector ports
  Hcnt <= conv_std_logic_vector(intHcnt,10);
  Vcnt <= conv_std_logic_vector(intVcnt,10);
  --ctrl <= to_bit(vgactrl);


  mixer: process(ck25MHz,intHcnt, intVcnt) 
  VARIABLE temp_i,temp_j,inttime,x,y:integer;
  VARIABLE rgb : std_logic_vector(2 downto 0);

  begin
	 inttime :=0;
	 if countdown(0)='1' then inttime:=inttime+1;
	 end if;
	 if countdown(1)='1' then inttime:=inttime+2;
	 end if;
	 if countdown(2)='1' then inttime:=inttime+4;
	 end if;
	 if countdown(3)='1' then inttime:=inttime+8;
	 end if;
	 if countdown(4)='1' then inttime:=inttime+16;
	 end if;
	 if countdown(5)='1' then inttime:=inttime+32;
	 end if;
    if intHcnt < PAL and intVcnt < LAF then	 -- in the active screen
	-- mouse
	 if intvcnt<320 then
		x:=0;
		for temp_i in 0 to 3 loop
			x:=temp_i*160;
		for temp_j in 0 to 1 loop
			y:=temp_j*160;
  		if inthcnt>=x and inthcnt<x+160 and intvcnt>=y and intvcnt<y+160 then
			rgb := draw_mouse(x,y,inthcnt,intvcnt,7-temp_i-4*temp_j,pic_mouse);
			end if;
			end loop;
			end loop;
	
	-- time
  	 elsif inthcnt>=10 and inthcnt<=10+(inttime)*7 and intvcnt>=420 and intvcnt<=460 then
 			rgb:= "010";
	-- score
  	 elsif inthcnt>=340 and inthcnt<=390 and intvcnt>=330 and intvcnt<=390 then
 			rgb := draw_num(340,330,inthcnt,intvcnt,score2, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9);
 	 elsif inthcnt>=410 and inthcnt<=460 and intvcnt>=330 and intvcnt<=390 then
 			rgb := draw_num(410,330,inthcnt,intvcnt,score1, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9);
 	 elsif inthcnt>=480 and inthcnt<=530 and intvcnt>=330 and intvcnt<=390 then
 			rgb := draw_num(480,330,inthcnt,intvcnt,score0, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9);
	-- high score
	elsif inthcnt>=340 and inthcnt<=390 and intvcnt>=410 and intvcnt<=470 then
 			rgb(2) := draw_num(340,410,inthcnt,intvcnt,score_max2, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9)(2);
			rgb(1 downto 0) :="00";
 	 elsif inthcnt>=410 and inthcnt<=460 and intvcnt>=410 and intvcnt<=470 then
 			rgb(2) := draw_num(410,410,inthcnt,intvcnt,score_max1, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9)(2);
			rgb(1 downto 0) :="00";
	 elsif inthcnt>=480 and inthcnt<=530 and intvcnt>=410 and intvcnt<=470 then
 			rgb(2) := draw_num(480,410,inthcnt,intvcnt,score_max0, pic_0,pic_1,pic_2,pic_3,pic_4,pic_5,pic_6,pic_7,pic_8,pic_9)(2);
			rgb(1 downto 0) :="00";
	 -- mission
	 elsif inthcnt>=560 and inthcnt<=620 and intvcnt>=430 and intvcnt<=460 then
			rgb :="011";
	 elsif inthcnt>=560 and inthcnt<=620 and intvcnt>=390 and intvcnt<=420 then
			if mission="01" or mission ="10" then
			rgb:= "010";
			else rgb:="000";
			end if;
	 elsif inthcnt>=560 and inthcnt<=620 and intvcnt>=350 and intvcnt<=380 then
			if mission="10" then
			rgb:= "110";
			else rgb:="000";
			end if;
	 -- heart
 	 else 
 		if inthcnt>=14 and inthcnt<=14+52 and intvcnt>=336 and intvcnt<=336+52 then
 		rgb := draw_heart(14,336,inthcnt,intvcnt,0,pic_heart,pic_brokenheart,life);
		elsif inthcnt>=74 and inthcnt<=74+52 and intvcnt>=336 and intvcnt<=336+52 then
 		rgb := draw_heart(74,336,inthcnt,intvcnt,1,pic_heart,pic_brokenheart,life);
		elsif inthcnt>=134 and inthcnt<=134+52 and intvcnt>=336 and intvcnt<=336+52 then
 		rgb := draw_heart(134,336,inthcnt,intvcnt,2,pic_heart,pic_brokenheart,life);
		elsif inthcnt>=194 and inthcnt<=194+52 and intvcnt>=336 and intvcnt<=336+52 then
 		rgb := draw_heart(194,336,inthcnt,intvcnt,3,pic_heart,pic_brokenheart,life);
		elsif inthcnt>=254 and inthcnt<=254+52 and intvcnt>=336 and intvcnt<=336+52 then
 		rgb := draw_heart(254,336,inthcnt,intvcnt,4,pic_heart,pic_brokenheart,life);
		else rgb:="000";
 		end if;
	 end if;
	 outRed <= rgb(2);
	 outGreen <= rgb(1);
	 outBlue <= rgb(0);
	 
	 else
         outRed <= '0'; 
         outGreen <= '0'; 
         outBlue <= '0'; 
	end if;
	
	end process;

end Behavioral;
