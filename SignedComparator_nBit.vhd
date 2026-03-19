LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SignedComparator_nBit IS
  GENERIC(
    N : INTEGER := 8
  );
    PORT(
        a, b      : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        o_equal   : OUT STD_LOGIC;
        o_greater : OUT STD_LOGIC;
        o_less    : OUT STD_LOGIC
    );
END SignedComparator_nBit;

ARCHITECTURE rtl OF SignedComparator_nBit IS
    SIGNAL eq_s : STD_LOGIC_VECTOR(N DOWNTO 0);
    SIGNAL gt_s : STD_LOGIC_VECTOR(N DOWNTO 0);
    SIGNAL lt_s : STD_LOGIC_VECTOR(N DOWNTO 0);

	 SIGNAL unsigned_greater : STD_LOGIC;
    SIGNAL unsigned_less    : STD_LOGIC;
    SIGNAL signA, signB     : STD_LOGIC;
	 
    COMPONENT oneBitComparator
        PORT(
            a, b    : IN  STD_LOGIC;
            eq_in   : IN  STD_LOGIC;
            gt_in   : IN  STD_LOGIC;
            lt_in   : IN  STD_LOGIC;
            eq_out  : OUT STD_LOGIC;
            gt_out  : OUT STD_LOGIC;
            lt_out  : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN
    -- init signals
    eq_s(N) <= '1';  -- start with equality true
    gt_s(N) <= '0';
    lt_s(N) <= '0';

    --internal bit comparators
    GEN_COMPARATORS: FOR i IN N downto 1 GENERATE
        cmp0: oneBitComparator
            PORT MAP(a => a(i-1), b => b(i-1),
                    eq_in => eq_s(i),
                    gt_in => gt_s(i), 
                    lt_in => lt_s(i),
                    eq_out => eq_s(i-1), 
                    gt_out => gt_s(i-1), 
                    lt_out => lt_s(i-1));
    END GENERATE GEN_COMPARATORS;

    -- unsigned results
    unsigned_greater <= gt_s(0);
    unsigned_less    <= lt_s(0);
    o_equal <= eq_s(0);

    -- capture sign bits (MSB)
    signA <= a(N-1);
    signB <= b(N-1);

    -- SIGNED comparison logic 
    o_less <= (signA AND NOT signB) OR ((signA XNOR signB) AND unsigned_less);
    o_greater <= (NOT signA AND signB) OR ((signA XNOR signB) AND unsigned_greater);

END rtl;
