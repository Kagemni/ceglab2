LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX4v1_32bit IS
    PORT(
        sel : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        a   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- sel="00"
        b   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- sel="01"
        c   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- sel="10"
        d   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- sel="11"
        z   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END MUX4v1_32bit;

ARCHITECTURE structural OF MUX4v1_32bit IS
    SIGNAL sel0_n, sel1_n : STD_LOGIC;
    SIGNAL and_a, and_b, and_c, and_d : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL or_ab, or_cd : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    sel0_n <= NOT sel(0);
    sel1_n <= NOT sel(1);

    GEN_BITS: FOR i IN 0 TO 31 GENERATE
        -- Decoder AND gates
        and_a(i) <= a(i) AND sel0_n AND sel1_n;  -- sel="00"
        and_b(i) <= b(i) AND sel(0)  AND sel1_n;  -- sel="01"
        and_c(i) <= c(i) AND sel0_n AND sel(1);   -- sel="10"
        and_d(i) <= d(i) AND sel(0)  AND sel(1);   -- sel="11"

        -- OR tree
        or_ab(i) <= and_a(i) OR and_b(i);
        or_cd(i) <= and_c(i) OR and_d(i);
        z(i)     <= or_ab(i) OR or_cd(i);
    END GENERATE GEN_BITS;

END structural;