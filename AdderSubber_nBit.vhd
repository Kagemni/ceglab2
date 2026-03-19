LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AdderSubber_nBit IS
    GENERIC (
        N : integer := 8 -- default 8-bit width
    );
    PORT(
        AddSubCtrl  : IN  STD_LOGIC; -- '0' for addition, '1' for subtraction
        x, y        : IN  STD_LOGIC_VECTOR(N-1 downto 0);
        Sum         : OUT STD_LOGIC_VECTOR(N-1 downto 0);
        CarryOut    : OUT STD_LOGIC;
        OverflowOut : OUT STD_LOGIC
    );
END AdderSubber_nBit;

ARCHITECTURE rtl OF AdderSubber_nBit IS
    SIGNAL int_Carry : STD_LOGIC_VECTOR(N downto 0);
    SIGNAL int_Sum   : STD_LOGIC_VECTOR(N-1 downto 0);
	 SIGNAL int_y   : STD_LOGIC_VECTOR(N-1 downto 0);
    COMPONENT oneBitAdder
        PORT(
            i_CarryIn           : IN STD_LOGIC;
            i_Xi, i_Yi          : IN STD_LOGIC;
            o_Sum, o_CarryOut   : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN

    int_Carry(0) <= AddSubCtrl;

    GEN_ADDER: FOR i IN 0 TO N-1 GENERATE
        int_y(i) <= y(i) xor AddSubCtrl;
        gen_OneBitAdders: oneBitAdder
            PORT MAP(
                i_CarryIn   => int_Carry(i),
                i_Xi        => x(i),
                i_Yi        => int_y(i),
                o_Sum       => int_Sum(i),
                o_CarryOut  => int_Carry(i+1)
            );
    END GENERATE GEN_ADDER;

    -- Drive outputs
    Sum      <= int_Sum;
    CarryOut <= int_Carry(N);
	 OverflowOut <= int_Carry(N) xor int_Carry(N-1);
	 
END rtl;
