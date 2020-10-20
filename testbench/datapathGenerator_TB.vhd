-- Model name: datapathGenerator_TB  
-- Description: Testbench for combinational logic example datapathGenerator

-- >> Authors: Marvin Dale, Brendan McKeown
-- >> Date: 19/10/2020

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY datapathGenerator_TB IS END datapathGenerator_TB;
 
ARCHITECTURE behavior OF datapathGenerator_TB IS 

COMPONENT datapathGenerator is

Port (   selCtrl     : in  std_logic;
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
end component;

-- >> signal declarations 

signal  selCtrl     : STD_LOGIC;
signal  ctrlA       : STD_LOGIC_VECTOR(1 downto 0);
signal  ctrlB       : STD_LOGIC_VECTOR(1 downto 0);  
signal  sys0Dat     : STD_LOGIC;  
signal  sys1Dat     : STD_LOGIC_VECTOR(2 downto 0);  
signal  sys2Dat     : STD_LOGIC_VECTOR(7 downto 0);
signal  sys3Dat     : STD_LOGIC_VECTOR(3 downto 0);
signal  datA        : STD_LOGIC_VECTOR(7 downto 0);
signal  datB        : STD_LOGIC_VECTOR(7 downto 0);
signal  datC        : STD_LOGIC_VECTOR(7 downto 0);

signal  testNo      : integer; -- test numbers aids locating each simulation waveform test 
signal  endOfSim    : boolean := false; -- assert at end of simulation to show end point
 
BEGIN

uut: datapathGenerator PORT MAP 
( selCtrl => selCtrl,
  ctrlA   => ctrlA ,
  ctrlB   => ctrlB,
  sys0Dat => sys0Dat,
  sys1Dat => sys1Dat,
  sys2Dat => sys2Dat,
  sys3Dat => sys3Dat,
  datA    => datA,
  datB    => datB,
  datC    => datC
);

stim_i: process
 
variable tempVec : std_logic_vector(1 downto 0); 
begin
    report "%N : Simulation start";
    endOfSim <= false;
    
	testNo <= 0; 
    -- >> assign default signals
    selCtrl <= '0';
    ctrlA   <= "00";
    ctrlB   <= "00";
    sys0Dat <= '1';
    sys1Dat <= "110";
    sys2Dat <= "01101110";
    sys3Dat <= "1101";
    wait for 10 ns;  

    testNo <= 1;
        
    wait for 10 ns;
    
    for i in 1 to 3 loop
        tempVec := std_logic_vector(to_unsigned(i,2));
        ctrlA <= tempVec;
        wait for 10ns;
    end loop;
    
    testNo <= 2;

    selCtrl <= '1';
    wait for 10ns;
    
    for i in 1 to 3 loop
        tempVec := std_logic_vector(to_unsigned(i,2));
        ctrlB <= tempVec;
        wait for 10ns;
    end loop;
        
        testNo <= 3;
        ctrlB <= "00";
        sys0Dat <= '0';
        sys1Dat <= "001";
        sys2Dat <= "01011011";
        sys3Dat <= "0010";

    endOfSim <= true;
    report "%N : Simulation end";
	wait;
	
end process;
END behavior;