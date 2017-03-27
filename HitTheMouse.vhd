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

--ʵ��
entity HitTheMouse is	

   port ( 
          mclk     : in    std_logic; 	--����50MHzʱ��
	       btn      : in    std_logic_vector (7 downto 0); 	--8����Ӱ��������ڴ����
          led      : out   std_logic_vector (7 downto 0); 	--8��led�ƣ���ʾ���󣬵���ʱʹ��
--        seg      : out   std_logic_vector (7 downto 0);  
--        an       : out   std_logic_vector (3 downto 0);
			 fpgabtn  : in    std_logic_vector (3 downto 0);	--fpga�ϵİ��������ڿ�ʼ/��λ/��ͣ�Ŀ���
          OutBlue  : out   std_logic; 	--VGA�����ɫ����
          OutGreen : out   std_logic; 	--VGA�����ɫ����
          OutRed   : out   std_logic; 	--VGA�����ɫ����
          HS       : out   std_logic; 	--VGA��ɨ���ź�
          VS       : out   std_logic;	--VGA��ɨ���ź�
			 soundwave : out std_logic;	--���������
			 bgm : out std_logic	--�����������
			 );

end HitTheMouse;

--������
architecture Structural of HitTheMouse is

-- �ź�������
	signal mainmouse : std_logic_vector (7 downto 0);	--8bit��ÿһλ����һֻ����1���������֣�0������δ����
	signal score2 : std_logic_vector (3 downto 0);	--�����İ�ζ
	signal score1 : std_logic_vector (3 downto 0);	--������ʮλ
	signal score0 : std_logic_vector (3 downto 0);	--�����ĸ�λ
	signal life :std_logic_vector (4 downto 0);	--5bit��ÿһλ����һ��������1������������ڣ�0���������
	signal countdown :std_logic_vector (5 downto 0);	--6bit����������ʾʣ��ʱ��
	signal score_max2:  std_logic_vector (3 downto 0);	--��߷ֵİ�λ
	signal score_max1:  std_logic_vector (3 downto 0); --��߷ֵ�ʮλ
	signal score_max0:  std_logic_vector (3 downto 0); --��߷ֵĸ�λ
	signal mission	:  std_logic_vector (1 downto 0);	--�Ѷ�
	
--Ԫ������
   component VGA_Display
      port ( ck       : in    std_logic; 	--ʱ���ź�
             HS       : out   std_logic; 	--��ɨ���ź�
             VS       : out   std_logic; 	--��ɨ���ź�
             outRed   : out   std_logic; 	--��ɫ����
             outGreen : out   std_logic; 	--��ɫ����
             outBlue  : out   std_logic;	--��ɫ����
				 mouse	 : in    std_logic_vector (7 downto 0);	--8bit��ʾ8ֻ����
				 score2	 : in 	std_logic_vector (3 downto 0);	--�����İ�λ
				 score1	 : in 	std_logic_vector (3 downto 0);	--�����ĸ�λ
				 score0	 : in 	std_logic_vector (3 downto 0);	--������ʮλ
				 countdown: in 	std_logic_vector (5 downto 0);	--ʣ��ʱ��
				 life 	 : in 	std_logic_vector (4 downto 0);	--5bit��ʾ5������
				 score_max2: in std_logic_vector (3 downto 0);	--��߷ְ�λ
				 score_max1: in std_logic_vector (3 downto 0);	--��߷�ʮλ
				 score_max0: in std_logic_vector (3 downto 0);	--��߷ָ�λ
				 mission	: in std_logic_vector (1 downto 0)	--3���Ѷ�(00��01��10)
				);
   end component;
   
	 component Led_Out
      port ( ck  : in    std_logic;	--ʱ��
             led : out   std_logic_vector (7 downto 0);	--led��� 
             mouse : in	std_logic_vector (7 downto 0)	--8ֻ����
			  ); 
   end component;
   
 
	
	component game
		port ( seg_out : out std_logic_vector (7 downto 0); 
				 seg1    : out std_logic;
				 seg2    : out std_logic;
				 seg3    : out std_logic;
				 seg4    : out std_logic;
				 soundwave:out std_logic;	--������
				 bgm		: out std_logic;	--������
				 clk     : in  std_logic;	--ʱ��
				 reset   : in  std_logic;	--��λ
				 start   : in  std_logic;	--��ʼ
				 btn     : in  std_logic_vector (7 downto 0); --�����İ���
				 mouseout: out std_logic_vector (7 downto 0); --8ֻ����״̬
				 score2	: out std_logic_vector (3 downto 0); --������λ
    			 score1	: out std_logic_vector (3 downto 0); --����ʮλ
				 score0	: out std_logic_vector (3 downto 0); --������λ
				 countdownout:out std_logic_vector (5 downto 0); --ʣ��ʱ��
				 lifeout : out std_logic_vector (4 downto 0); --5��ʣ������
				 pause	:in std_logic; --��ͣ
				 score_max2: out std_logic_vector (3 downto 0); --��߷ְ�λ
				 score_max1: out std_logic_vector (3 downto 0); --��߷�ʮλ
				 score_max0: out std_logic_vector (3 downto 0); --��߷ָ�λ
				 mission	: out std_logic_vector (1 downto 0) --3���Ѷ�
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

