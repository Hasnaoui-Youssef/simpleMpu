library IEEE;
use IEEE.std_logic_1164.all;

entity oe is
    port (
        data_in : in std_logic_vector(15 downto 0);
        en : in std_logic;
        data_out : out std_logic_vector(15 downto 0)
    );
end entity oe;

architecture rtl of oe is

begin

    process(data_in, en)
    begin
        if en = '1' then
            data_out <= data_in;
        else
            data_out <= (others => 'Z');
        end if;
    end process;


end architecture rtl;
