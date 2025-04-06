library IEEE;
use IEEE.std_logic_1164.all;

entity pcIrMux is
    Port (
        A : in STD_LOGIC_VECTOR(11 downto 0); -- pc
        B : in STD_LOGIC_VECTOR(11 downto 0); -- ir
        sel : in STD_LOGIC;
        s : out STD_LOGIC_VECTOR(11 downto 0)
    );
end pcIrMux;

architecture behavioralMux of pcIrMux is

begin
    process(A, B, sel)
    begin
        if sel = '0' then
            s <= A;
        else
            s <= B;
        end if;
    end process;

end architecture behavioralMux;
