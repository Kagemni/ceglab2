LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX2v1_5bit IS
    PORT(
        sel : IN  STD_LOGIC;
        a   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        b   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        z   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END MUX2v1_5bit;

ARCHITECTURE structural OF MUX2v1_5bit IS
    SIGNAL not_sel : STD_LOGIC;
    SIGNAL and_a, and_b : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
    not_sel <= NOT sel;

    GEN_BITS: FOR i IN 0 TO 4 GENERATE
        and_a(i) <= a(i) AND not_sel;
        and_b(i) <= b(i) AND sel;
        z(i)     <= and_a(i) OR and_b(i);
    END GENERATE GEN_BITS;

END structural;