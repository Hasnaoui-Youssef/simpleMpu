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
    S <= B when alufs = "0000" else
    std_logic_vector(unsigned(B) + 1) when alufs = "0011" else
    std_logic_vector(unsigned(A) + unsigned(B)) when alufs = "0010" else
    std_logic_vector(unsigned(A) - unsigned(B)) when alufs = "0001" else
    (others => '0');
end architecture rtl;
