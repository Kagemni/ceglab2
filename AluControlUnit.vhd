library ieee;
use ieee.std_logic_1164.all;
Entity AluControlUnit is
    Port(
        AluOP : in std_logic_vector(1 downto 0);
        Funct : in std_logic_vector(5 downto 0);
        Operation : out std_logic_vector(2 downto 0)
    );
end AluControlUnit;
architecture arch of AluControlUnit is 

begin --based off of lecture 4 slides 
    operation(2) <= AluOp(0) or ( AluOp(1) and Funct(1));
    operation(1) <= (not AluOp(1))or(not Funct(2));
    operation(0) <= AluOp(1) and (Funct(3) or Funct(0));
    
end architecture;