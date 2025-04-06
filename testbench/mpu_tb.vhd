library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mpu_tb is
end entity mpu_tb;

architecture testbench of mpu_tb is
    component mpu is
    port (
        clk : in std_logic;
        reset: in std_logic
    );
    end component;
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    constant clk_period : time := 10 ns;
begin

clk_process : process
begin
    while true loop
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end loop;
end process;

mpu_inst: mpu
 port map(
    clk => clk,
    reset => reset
);

sim_proc : process
begin
    wait for 30 ns;
    reset <= '0';
    wait for 1000 ns;
    assert false report "Simulation" severity failure;
end process;

end architecture testbench;
