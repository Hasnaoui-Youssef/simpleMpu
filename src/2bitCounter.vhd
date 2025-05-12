library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TwobitCounter is
    port (
        clk : in std_logic;
        reset : in std_logic;
        state : out std_logic_vector(1 downto 0)
    );
end entity TwobitCounter;

architecture tbca of TwobitCounter is

    signal next_state : std_logic_vector(1 downto 0) := "00";
begin

process(clk, reset)
begin
    if reset = '1' then
        state <= "11";
        next_state <= "00";
    elsif rising_edge(clk) then
        state <= next_state;
    end if;
end process; -- 00 -> 01 -> 10 -> 00

    next_state(0) <= (not state(0) and not state(1));
    next_state(1) <= state(0);


end architecture tbca;
