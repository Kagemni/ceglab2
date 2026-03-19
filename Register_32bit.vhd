LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Register_32bit IS
	PORT (
	Clk : IN std_logic;
	enable : IN std_logic;
	reset : IN std_logic;
	Data_IN : IN std_logic_vector(31 downto 0);
	Data_out : OUT std_logic_vector(31 downto 0)
	);
END ENTITY;
ARCHITECTURE arch OF Register_32bit IS
	COMPONENT enardFF_2
		PORT (
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC
		);
	END COMPONENT;
	BEGIN

	byteGen:  For i in 0 to 31 GENERATE
		dFF: enardFF_2
			PORT MAP (
				i_resetBar => reset,
				i_d => Data_IN(i),
				i_enable => enable,
				i_clock => Clk,
				o_q => Data_out(i),
				o_qBar => open
			);
	END GENERATE byteGen;


END ARCHITECTURE;
