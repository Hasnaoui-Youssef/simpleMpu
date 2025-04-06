library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity ir is
    Port (
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        clk : in std_logic;
        ir_ld        : in  STD_LOGIC;
        data_out  : out STD_LOGIC_VECTOR(11 downto 0);
        opcode  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ir;



architecture Behavioral_IR of ir is

    signal data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin

process(clk, ir_ld, data_in)

    begin
        if rising_edge(clk) then
            if ir_ld = '1' then
                data <= data_in;
            end if;
        end if;
    end process;

       opcode <= data(15 downto 12);

       data_out <= data(11 downto 0);

end Behavioral_IR;
