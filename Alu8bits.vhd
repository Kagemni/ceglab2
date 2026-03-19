library ieee;
use ieee.std_logic_1164.all;
--function == ALU_Sel
--     AND == 000
--      OR == 001
--     add == 010
--     sub == 110
--     slt == 111
entity Alu8bits is
    port (
        A : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        ALU_Sel : in std_logic_vector(2 downto 0);
        Result : out std_logic_vector(7 downto 0);
        Zero, overflow : out std_logic
    );
end Alu8bits;
architecture arch of Alu8bits is

  component AdderSubber_nBit
    generic (
      N : integer := 8
    );
    port (
      AddSubCtrl : in std_logic;
      x, y : in std_logic_vector(N-1 downto 0);
      Sum : out std_logic_vector(N-1 downto 0);
      CarryOut : out std_logic;
      OverflowOut : out std_logic
    );
  end component;
  component SignedComparator_nBit
    generic (
      N : integer := 8
    );
    port (
      a, b : in std_logic_vector(N-1 downto 0);
      o_equal : out std_logic;
      o_greater : out std_logic;
      o_less : out std_logic
    );
  end component;
  component MUX8v1
    port (
      sel : in std_logic_vector(2 downto 0);
      a, b, c, d, e, f, g, h : in std_logic_vector(7 downto 0);
      z : out std_logic_vector(7 downto 0)
    );
  end component;

  signal and_result, or_result, adder_result, slt_ext, mux_out : std_logic_vector(7 downto 0);
  signal slt_result : std_logic;
begin

  
  --- AND ----
genAND: for i in 0 to 7 generate
    and_result(i) <= A(i) and B(i);
  end generate;

  --- OR ----
genOR: for i in 0 to 7 generate
    or_result(i) <= A(i) or B(i);
  end generate;

  --- ADD/SUB ----
  AdderInst: AdderSubber_nBit
    generic map (N => 8)
    port map (
      AddSubCtrl => ALU_Sel(2), -- '0' for addition and '1' for subtraction
      x => A,
      y => B,
      Sum => adder_result,
      CarryOut => open,
      OverflowOut => overflow
    );

  --- SLT ----
  compInst: SignedComparator_nBit
    generic map (N => 8)
    port map (
      a => A,
      b => B,
      o_equal => open,
      o_greater => open,
      o_less => slt_result -- SLT result is '1' if A < B, else '0'
    );
	 slt_ext <= "0000000" & slt_result; --(SLT result, padded to 8 bits with leading zeros)

    --- MUX to select final result based on ALU_Sel ---
    MuxInst: MUX8v1
      port map(
        sel => ALU_Sel,
        a => and_result, --000
        b => or_result,  --001
        c => adder_result, --010
        d => "00000000",
        e => "00000000",
        f => "00000000",
        g => adder_result, --110 (subtraction result)
        h => slt_ext, --111 
        z => mux_out
      );
	
    Zero <= not(mux_out(7) or mux_out(6) or mux_out(5) or mux_out(4) or mux_out(3) or mux_out(2) or mux_out(1) or mux_out(0));
	 Result <= mux_out;
end arch;
  
