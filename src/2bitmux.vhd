library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity memValMux is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0); -- bus de donnees
        B : in STD_LOGIC_VECTOR(11 downto 0); -- bus d'addresse
        sel : in STD_LOGIC;
        s : out STD_LOGIC_VECTOR(15 downto 0)
    );
end memValMux;

architecture behavioralMux of memValMux is

begin
    process(A, B, sel)
    begin
        if sel = '0' then
            s <= A;
        else
            s(11 downto 0) <= B;
        end if;
    end process;

end architecture behavioralMux;
