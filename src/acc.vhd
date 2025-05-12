library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity acc is
    port (
        data_in : in std_logic_vector(15 downto 0);
        acc_ld : in std_logic;
        clk : in std_logic;
        data_out : out std_logic_vector(15 downto 0);
        accZ : out std_logic;
        acc15 : out std_logic
    );
end entity acc;

architecture accB of acc is
    signal accumulator : std_logic_vector(15 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if acc_ld = '1' then
                accumulator <= data_in;
            end if;
        end if;
    end process;

    data_out <= accumulator;
    accZ <= '1' when accumulator = X"0000" else '0';
    acc15 <= '1' when accumulator >= X"0000" else '0'; -- Optimisation

end architecture accB;
