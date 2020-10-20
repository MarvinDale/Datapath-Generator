-- Model name: datapathGenerator  
-- Description: Data generation component

-- >> Authors: Marvin Dale, Brendan McKeown
-- >> Date: 19/10/2020

-- Signal dictionary 
-- Inputs
--   selCtrl      deassert (l) to select ctrlA as DPMux select signal 
--                assert   (h) to select ctrlB as DPMux select signal 
--   ctrlA        2-bit control bus
--   ctrlB        2-bit control bus
--   sig0Dat      1-bit data  
--   sig1Dat      3-bit bus data
--   sig2Dat      8-bit bus data
--   sig3Dat      4-bit bus data
-- Outputs         
--   datA         8-bit data 
--   datB         8-bit data. 2s complement of datA 
--   datC         8-bit data. datA + datB

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
 
entity datapathGenerator is
    Port ( selCtrl     : in  std_logic;
           ctrlA       : in  STD_LOGIC_VECTOR(1 downto 0);
           ctrlB       : in  STD_LOGIC_VECTOR(1 downto 0);  
           sys0Dat     : in  STD_LOGIC;   
           sys1Dat     : in  STD_LOGIC_VECTOR(2 downto 0);   
           sys2Dat     : in  STD_LOGIC_VECTOR(7 downto 0);
           sys3Dat     : in  STD_LOGIC_VECTOR(3 downto 0);
           datA        : out STD_LOGIC_VECTOR(7 downto 0);
           datB        : out STD_LOGIC_VECTOR(7 downto 0);
           datC        : out STD_LOGIC_VECTOR(7 downto 0)
          );
end datapathGenerator;

architecture combinational of datapathGenerator is
-- declare internal signals 
signal ctrl             : STD_LOGIC_VECTOR(1 downto 0);
signal intDatA, intDatB : STD_LOGIC_VECTOR(7 downto 0);
signal sys3DatExtended  : STD_LOGIC_VECTOR(7 downto 0);
signal in_1             : STD_LOGIC_VECTOR(7 downto 0);
signal in_2             : STD_LOGIC_VECTOR(7 downto 0) := x"f4";
begin
 
-- concatanate bus
in_1 <= sys0Dat & sys1Dat & sys2Dat(4 downto 1);

-- Sign extend bus
sys3DatExtended <= std_logic_vector(resize(unsigned(sys3Dat), sys3DatExtended'length));

-- mux22_2
ctrl <= ctrlB when selCtrl = '1' else ctrlA;

-- mux48_1
SEL_PROCESS: process (ctrl,in_1, in_2, sys2Dat,sys3DatExtended)
begin
case ctrl is

when "01" => intDatA <= sys2Dat;
when "11" => intDatA <= in_1;
when "10" => intDatA <= in_2;
when "00" => intDatA <= sys3DatExtended;
when others => null;

end case;    
end process SEL_PROCESS;

-- Assign Outputs
datA      <= intDatA;
intDatB   <= std_logic_vector( unsigned(not intDatA) + 1 ); -- increment
datB      <= intDatB;
datC      <= std_logic_vector( unsigned(intDatA) + unsigned(intDatB) ); -- add

end combinational;