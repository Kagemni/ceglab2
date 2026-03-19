LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitAdder IS
PORT(
    i_CarryIn           : IN STD_LOGIC;
    i_Xi, i_Yi          : IN STD_LOGIC;
    o_Sum, o_CarryOut   : OUT STD_LOGIC);
END oneBitAdder;

ARCHITECTURE rtl OF oneBitAdder IS
    SIGNAL int_CarryOut1, int_CarryOut2, int_CarryOut3: STD_LOGIC;

    BEGIN
        -- Concurrent Signal Assignment
        int_CarryOut1 <= i_CarryIn xor i_Xi;
        int_CarryOut2 <= int_CarryOut1 and i_Yi;
        int_CarryOut3 <= i_CarryIn and i_Xi;

        -- Output Driver
        o_CarryOut <= int_CarryOut2 or int_CarryOut3;
        o_Sum <= i_CarryIn xor i_Xi xor i_Yi;
 END rtl;