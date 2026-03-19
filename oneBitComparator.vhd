LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitComparator IS
    PORT(
        a, b    : IN  STD_LOGIC;
        eq_in   : IN  STD_LOGIC;   -- input from lower bits
        gt_in   : IN  STD_LOGIC;
        lt_in   : IN  STD_LOGIC;
        eq_out  : OUT STD_LOGIC;
        gt_out  : OUT STD_LOGIC;
        lt_out  : OUT STD_LOGIC
    );
END oneBitComparator;

ARCHITECTURE rtl OF oneBitComparator IS
BEGIN
    eq_out <= (eq_in AND (a XNOR b)); --only equal if upper bits are and (Ai and Bi) are different 
    gt_out <= (gt_in OR (eq_in AND (a AND (NOT b)))); --gt if upper bits is gt or if Ai=1 and Bi=0 (1<0)
    lt_out <= (lt_in OR (eq_in AND ((NOT a) AND b))); --lt if upper bits is lt 
END rtl;
