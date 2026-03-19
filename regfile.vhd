LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
ENTITY regfile IS
	PORT(
    clock       : IN  STD_LOGIC;
    reset       : IN  STD_LOGIC;
    read_reg1   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    read_reg2   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    write_reg   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    write_data  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    reg_write   : IN  STD_LOGIC;
    read_data1  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    read_data2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END ENTITY;
ARCHITECTURE arch OF regfile IS
COMPONENT Register_8bit
    PORT (
    Clk : IN std_logic;
    enable : IN std_logic;
    reset : IN std_logic;
    Data_IN : IN std_logic_vector(7 downto 0);
    Data_out : OUT std_logic_vector(7 downto 0)
    );
END COMPONENT;
COMPONENT Decoder_5v32_8bit
    PORT(
        i_enable : in std_logic;
        i_input : in std_logic_vector(4 downto 0);
        o_output : out std_logic_vector(7 downto 0)
    );
END COMPONENT;
SIGNAL enableRow : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL  a, b, c, d, e, f, g, h: std_logic_vector(7 downto 0);
BEGIN


--adress decoder, helps with writing
Decoder: Decoder_5v32_8bit
    PORT MAP (
    i_enable => reg_write,--sends enable signal to decoder, wont enable any if 0
    i_input => write_reg,
    o_output => enableRow
    );

--8 registers of 8 bits bits each
    aReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(0),
        reset => reset,
        Data_IN => write_data,
        Data_out => a
        );
    
    bReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(1),
        reset => reset,
        Data_IN => write_data,
        Data_out => b
        );
    cReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(2),
        reset => reset,
        Data_IN => write_data,
        Data_out => c
        );

    dReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(3),
        reset => reset,
        Data_IN => write_data,
        Data_out => d
        );

    eReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(4),
        reset => reset,
        Data_IN => write_data,
        Data_out => e
        );

    fReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(5),
        reset => reset,
        Data_IN => write_data,
        Data_out => f
        );

    gReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(6),
        reset => reset,
        Data_IN => write_data,
        Data_out => g
        );

   hReg: Register_8bit
        PORT MAP (
        Clk => clock,
        enable => EnableRow(7),
        reset => reset,
        Data_IN => write_data,
        Data_out => h
        );


--Read Data outputs mux
read_data1 <= a when read_reg1 = "00000" else
              b when read_reg1 = "00001" else
              c when read_reg1 = "00010" else
              d when read_reg1 = "00011" else
              e when read_reg1 = "00100" else
              f when read_reg1 = "00101" else
              g when read_reg1 = "00110" else
              h;

read_data2 <= a when read_reg2 = "00000" else
              b when read_reg2 = "00001" else
              c when read_reg2 = "00010" else
              d when read_reg2 = "00011" else
              e when read_reg2 = "00100" else
              f when read_reg2 = "00101" else
              g when read_reg2 = "00110" else
              h; 

END ARCHITECTURE;