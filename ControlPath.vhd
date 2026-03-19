library ieee;
use ieee.std_logic_1164.all;

entity ControlPath is 
    port(
        OpCode   : in std_logic_vector(5 downto 0);
        RegDst   : out std_logic;
        Jump     : out std_logic;
        Branch   : out std_logic;
        MemRead  : out std_logic;
        MemToReg : out std_logic;
        AluOP    : out std_logic_vector(1 downto 0);
        MemWrite : out std_logic;
        AluSrc   : out std_logic;
        RegWrite : out std_logic
    );
end entity;

architecture arch of ControlPath is --based off of lecture 4 slides 
    signal RType, isLW, isSW, isBEQ, isJump : std_logic;
begin
    -- Control signal generation based on OpCode
    RType <= (not OpCode(5)) and (not OpCode(4)) and (not OpCode(3)) and (not OpCode(2)) and (not OpCode(1)) and (not OpCode(0)); --000000
    isLW <=(OpCode(5)) and (not OpCode(4)) and (not OpCode(3)) and (not OpCode(2)) and (OpCode(1)) and (OpCode(0));--100011
    isSW <=(OpCode(5)) and (not OpCode(4)) and (OpCode(3)) and (not OpCode(2)) and (OpCode(1)) and (OpCode(0)); --101011
    isBEQ <=(not OpCode(5)) and (not OpCode(4)) and (not OpCode(3)) and (OpCode(2)) and (not OpCode(1)) and (not OpCode(0));--000100
    isJump <=(not OpCode(5)) and (not OpCode(4)) and (not OpCode(3)) and (not OpCode(2)) and (OpCode(1)) and (not OpCode(0));--000010

    --control signals
    RegDst <= RType;
    AluSrc <= isLW or isSW;
    MemToReg <= isLW;
    RegWrite <= RType or isLW;
    MemRead <= isLW;
    MemWrite <= isSw;
    Branch <= isBEQ;
	 Jump <= isJump;
    AluOP(1) <= RType;
    AluOp(0) <= isBEQ;


     
end architecture;
