LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sl2_32bit IS
    PORT(
        i_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        o_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END sl2_32bit;

ARCHITECTURE structural OF sl2_32bit IS
BEGIN
    -- Shift left by 2: drop 2 MSBs, add 2 zeros at LSB
    o_out <= i_in(29 DOWNTO 0) & '0' & '0';
END structural;