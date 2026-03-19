library ieee;
use ieee.std_logic_1164.all;
entity Decoder_5v32_8bit is
    port(
        i_enable : in std_logic;
        i_input : in std_logic_vector(4 downto 0);
        o_output : out std_logic_vector(7 downto 0)
    );
end entity;

architecture arch of Decoder_5v32_8bit is
begin
    process(i_enable, i_input)
    begin
        if i_enable = '1' then
            case i_input is
                when "00000" => o_output <= "00000001";
                when "00001" => o_output <= "00000010";
                when "00010" => o_output <= "00000100";
                when "00011" => o_output <= "00001000";
                when "00100" => o_output <= "00010000";
                when "00101" => o_output <= "00100000";
                when "00110" => o_output <= "01000000";
                when "00111" => o_output <= "10000000";
                when others => o_output <= (others => '0');
            end case;
        else
            o_output <= (others => '0');
        end if;
    end process;
end arch;
