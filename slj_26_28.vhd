LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY slj_26_28 IS
    PORT(
        i_in  : IN  STD_LOGIC_VECTOR(25 DOWNTO 0);
        o_out : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
    );
END slj_26_28;

ARCHITECTURE structural OF slj_26_28 IS
BEGIN
    -- Shift left by 2: add 2 zeros at LSB
    o_out <= i_in & '0' & '0';
END structural;