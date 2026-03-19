library ieee;
use ieee.std_logic_1164.all;
entity MUX8v1 is
    port (
        sel : in std_logic_vector(2 downto 0);
        a, b, c, d, e, f, g, h : in std_logic_vector(7 downto 0);
        z : out std_logic_vector(7 downto 0)
    );
end MUX8v1;
architecture arch of MUX8v1 is
begin

  z <= a when sel = "000" else
       b when sel = "001" else
       c when sel = "010" else
       d when sel = "011" else
       e when sel = "100" else
       f when sel = "101" else
       g when sel = "110" else
       h; -- default case for sel = "111"
  
end arch;