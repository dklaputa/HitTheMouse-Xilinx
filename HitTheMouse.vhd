----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:28 07/03/2013 
-- Design Name: 
-- Module Name:    HitTheMouse - Behavioral 
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

--实体
entity HitTheMouse is	

   port ( 
          mclk     : in    std_logic; 	--板载50MHz时钟
	       btn      : in    std_logic_vector (7 downto 0); 	--8个外接按键，用于打地鼠
          led      : out   std_logic_vector (7 downto 0); 	--8个led灯，显示地鼠，调试时使用
--        seg      : out   std_logic_vector (7 downto 0);  
--        an       : out   std_logic_vector (3 downto 0);
			 fpgabtn  : in    std_logic_vector (3 downto 0);	--fpga上的按键，用于开始/复位/暂停的控制
          OutBlue  : out   std_logic; 	--VGA输出蓝色分量
          OutGreen : out   std_logic; 	--VGA输出绿色分量
          OutRed   : out   std_logic; 	--VGA输出红色分量
          HS       : out   std_logic; 	--VGA行扫描信号
          VS       : out   std_logic;	--VGA列扫描信号
			 soundwave : out std_logic;	--按键音输出
			 bgm : out std_logic	--背景音乐输出
			 );

end HitTheMouse;

--构造体
architecture Structural of HitTheMouse is

-- 信号量声明
	signal mainmouse : std_logic_vector (7 downto 0);	--8bit，每一位代表一只地鼠，1代表地鼠出现，0代表其未出现
	signal score2 : std_logic_vector (3 downto 0);	--分数的百味
	signal score1 : std_logic_vector (3 downto 0);	--分数的十位
	signal score0 : std_logic_vector (3 downto 0);	--分数的各位
	signal life :std_logic_vector (4 downto 0);	--5bit，每一位代表一条生命，1代表该生命存在，0其代表不存在
	signal countdown :std_logic_vector (5 downto 0);	--6bit二进制数表示剩余时间
	signal score_max2:  std_logic_vector (3 downto 0);	--最高分的百位
	signal score_max1:  std_logic_vector (3 downto 0); --最高分的十位
	signal score_max0:  std_logic_vector (3 downto 0); --最高分的各位
	signal mission	:  std_logic_vector (1 downto 0);	--难度
	
--元件声明
   component VGA_Display
      port ( ck       : in    std_logic; 	--时钟信号
             HS       : out   std_logic; 	--行扫描信号
             VS       : out   std_logic; 	--列扫描信号
             outRed   : out   std_logic; 	--红色分量
             outGreen : out   std_logic; 	--绿色分量
             outBlue  : out   std_logic;	--蓝色分量
				 mouse	 : in    std_logic_vector (7 downto 0);	--8bit表示8只地鼠
				 score2	 : in 	std_logic_vector (3 downto 0);	--分数的百位
				 score1	 : in 	std_logic_vector (3 downto 0);	--分数的个位
				 score0	 : in 	std_logic_vector (3 downto 0);	--分数的十位
				 countdown: in 	std_logic_vector (5 downto 0);	--剩余时间
				 life 	 : in 	std_logic_vector (4 downto 0);	--5bit表示5条生命
				 score_max2: in std_logic_vector (3 downto 0);	--最高分百位
				 score_max1: in std_logic_vector (3 downto 0);	--最高分十位
				 score_max0: in std_logic_vector (3 downto 0);	--最高分个位
				 mission	: in std_logic_vector (1 downto 0)	--3个难度(00，01，10)
				);
   end component;
   
	 component Led_Out
      port ( ck  : in    std_logic;	--时钟
             led : out   std_logic_vector (7 downto 0);	--led输出 
             mouse : in	std_logic_vector (7 downto 0)	--8只老鼠
			  ); 
   end component;
   
 
	
	component game
		port ( seg_out : out std_logic_vector (7 downto 0); 
				 seg1    : out std_logic;
				 seg2    : out std_logic;
				 seg3    : out std_logic;
				 seg4    : out std_logic;
				 soundwave:out std_logic;	--按键音
				 bgm		: out std_logic;	--背景音
				 clk     : in  std_logic;	--时钟
				 reset   : in  std_logic;	--复位
				 start   : in  std_logic;	--开始
				 btn     : in  std_logic_vector (7 downto 0); --打地鼠的按键
				 mouseout: out std_logic_vector (7 downto 0); --8只地鼠状态
				 score2	: out std_logic_vector (3 downto 0); --分数百位
    			 score1	: out std_logic_vector (3 downto 0); --分数十位
				 score0	: out std_logic_vector (3 downto 0); --分数个位
				 countdownout:out std_logic_vector (5 downto 0); --剩余时间
				 lifeout : out std_logic_vector (4 downto 0); --5条剩余生命
				 pause	:in std_logic; --暂停
				 score_max2: out std_logic_vector (3 downto 0); --最高分百位
				 score_max1: out std_logic_vector (3 downto 0); --最高分十位
				 score_max0: out std_logic_vector (3 downto 0); --最高分个位
				 mission	: out std_logic_vector (1 downto 0) --3个难度
				 );
	end component;
   
begin

   VGAshow : VGA_Display
      port map (
		          ck=>mclk,
                HS=>HS,
                VS=>VS,
                outRed=>OutRed,
                outGreen=>OutGreen,
                outBlue=>OutBlue,
--					 vgactrl =>sw(0),
					 mouse(7 downto 0) =>mainmouse(7 downto 0),
					 score2(3 downto 0) =>score2(3 downto 0),
					 score1(3 downto 0) =>score1(3 downto 0),
					 score0(3 downto 0) =>score0(3 downto 0),
					 life(4 downto 0) =>life(4 downto 0),
					 countdown(5 downto 0) =>countdown(5 downto 0),
					 mission(1 downto 0) => mission(1 downto 0),
					 score_max2(3 downto 0)=> score_max2(3 downto 0),
					 score_max1(3 downto 0)=> score_max1(3 downto 0),
					 score_max0(3 downto 0)=> score_max0(3 downto 0)
					 );
   
	LEDshow : Led_Out
      port map (
		          ck=>mclk,
                led(7 downto 0)=>led(7 downto 0),
					 mouse(7 downto 0) =>mainmouse(7 downto 0)
				    );
	
   

					 
    verilogmodelGE : game
	   port map (
				 seg_out(7 downto 0) =>seg(7 downto 0),
				 seg1    =>an(2),
				 seg2    =>an(1),
				 seg3    =>an(0),
				 seg4    =>an(3),
				 clk     =>mclk,
				 reset   =>fpgabtn(0),
				 start   =>fpgabtn(2),
				 pause	=>fpgabtn(1),
				 btn(7 downto 0) =>btn(7 downto 0),
				 mouseout(7 downto 0) =>mainmouse(7 downto 0),
				 soundwave =>soundwave,
				 bgm =>bgm,
				 score2(3 downto 0) =>score2(3 downto 0),
				 score1(3 downto 0) =>score1(3 downto 0),
				 score0(3 downto 0) =>score0(3 downto 0),
				 countdownout (5 downto 0) =>countdown(5 downto 0),
				 lifeout(4 downto 0) => life(4 downto 0),
				 mission(1 downto 0) => mission(1 downto 0),
					 score_max2(3 downto 0)=> score_max2(3 downto 0),
					 score_max1(3 downto 0)=> score_max1(3 downto 0),
					 score_max0(3 downto 0)=> score_max0(3 downto 0)
				 );
					 
   
end Structural;

