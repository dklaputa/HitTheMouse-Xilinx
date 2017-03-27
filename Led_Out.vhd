----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:15 07/03/2013 
-- Design Name: 
-- Module Name:    Led_Out - Behavioral 
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

entity Led_Out is

  Port (ck:  in  std_logic;


        led: out std_logic_vector(7 downto 0);
        
		  mouse: in std_logic_vector(7 downto 0)
		  );

end Led_Out;

architecture Behavioral of Led_Out is


begin

  led <= mouse;  -- switches control LEDs


end Behavioral;

