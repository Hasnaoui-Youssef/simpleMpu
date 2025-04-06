library IEEE;
use IEEE.std_logic_1164.all;

entity clk is
    port (
        j : in std_logic;
        k : in std_logic;
        h : in std_logic;
        q : out std_logic;
        qbar : out std_logic
    );
end entity clk;

architecture rtl of clk is
begin
    process (j, k, h)
    begin
        if rising_edge(h) then
            if j = k and j = '1' then
                q <= not q;
                qbar <= not qbar;
            elsif j /= k then
                q <= h;
                qbar <= k;
            end if;
        end if;
    end process;

end architecture rtl;
