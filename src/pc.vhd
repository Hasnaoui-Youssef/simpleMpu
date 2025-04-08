library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity pc is
    Port (
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        clk : in std_logic;
        pc_ld        : in  STD_LOGIC;
        pc_inc : in std_logic;
        reset : in std_logic;
        data_out  : out STD_LOGIC_VECTOR(11 downto 0)
    );
end pc;



architecture Behavioral_PC of pc is
    signal counter : unsigned(11 downto 0) := (others => '0');

begin

process(reset, clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            counter <= (others => '0');
        elsif pc_ld = '1' then
                counter <= unsigned(data_in(11 downto 0));
        elsif pc_inc = '1' then
                counter <= counter + 1;
        end if;
    end if;
end process;

       data_out <= std_logic_vector(counter);

end Behavioral_PC;

