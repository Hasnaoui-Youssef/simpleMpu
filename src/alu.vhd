library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        alufs : in std_logic_vector(3 downto 0);
        S : out std_logic_vector(15 downto 0)
    );
end entity alu;

architecture rtl of alu is

begin

    process (A, B, alufs)
    begin
        case alufs is
            when X"0" => S <= B;
            when X"1" => S <= std_logic_vector(unsigned(A) - unsigned(B));
            when X"2" => S <= std_logic_vector(unsigned(A) + unsigned(B));
            when X"3" => S <= std_logic_vector(unsigned(B) + 1);
            when others => S <= ( others => '0' );
        end case;
    end process;
end architecture rtl;
