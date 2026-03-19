LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY se16_32 IS
    PORT(
        i_in  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        o_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END se16_32;

ARCHITECTURE structural OF se16_32 IS
    SIGNAL msb : STD_LOGIC;
BEGIN
    -- bit 15 = msb to be replicated
    msb <= i_in(15);

    -- Replicate MSB 16 times for upper bits, keep original for lower 16

    o_out <= msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & msb & i_in;

END structural;