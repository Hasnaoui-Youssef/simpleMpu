library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity pc is
    Port (
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        pc_ld        : in  STD_LOGIC;
        clk : in std_logic;
        data_out  : out STD_LOGIC_VECTOR(11 downto 0)
    );
end pc;



architecture Behavioral_PC of pc is

    signal data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin

process(pc_ld, data_in)

    begin
        if rising_edge(clk) then
            if pc_ld = '1' then

                data <= data_in;

            end if;
        end if;

    end process;

       data_out <= data(11 downto 0);

end Behavioral_PC;

